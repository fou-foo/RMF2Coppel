##  Para facil instale GIT en la maquina windows y ya trae curl en el paquete
# setting my cloud pak for data hostname
CloudPakforData_HOSTNAME="icpd-zen.cp4dvip.coppel.io"

# Get platform Token
curl -k https://$CloudPakforData_HOSTNAME/v1/preauth/validateAuth  \
 -H 'content-type: application/json' -H 'password: cenic1234' -H 'username: cenic'

TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImNlbmljIiwicm9sZSI6IkFkbWluIiwicGVybWlzc2lvbnMiOlsiYWRtaW5pc3RyYXRvciIsImNhbl9wcm92aXNpb24iLCJtYW5hZ2VfY2F0YWxvZyIsImFjY2Vzc19jYXRhbG9nIiwic2lnbl9pbl9vbmx5Il0sInN1YiI6ImNlbmljIiwiaXNzIjoiS05PWFNTTyIsImF1ZCI6IkRTWCIsInVpZCI6IjY1MDIxIiwiYXV0aGVudGljYXRvciI6ImRlZmF1bHQiLCJpYXQiOjE2MDgwNjE4NjcsImV4cCI6MTYwODEwNTA2N30.fUHByVChJ4Dg3Sdgnk0fYPUSSnX8xV5Dlk_3vSBVBDyZGJw2_E2y1yyLPLeRnQUhipQ67RZOwPiHwh9VQRSPghvlorj4LyuxSHIiRyrwPgYmaHyvMcmcYU12kDAR9s9ulXDcfIaapUHQulSOvghb0qlE3yFZx7q0mZDlEAyP53MXPMpdiu4EUCnmmcVFFzjcgw2DjmAmUkfftdLe70LavaV2awrwxg3nQhZBiwJYyfG-HcToO1Ww3_nyR2kz8qkyBVkWXCWPDnUwg0zcdF5vJivaXYdJjo4XAEy6wI49uqTD9sYICbC-W5kuUxJFzeNg32ON8P2KZktsX2GENoy_Xg"

# Volume instance creation payload
## Pase esto a un archivito json porque YOLO para el storageclass me sirvio el blog de estos batos 
## https://sunilganatra.medium.com/python-client-for-analytics-engine-powered-by-apache-spark-service-apis-on-ibm-cloud-pak-for-data-7f71bdf35818
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
 -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d@volume_payload.json 

VOLUME_INSTANCE_NAME="app-vol-foo-ejercicio1"


#volume instance state

# get all volume instance
curl -ks -X GET https://$CloudPakforData_HOSTNAME/zen-data/v2/serviceInstance?type=volumes \
 -H 'Content-Type: application/json' -H "Authorization: Bearer $TOKEN" | jq '.'


# asi aparece en la doc. igual y como solo hay uno no se ve fancy 
curl -ks -X GET https://$CloudPakforData_HOSTNAME/zen-data/v2/serviceInstance?type=volumes \
 -H "Authorization: Bearer $TOKEN" 


# Start file server
curl -ik -X POST https://$CloudPakforData_HOSTNAME/zen-data/v1/volumes/volume_services/$VOLUME_INSTANCE_NAME \
 -H "Authorization: Bearer $TOKEN" -d '{}' -H 'Content-Type: application/json' -H 'cache-control: no-cache'

# Upload a file
#  porque YOLO subimos un archivo cualquiera 
#curl -ik -X PUT https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/files/mypippackages%2FmyCustomPkg.py \
# -H "Authorization: Bearer $TOKEN" -H 'cache-control: no-cache' -H 'content-type: multipart/form-data' \
# -F 'upFile=@myCustomPkg.py'
curl -ik -X PUT https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/files/mypippackages%2Farchivo_dummie.json \
 -H "Authorization: Bearer $TOKEN" -H 'cache-control: no-cache'  \
 -F 'upFile=@volume_payload.json'

# List directories on volume
curl -k -X GET https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/directories/mypippackages \
 -H "Authorization: Bearer $TOKEN"

# PUES NO ME dEJO SUBIR ARCHIVOS PORQUE DICE QUE NO CREE BIEN EL VOLUMEN 
curl -k -X GET https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/directories/ \
 -H "Authorization: Bearer $TOKEN"



# Upload tar.gz file
curl -ik -X PUT https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/files/python%2Fpackages?extract=true \
 -H "Authorization: Bearer $TOKEN" -H 'Content-Type: multipart/form-data' -F upFile='@wget-3.2.zip'

# List directories on volume
curl -ik -X GET https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/directories/python%2Fpackages \
 -H "Authorization: Bearer $TOKEN"

# Download file
curl -k -s -X GET https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/files/mypippackages%2FmyCustomPkg.py \
 -H "Authorization: Bearer $TOKEN" -H 'cache-control: no-cache' -o downloaded-myCustomPkg.py

head -20 downloaded-myCustomPkg.py

# Delete file
curl -ik -X DELETE https://$CloudPakforData_HOSTNAME/zen-volumes/$VOLUME_INSTANCE_NAME/v1/volumes/files/mypippackages%2FmyCustomPkg.py \
 -H "Authorization: Bearer $TOKEN"

# Stop file server

# PUES SI ME DEJO DETENERLO 
curl -ik -X DELETE https://$CloudPakforData_HOSTNAME/zen-data/v1/volumes/volume_services/$VOLUME_INSTANCE_NAME \
 -H "Authorization: Bearer $TOKEN" 





