
/* 
Author:			Juan Carlos Rivera Cuadros
Create date:	12/01/2021
Description:	SCD2 for Fact Table Ventas diarias 
----------------------------------------------------------------
Sources

https://www.youtube.com/playlist?list=PL8gxzfBmzgex2nuVanqvxoTXTPovVSwi2
https://github.com/juancarlosriveracuadros/Slowly_Changing_Dimention_Type_2_SQL_Server_SCD2/blob/main/2_SP_SCD2.sql
https://www.postgresql.org/docs/11/sql-createprocedure.html
https://www.postgresql.org/docs/11/plpgsql-cursors.html 
https://www.postgresqltutorial.com/plpgsql-cursor/
----------------------------------------------------------------
*/

CREATE OR REPLACE PROCEDURE spFacVentasDiarias()
LANGUAGE plpgsql
AS $$
	Declare		
		a_FECHA DATE;
		a_VENDED INT;
		a_PRODUCTO BIGINT;
		a_REFERENCIA TEXT;
		a_DESCRIPCION TEXT;
		a_CANTIDAD FLOAT;
		a_VALOR FLOAT;
		a_HashKey_BK TEXT;
		a_Hashkey_Data TEXT;

		cur_SCD2  cursor for
		SELECT FECHA, VENDED, PRODUCTO, REFERENCIA, DESCRIPCION, CANTIDAD, VALOR, HashKey_BK, Hashkey_Data
		FROM CLEANING.VentasDiarias;

	Begin
		open cur_SCD2;
		FETCH cur_SCD2 INTO a_FECHA, a_VENDED, a_PRODUCTO, a_REFERENCIA, a_DESCRIPCION, a_CANTIDAD, a_VALOR, a_HashKey_BK, a_Hashkey_Data;
		
		WHILE (FOUND) loop	
					IF a_Hashkey_BK in (SELECT VED_HashKey_BK FROM CORE.fac_ventasdiarias) and a_HashKey_Data not in (SELECT VED_HashKey_Data FROM CORE.fac_ventasdiarias) and (a_HashKey_BK is not null) THEN

						UPDATE CORE.fac_ventasdiarias
						SET	ved_Valid_To = (select current_date), 
							ved_Current_Flag = 'N', 
							ved_DML_Strat = 'HIST_UPD', 
							ved_ModifiedDate = (select current_date) 
						WHERE ved_HashKey_BK = a_HashKey_BK;						
						INSERT INTO CORE.fac_ventasdiarias
						(VED_FECHA
						,VED_VENDED
						,VED_PRODUCTO
						,VED_REFERENCIA
						,VED_DESCRIPCION
						,VED_CANTIDAD
						,VED_VALOR
						,VED_HashKey_BK
						,VED_Hashkey_Data
						,VED_Valid_From
						,VED_Valid_To
						,VED_Current_Flag
						,VED_DML_Strat
						,VED_DATA_Source
						,VED_ModifiedDate)
						 VALUES
						 (
						a_FECHA,
						a_VENDED,
						a_PRODUCTO,
						a_REFERENCIA,
						a_DESCRIPCION,
						a_CANTIDAD,
						a_VALOR,
						a_HashKey_BK,
						a_Hashkey_Data,
						 (select current_date),
						 '9999-12-30',
						 'Y',
						 'HIST_INS',
						 'CLEANING.VentasDiarias',
						 (select current_date));
						 
					ELSIF a_Hashkey_BK not in (SELECT VED_HashKey_BK FROM CORE.fac_ventasdiarias) THEN
						INSERT INTO CORE.fac_ventasdiarias
						(VED_FECHA
						,VED_VENDED
						,VED_PRODUCTO
						,VED_REFERENCIA
						,VED_DESCRIPCION
						,VED_CANTIDAD
						,VED_VALOR
						,VED_HashKey_BK
						,VED_Hashkey_Data
						,VED_Valid_From
						,VED_Valid_To
						,VED_Current_Flag
						,VED_DML_Strat
						,VED_DATA_Source
						,VED_ModifiedDate)
						 VALUES
						 (
						a_FECHA,
						a_VENDED,
						a_PRODUCTO,
						a_REFERENCIA,
						a_DESCRIPCION,
						a_CANTIDAD,
						a_VALOR,
						a_HashKey_BK,
						a_Hashkey_Data,
						 (select current_date),
						 '9999-12-30',
						 'Y',
						 'INS',
						 'CLEANING.VentasDiarias',
						 (select current_date));
					ELSE
					RAISE NOTICE 'existing data --> HashKey_BK : %, HashKey_Data : %', a_HashKey_BK, a_Hashkey_Data;
				END IF;
		FETCH cur_SCD2 INTO a_FECHA, a_VENDED, a_PRODUCTO, a_REFERENCIA, a_DESCRIPCION, a_CANTIDAD, a_VALOR, a_HashKey_BK, a_Hashkey_Data;
		end loop;
		close cur_scd2;
	End; $$;
	
