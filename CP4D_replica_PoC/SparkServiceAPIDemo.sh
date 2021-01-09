# setting my cloud pak for data hostname
CloudPakforData_HOSTNAME="icpd-zen.cp4dvip.coppel.io"

# Get platform Token
curl -ik https://$CloudPakforData_HOSTNAME/v1/preauth/validateAuth \
 -H 'content-type: application/json' -H 'password: password' -H 'username: admin'
# YOLO 
curl -ik https://$CloudPakforData_HOSTNAME/v1/preauth/validateAuth \
 -H 'content-type: application/json' -H 'password: cenic1234' -H 'username: cenic'


TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImNlbmljIiwicm9sZSI6IkFkbWluIiwicGVybWlzc2lvbnMiOlsiYWRtaW5pc3RyYXRvciIsImNhbl9wcm92aXNpb24iLCJtYW5hZ2VfY2F0YWxvZyIsImFjY2Vzc19jYXRhbG9nIiwic2lnbl9pbl9vbmx5Il0sInN1YiI6ImNlbmljIiwiaXNzIjoiS05PWFNTTyIsImF1ZCI6IkRTWCIsInVpZCI6IjY1MDIxIiwiYXV0aGVudGljYXRvciI6ImRlZmF1bHQiLCJpYXQiOjE2MDgwOTA5NDQsImV4cCI6MTYwODEzNDE0NH0.Zc-KKUiYkEPQqoHrI55JG4THjUbo5Quz1-nsJNTHmv32VwZ9e3NB2adlROfgMX1dmBGCLo0YRZf2wKynoe4g8enNElLFVsEW_O7jNy9gSqmnZ6z8KIIIDG0gWTfGmyBg3UpJUyx4xBmtGY9JKsPVjoKkDmvm-THCKxSjg2XvFcPtpZEgUkSDT8NytChHPBZ-QMNsXBpSRrCWJv6xikHq8xYVs_DZh1vhcdUWOHnci7sAKMs_RjaqLB3Zj03rNuqS0eC00QRUYdB4kmWxqgt_PDi-AuXk0fEU6taUGjulCxrwjZWWxyFyNU0k5NNcgyl7UtDY-Lah-ZP2Ui5Wz6NkuQ"

# Volume instance creation payload
{
	"createArguments": {
		"metadata": {
			"storageClass": "<StorageClass>",
			"storageSize": "5Gi"
		},
		"resources": {},
		"serviceInstanceDescription": "app volume"
	},
	"preExistingOwner": false,
	"serviceInstanceDisplayName": "<VOLUME_INSTANCE_NAME>",
	"serviceInstanceType": "volumes",
	"serviceInstanceVersion": "-",
	"transientFields": {}
} 

# Create Volume service instance
curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v2/serviceInstance \
 -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d@spark-instance-volume.json


# Spark instance payload
{
	"serviceInstanceType": "spark",
	"serviceInstanceDisplayName": "<SPARK_INSTANCE_NAME>",
	"serviceInstanceNamespace": "icpd-lite",
	"serviceInstanceVersion": "3.0.1",
	"preExistingOwner": false,
	"createArguments": {
		"metadata": {
			"volumeName": "<VOLUME_NAME>",
			"storageClass": "",
			"storageSize": ""
		}
	},
	"parameters": {},
	"serviceInstanceDescription": "my first spark instance",
	"metadata": {},
	"ownerServiceInstanceUsername": "",
	"transientFields": {}
}


# Spark instance creation
curl -ik -X POST -H 'Content-Type: application/json' https://$CloudPakforData_HOSTNAME/zen-data/v2/serviceInstance \
 -H "Authorization: Bearer $TOKEN" -d@spark-instance-creation.json

#NO JALO  Get instance details
curl -ks -X GET https://$CloudPakforData_HOSTNAME/zen-data/v2/serviceInstance?type=spark \
 -H 'Content-Type: application/json' -H "Authorization: Bearer $TOKEN" | jq '.'

# 
curl -ks -X GET https://$CloudPakforData_HOSTNAME/zen-data/v2/serviceInstance?type=spark \
 -H 'Content-Type: application/json' -H "Authorization: Bearer $TOKEN" 

JOB_ENDPOINT="https://icpd-zen.cp4dvip.coppel.io/ae/spark/v2/755d600ecf594f78a8a945747d788aa0/v2/jobs"
SPARK_INSTANCE_ID="spark-test1"

# simple spark job payload
{
	"engine": {
		"type": "spark"
	},
	"application_arguments": ["/opt/ibm/spark/examples/src/main/resources/people.txt"],
	"application": "/opt/ibm/spark/examples/src/main/python/wordcount.py"
}

# Submit simple spark job
curl -ik -X POST "$JOB_ENDPOINT" -H "Authorization: Bearer $TOKEN" -d@wordcount_job_payload.json

JOB_ID=""

# Get the state of job
curl -ik -X GET "$JOB_ENDPOINT/$JOB_ID" -H "Authorization: Bearer $TOKEN"

# Download Job logs

# Start file server on volume instance
INSTANCE_VOLUME_NAME="spark-inst2-vol"

curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v1/volumes/volume_services/$INSTANCE_VOLUME_NAME \
 -H "Authorization: Bearer $TOKEN" -d '{}' -H 'Content-Type: application/json' -H 'cache-control: no-cache'

# Spark drive log file format
$SPARK_INSTANCE_ID%2F$JOB_ID%2Flogs%2Fspark-driver-$JOB_ID-stdout

#Download driver log
curl -k -X GET \
 https://$CloudPakforData_HOSTNAME/zen-volumes/$INSTANCE_VOLUME_NAME/v1/volumes/files/$SPARK_INSTANCE_ID%2F$JOB_ID%2Flogs%2Fspark-driver-$JOB_ID-stdout \
  -H "Authorization: Bearer $TOKEN" -H 'cache-control: no-cache' -o spark-driver-$JOB_ID-stdout 

# Run large scale Job

# Start volume service
VOLUME_INSTANCE_NAME="app-vol"
curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v1/volumes/volume_services/$VOLUME_INSTANCE_NAME \
 -H "Authorization: Bearer $TOKEN" -d '{}' -H 'Content-Type: application/json' -H 'cache-control: no-cache'

# Upload job in a volume
curl -ik -X PUT https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/files/apps%2FtestSparkApp.py \
 -H "Authorization: Bearer $TOKEN" -H 'cache-control: no-cache' -H 'content-type: multipart/form-data' \
 -F 'upFile=@testSparkApp.py'

# Large scale spark app job payload
# Understanding spark job API payload
{
	"engine": {
		"type": "spark",
		"template_id": "spark-2.4.0-jaas-v2-cp4d-template",
		"conf": {
			"spark.app.name": "myTestSparkApp-with-largeEnv"
		},
		"env":{
			"SAMPLE_ENV_VAR": "my-env-var-vaule"
		}
		"size": {
			"num_workers": 15,
			"worker_size": {
				"cpu": 4,
				"memory": "20g"
			},
			"driver_size": {
				"cpu": 5,
				"memory": "20g"
			}
		},
		"volumes": [{
			"volume_name": "app-vol",
			"source_path": "apps",
			"mount_path": "/myapp"
		}]
	},
	"application_arguments": [],
	"application": "/myapp/testSparkApp.py",
	"main_class": "org.apache.spark.deploy.SparkSubmit"
}

{
	"engine": {
		"type": "spark",
		"template_id": "spark-2.4.0-jaas-v2-cp4d-template",
	},
	"application_arguments": [],
	"application": "/home/spark/user_home/testSparkApp.py",
	"main_class": "org.apache.spark.deploy.SparkSubmit"
}


# Submit spark job
curl -ik -X POST "$JOB_ENDPOINT" -H "Authorization: Bearer $TOKEN" -d@writedf2.json




curl -ik -X POST "$JOB_ENDPOINT" -H "Authorization: Bearer $TOKEN" -d@large_scale_spark_job.json




# Resource Quota

# Get instance resource quota
curl -ik -X GET https://$CloudPakforData_HOSTNAME/ae/spark/v2/$SPARK_INSTANCE_ID \
 -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json"

# Change resource quota for an instance
curl -ik -X PUT https://$CloudPakforData_HOSTNAME/ae/spark/v2/$SPARK_INSTANCE_ID/resource_quota \
 -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"cpu_quota":500,"memory_quota":"2000g"}'

# Get instance resource quota
curl -ik -X GET https://$CloudPakforData_HOSTNAME/ae/spark/v2/$SPARK_INSTANCE_ID \
 -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json"


# ReSubmit spark job
curl -ik -X POST "$JOB_ENDPOINT" -H "Authorization: Bearer $TOKEN" -d@large_scale_spark_job.json


# Get all spark jobs of an instance
curl -ik -X GET "$JOB_ENDPOINT" -H "Authorization: Bearer $TOKEN"

# Delete spark job
curl -ik -X DELETE "$JOB_ENDPOINT/<JOB_ID>" -H "Authorization: Bearer $TOKEN"



# History Server

# Get instance details
curl -ks -X GET https://$CloudPakforData_HOSTNAME/zen-data/v2/serviceInstance?type=spark \
 -H 'Content-Type: application/json' -H "Authorization: Bearer $TOKEN" | jq '.'

HISTORY_SERVER_ENDPOINT=""

# Start history server
curl -ik -X POST "$HISTORY_SERVER_ENDPOINT" -H "Authorization: Bearer $TOKEN"

# View History server

# Stop history server
curl -ik -X DELETE "$HISTORY_SERVER_ENDPOINT" -H "Authorization: Bearer $TOKEN"


