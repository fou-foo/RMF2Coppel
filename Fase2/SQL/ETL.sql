
CREATE  TABLE  CENIC.ANALYTICS.ANTONIO_MRF2_Demograficos AS (

--fijamos semilla para reproducibilidad de los numeros pseudoaleatorios
WITH semilla as (
select setseed(0.0)
), 
--informacion de felipe 
 Demogra AS (
 SELECT *
  FROM ANALITICAAFORE.ADMIN.BASECLIENTES_SISTEMA_REC 
 ), 
 
 --numeros de telefono que recopilo Vilma 
  VilmaTel AS (
 SELECT  NUMEROCLIENTE 
       , TIPOTELEFONO
       , NUMEROTELEFONOORIGEN
       , NUMEROTELEFONO
       , CARRIER, ROW_NUMBER() OVER( PARTITION BY NUMEROCLIENTE  ORDER BY  NUMEROCLIENTE) AS INDICE 

  FROM CENIC.BIG.MAETELEFONOS_MAY19
 ), 
 
 -- emails validados y confrmados que recopilo Vilma
   temp1 AS (
 SELECT IDU_CLIENTECODIGOMAESTRO, 
         DES_CORREOELECTRONICO
       , DES_ORIGEN
  FROM CENIC.BIG.MAETELEFONOS_MAY20
   where DES_ESTATUS ='Válido' ), 
   
   VilmaEmail as ( 
   SELECT IDU_CLIENTECODIGOMAESTRO, 
         DES_CORREOELECTRONICO
       , DES_ORIGEN, ROW_NUMBER() OVER ( PARTITION BY IDU_CLIENTECODIGOMAESTRO ORDER BY IDU_CLIENTECODIGOMAESTRO  ) AS INDICE
  FROM temp1 
   ), 
   
  res as (
 SELECT distinct  
 Demogra.*, 
        tel.TIPOTELEFONO
       , tel.NUMEROTELEFONOORIGEN
       , tel.NUMEROTELEFONO
       , tel.CARRIER
	   , Email.DES_CORREOELECTRONICO
	   , Email.DES_ORIGEN 
	   FROM  Demogra 
	LEFT JOIN  ( select  distinct NUMEROCLIENTE,  TIPOTELEFONO,NUMEROTELEFONOORIGEN, NUMEROTELEFONO, CARRIER   
	              from VilmaTel WHERE  INDICE = 1) tel 
	ON Demogra.ID_CTE = tel.NUMEROCLIENTE
	LEFT JOIN (select  distinct  IDU_CLIENTECODIGOMAESTRO, DES_CORREOELECTRONICO,DES_ORIGEN
	           from   VilmaEmail WHERE INDICE = 1) as Email
	ON Demogra.ID_CTE =Email.IDU_CLIENTECODIGOMAESTRO
	), 
	
	
	res2 as (
	select *, random() as Sampling from res order by FECHA_ALTA
	)
	
	select * from res2  ) DISTRIBUTE ON  (ID_CTE) 
	
	
	
	--Solo copio la tabla para tenerla en nuestro schema
CREATE  TABLE  CENIC.ANALYTICS.ANTONIO_MRF2_Transaccional AS (
SELECT * 
   FROM ANALITICAAFORE.ADMIN.TRANSACCIONES_SISTEMA_REC as t 
  ) DISTRIBUTE ON  (ID_CTE) 
