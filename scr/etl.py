# -*- coding: utf-8 -*-
"""
Created on: Wed Jan 13 09:18:01 2021

@author: Juan Carlos Rivera C

Description: function and orchestration ETLS of the Data Warehouse 
"""

from sql_queries import Insert_Stage_VentasDiarias, Insert_Cleaning, Insert_Core, Truncate_Tables 
import pandas as pd

#______________________________________________________________________________

# Load the data of a Excel Table in a data frame and clean the data

def data_cleaning(path_file, sheet_number):
    
    vent1 = pd.read_excel(path_file, sheet_name=sheet_number)
    n = 0
    # Clean from spaces, '-', replications in the columns name
    for item in vent1.columns:
        vent1 = vent1.rename(columns = {item:item.translate({ord(' '): None})})
        item = item.translate({ord(' '): None})
        vent1 = vent1.rename(columns = {item:item.translate({ord('-'): ('_')})})
        item = item.translate({ord('-'): ('_')})
        vent1 = vent1.rename(columns = {item:item.translate({ord('.'): ('_')})})
        item = item.translate({ord('.'): ('_')})
        if 'DESCRIPCION' in item :
            vent1 = vent1.rename(columns = {item:('DESCRIPCION_'+ str(n))})
            n = 1 + n
    
    # Clean from spaces in the values
    for index, row in vent1.iterrows():
        i = 0
        for item in row:
            try:
                vent1.loc[index,vent1.columns[i]] = item.strip()
            except Exception:
                pass
            i = i+1
    return vent1

#______________________________________________________________________________


def load_VentasDiarias_DWH(cur, conn, path_file, sheet_number):
    
    # Stage
    df = data_cleaning(path_file, sheet_number)
    
    for i, row in df.iterrows():
        cur.execute(Insert_Stage_VentasDiarias.format(row.FECHA.date(), row.ZONA, row.VENDED, row.CIUDAD, row.NOMBRE, row.LINEA_NOMBRE, row.LINEA, row.DESCRIPCION_0, row.GRUPO_NOMBRE, row.GRUPO, row.DESCRIPCION_1, row.PRODUCTO, row.REFERENCIA, row.DESCRIPCION_2, row.MARCA, row.CANTIDAD, row.VALOR, path_file))
    
    # Cleaning
    for query1 in Insert_Cleaning:
        cur.execute(query1)
        conn.commit()
    
    # Core
    for query2 in Insert_Core:
        cur.execute(query2)
        conn.commit()
    
    #Truncate Table
    for query3 in Truncate_Tables:
        cur.execute(query3)
        conn.commit()
    
    

    
    