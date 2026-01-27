*** Settings ***
Library     AppiumLibrary
Library     Dialogs
Library     ../../DBQuery/DBQuerySelect.py
Library     ../../DBQuery/ChangeBeneficiaryDB.py
Resource    ../../../CustomLibraries/common.robot
Resource    ../../../PageObjects/Insurance/Common/LoginPageObjects.resource
Resource    ../../../CustomLibraries/MailSac/mailsacAPIExecutor.robot
Resource    ../../../PageObjects/Insurance/Common/AddOTPObjects.resource
Resource    ../../DBQueryInvoke/DBQueriesInvoke.robot
Resource    ../../../PageObjects/Insurance/Common/CommonObjects.resource


*** Variables ***
${LoginPrevious_OTP}    ${EMPTY}


*** Keywords ***
Insert OTP
    [Arguments]     ${OTP_Source}    ${Expiry_Flag}     ${Resend_Flag}
        ${Previous_OTP}     Set Variable       567892
        #     Check for OTP expired scenario
        IF      '${Expiry_Flag}' != ''
            ${Expiry_Flag}      Convert To Number    ${Expiry_Flag}
            ${Expiry_Flag}=      Evaluate    ${Expiry_Flag}-20
            Sleep    ${Expiry_Flag}
            #        Get OTP Expired text
            ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Code_Expired}    timeout=30s
            Take Screenshot    Code_Expired
            IF    '${status}' == 'True'
                ${VP_OTP_Expired}    Get Text    ${${platformName}_${lang}_Code_Expired}
                Set Calc VP With Source And Original Values    Code Expiry Message    Code expired    ${VP_OTP_Expired}    Static    OMNE_OTPPage    Code expired    ${VP_OTP_Expired}
            END
        END
        #     Check for scenario where OTP is to be resend
        IF      '${Resend_Flag}' != ''
            ${VP_RequestForNewCode}    Get Text    ${${platformName}_${lang}_RequestForNewCode_txt}
            Set Calc VP With Source And Original Values    Request For New Code In    ${VP_RequestForNewCode}    ${VP_RequestForNewCode}    Static    OMNE_Login_OTP_Page    ${VP_RequestForNewCode}    ${VP_RequestForNewCode}
            Click Element    ${${platformName}_${lang}_OTP_TapResend}
            Take Screenshot    Tap to resend
            Sleep    10s
        END
        ${OTP_Source}     Convert To Lower Case    ${OTP_Source}
        IF      '${OTP_Source}' == 'mail'
            Sleep    10s

            Wait Until Page Contains Element        ${${platformName}_${lang}_OTP_email}        timeout=10s
            ${VP_OTP_Page_EmailID}    Get Text    ${${platformName}_${lang}_OTP_email}
            @{VP_OTP_Page_EmailID}    Split String    ${VP_OTP_Page_EmailID}

            ${emailstatus}   Run Keyword And Return Status    Should Contain    ${VP_OTP_Page_EmailID}    ${Email}
            IF  '${LoginMethod}' != 'SignUp' and '${emailstatus}' != 'True'
                ${m_Email}    Convert To Lower Case    ${insurance_mobilenumber}@mailsac.com
                Set Global Variable   ${m_Email}
            ELSE
                ${m_Email}    Convert To Lower Case    ${Email}
                Set Global Variable   ${m_Email}
            END
            Set Global Variable    ${m_Email}
            Get OTP     ${m_Email}
             ${LoginCurrent_OTP}      Set Variable    ${OTPNumber}
             ${LoginPrevious_OTP}      Set Variable          567653
            IF    '${LoginPrevious_OTP}' != '${LoginCurrent_OTP}'
                ${Current_OTP}     Set Variable        ${LoginCurrent_OTP}
            ELSE
                ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_OTP_Expire}    timeout=5s
                 WHILE    '${LoginPrevious_OTP}' == '${LoginCurrent_OTP}' and '${status}' != 'True'
                       Get OTP     ${m_Email}
#                      ${Current_OTP}      Set Variable    ${OTPNumber}
#                      ${LoginCurrent_OTP}      Set Variable    123456
                      ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_OTP_Expire}    timeout=5s
                 END
                 IF    '${status}' == 'True'
                     Fail     latest OTP not found for login from mailsac
                 END
            END
        ELSE IF      '${OTP_Source}' == 'db'
            Get Details from DB
            ${Current_OTP}      Set Variable    ${OTPNumber}
            IF    '${Previous_OTP}' != '${Current_OTP}'
                ${Current_OTP}     Set Variable        ${Current_OTP}
            ELSE
                ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Code_Expired}    timeout=5s
                 WHILE    '${Previous_OTP}' == '${Current_OTP}' and '${status}' != 'True'
                      Get Details from DB
                      ${Current_OTP}      Set Variable    ${OTPNumber}
                      ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Code_Expired}    timeout=5s
                 END
                 IF    '${status}' == 'True'
                     Fail     latest OTP not found in DB
                 END
            END

            ${Current_OTP}      Convert To String    ${Current_OTP}
            Set Global Variable    ${Current_OTP}
        ELSE
                   ${Current_OTP}      Set Variable    ${OTP_Source}
        END
        ${OTP1}     Get Substring    ${Current_OTP}    0    1
        ${OTP2}     Get Substring    ${Current_OTP}    1    2
        ${OTP3}     Get Substring    ${Current_OTP}    2    3
        ${OTP4}     Get Substring    ${Current_OTP}    3    4
        ${OTP5}     Get Substring    ${Current_OTP}    4    5
        ${OTP6}     Get Substring    ${Current_OTP}    5    6
        IF    '${OTP_Source.lower()}' == 'db' and '${platformName}' == 'iOS'
            Wait Until Element Is Visible    ${${platformName}_${lang}_InputOTPField}   timeout=3s
            Input Text    ${${platformName}_${lang}_InputOTPField}    ${Current_OTP}\n
        ELSE
             Wait Until Element Is Visible    ${${platformName}_${lang}_InputOTPField}      timeout=5s
             IF    '${platformName}' == 'iOS'
                 Input Password    ${${platformName}_${lang}_InputOTPField}    ${Current_OTP}\n
             ELSE
                 Input Password    ${${platformName}_${lang}_InputOTPField}    ${Current_OTP}
                 Hide Keyboard
             END
        END
        Take Screenshot    OTP Entry
#        Pause Execution
        Wait Until Element Is Visible    ${${platformName}_${lang}_Verify}
        Click Element    ${${platformName}_${lang}_Verify}
        Take Screenshot    OTP Submit
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Eror_Msg_Wrong_Otp}    timeout=1s
        IF    '${status}' == 'True'
            Take Screenshot    Invalid_OTP
            ${VP_Inavalid_OTP}    Get Text    ${${platformName}_${lang}_Eror_Msg_Wrong_Otp}
            Set Global Variable    ${errormsg}    ${VP_Inavalid_OTP}
            Set Calc VP With Source And Original Values    OTP Invalid Message    ${ValidationErrorMsg}    ${VP_Inavalid_OTP}    Static    OMNE_OTPPage    ${ValidationErrorMsg}    ${VP_Inavalid_OTP}
            Fail    ${errormsg}
        END
        Sleep    2s
        Take Screenshot    OTP Submit


Get Details from DB
    TRY
        IF    '${Update_Policy_Module}' == 'Policy(s)'
                ${Update_Policy_Module}    Set Variable    Personal details
        END
        IF    '${Policy_No}' != '${EMPTY}'
            ${OwnerUserId}    Run Keyword
            ...    Get Owner User ID from DB
            ...    ${dbhostname}
            ...    ${dbusername}
            ...    ${dbpassword}
            ...    ${dbport}
            ...    ${dbinstanceAddon}
            ...    ${Policy_No}
            ...    ${dbinstance}
            Log    ${OwnerUserId}
            Set Global Variable    ${OwnerUserId}
        END
        IF    '${LoginMethod}' != 'SignIn'
            Get SignUp OTP
        ELSE IF    '${Update_Policy_Module}' == 'Personal details' or '${Update_Policy_Module}' == 'My policy(s)'
            IF    '${PersonalDetails_WhatChange}' == 'Email'
                ${DBValue}    Get Email or Mobile Details    EmailAddress
                @{DBValueArr}    Split String    ${DBValue}    ~
                ${OTPNumber}    Get From List    ${DBValueArr}    0
                ${DBMailId}    Get From List    ${DBValueArr}    1
                Set Calc VP Actual Result With Original And Source
                ...    MailID_DB
                ...    ${DBMailId}
                ...    ${DBMailId}
                ...    Personal Details DB
                Set Global Variable    ${OTPNumber}
            ELSE IF    '${PersonalDetails_WhatChange}' == 'mobile number'
                ${DBValue}    Get Email or Mobile Details    MobileNumber
                @{DBValueArr}    Split String    ${DBValue}    ~
                ${OTPNumber}    Get From List    ${DBValueArr}    0
                ${DBMobileNo}    Get From List    ${DBValueArr}    1
                Set Calc VP Actual Result With Original And Source
                ...    MobileNo_DB
                ...    ${DBMobileNo}
                ...    ${DBMobileNo}
                ...    Personal Details DB
                Set Global Variable    ${OTPNumber}
            ELSE IF    '${PersonalDetails_WhatChange}' == 'Mailing address'
                Get Address Details from DB
            ELSE IF    '${PersonalDetails_WhatChange}' == 'Name'
                Get Name Marital Status Details
            END
        ELSE IF    '${Update_Policy_Module}' == 'Delete rider(s)'
            Get OTP from Cancellation Table
        ELSE IF    '${Update_Policy_Module}' == 'Cancel or surrender policy'
            Get OTP from Cancellation Table
        ELSE IF    '${Update_Policy_Module}' == 'Beneficiary(s) details'
            Get OTP from Beneficiary Table
        ELSE
            Get OTP from CustID    ${User_Id_Column_Name}    ${tablename}    ${orderby}    ${OTP_Column_Name}
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Get Details from DB
    END


Get OTP from Beneficiary Table
    TRY
        ${PDdf}    Get Change Beneficiary with OTP
        ...    ${dbhostname}
        ...    ${dbusername}
        ...    ${dbpassword}
        ...    ${dbport}
        ...    ${dbinstanceAddon}
        ...    ${OwnerUserId}
        ...    ${screenshotPath}
        Log    ${PDdf}
        ${leng}    Get Length    ${PDdf}
        Log    ${leng}
        ${list0}    Get From List    ${PDdf}    0
        Log    ${list0}
        ${index1}    Get Index From List    ${list0}    OTP
        Log    ${index1}
        ${counter}    Set Variable    1

        ${list}    Get From List    ${PDdf}    ${counter}

        ${OTPNumber}    Set Variable    ${list}[${index1}]
        Log    ${OTPNumber}
        Set Global Variable    ${OTPNumber}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Get OTP from Beneficiary Table
    END
