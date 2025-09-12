*** Settings ***
Library     AppiumLibrary
Library     Dialogs
Resource    ../../../CustomLibraries/common.robot
Resource    AddOTP.resource
Resource    CommonMethod.resource
Resource    LoginPage.resource
Resource    ../../../PageObjects/Insurance/Common/ForgotMPINPageObject.resource
Resource    ../../../PageObjects/Insurance/Common/LoginPageObjects.resource

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
        Additional Verification
        Set Or Enter PIN
        Set Global Variable     ${result}       MPIN Changed Successfully
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    OMNE_FLOW   ${reason}   MPIN Change
    END

Additional Verification
    TRY
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_DD_dropdown}    timeout=5s
        IF    '${status}' == 'True'
            Take Screenshot    SignIn_Details_Page
            Select DOB
            # Select FWD Policy Holder
            ${iOS_FWDPolicyHolder}      Set Variable          chain=**/XCUIElementTypeOther[`label == "${IS_FWD_PolicyHolder}"`]
            ${Android_FWDPolicyHolder}      Set Variable      xpath=//android.widget.TextView[@text='${IS_FWD_PolicyHolder}']/preceding-sibling::android.view.ViewGroup
            ${status}       Run Keyword And Return Status    Wait Until Element Is Visible       ${${platformName}_FWDPolicyHolder}     timeout=5s
            IF    '${status}' == 'True'
                 Click Element       ${${platformName}_FWDPolicyHolder}
            END

            # Select Country
             ${iOS_CountryObj}   Set Variable           chain=**/XCUIElementTypeOther[`label == "${Country}"`]
             ${iOS_DocuType}     Set Variable           chain=**/XCUIElementTypeOther[`label == "${DocumentType}"`]
             ${Android_CountryObj}   Set Variable    android=new UiSelector().textContains("${Country}")
             ${Android_DocuType}     Set Variable    xpath=//android.widget.TextView[@text='${DocumentType}']
            Wait Until Element Is Visible    ${${platformName}_${lang}_Country}    timeout=10s

            Click Element    ${${platformName}_${lang}_Country}
            Wait Until Element Is Visible    ${${platformName}_CountryObj}    timeout=5s
            Click Element    ${${platformName}_CountryObj}

            Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Type}    timeout=5s
            Click Element    ${${platformName}_${lang}_Document_Type}
            Wait Until Element Is Visible    ${${platformName}_DocuType}    timeout=5s
            Click Element    ${${platformName}_DocuType}
            Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Number}    timeout=5s
            Click Element    ${${platformName}_${lang}_Document_Number}
            IF    '${platformName}' == 'iOS'
                 Input Text    ${${platformName}_${lang}_Document_Number}    ${Customer_ID}\n
                 Close keyboard
            ELSE
                @{CustID_len}    Split String To Characters     ${Customer_ID}
                FOR    ${char}    IN    @{CustID_len}
                    Input Text Into Current Element    ${char}
                END
                 Close keyboard
            END
            ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Error_Invalid_Document_No}    timeout=1s
            IF    '${status}' == 'True'
                Take Screenshot    Invalid_Document_Details
                ${VP_Document_No_Pass}    Get Text    ${${platformName}_${lang}_Error_Invalid_Document_No}
                Set Global Variable    ${errormsg}    ${VP_Document_No_Pass}
                Set Calc VP With Source And Original Values    Invalid_Document_Number    ${ValidationErrorMsg}    ${VP_Document_No_Pass}    Static    OMNE_SignInDocumentPage    ${ValidationErrorMsg}    ${VP_Document_No_Pass}
                Fail    ${errormsg}
            END
            Wait Until Element Is Visible    ${${platformName}_${lang}_Verify_btn}
            Take Screenshot    Document_Details
            Get Details from DB
            ${Previous_OTP}    Set Variable    ${OTPNumber}
            Set Global Variable    ${Previous_OTP}
            Click Element    ${${platformName}_${lang}_Verify_btn}
        END
        Take Screenshot    SignIn_OTP_Page
        Run Keyword    Insert OTP       ${Transaction_OTP_Source}   ${Transaction_OTP_Expiry_Flag}  ${Transaction_OTP_Resend_Flag}

        Omne Action Popup
    EXCEPT     AS  ${reason}
       Set Failed Actual Result and VP    Omne_Flow   ${reason}   Additional Verification Page
    END