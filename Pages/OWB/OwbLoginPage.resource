*** Settings ***
Library     SeleniumLibrary
Resource    ../../PageObjects/OWB/LoginPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Library     ../../CustomLibraries/Operation.py


*** Variables ***
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
OWB Login
    SeleniumLibrary.Wait Until Element Is Visible    ${EN_User_txt}    timeout=200s
    SeleniumLibrary.Input Text    ${EN_User_txt}    ${OWB_User_ID}
    Sleep    0.5s
    SeleniumLibrary.Input Text    ${EN_Pass_txt}    ${OWB_Password}
    Take OWB Screenshot    OWB_LoginPage
    SeleniumLibrary.Wait Until Element Is Visible    ${EN_Login_btn}
    SeleniumLibrary.Click Element    ${EN_Login_btn}

Open Browser with OWB
    ${epos_url}    Get Environment Attribute    OWB_URL
    Open Chrome Browser    ${epos_url}

Open Chrome Browser
    [Arguments]    ${url}
#    ${path}    Get Chromedriver Path
#    Log    ${path}
#    ${dc}    Evaluate    sys.modules['selenium.webdriver'].DesiredCapabilities.CHROME    sys, selenium.webdriver
#    Set To Dictionary    ${dc}    acceptInsecureCerts    ${True}
#    Open Browser    url=${url}    browser=${browser}    executable_path=${path}    desired_capabilities=${dc}
#    Maximize Browser Window
    ${dc}                       Evaluate    sys.modules['selenium.webdriver'].DesiredCapabilities.CHROME  sys, selenium.webdriver
   Set To Dictionary           ${dc}       acceptInsecureCerts   ${True}
#    Open Browser    url=${url}     browser=${browser}      executable_path=${path}     desired_capabilities=${dc}
#    Maximize Browser Window

    IF    "${browser}" == "chrome"
        ${options}=    Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
        IF   "${headless}" == "true"
            Call Method    ${options}    add_argument    headless
            ${userAgent}=   set variable  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36"
            Call Method    ${options}  add_argument  ${userAgent}
#            ${capabilities}=   Call Method     ${options}    to_capabilities
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

