CREATE  TABLE  CENIC.ANALYTICS.ANTONIO_MRF2MERGE_TRANS_DEMO_001 AS (
WITH semilla as (
SELECT FECHA_TICKET
       , ID_TIENDA
       , ID_TICKET
       , PROD_SKU
       , PROD_DEP
       , DESC_PROD_DEP
       , PROD_CLAS
       , DESC_PROD_CLAS
       , PROD_FAM
       , DESC_PROD_FAM
       , PROD_AREA
       , PROD_CATEGORIA
       , DESC_PROD_CATEGORIA
       , IMPORTE_VTA
       , CANTIDAD_VTA
       , PROD_PRECIO_PROMEDIO
       , TIPOCOMPRA
       , ID_CTE
       , FECHA_NAC
       , GENERO
       , EDO_CIVIL
       , D_EDO
       , DESC_D_EDO
       , D_NC
       , DESC_D_NC
       , TP_HOGAR
       , T_HOGAR
       , N_P_HOGAR
       , N_P_TR_HOGAR
       , N_D_EC
       , N_HIJOS
       , NIVEL_EDUC
       , PUESTO
       , SUBPUESTO
       , OPCIONPUE
       , CTE_SALARIO_ANTIGUOS
       , CTE_SALARIO
       , CTE_CRED
       , TEL_CTE_VC
       , CEL_CTE_VC
       , CP_DOM_ALTA
       , FECHA_1COMPRA
       , FECHA_1COMPRA_R
       , FECHA_1COMPRA_M
       , FECHA_1COMPRA_TA
       , FECHA_1COMPRA_P
       , F_ULT_COMP
       , F_ULT_COMP_R
       , F_ULT_COMP_M
       , F_ULT_COMP_TA
       , F_ULT_COMP_P
       , FECHA_ALTA
       , ESTATUS_MIGRACION
       , DESC_ESTATUS_MIGRACION
       , CTE_SALDO_TOT
       , CTE_SALDO_ROPA
       , CTE_SALDO_MUEBLES
       , CTE_SALDO_T_AIRE
       , CTE_SALDO_PRESTAMO
       , CTE_SALDO_REVOLVENTE
       , CTE_SALDO_VENC_TOT
       , CTE_SALDO_VENC_ROPA
       , CTE_SALDO_VENC_MUEBLES
       , CTE_SALDO_VENC_T_AIRE
       , CTE_SALDO_VENC_PRESTAMOS
       , CTE_SALDO_VENC_REVOLVENTE
       , CTE_EFIC
       , TIPO_CTE
       , SITUACION
       , CAUSASITESP
       , FLAG_SIT_IMPIDE_COMPRA
       , FLAGALTADIRECTA
       , ABONOSVENCIDOS
       , FECHADIFCOBRO
       , SDOCTAPERDIDA
       , FECHACORTE
       , TIPOTELEFONO
       , NUMEROTELEFONOORIGEN
       , NUMEROTELEFONO
       , CARRIER
       , DES_CORREOELECTRONICO
       , DES_ORIGEN
from CENIC.ANALYTICS.ANTONIO_MRF2MERGE_TRANS_DEMO 
where Sampling <= 0.01
)

select * from semilla
)


CREATE  TABLE  CENIC.ANALYTICS.ANTONIO_MRF2MERGE_TRANS_DEMO_010 AS (
WITH semilla as (
SELECT FECHA_TICKET
       , ID_TIENDA
       , ID_TICKET
       , PROD_SKU
       , PROD_DEP
       , DESC_PROD_DEP
       , PROD_CLAS
       , DESC_PROD_CLAS
       , PROD_FAM
       , DESC_PROD_FAM
       , PROD_AREA
       , PROD_CATEGORIA
       , DESC_PROD_CATEGORIA
       , IMPORTE_VTA
       , CANTIDAD_VTA
       , PROD_PRECIO_PROMEDIO
       , TIPOCOMPRA
       , ID_CTE
       , FECHA_NAC
       , GENERO
       , EDO_CIVIL
       , D_EDO
       , DESC_D_EDO
       , D_NC
       , DESC_D_NC
       , TP_HOGAR
       , T_HOGAR
       , N_P_HOGAR
       , N_P_TR_HOGAR
       , N_D_EC
       , N_HIJOS
       , NIVEL_EDUC
       , PUESTO
       , SUBPUESTO
       , OPCIONPUE
       , CTE_SALARIO_ANTIGUOS
       , CTE_SALARIO
       , CTE_CRED
       , TEL_CTE_VC
       , CEL_CTE_VC
       , CP_DOM_ALTA
       , FECHA_1COMPRA
       , FECHA_1COMPRA_R
       , FECHA_1COMPRA_M
       , FECHA_1COMPRA_TA
       , FECHA_1COMPRA_P
       , F_ULT_COMP
       , F_ULT_COMP_R
       , F_ULT_COMP_M
       , F_ULT_COMP_TA
       , F_ULT_COMP_P
       , FECHA_ALTA
       , ESTATUS_MIGRACION
       , DESC_ESTATUS_MIGRACION
       , CTE_SALDO_TOT
       , CTE_SALDO_ROPA
       , CTE_SALDO_MUEBLES
       , CTE_SALDO_T_AIRE
       , CTE_SALDO_PRESTAMO
       , CTE_SALDO_REVOLVENTE
       , CTE_SALDO_VENC_TOT
       , CTE_SALDO_VENC_ROPA
       , CTE_SALDO_VENC_MUEBLES
       , CTE_SALDO_VENC_T_AIRE
       , CTE_SALDO_VENC_PRESTAMOS
       , CTE_SALDO_VENC_REVOLVENTE
       , CTE_EFIC
       , TIPO_CTE
       , SITUACION
       , CAUSASITESP
       , FLAG_SIT_IMPIDE_COMPRA
       , FLAGALTADIRECTA
       , ABONOSVENCIDOS
       , FECHADIFCOBRO
       , SDOCTAPERDIDA
       , FECHACORTE
       , TIPOTELEFONO
       , NUMEROTELEFONOORIGEN
       , NUMEROTELEFONO
       , CARRIER
       , DES_CORREOELECTRONICO
       , DES_ORIGEN
from CENIC.ANALYTICS.ANTONIO_MRF2MERGE_TRANS_DEMO 
where Sampling <= 0.1
)

select * from semilla
)


