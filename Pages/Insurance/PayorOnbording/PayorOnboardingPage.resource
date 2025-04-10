*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     ../../Qrace/QraceHelper.py
Library     ../../DBQuery/DBQuerySelect.py
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource
Resource    ../Common/LoginPage.resource


*** Keywords ***
Payor Onboard
    TRY
        Onboard Insurance
        ${Android_EN_InsurnacePage}       Set Variable    android=new UiSelector().text("Insurance")
        ${iOS_EN_InsurnacePage}           Set Variable    chain=**/XCUIElementTypeButton[`label == 'Insurance'`]
        Wait Until Element Is Visible      ${${platformName}_${lang}_InsurnacePage}            timeout=30s
        Take Screenshot     FWD_Insurance_Page
        Click Element       ${${platformName}_${lang}_InsurnacePage}
        Set or enter PIN
        ${iOS_EN_ViewDocumnets}    Set Variable      chain=**/XCUIElementTypeOther[`label CONTAINS 'View'`][-1]
        Wait Until Element Is Visible       ${${platformName}_${lang}_ViewDocumnets}       timeout=30s
        Click Element       ${${platformName}_${lang}_ViewDocumnets}
        Take Screenshot     View Document
        Set Global Variable    ${result}    View Document Enable for Payor Onbording
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END