CREATE INDEX index_civil2 IF NOT EXISTS FOR (n:Cliente)
ON (n.EDO_CIVIL);

MATCH (edo:EDO_CIVIL)
WHERE edo.edocivil="C"
WITH edo
MATCH (c1:Cliente)
WHERE c1.EDO_CIVIL="C" AND  c1.D_EDO<16   AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 

WITH c1, edo
CREATE (c1)-[r:EDO_SIMILITUD]->(edo)
SET r.pesosimiledo=0.1;


MATCH (edo:EDO_CIVIL)
WHERE edo.edocivil="C"
WITH edo
MATCH (c1:Cliente)
WHERE c1.EDO_CIVIL="C" AND  c1.D_EDO>=16   AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 

WITH c1, edo
CREATE (c1)-[r:EDO_SIMILITUD]->(edo)
SET r.pesosimiledo=0.1;


MATCH (edo:EDO_CIVIL)
WHERE edo.edocivil="S"
WITH edo
MATCH (c1:Cliente)
WHERE c1.EDO_CIVIL="S"    AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 

WITH c1, edo
CREATE (c1)-[r:EDO_SIMILITUD]->(edo)
SET r.pesosimiledo=0.1;


UNWIND [ "V", "D"] as x

MATCH (edo:EDO_CIVIL)
WHERE edo.edocivil=x
WITH edo
MATCH (c1:Cliente)
WHERE c1.EDO_CIVIL=edo.edocivil   AND (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 

WITH c1, edo
CREATE (c1)-[r:EDO_SIMILITUD]->(edo)
SET r.pesosimiledo=0.1;