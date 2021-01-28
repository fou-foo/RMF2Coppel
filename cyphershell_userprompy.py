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
edocivqval = '"edociv =>\'{}\'"'
entidad_qval = '"entidad => {}"'
generoqval = '"gen =>\'{}\'"'
educqval = '"educ =>\'{}\'"'
filename = ""
idcte = 25026933
EDO_CIV = "C"
D_EDO = 2
GENERO = "M"
NIVEL_EDUC = "SECUNDARIA"
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

cypher_bash_coldstrt = ["cypher-shell",
                        "-u",
                        "neo4j",
                        "-p",
                        "test",
                        "--file",
                        "Pagerank_coldstart.cyp",
                        "-P",
                        edocivqval.format(EDO_CIV),
                        "-P",
                        entidad_qval.format(D_EDO),
                        "-P",
                        generoqval.format(GENERO),
                        "-P",
                        educqval.format(NIVEL_EDUC),
                        "-P",
                        filenameqval.format(filename)
                        ]
print("cargando tabla cliente")
df_clientes = pd.read_csv("clientes.csv",sep="|",index_col="ID_CTE")
print("sorteando indice")
df_clientes.sort_index()
while get_recommendation == "s":
    modl = input(
        "Escoga un numero\n "
        +"1: siguiente compra\n"
        +" 2: primeracompra(id)")
    if (modl == "1" or modl=="2"):
        idcliente = input("Deme el número de id del cliente")
        try:
            idcte = int(idcliente)
        except ValueError:
            idcte = idcliente
            print('Un entero')
        if isinstance(idcte, int):
            print("buscando cliente en BD")
            if idcte not in df.index:
                print("Error, no hay un cliente con dicho indice")
            elif modl == "1":
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
                cte = df_cliente.loc[idcte]
                EDO_CIVIL = cte["EDO_CIVIL"]
                D_EDO = cte["D_EDO"]
                GENERO = cte["GENERO"]
                NIVEL_EDUC = cte["NIVEL_EDUC"]
                cypher_bash_coldstrt[8] = edocivqval.format(EDO_CIV)
                cypher_bash_coldstrt[10] = entidad_qval.format(D_EDO)
                cypher_bash_coldstrt[12] = generoqval.format(GENERO)
                cypher_bash_coldstrt[14] = educqval.format(NIVEL_EDUC)
                filename = input(" nombre donde se va a escribir (sin .csv)")
                cypher_bash_coldstrt[16] = filenameqval.format(filename)
                print(cypher_bash_coldstrt)
                cycomd = " ".join(cypher_bash_coldstrt)
                print(cycomd)
                subprocess.run(cycomd, shell=True)
                print("archivo escrito, algunos valores")
                df = pd.read_csv("import/{}.csv".format(filename))
                print(df.head())
                

    get_recommendation = input("quiere otra recomendacion?(s/n)")
        