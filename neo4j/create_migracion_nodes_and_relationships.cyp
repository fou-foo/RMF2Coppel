CREATE INDEX idxgenero IF NOT EXISTS FOR (n:Cliente)
ON (n.ESTATUS_MIGRACION);
match(c:Cliente) 
WHERE c.ESTATUS_MIGRACION IS NOT NULL
with distinct(c.ESTATUS_MIGRACION) as emig
MERGE(c2:ESTATUS_MIGRACION{estatusmigracion:emig}) return count(c2);


MATCH (em:ESTATUS_MIGRACION)
WHERE em.estatusmigracion=1
WITH em
MATCH (c1:Cliente)
WHERE c1.ESTATUS_MIGRACION=em.estatusmigracion  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, em
CREATE (c1)-[r:EDO_SIMILITUD]->(em)
SET r.pesosimiledo=0.1;


MATCH (em:ESTATUS_MIGRACION)
WHERE em.estatusmigracion=2
WITH em
MATCH (c1:Cliente)
WHERE c1.ESTATUS_MIGRACION=em.estatusmigracion  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, em
CREATE (c1)-[r:EDO_SIMILITUD]->(em)
SET r.pesosimiledo=0.1;



MATCH (em:ESTATUS_MIGRACION)
WHERE em.estatusmigracion=3
WITH em
MATCH (c1:Cliente)
WHERE c1.ESTATUS_MIGRACION=em.estatusmigracion  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, em
CREATE (c1)-[r:EDO_SIMILITUD]->(em)
SET r.pesosimiledo=0.1;


MATCH (em:ESTATUS_MIGRACION)
WHERE em.estatusmigracion=4
WITH em
MATCH (c1:Cliente)
WHERE c1.ESTATUS_MIGRACION=em.estatusmigracion  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, em
CREATE (c1)-[r:EDO_SIMILITUD]->(em)
SET r.pesosimiledo=0.1;


MATCH (em:ESTATUS_MIGRACION)
WHERE em.estatusmigracion=5
WITH em
MATCH (c1:Cliente)
WHERE c1.ESTATUS_MIGRACION=em.estatusmigracion  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, em
CREATE (c1)-[r:EDO_SIMILITUD]->(em)
SET r.pesosimiledo=0.1;





MATCH (em:ESTATUS_MIGRACION)
WHERE em.estatusmigracion=6
WITH em
MATCH (c1:Cliente)
WHERE c1.ESTATUS_MIGRACION=em.estatusmigracion  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, em
CREATE (c1)-[r:EDO_SIMILITUD]->(em)
SET r.pesosimiledo=0.1;


MATCH (em:ESTATUS_MIGRACION)
WHERE em.estatusmigracion=7
WITH em
MATCH (c1:Cliente)
WHERE c1.ESTATUS_MIGRACION=em.estatusmigracion  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, em
CREATE (c1)-[r:EDO_SIMILITUD]->(em)
SET r.pesosimiledo=0.1;


MATCH (em:ESTATUS_MIGRACION)
WHERE em.estatusmigracion=8
WITH em
MATCH (c1:Cliente)
WHERE c1.ESTATUS_MIGRACION=em.estatusmigracion  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, em
CREATE (c1)-[r:EDO_SIMILITUD]->(em)
SET r.pesosimiledo=0.1;

MATCH (em:ESTATUS_MIGRACION)
WHERE em.estatusmigracion=9
WITH em
MATCH (c1:Cliente)
WHERE c1.ESTATUS_MIGRACION=em.estatusmigracion  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, em
CREATE (c1)-[r:EDO_SIMILITUD]->(em)
SET r.pesosimiledo=0.1;

