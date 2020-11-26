CREATE INDEX index_edo IF NOT EXISTS FOR (n:Cliente)
ON (n.D_EDO);
UNWIND [20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 ] AS x



MATCH (edo:ESTADO)
WHERE edo.D_EDO=x
WITH edo
MATCH (c1:Cliente)
WHERE c1.D_EDO=edo.D_EDO AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, edo
CREATE (c1)-[r:EDO_SIMILITUD]->(edo)
SET r.pesosimiledo=0.1;


