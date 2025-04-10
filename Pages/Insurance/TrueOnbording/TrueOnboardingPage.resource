*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     ../../Qrace/QraceHelper.py
Library     ../../DBQuery/DBQuerySelect.py
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource
Resource    ../Common/LoginPage.resource


*** Keywords ***
True Onboarding
    TRY
        Onboard Insurance
        ${Android_EN_InsurnacePage}       Set Variable    android=new UiSelector().text("Insurance")
        ${iOS_EN_InsurnacePage}           Set Variable    chain=**/XCUIElementTypeButton[`label == 'Insurance'`]
        Wait Until Element Is Visible      ${${platformName}_${lang}_InsurnacePage}            timeout=30s
        Take Screenshot     FWD_Insurance_Page
        Click Element       ${${platformName}_${lang}_InsurnacePage}
        Set or enter PIN
        ${Android_EN_Insurance_Module}    Set Variable    android=new UiSelector().textContains("My policy(s)")
        ${iOS_EN_Insurance_Module}        Set Variable     chain=**/XCUIElementTypeOther[`label == "My policy(s) See all"`]/XCUIElementTypeOther[-1]
        Wait Until Element Is Visible    ${${platformName}_${lang}_Insurance_Module}    timeout=30s
        Click Element    ${${platformName}_${lang}_Insurance_Module}
        Take Screenshot     My Policy
        Wait Until Element Is Visible       ${iOS_EN_NavigateBackButton}    timeout=30s
        Click Element       ${iOS_EN_NavigateBackButton}
        ${iOS_EN_ViewDocumnets}    Set Variable      chain=**/XCUIElementTypeOther[`label CONTAINS 'View'`][-1]
        Wait Until Element Is Visible       ${${platformName}_${lang}_ViewDocumnets}       timeout=30s
        Click Element       ${${platformName}_${lang}_ViewDocumnets}
        Take Screenshot     View Document

        Set Global Variable    ${result}   View Policy and View Document Enable for True Onbording
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END