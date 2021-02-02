# setting my cloud pak for data hostname
# esta valiendo madres con nuestro user vamos a intentar con el sudo su 
CloudPakforData_HOSTNAME="icpd-zen.cp4dvip.coppel.io"

# Get platform Token NO JALO 
curl -ik https://$CloudPakforData_HOSTNAME/v1/preauth/validateAuth \
 -H 'content-type: application/json' -H 'password: cenic1234' -H 'username: cenic'


# rICHIE CORRIO LOS EJERCICIOS CON MI USSER ! 
curl -ik https://$CloudPakforData_HOSTNAME/v1/preauth/validateAuth \
 -H 'content-type: application/json' -H 'password: password' -H 'username: antoniog'


TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFudG9uaW9nIiwicm9sZSI6IkFkbWluIiwicGVybWlzc2lvbnMiOlsiYWRtaW5pc3RyYXRvciIsImNhbl9wcm92aXNpb24iLCJtYW5hZ2VfY2F0YWxvZyIsImFjY2Vzc19jYXRhbG9nIiwic2lnbl9pbl9vbmx5Il0sInN1YiI6ImFudG9uaW9nIiwiaXNzIjoiS05PWFNTTyIsImF1ZCI6IkRTWCIsInVpZCI6IjY1MDExIiwiYXV0aGVudGljYXRvciI6ImRlZmF1bHQiLCJpYXQiOjE2MDgxNDM5NTcsImV4cCI6MTYwODE4NzE1N30.jaVO72OG86qYYwEkBv8B4-iLvrU1WzS7HbyvtVvdl_5SIfdigQdWqvqjOjm1-qbwxAfV3UcebbM62_O7IPgyYQuh5oGOflTmBKA5fzHGwg2NvRWypwHLMgPD66mIMMEtt4vZIvhO9EUuuv6G0ZNuwadvtQ-C0bzGElForVUGY05uvkcmV7CD4qD3h1gOwCSj0OsZGa-eEyxeOoJ8M6J7QpbzYyeXWB1tOMdu8UcPHL9LudQkoF3uMvYCdfKZR0Pxb2o7nNh1lw1Q8CuaZCfwhpcShLWN4wFo5pC3-HOm2x1p4XTcw8lyNAUHMRlYsGzUfbBMTiSCq-msGVD1FI7KBg"

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
	"serviceInstanceDisplayName": "foo-v3",
	"serviceInstanceType": "volumes",
	"serviceInstanceVersion": "-",
	"transientFields": {} }' 


# Spark instance creation
curl -ik -X POST -H 'Content-Type: application/json' https://$CloudPakforData_HOSTNAME/zen-data/v2/serviceInstance \
 -H "Authorization: Bearer $TOKEN" -d '{ 	"serviceInstanceType": "spark",
	"serviceInstanceDisplayName": "foo-spark-v3",
	"serviceInstanceNamespace": "icpd-lite",
	"serviceInstanceVersion": "3.0.1",
	"preExistingOwner": false,
	"createArguments": {
		"metadata": {
			"volumeName": "foo-v3",
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
JOB_ENDPOINT="https://icpd-zen.cp4dvip.coppel.io/ae/spark/v2/0c8a52d8934d49c7a2adde133d310f25/v2/jobs"
SPARK_INSTANCE_ID="0c8a52d8934d49c7a2adde133d310f25"

# Start file server on volume instance
INSTANCE_VOLUME_NAME="foo-spark-v3"

curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v1/volumes/volume_services/$INSTANCE_VOLUME_NAME \
 -H "Authorization: Bearer $TOKEN" -d '{}' -H 'Content-Type: application/json' -H 'cache-control: no-cache'


# Start volume service
VOLUME_INSTANCE_NAME="foo-v3"
curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v1/volumes/volume_services/$VOLUME_INSTANCE_NAME \
 -H "Authorization: Bearer $TOKEN" -d '{}' -H 'Content-Type: application/json' -H 'cache-control: no-cache'


 
# Upload job in a volume
curl -ik -X PUT https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/files/apps%2Fwritedf.py \
 -H "Authorization: Bearer $TOKEN" -H 'cache-control: no-cache' -H 'content-type: multipart/form-data' \
 -F 'upFile=@writedf.py'

# Como la regue vamos a ver que y que subi 
curl -k -X GET https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/directories/apps \
 -H "Authorization: Bearer $TOKEN"

# vamos a ver los recursos disponibles 
curl -ik -X GET https://$CloudPakforData_HOSTNAME/ae/spark/v2/$SPARK_INSTANCE_ID \
 -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json"


# Submit spark job, LA LECTURA ESTO DEBERIA SER RAPIDO 
curl -ik -X POST "$JOB_ENDPOINT" -H "Authorization: Bearer $TOKEN" -d '{ "engine": {
    "type": "spark",
    "conf": {
      "spark.executor.extraClassPath":"/myapp/*",
      "spark.network.timeout":"10000s",
      "spark.executor.heartbeatInterval":"500s",
      "spark.driver.extraClassPath":"/myapp/*"
    }, "volumes": [{ "volume_name": "foo-v3", "source_path": "myapp", "mount_path": "/myapp" }],
"env": {   "SPARK_LOCAL_DIRS": "/home/spark/tmp",
            "PYSPARK_PYTHON": "/opt/ibm/conda/miniconda3.6/bin/python",
            "PYTHONPATH": "/myapp/pippackages:/home/spark/shared/user-libs/python3.6:/home/spark/shared/conda/envs/python3.6/lib/python3.6/site-packages:/opt/ibm/conda/miniconda3.6/lib/python3.6/site-packages:/
opt/ibm/third-party/libs/python3:/opt/ibm/image-libs/python3.6:/opt/ibm/image-libs/spark2/metaindexmanager.jar:/opt/ibm/image-libs/spark2/stmetaindexplugin.jar:/opt/ibm/spark/python:/opt/ibm/spark/python/lib/py4
j-0.10.7-src.zip"
                },
"size": {
          "num_workers": 9,
          "worker_size": {
              "cpu": 6,
              "memory": "54g"
          },
          "driver_size": {
              "cpu": 5,
              "memory": "20g"
          }
      }
        },
        "application_arguments": [],
        "application_jar": "/home/spark/user_home/writedf.py",
        "main_class": "org.apache.spark.deploy.SparkSubmit" }' 
# ejemplo peqenio 
curl -ik -X POST "$JOB_ENDPOINT" -H "Authorization: Bearer $TOKEN" -d '{ "engine": {
    		"type": "spark"
	},
	"application_arguments": ["/opt/ibm/spark/examples/src/main/resources/people.txt"],
	"application": "/opt/ibm/spark/examples/src/main/python/wordcount.py" } '

########3################
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

# Get the state of job
curl -ik -X GET "$JOB_ENDPOINT/$JOB_ID" -H "Authorization: Bearer $TOKEN"


# Get instance resource quota
curl -ik -X GET https://$CloudPakforData_HOSTNAME/ae/spark/v2/$SPARK_INSTANCE_ID \
 -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json"



# Change resource quota for an instance
curl -ik -X PUT https://$CloudPakforData_HOSTNAME/ae/spark/v2/$SPARK_INSTANCE_ID/resource_quota \
 -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"cpu_quota":500,"memory_quota":"2000g"}'


#se saca del front-end 
HISTORY_SERVER_ENDPOINT="https://icpd-zen.cp4dvip.coppel.io/ae/spark/v2/0c8a52d8934d49c7a2adde133d310f25/history-server"
# Start history server
curl -ik -X POST "$HISTORY_SERVER_ENDPOINT" -H "Authorization: Bearer $TOKEN"

# corremos el job 
 curl -ik -X POST "$JOB_ENDPOINT" -H "Authorization: Bearer $TOKEN" -d@writedf2.json



# Upload job in a volume
curl -ik -X PUT https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/files/apps%2Fwritedf.py \
 -H "Authorization: Bearer $TOKEN" -H 'cache-control: no-cache' -H 'content-type: multipart/form-data' \
 -F 'upFile=@writedf.py'














