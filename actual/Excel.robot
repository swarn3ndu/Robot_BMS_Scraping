*** Settings ***
Library     RPA.Excel.Files
Library     RPA.JSON
Library     file.py
Library     RPA.RobotLogListener
Resource    resources.robot
Resource    system.robot


*** Keywords ***
Write JSON to Excel
    [Arguments]    ${json_file}    ${excel_file}    ${sheet_name}
    ${temp}=    RPA.JSON.Load JSON from file    ${json_file}
    ${condition}=    Evaluate    len(${temp}) < 1
    IF    ${condition}    RETURN

    ${fileExists}=    File Exists    ${excel_file}
    IF    ${fileExists} is True
        Log    File Exsists Overwriting
        Open Workbook    ${excel_file}
    ELSE
        Create Workbook    ${excel_file}
    END

    ${json_data}=    Convert To Dictionary    ${temp}
    @{keys}=    Get Dictionary Keys    ${json_data}    sort_keys=True
    ${elementAtIndexZero}=    Get From List    ${keys}    0
    ${temp}=    Get From Dictionary    ${json_data}    ${elementAtIndexZero}
    @{attributes}=    Get Dictionary Keys    ${temp}    sort_keys=True

    ${Does_Worksheet_Exist}=    Worksheet Exists    ${sheet_name}

    IF    ${Does_Worksheet_Exist}
        Set Active Worksheet    ${sheet_name}
    ELSE
        Create Worksheet    ${sheet_name}
    END

    ${row}=    Set Variable    1
    ${col}=    Set Variable    1

    #Write the Coloumn Headers
    FOR    ${attribute}    IN    @{attributes}
        Set Cell Value    ${row}    ${col}    ${attribute}
        ${col}=    Evaluate    ${col} + 1
    END
    ${col}=    Set Variable    1
    ${row}=    Evaluate    ${row} + 1

    #Write the actual Values
    FOR    ${key}    IN    @{keys}
        ${temp}=    Get From Dictionary    ${json_data}    ${key}
        @{values}=    Get Dictionary Values    ${temp}    sort_keys=True
        FOR    ${value}    IN    @{values}
            Set Cell Value    ${row}    ${col}    ${value}
            ${col}=    Evaluate    ${col} + 1
        END
        ${col}=    Set Variable    1
        ${row}=    Evaluate    ${row} + 1
    END
    Save Workbook
    Close Workbook
