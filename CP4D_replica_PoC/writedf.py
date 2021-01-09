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

#from project_lib import Project
#project = Project.access()
#PDA_Analytics_credentials = project.get_connection(name="PDA_Analytics")

PDA_Analytics_credentials = {'database': 'SYSTEM', 'password': 'Ukj6fyZU7TFCOLIsZ4vg', 'port': 5480, 'host': '10.44.14.126', 'username': 'analytics'}
from pyspark.sql import SparkSession
sparkSession = SparkSession(spark).builder.getOrCreate()

query = '''
SELECT CLIENTECODIGO as ID_CTE, CAST( ADCLAFAM as integer) as ID_CLAS1,
                FRECUENCIA as FREQUENCY
        FROM(   SELECT *, TRIM(TO_CHAR(FAMILIA,'000')) AS FAM, TRIM(TO_CHAR(CLASE,'00')) AS CLAS,
                          TRIM(TO_CHAR(AREA,'0')) AS AREA, (AREA||DEPARTAMENTO||CLAS||FAM) AS ADCLAFAM
                                FROM(    SELECT  CLIENTECODIGO, CLASE, FAMILIA, DEPARTAMENTO,
                                                 SUM(CASE WHEN CLASE>'0' THEN 1 ELSE 0 END) AS FRECUENCIA,
                                                 MAX(CASE WHEN CARTERA='Ropa' THEN 1
                                                                          WHEN CARTERA='Muebles' THEN 2
                                                                                  WHEN CARTERA='Prestamos' THEN 3 ELSE 0 END) AS AREA
                                                        FROM( SELECT *, CASE WHEN CLASE>'0' THEN 1 ELSE 0 END AS T_CLASE,
                                                                       CASE WHEN FAMILIA>'0' THEN 1 ELSE 0 END AS T_FAMILIA
                                                                        FROM DIRECCIONRIESGOS.ADMIN.TRANSACCIONESCARTERAS
                                                                        where FECHACORTE between '2017-01-31' and '2019-12-31'
                                                                        and CLIENTECODIGO not in (9001,9000) AND CLIENTECODIGO >10000) E
                                GROUP BY CLIENTECODIGO, CLASE, FAMILIA, DEPARTAMENTO
                                ORDER BY CLIENTECODIGO) T
        WHERE CLASE NOT IN (-99)) P
        ORDER BY CLIENTECODIGO,ADCLAFAM
        
'''

dbTableOrQuery = "(" + query + ") TBL"

t1 = time.time()

spark_df = sparkSession.read.format('jdbc') \
    .option('url', 'jdbc:netezza://{}:{}/{}'.format(PDA_Analytics_credentials['host'],PDA_Analytics_credentials['port'],PDA_Analytics_credentials['database'])) \
    .option('dbtable', dbTableOrQuery) \
    .option("numPartitions", 60) \
    .option('user', PDA_Analytics_credentials['username']) \
    .option('password', PDA_Analytics_credentials['password']) \
    .option("lowerBound", 1) \
    .option("upperBound", 1000000) \
    .option("partitionColumn", "ID_CTE").load()


#spark_df = spark_df.repartition(60)
#spark_df.show(5)
spark_df.write.format("csv").option("header", "true").save("/myapp/temp_data.csv")
