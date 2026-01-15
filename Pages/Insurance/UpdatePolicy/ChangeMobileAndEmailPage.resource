*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     String
Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/PersonalDetailsPageObject.resource
Resource    ../Common/AddOTP.resource
Library      .../../../../DBQuery/PersonalDetailsDB.py


*** Keywords ***
Mobile and Email Change
        IF   '${Agent_Verification}' == 'Yes'
              Agent Details Verification
              Set Global Variable    ${result}    Agent Email and Mobile Not Changed Successfully

        ELSE
            Wait Until Page Contains Element    ${${platformName}_${lang}_updateemailfield}    timeout=50s
            # Capture existing email and mobile details
            ${oldUsername}    Get Text    ${${platformName}_${lang}_updateemailfield}
            Set Global Variable    ${oldUsername}
            Sleep   2s
            Wait Until Element Is Visible    ${${platformName}_${lang}_CountryCode}    timeout=10s
            ${CCode}    Get Text    ${${platformName}_${lang}_CountryCode}
            ${CCode}    Replace String    ${CCode}    +    ${EMPTY}
            ${oldMobileNo}    Get Text    ${${platformName}_${lang}_updatemobilefield}
            ${Mob}    Set Variable    ${CCode}
            Set Global Variable    ${Mob}
            ${MobNo}    Set Variable    ${Mob}${oldMobileNo}
            Set Global Variable    ${MobNo}
            Take Screenshot    Update_Details
            IF    '${PersonalDetails_WhatChange}' == 'MobileNo'

                Mobile Change
                ${Static_Message}        Set Variable            FWD has successfully updated your mobile number as requested.
            ELSE
                Email Change
                ${Static_Message}        Set Variable            We are delighted to confirm that we have completed your Change of Email address request.
            END
#            Set Global Variable    ${Static_Message}

            Get Details from DB
            ${Previous_OTP}    Set Variable    ${OTPNumber}
            Set Global Variable    ${Previous_OTP}
            Wait Until Element Is Visible    ${${platformName}_${lang}_btnSave}    timeout=10s
            Click Element    ${${platformName}_${lang}_btnSave}
            Take Screenshot    Update_Details
            
            ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_OTP_email}
            IF    '${status}' == 'True'
                Insert OTP    ${Transaction_OTP_Source}    ${Transaction_OTP_Expiry_Flag}    ${Transaction_OTP_Resend_Flag}
            END
            #Check confirmation emaik
#            Get Email   ${oldUsername}      Old
#            Get Email   ${email}        New
            # New All Done Confirmation Page
            Run Keyword    Check Transaction Status
            Run Keyword    Handle Feedback
            Run Keyword    Capture Email and Mobile Details Transaction for ${platformName}    Pre
            Take Screenshot    Update_Details
            Set Global Variable    ${result}    Personal Details ${PersonalDetails_WhatChange} Changed Successfully
        END

Email Change
    ${email}    Convert To Lowercase    jane@mailsac
    ${email}    Strip String    ${email}
    Set Global Variable    ${email}
    Clear Text    ${${platformName}_${lang}_updateemailfield}

    # Check Error 'Email is a required field'
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_Error_Email_Required_Txt}
    IF    '${status}' == 'True'
        Take Screenshot    EmailRequired
        ${VP_Invalid_Email_Pass}    Get Text    ${${platformName}_${lang}_Error_Email_Required_Txt}
        Set Global Variable    ${errormsg}    ${VP_Invalid_Email_Pass}
        Set Calc VP With Source And Original Values
        ...    Email Required
        ...    Email is a required field
        ...    ${VP_Invalid_Email_Pass}
        ...    Static
        ...    OMNE_Application
        ...    Email is a required field
        ...    ${VP_Invalid_Email_Pass}
    END
    # Ckeck for the Invalid email id
    Input Text    ${${platformName}_${lang}_updateemailfield}    ${email.strip()}
    Close keyboard
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_Error_Must_Be_Valid_Email_Txt}
    ...    timeout=10s
    IF    '${status}' == 'True'
        ${VP_Inavalid_Email_Pass}    Get Text    ${${platformName}_${lang}_Error_Must_Be_Valid_Email_Txt}
        Set Global Variable    ${errormsg}    ${VP_Inavalid_Email_Pass}
        Set Calc VP With Source And Original Values
        ...    Invalid_Email_ID
        ...    Must be a valid email
        ...    ${VP_Inavalid_Email_Pass}
        ...    Static
        ...    OMNE_Application
        ...    Must be a valid email
        ...    ${VP_Inavalid_Email_Pass}
    END
     # Enter a Valid email id
    ${emailname}    FakerLibrary.first_name
    ${email}    Convert To Lowercase    ${emailname}@mailsac.com
    ${email}    Strip String    ${email}
    Set Global Variable    ${email}

    Clear Text    ${${platformName}_${lang}_updateemailfield}

    Input Text    ${${platformName}_${lang}_updateemailfield}    ${email.strip()}
    Close keyboard
    Set Calc VP Expected Result With Original And Source    NEW_Email_id    ${email}    ${email}    OmneApplication
    Set Calc VP Expected Result With Original And Source
    ...    NEW_Email_id_OWB
    ...    ${email}
    ...    ${email}
    ...    OmneApplication
    Set Calc VP Expected Result With Original And Source    MailID_DB    ${email}    ${email}    OmneApplication
    
Mobile Change
     ${email}      Set Variable          ${oldUsername}
     Set Global Variable    ${email}

    # Input invalid mobile number
    ${PersonalDetails_MobileNo}    Set Variable    56
    FOR    ${counter}    IN RANGE    1    6
        Log    ${counter}
        ${randomnum}    FakerLibrary.Building Number
        ${randomnum}    Get Substring    ${randomnum}    0    1
        ${PersonalDetails_MobileNo}    Set Variable    ${PersonalDetails_MobileNo}${randomnum}
    END
    Clear Text    ${${platformName}_${lang}_updatemobilefield}
    Input Text    ${${platformName}_${lang}_updatemobilefield}    ${PersonalDetails_MobileNo}
    Click Element    ${${platformName}_${lang}_updateemailfield}
    Close keyboard

    # Check Error 'Must be a valid mobile number'
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_Error_Must_Be_Mobile_No_Txt}
    ...    timeout=10s
    IF    '${status}' == 'True'
        ${VP_Invalid_MobileNo_Pass}    Get Text    ${${platformName}_${lang}_Error_Must_Be_Mobile_No_Txt}
        Take Screenshot    Invalid_Mobile_No_Page
        Set Calc VP With Source And Original Values
        ...    Mobile Required
        ...    Must be a valid mobile number
        ...    ${VP_Invalid_MobileNo_Pass}
        ...    Static
        ...    OMNE_Application
        ...    Must be a valid mobile number
        ...    ${VP_Invalid_MobileNo_Pass}
        Set Global Variable    ${errormsg}    ${VP_Invalid_MobileNo_Pass}
    END
    Clear Text    ${${platformName}_${lang}_updatemobilefield}
    #Fetch sample mobile number from Qrace config
    @{Sample_MobileNo}    Split String    ${samplemobileno}    ,
    ${mobilecount}    Get Length    ${Sample_MobileNo}
    FOR    ${counter}    IN RANGE    0    ${mobilecount}
        ${PersonalDetails_MobileNo}    Get From List    ${Sample_MobileNo}    ${counter}
        Clear Text    ${${platformName}_${lang}_updatemobilefield}
        IF    '${PersonalDetails_MobileNo}' != '${MobNo}'
            Log     ${MobNo}
            ${PersonalDetails_MobileNo}     Get Substring    ${PersonalDetails_MobileNo}    3
            Input Text    ${${platformName}_${lang}_updatemobilefield}    ${PersonalDetails_MobileNo}
            Click Element    ${${platformName}_${lang}_updateemailfield}
            Close keyboard
            Exit For Loop
        ELSE
            ${counter}      Evaluate    ${counter} + 1
        END
    END
    ${NewMob}    Set Variable    ${Mob}${PersonalDetails_MobileNo}
    Set Global Variable    ${NewMob}
    Set Calc VP Expected Result With Original And Source
    ...    NEW_MobileNo
    ...    ${NewMob}
    ...    ${NewMob}
    ...    OmneApplication
    Set Calc VP Expected Result With Original And Source
    ...    NEW_MobileNo_OWB
    ...    ${NewMob}
    ...    ${NewMob}
    ...    OmneApplication
    Set Calc VP Expected Result With Original And Source
    ...    MobileNo_DB
    ...    ${NewMob}
    ...    ${NewMob}
    ...    OmneApplication

Agent Details Verification
    Get Agent Details
    Wait Until Element Is Visible       ${${platformName}_${lang}_CountryCode}           timeout=20s
    Click Element    ${${platformName}_${lang}_CountryCode}
    Wait Until Element Is Visible    ${${platformName}_${lang}_CountryCodeTH}    timeout=10s
    Sleep    1s
    Click Element    ${${platformName}_${lang}_CountryCodeTH}
    IF    '${platformName}' == 'Android'
        Clear Text    ${${platformName}_${lang}_updatemobilefield}
        Input Text    ${${platformName}_${lang}_updatemobilefield}    ${AgentMobileNumber}
        Close keyboard
    ELSE
        Clear Text    ${${platformName}_${lang}_updatemobilefield}
        Input Text    ${${platformName}_${lang}_updatemobilefield}    ${AgentMobileNumber}\n
    END
    Click Element    ${${platformName}_${lang}_btnSave}
    # Capture Servicing Agent Error
    Wait Until Element Is Visible    ${${platformName}_${lang}_EmailerrorMessage}
    ${vp_errormsg}    Get Text    ${${platformName}_${lang}_EmailerrorMessage}
    Take Screenshot    Servicing_Agent_Error
    Set Calc VP With Source And Original Values
    ...    MobileNumber_Validation_ErrorMsg
    ...    ${vp_errormsg}
    ...    ${vp_errormsg}
    ...    static
    ...    Omne Application
    ...    ${vp_errormsg}
    ...    ${vp_errormsg}
    # Check Servicing Agent Error
    Clear Text    ${${platformName}_${lang}_updateemailfield}
    Input Text    ${${platformName}_${lang}_updateemailfield}    ${AgentEmailAddress}
    Close keyboard
    Take Screenshot    Servicing_Agent_Email_ID
    Click Element    ${${platformName}_${lang}_btnSave}

    Wait Until Element Is Visible    ${${platformName}_${lang}_EmailerrorMessage}
    ${vp_errormsg}    Get Text    ${${platformName}_${lang}_EmailerrorMessage}
    Take Screenshot    Servicing_Agent_Error
    Set Calc VP With Source And Original Values    Email_Validation_ErrorMsg    ${vp_errormsg}    ${vp_errormsg}    static    Omne Application    ${vp_errormsg}    ${vp_errormsg}

Get Agent Details
    ${AgentDetaillistdf}    Run Keyword
        ...    Get Servicing Agent Details
        ...    ${dbhostname}
        ...    ${dbusername}
        ...    ${dbpassword}
        ...    ${dbport}
        ...    ${dbinstance}
        ...    ${Policy_No}
        ...    ${screenshotPath}
        Log    ${AgentDetaillistdf}
        ${leng}    Get Length    ${AgentDetaillistdf}
        Log    ${leng}
        ${list0}    Get From List    ${AgentDetaillistdf}    0
        Log    ${list0}
        ${index1}    Get Index From List    ${list0}    EmailAddress
        Log    ${index1}
        ${index2}    Get Index From List    ${list0}    MobileNumber
        Log    ${index2}
        ${list}    Get From List    ${AgentDetaillistdf}    1
        # agentemailaddress
        ${AgentEmailAddress}    Set Variable    ${list}[${index1}]
        IF    '${AgentEmailAddress}' != ''
            ${AgentEmailAddress}    Strip String    ${AgentEmailAddress}
            ${AgentEmailAddress}    AES Decrypt    ${key}    ${AgentEmailAddress}
            Set Global Variable    ${AgentEmailAddress}
        END
        # agent mobileno
        ${AgentMobileNumber}    Set Variable    ${list}[${index2}]
        IF    '${AgentMobileNumber}' != ''
            ${AgentMobileNumber}    Strip String    ${AgentMobileNumber}
            ${AgentMobileNumber}    AES Decrypt    ${key}    ${AgentMobileNumber}
            Set Global Variable    ${AgentMobileNumber}
        END



Capture Email and Mobile Details Transaction for iOS
    [Arguments]    ${Transaction_Info}

    Take Screenshot    Transaction Page
    Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=50s
    Click Element    ${${platformName}_${lang}_SeeAll}
    Take Screenshot    Transaction_Page
    Wait Until Page Contains Element    ${${platformName}_${lang}_ServiceReuest}    timeout=50s
    Click Element    ${${platformName}_${lang}_ServiceReuest}
    Take Screenshot    Transaction Page
    IF    '${Transaction_Info}'== 'Pre'
        RefreshPage
        ${iOS_selectCurrentTransaction1}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of personal details' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    END
    Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction1}    timeout=300s
    Take Screenshot    Transaction Page

    ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction1}
    @{transactionstatusdetail}    Split String    ${transactionstatus}    Policy no
    ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
    @{transactionstatusdetail}    Split String    ${transactionstatus}    Change of personal details
    ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
    ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
    ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
    IF    '${mTransactionstatus}' == 'Completed'
        ${mTransactionstatus}    Set Variable    Approve
    END
    Take Screenshot    Transaction Page
    Click Element    ${${platformName}_selectCurrentTransaction1}
    Take Screenshot    Transaction Page
    Wait Until Page Contains Element    chain=**/XCUIElementTypeOther[`label CONTAINS "Email"`]    timeout=60s
    IF    '${PersonalDetails_WhatChange}' == 'Email'
        ${emailDetails}    Get Element Attribute
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS "Email"`]
        ...    attribute=label
        ${email_pattern}    Set Variable    \\S+@\\S+
        ${VP_Transaction_email}    Get Regexp Matches    ${emailDetails}    ${email_pattern}
        ${VP_Transaction_email}    Get From List    ${VP_Transaction_email}    0
    ELSE
        ${mobileDetails}    Get Element Attribute
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS "Email"`]
        ...    attribute=label
        @{mobileDetails1}    Split String    ${mobileDetails}    number
        ${mobileDetails11}    Get From List    ${mobileDetails1}    1
        @{mobileDetails2}    Split String    ${mobileDetails11}    New
        ${mobileDetails21}    Get From List    ${mobileDetails2}    0
        ${VP_Transaction_Mobile}    Strip String    ${mobileDetails21}
    END
    IF    '${PersonalDetails_WhatChange}' == 'MobileNo'
        Set Calc VP With Source And Original Values
        ...    NEW_MobileNo
        ...    ${NewMob}
        ...    ${VP_Transaction_Mobile}
        ...    PersonalDetail_Page
        ...    Transaction_Page
        ...    ${NewMob}
        ...    ${VP_Transaction_Mobile}
        IF    '${Core_System}' != ''
            ${mVP_Transaction_Mobile}    Get Substring    ${VP_Transaction_Mobile}    -8
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_Mobile
            ...    ${mVP_Transaction_Mobile.strip()}
            ...    ${VP_Transaction_Mobile}
            ...    OMNE_Transaction_Page
        END
    ELSE
        Set Calc VP With Source And Original Values
        ...    NEW_Email_id
        ...    ${email}
        ...    ${VP_Transaction_email}
        ...    PersonalDetail_Page
        ...    Transaction_Page
        ...    ${email}
        ...    ${VP_Transaction_email}
        IF    '${Core_System}' != ''
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_Email_ID
            ...    ${VP_Transaction_email}
            ...    ${VP_Transaction_email}
            ...    OMNE_Transaction_Page
        END
    END
    Set Calc VP Expected Result With Original And Source
    ...    Transaction_Status
    ...    ${mTransactionstatus.strip()}
    ...    ${mTransactionstatus.strip()}
    ...    OMNE_Application
    ${OPUSTransactionstatus}    Set Variable    Completed
    Set Global Variable    ${OPUSTransactionstatus}

Capture Email and Mobile Details Transaction for Android
    [Arguments]    ${Transaction_Info}

    Take Screenshot    Transaction Page
    Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=50s
    Click Element    ${${platformName}_${lang}_SeeAll}
    Take Screenshot    Transaction_Page
    Wait Until Page Contains Element    ${${platformName}_${lang}_ServiceReuest}    timeout=50s
    Click Element    ${${platformName}_${lang}_ServiceReuest}
#    Wait Until Element Is Visible    ${${platformName}_${lang}_ViewTransaction}    timeout=20s
#    Click Element    ${${platformName}_${lang}_ViewTransaction}
    Take Screenshot    Transaction Page
    IF    '${Transaction_Info}'== 'Pre'

        RefreshPage
        ${Android_selectCurrentTransaction}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of personal details'])[1]
    END
    Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction}    timeout=300s
    Take Screenshot    Transaction Page
    ${transactionstatus}    Get Text
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of personal details']/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]
    ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
    ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
    IF    '${mTransactionstatus}' == 'Completed'
        ${mTransactionstatus}    Set Variable    Approve
    END

    # capture transaction detail
    Click Element    ${${platformName}_selectCurrentTransaction}
    Take Screenshot    Address Change Transaction Details
    ${VP_Transaction_email}    Get Text    ${${platformName}_${lang}_TransactionEmail}
    ${VP_Transaction_Mobile}    Get Text    ${${platformName}_${lang}_TransactionMobile}
    ${VP_Completion_Date}    Get Text    ${${platformName}_${lang}_TransCompletion_Date}
    IF    '${PersonalDetails_WhatChange}' == 'MobileNo'
     Set Calc VP With Source And Original Values    OLD_MobileNo    ${MobNo}    ${VP_Transaction_Mobile}    PersonalDetail_Page    Transaction_Page    ${MobNo}    ${VP_Transaction_Mobile}
        Set Calc VP With Source And Original Values
        ...    NEW_MobileNo
        ...    ${NewMob}
        ...    ${VP_Transaction_Mobile}
        ...    PersonalDetail_Page
        ...    Transaction_Page
        ...    ${NewMob}
        ...    ${VP_Transaction_Mobile}
        IF    '${Core_System}' != ''
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_Mobile
            ...    ${VP_Transaction_Mobile}
            ...    ${VP_Transaction_Mobile}
            ...    OMNE_Transaction_Page
        END
    ELSE
        Set Calc VP With Source And Original Values
        ...    NEW_Email_id
        ...    ${email}
        ...    ${VP_Transaction_email}
        ...    PersonalDetail_Page
        ...    Transaction_Page
        ...    ${email}
        ...    ${VP_Transaction_email}
        IF    '${Core_System}' != ''
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_Email_ID
            ...    ${VP_Transaction_email}
            ...    ${VP_Transaction_email}
            ...    OMNE_Transaction_Page
        END
    END
    Set Calc VP Expected Result With Original And Source
    ...    Transaction_Status
    ...    ${mTransactionstatus.strip()}
    ...    ${mTransactionstatus.strip()}
    ...    OMNE_Application
    ${OPUSTransactionstatus}    Set Variable    Completed
    Set Global Variable    ${OPUSTransactionstatus}
