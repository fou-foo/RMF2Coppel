# setting my cloud pak for data hostname 
CloudPakforData_HOSTNAME="icpd-zen.cp4dvip.coppel.io"


# get token  
curl -ik https://$CloudPakforData_HOSTNAME/v1/preauth/validateAuth \
 -H 'content-type: application/json' -H 'password: password' -H 'username: antoniog'

# refresh it 
TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFudG9uaW9nIiwicm9sZSI6IkFkbWluIiwicGVybWlzc2lvbnMiOlsic2lnbl9pbl9vbmx5IiwiYWNjZXNzX2NhdGFsb2ciLCJhZG1pbmlzdHJhdG9yIiwiY2FuX3Byb3Zpc2lvbiIsIm1hbmFnZV9jYXRhbG9nIl0sInN1YiI6ImFudG9uaW9nIiwiaXNzIjoiS05PWFNTTyIsImF1ZCI6IkRTWCIsInVpZCI6IjY1MDExIiwiYXV0aGVudGljYXRvciI6ImRlZmF1bHQiLCJpYXQiOjE2MTAxNjkzMDQsImV4cCI6MTYxMDIxMjUwNH0.E1-XXclxdA5u8QgGn5sDgp-TvEk3Uxph8v9eh2cSHsxU4AHduVbH6Kg0AypScQKckZWdnB9RY443sQz3lMd2VzobCsXOE1dnvCmXgIxZn81_izoBXHwbVeT3BCw6583sdfqcD-pjUy8a9lNAlW7vgfklZY0Oi53eux9Ehy7Ruj29CewEXhRTJdrXEW6b-nB4LGNMdmCJqtMifNFyZ-iXV9mlK8j-rkgafYpGNDGJ7ZpMIfPzsQ0JKcI9248S6GMTjak5nmhNIfo2BxvZd2y8iIkJKq4fsLOSXJuiE5nqoMb6M2uErW3e7piKoEOjPvdnOGJgK_FLYBCN3HXE9kYYzw"


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
	"serviceInstanceDisplayName": "default11",
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
	"serviceInstanceDisplayName": "spark-vol-rmf2-11",
	"serviceInstanceType": "volumes",
	"serviceInstanceVersion": "-",
	"transientFields": {} }' 



# Spark instance creation
curl -ik -X POST -H 'Content-Type: application/json' https://$CloudPakforData_HOSTNAME/zen-data/v2/serviceInstance \
 -H "Authorization: Bearer $TOKEN" -d '{ 	"serviceInstanceType": "spark",
	"serviceInstanceDisplayName": "spark-instance-rmf2-11",
	"serviceInstanceNamespace": "icpd-lite",
	"serviceInstanceVersion": "3.0.1",
	"preExistingOwner": false,
	"createArguments": {
		"metadata": {
			"volumeName": "default11",
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
JOB_ENDPOINT="https://icpd-zen.cp4dvip.coppel.io/ae/spark/v2/14ea6cd84e1d4afba1b68fac6c887ecf/v2/jobs"
SPARK_INSTANCE_ID="14ea6cd84e1d4afba1b68fac6c887ecf"


# Start volume service
VOLUME_INSTANCE_NAME="foo-instance-rmf2-11"

curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v1/volumes/volume_services/$VOLUME_INSTANCE_NAME \
 -H "Authorization: Bearer $TOKEN" -d '{}' -H 'Content-Type: application/json' -H 'cache-control: no-cache'


VOLUME_NAME="spark-vol-rmf2-11"

curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v1/volumes/volume_services/$VOLUME_NAME \
 -H "Authorization: Bearer $TOKEN" -d '{}' -H 'Content-Type: application/json' -H 'cache-control: no-cache'

curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v1/volumes/volume_services/$VOLUME_NAME \
 -H "Authorization: Bearer $TOKEN" -d '{}' -H 'Content-Type: application/json' -H 'cache-control: no-cache'

# Upload job in a volume
curl -ik -X PUT https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/files/apps%2Fwritedf1000.py \
 -H "Authorization: Bearer $TOKEN" -H 'cache-control: no-cache' -H 'content-type: multipart/form-data' \
 -F 'upFile=@writedf1000.py'

# vamos a ver los recursos disponibles 
curl -ik -X GET https://$CloudPakforData_HOSTNAME/ae/spark/v2/$SPARK_INSTANCE_ID \
 -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json"


# ejemplo pequenio 
curl -ik -X POST "$JOB_ENDPOINT" -H "Authorization: Bearer $TOKEN" -d '{ "engine": {
    		"type": "spark"
	},
	"application_arguments": ["/opt/ibm/spark/examples/src/main/resources/people.txt"],
	"application": "/opt/ibm/spark/examples/src/main/python/wordcount.py" } '

########################
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
HISTORY_SERVER_ENDPOINT="https://icpd-zen.cp4dvip.coppel.io/ae/spark/v2/62ae2741e9de4c45b34948d72f516af6/history-server"
# Start history server
curl -ik -X POST "$HISTORY_SERVER_ENDPOINT" -H "Authorization: Bearer $TOKEN"

# corremos el job 
 curl -ik -X POST "$JOB_ENDPOINT" -H "Authorization: Bearer $TOKEN" -d@writedf2.json



# Upload job in a volume
curl -ik -X PUT https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/files/apps%2Fwritedf.py \
 -H "Authorization: Bearer $TOKEN" -H 'cache-control: no-cache' -H 'content-type: multipart/form-data' \
 -F 'upFile=@writedf.py'














