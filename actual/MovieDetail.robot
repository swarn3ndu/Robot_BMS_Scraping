*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem
Library     Collections
Library     String
Library     JSONLibrary
Library     RPA.Excel.Files
Resource    resources.robot
Resource    system.robot


*** Variables ***
${FilterUpcoming}           //span[@color = '#FFFFFF' and contains(text(),'Releasing')]
${FilterReleaseDate}        //h1/parent::div/section/div[2]/div[2]//span

${FilterInCinemas}          //section[@type]/div/span
${rating}                   //h1/following-sibling::section/div/span
${MovieNameFilter}          //h1
${MovieSynopsisFilter}      //h4[text()='About the movie']/following-sibling::div//span
${MovieGenreFilter}         //h1/parent::div/div/div[2]
${MovieCastFilter}          //h4[text()='Cast']/ancestor-or-self::section//h5[1]

#${InCinema_dict}=    %{InCinema_dict}
#${ComingSoon_dict}=    %{ComingSoon_dict}


*** Keywords ***
Get Texts
    [Arguments]    ${xpath}
    ${text_list}=    Set Variable    ${EMPTY}
    ${temp}=    Set Variable    ${EMPTY}
    @{element_list}=    Get Webelements    ${xpath}
    FOR    ${element}    IN    @{element_list}
        ${temp}=    Get Text    locator=${element}
        ${text_list}=    Catenate    SEPARATOR= ,    ${text_list} ${temp}
    END
    RETURN    ${text_list}

MovieInCinemas
    ${text}=    Get Text    xpath=${FilterInCinemas}
    ${return}=    Evaluate    ${text} == 'In Cinemas'
    RETURN    ${return}

Fetch Movie Details
    ${text}=    Get Text    xpath=${FilterInCinemas}
    ${return}=    Evaluate    """${text}""" == "In cinemas"
    IF    ${return} == True
        Run Keyword And Ignore Error    Fetch Movie Details From Cinemas
    ELSE
        Run Keyword And Ignore Error    Fetch Movie Details From Coming Soon
    END
    Dump Json To File    ${InCinemasJSONFilePath}    ${InCinema_dict}
    DUmp Json To File    ${ComingSoonJSONFilePath}    ${ComingSoon_dict}

Fetch Movie Details From Cinemas
    ${movieName}=    Get Text    xpath=${MovieNameFilter}
    TRY
        ${movieRating}=    Get Text    xpath=${rating}
    EXCEPT    message
        ${movieRating}= Set Variable    0
    END
    ${temp}=    Get Text    xpath=${MovieGenreFilter}
    @{temps}=    Split String    ${temp}    \n
    ${movieDuration}=    Get From List    ${temps}    0
    ${movieGenre}=    Get From List    ${temps}    2
    ${movieRelease}=    Get From List    ${temps}    -1
    ${movieSynopsis}=    Get Text    xpath=${MovieSynopsisFilter}
    ${movieCast}=    Get Texts    xpath=${MovieCastFilter}

    ${movie_dict}=    Create Dictionary
    ...    Name=${movieName}
    ...    Rating=${movieRating}
    ...    Duration=${movieDuration}
    ...    Genre=${movieGenre}
    ...    Release=${movieRelease}
    ...    Synopsis=${movieSynopsis}
    ...    Cast=${movieCast}
    Set To Dictionary    ${InCinema_dict}    ${movieName}    ${movie_dict}

Fetch Movie Details From Coming Soon
    ${movieName}=    Get Text    xpath=${MovieNameFilter}
    ${movieRelease}=    Get Text    ${FilterReleaseDate}
    ${movieSynopsis}=    Get Text    xpath=${MovieSynopsisFilter}
    ${movieCast}=    Get Texts    xpath=${MovieCastFilter}

    ${movie_dict}=    Create Dictionary
    ...    Name=${movieName}
    ...    Release=${movieRelease}
    ...    Synopsis=${movieSynopsis}
    ...    Cast=${movieCast}
    Set To Dictionary    ${ComingSoon_dict}    ${movieName}    ${movie_dict}

Save Data To Excel File
    [Arguments]    ${ExcelFileName}
    ${filepath}=    Join Path    ${CURDIR}    \output\    ${ExcelFileName}
    Create Workbook    ${ExcelFileName}
    Create Worksheet    name=In_Cinemas    content=${InCinema_dict}

    Create Worksheet    name=Coming_Soon    content=${ComingSoon_dict}
    Save Workbook
