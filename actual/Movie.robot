*** Settings ***
Library             SeleniumLibrary
Library             OperatingSystem
Library             RPA.JSON
Resource            resources.robot
Resource            system.robot
Resource            MovieDetail.robot
Resource            Excel.robot

Suite Setup         Run Keywords    Configure Selenium    Configure Variables
Suite Teardown      Exit Selenium


*** Test Cases ***
Get Movie Names
    Fetch Script Tab Text    ${SiteUrl}    ${BROWSER}
    Close Browser

Extract Movie Names and Link
    &{json_data}=    RPA.JSON.Load JSON from file    %{JSON_FILENAME}
    ${JSONPathEpression}=    Set Variable    $..ctaUrl
    @{URLS}=    Get values from JSON    ${json_data}    ${JSONPathEpression}
    ${counter}=    Set Variable    1
    FOR    ${url}    IN    @{URLS}
        ${contains}=    Evaluate    "/movies/" in """${url}"""
        IF    ${contains} == True
            Navigate To Page    ${url}
            Fetch Movie Details
            Close Browser
            ${counter}=    Evaluate    ${counter} + 1
            IF    ${counter} > ${MaxMovieRetrive}                BREAK
        END
    END
    Write JSON to Excel    ${InCinemasJSONFilePath}    ${MovieExcelFilePath}    In Cinemas
    Write JSON to Excel    ${ComingSoonJSONFilePath}    ${MovieExcelFilePath}    Coming Soon
