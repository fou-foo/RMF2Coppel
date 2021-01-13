WITH "MATCH (lat_civil:EDO_CIVIL{edocivil:\""+$edociv+"\"}) CALL gds.pageRank.stream('graforecoconexo_con_compras', {
  maxIterations: 20,
  dampingFactor: 0.85,
  tolerance: 0.01,
  relationshipTypes:['COMPRO_CLASE','EDO_SIMILITUD','PODRIA_INTERESARLE'],
  relationshipWeightProperty: 'peso',
  sourceNodes: [lat_civil]})
YIELD nodeId, score
WITH gds.util.asNode(nodeId) as node, score
WHERE node:ProdClase
RETURN node.id_prodclase AS id_prodclase, score" as query
CALL apoc.export.csv.query(query, "resultados_reco.csv", {})
YIELD file, nodes, relationships, properties, data
RETURN file, nodes, relationships, properties, data;