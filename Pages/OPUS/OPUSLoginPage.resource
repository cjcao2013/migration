*** Settings ***
Library     SeleniumLibrary
Resource    ../../CustomLibraries/Common.robot
Library     ../../CustomLibraries/Operation.py
Resource    ../../PageObjects/OPUS/OPUSLoginPageObject.resource
#Library    webdrivermanager

*** Variables ***
${OPUS_Username}        THPOS01
${OPUS_Password}        123456
${browser}          chrome
${headless}         false
@{_tmp}
...                 browserName: ${browser},
...                 platform: WINDOWS,
...                 platformName: WINDOWS
#    ...    plugins.always_open_pdf_externally: True

${capabilities}     ${EMPTY.join(${_tmp})}
${remote_url}       http://localhost:4445/wd/hub


*** Keywords ***
OPUS Login
    TRY
        SeleniumLibrary.Wait Until Element Is Visible      ${EN_Switch_Account}     timeout=200s
        SeleniumLibrary.Click Element    ${EN_Switch_Account}
        SeleniumLibrary.Click Element    ${EN_Switch_Account}

        SeleniumLibrary.Wait Until Element Is Visible    ${EN_User_txt}    timeout=200s
        SeleniumLibrary.Input Text    ${EN_User_txt}    ${OPUS_Username}
        SeleniumLibrary.Input Text    ${EN_Pass_txt}    ${OPUS_Password}

        SeleniumLibrary.Wait Until Element Is Visible    ${EN_Login_btn}    timeout=20s
        Take OPUS Screenshot    OPUS_LoginPage
        SeleniumLibrary.Click Element    ${EN_Login_btn}
        ${opusactualResult}=    Catenate    ${opusactualResult}     |   OPUS Login Successfully
        Set Global Variable    ${opusactualResult}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    OPUS_Flow   ${reason}   OPUS Login
    END


Open Browser with OPUS
    TRY
        ${opos_url}    Get Environment Attribute    OPUS_URL
        Open Chrome Browser    ${opos_url}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}    Open Browser with OPUS ${Insurance_Flow}
    END
Open Chrome Browser
    [Arguments]    ${url}
#    ${path}     Get Chromedriver Path
#    Log     ${path}
    ${dc}                       Evaluate    sys.modules['selenium.webdriver'].DesiredCapabilities.CHROME  sys, selenium.webdriver
   Set To Dictionary           ${dc}       acceptInsecureCerts   ${True}

    IF    "${browser}" == "chrome"
        ${options}=    Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
        IF   "${headless}" == "true"
            Call Method    ${options}    add_argument    headless
            ${userAgent}=   set variable  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36"
            Call Method    ${options}  add_argument  ${userAgent}
            Call Method    ${options}    add_argument    download.prompt_for_download=False
        END
    END

#    ${chrome_options}=              Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()   sys
    Call Method                     ${options}   add_argument    --use-fake-ui-for-media-stream
    Call Method                     ${options}   add_argument    --use-fake-device-for-media-stream
#    Call Method                     ${chrome_options}   add_argument    Zoom 80%
#    Create Webdriver                Chrome  alias=tab1  chrome_options=${chrome_options}
    Open Browser                    ${url}      browser=${browser}
    ...     remote_url=${remote_url}
    ...     desired_capabilities=${dc}
    ...     options=${options}

    Maximize Browser Window
