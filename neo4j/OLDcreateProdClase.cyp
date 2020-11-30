USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM 'file:///transaccional.csv' AS csvline
WITH csvline
WHERE toInteger(csvline.area) IN [1,2] 
MERGE (prod:ProdClase{area: toInteger(csvline.area),prod_dep:toInteger(csvline.PROD_DEP),prod_class:toInteger(csvline.PROD_CLAS),prod_fam:toInteger(csvline.PROD_FAM),
id_prodclase:1000000*toInteger(csvline.area)+100000*toInteger(csvline.PROD_DEP)+1000*toInteger(csvline.PROD_CLAS)+toInteger(csvline.PROD_FAM)})