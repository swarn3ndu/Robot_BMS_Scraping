import os
import RPA.Excel.Files as Excel


def file_exists(file):
    return os.path.isfile(file)


def Create_Sheet(sheet_name):
    sheets = Excel.list_worksheets()
    if sheet_name in sheets:
        Excel.remove_worksheet(sheet_name)

    Excel.create_worksheet(sheet_name)
