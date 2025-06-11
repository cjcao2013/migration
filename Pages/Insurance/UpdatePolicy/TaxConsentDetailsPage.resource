*** Settings ***
Library     AppiumLibrary
Library     String
Library     ../../Qrace/QraceHelper.py
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/TaxConsentDetailsPageObjects.resource


*** Variables ***
${result}       ${EMPTY}


*** Keywords ***
Tax consent
    # header VP
    IF    '${Transaction_Page_GUI}' == 'Yes'
        ${VP_TaxConsent_HeaderText}    Get Text    ${${platformName}_${lang}_TaxConsent_HeaderText}
        Set Calc VP With Source And Original Values
        ...    Exercise tax deduction for insurance premiums
        ...    Exercise tax deduction for insurance premiums
        ...    ${VP_TaxConsent_HeaderText}
        ...    Static
        ...    OMNE_TaxConsent_Page
        ...    Exercise tax deduction for insurance premiums
        ...    ${VP_TaxConsent_HeaderText}

        ${Status}    Run Keyword And Return Status
        ...    Wait Until Page Contains Element
        ...    ${${platformName}_${lang}_TaxConsent_YesOption}      timeout=3s
        Set Calc VP With Source And Original Values
        ...    Tax_Consent_YesOption_Avalible
        ...    true
        ...    ${Status}
        ...    Static
        ...    OMNE_TaxConsent_Page
        ...    true
        ...    ${Status}
        ${Status}    Run Keyword And Return Status
        ...    Wait Until Page Contains Element
        ...    ${${platformName}_${lang}_TaxConsent_NoOption}       timeout=3s
        Set Calc VP With Source And Original Values
        ...    Tax_Consent_NoOption_Avalible
        ...    true
        ...    ${Status}
        ...    Static
        ...    OMNE_TaxConsent_Page
        ...    true
        ...    ${Status}

        Take Screenshot    Tax_Consent_Page
    END
    IF    '${TaxConsent_acknowledgement_status}' == 'Yes'
        ${Android_EN_TCAckStatus}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${TaxConsent_acknowledgement_status}']/preceding-sibling::android.view.ViewGroup)[2]
    ELSE
        ${Android_EN_TCAckStatus}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${TaxConsent_acknowledgement_status}']/preceding-sibling::android.view.ViewGroup)[3]
    END
    ${Android_PolicyNo}    Set Variable
    ...    xpath=(//android.widget.TextView[contains(@text,'${Policy_No}')]/../preceding-sibling::android.view.ViewGroup)
    ${iOS_PolicyNo}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label ENDSWITH "Policy no: ${Policy_No}"`][-1]
    ${Android_PolicyName}    Set Variable
    ...    xpath=//android.widget.TextView[@text='Policy no: ${Policy_No}']/preceding-sibling::android.widget.TextView
    ${iOS_PolicyName}    Set Variable
    ...    xpath=//XCUIElementTypeStaticText[@name="Policy no: ${Policy_No}"]//preceding-sibling::XCUIElementTypeStaticText
    # select Yes or no Option
    IF    '${TaxConsent_acknowledgement_status}' == 'Yes'
#            Click Element    chain=**/XCUIElementTypeOther[`name == "Select all"`]
            Wait Until Page Contains Element    ${${platformName}_${lang}_TaxConsent_YesOption}         timeout=10s
            Click Element    ${${platformName}_${lang}_TaxConsent_YesOption}
    ELSE
            Wait Until Page Contains Element    ${${platformName}_${lang}_TaxConsent_NoOption}          timeout=10s
            Click Element    ${${platformName}_${lang}_TaxConsent_NoOption}
    END
#    Pause Execution
    Take Screenshot    Tax_Consent_Page

#    IF    '${TaxConsent_acknowledgement_status}' == 'Yes'
#
#        IF    '${platformName}' == 'Android'
#            ${Status}    Run Keyword And Return Status
#            ...    Element Should Be Enabled
#            ...    ${${platformName}_${lang}_TaxConsent_SubmitButton}
#            IF    '${Status}' == 'True'
#                Click Element    ${${platformName}_PolicyNo}
#            END
#        ELSE
#            ${Status}    Run Keyword And Return Status
#            ...    Element Should Be Enabled
#            ...    ${${platformName}_${lang}_TaxConsent_SubmitButton}
#            IF    '${Status}' != 'True'
##                Click Element    ${${platformName}_PolicyNo}
#                 Click Text    ${Policy_No}
#            END
#        END
#
#        Take Screenshot    Tax_Consent_Page
#    END
    Wait Until Page Contains Element    ${${platformName}_${lang}_TaxConsent_NextButton}        timeout=2s
    Click Element    ${${platformName}_${lang}_TaxConsent_NextButton}
    Take Screenshot    Tax_Consent_Page
     ${Status}    Run Keyword And Return Status             Wait Until Element Is Visible    ${${platformName}_${lang}_TaxConsent_proceedBtn}       timeout=2s
     IF    '${Status}' == 'True'
        Click Element    ${${platformName}_${lang}_TaxConsent_proceedBtn}
     END
    # Previous OTP from DB
    Get Details from DB
    ${Previous_OTP}    Set Variable    ${OTPNumber}
    Set Global Variable    ${Previous_OTP}
    ${Status}    Run Keyword And Return Status
    ...    Element Should Be Enabled
    ...    ${${platformName}_${lang}_TaxConsent_SubmitButton}
    ...    timeout=2s
#    Set Calc VP With Source And Original Values    Tax_Consent_SubmitButton_Enable_AfterSelect_Option    true    ${Status}    Static    OMNE_TaxConsent_Page    true    ${Status}
    Click Element    ${${platformName}_${lang}_TaxConsent_SubmitButton}
    Take Screenshot    Tax_Consent_Page

    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_OTP_email}
    ...    timeout=2s
    IF    '${status}' == 'True'
        Insert OTP    ${Transaction_OTP_Source}    ${Transaction_OTP_Expiry_Flag}    ${Transaction_OTP_Resend_Flag}
    ELSE
        Fail    Tax Consent submit button is disabled
    END
    Take Screenshot    Tax_Consent_Page

        # New All Done Confirmation Page
    ${sOutput}    Run Keyword And Ignore Error    Check Transaction Status
    IF    ${sOutput} != ('PASS', None)
        Take Screenshot    Update Policy
        ${failure_reason}    Fetch Reason    ${sOutput}
        RETURN    ${failure_reason}
    END
    ${sOutput}    Run Keyword And Ignore Error    Completion Popup
    IF    ${sOutput} != ('PASS', None)
        Take Screenshot    Update Policy
        ${failure_reason}    Fetch Reason    ${sOutput}
        RETURN    ${failure_reason}
    END

    Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=5s
    Click Element    ${${platformName}_${lang}_SeeAll}
    Take Screenshot    Transaction_Page
    Wait Until Page Contains Element    ${${platformName}_${lang}_ServiceReuest}    timeout=2s
    Click Element    ${${platformName}_${lang}_ServiceReuest}
    Take Screenshot    Transaction_Page
    ${sOutput}    Run Keyword And Ignore Error    Capture Tax Consent Transaction Details for ${platformName}    Pre
    IF    ${sOutput} != ('PASS', None)
        Take Screenshot    Update Policy
        ${failure_reason}    Fetch Reason    ${sOutput}
        RETURN    ${failure_reason}
    END

    Set Global Variable    ${result}    Tax Consent Completed Successfully for policy No: ${Policy_No}

Capture Tax Consent Transaction Details for iOS
    [Arguments]    ${Transaction_Info}
#    Take Screenshot    Transaction Page
#    Wait Until Element Is Visible    ${${platformName}_${lang}_ViewTransaction}    timeout=20s
#    Click Element    ${${platformName}_${lang}_ViewTransaction}

    Take Screenshot    Transaction Page
    IF    '${Transaction_Info}'== 'Pre'

        RefreshPage
        ${iOS_selectCurrentTransaction1}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'tax consent'`][27]
    END
    Wait Until Page Contains Element    ${${platformName}_selectCurrentTransaction1}            timeout=30s
    Click Element    ${${platformName}_selectCurrentTransaction1}

    ${TransactionDetail}        Get Text    ${${platformName}_selectCurrentTransaction1}
    ${status}       Run Keyword And Return Status    Should Contain    ${TransactionDetail}     Policies
        IF    '${status}' == 'True'
#            ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction1}
            @{transactionstatusdetail1}    Split String    ${TransactionDetail}    Policies
            ${transactionstatus}    Get From List    ${transactionstatusdetail1}    0
            @{transactionstatusdetail}    Split String    ${transactionstatus}    tax consent
            ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
            ${status}       Run Keyword And Return Status    Should Contain    ${transactionstatus}     Completed
            IF    '${status}' == 'True'
                ${mTransactionstatus}    Set Variable    Approve
                ${OPUSTransactionstatus}    Set Variable    Completed
                Set Global Variable    ${OPUSTransactionstatus}
                Log To Console    Test1=${mTransactionstatus}
            END
        ELSE
            @{transactionstatusdetail1}    Split String    ${TransactionDetail}    Policy no
            ${transactionstatus}    Get From List    ${transactionstatusdetail1}    0
            @{transactionstatusdetail}    Split String    ${transactionstatus}    tax consent
            ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
            ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
            ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
            IF    '${mTransactionstatus}' == 'Completed'
                ${mTransactionstatus}    Set Variable    Approve
                ${OPUSTransactionstatus}    Set Variable    Completed
                Set Global Variable    ${OPUSTransactionstatus}
            END
        END
#        ${status}       Run Keyword And Return Status    Should Contain    ${Test}     Policy(s)
        IF    '${TaxConsent_acknowledgement_status}' == 'Yes'
                ${transactionlist}    Get From List    ${transactionstatusdetail1}    1
                Log To Console    ${transactionlist}
                ${status}       Run Keyword And Return Status    Should Contain    ${transactionlist}     Policy(s) applied for tax exemption
                IF    '${status}' == 'True'
                        Log To Console    Test1
                        @{TransactionDeatilsList}    Split String    ${transactionlist}     Policy(s) applied for tax exemption
                        ${YesOption}       Get From List            ${TransactionDeatilsList}       1
                        ${VP_TaxConsent_Option}         Set Variable        Yes
                        ${status}       Run Keyword And Return Status    Should Contain    ${transactionlist}     Policy(s) not applied for tax exemption
                        IF    '${status}' == 'True'
                            @{YesOption}       Split String           ${YesOption}
                            ${YesOption}        Get From List    ${YesOption}    0
                            ${status}       Run Keyword And Return Status    Should Contain    ${transactionlist}     ${Policy_No}
                            IF    '${status}' == 'True'
                                ${VP_TaxConsent_Option}         Set Variable        Yes

                            END
                        END

                END

        ELSE
            ${transactionlist}    Get From List    ${transactionstatusdetail1}    1
                Log To Console    ${transactionlist}
                ${status}       Run Keyword And Return Status    Should Contain    ${transactionlist}     Policy(s) not applied for tax exemption
                IF    '${status}' == 'True'
                        Log To Console    Test1
                        @{TransactionDeatilsList}    Split String    ${transactionlist}     Policy(s) not applied for tax exemption
                        ${YesOption}       Get From List            ${TransactionDeatilsList}       1
                        ${VP_TaxConsent_Option}         Set Variable        No
                        ${status}       Run Keyword And Return Status    Should Contain    ${transactionlist}     Policy(s) not applied for tax exemption
                        IF    '${status}' == 'True'
                            @{YesOption}       Split String           ${YesOption}
                            ${YesOption}        Get From List    ${YesOption}    0
                            ${status}       Run Keyword And Return Status    Should Contain    ${transactionlist}     ${Policy_No}
                            IF    '${status}' == 'True'
                                ${VP_TaxConsent_Option}         Set Variable        No

                            END
                        END

                END
        END

    #    Log To Console    CompletionDate=${VP_CompletonDate}
    IF    '${Transaction_Info}' == 'Pre'

        Set Calc VP Expected Result With Original And Source
        ...    TaxConsent_Option
        ...    ${VP_TaxConsent_Option.strip()}
        ...    ${VP_TaxConsent_Option.strip()}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status
        ...    ${mTransactionstatus.strip()}
        ...    ${mTransactionstatus.strip()}
        ...    OMNE_Application
#        Set Calc VP Expected Result With Original And Source
#        ...    Completion_Date
#        ...    ${VP_TaxConsent_CompletionDate.strip()}
#        ...    ${VP_TaxConsent_CompletionDate}
#        ...    OMNE_TransactionPage
    END
    IF    '${CoreSystem_Flag}' == 'Yes'
        Set Calc VP Expected Result With Original And Source
        ...    ${Core_System}_TaxConsent_acknowledgement_status
        ...    ${TaxConsent_acknowledgement_status}
        ...    ${TaxConsent_acknowledgement_status}
        ...    TestData
    END

Capture Tax Consent Transaction Details for Android
    [Arguments]    ${Transaction_Info}
    Take Screenshot    Transaction Page

    Take Screenshot    Transaction Page
    #    ${Android_selectCurrentTransaction}    Set Variable    xpath
    IF    '${Transaction_Info}'== 'Pre'

        RefreshPage
        ${Android_selectCurrentTransaction1}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of tax consent'])[1]
    END
    Wait Until Page Contains Element    ${Android_selectCurrentTransaction1}    timeout=50s
    ${VP_Transaction_Status}    Get Text    ${${platformName}_${lang}_TransactionStatusTaxConsent}
    Click Element    ${Android_selectCurrentTransaction1}


    IF    '${TaxConsent_acknowledgement_status}' == 'Yes'
        Wait Until Element Is Visible    ${${platformName}_${lang}_Transaction_Tax_Yes_Option}      timeout=5s
        ${VP_TaxConsent_Option}    Get Text    ${${platformName}_${lang}_Transaction_Tax_Yes_Option}
        ${VP_TaxConsent_PolicyNumber}    Get Text    ${${platformName}_${lang}_TSTaxConsent_PolicyNumber}
        IF    '${VP_TaxConsent_Option}' == 'Policy(s) applied for tax exemption'
                ${VP_TaxConsent_Option}         Set Variable            Yes
        END
    ELSE
          Wait Until Element Is Visible    ${${platformName}_${lang}_Transaction_Tax_No_Option}     timeout=5s
          ${VP_TaxConsent_Option}    Get Text    ${${platformName}_${lang}_Transaction_Tax_No_Option}
          ${VP_TaxConsent_PolicyNumber}    Get Text    ${${platformName}_${lang}_TSTaxConsent_PolicyNumber}
           IF    '${VP_TaxConsent_Option}' == 'Policy(s) not applied for tax exemption'
                ${VP_TaxConsent_Option}         Set Variable            No
           END
    END
    IF    '${VP_Transaction_Status}' == 'Completed'
        ${mTransactionstatus}    Set Variable    Approve
        Set Global Variable    ${mTransactionstatus}
        ${OPUSTransactionstatus}    Set Variable    Completed
        Set Global Variable    ${OPUSTransactionstatus}

    END
    IF    '${CoreSystem_Flag}' == 'Yes'
        Set Calc VP Expected Result With Original And Source
        ...    ${Core_System}_TaxConsent_acknowledgement_status
        ...    ${TaxConsent_acknowledgement_status}
        ...    ${TaxConsent_acknowledgement_status}
        ...    TestData
    END
    IF    '${Transaction_Info}' == 'Pre'
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status
        ...    ${mTransactionstatus.strip()}
        ...    ${mTransactionstatus.strip()}
        ...    OMNE_Application

        Set Calc VP Expected Result With Original And Source
        ...    TaxConsent_Option
        ...    ${VP_TaxConsent_Option.strip()}
        ...    ${VP_TaxConsent_Option.strip()}
        ...    OMNE_TransactionPage
    END
