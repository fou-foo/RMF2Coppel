### Load packages
import time
t0 = time.time()
import pyspark.sql.functions as sql_func
from pyspark.sql.types import *
from pyspark.ml.recommendation import ALS, ALSModel # factorizacion de matrices
from pyspark.context import SparkContext
from pyspark.sql.session import SparkSession
from pyspark.mllib.evaluation import RegressionMetrics, RankingMetrics
from pyspark.ml.evaluation import RegressionEvaluator
import jaydebeapi, pandas as pd

### set up spark session and context
sc = SparkContext.getOrCreate()
spark = SparkSession(sc)

#%%time
# @hidden_cell
# This connection object is used to access your data and contains your credentials.
# You might want to remove those credentials before you share your notebook.

#PARA LEER REGISTROS DE PDA CON ALTO VOLUMEN (Ej.: 300 MILLONES ) USAR SPARK SQL


PDA_Analytics_credentials = {'database': 'SYSTEM', 'password': 'Ukj6fyZU7TFCOLIsZ4vg', 'port': 5480, 'host': '10.44.14.126', 'username': 'analytics'}
from pyspark.sql import SparkSession
sparkSession = SparkSession(spark).builder.getOrCreate()


t1 = time.time()

spark_df=spark.read.format('csv').options(header='true').load('/myapp/temp_data.csv')

spark_df=spark_df.withColumn("ID_CTE", spark_df["ID_CTE"].cast(IntegerType()))
spark_df=spark_df.withColumn("ID_CLAS1", spark_df["ID_CLAS1"].cast(IntegerType()))
spark_df=spark_df.withColumn("FREQUENCY", spark_df["FREQUENCY"].cast(IntegerType()))
print(spark_df.dtypes)

t2 = time.time()
seconds_get_data = t2 - t1
print(str(seconds_get_data / 60 ) + ' Print Cargar csv en dataframe ')


print('Print pre-partition')
print('Print partitions current' + str(spark_df.rdd.getNumPartitions()))
#spark_df=spark_df.repartition(45)
#spark_df.show(5)
#spark_df.rdd.getNumPartitions()
print('Print post partiotion num partitions '+ str(spark_df.rdd.getNumPartitions()))
print('Print post partition ')
ratings = (spark_df
    .select(
        'ID_CTE',
        'ID_CLAS1',
        'FREQUENCY',
    )
).cache()

#ratings = ratings.coalesce(9)

(training, test) = ratings.randomSplit([0.8, 0.2]) #  debemos validar esto


# Note we set cold start strategy to 'drop' to ensure we don't get NaN evaluation metrics
t2 = time.time()
#als = ALS(maxIter=10, regParam=0.01, rank = 100,
als = ALS(maxIter=10, regParam=0.01, rank=100, checkpointInterval=100, numUserBlocks=60, numItemBlocks=60,
          userCol="ID_CTE", itemCol="ID_CLAS1", ratingCol="FREQUENCY",
          coldStartStrategy="drop",
          intermediateStorageLevel='MEMORY_ONLY', finalStorageLevel='MEMORY_ONLY',
          implicitPrefs=True)

model = als.fit(ratings)



# Evaluate the model by computing the RMSE on the test data
predictions = model.transform(test)
evaluator = RegressionEvaluator(metricName="rmse", labelCol="FREQUENCY",
                                predictionCol="prediction")
t3 = time.time()
rmse = evaluator.evaluate(predictions)
print('Print Root-mean-square error = ' + str(rmse))
print('Print Tiempo de entranar y predecir    ' + str( (t3- t2)/60) + '    minutos')

#GENERATE TOP K ITEM RECOMMENDATIONS FOR EACH USER
print('Print Generating Top k ITEM Recommendations for each user...')
userRecs = model.recommendForAllUsers(10)
from pyspark.sql.functions import explode
userRecs1=userRecs.withColumn("recommendations", explode(userRecs.recommendations))
userRecs1= userRecs1 \
  .select('ID_CTE', 'recommendations.*')

print('Print Start writing recommendations to Database...')
t4 = time.time()

new_table_name = 'RECOMMENDATIONSRESULT_TEST_CENIC_1000_02-02-2021_1'
userRecs1.coalesce(10).write.format('jdbc') \
    .mode('overwrite') \
    .option('url', 'jdbc:netezza://{}:{}/{}'.format(PDA_Analytics_credentials['host'],PDA_Analytics_credentials['port'],'CENIC')) \
    .option('dbtable', new_table_name) \
    .option('numPartitions', 33) \
    .option('batchsize', 1000000) \
    .option('user', PDA_Analytics_credentials['username']).option('driver','org.netezza.Driver').option('password', PDA_Analytics_credentials['password']).save()

t5 = time.time()
print('Print Saving data recommendations into Database completed... Saving Data duration time= '+ str((t5-t4)/60) + ' minutes')
