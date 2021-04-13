# -*- coding: utf-8 -*-
"""
Created on Mon Feb 22 11:37:30 2021

@author: cenic
"""

# Analytics Engine Powered by apache spark Python Demo
import json, time
#from analytic_engine_client import AnalyticEngineClient
from ibmaemagic import AnalyticsEngineClient
#e.g
CloudPakforData_HOSTNAME = "icpd-zen.cp4dvip.coppel.io"
USER = "juancp"
PASSWORD = "password"
SPARK_INSTANCE = "IBMDebug2"

# Initializing client
client = AnalyticsEngineClient(host=CloudPakforData_HOSTNAME, uid=USER, pwd=PASSWORD)
APP_VOLUME_INSTANCE="appvol2jc1"
pathy=r"C:\Users\cenic\Desktop\respaldo_pc_cenic_juanc\respaldoDocumentos\ai_robot_excercises\RMF2Coppel\CP4D_replica_PoC\RegresoConClientePythonEnero2021"
pathy+=r"\writedf.py"

from pathlib import Path
target_file_name = Path(pathy).name
target_directory = "/my-spark-apps/"
app_volume_name = "appvol2jc1"
resp=client.add_file_to_volume(app_volume_name,pathy,target_file_name,target_directory)

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
params_json = write_job_payload    
spark_job_filename=pathy
if "application" not in params_json or "application_jar" not in params_json:
            params_json["application"] = "/{}/{}".format(target_directory.lstrip('/').rstrip('/'),Path(spark_job_filename).name)
            
instance_display_name = SPARK_INSTANCE

import json, time
#from analytic_engine_client import AnalyticEngineClient
from ibmaemagic import AnalyticsEngineClient
#e.g
CloudPakforData_HOSTNAME = "icpd-zen.cp4dvip.coppel.io"
USER = "juancp"
PASSWORD = "password"
SPARK_INSTANCE = "IBMDebug2"


    
SPARK_INSTANCE = "IBMDebug2"
instance_display_name = SPARK_INSTANCE
try:
    job_response = client.submit_job(instance_display_name, params_json=params_json)
except Exception as e:
    print(e)
    
print(job_response)