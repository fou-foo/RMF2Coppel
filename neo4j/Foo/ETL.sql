CREATE OR REPLACE TABLE  `rmf2gcp.Desarrollo.productos_descripcion_cruda`
AS SELECT * FROM `ecommerce-bi.SourceTables.mae_articulos`; 

create or replace table  `rmf2gcp.Desarrollo.productos_descripcion` 
as (
  SELECT  distinct *  from 
  (SELECT  1000000*(CASE des_Area WHEN 'Muebles' THEN 2  WHEN 'Ropa' THEN 1 ELSE 3 END) + 100000 * idu_DepartamentoCodigo+1000 *idu_ClaseCodigo + idu_FamiliaCodigo as id_Familia, 
          des_Departamento as Departamento , des_Clase as Clase, des_Familia as Familia, des_Categoria as Categoria, des_Subcategoria as Subcategoria--, 
          --idu_ArticuloCodigo--, des_Articulo
        FROM `rmf2gcp.Desarrollo.productos_descripcion_cruda`
        WHERE des_Area in ('Muebles' , 'Ropa')
        ) as a
        order by id_Familia ); 


SELECT * FROM `rmf2gcp.Desarrollo.productos_descripcion`

