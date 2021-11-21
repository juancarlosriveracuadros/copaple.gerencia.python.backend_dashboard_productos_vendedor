-- PROCEDURE: public.spfacventasdiarias()

-- DROP PROCEDURE public.spfacventasdiarias();

CREATE OR REPLACE PROCEDURE PUBLIC.spfacventasdiarias_scd1()
LANGUAGE plpgsql
as
$$
Begin
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
						--,VED_Valid_To
						,VED_Current_Flag
						,VED_DML_Strat
						,VED_DATA_Source
						,VED_ModifiedDate)
				(SELECT	FECHA,
						VENDED,
						PRODUCTO,
						REFERENCIA,
						DESCRIPCION,
						CANTIDAD,
						VALOR,
						HashKey_BK,
						Hashkey_Data,
						(select current_date),
						--'9999-12-30',
						'Y',
						'INS',
						'CLEANING.VentasDiarias',
						(select current_date)
				FROM	CLEANING.VentasDiarias
				WHERE	NOT EXISTS
				(
					SELECT	VED_HashKey_BK
					FROM	CORE.fac_ventasdiarias
					WHERE	(CLEANING.VentasDiarias.HashKey_BK = CORE.fac_ventasdiarias.VED_HashKey_BK
					AND CLEANING.VentasDiarias.Hashkey_Data = CORE.fac_ventasdiarias.VED_Hashkey_Data)
					
				));
end;
$$