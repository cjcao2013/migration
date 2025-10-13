*** Settings ***
Library     AppiumLibrary
Library     Dialogs
Resource    ../../../CustomLibraries/common.robot
Resource    ../../../PageObjects/Insurance/Common/LoginPageObjects.resource
Resource    AddOTP.resource
Resource    CommonMethod.resource
Resource    ../../../CustomLibraries/API/SignUP.resource
Resource    ../../../CustomLibraries/API/ConfirmOTP.resource
Resource    ../../../CustomLibraries/API/UpdateDOB.resource
Library     FakerLibrary




*** Variables ***
${VP_ByDefault_Lang}        ${EMPTY}

*** Keywords ***
Logout From OMNE
    TRY
        ${sOutput}    Run Keyword And Ignore Error    Navigate to Home Page
        IF    ${sOutput} != ('PASS', None)
            Take Screenshot    Log out Error
           ${failure_reason}    Fetch Reason    ${sOutput}
           RETURN       ${failure_reason}
        END
        ${status}    Run Keyword And Return Status   Wait Until Element Is Visible    ${${platformName}_${lang}_Profile_Icon_btn}    timeout=10s
        IF    '${status}' == 'True'
            Take Screenshot    ProfilePage
            Click Element    ${${platformName}_${lang}_Profile_Icon_btn}
            Sleep    1s
            Click Element At Coordinates    340    163
        END
        ${status}    Run Keyword And Return Status   Wait Until Element Is Visible    ${${platformName}_${lang}_SettingIcon}    timeout=10s
        Click Element    ${${platformName}_${lang}_SettingIcon}
        Wait Until Element Is Visible    ${${platformName}_${lang}_Logout_btn}    timeout=5s
        Click Element    ${${platformName}_${lang}_Logout_btn}
        Wait Until Element Is Visible    ${${platformName}_${lang}_Confirm_btn}    timeout=5s
        Click Element    ${${platformName}_${lang}_Confirm_btn}
        Login Application
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Logout From OMNE
    END



Logout with Check
    TRY
         ${ProfileMailTxt}      Get Text        ${${platformName}_${lang}_Profile_Mail}
         IF    '${Email}' == '${ProfileMailTxt}'
                        Click Element       ${${platformName}_${lang}_AccountBackButton_Arrow}
                        Sleep    2s
         ELSE
                Click Element    ${${platformName}_${lang}_SettingIcon}
                Wait Until Element Is Visible    ${${platformName}_${lang}_Logout_btn}    timeout=5s
                Click Element    ${${platformName}_${lang}_Logout_btn}
                Wait Until Element Is Visible    ${${platformName}_${lang}_Confirm_btn}    timeout=5s
                Click Element    ${${platformName}_${lang}_Confirm_btn}
                Login Application
         END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Logout with Check
    END

Login Application
    TRY
         Run Keyword    ${LoginMethod}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   ${LoginMethod}
    END
    Set Global Variable    ${actualResult}

SignUp
    TRY
        Sign Up API
        Confirm Sign Up OTP
        Update Sign Up DOB
        SignIn
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   ${LoginMethod}
    END


Onboard Insurance
    TRY
        ${Android_EN_InsurancePage}       Set Variable    android=new UiSelector().text("Insurance")
        ${iOS_EN_InsurancePage}           Set Variable    chain=**/XCUIElementTypeButton[`label == 'Insurance'`]
        Wait Until Element Is Visible      ${${platformName}_${lang}_InsurancePage}            timeout=100s
        Take Screenshot     FWD_Insurance_Page
        Click Element       ${${platformName}_${lang}_InsurancePage}
        ${iOS_EN_CountryObj}   Set Variable           chain=**/XCUIElementTypeOther[`label == "${Country}"`]
        ${iOS_EN_DocuType}     Set Variable           chain=**/XCUIElementTypeOther[`label == "${DocumentType}"`]
        ${Android_EN_CountryObj}   Set Variable    android=new UiSelector().textContains("${Country}")
        ${Android_EN_DocuType}     Set Variable    xpath=//android.widget.TextView[@text='${DocumentType}']

        Wait Until Element Is Visible    ${${platformName}_${lang}_Country}    timeout=10s
    #    Sleep    1s
        Take Screenshot    FWD_Insurance_Page
        Click Element    ${${platformName}_${lang}_Country}
        Wait Until Element Is Visible    ${${platformName}_${lang}_CountryObj}    timeout=10s
        Click Element    ${${platformName}_${lang}_CountryObj}
        ${status}    Run Keyword And Return Status    Element Should Be Visible    ${${platformName}_${lang}_Document_Type}     timeout=10s
        ${status}    Run Keyword And Return Status    Element Should Be Visible    ${${platformName}_${lang}_Document_Number}       timeout=10s

        Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Type}    timeout=10s
        Click Element    ${${platformName}_${lang}_Document_Type}
        Wait Until Element Is Visible    ${${platformName}_${lang}_DocuType}    timeout=10s
        Click Element   ${${platformName}_${lang}_DocuType}
        Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Number}    timeout=10s
        Click Element    ${${platformName}_${lang}_Document_Number}
        IF    '${platformName}' != 'iOS'
              @{CustID_len}    Split String To Characters     ${Customer_ID}
             FOR    ${char}    IN    @{CustID_len}
                    Input Text Into Current Element    ${char}
             END
        ELSE
            IF    '${DocumentType}' == 'Passport'
                ${Wrong_PasswordNumber}     Get Substring    ${Customer_ID}    5
                Input Text    ${${platformName}_${lang}_Document_Number}    ${Wrong_PasswordNumber}
                Close keyboard
                ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Error_Invalid_Document_No}    timeout=2s
                IF    '${status}' == 'True'
                    Take Screenshot    Invalid_Document_Details
                    ${VP_Document_No_Pass}    Get Text    ${${platformName}_${lang}_Error_Invalid_Document_No}
                    Set Global Variable    ${errormsg}    ${VP_Document_No_Pass}
                    Set Calc VP With Source And Original Values    Invalid_Document_Number_Eror_With_5_Digit_Number   ${ValidationErrorMsg}    ${VP_Document_No_Pass}    Static    OMNE_SignInDocumentPage    ${ValidationErrorMsg}    ${VP_Document_No_Pass}
                END
                ${Wrong_PasswordNumber}     Set Variable    ABCD5678901234567
                Clear Text    ${${platformName}_${lang}_Document_Number}
                Input Text    ${${platformName}_${lang}_Document_Number}    ${Wrong_PasswordNumber}
                Close keyboard
                ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Error_Invalid_Document_No}    timeout=2s
                IF    '${status}' == 'True'
                    Take Screenshot    Invalid_Document_Details
                    ${VP_Document_No_Pass}    Get Text    ${${platformName}_${lang}_Error_Invalid_Document_No}
                    Set Global Variable    ${errormsg}    ${VP_Document_No_Pass}
                    Set Calc VP With Source And Original Values    Invalid_Document_Number_Eror_With_17_Digit_Number   ${ValidationErrorMsg}    ${VP_Document_No_Pass}    Static    OMNE_SignInDocumentPage    ${ValidationErrorMsg}    ${VP_Document_No_Pass}
                END
                 Click Element    ${${platformName}_${lang}_Document_Number}
                 Clear Text    ${${platformName}_${lang}_Document_Number}
                 Input Text    ${${platformName}_${lang}_Document_Number}    ${Customer_ID}
                 Close keyboard
            ELSE
                ${Wrong_PasswordNumber}     Get Substring    ${Customer_ID}    10
                Input Text    ${${platformName}_${lang}_Document_Number}    ${Wrong_PasswordNumber}
                Close keyboard
                ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Error_Invalid_Document_No}    timeout=2s
                IF    '${status}' == 'True'
                    Take Screenshot    Invalid_Document_Details
                    ${VP_Document_No_Pass}    Get Text    ${${platformName}_${lang}_Error_Invalid_Document_No}
                    Set Global Variable    ${errormsg}    ${VP_Document_No_Pass}
                    Set Calc VP With Source And Original Values    Invalid_Document_Number_Eror_With_10_Digit_Number   ${ValidationErrorMsg}    ${VP_Document_No_Pass}    Static    OMNE_SignInDocumentPage    ${ValidationErrorMsg}    ${VP_Document_No_Pass}
                END
                Click Element    ${${platformName}_${lang}_Document_Number}
                Clear Text    ${${platformName}_${lang}_Document_Number}
                Input Text    ${${platformName}_${lang}_Document_Number}    ${Customer_ID}
                Close keyboard
            END
        END

        Wait Until Element Is Visible    ${${platformName}_${lang}_Verify_btn}          timeout=10s
        Take Screenshot    Document_Details
        # Previous OTP from Mailsac
        Get SignUp OTP
        ${LoginPrevious_OTP}     Set Variable      ${OTPNumber}
        Set Global Variable    ${LoginPrevious_OTP}
        Click Element    ${${platformName}_${lang}_Verify_btn}
        #unlik policy code
        ${status}   Run Keyword And Return Status   Wait Until Element Is Visible      ${${platformName}_${lang}_UnlinkPolicy_chkBox}            timeout=10s
        IF    '${status}' == 'True'
            Click Element       ${${platformName}_${lang}_UnlinkPolicy_chkBox}
            Wait Until Element Is Visible      ${${platformName}_${lang}_ConfirmBtn}
            Take Screenshot     Onboard Unlik Policy Popup
            Click Element       ${${platformName}_${lang}_ConfirmBtn}
        END
        Sleep    5s
        Get SignUp OTP
        ${OTP}      Set Variable    ${OTPNumber}
        ${OTP}      Convert To String    ${OTP}
        ${OTP1}     Get Substring    ${OTP}    0    1
        ${OTP2}     Get Substring    ${OTP}    1    2
        ${OTP3}     Get Substring    ${OTP}    2    3
        ${OTP4}     Get Substring    ${OTP}    3    4
        ${OTP5}     Get Substring    ${OTP}    4    5
        ${OTP6}     Get Substring    ${OTP}    5    6
        ${OTP_Source}           Set Variable        db
        IF    '${OTP_Source.lower()}' == 'db' and '${platformName}' == 'iOS'
            Sleep    2s
            Input Text    ${${platformName}_${lang}_InputOTPField}    ${OTP}\n
        ELSE
           Input Password    ${${platformName}_${lang}_InputOTPField}    ${OTP}
           Hide Keyboard
        END

        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_NextButton}    timeout=3s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_NextButton}
        ELSE
            Click Element    ${${platformName}_${lang}_Verify}
        END
        Take Screenshot    OTP Submit
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Eror_Msg_Wrong_Otp}    timeout=1s
        IF    '${status}' == 'True'
            Take Screenshot    Invalid_OTP
            ${VP_Inavalid_OTP}    Get Text    ${${platformName}_${lang}_Eror_Msg_Wrong_Otp}
            Set Global Variable    ${errormsg}    ${VP_Inavalid_OTP}
            Set Calc VP With Source And Original Values    Onboard OTP Invalid Message    OTP is invalid    ${VP_Inavalid_OTP}    Static    OMNE_OTPPage    OTP is invalid    ${VP_Inavalid_OTP}
            Fail    ${errormsg}
        END
       Set or enter PIN
       Regestration Experience Feedback
       Wait Until Element Is Visible      ${${platformName}_${lang}_InsurancePage}            timeout=30s
       Take Screenshot    FWD Insurance Page
       ${actualResult}=    Catenate    ${actualResult}    |  Onboard Insurance Details Successfull
       Set Global Variable    ${actualResult}
   EXCEPT     AS  ${reason}
       Set Failed Actual Result and VP    Omne_Flow   ${reason}   Onboard Insurance Details
   END

SignIn
    TRY
        ${status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${${platformName}_${lang}_Allow}     timeout=2s
        IF    '${status}' == 'True'
            Click Element       ${${platformName}_${lang}_Allow}
        END
        ${status}    Run Keyword And Return Status   Wait Until Element Is Visible    ${${platformName}_${lang}_Sign_in_here}    timeout=20s
        IF    '${status}' == 'True'    Click Element    ${${platformName}_${lang}_Sign_in_here}
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_SignIn_WelomebackText}    timeout=2s
        Set Global Variable    ${loginstatus}    ${status}
        IF    '${status}' == 'True'
            ${VP_Sign_here_Welcome_Txt}    Get Text    ${${platformName}_${lang}_SignIn_WelomebackText}
            ${VP_Sign_here_DontHave_Txt}    Get Text    ${${platformName}_${lang}_SignIn_DontHaveText}
            Set Calc VP With Source And Original Values    Login_Welcome_txt    Welcome back!    ${VP_Sign_here_Welcome_Txt}    Static    OMNE_Application    Welcome back!    ${VP_Sign_here_Welcome_Txt}
            Set Calc VP With Source And Original Values    Login_Don't_have_account_txt    Don't have an account yet?    ${VP_Sign_here_DontHave_Txt.strip()}    Static    OMNE_Application    Don't have an account yet?    ${VP_Sign_here_DontHave_Txt}
            ${status}    Run Keyword And Return Status    Element Should Be Enabled    ${${platformName}_${lang}_Enter_MobileNo}
            Set Calc VP With Source And Original Values    Mobile_No_Enable_By_Default    true    ${status}    Static    OMNE_Application    true    ${status}
            ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Language}    timeout=1s
            IF    '${status}' == 'True'
                ${VP_ByDefault_Lang}    Get Text    ${${platformName}_${lang}_Language}
            END
            Set Calc VP With Source And Original Values    By_Default_EN_Language    EN    ${VP_ByDefault_Lang}    Static    OMNE_Application    EN    ${VP_ByDefault_Lang}

            #       Login by Email or Mobile
            Run Keyword    Login By ${LoginType}
            Additional Verification Page

            Extra POP Up

        ELSE
            Logout From OMNE
        END

        ${status}    Run Keyword And Return Status    Wait Until Page Contains    Allow    timeout=2s
        IF    '${status}' == 'True'
            Click Text    Allow    exact_match=true
            Take Screenshot    PostSignInHome_Page
        END

        ${status}    Run Keyword And Return Status    Wait Until Page Contains    Close    timeout=1s
        IF    '${status}' == 'True'
            Click Text    Close    exact_match=true
            Take Screenshot    PostSignInHome_Page
        END
            ${Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Popup_Confirm_btn}   timeout=3s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_Popup_Confirm_btn}
        END
    EXCEPT     AS  ${reason}
       Set Failed Actual Result and VP    Omne_Flow   ${reason}   Sign IN
    END


Additional Verification Page
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

            #  Select Country
             ${iOS_CountryObj}   Set Variable           chain=**/XCUIElementTypeOther[`label == "${Country}"`]
             ${iOS_DocuType}     Set Variable           chain=**/XCUIElementTypeOther[`label == "${DocumentType}"`]
             ${Android_CountryObj}   Set Variable    android=new UiSelector().textContains("${Country}")
             ${Android_DocuType}     Set Variable    xpath=//android.widget.TextView[@text='${DocumentType}']
            Wait Until Element Is Visible    ${${platformName}_${lang}_Country}    timeout=10s
            #            Sleep    1s
            Click Element    ${${platformName}_${lang}_Country}
            Wait Until Element Is Visible    ${${platformName}_CountryObj}    timeout=5s
            Click Element    ${${platformName}_CountryObj}
            IF    '${Country}' == 'Thailand' or '${Country}' == 'Cambodia'
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
                #                Click Element At Coordinates    61    800
                ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Error_Invalid_Document_No}    timeout=1s
                IF    '${status}' == 'True'
                    Take Screenshot    Invalid_Document_Details
                    ${VP_Document_No_Pass}    Get Text    ${${platformName}_${lang}_Error_Invalid_Document_No}
                    Set Global Variable    ${errormsg}    ${VP_Document_No_Pass}
                    Set Calc VP With Source And Original Values    Invalid_Document_Number    ${ValidationErrorMsg}    ${VP_Document_No_Pass}    Static    OMNE_SignInDocumentPage    ${ValidationErrorMsg}    ${VP_Document_No_Pass}
                    Fail    ${errormsg}
                END
            END
            Wait Until Element Is Visible    ${${platformName}_${lang}_Verify_btn}
            Take Screenshot    Document_Details



#            Get OTP
#            ${LoginPrevious_OTP}     Set Variable      ${OTPNumber}
            ${LoginPrevious_OTP}     Set Variable      643456
            Set Global Variable    ${LoginPrevious_OTP}
            Click Element    ${${platformName}_${lang}_Verify_btn}
            # Previous OTP from Mailsac
            ${status}   Run Keyword And Return Status   Wait Until Element Is Visible      ${${platformName}_${lang}_UnlinkPolicy_chkBox}            timeout=10s
            IF    '${status}' == 'True'
                Click Element       ${${platformName}_${lang}_UnlinkPolicy_chkBox}
                Wait Until Element Is Visible      ${${platformName}_${lang}_ConfirmBtn}
                Take Screenshot     Onboard Unlik Policy Popup
                Click Element       ${${platformName}_${lang}_ConfirmBtn}
            END
        END
        Take Screenshot    SignIn_OTP_Page
        Insert OTP      ${OTP_Source}    ${OTP_Expiry_Flag}     ${OTP_Resend_Flag}
#        Pause Execution
        Omne Action Popup
    EXCEPT     AS  ${reason}
       Set Failed Actual Result and VP    Omne_Flow   ${reason}   Additional Verification Page
    END



Select DOB
    TRY
        @{DOB}    Split String    ${SignUpDOB}
        ${day}    Get From List    ${DOB}    0
        ${month}    Get From List    ${DOB}    1
        ${Year}    Get From List    ${DOB}    2

        ${Android_DayObj}      Set Variable     xpath=//android.view.ViewGroup[@content-desc="${day}"]/android.widget.TextView
        ${Android_MonthObj}      Set Variable    android=new UiSelector().textContains("${month}")
        ${Android_YearObj}      Set Variable    android=new UiSelector().textContains("${Year}")
        ${iOS_DayObj}      Set Variable             chain=**/XCUIElementTypeOther[`label == '${day}'`][-1]
        ${iOS_MonthObj}      Set Variable           chain=**/XCUIElementTypeOther[`label == '${month}'`][-1]
        ${iOS_YearObj}      Set Variable            chain=**/XCUIElementTypeOther[`label == '${Year}'`][-1]

        Click Element    ${${platformName}_${lang}_DD_dropdown}
        Sleep    2s
        ${status}    Run Keyword And Return Status      Wait Until Page Contains Element    ${${platformName}_DayObj}    timeout=2s
        WHILE    '${status}' != 'True'
            Swipe    289    1294    294    735
            ${status}    Run Keyword And Return Status      Wait Until Page Contains Element    ${${platformName}_DayObj}    timeout=2s

        END
        Click Element    ${${platformName}_DayObj}
        Wait Until Element Is Visible    ${${platformName}_${lang}_MMM_dropdown}       timeout=5s
        Click Element    ${${platformName}_${lang}_MMM_dropdown}
        ${status}    Run Keyword And Return Status      Wait Until Page Contains Element    ${${platformName}_MonthObj}    timeout=2s
        WHILE    '${status}' != 'True'
            Swipe    289    1294    294    735
            ${status}    Run Keyword And Return Status      Wait Until Page Contains Element    ${${platformName}_MonthObj}    timeout=2s
        END
        Click Element    ${${platformName}_MonthObj}
        Wait Until Element Is Visible    ${${platformName}_${lang}_YYYY_dropdown}
        Click Element    ${${platformName}_${lang}_YYYY_dropdown}
        ${status}    Run Keyword And Return Status      Wait Until Page Contains Element    ${${platformName}_YearObj}    timeout=2s
        WHILE    '${status}' != 'True'
            Swipe    289    1294    294    735
            ${status}    Run Keyword And Return Status      Wait Until Page Contains Element    ${${platformName}_YearObj}    timeout=2s
    #        IF    '${status}' == 'True'
    #            BREAK
    #        END
        END
        Click Element   ${${platformName}_YearObj}
    EXCEPT     AS  ${reason}
       Set Failed Actual Result and VP    Omne_Flow   ${reason}   Select DOB
    END

Login By Email
    TRY
        Wait Until Element Is Visible    ${${platformName}_${lang}_email_option}    timeout=5s
        Click Element    ${${platformName}_${lang}_email_option}
        Take Screenshot    Login PrePage
        Clear Text    ${${platformName}_${lang}_Enter_email}
        IF    '${LoginMethod}' == 'SignUp'
             Input Text    ${${platformName}_${lang}_Enter_email}    ${EmailNew}
        ELSE
            Input Text    ${${platformName}_${lang}_Enter_email}    ${Email}
        END
        Close keyboard
        Take Screenshot    Login PostPage
        # Previous OTP from Mailsac
#        Get OTP
        ${LoginPrevious_OTP}     Set Variable      231456
#        ${LoginPrevious_OTP}     Set Variable      ${OTPNumber}
        Set Global Variable    ${LoginPrevious_OTP}
        Click Element    ${${platformName}_${lang}_NextButton}
    #            Get Value From User    check
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Error_MSg_Invalid_emailMObile}    timeout=1s
        IF    '${status}' == 'True'
            ${VP_Inavalid_Email_Pass}    Get Text    ${${platformName}_${lang}_Error_MSg_Invalid_emailMObile}
            Set Global Variable    ${errormsg}    ${VP_Inavalid_Email_Pass}
            Take Screenshot    SignInInvalidEmail
            Set Calc VP With Source And Original Values    SignIn_Not_Found    ${ValidationErrorMsg}    ${VP_Inavalid_Email_Pass}    Static    OMNE_SignInPage    ${ValidationErrorMsg}    ${VP_Inavalid_Email_Pass}
            Fail    ${errormsg}
        END
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Error_MSg_Invalid_Email}    timeout=1s
        IF    '${status}' == 'True'
            ${VP_Inavalid_Email_Pass}    Get Text    ${${platformName}_${lang}_Error_MSg_Invalid_Email}
            Set Global Variable    ${errormsg}    ${VP_Inavalid_Email_Pass}
            Take Screenshot    SignUpInvalidEmail
            Set Calc VP With Source And Original Values    Invalid_Email_ID    ${ValidationErrorMsg}    ${VP_Inavalid_Email_Pass}    Static    OMNE_SignInPage    ${ValidationErrorMsg}    ${VP_Inavalid_Email_Pass}
            Fail    ${errormsg}
        END
    EXCEPT     AS  ${reason}
       Set Failed Actual Result and VP    Omne_Flow   ${reason}   Sign IN
    END


Login By Mobile
    Wait Until Element Is Visible    ${${platformName}_${lang}_mobile_option}    timeout=10s
    Click Element    ${${platformName}_${lang}_mobile_option}
    Take Screenshot    Login Page Pre
    Input Text    ${${platformName}_${lang}_Enter_MobileNo}    ${MobileNumber}
    Take Screenshot    Login Page Post
    # Previous OTP from Mailsac
    Get OTP
    ${LoginPrevious_OTP}     Set Variable      ${OTPNumber}
    Set Global Variable    ${LoginPrevious_OTP}
    Click Element    ${${platformName}_${lang}_NextButton}
    ${status}    Run Keyword And Return Status    Element Should Be Enabled    ${${platformName}_${lang}_Error_MSg_Invalid_emailMObile}
    IF    '${status}' == 'True'
        ${VP_Inavalid_Email_Pass}    Get Text    ${${platformName}_${lang}_Error_MSg_Invalid_emailMObile}
        Take Screenshot    SignUpErrorInvalidMobile
        Set Calc VP With Source And Original Values    SignIn_Not_Found    ${ValidationErrorMsg}    ${VP_Inavalid_Email_Pass}    Static    OMNE_SignInPage    ${ValidationErrorMsg}    ${VP_Inavalid_Email_Pass}
#                Set Calc VP Actual Result With Original And Source      SignIn_Not_Found    ${VP_Inavalid_Email_Pass}   ${VP_Inavalid_Email_Pass}   OMNE_SignInPage
#                Set Calc VP With Source And Original Values
#                ...    Invalid_Mobile_No
#                ...    Mobile number/Email not found
#                ...    ${VP_Inavalid_Email_Pass}
#                ...    Static
#                ...    OMNE_Application
#                ...    Mobile number/Email not found
#                ...    ${VP_Inavalid_Email_Pass}
        Fail    ${errormsg}
    END
    ${status}    Run Keyword And Return Status    Element Should Be Enabled    ${${platformName}_${lang}_Error_MSg_Invalid_Mobile}
    IF    '${status}' == 'True'
        ${VP_Inavalid_Email_Pass}    Get Text    ${${platformName}_${lang}_Error_MSg_Invalid_Mobile}
        Take Screenshot    SignUpErrorInvalidMobile
        Set Calc VP With Source And Original Values    Invalid_Mobile_No    ${ValidationErrorMsg}    ${VP_Inavalid_Email_Pass}    Static    OMNE_SignInPage    ${ValidationErrorMsg}    ${VP_Inavalid_Email_Pass}
        Set Calc VP Actual Result With Original And Source      Invalid_Mobile_No    ${VP_Inavalid_Email_Pass}   ${VP_Inavalid_Email_Pass}   OMNE_SignInPage
#                Set Calc VP With Source And Original Values
#                ...    Invalid_Mobile_No
#                ...    Mobile number/Email not found
#                ...    ${VP_Inavalid_Email_Pass}
#                ...    Static
#                ...    OMNE_Application
#                ...    Mobile number/Email not found
#                ...    ${VP_Inavalid_Email_Pass}
        Fail    ${errormsg}
    END

Omne Action Popup
    ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_would_you_like}          timeout=5s
        IF    '${status}' == 'True'
           ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_MangeYourInsurance}      timeout=5s
           IF    '${status}' == 'True'
                Click Element    ${${platformName}_${lang}_MangeYourInsurance}
           END
             Click Element    ${${platformName}_${lang}_Option_Get_Filter}
             Click Element    ${${platformName}_${lang}_Option_Sleep_Better}
             Take Screenshot    Omne First Page
             Click Element    ${${platformName}_${lang}_Ok_button_popupPage}

        END