USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM 'file:///estados_categorias.csv' AS line
CREATE (edo:ESTADO{D_EDO:toInteger(line.D_EDO)})
WITH edo, line
MATCH (c1:Cliente)
WHERE (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) AND c1.D_EDO=line.D_EDO
WITH c1, edo
MERGE (c1)-[r:EDO_SIMIL]->(edo)
ON MATCH SET r.pesosimil=0.1;