# -*- coding: utf-8 -*-
"""
Created on Tue Feb 16 13:31:25 2021

@author: cenic
"""

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