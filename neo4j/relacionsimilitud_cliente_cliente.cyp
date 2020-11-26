//MATCH between all clientes that bought something from a familiy
MATCH (c1:Cliente)
WHERE (c1:Cliente)-[:COMPRO_CLASE]->(:ProdClase) AND c1.D_EDO=2
WITH collect(c1) as c1nodes
MATCH (c2:Cliente)
WHERE (c2:Cliente)-[:COMPRO_CLASE]->(:ProdClase) AND c2.D_EDO=2
WITH c1nodes, collect(c2)  as c2nodes
UNWIND c1nodes as x
UNWIND c2nodes as y
MATCH (a:Cliente),(b:Cliente)
WHERE a.id_cte = x.id_cte AND b.id_cte = y.id_cte AND a.id_cte <> b.id_cte
WITH a,b
MERGE (a)-[r:ES_SIMIL]->(b)
ON MATCH SET r.pesosimil=0.1*((CASE WHEN a.GENERO=b.GENERO THEN 1  ELSE 0 END)
                     +(CASE WHEN a.EDO_CIVIL=b.GENERO THEN 1 ELSE 0 END)
                     +(CASE WHEN a.D_EDO=b.D_EDO THEN 1 ELSE 0 END)
                     +(CASE WHEN a.ESTATUS_MIGRACION=b.ESTATUS_MIGRACION THEN 1 ELSE 0 END)
                     );





