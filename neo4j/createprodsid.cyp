//CREATE CONSTRAINT c1 IF NOT EXISTS ON (c:Cliente) ASSERT c.id_cte IS UNIQUE;
//CREATE CONSTRAINT c2 IF NOT EXISTS ON (prod:ProdClase) ASSERT prod.id_prodclase IS UNIQUE;

CREATE INDEX indiceclases IF NOT EXISTS
FOR (prod:ProdClase)
ON (prod.id_prodclase);

CREATE INDEX indiceclientes IF NOT EXISTS
FOR (c:Cliente)
ON (c.id_cte);

USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM 'file:///transaccional.csv' AS csvline FIELDTERMINATOR '|'
WITH csvline
WHERE csvline.PROD_AREA IN ["Ropa", "Muebles"] 
//MATCH (c:Cliente{id_cte:toInteger(csvline.ID_CTE)})
MERGE (prod:ProdClase{id_prodclase:1000000*(CASE csvline.PROD_AREA WHEN 'Muebles' THEN 2  WHEN 'Ropa' THEN 1 ELSE 3 END)+ 100000*toInteger(csvline.PROD_DEP)+1000*toInteger(csvline.PROD_CLAS)+toInteger(csvline.PROD_FAM)})
ON CREATE SET prod.PROD_AREA=csvline.PROD_AREA, prod.prod_dep=toInteger(csvline.PROD_DEP), prod.prod_clas=toInteger(csvline.PROD_CLAS),prod.prod_fam=toInteger(csvline.PROD_FAM);

