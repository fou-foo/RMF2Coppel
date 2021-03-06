CALL gds.graph.create(


  'graforecoconexo_con_compras',{
    Cliente: { label: 'Cliente_con_compras' },
        ProdClase: { label: 'ProdClase' },
		Genero: {label: 'GENERO'},
		edocivil:{label: 'EDO_CIVIL'},
		estado:{label:'ESTADO'},
		estatus_migracion:{label:'ESTATUS_MIGRACION'},
		nivel_edu:{label:'NIVEL_EDUC'}
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
        },
		PODRIA_INTERESARLE:{
            type: 'PODRIA_INTERESARLE',
            orientation: 'UNDIRECTED',
			properties: {
			   peso: {
			          property:'peso'
				      }
			}
        },
		
    
	}
	)
	
YIELD graphName, nodeCount, relationshipCount;

MATCH (clienteinit:Cliente_con_compras{id_cte:25026933})
CALL gds.pageRank.stream.estimate('graforecoconexo', {
  maxIterations: 20,
  dampingFactor: 0.85,
  relationshipTypes:['COMPRO_CLASE','EDO_SIMILITUD','PODRIA_INTERESARLE'],
  relationshipWeightProperty: 'peso',
  sourceNodes: [clienteinit]
})
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory
return requiredMemory;






MATCH (clienteinit:Cliente_con_compras{id_cte:25026933})
CALL gds.pageRank.stream('graforecoconexo_con_compras', {
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