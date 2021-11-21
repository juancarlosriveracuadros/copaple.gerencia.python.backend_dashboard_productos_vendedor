
/* 
Author:			Juan Carlos Rivera Cuadros
Create date:	12/01/2021
Description:	SCD2 for Table vended
----------------------------------------------------------------
Sources

https://www.youtube.com/playlist?list=PL8gxzfBmzgex2nuVanqvxoTXTPovVSwi2
https://github.com/juancarlosriveracuadros/Slowly_Changing_Dimention_Type_2_SQL_Server_SCD2/blob/main/2_SP_SCD2.sql
https://www.postgresql.org/docs/11/sql-createprocedure.html
https://www.postgresql.org/docs/11/plpgsql-cursors.html 
https://www.postgresqltutorial.com/plpgsql-cursor/
----------------------------------------------------------------
*/

CREATE OR REPLACE PROCEDURE spDimVended()
LANGUAGE plpgsql
AS $$
	Declare 
		a_VENDED INT;
		a_ZONA INT;
		a_CIUDAD TEXT;
		a_NOMBRE TEXT;
		a_HashKey_BK TEXT;
		a_Hashkey_Data TEXT;
		
		cur_SCD2  cursor for
		select VENDED, ZONA, CIUDAD, NOMBRE, HashKey_BK, Hashkey_Data 
		from CLEANING.VENDED;

	Begin
		open cur_SCD2;
		FETCH cur_SCD2 INTO a_VENDED, a_ZONA, a_CIUDAD, a_NOMBRE, a_HashKey_BK, a_Hashkey_Data;
		WHILE (FOUND) loop
			Declare
				a_VEN_VENDED INT; a_VEN_ZONA INT; a_VEN_CIUDAD TEXT;a_VEN_NOMBRE TEXT; a_VEN_HashKey_BK TEXT; a_VEN_HashKey_Data TEXT;
			Begin
				SELECT  VEN_VENDED, VEN_ZONA, VEN_CIUDAD, VEN_NOMBRE, VEN_HashKey_Data INTO
				a_VEN_VENDED, a_VEN_ZONA, a_VEN_NOMBRE, a_VEN_HashKey_Data
				FROM CORE.Dim_VENDED
				WHERE a_HashKey_BK = VEN_HashKey_BK and a_HashKey_BK is not NULL;			
				
					IF a_Hashkey_BK in (SELECT VEN_HashKey_BK FROM CORE.dim_vended) and a_HashKey_Data not in (SELECT VEN_HashKey_Data FROM CORE.dim_vended) and (a_HashKey_BK is not null) THEN

						UPDATE CORE.DIM_VENDED
						SET	VEN_Valid_To = (select current_date), 
							VEN_Current_Flag = 'N', 
							VEN_DML_Strat = 'HIST_UPD', 
							VEN_ModifiedDate = (select current_date) 
						WHERE VEN_HashKey_BK = a_HashKey_BK;
						
						INSERT INTO CORE.DIM_VENDED
						(VEN_VENDED,
						 VEN_ZONA,
						 VEN_CIUDAD,
						 VEN_NOMBRE,
						 VEN_HASHKEY_BK,
						 VEN_HASHKEY_DATA,
						 VEN_VALID_FROM,
						 VEN_VALID_TO,
						 VEN_CURRENT_FLAG,
						 VEN_DML_STRAT,
						 VEN_DATA_SOURCE,
						 VEN_MODIFIEDDATE)
						 VALUES
						 (a_VENDED,
						 a_ZONA,
						 a_CIUDAD,
						 a_NOMBRE,
						 a_HASHKEY_BK,
						 a_HASHKEY_DATA,
						 (select current_date),
						 '9999-12-30',
						 'Y',
						 'HIST_INS',
						 'CLEANING.VENDED',
						 (select current_date));
						 
					ELSIF a_Hashkey_BK not in (SELECT VEN_HashKey_BK FROM CORE.dim_vended) THEN
						INSERT INTO CORE.DIM_VENDED
						(VEN_VENDED,
						 VEN_ZONA,
						 VEN_CIUDAD,
						 VEN_NOMBRE,
						 VEN_HASHKEY_BK,
						 VEN_HASHKEY_DATA,
						 VEN_VALID_FROM,
						 VEN_VALID_TO,
						 VEN_CURRENT_FLAG,
						 VEN_DML_STRAT,
						 VEN_DATA_SOURCE,
						 VEN_MODIFIEDDATE)
						 VALUES
						 (a_VENDED,
						 a_ZONA,
						 a_CIUDAD,
						 a_NOMBRE,
						 a_HASHKEY_BK,
						 a_HASHKEY_DATA,
						 (select current_date),
						 '9999-12-30',
						 'Y',
						 'INS',
						 'CLEANING.VENDED',
						 (select current_date));
					ELSE
					RAISE NOTICE 'existing data --> HashKey_BK : %, HashKey_Data : %', a_HashKey_BK, a_Hashkey_Data;
				END IF;
			END;
		FETCH cur_SCD2 INTO a_VENDED, a_ZONA, a_CIUDAD, a_NOMBRE, a_HashKey_BK, a_Hashkey_Data;
		end loop;
		close cur_scd2;
	End; $$;
