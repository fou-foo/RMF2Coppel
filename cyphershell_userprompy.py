# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 16:11:28 2021

@author: juan.ramirezp
"""

import subprocess
import pandas as pd
get_recommendation = "s"
idcte_qval = '"idcte_q => {}"'
filenameqval = '"filename =>\'{}.csv\'"'
filename = ""
idcte = 25026933
cypher_bash_cte_cmmd = ["cypher-shell",
                        "-u",
                        "neo4j",
                        "-p",
                        "test",
                        "--file",
                        "Pagerank_q_get_reco.cyp",
                        "-P",
                        idcte_qval.format(idcte),
                        "-P",
                        filenameqval.format(filename)
                        ]
while get_recommendation == "s":
    modl = input("Escoga un numero\n 1:siguiente compra\n 2 primeracompra")
    if (modl == "1"):
        idcliente = input("Deme el número de id del cliente")
        try:
            idcte = int(idcliente)
        except ValueError:
            idcte = idcliente
            print('Un entero')
        if isinstance(idcte, int):
            cypher_bash_cte_cmmd[8] = idcte_qval.format(idcte)
            filename = input(" nombre donde se va a escribir (sin .csv)")
            cypher_bash_cte_cmmd[10] = filenameqval.format(filename)
            print(cypher_bash_cte_cmmd)
            cycomd = " ".join(cypher_bash_cte_cmmd)
            print(cycomd)
            subprocess.run(cycomd, shell=True)
            print("archivo escrito, algunos valores")
            df = pd.read_csv("import/{}.csv".format(filename))
            print(df.head())
    elif(modl == "2"):
        print("TODO")
    else:
        print("opcion invalida")
    get_recommendation = input("quiere otra recomendacion?(s/n)")
        