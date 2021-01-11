# setting my cloud pak for data hostname
CloudPakforData_HOSTNAME="icpd-zen.cp4dvip.coppel.io"

# get token  
curl -ik https://$CloudPakforData_HOSTNAME/v1/preauth/validateAuth \
 -H 'content-type: application/json' -H 'password: password' -H 'username: antoniog'


TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFudG9uaW9nIiwicm9sZSI6IkFkbWluIiwicGVybWlzc2lvbnMiOlsic2lnbl9pbl9vbmx5IiwiYWNjZXNzX2NhdGFsb2ciLCJhZG1pbmlzdHJhdG9yIiwiY2FuX3Byb3Zpc2lvbiIsIm1hbmFnZV9jYXRhbG9nIl0sInN1YiI6ImFudG9uaW9nIiwiaXNzIjoiS05PWFNTTyIsImF1ZCI6IkRTWCIsInVpZCI6IjY1MDExIiwiYXV0aGVudGljYXRvciI6ImRlZmF1bHQiLCJpYXQiOjE2MTAzNzk4MTEsImV4cCI6MTYxMDQyMzAxMX0.dFiWIeMl3uJUNC3lo0M-5Y0YemYeLzTCZD9OZNzOiq1lPP-1CU9kwN2eogSn5v-sSMjTOBDFoEiMvwVJw8P56RqJFv8uKgP3OM_kKnHrKuqpc8_2HjgT5lneIAO1QuOKL-r3xUN-Li5F5K9n2nugUDiziYS4h2ccw3oVUlf0lj4i3mouM0IiCc6Cu3ZVnKKHEaNmEvBe64LS_28MaD0qmMnXCSgJY1HMC3obSNXJ0UyOa7TocsCMCm5GbZEv7vGVG5WZP1yfkkrwtINSgJnt1qUI3dqLqiPrgFz0pIbrq8MzDK9T9pgAhuaaMny9KESChpmklh58iFiqnFZRzlbNqQ"

# Create Volume service instance
curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v2/serviceInstance \
 -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d '{	"createArguments": {
		"metadata": {
			"storageClass": "portworx-shared-gp3",
			"storageSize": "1000Gi"
		},
		"resources": {},
		"serviceInstanceDescription": "app volume"
	},
	"preExistingOwner": false,
	"serviceInstanceDisplayName": "ana-v4",
	"serviceInstanceType": "volumes",
	"serviceInstanceVersion": "-",
	"transientFields": {} }' 

curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v2/serviceInstance \
 -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d '{	"createArguments": {
		"metadata": {
			"storageClass": "portworx-shared-gp3",
			"storageSize": "1000Gi"
		},
		"resources": {},
		"serviceInstanceDescription": "app volume"
	},
	"preExistingOwner": false,
	"serviceInstanceDisplayName": "ana-v-write",
	"serviceInstanceType": "volumes",
	"serviceInstanceVersion": "-",
	"transientFields": {} }' 

# Spark instance creation
curl -ik -X POST -H 'Content-Type: application/json' https://$CloudPakforData_HOSTNAME/zen-data/v2/serviceInstance \
 -H "Authorization: Bearer $TOKEN" -d '{ 	"serviceInstanceType": "spark",
	"serviceInstanceDisplayName": "ana-spark-v4",
	"serviceInstanceNamespace": "icpd-lite",
	"serviceInstanceVersion": "3.0.1",
	"preExistingOwner": false,
	"createArguments": {
		"metadata": {
			"volumeName": "ana-v4",
			"storageClass": "portworx-shared-gp3",
			"storageSize": "1000Gi"
		}
	},
	"parameters": {},
	"serviceInstanceDescription": "my first spark instance",
	"metadata": {},
	"ownerServiceInstanceUsername": "",
	"transientFields": {} }' 


# Get instance details
curl -ks -X GET https://$CloudPakforData_HOSTNAME/zen-data/v2/serviceInstance?type=spark \
 -H 'Content-Type: application/json' -H "Authorization: Bearer $TOKEN" 

# se saca del front-end
JOB_ENDPOINT="https://icpd-zen.cp4dvip.coppel.io/ae/spark/v2/f74397d3527943db90e2afd13a05ea37/v2/jobs"
SPARK_INSTANCE_ID="f74397d3527943db90e2afd13a05ea37"

# Start file server on volume instance
INSTANCE_VOLUME_NAME="ana-spark-v4"

curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v1/volumes/volume_services/$INSTANCE_VOLUME_NAME \
 -H "Authorization: Bearer $TOKEN" -d '{}' -H 'Content-Type: application/json' -H 'cache-control: no-cache'


# Start volume service
VOLUME_INSTANCE_NAME="ana-v4"
VOLUME_INSTANCE_NAME_WRITE="ana-v-write"
curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v1/volumes/volume_services/$VOLUME_INSTANCE_NAME \
 -H "Authorization: Bearer $TOKEN" -d '{}' -H 'Content-Type: application/json' -H 'cache-control: no-cache'

curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v1/volumes/volume_services/$VOLUME_INSTANCE_NAME_WRITE \
 -H "Authorization: Bearer $TOKEN" -d '{}' -H 'Content-Type: application/json' -H 'cache-control: no-cache'


# Upload job in a volume
curl -ik -X PUT https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/files/apps%2Fwritedf1000.py \
 -H "Authorization: Bearer $TOKEN" -H 'cache-control: no-cache' -H 'content-type: multipart/form-data' \
 -F 'upFile=@writedf1000.py'

curl -ik -X PUT https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME_WRITE/v1/volumes/files/apps%2Fwritedf1000.py \
 -H "Authorization: Bearer $TOKEN" -H 'cache-control: no-cache' -H 'content-type: multipart/form-data' \
 -F 'upFile=@writedf1000.py'

# list content in volume 
curl -k -X GET https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME_WRITE/v1/volumes/directories/apps \
 -H "Authorization: Bearer $TOKEN"


# vamos a ver los recursos disponibles 
curl -ik -X GET https://$CloudPakforData_HOSTNAME/ae/spark/v2/$SPARK_INSTANCE_ID \
 -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json"

# ejemplo pequenio 
curl -ik -X POST "$JOB_ENDPOINT" -H "Authorization: Bearer $TOKEN" -d '{ "engine": {
    		"type": "spark"
	},
	"application_arguments": ["/opt/ibm/spark/examples/src/main/resources/people.txt"],
	"application": "/opt/ibm/spark/examples/src/main/python/wordcount.py" } '

# ejemplo shuffle 
curl -ik -X POST "$JOB_ENDPOINT" -H "Authorization: Bearer $TOKEN" -d ' {
	"engine": {
		"type": "spark",
		"env": {
			"SPARK_LOCAL_DIRS": "/home/spark/tmp",
			"PYSPARK_PYTHON": "/opt/ibm/conda/miniconda3.6/bin/python"
		}
	},
	"application_arguments": ["/opt/ibm/spark/examples/src/main/resources/people.txt"],
	"application_jar": "/opt/ibm/spark/examples/src/main/python/wordcount.py",
	"main_class": "org.apache.spark.deploy.SparkSubmit"
} ' 


#######################


# Get instance resource quota
curl -ik -X GET https://$CloudPakforData_HOSTNAME/ae/spark/v2/$SPARK_INSTANCE_ID \
 -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json"

# Change resource quota for an instance
curl -ik -X PUT https://$CloudPakforData_HOSTNAME/ae/spark/v2/$SPARK_INSTANCE_ID/resource_quota \
 -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"cpu_quota":500,"memory_quota":"2000g"}'

#se saca del front-end 
HISTORY_SERVER_ENDPOINT="https://icpd-zen.cp4dvip.coppel.io/ae/spark/v2/f74397d3527943db90e2afd13a05ea37/history-server"
# Start history server
curl -ik -X POST "$HISTORY_SERVER_ENDPOINT" -H "Authorization: Bearer $TOKEN"

# corremos el job 
curl -ik -X POST "$JOB_ENDPOINT" -H "Authorization: Bearer $TOKEN" -d@writedf1000.json









