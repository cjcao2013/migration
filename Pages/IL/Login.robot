*** Settings ***
Library     SeleniumLibrary
Resource    ../../CustomLibraries/common.robot
Resource    ../../PageObjects/IL/LoginPageObjects.robot
*** Variables ***
${capabilities}     ${EMPTY.join(${_tmp})}
${remote_url}       http://localhost:4445/wd/hub
${IL_Actual}

*** Keywords ***
IL Login
    TRY
        ${IL_username}    Get Environment Attribute    IL_username
        ${IL_password}    Get Environment Attribute    IL_password
        Input Text    ${obj_IL_username}    ${IL_username}
        Input Text    ${obj_IL_password}    ${IL_password}
        Take IL Screenshot    Login
        Click Element    ${obj_IL_login_button}
        Sleep    4s
        ${counter}    Set Variable    0
        ${login_status}    Set Variable    False
        WHILE    ${counter}<30
            @{list}    Get Window Handles    CURRENT
            ${list_length}    Get Length    ${list}
            IF    ${list_length}>1
                ${login_status}    Set Variable    True
                Set Global Variable    ${login_status}
                BREAK
            END
            Sleep    2s
            ${counter}    Evaluate    ${counter} + 1
        END

        ${IL_Actual}=    Catenate    ${IL_Actual}     |   IL Login Successfully
        Set Global Variable    ${IL_Actual}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       IL_Flow   ${reason}  IL Login
    END
Open IL Chrome Browser
    [Arguments]    ${url}
    TRY
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
            Call Method                     ${options}   add_argument    --use-fake-ui-for-media-stream
            Call Method                     ${options}   add_argument    --use-fake-device-for-media-stream

            Open Browser                    ${url}      browser=${browser}
            ...     remote_url=${remote_url}
            ...     desired_capabilities=${dc}
            ...     options=${options}

            Maximize Browser Window

        Set Selenium Timeout    10
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       IL_Flow   ${reason}  IL Open Browser
    END
