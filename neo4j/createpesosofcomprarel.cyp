USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM 'file:///clientes.csv' AS csvline FIELDTERMINATOR '|'
WITH csvline
WHERE csvline.PROD_AREA IN ["Ropa", "Muebles"] 
MATCH (c:Cliente{id_cte:toInteger(csvline.ID_CTE)}),(prod:ProdClase{id_prodclase:1000000*(CASE csvline.PROD_AREA WHEN 'Muebles' THEN 2  WHEN 'Ropa' THEN 1 ELSE 3 END)+ 100000*toInteger(csvline.PROD_DEP)+1000*toInteger(csvline.PROD_CLAS)+toInteger(csvline.PROD_FAM)})
MATCH (c)-[r:COMPRO_CLASE]->(prod)
ON CREATE SET r.peso = r.peso + 1; 