
USING PERIODIC COMMIT LOAD CSV WITH HEADERS  FROM 'file:///transaccional.csv' AS csvline
WITH csvline
WHERE csvline.PROD_AREA IN ["Ropa", "Muebles"] 
MATCH (c:Cliente{id_cte:toInteger(csvline.ID_CTE)})
MATCH (prod:ProdClase{id_prodclase:1000000*(CASE csvline.PROD_AREA WHEN 'Muebles' THEN 2  WHEN 'Ropa' THEN 1 ELSE 3 END)+ 100000*toInteger(csvline.PROD_DEP)+1000*toInteger(csvline.PROD_CLAS)+toInteger(csvline.PROD_FAM)})
MERGE (c)-[r:COMPRO_CLASE]->(prod)
ON CREATE SET r.peso = 0 

