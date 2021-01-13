CREATE INDEX ideduc IF NOT EXISTS FOR (n:Cliente)
ON (n.NIVEL_EDUC);
match(c:Cliente) 
WHERE c.NIVEL_EDUC IS NOT NULL
with distinct(c.NIVEL_EDUC) as educ
MERGE(c2:NIVEL_EDUC{estatusedu:educ}) return count(c2);


MATCH (edu:NIVEL_EDUC)
WHERE edu.estatusedu="SECUNDARIA"
WITH edu
MATCH (c1:Cliente)
WHERE c1.NIVEL_EDUC=edu.estatusedu  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, edu
CREATE (c1)-[r:EDO_SIMILITUD]->(edu)
SET r.pesosimiledo=0.1;

MATCH (edu:NIVEL_EDUC)
WHERE edu.estatusedu="CARRERA TECNICA"
WITH edu
MATCH (c1:Cliente)
WHERE c1.NIVEL_EDUC=edu.estatusedu  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, edu
CREATE (c1)-[r:EDO_SIMILITUD]->(edu)
SET r.pesosimiledo=0.1;

MATCH (edu:NIVEL_EDUC)
WHERE edu.estatusedu="CARRERA PROFESIONAL"
WITH edu
MATCH (c1:Cliente)
WHERE c1.NIVEL_EDUC=edu.estatusedu  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, edu
CREATE (c1)-[r:EDO_SIMILITUD]->(edu)
SET r.pesosimiledo=0.1;


MATCH (edu:NIVEL_EDUC)
WHERE edu.estatusedu="PRIMARIA"
WITH edu
MATCH (c1:Cliente)
WHERE c1.NIVEL_EDUC=edu.estatusedu  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, edu
CREATE (c1)-[r:EDO_SIMILITUD]->(edu)
SET r.pesosimiledo=0.1;

MATCH (edu:NIVEL_EDUC)
WHERE edu.estatusedu="PREPARATORIA"
WITH edu
MATCH (c1:Cliente)
WHERE c1.NIVEL_EDUC=edu.estatusedu  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, edu
CREATE (c1)-[r:EDO_SIMILITUD]->(edu)
SET r.pesosimiledo=0.1;


MATCH (edu:NIVEL_EDUC)
WHERE edu.estatusedu="NO ESTUDIO"
WITH edu
MATCH (c1:Cliente)
WHERE c1.NIVEL_EDUC=edu.estatusedu  AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
WITH c1, edu
CREATE (c1)-[r:EDO_SIMILITUD]->(edu)
SET r.pesosimiledo=0.1;


