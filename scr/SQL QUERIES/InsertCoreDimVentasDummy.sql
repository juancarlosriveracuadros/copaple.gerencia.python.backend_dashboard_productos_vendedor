INSERT INTO core.dim_vended
	(VEN_VENDED 
	,VEN_ZONA
	,VEN_CIUDAD 
	,VEN_NOMBRE 
	,VEN_HashKey_BK
	,VEN_Hashkey_Data
	,VEN_current_flag
	,VEN_dml_strat
	,VEN_DATA_Source
	,VEN_ModifiedDate
	)
values
	('0' 
	,'0'
	,'xx' 
	,'xx' 
	,'xx'
	,'1'
	,'xx'
	,'xx'
	,now()
	,NOW()
);

--select * from core.dim_vended;