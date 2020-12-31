CREATE CONSTRAINT ON (c:Cliente) ASSERT c.id_cte IS UNIQUE;
CREATE CONSTRAINT ON (prod:ProdClase) ASSERT prod.id_prodclase IS UNIQUE;

CREATE INDEX indiceclases IF NOT EXISTS
FOR (prod:ProdClase)
ON (prod.id_prodclase);

CREATE INDEX indiceclientes IF NOT EXISTS
FOR (c:Cliente)
ON (c.id_cte);

USING PERIODIC COMMIT LOAD CSV WITH HEADERS  FROM 'file:///transaccional.csv' AS csvline
WITH csvline
WHERE toInteger(csvline.area) IN [1,2] 
MATCH (c:Cliente{id:toInteger(csvline.id_cte)})
MERGE (prod:ProdClase{area: toInteger(csvline.area),prod_dep:toInteger(csvline.PROD_DEP),prod_class:toInteger(csvline.PROD_CLAS),prod_fam:toInteger(csvline.PROD_FAM),
id_prodclase:1000000*toInteger(csvline.area)+100000*toInteger(csvline.PROD_DEP)+1000*toInteger(csvline.PROD_CLAS)+toInteger(csvline.PROD_FAM)})
MERGE (c)-[r:COMPRO_CLASE]->(prod)
ON CREATE SET r.peso = 0 
MATCH (c)-[r2:COMPRO_CLASE]->(prod)
SET r2.peso =r2.peso+1 ;

