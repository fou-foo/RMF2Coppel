// no me dejo en  la community edition USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM 'file:///prod_prod_w.csv' AS csvline FIELDTERMINATOR ','
WITH csvline
MATCH (n:Familia{id_Familia: toInteger(csvline.source) } ) 
MATCH (p:Familia{id_Familia: toInteger(csvline.target) } ) 
MERGE (n)-[r:PODRIA_INTERESARLE]->(p)
ON CREATE SET r.peso = toFloat(csvline.weight);