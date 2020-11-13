MATCH (c:Cliente{id_cte:49264509})-[:COMPRO_CLASE]->(prod:ProdClase)<-[:COMPRO_CLASE]-(cocliente2:Cliente)-[:COMPRO_CLASE]->(simprod:ProdClase) 
WHERE c <> cocliente2
AND NOT (c)-[:COMPRO_CLASE]->(simprod)
return simprod.id_prodclase, count(simprod) as frequency
ORDER BY frequency DESC
LIMIT 10;




//MATCH (c:Cliente{id_cte:49264509})-[r:COMPRO_CLASE]->(prod:ProdClase)<-[:COMPRO_CLASE]-(cocliente2:Cliente)-[r:COMPRO_CLASE]->(simprod:ProdClase)
//WHERE c <> cocliente
//AND NOT (c)-[:COMPRO_CLASE]->(prod2)
//RETURN prod2.id_prodclase, count(prod2) as frequency
//ORDER BY frequency DESC
//LIMIT 10;
//MATCH (c:Cliente{id_cte:49264509})-[r:COMPRO_CLASE]->(prod:ProdClase)<-[:COMPRO_CLASE]-(cocliente:Cliente)-[r2:COMPRO_CLASE]->(prod2:Prodclase) return count(r2);
