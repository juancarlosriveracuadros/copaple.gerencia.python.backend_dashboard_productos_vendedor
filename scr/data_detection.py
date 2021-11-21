# -*- coding: utf-8 -*-
"""
Created on Wed Jan 13 12:37:44 2021

@author: Juan Carlos Rivera C

Description: find the excel data to be load
"""

import pandas as pd 
import re
#import itertools
import numpy as np
import os



def data_detection_datalake(folder_path):
    file_list = os.listdir(folder_path)
    file_list_pandas = [ file for file in file_list if ".xlsx" in file]
    
    excels_to_read = []

    for excel_file in file_list_pandas: 

        # Read Excel file
        excel_path = os.path.join(folder_path,excel_file)
        xl = pd.ExcelFile(excel_path)
        xl_sheets = [sheet for sheet in xl.sheet_names if re.search("\d",sheet)]
        print(" Reading excel", excel_path, ", number of sheets", len(xl_sheets))
        n_sheets = len(xl_sheets)

        # Create Data Frame
        excel_to_read = pd.DataFrame({'excel_file' : np.repeat(excel_path, n_sheets), 'excel_sheet': xl_sheets, 'file_name':excel_file})
        excels_to_read.append(excel_to_read)
    df_excels = pd.concat(excels_to_read).reset_index(drop= True)
    return df_excels