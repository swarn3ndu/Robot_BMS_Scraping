*** Variables ***
${Browser}                      chrome
${SiteUrl}                      https://in.bookmyshow.com/explore/movies-pune
${Delay}                        5s
${search_for}                   window.__INITIAL_STATE__
${ScriptTag}
...                             return document.evaluate('//body/script[2]', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.innerHTML
${MaxMovieRetrive}              6
${MovieExcelFilePath}           ${CURDIR}\\output\\Movie.xlsx
${InCinemasJSONFilePath}        ${CURDIR}\\output\\InCinemas.json
${ComingSoonJSONFilePath}       ${CURDIR}\\output\\ComingSoon.json
