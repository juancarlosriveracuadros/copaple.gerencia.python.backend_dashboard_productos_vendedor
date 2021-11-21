# -*- coding: utf-8 -*-
"""
Created on: Wed Jan 13 07:50:46 2021

@author: Juan Carlos Rivera C

Description: In this scripte you will find all the sql queries for the Data Warehouse 
"""

#______________________________________________________________________________

##Stage


Insert_Stage_VentasDiarias = (
"INSERT INTO stage.ventasdiarias(\
    FECHA\
    ,ZONA\
    ,VENDED\
    ,CIUDAD\
    ,NOMBRE\
    ,LINEA_NOMBRE\
    ,LINEA,LINEA_DESCRIPCION\
    ,GRUPO_NOMBRE\
    ,GRUPO,GRUPO_DESCRIPCION\
    ,PRODUCTO\
    ,REFERENCIA\
    ,DESCRIPCION\
    ,MARCA,CANTIDAD\
    ,VALOR,DATA_SOURCE\
    ,MODIFIEDDATE)\
    VALUES(\
    TO_DATE('"'{}'"','YYYY-MM-DD')\
    ,NULLIF('"'{}'"','')::integer\
    ,NULLIF('"'{}'"','')::integer\
    ,'"'{}'"'\
    ,'"'{}'"'\
    ,'"'{}'"'\
    ,{}\
    ,'"'{}'"'\
    ,'"'{}'"'\
    ,{}\
    ,'"'{}'"'\
    ,{}\
    ,'"'{}'"'\
    ,'"'{}'"'\
    ,'"'{}'"'\
    ,NULLIF('"'{}'"','')::float\
    ,NULLIF('"'{}'"','')::float\
    ,'"'{}'"'\
    ,NOW()\
    );")

#______________________________________________________________________________
      
## Cleaning

Insert_Cleaning_Producto = ("INSERT INTO CLEANING.PRODUCTO \
(LINEA_NOMBRE \
,LINEA \
,LINEA_DESCRIPCION \
,GRUPO_NOMBRE \
,GRUPO \
,GRUPO_DESCRIPCION \
,PRODUCTO \
,MARCA \
,HashKey_BK \
,Hashkey_Data \
,DATA_Source \
,ModifiedDate) \
SELECT DISTINCT \
LINEA_NOMBRE \
,LINEA \
,LINEA_DESCRIPCION \
,GRUPO_NOMBRE \
,GRUPO \
,GRUPO_DESCRIPCION \
,PRODUCTO \
,MARCA \
,md5(PRODUCTO::text) \
,md5(concat_ws('"'__'"', LINEA_NOMBRE, LINEA, LINEA_DESCRIPCION, GRUPO_NOMBRE, GRUPO, GRUPO_DESCRIPCION ,MARCA)) \
,'"'STAGE.VENTASDIARIAS'"' \
 ,NOW() \
FROM STAGE.VentasDiarias \
ORDER BY LINEA_DESCRIPCION;\
")     
        
Insert_Cleaning_Vended = ("INSERT INTO CLEANING.VENDED \
(VENDED \
,ZONA \
,CIUDAD \
,NOMBRE \
,HashKey_BK \
,Hashkey_Data \
,DATA_Source \
,ModifiedDate) \
SELECT DISTINCT \
VENDED \
,ZONA \
,CIUDAD \
,NOMBRE \
,md5(VENDED::text) \
,md5(concat_ws('"'__'"', ZONA, CIUDAD ,NOMBRE)) \
,'"'STAGE.VENTASDIARIAS'"' \
,NOW() \
FROM STAGE.VentasDiarias \
ORDER BY ZONA;")

Insert_Cleaning_Ventasdiarias = ("INSERT INTO CLEANING.VENTASDIARIAS \
(FECHA \
,VENDED \
,PRODUCTO \
,REFERENCIA \
,DESCRIPCION \
,CANTIDAD \
,VALOR \
,HashKey_BK \
,Hashkey_Data \
,DATA_Source \
,ModifiedDate) \
SELECT DISTINCT \
FECHA \
,VENDED \
,PRODUCTO \
,REFERENCIA \
,DESCRIPCION \
,CANTIDAD \
,VALOR \
,md5(concat_ws('"'__'"',VENDED,PRODUCTO,REFERENCIA,DESCRIPCION, EXTRACT(year from FECHA), EXTRACT(month from FECHA))) \
,md5(concat_ws('"'__'"',CANTIDAD,VALOR, VENDED,PRODUCTO,REFERENCIA,DESCRIPCION, EXTRACT(year from FECHA), EXTRACT(month from FECHA)))\
,'"'STAGE.VENTASDIARIAS'"' \
,NOW() \
FROM STAGE.VentasDiarias\
;")

#______________________________________________________________________________

# Core

SCD2_Dim_Producto = ('call spDimProducto();')
SCD2_Dim_Vended = ('call spdimvended();')
SCD2_Fac_VentasDiarias = ('call spfacventasdiarias();')
#______________________________________________________________________________

#Truncate Tables
Truncate_Stage_Ventasdiarias = ('truncate table STAGE.VENTASDIARIAS;')
Truncate_Cleaning_Producto = ('TRUNCATE TABLE CLEANING.producto;')
Truncate_Cleaning_Vended = ('TRUNCATE TABLE CLEANING.vended;')
Truncate_Cleaning_VentasDiarias=('TRUNCATE TABLE CLEANING.ventasdiarias;')

#_____________________________________________________________________________

#Query List
 
Insert_Cleaning = [Insert_Cleaning_Producto,
                   Insert_Cleaning_Vended, \
                   Insert_Cleaning_Ventasdiarias]

Insert_Core = [SCD2_Dim_Producto, \
               SCD2_Dim_Vended, \
               SCD2_Fac_VentasDiarias]

Truncate_Tables = [Truncate_Stage_Ventasdiarias, \
                   Truncate_Cleaning_Producto, \
                   Truncate_Cleaning_Vended, \
                   Truncate_Cleaning_VentasDiarias]
 