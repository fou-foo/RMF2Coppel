Setup
================
Antonio García
6/2/2020

### Create proyect in GCP

[console](https://console.cloud.google.com/projectselector2/home/dashboard?hl=es-419&_ga=2.107833418.930555649.1591087211-2107747144.1590254601&_gac=1.86778346.1590759743.CjwKCAjw5cL2BRASEiwAENqAPodrcbNKYucbO6dA4dEAMP2VGrfQmqsPF5TCxfsGrMbXoLBfzWUMjRoCRs0QAvD_BwE)

With name `RMF2GCP` and clone repo

```sh
git clone https://github.com/fou-foo/RMF2Coppel.git
```

### Install Google Cloud’s SDK

* In [Ubuntu](https://cloud.google.com/sdk/docs/downloads-apt-get?hl=es-419)

```sh
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

sudo apt-get install apt-transport-https ca-certificates gnupg

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

sudo apt-get update && sudo apt-get install google-cloud-sdk

gcloud init # para comenzar y configurar credenciales
```

### Create buckets for *sample* data and *real* data

```sh
gsutil mb -p rmf2gcp -c STANDARD -l US-EAST1 -b on gs://sample_data_rmf2/
gsutil cp InfSociedomografica_CtesEcommerce_DR.zip gs://sample_data_rmf2/demographics/ # esto lo sube de manera unicore
gsutil cp InfTransacciones_CtesEcommerce_DR.zip gs://sample_data_rmf2/transactional/ # esto lo sube de manera unicore
gsutil cp foo.txt  gs://raw_data_rmf2/demographics/
gsutil cp foo.txt  gs://raw_data_rmf2/transactional/
gsutil cp demographics.zip  gs://sample_data_rmf2/demographics/
gsutil cp transactions.zip  gs://sample_data_rmf2/transactional/
```

Next we unzip the files with Dataflow
[prices](https://cloud.google.com/dataflow/pricing?hl=es)

```sh
gcloud dataflow jobs run sample-data-rmf2-demographics --gcs-location gs://dataflow-templates-us-central1/latest/Bulk_Decompress_GCS_Files --region us-central1 --staging-location gs://sample_data_rmf2/demographics/temp --parameters inputFilePattern=gs://sample_data_rmf2/demographics/InfSociedomografica_CtesEcommerce_DR.zip,outputDirectory=gs://sample_data_rmf2/demographics/,outputFailureFile=gs://sample_data_rmf2/demographics/errors

gcloud dataflow jobs run sample-data-rmf2-transactional --gcs-location gs://dataflow-templates-us-east1/latest/Bulk_Decompress_GCS_Files --region us-east1 --staging-location gs://sample_data_rmf2/transactional/temp --parameters inputFilePattern=gs://sample_data_rmf2/transactional/InfTransacciones_CtesEcommerce_DR.zip,outputDirectory=gs://sample_data_rmf2/transactional/,outputFailureFile=gs://sample_data_rmf2/transactional/errors

gcloud dataflow jobs run raw-data-rmf2-demographics --gcs-location gs://dataflow-templates-us-east1/latest/Bulk_Decompress_GCS_Files --region us-east1 --staging-location gs://raw_data_rmf2/demographics/temp --parameters inputFilePattern=gs://raw_data_rmf2/demographics/demographics.zip,outputDirectory=gs://raw_data_rmf2/demographics/,outputFailureFile=gs://raw_data_rmf2/demographics/errors

gcloud dataflow jobs run raw-data-rmf2-transactional --gcs-location gs://dataflow-templates-us-east1/latest/Bulk_Decompress_GCS_Files --region us-east1 --staging-location gs://raw_data_rmf2/transactional/temp --parameters inputFilePattern=gs://raw_data_rmf2/transactional/transactions.zip,outputDirectory=gs://raw_data_rmf2/transactional/,outputFailureFile=gs://raw_data_rmf2/transactional/errors
```

Exportamos los archivos a tablas en BigQuery para explorarlas

Checar logs de fallo al cargar tablas en [BQ](https://stackoverflow.com/questions/52100812/bigquery-where-can-i-find-the-error-stream)

```sh
bq --format=prettyjson show -j <JobID> # logs en BQ
wc -l InfTransacciones_CtesEcommerce_DR.csv # vamos a permitir hasta un 10% de registros con errores con tal que jale
24959943 /10
```

Despues de crear las tablas en BigQuery, encontramos los siguentes detalles :
* Información redundante, en los archivos hay variables que no se ocupan
* La fecha de nacimiento del cliente puede ser usado como __feature__
* Los archivos de prueba (muestra) y el historico no son consistentes en nombre y número de columnas, __debemos homologar eso__ [revizar como se encuentra directamenta en la base de datos de Evelín]()

# Reproduciendo el analísis del notebook `PySparkRecommenderWithWorkflow.jupyter-py35`


## Localmente el Ubuntu 20

Creamos la tabla a partir de la muestra total

Primero creamos una tabla con los features que se utilizan con una columna contando el número del user

```sql
CREATE TABLE `rmf2gcp.RawData.demographics_features` AS  
  SELECT ROW_NUMBER() OVER() id_table_dem, * 
    FROM (
      SELECT ID_CTE as USERID, CONCAT( CAST( DATE_DIFF( CURRENT_DATE(), cast( FECHA_NAC as date), YEAR)  as string) , ',', CAST( EDO_CIVIL as string), ',', CAST( GENERO as string) ) as FEATURES, D_EDO as STATE
        FROM `rmf2gcp.RawData.demographics` 
        order by ID_CTE
          ) as A # 18,986,920
        WHERE A.FEATURES IS NOT NULL # 18,985,770

CREATE OR REPLACE TABLE `rmf2gcp.RawData.demographics_features` AS  
select * 
from `rmf2gcp.RawData.demographics_features`
order by id_table_dem


```

Ya de ahi nos seguimos a crear el agregado de las transacciones

```sql
CREATE OR REPLACE TABLE RawData.Workflow_aggregado as (
select dem.id_table_dem, dem.USERID ,  cast(REGEXP_REPLACE(T.ID_FAM, '^.', '') as int64 )  as ID_FAM  , count(*) as FREQUENCY
  from `RawData.transactional` as T
    inner join `RawData.demographics_features` as dem
  on T.ID_CTE  = dem.USERID
#  where dem.D_EDO='JALISCO                  '
#  and T.FECHA_TICKET >='2016-01-01'
 # and T.FECHA_TICKET <'2018-01-01'
  group by id_table_dem, dem.USERID , T.ID_FAM   );

```

Para poder extraer la info de BQ installamos a un local `pip install --upgrade google-cloud-bigquery[pandas]` y luego configuramos los servicios de [service account](https://cloud.google.com/docs/authentication/getting-started) para la API de BQ ( se uede hacer con la consola web pero mejor con el SDK)

```sh
mkdir BQkeys #para guardar las llaves
gcloud init
gcloud iam service-accounts create antoniobq
gcloud projects list
gcloud projects add-iam-policy-binding rmf2gcp --member "serviceAccount:antoniobq@rmf2gcp.iam.gserviceaccount.com" --role "roles/owner"
gcloud iam service-accounts keys create antoniobq_key.json --iam-account antoniobq@rmf2gcp.iam.gserviceaccount.com
cp antoniobq_key.json BQkeys/antoniobq_key.json
cd BQkeys
pwd  # get path to credentials  /home/antonio/Desktop/github/RMF2Coppel/BQkeys/antoniobq_key.json
```


Habilitamos las credenciales

```sh
conda deactivate
export GOOGLE_APPLICATION_CREDENTIALS="/home/antonio/Desktop/github/RMF2Coppel/BQkeys/antoniobq_key.json"
conda activate
sudo apt install openjdk-8-jdk
sudo update-alternatives --config java
```


# Para reproducir lo que hicieron en la nube con los 'datos mas recientes'

```sql
SELECT *
FROM `rmf2gcp.IBM_test.ibm_test`
LIMIT 3105886 #
```


### Setup local Ubuntu 20

Install Apache Spark, this site is very [useful](https://computingforgeeks.com/how-to-install-apache-spark-on-ubuntu-debian/).

__Usar Java 8!!!!!!!!!!!!!!!!!__


Creamos las variables de entorno en `antonio@antonio-GL553VD:~$ source ~/.bashrc`


```sh
#sudo update-java-alternatives -s java-1.8.0-openjdk-amd64
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:$JAVA_HOME
export ARROW_PRE_0_15_IPC_FORMAT=1
source ~/.bashrc # ejecucion del archivo
```



## En GCP

Caracteristicas y doc de [Dataproc](https://cloud.google.com/dataproc/docs?hl=es) para cluster Spark facíl ! :D  

Y de aqui podemos usar el comando `%%bq` como dice [aqui](https://cloud.google.com/bigquery/docs/visualize-jupyter) en un jupyter notebook dentro de GCP en otro caso construimos la funcion a pie

```python
from google.cloud import bigquery
def get_data_BQ(sql):
    client = bigquery.Client()
    df = client.query(sql).to_dataframe()
    return(df)
sql =  '''SELECT *
FROM `rmf2gcp.RawData.Workflow_aggregado`
where id_table_dem <= 189857#18985770 # 1% ''' # corre en mi local y pesa 56MB
```

Aca una referencia para automatizar el flujo con funciones cloud y [Cloud Scheduler](https://cloud.google.com/dataproc/docs/tutorials/workflow-scheduler?hl=es) __sí lgramos determinar el layout de escritura en un bocket para no pasar por BigQuery__


Y seguimos esta guía para el cluster para ejecutarlo en todo el dataset [notebook-datapproc](https://cloud.google.com/dataproc/docs/tutorials/jupyter-notebook?hl=es#console)




### Create bucket for save notebooks

```sh
gcloud init
gsutil mb -p rmf2gcp -c STANDARD -l US-EAST1 -b on gs://rmf2code/
gsutil cp  -r /home/antonio/Desktop/github/RMF2Coppel/ gs://rmf2code/notebooks/jupyter # copiar el repo

```

### Create the cluster

Con:

* OS: Ubuntu 18 # pues es lo que hay de ubuntu, ojala pronto tengan la versión 19 para dejar de preocuparnos por la version de python  

* 1 solo nodo master (a ver si se puede alterar despues esto)
* En general es una maquina con el doble de capacidad que la de mi casa


```sh
gcloud beta dataproc clusters create rmf2-cluster1 --enable-component-gateway --bucket rmf2code --region us-central1 --subnet default --zone us-central1-b --single-node --master-machine-type n1-standard-8 --master-boot-disk-size 500 --image-version 1.5-ubuntu18 --optional-components ANACONDA,JUPYTER --project rmf2gcp
```


# Reproduciendo el analísis del notebook `hybridModel.jupyter`


### De manera local

Vamos a utilizar los datos de transacciones creadas con el query y guardadas en el archivo `transacctional_sample.csv`

```sql
SELECT *
FROM `rmf2gcp.RawData.Workflow_aggregado`
where id_table_dem <= 189857#18985770 # 1%
```
Y el query siguiente para el archivo `transaccional_sample_features_combined.csv`

```sql
select ID_CTE as USERID, CONCAT( CAST( DATE_DIFF( CURRENT_DATE(), cast( FECHA_NAC as date), YEAR)  as string) , ',', CAST( EDO_CIVIL as string), ',', CAST( GENERO as string) ) as FEATURES, D_EDO as STATE
from `rmf2gcp.RawData.demographics_features`
where ID_CTE in
(SELECT  ID_CTE
FROM `rmf2gcp.RawData.Workflow_aggregado`
where id_table_dem <= 189857#18985770 # 1%
)

```

# Reproduciendo el analísis del notebook `Hybrid Recommendation Engine.jupyter-py35`

### De manera local
