*** Settings ***
Documentation       MainFrame Demo

Library             Mainframe3270
Library             BuiltIn
Library             Screenshot
Library             OperatingSystem
Library             SeleniumLibrary
Library             ../../Qrace/QraceHelper.py
Resource            ../../CustomLibraries/LA/AS400Utility.robot
Resource            ../../CustomLibraries/common.robot

*** Keywords ***
Tax Consent Core
    TRY
        Execute Command    MoveCursor(9, 43)
        Take AS400 Screenshot
        Send Enter
        Send Enter
        Write Bare In position    ${Policy_No}    17    39
        Write Bare In position    S    19    39
        Take AS400 Screenshot
        Send Enter
        ${Taxconsent}    Read    17    20    1
        ${Taxconsent}    Strip String    ${Taxconsent}
        Take AS400 Screenshot
        IF    '${Taxconsent}' == 'Y'
            ${MTaxconsent}    Set Variable    Yes
            Set Global Variable    ${MTaxconsent}
            Set Calc VP Actual Result With Original And Source
            ...    LA_TaxConsent_acknowledgement_status
            ...    ${MTaxconsent}
            ...    ${MTaxconsent}
            ...    LA_Application
        ELSE IF    '${Taxconsent}' == 'N'
            ${MTaxconsent}    Set Variable    No
            Set Global Variable    ${MTaxconsent}
            Set Calc VP Actual Result With Original And Source
            ...    LA_TaxConsent_acknowledgement_status
            ...    ${MTaxconsent}
            ...    ${MTaxconsent}
            ...    LA_Application
        END
        Execute Command    PA(1)
        Send PF    3
        Execute Command    PA(1)
        Send PF    3
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       LA_Flow   ${reason}   Tax Consent
    END