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
#20557825
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

cypher_bash_coldstid = ["cypher-shell",
                        "-u",
                        "neo4j",
                        "-p",
                        "test",
                        "--file",
                        "pagerank_coldstart_id.cyp",
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
                        "Pagerank_coldstart_id.cyp",
                        "-P",
                        idcte_qval.format(idcte),
                        "-P",
                        filenameqval.format(filename)
                        ]

while get_recommendation == "s":
    modl = input(
        "Escoga un numero\n "
        + "1: siguiente compra\n"
        + " 2: primeracompra(id)")
    if (modl == "1" or modl == "2"):
        idcliente = input("Deme el número de id del cliente")
        try:
            idcte = int(idcliente)
        except ValueError:
            idcte = idcliente
            print('Un entero')
        if isinstance(idcte, int):
            filename = input(" nombre donde se va a escribir (sin .csv)")
            if modl == "1":
                cypher_bash_cte_cmmd[8] = idcte_qval.format(idcte)
                cypher_bash_cte_cmmd[10] = filenameqval.format(filename)
                print(cypher_bash_cte_cmmd)
                cycomd = " ".join(cypher_bash_cte_cmmd)
            elif modl == "2":
                cypher_bash_coldstid[8] = idcte_qval.format(idcte)
                cypher_bash_coldstid[10] = filenameqval.format(filename)
                print(cypher_bash_coldstid)
                cycomd = " ".join(cypher_bash_coldstid)
            elif(modl == "3"):
                EDO_CIVIL = input("EDO_CIVIL")
                D_EDO = input("D_EDO")
                GENERO = input("GENERO")
                NIVEL_EDUC = input("NIVEL_EDUC")
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
