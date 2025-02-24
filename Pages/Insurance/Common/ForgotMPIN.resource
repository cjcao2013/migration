*** Settings ***
Library     AppiumLibrary
Library     Dialogs
Resource    ../../../CustomLibraries/common.robot
Resource    AddOTP.resource
Resource    CommonMethod.resource
Resource    LoginPage.resource
Resource    ../../../PageObjects/Insurance/Common/ForgotMPINPageObject.resource

*** Keywords ***
Forgot_MPIN
    TRY
        ${ranint}   Generate Random String  length=6      chars=[NUMBERS]
        ${ranint}   Convert To Integer    ${ranint}
        ${Android_EN_InsurancePage}       Set Variable    android=new UiSelector().text("Insurance")
        ${iOS_EN_InsurancePage}           Set Variable    chain=**/XCUIElementTypeButton[`label == 'Insurance'`]
        Wait Until Element Is Visible      ${${platformName}_${lang}_InsurancePage}            timeout=30s
        Take Screenshot     FWD_Insurance_Page
        Click Element       ${${platformName}_${lang}_InsurancePage}
        Wait Until Element Is Visible    ${${platformName}_${lang}_Forgot_PIN}      timeout=10s
        Click Element    ${${platformName}_${lang}_Forgot_PIN}
        Wait Until Element Is Visible       ${${platformName}_${lang}_SetNewPIN}    timeout=10s
        Additional Verification Page
        Set Or Enter PIN
        Set Global Variable     ${result}       MPIN Changed Successfully
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    OMNE_FLOW   ${reason}   MPIN Change
    END