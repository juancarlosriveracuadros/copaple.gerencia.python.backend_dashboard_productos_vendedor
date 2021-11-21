# -*- coding: utf-8 -*-
"""
Created on Wed Jan 13 10:41:35 2021

@author: Juan Carlos Rivera C
"""

import psycopg2
from etl import load_VentasDiarias_DWH
from data_detection import data_detection_datalake

def main():
    #data information
    folder_path = r"C:\dev\copaple.gerencia.python.dashboard_productos_vendedor\data"
    
    
    # Data base conection
    conn = psycopg2.connect("host=127.0.0.1 dbname=VentasDiariasCopapel user=postgres \
                            password=Password")
    
    conn.set_session(autocommit=True)
    cur = conn.cursor()
    
    # Load Tables
    data = data_detection_datalake(folder_path)

    # etl pipeline
    for index, row in data.iterrows():
        print('Current table, name: '+ row.file_name + ' sheet: ' + row.excel_sheet)
        load_VentasDiarias_DWH(cur, conn, row.excel_file, row.excel_sheet)

    conn.close()


if __name__ == "__main__":
    main()