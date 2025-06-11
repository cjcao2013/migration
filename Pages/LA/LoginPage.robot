*** Settings ***
Documentation       MainFrame Demo

Library             Mainframe3270
Library             BuiltIn
Library             Screenshot
Library             OperatingSystem
Library             ../../Qrace/QraceHelper.py
Library             SeleniumLibrary
Resource            ../../CustomLibraries/common.robot
# Library    keyboard
Resource            ../../CustomLibraries/LA/AS400Utility.robot


*** Variables ***
${USERNAME}     HK223742
${PASSWORD}     Test@123
${HOSTNAME}     10.16.95.21


*** Keywords ***
Log in to application
    TRY
        ${HOSTNAME}    Get Environment Attribute    CATHLA01.TH.INTRANET
        Set Global Variable    ${HOSTNAME}
        ${listarg}    Create List    -codepage    thai
        Log    ${listarg}    WARN
        Open Connection    Y:L:CATHLA01.TH.INTRANET    port=992    extra_args=${listarg}
        Sleep    10s
        Wait Field Detected
        Sleep    2s
        Change Wait Time    2
        Change Wait Time After Write    2
        ${USERNAME}    Get Environment Attribute    LA_USERNAME
        ${PASSWORD}    Get Environment Attribute    LA_UPASSWORD
        Write Bare In position    ${USERNAME}    9    62
        Write Bare In position    ${PASSWORD}    10    62
        Take AS400 Screenshot
        Send Enter
        ${errmsg}    Capture Message    24    1    30
        ${containstr}    Should Contain    ${errmsg}    COPYRIGHT
        IF    '${containstr}' == 'None'
            Send Enter
            Send Enter
            Write Bare In Position    d    18    7
            Take AS400 Screenshot
            Send Enter
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       LA_Flow   ${reason}   Log in to application
    END
Log in to application1
    TRY
        ${USERNAME}    Get Environment Attribute    USERNAME
        ${PASSWORD}    Get Environment Attribute    PASSWORD
        ${HOSTNAME}    Get Environment Attribute    HOSTNAME
        Set Global Variable    ${HOSTNAME}
        ${LA_ENV}    Get Environment Attribute    LA_Env


        ${extra_args}    Create List    -codepage    thai

        Open Connection    ULIFE    extra_args=${extra_args}

        Sleep    2s
        Wait Field Detected
        Sleep    4s
        Change Wait Time    2
        Change Wait Time After Write    2
        Write Bare In position    ไพศาลABC    9    62
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       LA_Flow   ${reason}   Log in to application
    END