*** Settings ***
Library     AppiumLibrary
Library    FakerLibrary
Resource    ../../../PageObjects/Insurance/Common/CommonMethodObjects.resource
Resource    UploadDocuments.resource
Resource    ../../../CustomLibraries/common.robot
Resource    ../../../PageObjects/Insurance/Common/CommonObjects.resource
Library     ../../DBQuery/ViewPolicyDB.py


*** Keywords ***
Completion Popup
    TRY
        Sleep    10s
        IF    '${platformName}' == 'iOS'
            Click by Coordinates    199    95
        ELSE
                Click by Coordinates    510    248
        END
        Extra POP Up
        ${Android_EN_InsurancePage}    Set Variable    android=new UiSelector().text("${Flow_Flag}")
        ${iOS_EN_InsurancePage}    Set Variable    chain=**/XCUIElementTypeButton[`label == '${Flow_Flag}'`]
        ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_InsurancePage}   timeout=3s
        Take Screenshot    Feedback_Page
        IF    '${status}' == 'True'
                Take Screenshot    FWD_Insurance_Page
                Click Element    ${${platformName}_${lang}_InsurancePage}
        END

        Set or enter PIN
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Completion Popup
    END

Add Payment Methods
    TRY
        ${PreSelectionstatus}      Run Keyword And Return Status    Element Should Be Disabled     ${${platformName}_${lang}_BankName}         timeout=3s
        IF    '${PreSelectionstatus}' == 'True'
               Set Calc VP With Source And Original Values    Bank_Name_Present    true    ${PreSelectionstatus}     Static   OMNE_Application    true    ${PreSelectionstatus}
        END
        TRY
            Sleep    1s
             Wait Until Element Is Visible   ${${platformName}_${lang}_DeleteRider_AddImage}     timeout=10s
             Click Element    ${${platformName}_${lang}_DeleteRider_AddImage}
        EXCEPT
            Wait Until Element Is Visible   ${${platformName}_${lang}_AddImage}     timeout=10s
            Click Element    ${${platformName}_${lang}_AddImage}
        END
        ${path}     Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/Certificate.PNG
        Upload Document BS    ${path}

        Sleep    2s
        ${txtYes} =   Run Keyword And Return Status    Page Should Contain Text    Yes
        Run Keyword If    ${txtYes}    Click Text    Yes      exact_match=True

        Wait Until Element Is Visible    ${${platformName}_${lang}_BankName}    timeout=3s
        Click Element     ${${platformName}_${lang}_BankName}
        ${status}   Run Keyword And Return Status       Wait Until Element Is Visible    ${${platformName}_${lang}_SearchBankName}      timeout=5s
        IF    '${status}' == 'True'
            Input Text    ${${platformName}_${lang}_SearchBankName}    ${BankName}
            Close keyboard
        END
        ${Android_selectBankName}       Set Variable    xpath=((//android.widget.TextView[@text='${BankName}'])/..)
        ${iOS_selectBankName}           Set Variable    chain=**/XCUIElementTypeOther[`label == '${Bank_Name}'`][-1]
        Wait Until Element Is Visible      ${${platformName}_selectBankName}
        Click Element    ${${platformName}_selectBankName}
        IF    '${Insurance_Flow}' != 'claim'
            Click Element           ${${platformName}_${lang}_bankNamebtnDone}
        END
        Click Element    ${${platformName}_${lang}_BankAccNo}
        IF    '${platformName}' == 'iOS'
             Input Text    ${${platformName}_${lang}_BankAccountNoInput}    ${BankAccountNo}\n
        ELSE
            Input Text    ${${platformName}_${lang}_BankAccountNoInput}    ${BankAccountNo}
            Close keyboard
        END
        ${status}      Run Keyword And Return Status    Wait Until Element Is Visible   ${${platformName}_${lang}_Account_Type_Dropdown}     timeout=2s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_Account_Type_Dropdown}
            ${Android_selectAccountType}    Set Variable    android=new UiSelector().text("${AccountType}")
            ${iOS_selectAccountType}    Set Variable    chain=**/XCUIElementTypeOther[`label == '${AccountType}'`][-1]
            Wait Until Element Is Visible    ${${platformName}_selectAccountType}
            Click Element    ${${platformName}_selectAccountType}
            Click Element    ${${platformName}_${lang}_btnDone}
        END

        ${status}      Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Error_MSg_bankaccountno_txt}        timeout=2s
       IF    '${status}' == 'True'
              ${VP_BankAccErrorMsg}    Get Text     ${${platformName}_${lang}_Error_MSg_bankaccountno_txt}
              Set Global Variable    ${errormsg}      ${VP_BankAccErrorMsg}
              Set Calc VP With Source And Original Values    Invalid_Name   ${VP_BankAccErrorMsg}       ${VP_BankAccErrorMsg}     Static    OMNE_Application    ${VP_BankAccErrorMsg}       ${VP_BankAccErrorMsg}

       END

       ${status}      Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_BankAcc_HolderName}        timeout=2s
       IF    '${status}' == 'True'
              ${BankAccHolderName}    Get Text     ${${platformName}_${lang}_BankAcc_HolderName}
              ${BankAccHolderName}     Strip String          ${BankAccHolderName}
             Set Calc VP With Source And Original Values    Bank Account Holder Name   ${BankAccHolderName}	    ${BankAccHolderName}    Static   OMNE_Application    ${BankAccHolderName}	    ${BankAccHolderName}
       END

        ${PreSelectionstatus}      Run Keyword And Return Status    Element Should Be Enabled     ${${platformName}_${lang}_BankAccNo}         timeout=2s
        IF    '${PreSelectionstatus}' == 'True'
               Set Calc VP With Source And Original Values    Bank_AccountNo_Present    true    ${PreSelectionstatus}     Static   OMNE_Freelook_Cancellation    true    ${PreSelectionstatus}
        END

         ${PostSelectionstatus}      Run Keyword And Return Status   Element Should Be Enabled   ${${platformName}_${lang}_btnSave}         timeout=2s
        Take Screenshot     Addpaymentmethod
        Click Element    ${${platformName}_${lang}_btnSave}

    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Add Payment Method
    END


Navigate to Home Page
     Set Library Search Order    AppiumLibrary       SeleniumLibrary
    RefreshPage
    Sleep   2s
    ${status}    Run Keyword And Return Status      Wait Until Element Is Visible    ${${platformName}_${lang}_NavigateBackButton1}    timeout=2s
    IF    '${status}' == 'True'
        Click Element       ${${platformName}_${lang}_NavigateBackButton1}
        Sleep   1s
    END
    ${status}    Run Keyword And Return Status      Wait Until Element Is Visible    ${${platformName}_${lang}_NavigateBackButton}    timeout=2s
    IF    '${status}' == 'True'
        Click Element       ${${platformName}_${lang}_NavigateBackButton}
        Sleep   1s
    END
    ${status}    Run Keyword And Return Status      Wait Until Element Is Visible    ${${platformName}_${lang}_NavigateBackButton}    timeout=2s
    IF    '${status}' == 'True'
        Click Element       ${${platformName}_${lang}_NavigateBackButton}
        Sleep   1s
    END
    ${status}    Run Keyword And Return Status      Wait Until Element Is Visible    ${${platformName}_${lang}_NavigateBackButton}    timeout=2s
    IF    '${status}' == 'True'
        Click Element       ${${platformName}_${lang}_NavigateBackButton}
        Sleep   1s
    END
    ${status}    Run Keyword And Return Status      Wait Until Element Is Visible    ${${platformName}_${lang}_NavigateBackButton}    timeout=2s
    IF    '${status}' == 'True'
        Click Element       ${${platformName}_${lang}_NavigateBackButton}
        Sleep   1s
    END
    ${status}    Run Keyword And Return Status      Wait Until Element Is Visible    ${${platformName}_${lang}_NavigateBackButton}    timeout=2s
    IF    '${status}' == 'True'
        Click Element       ${${platformName}_${lang}_NavigateBackButton}
        Sleep   1s
    END
    ${status}    Run Keyword And Return Status      Wait Until Element Is Visible    ${${platformName}_${lang}_UpdatePolicyBackButton}    timeout=2s
    IF    '${status}' == 'True'
        Click by Coordinates    219    58
        Sleep   1s
        Click Element       ${${platformName}_${lang}_UpdatePolicyBackButton}
        Sleep   1s
    END
    ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_EnterPinField}          timeout=5s
    IF    '${status}' == 'True'
        Input Text    ${${platformName}_${lang}_EnterPinField}    123456
        FOR    ${counter}    IN RANGE    1    7
           Log    ${counter}
            Click Element       chain=**/XCUIElementTypeOther[`name == "${counter}"`]
        END
        Sleep    1s
        Click Element    ${${platformName}_${lang}_ConfirmButton}
    END
    ${status}    Run Keyword And Return Status      Wait Until Element Is Visible    ${${platformName}_${lang}_insuranceButton}    timeout=5s
    IF    '${status}' == 'True'
        Click Element       ${${platformName}_${lang}_insuranceButton}
        Sleep   1s
    END


FATCA Status Change
    TRY
         Wait Until Element Is Visible    ${${platformName}_${lang}_Fatca_Status_Change_header}
        Input Text    ${${platformName}_${lang}_us_id_passport_no}    ${US_ID_Passport_Number}\n
        Input Text    ${${platformName}_${lang}_us_tax_id_social_security_no}    ${US_Tax_ID_Social_Security_No}\n
     #    Address
        Input Text    ${${platformName}_${lang}_street_number}    ${Street_Number}
        Input Text    ${${platformName}_${lang}_City}    ${City}
        Close keyboard
        Click Element    ${${platformName}_${lang}_State_Dropdown}
        Wait Until Element Is Visible    ${${platformName}_${lang}_beneficiary_dropdown_search_field}
        Input Text    ${${platformName}_${lang}_beneficiary_dropdown_search_field}    ${State}
        Close keyboard
        ${Android_SelectState}    Set Variable
        ...    android=new UiSelector().className("android.widget.TextView").text("${State}")
        ${iOS_SelectState}    Set Variable    chain=**/XCUIElementTypeOther[`label == '${State}'`][-1]
        Click Element    ${${platformName}_SelectState}
        Wait Until Element Is Visible    ${${platformName}_${lang}_Postal_Code}
        Input Text    ${${platformName}_${lang}_Postal_Code}    ${Postal_Code}\n
        Take Screenshot    Fatca Change Details
    #    Upload Documents
        SwipePage
        Sleep    2s
        Click Element    ${${platformName}_${lang}_add_document_btn}
        IF    '${platformName}' == 'Android'
            ${path}    Set Variable    ${EXECDIR}/CustomLibraries/test.png
            Upload Document BS    ${path}
        ELSE
            Capture Image
        END
        Take Screenshot    Fatca Change Details
        Click Element    ${${platformName}_${lang}_btnSave}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FATCA Status Change
    END

Check if button is enabled and click
    [Arguments]    ${locator}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    ${locator}    timeout=3s
    IF    '${status}' == 'True'
        Click Element    ${locator}
    ELSE
        ${errormsg}    Set Variable    Button is not Enabled
        Set Global Variable    ${errormsg}
    END

Scroll Till Transaction Is Visible
    [Arguments]    ${locator}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=5s
    IF    '${status}' != 'True'
        WHILE    '${status}' != 'True'
            SwipePage
            ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=2s
            IF    '${status}' == 'True'    BREAK
        END
    END

Get FundCode from Dic
    [Arguments]    ${Fundname}
    &{fundcodeDict}    Create Dictionary
    ...    FWD Peso Balanced Fund=PBBA
    ...    FWD Peso Equity Fund=PBEA
    ...    FWD Peso Fixed Income Fund=PBFA
    ...    FWD PHP NitroGlobalPayoutFund=PFBA
    ...    FWDPHPVelocityGlobalPayoutFund=PFBB
    ...    FWD Global Good Peso ESG Fund=PFEA
    ...    FWD Diversity Fund=PFEB
    ...    FWD PHP STRD Income Fund 2030=PFPA
    ...    FWD Peso Stable Fund=PSBA
    ...    FWD Peso Growth Fund=PSEA
    ...    FWD Peso High Divd. Eq. Fund=PSEB
    ...    FWD Peso Equity Index Fund=PSEC
    ...    FWD Peso Bond Fund=PSFA
    ...    FWD PHP Pitstop Liquidity Fund=PSMA
    ...    FWD USD NitroGlobalPayout Fund=UXBA
    ...    FWD USD VelocityGlblPayoutFund=UXBB
    ...    FWD Global USD Equity Index=UXEA
    ...    FWD Global Good USD ESG Fund=UXEB
    ...    FWD USD Pitstop Liquidity Fund=UXFA
    ...    FWD USD Pitstop Liquidity Fund=UXMA

    ${fundcode}    Get From Dictionary    ${fundcodeDict}    ${Fundname}
    RETURN    ${fundcode}

Month Dic
    [Arguments]    ${month}
    &{Month_dic}    Create Dictionary
    ...    01=January
    ...    02=February
    ...    03=March
    ...    04=April
    ...    05=May
    ...    06=June
    ...    07=July
    ...    08=Auguest
    ...    09=September
    ...    10=October
    ...    11=November
    ...    12=December
    ...    January=01
    ...    February=02
    ...    March=03
    ...    April=04
    ...    May=05
    ...    June=06
    ...    July=07
    ...    August=08
    ...    September=09
    ...    October=10
    ...    November=11
    ...    December=12
#    ${month}    Evaluate    str(${month}).zfill(2)
    ${Month_value}    Get From Dictionary    ${Month_dic}    ${month}
    RETURN    ${Month_value}

Select Policy
    TRY
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_EN_PolicyNotAvailable}
        ...    timeout=5s
        IF    '${status}' == 'True'
            Set Global Variable    ${errormsg}    No Eligible Policy
        END
        #    Click On Policy Number
        ${Android_SelectPolicyNo}    Set Variable    android=new UiSelector().textContains("${Policy_No}")
        ${iOS_SelectPolicyNo}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Policy_No}'`][-1]
        Scroll Till Transaction Is Visible    ${${platformName}_SelectPolicyNo}
        Wait Until Page Contains Element    ${${platformName}_SelectPolicyNo}       timeout=30s
        Take Screenshot    Select Policy
        Click Element    ${${platformName}_SelectPolicyNo}
        #        ${PolicyDetails}    Get Text    ${${platformName}_SelectPolicyNo}
        Set Global Variable    ${${platformName}_SelectPolicyNo}
   EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Select Policy ${Insurance_Flow}
   END




Handle Feedback
    ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_FeedbackPage_Title}     timeout=20s
    IF    '${status}' == 'True'
       Take Screenshot    FeedBack_Page
        ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_FeebackEmoji_Option}     timeout=20s
        IF    '${status}' == 'True'
            Click Element   ${${platformName}_${lang}_FeebackEmoji_Option}
        ELSE
            Click Element   ${${platformName}_${lang}_Seven_Txt}
        END
       ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Feedback_CheckBox}      timeout=10s
       IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_Feedback_CheckBox}
       ELSE
            Click Element    ${${platformName}_${lang}_Feedback_Claim_CheckBox}
       END
       Sleep    2s
        Click Element    ${${platformName}_${lang}_FeedbackSubmit_Btn}
        ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_FeedbackSkip_Btn}    timeout=10s
        Take Screenshot    Feedback_Page
        IF    '${status}' == 'True'
            Input Text    ${${platformName}_${lang}_FeedbackComment_Txt}    Feedback Sample Text
            Close keyboard
            Click Element    ${${platformName}_${lang}_TellUsMoreTxt}
            Take Screenshot     FeedBack_Page
            Click Element    ${${platformName}_${lang}_FeedbackSubmit_Btn}
            ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_FeedbackDone_Btn}    timeout=10s
            Take Screenshot    FeedbackPage
            IF    '${status}' == 'True'
                Click Element    ${${platformName}_${lang}_FeedbackDone_Btn}
            END
            ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_FeedbackSubmit_Btn}    timeout=3s
            Take Screenshot    FeedbackPage
            IF    '${status}' == 'True'
                Click Element    ${${platformName}_${lang}_FeedbackSubmit_Btn}
            END
        END
#        Click Element    ${${platformName}_${lang}_FeedbackDone_Btn}
    END
    ${Android_EN_InsurancePage}    Set Variable    android=new UiSelector().text("${Flow_Flag}")
    ${iOS_EN_InsurancePage}    Set Variable    chain=**/XCUIElementTypeButton[`label == '${Flow_Flag}'`]
    ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_InsurancePage}   timeout=30s
    Take Screenshot    Feedback_Page
    IF    '${status}' == 'True'
            Take Screenshot    FWD_Insurance_Page
            Click Element    ${${platformName}_${lang}_InsurancePage}
    END




Check Transaction Status
    TRY
         ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_All_Done_Txt}
        ...    timeout=20s

        IF    '${status}' == 'True'
            Take Screenshot    TransactionStatusPage
            ${VP_All_Done}    Get Text    ${${platformName}_${lang}_All_Done_Txt}
            Set Global Variable    ${Successmsg}    ${VP_All_Done}
            Set Calc VP With Source And Original Values
            ...    OMNE_Transaction_Status
            ...    All Done!
            ...    ${VP_All_Done}
            ...    Static
            ...    OMNE_Application
            ...    All Done!
            ...    ${VP_All_Done}
        ELSE
            Take Screenshot    TransactionStatusPage
            Wait Until Element Is Visible           ${${platformName}_${lang}_Submitted_Txt}     timeout=10s
            ${VP_Submitted}    Get Text    ${${platformName}_${lang}_Submitted_Txt}
            Set Global Variable    ${Successmsg}    ${VP_Submitted}
            Set Calc VP With Source And Original Values
            ...    OMNE_Transaction_Status
            ...    ${VP_Submitted}
            ...    ${VP_Submitted}
            ...    Static
            ...    OMNE_Application
            ...    ${VP_Submitted}
            ...    ${VP_Submitted}
        END
        Click Element    ${${platformName}_${lang}_DoneButton}
        Take Screenshot    Dashboard_Page
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Check Transaction Status
    END


Set or enter PIN
    TRY
        Take Screenshot    PIN PopUp
        ${status}       Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_SetPin}     timeout=2s
        ${enterpinstatus}       Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_EnterPinField}     timeout=2s
        ${enterpinFieldStatus}      Run Keyword And Return Status    Wait Until Element Is Visible      ${${platformName}_${lang}_SetPinField}  timeout=2s
        IF    '${status}' == 'True' or '${enterpinFieldStatus}' == 'True'
            IF    '${status}' == 'True'
                Click Element    ${${platformName}_${lang}_SetPin}
            END
            IF    '${enterpinFieldStatus}' == 'True'
                Click Element    ${${platformName}_${lang}_SetPinField}
            END
            Wait Until Element Is Visible    ${${platformName}_${lang}_SetPinField}       timeout=2s
#            Input Text    ${${platformName}_${lang}_SetPinField}    123456
            FOR    ${counter}    IN RANGE    1    7
               Log    ${counter}
               IF    '${platformName}' == 'iOS'
                    Click Element       chain=**/XCUIElementTypeOther[`name == "${counter}"`]
               ELSE
                    ${counter}      Set Variable    0
                    ${Android_EN_pin}           Set Variable    xpath=//android.view.ViewGroup[@content-desc="${counter}"]
                    Click Element       ${${platformName}_${lang}_Pin}
               END
            END
            Take Screenshot    enter new pin Page
            Click Element    ${${platformName}_${lang}_NextButton}
            Wait Until Element Is Visible    ${${platformName}_${lang}_ConfirmPinField}       timeout=2s
            Click Element   ${${platformName}_${lang}_ConfirmPinField}
#            Input Text    ${${platformName}_${lang}_ConfirmPinField}    123456
            FOR    ${counter}    IN RANGE    1    7
               Log    ${counter}
                IF    '${platformName}' == 'iOS'
                    Click Element       chain=**/XCUIElementTypeOther[`name == "${counter}"`]
               ELSE
                    ${counter}      Set Variable    0
                    ${Android_EN_pin}           Set Variable    xpath=//android.view.ViewGroup[@content-desc="${counter}"]
                    Click Element       ${${platformName}_${lang}_Pin}
               END
            END
            Take Screenshot    Re-enter pin page
            Click Element    ${${platformName}_${lang}_ConfirmButton}
            ${status}   Run Keyword And Return Status       Wait Until Element Is Visible    ${${platformName}_${lang}_SkipButton}       timeout=2s
            IF    '${status}' == 'True'
                Take Screenshot     Enable biometric popup
                Click Element       ${${platformName}_${lang}_SkipButton}
            END
        ELSE IF     '${enterpinstatus}' == 'True'
            Wait Until Element Is Visible    ${${platformName}_${lang}_EnterPinField}       timeout=2s
            Click Element   ${${platformName}_${lang}_EnterPinField}
#            Input Text    ${${platformName}_${lang}_EnterPinField}    123456
            FOR    ${counter}    IN RANGE    1    7
               Log    ${counter}
                IF    '${platformName}' == 'iOS'
                    Click Element       chain=**/XCUIElementTypeOther[`name == "${counter}"`]
               ELSE
                    ${counter}      Set Variable    0
                    ${Android_EN_pin}           Set Variable    xpath=//android.view.ViewGroup[@content-desc="${counter}"]
                    Click Element       ${${platformName}_${lang}_Pin}
               END
            END
            Take Screenshot    enter new pin Page
            Click Element    ${${platformName}_${lang}_ConfirmButton}
        END

#        Pause Execution
        Overall APP Experience
    EXCEPT     AS  ${reason}
       Set Failed Actual Result and VP    Omne_Flow   ${reason}   SET UP PIN
    END



Claim Feedback
    Take Screenshot    FeedBack_Page
    ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_FeedbackRangeoption}   timeout=60s
    Take Screenshot    Feedback_Page
    IF    '${status}' == 'True'
        Click Element   ${${platformName}_${lang}_FeedbackRangeoption}
        Wait Until Element Is Visible    ${${platformName}_${lang}_FeedbackReviewOption}
        Click Element    ${${platformName}_${lang}_FeedbackReviewOption}
        Sleep    2s
        Click Element    ${${platformName}_${lang}_FeedbackSubmit_Btn}
        ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_FeedbackSkip_Btn}    timeout=30s
        Take Screenshot    Feedback_Page
        IF    '${status}' == 'True'
            Input Text    ${${platformName}_${lang}_FeedbackComment_Txt}    Good
            Close keyboard
            Click Element    ${${platformName}_${lang}_TellUsMoreTxt}
            Take Screenshot     FeedBack_Page
            Click Element    ${${platformName}_${lang}_FeedbackSubmit_Btn}
            ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_FeedbackDone_Btn}    timeout=30s
            Take Screenshot    FeedbackPage
            IF    '${status}' == 'True'
                Click Element    ${${platformName}_${lang}_FeedbackDone_Btn}
            END
        END
        ${Android_EN_InsurancePage}    Set Variable    android=new UiSelector().text("${Flow_Flag}")
        ${iOS_EN_InsurancePage}    Set Variable    chain=**/XCUIElementTypeButton[`label == '${Flow_Flag}'`]
        ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_InsurancePage}   timeout=30s
        Take Screenshot    Feedback_Page
        IF    '${status}' == 'True'
                Take Screenshot    FWD_Insurance_Page
                Click Element    ${${platformName}_${lang}_InsurancePage}
        END
        Set or enter PIN
    END
    ${PolAdddf}    Run Keyword
    ...    Get Selected Policy Detail from customer policies
    ...    ${dbhostname}
    ...    ${dbusername}
    ...    ${dbpassword}
    ...    ${dbport}
    ...    ${dbinstance}
    ...    ${Policy_No}
    ...    ${screenshotPath}
    Log    ${PolDetaildf}
    ${leng}    Get Length    ${PolDetaildf}
    Log    ${leng}
    ${list0}    Get From List    ${PolDetailsdf}    0
    Log    ${list0}
    ${index1}    Get Index From List    ${list0}    Point
    Log    ${index1}
    ${Point}    Set Variable    ${list}[${index1}]
    ${Point}    Strip String    ${Point}
    Set Calc VP With Source And Original Values    Wallet_Point    ${Point}    ${Point}    Static    DB    ${Point}    ${Point}

Overall APP Experience
    ${status}    Run Keyword And Return Status      Wait Until Element Is Visible       ${${platformName}_${lang}_OverAllAppExperience}     timeout=3s
    IF    '${status}' == 'True'
         Take Screenshot    Feedback Page
         Wait Until Element Is Visible       ${${platformName}_${lang}_FeedBackStars}     timeout=30s
         Click Element      ${${platformName}_${lang}_FeedBackStars}

        Take Screenshot    Feedback Page
    END

Regestration Experience Feedback
     ${status}    Run Keyword And Return Status      Wait Until Element Is Visible       ${${platformName}_${lang}_RegestrationExp}     timeout=5s
    IF    '${status}' == 'True'
        Take Screenshot     Regestration Feedback Page
         Wait Until Element Is Visible       ${${platformName}_${lang}_Regestration_StartFeedback}     timeout=30s
         Click Element      ${${platformName}_${lang}_Regestration_StartFeedback}
         Take Screenshot    Regestration Feedback Page
    END

Biometric Check
    TRY
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible        ${${platformName}_${lang}_TakeMEHere_Btn}     timeout=5s
        IF    '${status}' == 'True'
             Sleep      5s
             Wait Until Element Is Visible    ${${platformName}_${lang}_TakeMEHere_Btn}      timeout=20s
             Click Element    ${${platformName}_${lang}_TakeMEHere_Btn}
             Sleep    15s
             Take Screenshot     Biometric_Enable_Page
             Wait Until Element Is Visible    ${${platformName}_${lang}_setting_Btn}    timeout=30s
             Click Element    ${${platformName}_${lang}_setting_Btn}
             Take Screenshot     Biometric_Enable_Page
             Wait Until Element Is Visible       ${${platformName}_${lang}_Biometric_toggle}     timeout=20s
             Click Element    ${${platformName}_${lang}_Biometric_toggle}
             Wait Until Element Is Visible          ${${platformName}_${lang}_Biometric_Status}     timeout=20s
              Take Screenshot     Biometric_Enable_Page
              IF    '${platformName}' == 'iOS'
                    Click Text        Pass        extact_match=true
              ELSE
                    Click Element    ${${platformName}_${lang}_Biometric_Status}
              END
            Click Element    ${${platformName}_${lang}_BAck_Btn}
             Sleep      2s
              Take Screenshot     Biometric_Enable_Page
              Click Element    ${${platformName}_${lang}_BAck_Btn}
              Take Screenshot     Biometric_Enable_Page
              Sleep      2s
              IF    '${platformName}' == 'iOS'
                    Click Text        Pass        extact_match=true
              ELSE
                    Click Element    ${${platformName}_${lang}_Biometric_Status}
              END

    #          Click Text        Pass        extact_match=true
    #          Click Element    ${${platformName}_${lang}_Biometric_Status}
        END
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_BiometricEnable_Txt}
        ...    timeout=10s
        IF    '${status}' == 'True'
            Sleep    2s
            Click Element    ${${platformName}_${lang}_TakeMEHere_Btn}
            Sleep    5s
            Click Element    ${${platformName}_${lang}_BAck_Btn}
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Biometric Check
    END

Transaction Success Page
    ${status}   Run Keyword And Return Status      Wait Until Element Is Visible    ${${platformName}_${lang}_AllDoneBtn}       timeout=10s
    IF    '${status}' == 'True'
        Take Screenshot    All Done Page
        Click Element    ${${platformName}_${lang}_AllDoneBtn}
        Handle Feedback
        Wait Until Element Is Visible        ${${platformName}_${lang}_TransactionTab}        timeout=50s
        Click Element        ${${platformName}_${lang}_TransactionTab}
        ${status}       Run Keyword And Return Status   Wait Until Element Is Visible        ${${platformName}_${lang}_TransactionServiceRequest}   timeout=50s
        IF    '${status}' != 'True'
            Click Element        ${${platformName}_${lang}_TransactionTab}
        END
        Wait Until Element Is Visible        ${${platformName}_${lang}_TransactionServiceRequest}   timeout=10s
        Click Element    ${${platformName}_${lang}_TransactionServiceRequest}
    END

Extra POP Up
    ${Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Popup_SKIP}   timeout=3s
    IF    '${status}' == 'True'
        Click Element    ${${platformName}_${lang}_Popup_SKIP}
    END

    ${Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Popup_Confirm_btn}   timeout=3s
    IF    '${status}' == 'True'
        Click Element    ${${platformName}_${lang}_Popup_Confirm_btn}
    END

    ${status}    Run Keyword And Return Status    Wait Until Page Contains    Continue    timeout=3s
    IF    '${status}' == 'True'
        Click Text    Continue    exact_match=true
        Take Screenshot    PostSignInHome_Page
    END
Click by Coordinates
    [Arguments]     ${xaxis}    ${yaxis}
    @{coordinates}  Create List     ${xaxis}      ${yaxis}
    Tap     ${coordinates}      count=1