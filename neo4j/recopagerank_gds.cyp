CALL gds.graph.create(
    'graforeco2',
    {    Cliente: { label: 'Cliente' },
        ProdClase: { label: 'ProdClase' }
    },
	    {
        COMPRO_CLASE: {
            type: 'COMPRO_CLASE',
            orientation: 'UNDIRECTED'
        }
    }
)
YIELD graphName, nodeCount, relationshipCount, createMillis;



    
	
MATCH (clienteinit:Cliente{id_cte:49264509})
CALL gds.pageRank.stream('graforeco2', {
  maxIterations: 20,
  dampingFactor: 0.85,
  sourceNodes: [clienteinit]
})
YIELD nodeId, score
WHERE 'ProdClase'IN labels(gds.util.asNode(nodeId)) 
RETURN gds.util.asNode(nodeId).id_prodclase AS id_prodclase, score

ORDER BY score DESC, id_prodclase ASC LIMIT 10;