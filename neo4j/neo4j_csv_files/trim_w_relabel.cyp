MATCH (n:Cliente)
WHERE (n:Cliente)-[:COMPRO_CLASE]->(:ProdClase) 
REMOVE n:Cliente
SET n:Cliente_con_compras