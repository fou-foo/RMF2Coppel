CREATE INDEX idxgenero IF NOT EXISTS FOR (n:Cliente)
ON (n.GENERO);
match(c:Cliente) 
WHERE c.GENERO IS NOT NULL
with distinct(c.GENERO) as gro
MERGE(c2:GENERO{genero:gro}) return count(c2);


MATCH (gen:GENERO)
WHERE gen.genero="M"
WITH gen
MATCH (c1:Cliente)
WHERE c1.GENERO="M"  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, gen
CREATE (c1)-[r:EDO_SIMILITUD]->(gen)
SET r.pesosimiledo=0.1;


MATCH (gen:GENERO)
WHERE gen.genero="F"
WITH gen
MATCH (c1:Cliente)
WHERE c1.GENERO="F"  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, gen
CREATE (c1)-[r:EDO_SIMILITUD]->(gen)
SET r.pesosimiledo=0.1;
