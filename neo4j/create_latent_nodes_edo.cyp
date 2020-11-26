USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM 'file:///estados_categorias.csv' AS line
MERGE (edo:ESTADO{D_EDO:toInteger(line.D_EDO)})
