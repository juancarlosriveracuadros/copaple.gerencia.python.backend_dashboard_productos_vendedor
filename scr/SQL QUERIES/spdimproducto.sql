
/* 
Author:			Juan Carlos Rivera Cuadros
Create date:	12/01/2021
Description:	SCD2 for Table producto
----------------------------------------------------------------
Sources

https://www.youtube.com/playlist?list=PL8gxzfBmzgex2nuVanqvxoTXTPovVSwi2
https://github.com/juancarlosriveracuadros/Slowly_Changing_Dimention_Type_2_SQL_Server_SCD2/blob/main/2_SP_SCD2.sql
https://www.postgresql.org/docs/11/sql-createprocedure.html
https://www.postgresql.org/docs/11/plpgsql-cursors.html 
https://www.postgresqltutorial.com/plpgsql-cursor/
----------------------------------------------------------------
*/

CREATE OR REPLACE PROCEDURE spDimProducto()
LANGUAGE plpgsql
AS $$
	Declare		
		a_LINEA_NOMBRE TEXT;
		a_LINEA INT;
		a_LINEA_DESCRIPCION TEXT; 
		a_GRUPO_NOMBRE TEXT;
		a_GRUPO INT;
		a_GRUPO_DESCRIPCION TEXT; 
		a_PRODUCTO BIGINT;
		a_MARCA TEXT;
		a_HashKey_BK TEXT;
		a_Hashkey_Data TEXT;
		
		cur_SCD2  cursor for
		SELECT LINEA_NOMBRE, LINEA, LINEA_DESCRIPCION, GRUPO_NOMBRE, GRUPO, GRUPO_DESCRIPCION, PRODUCTO, MARCA, HashKey_BK, Hashkey_Data
		from CLEANING.PRODUCTO;

	Begin
		open cur_SCD2;
		FETCH cur_SCD2 INTO a_LINEA_NOMBRE, a_LINEA, a_LINEA_DESCRIPCION, a_GRUPO_NOMBRE, a_GRUPO, a_GRUPO_DESCRIPCION, a_PRODUCTO, a_MARCA, a_Hashkey_BK, a_Hashkey_Data;
		WHILE (FOUND) loop	
					IF a_Hashkey_BK in (SELECT PRO_HashKey_BK FROM CORE.dim_producto) and a_HashKey_Data not in (SELECT PRO_HashKey_Data FROM CORE.dim_producto) and (a_HashKey_BK is not null) THEN

						UPDATE CORE.dim_producto
						SET	pro_Valid_To = (select current_date), 
							pro_Current_Flag = 'N', 
							pro_DML_Strat = 'HIST_UPD', 
							pro_ModifiedDate = (select current_date) 
						WHERE pro_HashKey_BK = a_HashKey_BK;
						
						INSERT INTO CORE.DIM_producto 
						(PRO_LINEA_NOMBRE
						,PRO_LINEA
						,PRO_LINEA_DESCRIPCION
						,PRO_GRUPO_NOMBRE
						,PRO_GRUPO
						,PRO_GRUPO_DESCRIPCION
						,PRO_PRODUCTO
						,PRO_MARCA
						,PRO_HashKey_BK
						,PRO_Hashkey_Data
						,PRO_Valid_From
						,PRO_Valid_To
						,PRO_Current_Flag
						,PRO_DML_Strat
						,PRO_DATA_Source
						,PRO_ModifiedDate)
						 VALUES
						 (a_LINEA_NOMBRE,
						  a_LINEA,
						  a_LINEA_DESCRIPCION,
						  a_GRUPO_NOMBRE,
						  a_GRUPO,
						  a_GRUPO_DESCRIPCION,
						  a_PRODUCTO,
						  a_MARCA,
						  a_HASHKEY_BK,
						  a_HASHKEY_DATA,
						 (select current_date),
						 '9999-12-30',
						 'Y',
						 'HIST_INS',
						 'CLEANING.PRODUCTO',
						 (select current_date));
						 
					ELSIF a_Hashkey_BK not in (SELECT PRO_HashKey_BK FROM CORE.dim_producto) THEN
						INSERT INTO CORE.DIM_PRODUCTO
						(PRO_LINEA_NOMBRE
						,PRO_LINEA
						,PRO_LINEA_DESCRIPCION
						,PRO_GRUPO_NOMBRE
						,PRO_GRUPO
						,PRO_GRUPO_DESCRIPCION
						,PRO_PRODUCTO
						,PRO_MARCA
						,PRO_HashKey_BK
						,PRO_Hashkey_Data
						,PRO_Valid_From
						,PRO_Valid_To
						,PRO_Current_Flag
						,PRO_DML_Strat
						,PRO_DATA_Source
						,PRO_ModifiedDate)
						 VALUES
						 (a_LINEA_NOMBRE,
						  a_LINEA,
						  a_LINEA_DESCRIPCION,
						  a_GRUPO_NOMBRE,
						  a_GRUPO,
						  a_GRUPO_DESCRIPCION,
						  a_PRODUCTO,
						  a_MARCA,
						  a_HASHKEY_BK,
						  a_HASHKEY_DATA,
						 (select current_date),
						 '9999-12-30',
						 'Y',
						 'INS',
						 'CLEANING.PRODUCTO',
						 (select current_date));
					ELSE
					RAISE NOTICE 'existing data --> HashKey_BK : %, HashKey_Data : %', a_HashKey_BK, a_Hashkey_Data;
				END IF;
		FETCH cur_SCD2 INTO a_LINEA_NOMBRE, a_LINEA, a_LINEA_DESCRIPCION, a_GRUPO_NOMBRE, a_GRUPO, a_GRUPO_DESCRIPCION, a_PRODUCTO, a_MARCA, a_Hashkey_BK, a_Hashkey_Data;
		end loop;
		close cur_scd2;
	End; $$;
