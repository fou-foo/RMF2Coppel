# Analytics Engine Powered by apache spark Python Demo
import json
#from analytic_engine_client import AnalyticEngineClient
from ibmaemagic import AnalyticsEngineClient
#e.g
CloudPakforData_HOSTNAME = "icpd-zen.cp4dvip.coppel.io"
USER = "antoniog"
PASSWORD = "password"
SPARK_INSTANCE = "spark-instance-py2"
SPARK_INSTANCE_HOME_VOLUME = "spark-instance-py2-vol"
APP_VOLUME_INSTANCE = "app-py2-vol"



# Initializing client
client = AnalyticsEngineClient(host=CloudPakforData_HOSTNAME, uid=USER, pwd=PASSWORD)
#volume instance creation payload
volume_instance_payload = {
	"metadata": {
		"storageClass": "portworx-shared-gp3",
		"storageSize": "20Gi"
	},
	"resources": {},
	"serviceInstanceDescription": "spark-inst1 instance home volume"
}

#Create volume instance
client.create_volume(SPARK_INSTANCE_HOME_VOLUME,create_arguments=volume_instance_payload)

#spark instance creation payload
spark_instance_payload = {    "metadata":{
        "volumeName":"spark-py2-vol",
        "storageClass":"portworx-shared-gp3",
        "storageSize": "20Gi"
    },    "resources": {},
    "serviceInstanceDescription": "spark instance python client demo instance"}

#Create spark instance
client.create_instance(SPARK_INSTANCE, create_arguments=spark_instance_payload)
#Create simple spark job
client.submit_word_count_job(SPARK_INSTANCE)
#Get spark job status
client.get_spark_job_status(SPARK_INSTANCE,job_id='REPLACE_ME_WITH_JOB_ID')


#Get instance resource quota
client.get_instance_resource_quota(SPARK_INSTANCE)


#Update Resource Quota
client.update_instance_resource_quota(SPARK_INSTANCE, cpu_quota=500, memory_quota='2000g')


#Get instance resource quota
client.get_instance_resource_quota(SPARK_INSTANCE)


# Define spark job payload for upload & submit job method.
payload={
    "engine": {
        "type": "spark",
        "template_id": "spark-2.4.0-jaas-v2-cp4d-template",
        "conf": {
            "spark.app.name": "my-spark-job1"
        },
        "size": {
            "num_workers": 5,
            "worker_size": {
                "cpu": 4,
                "memory": "16g"
            },
            "driver_size": {
                "cpu": 5,
                "memory": "20g"
            }
        }
    },
    "application_arguments": [],
    "main_class": "org.apache.spark.deploy.SparkSubmit"
}


#Upload spark job & submit
client.upload_and_submit_job(SPARK_INSTANCE,APP_VOLUME_INSTANCE,'/Users/sunilganatra/testSparkApp.py',params_json=payload)


# NOTE : above initialized payload is updated with volume & application details.
print(json.dumps(payload, indent=2))


# resubmit without reuploading it with updated payload
client.submit_job(SPARK_INSTANCE,params_json=payload)


# If you want to run upload_and_submit_job again reinitialize it with new payload.
payload={
    "engine": {
        "type": "spark",
        "template_id": "spark-2.4.0-jaas-v2-cp4d-template",
        "conf": {
            "spark.app.name": "my-spark-job2"
        }
    },
    "application_arguments": [],
    "main_class": "org.apache.spark.deploy.SparkSubmit"
}

#Upload spark job & submit
client.upload_and_submit_job(SPARK_INSTANCE,APP_VOLUME_INSTANCE,'/Users/sunilganatra/testSparkApp.py',params_json=payload)


#Get all spark jobs of an Instance
client.get_all_jobs(SPARK_INSTANCE)


#Delete spark job
client.delete_spark_job(SPARK_INSTANCE,job_id='REPLACE_ME_WITH_JOB_ID')


#Delete all finished jobs of an instance
client.delete_all_finished_spark_job(SPARK_INSTANCE)


#Delete all jobs of an instance, irrespective of job state
client.delete_all_spark_job(SPARK_INSTANCE)



#Start History Server
client.start_history_server(SPARK_INSTANCE) 


#Get History Server Url
client.get_history_server_ui_end_point(SPARK_INSTANCE)


#Stop History Server
client.stop_history_server(SPARK_INSTANCE)