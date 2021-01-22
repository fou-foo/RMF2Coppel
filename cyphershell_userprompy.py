# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 16:11:28 2021

@author: juan.ramirezp
"""

import subprocess

get_recommendation = "s"
idcte_qval = '"idcte_q=>{}"' 
idcte = 250269
cypher_bash_cte_cmmd=["cypher-shell",
                     "-u",
                     "neo4j",
                     "-p",
                     "test",
                     "--file",
                     "Pagerank_q_get_reco.cyp",
                     "-P",
                     idcte_qval.format(idcte)]
print(cypher_bash_cte_cmmd)
#subprocess.run(["ls", "-l"])
while get_recommendation == "s":
    modl=input("Escoga un numero\n 1:siguiente compra\n 2 primeracompra")
    if (modl=="1"):
        idcliente = input("Deme el número de id del cliente")
        try:
            idcte = int(idcliente)
        except ValueError:
            idcte = idcliente
            print('Un entero')
        if isinstance(idcte, int):
           cypher_bash_cte_cmmd[8]=idcte_qval.format(idcte)
           #print(cypher_bash_cte_cmmd)
           subprocess.run(cypher_bash_cte_cmmd)
    elif(modl21=="2"):
        print("TODO")
    else:
        print("opcion invalida")
    get_recommendation=input("quiere otra recomendacion?(s/n)")    
        