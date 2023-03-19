*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem
Library     Collections
Library     String
Library     JSONLibrary
Library     RPA.Excel.Files
Resource    MovieDetail.robot
Resource    resources.robot


*** Keywords ***
Configure Selenium
    Set Selenium Speed    .5 Seconds

Configure Variables
    ${InCinema_dict}=    Create Dictionary
    ${ComingSoon_dict}=    Create Dictionary
    Set Suite Variable    ${InCinema_dict}
    Set Suite Variable    ${ComingSoon_dict}
    #Set environment variable    InCinema_dict    ${InCinema_dict}
    #Set environment variable    ComingSoon_dict    ${ComingSoon_dict}

Navigate To Page
    [Arguments]    ${arg1}    ${arg2}=${Browser}
    Open Browser    ${arg1}    ${arg2}
    Maximize Browser Window

Exit Selenium
    Capture Page Screenshot
    Close Browser

Generate Random Number
    ${random_number}=    Evaluate    random.randint(1000000, 9999999)    random
    RETURN    ${random_number}

Initialize
    set global variable    PYTHONPATH    /venv/

Fetch Script Tab Text
    [Arguments]    ${SiteUrl}    ${BROWSER}=${Browser}
    Navigate To Page    ${SiteUrl}    ${BROWSER}
    ${scriptText}=    Execute Javascript    ${ScriptTag}
    ${substring}=    Replace String    ${scriptText}    ${search_for}    ${EMPTY}    count=1
    ${substring}=    Replace String    ${substring}    =    ${EMPTY}    count=1
    ${json_data}=    JSONLibrary.Convert String To Json    ${substring}
    @{json_fileName_List}=    Split String From Right    string=${SiteUrl}    separator=/    max_split=1
    ${json_fileName}=    Catenate    ${json_fileName_List}[1].json
    Set environment variable    JSON_FILENAME    ${json_fileName}
    Dump Json To File    ${json_fileName}    ${json_data}
