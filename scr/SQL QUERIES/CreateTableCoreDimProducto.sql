CREATE TABLE IF NOT EXISTS core.dim_PRODUCTO
	(PRO_LINEA_NOMBRE TEXT 
	,PRO_LINEA INT
	,PRO_LINEA_DESCRIPCION TEXT 
	,PRO_GRUPO_NOMBRE TEXT
	,PRO_GRUPO INT
	,PRO_GRUPO_DESCRIPCION TEXT
	,PRO_PRODUCTO BIGINT
	,PRO_MARCA TEXT 
	,PRO_HashKey_BK TEXT
	,PRO_Hashkey_Data TEXT
	,PRO_Valid_From TIMESTAMP
	,PRO_Valid_To TIMESTAMP
	,PRO_Current_Flag varchar(5)
	,PRO_DML_Strat varchar(30)
	,PRO_DATA_Source TEXT
	,PRO_ModifiedDate TIMESTAMP);