CALL gds.graph.create(


  'graforecoconexo',{
    Cliente: { label: 'Cliente' },
        ProdClase: { label: 'ProdClase' },
		Genero: {label: 'GENERO'},
		edocivil:{label: 'EDO_CIVIL'},
		estado:{label:'ESTADO'}
    },{
        COMPRO_CLASE: {
            type: 'COMPRO_CLASE',
            orientation: 'UNDIRECTED',
			properties: {
			   peso: {
			          property:'peso'
				      }
			}
        },
		EDO_SIMILITUD:{
            type: 'EDO_SIMILITUD',
            orientation: 'UNDIRECTED',
			properties: {
			   peso: {
			          property:'pesosimiledo'
				      }
			}
        }
    
	}
	)
	
YIELD graphName, nodeCount, relationshipCount;

MATCH (clienteinit:Cliente{id_cte:49264509})
CALL gds.pageRank.stream.estimate('graforecoconexo', {
  maxIterations: 20,
  dampingFactor: 0.85,
  relationshipTypes:['COMPRO_CLASE','EDO_SIMILITUD'],
  relationshipWeightProperty: 'peso',
  sourceNodes: [clienteinit]
})
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory
return requiredMemory;






MATCH (clienteinit:Cliente{id_cte:49264509})
CALL gds.pageRank.stream('graforecoconexo', {
  maxIterations: 20,
  dampingFactor: 0.85,
  tolerance: 0.01,
  relationshipTypes:['COMPRO_CLASE','EDO_SIMILITUD'],
  relationshipWeightProperty: 'peso',
  sourceNodes: [clienteinit]
  
})

YIELD nodeId, score
WITH gds.util.asNode(nodeId) as node, score
WHERE node:ProdClase
RETURN node.id_prodclase AS id_prodclase, score

ORDER BY score DESC, id_prodclase ASC LIMIT 10;