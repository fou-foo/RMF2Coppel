// version 4.1 de neo4j
CREATE INDEX indicefamilias 
FOR (prod:Familia)
ON (prod.id_Familia);

// no me dejo en  la community edition USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM 'file:///prod_prod_no_conexo.csv' AS csvline FIELDTERMINATOR ','
WITH csvline
CREATE (prod:Familia{id_Familia: toInteger(csvline.id_Familia) } );



// no me dejo en  la community edition USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM 'file:///prod_prod_w.csv' AS csvline FIELDTERMINATOR ','
WITH csvline
MERGE (prod:Familia{id_Familia: toInteger(csvline.source) } );
