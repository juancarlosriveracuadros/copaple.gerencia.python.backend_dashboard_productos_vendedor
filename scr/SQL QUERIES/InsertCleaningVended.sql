INSERT INTO CLEANING.VENDED
	(VENDED 
	,ZONA
	,CIUDAD 
	,NOMBRE 
	,HashKey_BK
	,Hashkey_Data
	,DATA_Source
	,ModifiedDate)
SELECT DISTINCT
	VENDED 
	,ZONA
	,CIUDAD 
	,NOMBRE 
	,md5(VENDED::text)
	,md5(concat_ws('__', ZONA, CIUDAD ,NOMBRE))
	,'STAGE.VENTASDIARIAS'
	,NOW()
FROM STAGE.VentasDiarias
ORDER BY ZONA;