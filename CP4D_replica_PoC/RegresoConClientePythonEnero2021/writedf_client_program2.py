# Analytics Engine Powered by apache spark Python Demo
import json, time
#from analytic_engine_client import AnalyticEngineClient
from ibmaemagic import AnalyticsEngineClient
#e.g
CloudPakforData_HOSTNAME = "icpd-zen.cp4dvip.coppel.io"
USER = "juancp"
PASSWORD = "password"
SPARK_INSTANCE = "JCPRUEBA"

# Initializing client
client = AnalyticsEngineClient(host=CloudPakforData_HOSTNAME, uid=USER, pwd=PASSWORD)


#Spark job payload for writing data
write_job_payload={
	"engine": {
		"type": "spark",
		"conf": {
			"spark.executor.extraClassPath": "/myapp/*",
			"spark.network.timeout": "10000s",
			"spark.executor.heartbeatInterval": "500s",
			"spark.driver.extraClassPath": "/myapp/*"
		},
		"volumes": [{
			"volume_name": "appvol2jc1",
			"source_path": "myapp",
			"mount_path": "/myapp"
		}],
		"env": {
			"SPARK_LOCAL_DIRS": "/home/spark/tmp",
			"PYSPARK_PYTHON": "/opt/ibm/conda/miniconda3.6/bin/python",
			"PYTHONPATH": "/myapp/pippackages:/home/spark/shared/user-libs/python3.6:/home/spark/shared/conda/envs/python3.6/lib/python3.6/site-packages:/opt/ibm/conda/miniconda3.6/lib/python3.6/site-packages:/opt/ibm/third-party/libs/python3:/opt/ibm/image-libs/python3.6:/opt/ibm/image-libs/spark2/metaindexmanager.jar:/opt/ibm/image-libs/spark2/stmetaindexplugin.jar:/opt/ibm/spark/python:/opt/ibm/spark/python/lib/py4j-0.10.7-src.zip"
		},
		"size": {
			"num_workers": 2,
			"worker_size": {
				"cpu": 2,
				"memory": "20g"
			},
			"driver_size": {
				"cpu": 2,
				"memory": "20g"
			}
		}
	},
	"application_arguments": [],
	"main_class": "org.apache.spark.deploy.SparkSubmit"
}

print("==========================================================================")
print("Job payload : {}".format(write_job_payload))



print("==========================================================================")
#job_submit_response = client.submit_job(SPARK_INSTANCE,params_json=write_job_payload)
APP_VOLUME_INSTANCE="appvol2jc1"
client.upload_and_submit_job(SPARK_INSTANCE,APP_VOLUME_INSTANCE,pathy,params_json=write_job_payload)
#client.upload_and_submit_job(SPARK_INSTANCE,APP_VOLUME_INSTANCE,'C:\coppel\writedf.py',params_json=write_job_payload)
client.upload_and_submit_job(SPARK_INSTANCE,APP_VOLUME_INSTANCE,
                            
                             'C:\\Users\\cenic\\Desktop\\respaldo_pc_cenic_juanc\\respaldoDocumentos\\ai_robot_excercises\\RMF2Coppel\\CP4D_replicaPoC\\RegresoConClientePythonEnero2021\\writedf.py',params_json=write_job_payload)
y = client.upload_and_submit_job(SPARK_INSTANCE,APP_VOLUME_INSTANCE,pathy,params_json=write_job_payload)