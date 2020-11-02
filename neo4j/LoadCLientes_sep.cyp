USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM 'file:///clientes.csv' AS line FIELDTERMINATOR '|'

CREATE (c:Cliente { id_cte:toInteger(line.ID_CTE), FECHA_NAC: date(split(line.FECHA_NAC," ")[0]), 
GENERO: line.GENERO, EDO_CIVIL: line.EDO_CIVIL, D_EDO: toInteger(line.D_EDO),
FECHA_PRIMERA_COMPRA: date(split(line.FECHA_PRIMERA_COMPRA," ")[0]),
F_ULT_COMP: date(split(line.F_ULT_COMP," ")[0]),
FECHA_ALTA: date(split(line.FECHA_ALTA," ")[0]), ESTATUS_MIGRACION:toInteger(line.ESTATUS_MIGRACION)});
