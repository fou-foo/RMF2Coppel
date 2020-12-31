//Primero hay que comiar el archivo del bucket al folder de import 
// despues de logerase con ssh 
cd /var/lib/neo4j/import 
sudo  gsutil cp gs://desarrollofast/prod_prod_w.csv prod_prod_w.csv
// no me dejo en  la community edition USING PERIODIC COMMIT 



// no me dejo en  la community edition USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM 'file:///prod_prod_w.csv' AS csvline FIELDTERMINATOR ','
WITH csvline
MERGE (prod:ProdClase{id_prodclase: toInteger(csvline.source) } );

USING PERIODIC COMMIT  LOAD CSV WITH HEADERS FROM 'file:///prod_prod_w.csv' AS csvline FIELDTERMINATOR ','
WITH csvline
MATCH (n:ProdClase{id_prodclase: toInteger(csvline.source) } ) 
MATCH (p:ProdClase{id_prodclase: toInteger(csvline.target) } ) 
MERGE (n)-[r:PODRIA_INTERESARLE]->(p)
ON CREATE SET r.peso = toFloat(csvline.weight);