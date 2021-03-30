# Analytics Engine Powered by apache spark Python Demo
import json, time
# instalar el cliente pip install ibmaemagic
# python -3 -m pip install ibmaemagic
# checar https://sunilganatra.medium.com/python-client-for-analytics-engine-powered-by-apache-spark-service-apis-on-ibm-cloud-pak-for-data-7f71bdf35818
#from analytic_engine_client import AnalyticEngineClient
from ibmaemagic import AnalyticsEngineClient
#e.g
CloudPakforData_HOSTNAME = "icpd-zen.cp4dvip.coppel.io"
USER = "juancp"
PASSWORD = "password"
SPARK_INSTANCE = "coppel-spark-instance"

# Initializing client
#client = AnalyticEngineClient(host=CloudPakforData_HOSTNAME, uid=USER, pwd=PASSWORD)
client = AnalyticsEngineClient(host=CloudPakforData_HOSTNAME, uid=USER, pwd=PASSWORD)
print('clienye iniciado')
#volume instance creation payload
volume_instance_payload = {
	"metadata": {
		"storageClass": "portworx-shared-gp3",
		"storageSize": "20Gi"
	},"resources": {}, "serviceInstanceDescription": "app volume"}

#Create volume instance
#client.create_volume("app-vol2",create_arguments=volume_instance_payload)
respuesta = client.create_volume("appvol2jc2",create_arguments=volume_instance_payload)
print('Se creo el volumen !!!!!------------------------')
