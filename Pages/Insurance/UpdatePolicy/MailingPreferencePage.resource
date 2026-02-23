*** Settings ***
Library     AppiumLibrary
Library     RequestsLibrary
Library    SeleniumLibrary

Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/MailingPreferencePageObjects.resource
Resource      ../../../PageObjects/Insurance/Common/CommonObjects.resource
Resource    ../Common/AddOTP.resource
Resource    ../../../CustomLibraries/common.robot




*** Keywords ***
Mailing preference
    [Documentation]     This Keyword is used for perfrom the transaction for mailing preference

    # Select Policy which is mention in data
    Select Policy
    Wait Until Element Is Visible       ${${platformName}_${lang}_NextButton}           timeout=10s
    Click Element    ${${platformName}_${lang}_NextButton}


    # Read the contact details from DB
    Capture DB Email Mobile addressDetails

    Take Screenshot    Mailing preference Selection Page

    #Select Mailing preference through data
    ${iOS_EN_MailingPreference_Option}     Set Variable        chain=**/XCUIElementTypeOther[`name == "${Mailing_preference}"`]
    ${Android_EN_MailingPreference_Option}     Set Variable         xpath=//android.widget.TextView[@text="${Mailing_preference}"]

    Wait Until Element Is Visible    ${${platformName}_${lang}_MailingPreference_Option}         timeout=30s
    Click Element    ${${platformName}_${lang}_MailingPreference_Option}
    Take Screenshot    Mailing preference Page

    ${VP_New_Mailing_Preference}                  Get Text        ${${platformName}_${lang}_NewMailingPreference_Text}

    Run Keyword    ${Mailing_preference} preference
    ${VP_Current_MailingPrefernce}      Get Text    ${${platformName}_${lang}_Current_MailingPreference}
    ${VP_Current_MailingPrefernce.strip()}      Remove String    ${VP_Current_MailingPrefernce}     Current preference:

    Run Keyword    ${VP_Current_MailingPrefernce.strip()}
    #Compare  Mailing preference deatil with Transaction details Page
    Set Calc VP Expected Result With Original And Source   New_Mailing_Preference    ${VP_New_Mailing_Preference}     ${VP_New_Mailing_Preference}     Mailing Preference Page
#    Set Calc VP Expected Result With Original And Source       ${VP_New_Mailing_Preference_Value}     ${VP_New_Mailing_Preference_Value}     Mailing Preference Page


    Wait Until Element Is Visible    ${${platformName}_${lang}_SubmitButton}        timeout=10s
    Click Element    ${${platformName}_${lang}_SubmitButton}
    #run keyword as per data
    Sleep    1s
    Insert OTP    ${Transaction_OTP_Source}    ${Transaction_OTP_Expiry_Flag}    ${Transaction_OTP_Resend_Flag}

    Run Keyword    Check Transaction Status
    Run Keyword    Handle Feedback
    Run Keyword    Capture Transaction Details for Email Mailing Preference ${platformName}
    Take Screenshot    Update_Details
    Set Global Variable    ${result}    Change Mailing Prference Changed to ${Mailing_preference}

Email
    [Documentation]     This keyword is used for  capture current mailing email
    ${VP_Current_MailingPreferenceValue}            Get Text    ${${platformName}_${lang}_Current_Mailing_Email}
    ${VP_Current_MailingPreferenceValue}            Remove String    ${VP_Current_MailingPreferenceValue}       Email:
    Set Global Variable    ${VP_Current_MailingPreferenceValue}

    #comapre current  email with DB
    Set Calc VP With Source And Original Values    Current_Mailing_Preference_Email    ${DB_EmailAddress}    ${VP_Current_MailingPreferenceValue.strip()}    DB Query    Mailing Preference Page    ${DB_EmailAddress}     ${VP_Current_MailingPreferenceValue.strip()}


SMS
    [Documentation]     This keyword is used for  capture current mailing SMS
    ${VP_Current_MailingPreferenceValue}            Get Text    ${${platformName}_${lang}_Current_Mailing_Mobile_number}
    Set Global Variable    ${VP_Current_MailingPreferenceValue}

    ${VP_Current_MailingPreferenceValue}            Remove String    Mobile No:  ${VP_Current_MailingPreferenceValue}
    Set Calc VP With Source And Original Values    Current_Mailing_Preference_Mobile    ${DB_MObileNUmber}    ${VP_Current_MailingPreferenceValue}    DB Query    Mailing Preference Page    ${DB_MObileNUmber}     ${VP_Current_MailingPreferenceValue}


Mailing address
    [Documentation]     This keyword is used for  capture current mailing Mailing address
     ${VP_Current_MailingPreferenceValue}            Get Text    ${${platformName}_${lang}_Current_Mailing_Mobile_number}
    Set Global Variable    ${VP_Current_MailingPreferenceValue}

    ${VP_Current_MailingPreferenceValue}            Remove String    Mobile No:  ${VP_Current_MailingPreferenceValue}
    Set Calc VP With Source And Original Values    Current_Mailing_Preference_MailingAddess    ${DB_MObileNUmber}    ${VP_Current_MailingPreferenceValue}    DB Query    Mailing Preference Page    ${DB_MObileNUmber}     ${VP_Current_MailingPreferenceValue}


Email preference
    [Documentation]   This keyword is used for when we  change mailing preference as Eamil

    ${VP_New_Mailing_Preference_Value}         Get Text       ${${platformName}_${lang}_NewMailing_Email_Text}
    ${VP_New_Mailing_Preference_Value}      Remove String    Eamil:       ${VP_New_Mailing_Preference_Value}
    Set Global Variable     ${VP_New_Mailing_Preference_Value}
    Set Calc VP With Source And Original Values    New_Mailing_Preference_${Mailing_preference}    ${VP_New_Mailing_Preference_Value}    ${DB_EmailAddress}    Mailing Preference Page    DB_Query    ${VP_New_Mailing_Preference_Value}    ${DB_EmailAddress}




SMS preference
    [Documentation]   This keyword is used for when we  change mailing preference as Mobile

    #Capture Current Mailing email
    ${VP_New_Mailing_Preference_Value}            Get Text    ${${platformName}_${lang}_NewMailing_Mobile_Text}
    ${VP_New_Mailing_Preference_Value}              Remove String    ${VP_New_Mailing_Preference_Value}          Mobile no.:
    Set Global Variable     ${VP_New_Mailing_Preference_Value}
    Set Calc VP With Source And Original Values    New_Mailing_Preference_${Mailing_preference}    ${VP_New_Mailing_Preference_Value}    ${DB_MObileNUmber}    Mailing Preference Page    DB_Query    ${VP_New_Mailing_Preference_Value}    ${DB_MObileNUmber}

Post preference
     [Documentation]   This keyword is used for when we  change mailing preference as post


    #Capture Current Mailing email
    ${VP_Current_Mailing_Email}            Get Text    ${${platformName}_${lang}_NewMailing_Post_Text}
    Set Global Variable     ${VP_New_Mailing_Preference_Value}
    Set Calc VP With Source And Original Values    New_Mailing_Preference_${Mailing_preference}    ${VP_New_Mailing_Preference_Value}    ${DB_MObileNUmber}    Mailing Preference Page    DB_Query    ${VP_New_Mailing_Preference_Value}    ${DB_MObileNUmber}


Capture DB Email Mobile addressDetails
    [Documentation]     This Keyword is used for
    Sleep    1s
    ${PDdf}    Get Contact Details
        ...    ${dbhostname}
        ...    ${dbusername}
        ...    ${dbpassword}
        ...    ${dbport}
        ...    ${dbinstance}
        ...    ${Policy_No}
        ...    ${screenshotPath}
        Log    ${PDdf}

    Log    ${PDdf}
    ${leng}    Get Length    ${PDdf}
    Log    ${leng}
    ${list0}    Get From List    ${PDdf}    0
    Log    ${list0}
    ${index1}    Get Index From List    ${list0}    Email
    Log    ${index1}
    ${index2}    Get Index From List    ${list0}    MobileNumber
    Log    ${index2}
    ${index3}    Get Index From List    ${list0}    AddressLine1
    Log    ${index3}
    ${index4}    Get Index From List    ${list0}    AddressLine2
    Log    ${index4}
    ${index5}    Get Index From List    ${list0}    AddressLine3
    Log    ${index5}
    ${index6}    Get Index From List    ${list0}    AddressLine4
    Log    ${index6}
    ${index7}    Get Index From List    ${list0}    AddressLine5
    Log    ${index7}
    ${index8}    Get Index From List    ${list0}    PostalCode
    Log    ${index8}

    ${counter}    Set Variable    1
            #    Log    ${counter}
    ${list0}    Get From List    ${PDdf}    ${counter}
    ${DB_EmailAddress}    Set Variable    ${list0}[${index1}]
    ${DB_MObileNUmber}      Set Variable    ${list0}[${index2}]

    ${DB_EmailAddress}            Decrypt Details       ${DB_EmailAddress}
    ${DB_MObileNUmber}            Decrypt Details       ${DB_MObileNUmber}
    Set Global Variable    ${DB_EmailAddress}
    Set Global Variable    ${DB_MObileNUmber}





Capture Transaction Details for Email Mailing Preference iOS

    [Documentation]     This Keyword is used for capture transaction details
    Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=50s
    Click Element    ${${platformName}_${lang}_SeeAll}
    Take Screenshot    Transaction Page
    Wait Until Page Contains Element    ${${platformName}_${lang}_ServiceReuest}    timeout=50s
    Click Element    ${${platformName}_${lang}_ServiceReuest}

    ${iOS_EN_MailingPreferenceTransaction}          Set Variable      chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change mailing preference' and label CONTAINS 'Policy no: ${Policy_No}'`][27]

    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_MailingPreferenceTransaction}
    Click Element    ${${platformName}_${lang}_MailingPreferenceTransaction}

    ${transactionstatusdetail}             Get Text        ${${platformName}_${lang}_MailingPreferenceTransaction}
    @{transactionstatusdetail}    Split String      ${transactionstatusdetail}        Policy no:
    ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
    @{transactionstatus}    Split String    ${transactionstatus}    Change mailing preference
    ${transactionstatus}    Get From List    ${transactionstatus}    1

    Log To Console    Transaction_Status=${transactionstatus}

    ${ChangeMailingPreference_Transaction_Detail}           Get From List    ${transactionstatusdetail}    1
    @{ChangeMailingPreference_Transaction_Detail}         Split String    ${ChangeMailingPreference_Transaction_Detail}       New mailing preference:
    ${VP_PolicyNumber}     Get From List    ${ChangeMailingPreference_Transaction_Detail}     0
    Log To Console    PolicyNUmber=${VP_PolicyNumber}

    ${ChangeMailingPreference_Transaction_Detail}           Get From List    ${ChangeMailingPreference_Transaction_Detail}         1
    @{ChangeMailingPreference_Transaction_Detail}         Split String    ${ChangeMailingPreference_Transaction_Detail}       Policy applied

    ${VP_Mailing_Preference}        Get From List    ${ChangeMailingPreference_Transaction_Detail}     0
    ${VP_Policy_Applied}            Get From List    ${ChangeMailingPreference_Transaction_Detail}     1
    Log To Console    New_Mailing_Address=${VP_Mailing_Preference}
    Log To Console    PolicyApplied=${VP_Policy_Applied}

    Set Calc VP With Source And Original Values    Transaction_Status    Completed    ${transactionstatus.strip()}    Static    Transaction Page    Completed    ${transactionstatus.strip()}
    Set Calc VP Actual Result With Original And Source    New_Mailing_Preference    ${VP_Mailing_Preference.strip()}    ${VP_Mailing_Preference}    Transaction Page
    Set Calc VP With Source And Original Values    Policy_NUmber    ${Policy_No}    ${VP_PolicyNumber}    TestData    Transaction Page    ${Policy_No}     ${VP_PolicyNumber}

Capture Transaction Details for Email Mailing Preference Android

     ${Android_EN_MailingPreferenceTransaction}          Set Variable      xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change mailing preference'])[1]

    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_MailingPreferenceTransaction}
    Click Element    ${${platformName}_${lang}_MailingPreferenceTransaction}

    ${transactionstatus}        Get Text            ${Android_EN_ChangeMailingPreferenceTransactionStatus}
    ${VP_Mailing_Preference}        Get Text        ${Android_EN_TransactionNewMailingPreference}
    ${VP_PolicyNumber}              Get Text            ${Android_EN_TransactionPolicyNumber}
    Set Calc VP With Source And Original Values    Transaction_Status    Completed    ${transactionstatus}    Static    Transaction Page    Completed    ${transactionstatus}
    Set Calc VP Actual Result With Original And Source    New_Mailing_Preference    ${VP_Mailing_Preference}    ${VP_Mailing_Preference}    Transaction Page
    Set Calc VP With Source And Original Values    Policy_NUmber    ${Policy_No}    ${VP_PolicyNumber}    TestData    Transaction Page    ${Policy_No}     ${VP_PolicyNumber}

