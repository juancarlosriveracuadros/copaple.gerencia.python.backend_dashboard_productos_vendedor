--drop table cleaning.vended;
CREATE TABLE IF NOT EXISTS CORE.DIM_VENDED
	(VEN_VENDED INT
	,VEN_ZONA INT
	,VEN_CIUDAD TEXT
	,VEN_NOMBRE TEXT
	,VEN_HashKey_BK TEXT
	,VEN_Hashkey_Data TEXT
	,VEN_Valid_From TIMESTAMP
	,VEN_Valid_To TIMESTAMP
	,VEN_Current_Flag varchar(5)
	,VEN_DML_Strat varchar(30)
	,VEN_DATA_Source TEXT
	,VEN_ModifiedDate TIMESTAMP);