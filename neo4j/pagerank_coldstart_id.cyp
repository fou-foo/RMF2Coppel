WITH "
MATCH (clienteconid:Cliente{id_cte:"+$idcte_q+"})
WITH clienteconid AS c1
MATCH (lat_civil:EDO_CIVIL{edocivil:c1.EDO_CIVIL}),(lat_entidad:ESTADO{D_EDO:c1.D_EDO}),(lat_gen:GENERO{genero:c1.GENERO}),(lat_educ:NIVEL_EDUC{estatusedu:c1.NIVEL_EDUC})
CALL gds.pageRank.stream('graforecoconexo_con_compras', {
  maxIterations: 20,
  dampingFactor: 0.85,
  tolerance: 0.01,
  relationshipTypes:['COMPRO_CLASE','EDO_SIMILITUD','PODRIA_INTERESARLE'],
  relationshipWeightProperty: 'peso',
  sourceNodes: [lat_civil, lat_entidad, lat_gen, lat_educ]})
YIELD nodeId, score
WITH gds.util.asNode(nodeId) AS node, score
WHERE node:ProdClase
RETURN node.id_prodclase AS id_prodclase, score" as query
CALL apoc.export.csv.query(query, $filename, {})
YIELD file, nodes, relationships, properties, data
RETURN file, nodes, relationships, properties, data;