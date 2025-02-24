*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     String
Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/PersonalDetailsPageObject.resource
Resource    ../Common/AddOTP.resource


*** Keywords ***
Personal details
    TRY
        ${Android_PersonalDetail_WhatChange}    Set Variable        xpath=//android.widget.TextView[contains(@text,'${PersonalDetails_WhatChange}')]
        ${iOS_PersonalDetail_WhatChange}    Set Variable            chain=**/XCUIElementTypeOther[`label CONTAINS '${PersonalDetails_WhatChange}'`][-1]
        ${Android_PolicyName}    Set Variable    xpath=//android.widget.TextView[@text='${Policy_Name}']
        ${iOS_PolicyName}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Policy_Name}'`][-1]
        ${Android_PolicyNo}    Set Variable    xpath=//android.widget.TextView[@text='${Policy_No}']
        ${iOS_PolicyNo}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Policy_No}'`][-1]
        ${iOS_CountryCode}    Set Variable    chain=**/XCUIElementTypeOther[`label == "${CountryCode}"`][3]
        IF    '${Transaction_Page_GUI}' == 'Yes'
            ${status}    Run Keyword And Return Status   Element Should Be Visible      ${${platformName}_${lang}_What_Change_Txt}
            IF    '${status}' == 'True'
                Set Calc VP With Source And Original Values     What_would_like_to_change_Options_Present   true    ${status}      Static  OMNE_Applicatio True   ${status}
            END
            ${status}    Run Keyword And Return Status      Element Should Be Visible   ${${platformName}_${lang}_Address_Txt}
            IF    '${status}' == 'True'
                Set Calc VP With Source And Original Values     Address_Options_Present    true    ${status}   Status   OMNE_Applicatio   True   ${status}
            END
            ${status}    Run Keyword And Return Status      Element Should Be Visible     ${${platformName}_${lang}_Email_Mobile_Txt}
            IF    '${status}' == 'True'
                Set Calc VP With Source And Original Value      Email_Mobile_Options_Presen  true   ${status}   Static  OMNE_Application    True    ${status}
            END
            ${status}    Run Keyword And Return Status      Element Should Be Visible   ${${platformName}_${lang}_Name_Martial_Status_Txt}
            IF    '${status}' == 'True'
                Set Calc VP With Source And Original Values     Name_Martial_Status_Options_Present     true   ${status}   Static  OMNE_Application    True    ${status}
            END
        END
        Take Screenshot    Personal_Details_Page
        IF    '${PersonalDetails_WhatChange}' == 'MobileNo' and '${platformName}' == 'iOS'
            Click Element    chain=**/XCUIElementTypeOther[`label CONTAINS 'mobile'`][-1]
        ELSE
            Click Element    ${${platformName}_PersonalDetail_WhatChange}
        END
        IF    '${PersonalDetails_WhatChange}' == 'Mailing address'    Address Change
        IF    '${PersonalDetails_WhatChange}' == 'Name'    Name Change
        IF    '${PersonalDetails_WhatChange}' == 'Email'    Email And Mobile Change
        IF    '${PersonalDetails_WhatChange}' == 'MobileNo'
            Email And Mobile Change
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END
Email And Mobile Change
    # Capture Servicing Agent details from db
    TRY
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
    #    ${AgentMobileNumber}    Strip String    ${AgentMobileNumber}
    #    ${AgentMobileNumber}    AES Decrypt    ${key}    ${AgentMobileNumber}
    #    Set Global Variable    ${AgentMobileNumber}

        ${status}    Run Keyword And Return Status
        ...    Element Should Be Visible
        ...    ${${platformName}_${lang}_Email_Mobile_Txt}
        IF    '${status}' == 'True'
            Set Calc VP With Source And Original Values
            ...    Email_Mobile_Options_Present
            ...    true
            ...    ${status}
            ...    Static
            ...    OMNE_Application
            ...    True
            ...    ${status}
        END
        IF    '${Transaction_Page_GUI}' == 'Yes'
            ${status}    Run Keyword And Return Status
            ...    Element Should Be Visible
            ...    ${${platformName}_${lang}_Update_personal_details_Txt}
            IF    '${status}' == 'True'
                Set Calc VP With Source And Original Values
                ...    Update_Personal_Details_Present
                ...    true
                ...    ${status}
                ...    Static
                ...    OMNE_Application
                ...    True
                ...    ${status}
            END
            ${status}    Run Keyword And Return Status
            ...    Element Should Be Visible
            ...    ${${platformName}_${lang}_updatemobilefield}
            IF    '${status}' == 'True'
                Set Calc VP With Source And Original Values
                ...    Enter_Mobile_Details_Present
                ...    true
                ...    ${status}
                ...    Static
                ...    OMNE_Application
                ...    True
                ...    ${status}
            END
            ${status}    Run Keyword And Return Status
            ...    Element Should Be Visible
            ...    ${${platformName}_${lang}_updateemailfield}
            IF    '${status}' == 'True'
                Set Calc VP With Source And Original Values
                ...    Enter_Email_Details_Present
                ...    true
                ...    ${status}
                ...    Static
                ...    OMNE_Application
                ...    True
                ...    ${status}
            END
        END
        Wait Until Page Contains Element    ${${platformName}_${lang}_updateemailfield}    timeout=50s
        # Capture existing email and mobile details
        ${oldUsername}    Get Text    ${${platformName}_${lang}_updateemailfield}
        Set Global Variable    ${oldUsername}
        Wait Until Element Is Visible    ${${platformName}_${lang}_CountryCode}    timeout=10s
        ${CCode}    Get Text    ${${platformName}_${lang}_CountryCode}
        ${CCode}    Replace String    ${CCode}    +    ${EMPTY}
        ${oldMobileNo}    Get Text    ${${platformName}_${lang}_updatemobilefield}
        ${Mob}    Set Variable    ${CCode}
        ${MobNo}    Set Variable    ${Mob}${oldMobileNo}
        Set Global Variable    ${MobNo}
        Take Screenshot    Update_Details
        # ----------------------------- Change Email ----------------------------------------------
        IF    '${PersonalDetails_WhatChange}' == 'Email'
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
            # Check Servicing Agent Error
    #    Clear Text    ${${platformName}_${lang}_updateemailfield}
    #    Input Text    ${${platformName}_${lang}_updateemailfield}    ${AgentEmailAddress}
    #    Close keyboard
    #    Take Screenshot    Servicing_Agent_Email_ID
    #    Click Element    ${${platformName}_${lang}_btnSave}
    #
    #    Wait Until Element Is Visible    ${${platformName}_${lang}_EmailerrorMessage}
    #    ${vp_errormsg}    Get Text    ${${platformName}_${lang}_EmailerrorMessage}
    #    Take Screenshot    Servicing_Agent_Error
    #    Set Calc VP With Source And Original Values    Email_Validation_ErrorMsg    ${vp_errormsg}    ${vp_errormsg}    static    Omne Application    ${vp_errormsg}    ${vp_errormsg}

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

    # ---------------------------- Change MobileNo ---------------------------------------
        ELSE IF    '${PersonalDetails_WhatChange}' == 'MobileNo'
            # Select Country Code (852)
            IF    '${CCode}' != '852'
                Click Element    ${${platformName}_${lang}_CountryCode}
                Wait Until Element Is Visible    ${${platformName}_${lang}_CountryCodeHK}    timeout=10s
                Click Element    ${${platformName}_${lang}_CountryCodeHK}
            END

            Clear Text    ${${platformName}_${lang}_updatemobilefield}
        # Enter the Servicing Agent Details
    #    IF   '${AgentMobileNumber}' != 'N/A'
    #        IF    '${platformName}' == 'Android'
    #            Input Text    ${${platformName}_${lang}_updatemobilefield}    ${AgentMobileNumber}
    #            Close keyboard
    #        ELSE
    #            Input Text    ${${platformName}_${lang}_updatemobilefield}    ${AgentMobileNumber}\n
    #        END
    #        Click Element    ${${platformName}_${lang}_btnSave}
    #    # Capture Servicing Agent Error
    #        Wait Until Element Is Visible    ${${platformName}_${lang}_EmailerrorMessage}
    #        ${vp_errormsg}    Get Text    ${${platformName}_${lang}_EmailerrorMessage}
    #        Take Screenshot    Servicing_Agent_Error
    #        Set Calc VP With Source And Original Values
    #        ...    MobileNumber_Validation_ErrorMsg
    #        ...    ${vp_errormsg}
    #        ...    ${vp_errormsg}
    #        ...    static
    #        ...    Omne Application
    #        ...    ${vp_errormsg}
    #        ...    ${vp_errormsg}
    #    END
        # Input invalid mobile number
            ${PersonalDetails_MobileNo}    Set Variable    56
            FOR    ${counter}    IN RANGE    1    6
                Log    ${counter}
                ${randomnum}    FakerLibrary.Building Number
                ${randomnum}    Get Substring    ${randomnum}    0    1
                ${PersonalDetails_MobileNo}    Set Variable    ${PersonalDetails_MobileNo}${randomnum}
            END
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

    #    IF    '${errormsg}' == ''
            Set Calc VP Expected Result With Original And Source
            ...    NEW_MobileNo
            ...    ${NewMob}
            ...    ${NewMob}
            ...    OmneApplication
    #        Set Calc VP Expected Result With Original And Source
    #        ...    OLD_MobileNo_OWB
    #        ...    ${MobNo}
    #        ...    ${MobNo}
    #        ...    OmneApplication
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
    #    END
        END

        # Previous OTP Number
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
        # New All Done Confirmation Page
        Run Keyword    Check Transaction Status
        Run Keyword    Handle Feedback
        Run Keyword    Capture Personal Details Transaction for ${platformName}    Pre
        Take Screenshot    Update_Details
        Set Global Variable    ${result}    Personal Details ${PersonalDetails_WhatChange} Changed Successfully
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Email And Mobile Change
    END
Capture Personal Details Transaction for iOS
    [Arguments]    ${Transaction_Info}
    TRY
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
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Personal Details Transaction for
    END
Capture Personal Details Transaction for Android
    [Arguments]    ${Transaction_Info}
    TRY
        Wait Until Element Is Visible    ${${platformName}_${lang}_ViewTransaction}    timeout=20s
        Click Element    ${${platformName}_${lang}_ViewTransaction}
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
    #    Set Calc VP With Source And Original Values    OLD_MobileNo    ${MobNo}    ${VP_Transaction_Mobile}    PersonalDetail_Page    Transaction_Page    ${MobNo}    ${VP_Transaction_Mobile}
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
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Personal Details Transaction for Android
    END
Address Change
    TRY
        ${Android_SelectPolicyNo}    Set Variable
        ...    xpath=//android.view.ViewGroup[contains(@content-desc,"${Policy_No}")]/android.widget.TextView[4]
        ${iOS_SelectPolicyNo}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Policy_No}'`][-1]
        Wait Until Page Contains Element    ${${platformName}_SelectPolicyNo}           timeout=3s
        Take Screenshot    Update Details
        Click Element    ${${platformName}_SelectPolicyNo}

        ${VP_CurrentAddress}    Get Text    ${${platformName}_SelectPolicyNo}
        IF    '${platformName}' == 'Android'
            ${currAddressSplit}    Set Variable    ${VP_CurrentAddress}
        ELSE
            @{currAddressSplit}    Split String    ${VP_CurrentAddress}    Address:
            ${currAddressSplit}    Get From List    ${currAddressSplit}    1
        END
        @{Current_Add}    Split String    ${currAddressSplit}    ,
        ${Length}       Get Length    ${Current_Add}
        IF    '${Length}' != '6'
            ${Current_Address_Line1}    Get From List    ${Current_Add}    0
            ${Current_Address_Line2}    Get From List    ${Current_Add}    1
            ${Current_Address_District}    Get From List    ${Current_Add}    3
            ${Current_Address_City}    Get From List    ${Current_Add}    2
            ${Current_Address_State}    Get From List    ${Current_Add}    4
            ${Current_Address_ZipCode}    Get From List    ${Current_Add}    5
            ${Current_Address_Country}    Get From List    ${Current_Add}    6
        ELSE
            ${Current_Address_Line2}    Get From List    ${Current_Add}    0
            ${Current_Address_District}    Get From List    ${Current_Add}    1
            ${Current_Address_City}    Get From List    ${Current_Add}    2
            ${Current_Address_State}    Get From List    ${Current_Add}    3
            ${Current_Address_ZipCode}    Get From List    ${Current_Add}    4
            ${Current_Address_Country}    Get From List    ${Current_Add}    5
        END
        ${iOS_EN_CountryNameObj}    Set Variable    chain=**/XCUIElementTypeButton[`label == "${Country}"`]
        ${Android_EN_CountryNameObj}    Set Variable    android=new UiSelector().textContains("${Country}")

        Click Element    ${${platformName}_${lang}_NextButton}
        Take Screenshot    Update Details


    #    Wait Until Page Contains Element    ${${platformName}_PolicyNo}
    #    Click Element    ${${platformName}_PolicyNo}
    #    Click Element    ${${platformName}_${lang}_btnNext}
    #    Take Screenshot    Update_Address
    #    Sleep    3s
    #    Wait Until Element Is Visible    ${${platformName}_${lang}_Update_Address_Txt}    timeout=10s
    #    ${Current_Add}    Get Text    ${${platformName}_${lang}_Current_Address}
    #    ${Current_Add}    Replace String    ${Current_Add}    \n    ${SPACE}
    #    ${Current_Add}    Replace String    ${Current_Add}    ,    ${EMPTY}
    #    ${Current_Add}    Replace String    ${Current_Add}    ${SPACE}    ,${SPACE}
    #    ${Current_Add}    Split String    ${Current_Add}    ,
    #    Set Global Variable    ${Current_Add}
    #    ${Current_Address_Line1}    Get From List    ${Current_Add}    0
    #    ${Current_Address_Line2}    Get From List    ${Current_Add}    1
    #    ${Current_Address_District}    Get From List    ${Current_Add}    3
    #    ${Current_Address_City}    Get From List    ${Current_Add}    2
    #    ${Current_Address_State}    Get From List    ${Current_Add}    4
    #    ${Current_Address_ZipCode}    Get From List    ${Current_Add}    5
    #    ${Current_Address_Country}    Get From List    ${Current_Add}    6
    #
        ${Current_Address_Line1}    Strip String    ${Current_Address_Line1}
        ${Current_Address_Line2}    Strip String    ${Current_Address_Line2}
        ${Current_Address_District}    Strip String    ${Current_Address_District}
        ${Current_Address_City}    Strip String    ${Current_Address_City}
        ${Current_Address_State}    Strip String    ${Current_Address_State}
        ${Current_Address_ZipCode}    Strip String    ${Current_Address_ZipCode}
        ${Current_Address_Country}    Strip String    ${Current_Address_Country}

        # Capture Servicing Agent Details
        ${AgentDetaillistdf}    Run Keyword
        ...    Get Servicing Agent Address Details
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
        ${index1}    Get Index From List    ${list0}    AddressLine1
        Log    ${index1}
        ${index2}    Get Index From List    ${list0}    AddressLine2
        Log    ${index2}
        ${index3}    Get Index From List    ${list0}    AddressLine3
        Log    ${index3}
        ${index4}    Get Index From List    ${list0}    AddressLine4
        Log    ${index4}
        ${index5}    Get Index From List    ${list0}    AddressLine5
        Log    ${index5}
        ${index6}    Get Index From List    ${list0}    ZipCode
        Log    ${index6}
        ${list}    Get From List    ${AgentDetaillistdf}    1

        # agentaddressline1
        ${AgentAddressLine1}    Set Variable    ${list}[${index1}]
        IF    '${AgentAddressLine1}' != 'None' and '${AgentAddressLine1}' != ''
            ${AgentAddressLine1}    Strip String    ${AgentAddressLine1}
            ${AgentAddressLine1}    AES Decrypt    ${key}    ${AgentAddressLine1}
        END
        Set Global Variable    ${AgentAddressLine1}
        # agentaddressline2
        ${AgentAddressLine2}    Set Variable    ${list}[${index2}]
        IF    '${AgentAddressLine2}' != 'None' and '${AgentAddressLine2}' != ''
            ${AgentAddressLine2}    Strip String    ${AgentAddressLine2}
            ${AgentAddressLine2}    AES Decrypt    ${key}    ${AgentAddressLine2}
        END
        Set Global Variable    ${AgentAddressLine2}

        # agentaddressline3
        ${AgentAddressLine3}    Set Variable    ${list}[${index3}]
         IF    '${AgentAddressLine3}' != 'None' and '${AgentAddressLine3}' != ''
            ${AgentAddressLine3}    Strip String    ${AgentAddressLine3}
            ${AgentAddressLine3}    AES Decrypt    ${key}    ${AgentAddressLine3}
         END
         Set Global Variable    ${AgentAddressLine3}

        # agentaddressline4

        ${AgentAddressLine4}    Set Variable    ${list}[${index4}]
        IF    '${AgentAddressLine4}' != 'None' and '${AgentAddressLine4}' != ''
            ${AgentAddressLine4}    Strip String    ${AgentAddressLine4}
            ${AgentAddressLine4}    AES Decrypt    ${key}    ${AgentAddressLine4}
        END
        Set Global Variable    ${AgentAddressLine4}

        # agentaddressline5
        ${AgentAddressLine5}    Set Variable    ${list}[${index5}]
        IF    '${AgentAddressLine5}' != 'None' and '${AgentAddressLine5}' != ''
            ${AgentAddressLine5}    Strip String    ${AgentAddressLine5}
            ${AgentAddressLine5}    AES Decrypt    ${key}    ${AgentAddressLine5}
        END
        Set Global Variable    ${AgentAddressLine5}

        # agentZipCode
        ${AgentZipCode}    Set Variable    ${list}[${index6}]
        IF    '${AgentZipCode}' != 'None' and '${AgentZipCode}' != ''
            ${AgentZipCode}    Strip String    ${AgentZipCode}
            ${AgentZipCode}    AES Decrypt    ${key}    ${AgentZipCode}
        END
        Set Global Variable    ${AgentZipCode}

        # Enter Servicing Details
    #    Input Text    ${${platformName}_${lang}_AddressLineOne}    ${AgentAddressLine1}
    #    Input Text    ${${platformName}_${lang}_AddressLineTwo}    ${AgentAddressLine2}
    #    IF    '${platformName}' == 'iOS'
    #    Input Text    ${${platformName}_${lang}_txtZipCode}    ${AgentZipCode}
    #    ELSE
    #    Click Element    ${${platformName}_${lang}_txtZipCode}
    #    Sleep    3s
    #    Input Text Into Current Element    ${AgentZipCode}
    #    Close keyboard
    #    END
    #    Sleep    1s
    #    Click Element    ${${platformName}_${lang}_AddressLineOne}
    #    Close keyboard
    #    Take Screenshot    ServicingAgent_Address
    #    Click Element    ${${platformName}_${lang}_btnNext}
        # Capture Servicng Agent Error
    #    Wait Until Element Is Visible    ${${platformName}_${lang}_AddresserrorMessage}    timeout=20s
    #    ${vp_errormsg}    Get Text    ${${platformName}_${lang}_AddresserrorMessage}
    #    Take Screenshot    Servicing_Agent_Error
    #    Set Calc VP With Source And Original Values    Address_Validation_ErrorMsg    ${vp_errormsg}    ${vp_errormsg}    static    Omne Application    ${vp_errormsg}    ${vp_errormsg}

        Clear Text    ${${platformName}_${lang}_AddressLineOne}
        Clear Text    ${${platformName}_${lang}_AddressLineTwo}
        Clear Text    ${${platformName}_${lang}_txtZipCode}
        ${PersonalDetails_Address_Line1}    Set Variable    ${EMPTY}
        FOR    ${counter}    IN RANGE    1    7
            Log    ${counter}
            ${randomnum}    FakerLibrary.Random Uppercase Letter
            ${PersonalDetails_Address_Line1}    Set Variable    ${PersonalDetails_Address_Line1}${randomnum}
        END
        Input Text    ${${platformName}_${lang}_AddressLineOne}    ${PersonalDetails_Address_Line1}
        ${PersonalDetails_Address_Line2}    Set Variable    ${EMPTY}
        FOR    ${counter}    IN RANGE    1    7
            Log    ${counter}
            ${randomnum}    FakerLibrary.Random Uppercase Letter
            ${PersonalDetails_Address_Line2}    Set Variable    ${PersonalDetails_Address_Line2}${randomnum}
        END
        Input Text    ${${platformName}_${lang}_AddressLineTwo}    ${PersonalDetails_Address_Line2}
        IF    '${platformName}' == 'iOS'
            Input Text    ${${platformName}_${lang}_txtZipCode}    ${PersonalDetails_Address_ZipCode}
        ELSE
            Click Element    ${${platformName}_${lang}_txtZipCode}
            Input Text Into Current Element    ${PersonalDetails_Address_ZipCode}
            Close keyboard
        END
        Click Element    ${${platformName}_${lang}_AddressLineOne}
        Close keyboard
        SwipePage
        Take Screenshot    Update_Address
        ${New_Address}    Set Variable
        ...    ${PersonalDetails_Address_Line1} ${PersonalDetails_Address_Line2} ${PersonalDetails_Address_State}, ${PersonalDetails_Address_District}, ${PersonalDetails_Address_City}

        # Previous OTP from DB
        Get Details from DB
        ${Previous_OTP}    Set Variable    ${OTPNumber}
        Set Global Variable    ${Previous_OTP}
        Wait Until Page Contains Element    ${${platformName}_${lang}_btnNext}    timeout=5s
        Click Element    ${${platformName}_${lang}_btnNext}
        Take Screenshot    Update_Address

       # Capture Address Summary Details
        Wait Until Element Is Visible    ${${platformName}_${lang}_AddressViewSummaryPage}    timeout=5s
        Take Screenshot    View Summary Page
        ${VP_summaryPage_newAddress}    Get Text    ${${platformName}_${lang}_SummaryPage_newAddress}
        @{VP_NewAddress}    Split String    ${VP_summaryPage_newAddress}    ,
        ${New_Address_Line1}    Get From List    ${VP_NewAddress}    0
        ${New_Address_Line2}    Get From List    ${VP_NewAddress}    1
        ${New_Address_District}    Get From List    ${VP_NewAddress}    3
        ${New_Address_City}    Get From List    ${VP_NewAddress}    2
        ${New_Address_State}    Get From List    ${VP_NewAddress}    4
        ${New_Address_ZipCode}    Get From List    ${VP_NewAddress}    5
        ${New_Address_Country}    Get From List    ${VP_NewAddress}    6
        Set Calc VP Expected Result With Original And Source
        ...    New Address
        ...    ${VP_summaryPage_newAddress.strip()}
        ...    ${VP_summaryPage_newAddress.strip()}
        ...    View Summary Page
        Set Calc VP Expected Result With Original And Source
        ...    New_Address_Line1_DB
        ...    ${New_Address_Line1.strip()}
        ...    ${New_Address_Line1.strip()}
        ...    OmneApplication
        Set Calc VP Expected Result With Original And Source
        ...    New_Address_Line2_DB
        ...    ${New_Address_Line2.strip()}
        ...    ${New_Address_Line2.strip()}
        ...    OmneApplication
        Set Calc VP Expected Result With Original And Source
        ...    New_Address_State_DB
        ...    ${New_Address_State.strip()}
        ...    ${New_Address_State.strip()}
        ...    OmneApplication
    #    Set Calc VP Expected Result With Original And Source    New_Address_District_DB    ${New_Address_District.strip()}    ${New_Address_District.strip()}    OmneApplication
        Set Calc VP Expected Result With Original And Source
        ...    New_Address_City_DB
        ...    ${New_Address_City.strip()}
        ...    ${New_Address_City.strip()}
        ...    OmneApplication
        Set Calc VP Expected Result With Original And Source
        ...    New_Address_ZipCode_DB
        ...    ${New_Address_ZipCode.strip()}
        ...    ${New_Address_ZipCode.strip()}
        ...    OmneApplication
        Click Element    ${${platformName}_${lang}_SubmitButton}

        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_OTP_email}     timeout=3s
        IF    '${status}' == 'True'
            Insert OTP    ${Transaction_OTP_Source}    ${Transaction_OTP_Expiry_Flag}    ${Transaction_OTP_Resend_Flag}
        END
        ${status}    Run Keyword And Return Status
        ...    Wait Until Page Contains Element
        ...    ${${platformName}_${lang}_Change_Success_Txt}
        ...    timeout=3s
        IF    '${status}' == 'True'
            ${VP_Change_Success_Pass}    Get Text    ${${platformName}_${lang}_Change_Success_Txt}
            Set Global Variable    ${Successmsg}    ${VP_Change_Success_Pass}
            Set Calc VP With Source And Original Values
            ...    OMNE_App
            ...    Change Success
            ...    ${VP_Change_Success_Pass}
            ...    Static
            ...    OMNE_Application
            ...    Change Success
            ...    ${VP_Change_Success_Pass}
        END

        # New All Done Confirmation Page
        Run Keyword    Check Transaction Status
        Run Keyword    Completion Popup
        Run Keyword    Capture Address Transaction Details for ${platformName}

        Take Screenshot    Update_Details
        Set Global Variable    ${result}    Personal Details Address Changed Successfully for ${Policy_No}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Address Change
    END
Capture Address Transaction Details for iOS
    TRY
        Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=5s
        Click Element    ${${platformName}_${lang}_SeeAll}
        Take Screenshot    Transaction Page
        Wait Until Page Contains Element    ${${platformName}_${lang}_ServiceReuest}    timeout=5s
        Click Element    ${${platformName}_${lang}_ServiceReuest}
        RefreshPage
        ${iOS_selectCurrentTransaction1}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of mailing address' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction1}    timeout=60s
        Take Screenshot    Transaction Page

        ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction1}
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Policy no
        ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Change of mailing address
        ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
        ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
        ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
        IF    '${mTransactionstatus}' == 'Completed'
            ${mTransactionstatus}    Set Variable    Approve
            ${OPUSTransactionstatus}    Set Variable    Completed
            Set Global Variable    ${OPUSTransactionstatus}
        END
        Click Element    ${${platformName}_selectCurrentTransaction1}
        Take Screenshot    Transaction Page
        Wait Until Element Is Visible    chain=**/XCUIElementTypeOther[`label CONTAINS "New mailing address"`][-1]          timeout=3s
        ${AddressDetails}    Get Element Attribute
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS "New mailing address"`][-1]
        ...    attribute=label
        ${Policy}    Split String    ${AddressDetails}    New mailing address
        ${P}    Get From List    ${Policy}    1
        ${New_Address1}    Split String    ${P}    Policy(s) applied
        ${New_Add}    Get From List    ${New_Address1}    0
        ${PolicyDetails}    Get From List    ${New_Address1}    1
        ${PolicyDetails1}    Split String    ${PolicyDetails}    Policy no:
        ${Policy_Name}    Get From List    ${PolicyDetails1}    0
        ${PolicyDetails2}    Get From List    ${PolicyDetails1}    1
        ${PolicyDetails2}    Split String    ${PolicyDetails2}    Completion date
        ${VP_PolicyNo}    Get From List    ${PolicyDetails2}    0
        ${VP_PolicyNo}    Strip String    ${VP_PolicyNo}
    #    ${VP_New_Address}    Set Variable    ${add}
    #    ${Date}    Get From List    ${New_Address3}    1
        ${VP_Completion_Date}    Get From List    ${PolicyDetails2}    1

    #    ${VP_New_Address}    Strip String    ${VP_New_Address}
    #    ${VP_New_Address}    Replace String    ${VP_New_Address}    \n    ${SPACE}
    #    ${VP_New_Address}    Replace String    ${VP_New_Address}    ,    ${EMPTY}
    #    ${VP_New_Address}    Replace String    ${VP_New_Address}    ${SPACE}    ,${SPACE}
        ${VP_New_Address}    Split String    ${New_Add}    ,
        ${VP_New_Address_Line1}    Get From List    ${VP_New_Address}    0
        ${VP_New_Address_Line2}    Get From List    ${VP_New_Address}    1
        ${VP_New_City}    Get From List    ${VP_New_Address}    2
        ${VP_New_ZipCode}    Get From List    ${VP_New_Address}    5
        ${VP_New_State}    Get From List    ${VP_New_Address}    4
        ${VP_New_District}    Get From List    ${VP_New_Address}    3
        ${VP_New_Country}    Get From List    ${VP_New_Address}    6

        ${VP_New_Address_Line1}    Strip String    ${VP_New_Address_Line1}
        ${VP_New_Address_Line2}    Strip String    ${VP_New_Address_Line2}
        ${VP_New_City}    Strip String    ${VP_New_City}
        ${VP_New_ZipCode}    Strip String    ${VP_New_ZipCode}
        ${VP_New_State}    Strip String    ${VP_New_State}
        ${VP_New_District}    Strip String    ${VP_New_District}
        ${VP_New_Country}    Strip String    ${VP_New_Country}
        ${VP_Completion_Date}    Strip String    ${VP_Completion_Date}
        ${requeststatus}    Get Element Attribute
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of mailing address' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        ...    attribute=label
        ${pattern}    Set Variable    Completed
        ${reqstatus}    Get Regexp Matches    ${requeststatus}    ${pattern}
        ${VP_Transaction_Status}    Get From List    ${reqstatus}    0
        IF    '${VP_Transaction_Status}' == 'Completed'
            ${m_Vp}    Set Variable    Approve
            ${PreTxnStatus}    Set Variable    approve
            Set Global Variable    ${PreTxnStatus}
        END
        Set Calc VP With Source And Original Values
        ...    Policy_No
        ...    ${Policy_No}
        ...    ${VP_Policy_No}
        ...    PersonalDetail_Page
        ...    Transaction_Page
        ...    ${Policy_No}
        ...    ${VP_Policy_No}
        IF    '${Insurance_Flow}' == 'Manage'
            IF    '${Core_System}' != ''
                Set Calc VP Expected Result With Original And Source
                ...    ${Core_System}_AddressLine1
                ...    ${VP_New_Address_Line1}
                ...    ${VP_New_Address_Line1}
                ...    OMNE_Transaction_Page
                Set Calc VP Expected Result With Original And Source
                ...    ${Core_System}_AddressLine2
                ...    ${VP_New_Address_Line2}
                ...    ${VP_New_Address_Line2}
                ...    OMNE_Transaction_Page
                IF    '${Core_System}' == 'IL'
                    Set Calc VP Expected Result With Original And Source
                    ...    ${Core_System}_AddressState
                    ...    ${VP_New_State}
                    ...    ${VP_New_State}
                    ...    OMNE_Transaction_Page
                    Set Calc VP Expected Result With Original And Source
                    ...    ${Core_System}_AddressDistrict
                    ...    ${VP_New_District}
                    ...    ${VP_New_District}
                    ...    OMNE_Transaction_Page
                    Set Calc VP Expected Result With Original And Source
                    ...    ${Core_System}_AddressCity
                    ...    ${VP_New_City}
                    ...    ${VP_New_City}
                    ...    OMNE_Transaction_Page
                END
                Set Calc VP Expected Result With Original And Source
                ...    ${Core_System}_AddressZipCode
                ...    ${VP_New_ZipCode}
                ...    ${VP_New_ZipCode}
                ...    OMNE_Transaction_Page
            END
        END
    #    ${VP_Completion_Date}    Convert Date    ${currdate}    result_format=%d %b %Y
        Set Calc VP With Source And Original Values
        ...    Completion Date
        ...    ${VP_Completion_Date}
        ...    ${VP_Completion_Date}
        ...    PersonalDetail_Page
        ...    Transaction_Page
        ...    ${VP_Completion_Date}
        ...    ${VP_Completion_Date}
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status
        ...    ${m_Vp}
        ...    ${VP_Transaction_Status}
        ...    OMNE_TransactionPage
        ${Con_NewAddress}    Catenate
        ...    ${VP_New_Address_Line1}, ${VP_New_Address_Line2}, ${VP_New_District}, ${VP_New_City}, ${VP_New_State}, ${VP_New_ZipCode}, ${VP_New_Country}
        Set Calc VP Expected Result With Original And Source
        ...    New Address
        ...    ${Con_NewAddress}
        ...    ${Con_NewAddress}
        ...    OMNE_TransactionPage
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Address Change
    END
Capture Address Transaction Details for Android
    Wait Until Page Contains Element    ${${platformName}_${lang}_ServiceReuest}    timeout=50s
    Click Element    ${${platformName}_${lang}_ServiceReuest}
    Take Screenshot    Transaction_Page
    RefreshPage
    ${Android_selectCurrentTransaction1}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of mailing address']/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]

    Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction1}    timeout=60s
    Take Screenshot    Transaction Page

    ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction1}
    ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
    ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
    IF    '${mTransactionstatus}' == 'Completed'
        ${mTransactionstatus}    Set Variable    Approve
    END
    Click Element    ${${platformName}_selectCurrentTransaction1}
    Take Screenshot    Transaction Page
    # new address
    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_Transaction_NewAddress}
    ${NewAddress}    Get Text    ${${platformName}_${lang}_Transaction_NewAddress}
    ${NewAddress}    Replace String    ${NewAddress}    \n    ${SPACE}
    ${mVP_newAddress}    Remove String    ${NewAddress}    ,

    # policy applied
    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_AddressPolicyApplied}
    ${VP_PolicyApplied}    Get Text    ${${platformName}_${lang}_AddressPolicyApplied}
    ${VP_PolicyApplied}    Strip String    ${VP_PolicyApplied}

    # policy number
    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_AddresspolicyNumber}
    ${VP_Policy_No}    Get Text    ${${platformName}_${lang}_AddresspolicyNumber}
    ${VP_Policy_No}    Remove String    ${VP_Policy_No}    Policy no:
    ${VP_Policy_No}    Strip String    ${VP_Policy_No}

    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_TransactionCompletionDate}
    ${VP_Completion_Date}    Get Text    ${${platformName}_${lang}_TransactionCompletionDate}
    ${VP_Completion_Date}    Strip String    ${VP_Completion_Date}

    ${VP_New_Address}    Split String    ${NewAddress}    ,
    ${VP_New_Address_Line1}    Get From List    ${VP_New_Address}    0
    ${VP_New_Address_Line2}    Get From List    ${VP_New_Address}    1
    ${VP_New_City}    Get From List    ${VP_New_Address}    2
    ${VP_New_ZipCode}    Get From List    ${VP_New_Address}    5
    ${VP_New_State}    Get From List    ${VP_New_Address}    4
    ${VP_New_District}    Get From List    ${VP_New_Address}    3
    ${VP_New_Country}    Get From List    ${VP_New_Address}    6

    ${VP_New_Address_Line1}    Strip String    ${VP_New_Address_Line1}
    ${VP_New_Address_Line2}    Strip String    ${VP_New_Address_Line2}
    ${VP_New_City}    Strip String    ${VP_New_City}
    ${VP_New_ZipCode}    Strip String    ${VP_New_ZipCode}
    ${VP_New_State}    Strip String    ${VP_New_State}
    ${VP_New_District}    Strip String    ${VP_New_District}
    ${VP_New_Country}    Strip String    ${VP_New_Country}
    Set Calc VP With Source And Original Values
    ...    Policy_No
    ...    ${Policy_No}
    ...    ${VP_Policy_No}
    ...    PersonalDetail_Page
    ...    Transaction_Page
    ...    ${Policy_No}
    ...    ${VP_Policy_No}
    IF    '${Insurance_Flow}' == 'Manage'
        IF    '${Core_System}' != ''
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_AddressLine1
            ...    ${VP_New_Address_Line1}
            ...    ${VP_New_Address_Line1}
            ...    OMNE_Transaction_Page
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_AddressLine2
            ...    ${VP_New_Address_Line2}
            ...    ${VP_New_Address_Line2}
            ...    OMNE_Transaction_Page
            IF    '${Core_System}' == 'IL'
                Set Calc VP Expected Result With Original And Source
                ...    ${Core_System}_AddressState
                ...    ${VP_New_State}
                ...    ${VP_New_State}
                ...    OMNE_Transaction_Page
                Set Calc VP Expected Result With Original And Source
                ...    ${Core_System}_AddressDistrict
                ...    ${VP_New_District}
                ...    ${VP_New_District}
                ...    OMNE_Transaction_Page
                Set Calc VP Expected Result With Original And Source
                ...    ${Core_System}_AddressCity
                ...    ${VP_New_City}
                ...    ${VP_New_City}
                ...    OMNE_Transaction_Page
            END
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_AddressZipCode
            ...    ${VP_New_ZipCode}
            ...    ${VP_New_ZipCode}
            ...    OMNE_Transaction_Page
        END
    END
#    ${VP_Completion_Date}    Convert Date    ${currdate}    result_format=%d %b %Y
    Set Calc VP With Source And Original Values
    ...    Completion Date
    ...    ${VP_Completion_Date}
    ...    ${VP_Completion_Date}
    ...    PersonalDetail_Page
    ...    Transaction_Page
    ...    ${VP_Completion_Date}
    ...    ${VP_Completion_Date}
    Set Calc VP Expected Result With Original And Source
    ...    Transaction_Status
    ...    ${mTransactionstatus}
    ...    ${mTransactionstatus}
    ...    OMNE_TransactionPage
    ${Con_NewAddress}    Catenate
    ...    ${VP_New_Address_Line1}, ${VP_New_Address_Line2}, ${VP_New_District}, ${VP_New_City}, ${VP_New_State}, ${VP_New_ZipCode}, ${VP_New_Country}
    Set Calc VP Expected Result With Original And Source
    ...    New Address
    ...    ${Con_NewAddress}
    ...    ${Con_NewAddress}
    ...    OMNE_TransactionPage

Name Change
    TRY
        ${iOS_Title}    Set Variable    chain=**/XCUIElementTypeStaticText[`label CONTAINS "${PersonalDetails_Title}"`]
        ${iOS_MaritalStatus}    Set Variable
        ...    chain=**/XCUIElementTypeStaticText[`label == "${PersonalDetails_MaritalStatus}"`]
        ${Android_Title}    Set Variable    android=new UiSelector().textContains("${PersonalDetails_Title}")
        ${Android_MaritalStatus}    Set Variable
        ...    android=new UiSelector().textContains("${PersonalDetails_MaritalStatus}")
        Wait Until Page Contains Element    ${${platformName}_${lang}_txtTitle}    timeout=10s
        # Capture ALl Detaila
        ${Title}    Get Text    ${${platformName}_${lang}_txtTitle}
        ${Title}    Remove String    ${Title}    Title
        ${Title}    Remove String    ${Title}    .
        ${Current_FirstName}    Get Text    ${${platformName}_${lang}_txtFirstName}
        ${Current_MiddleName}    Get Text    ${${platformName}_${lang}_txtMiddleName}
        ${Current_LastName}    Get Text    ${${platformName}_${lang}_txtLastName}
        ${Current_MaritalStatus}    Get Text    ${${platformName}_${lang}_Marital_Status}
        ${Current_MaritalStatus}    Remove String    ${Current_MaritalStatus}    Marital status (Optional)
        ${fname}    FakerLibrary.First_Name
        ${mname}    FakerLibrary.First_Name
        ${lname}    FakerLibrary.Last_Name
        Take Screenshot    Personal_Details_Page
        # Clear Old Details
        Clear Text    ${${platformName}_${lang}_txtFirstName}

        ${Status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_Error_Messgage_FirstName}
        ...    timeout=5s
        IF    '${Status}' == 'True'
            ${msg}    Get Text    ${${platformName}_${lang}_Error_Messgage_FirstName}
    #    attribute=value
            ${errormsg}    Set Variable    ${msg}
            Take Screenshot    ChangeName_Error
            Set Calc VP With Source And Original Values
            ...    Firstname_ErrorMsg
            ...    ${errormsg}
            ...    ${errormsg}
            ...    Static
            ...    OMNE_Application
            ...    ${errormsg}
            ...    ${errormsg}
        END
        Clear Text    ${${platformName}_${lang}_txtMiddleName}
        Clear Text    ${${platformName}_${lang}_txtLastName}
        ${Status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_Error_Messgage_LasttName}
        ...    timeout=5s
        IF    '${Status}' == 'True'
            ${msg}    Get Text    ${${platformName}_${lang}_Error_Messgage_LasttName}
            #    attribute=value
            ${errormsg}    Set Variable    ${msg}
            Take Screenshot    ChangeName_Error
            Set Calc VP With Source And Original Values
            ...    Lastname_ErrorMsg
            ...    ${errormsg}
            ...    ${errormsg}
            ...    Static
            ...    OMNE_Application
            ...    ${errormsg}
            ...    ${errormsg}
        END
        Close keyboard
        Take Screenshot    Personal_Details_Error_Page
        # Input New ELement
        IF    '${PersonalDetails_Title}' != '${Title}'
            Click Element    ${${platformName}_${lang}_txtTitle}
            Click Element    ${${platformName}_Title}
        END
        Click Element    ${${platformName}_${lang}_txtFirstName}
        Input Text    ${${platformName}_${lang}_txtFirstName}    ${fname}
        ${Status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_Error_Messgage_FirstName}
        ...    timeout=5s
        IF    '${Status}' == 'True'
            ${msg}    Get Text    ${${platformName}_${lang}_Error_Messgage_FirstName}
        #    attribute=value
            ${errormsg}    Set Variable    ${msg}
            Set Calc VP With Source And Original Values
            ...    ErrorMsg
            ...    ${errormsg}
            ...    ${errormsg}
            ...    Static
            ...    OMNE_Application
            ...    ${errormsg}
            ...    ${errormsg}
            Set Global Variable    Change Name :${errormsg}
        END
        Close keyboard
        Input Text    ${${platformName}_${lang}_txtMiddleName}    ${mname}
        Close keyboard
        Input Text    ${${platformName}_${lang}_txtLastName}    ${lname}
        Close keyboard
        ${Status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_Error_Messgage_LasttName}
        ...    timeout=5s
        IF    '${Status}' == 'True'
            ${msg}    Get Text    ${${platformName}_${lang}_Error_Messgage_LasttName}
            #    attribute=value
            ${errormsg}    Set Variable    ${msg}
            Set Calc VP With Source And Original Values
            ...    ErrorMsg
            ...    ${errormsg}
            ...    ${errormsg}
            ...    Static
            ...    OMNE_Application
            ...    ${errormsg}
            ...    ${errormsg}
            Set Global Variable    Change Name :${errormsg}
        END
        Set Global Variable    ${Title}
        Set Global Variable    ${fname}
        Set Global Variable    ${mname}
        Set Global Variable    ${lname}
        IF    '${PersonalDetails_MaritalStatus}' != '${Current_MaritalStatus}'
            Wait Until Page Contains Element    ${${platformName}_${lang}_Marital_Status}        timeout=10s
            Click Element    ${${platformName}_${lang}_Marital_Status}
            Wait Until Page Contains Element    ${${platformName}_MaritalStatus}            timeout=10s
            Click Element    ${${platformName}_MaritalStatus}
        END
        Take Screenshot    Personal_Details_Page
        Click Element    ${${platformName}_${lang}_Submit_btn}
        ${status}    Run Keyword And Return Status
        ...    Element Should Be Disabled
        ...    ${${platformName}_${lang}_Personal_particulars}
        IF    '${status}' == 'True'
            Set Calc VP With Source And Original Values
            ...    Update_Personal_Particulars_text_present
            ...    true
            ...    ${status}
            ...    Static
            ...    OMNE_Application
            ...    True
            ...    ${status}
        END
        Wait Until Page Contains Element    ${${platformName}_${lang}_Personal_particulars}    timeout=20s
        Wait Until Element Is Visible    ${${platformName}_${lang}_AddImage}    timeout=20s
        Click Element    ${${platformName}_${lang}_AddImage}
        ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/Certificate.PNG
        Upload Document BS    ${path}
        Take Screenshot    Update_Name/MaritalStatus
        Click Text    Save    exact_match=true
        # Previous OTP from DB
        Get Details from DB
        ${Previous_OTP}    Set Variable    ${OTPNumber}
        Set Global Variable    ${Previous_OTP}
        Wait Until Page Contains Element    ${${platformName}_${lang}_Submit_btn}    timeout=20s
        Click Text    Submit    exact_match=true
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_Submit_btn}
        ...    timeout=5s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_Submit_btn}
        END
        Take Screenshot    Update_Name/MaritalStatus
        ${status}    Run Keyword And Return Status    Element Should Be Disabled    ${${platformName}_${lang}_Verify_btn}
        IF    '${status}' == 'True'
            Set Calc VP With Source And Original Values
            ...    Verify_Button_Disable_By_Default
            ...    true
            ...    ${status}
            ...    Static
            ...    OMNE_Application
            ...    True
            ...    ${status}
        END
        Run Keyword    Insert OTP
        ...    ${Transaction_OTP_Source}
        ...    ${Transaction_OTP_Expiry_Flag}
        ...    ${Transaction_OTP_Resend_Flag}
        Run Keyword    Check Transaction Status
        Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=20s
        Click Element    ${${platformName}_${lang}_SeeAll}
        Run Keyword    Capture Change Name Transaction Details for ${platformName}    Pre
        Set Global Variable    ${result}    Personal Details Name/Marital Changed Initiate Successfully
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Personal Details Name/Marital Changed
    END
Capture Change Name Transaction Details for iOS
    [Arguments]    ${Transaction_Info}
    TRY
        IF    '${Transaction_Info}'== 'Pre'
            ${iOS_selectCurrentTransaction1}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of personal details In progress' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        ELSE IF    '${Transaction_Info}'== 'Post'
            ${iOS_selectCurrentTransaction1}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of personal details ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        END

        Wait Until Page Contains Element    ${${platformName}_${lang}_TransactionServiceRequest}    timeout=10s
        Click Element    ${${platformName}_${lang}_TransactionServiceRequest}
    #    Log    ${${platformName}_selectCurrentTransaction1}
        RefreshPage

        Scroll Till Transaction Is Visible    ${${platformName}_selectCurrentTransaction1}
        Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction1}    timeout=300s
        Take Screenshot    Transaction Page
        Click Element    ${${platformName}_selectCurrentTransaction1}
        ${CompleteStatus_List}    Get Text    ${${platformName}_selectCurrentTransaction1}
        @{Transaction_Status_List}    Split String    ${CompleteStatus_List}    Policy no
        Log To Console    Test1
        Take Screenshot    Transaction_Page
        ${TransactionStatus_list2}    Get From List    ${Transaction_Status_List}    0
        Log To Console    Test2
        @{TransactionStatus_list2}    Split String    ${TransactionStatus_list2}
        Log To Console    Test3
        ${Count}    Get Length    ${TransactionStatus_list2}
        ${Count}    Evaluate    ${Count} - 1
        ${VP_Transaction_Status}    Get From List    ${TransactionStatus_list2}    ${Count}
        Log To Console    Test4
        Log     Transaction_Status=${VP_Transaction_Status}
        Log To Console    ListCount=${Count}
        IF    '${VP_Transaction_Status}' == 'progress'
            ${m_VP_Transaction_Status}    Set Variable    In Progress
            Set Global Variable    ${m_VP_Transaction_Status}
            ${OPUSTransactionstatus}    Set Variable    In progress
            Set Global Variable    ${OPUSTransactionstatus}
            Log     ${OPUSTransactionstatus}
        END
        IF    '${VP_Transaction_Status}' == 'Completed'
            ${m_VP_Transaction_Status}    Set Variable    Approve
            Set Global Variable    ${m_VP_Transaction_Status}
            ${OPUSTransactionstatus}    Set Variable    Completed
            Set Global Variable    ${OPUSTransactionstatus}
        END
        IF    '${VP_Transaction_Status}' == 'Declined'
            ${m_VP_Transaction_Status}    Set Variable    Decline
            Set Global Variable    ${m_VP_Transaction_Status}
        END

        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS "Title"`][27]
        ...    timeout=10s
        IF    '${status}'=='True'
            ${NameDetails}    Get Text    chain=**/XCUIElementTypeOther[`label CONTAINS "Title"`][27]
            @{Details}    Split String    ${NameDetails}    Title
            ${NameDetails}    Get From List    ${Details}    1
            @{NameDetails}    Split String    ${NameDetails}    New
            ${title}    Get From List    ${NameDetails}    0
            #    ${title}    Remove String    ${title}    Title
            ${title}    Remove String    ${title}    .
            Log To Console    Title:-${title}
            ${FirstNameList}    Get From List    ${NameDetails}    1
            ${VP_FirstName}    Remove String    ${FirstNameList}    First name
            Log To Console    FirstName=${VP_FirstName}
            ${LastNameList}    Get From List    ${NameDetails}    2

            ${LastNameList}    Get From List    ${NameDetails}    2
            ${VP_MiddleName}    Remove String    ${LastNameList}    Middle name
            Log To Console    MiddleName=${VP_MiddleName}
            ${LastNameList}    Get From List    ${NameDetails}    3
            ${VP_LastName}    Remove String    ${LastNameList}    Last name
            Log To Console    LastName=${VP_LastName}
            ${MartialStatusList}    Get From List    ${NameDetails}    4
            ${VP_MartialStatus}    Remove String    ${MartialStatusList}    Marital status
            Log To Console    LastName=${VP_MartialStatus}
            Set Calc VP With Source And Original Values
            ...    Transaction_NEW_Title
            ...    ${Title.strip()}
            ...    ${title.strip()}
            ...    OMNE_NameChangePage
            ...    OMNE_Transaction_Page
            ...    ${Title}
            ...    ${title}
            Set Calc VP Expected Result With Original And Source
            ...    NEW_Title
            ...    ${title.strip()}
            ...    ${title}
            ...    OMNE_Transaction_Page
            Set Calc VP Expected Result With Original And Source
            ...    NEW_Title_DB
            ...    ${title.strip()}
            ...    ${title}
            ...    OMNE_NameChangePage
        ELSE
            ${NameDetails}    Get Text    chain=**/XCUIElementTypeOther[`label CONTAINS "First name"`][27]
            @{NameDetails}    Split String    ${NameDetails}    ${Policy_No}
            ${NameDetails}    Get From List    ${NameDetails}    1
            ${NameDetails}    Split String    ${NameDetails}    New
            ${FirstNameList}    Get From List    ${NameDetails}    1
            ${VP_FirstName}    Remove String    ${FirstNameList}    First name
            Log To Console    FirstName=${VP_FirstName}
            ${LastNameList}    Get From List    ${NameDetails}    2
            ${VP_MiddleName}    Remove String    ${LastNameList}    Middle name
            Log To Console    MiddleName=${VP_MiddleName}
            ${LastNameList}    Get From List    ${NameDetails}    3
            ${VP_LastName}    Remove String    ${LastNameList}    Last name
            Log To Console    LastName=${VP_LastName}
            ${MartialStatusList}    Get From List    ${NameDetails}    4
            ${VP_MartialStatus}    Remove String    ${MartialStatusList}    Marital status
            Log To Console    LastName=${VP_MartialStatus}
        END
        IF    '${Transaction_Info}'== 'Pre'
                Set Calc VP With Source And Original Values
                ...    Transaction_NEW_FirstName
                ...    ${fname.strip()}
                ...    ${VP_FirstName.strip()}
                ...    OMNE_NameChangePage
                ...    OMNE_Transaction_Page
                ...    ${fname}
                ...    ${VP_FirstName}

                Set Calc VP With Source And Original Values
                ...    Transaction_NEW_LastName
                ...    ${lname.strip()}
                ...    ${VP_LastName.strip()}
                ...    OMNE_NameChangePage
                ...    OMNE_Transaction_Page
                ...    ${lname}
                ...    ${VP_LastName}

                Set Calc VP Expected Result With Original And Source
                ...    Transaction_Status
                ...    ${m_VP_Transaction_Status.strip()}
                ...    ${m_VP_Transaction_Status}
                ...    OMNE_Transaction_Page

                Set Calc VP Expected Result With Original And Source
                ...    NEW_FirstName
                ...    ${VP_FirstName.strip()}
                ...    ${VP_FirstName}
                ...    OMNE_Transaction_Page

                Set Calc VP Expected Result With Original And Source
                ...    NEW_MiddleName
                ...    ${VP_MiddleName.strip()}
                ...    ${VP_MiddleName.strip()}
                ...    OMNE_Transaction_Page

                Set Calc VP Expected Result With Original And Source
                ...    NEW_LastName
                ...    ${VP_LastName.strip()}
                ...    ${VP_LastName}
                ...    OMNE_Transaction_Page

                Set Calc VP Expected Result With Original And Source
                ...    NEW_FirstName_DB
                ...    ${VP_FirstName.strip()}
                ...    ${VP_FirstName}
                ...    OMNE_NameChangePage

                Set Calc VP Expected Result With Original And Source
                ...    NEW_MiddleName_DB
                ...    ${VP_MiddleName.strip()}
                ...    ${VP_MiddleName.strip()}
                ...    OMNE_NameChangePage

                Set Calc VP Expected Result With Original And Source
                ...    NEW_LastName_DB
                ...    ${VP_LastName.strip()}
                ...    ${VP_LastName}
                ...    OMNE_NameChangePage

                IF    '${VP_MartialStatus}' != ''
                    Set Calc VP Expected Result With Original And Source
                    ...    NEW_MaritalStatus
                    ...    ${VP_MartialStatus.strip()}
                    ...    ${VP_MartialStatus}
                    ...    OMNE_Transaction_Page
                     Set Calc VP Expected Result With Original And Source
                    ...   NEW_MaritalStatus_DB
                    ...   ${PersonalDetails_MaritalStatus}
                    ...   ${PersonalDetails_MaritalStatus}
                    ...   OMNE_NameChangePage
                END

        ELSE IF    '${Transaction_Info}'== 'Post'
                IF    '${VP_MartialStatus}' != ''

                    Set Calc VP Actual Result With Original And Source
                    ...    Post_OWB_NEW_MaritalStatus
                    ...    ${VP_MartialStatus.strip()}
                    ...    ${VP_MartialStatus}
                    ...    OMNE_Transaction_Page
                END

                Set Calc VP Expected Result With Original And Source
                ...    Transaction_Status_OPUS
                ...    ${m_VP_Transaction_Status.strip()}
                ...    ${m_VP_Transaction_Status}
                ...    OMNE_Transaction_Page



                Set Calc VP Actual Result With Original And Source
                ...    Post_OWB_NEW_Title
                ...    ${title.strip()}
                ...    ${title}
                ...    OMNE_Transaction_Page
                Set Calc VP Actual Result With Original And Source
                ...    Post_OWB_NEW_FirstName
                ...    ${VP_FirstName.strip()}
                ...    ${VP_FirstName}
                ...    OMNE_Transaction_Page
                Set Calc VP Actual Result With Original And Source
                ...    Post_OWB_NEW_MiddleName
                ...    ${VP_MiddleName.strip()}
                ...    ${VP_MiddleName.strip()}
                ...    OMNE_Transaction_Page
                Set Calc VP Actual Result With Original And Source
                ...    Post_OWB_NEW_LastName
                ...    ${VP_LastName.strip()}
                ...    ${VP_LastName}
                ...    OMNE_Transaction_Page
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END

Capture Change Name Transaction Details for Android
    [Arguments]    ${Transaction_Info}
    Wait Until Page Contains Element
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of personal details'])[1]
    ...    timeout=40s
    Click Element
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of personal details'])[1]
    Take Screenshot    Transaction_Page
    Sleep    5s
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_TransactionTitle}
    ...    timeout=10s
    IF    '${status}'=='True'
        ${VP_Title}    Get Text    ${${platformName}_${lang}_TransactionTitle}
        Set Calc VP With Source And Original Values
        ...    Transaction_NEW_Title
        ...    ${Title.strip()}
        ...    ${VP_Title.strip()}
        ...    OMNE_NameChangePage
        ...    OMNE_Transaction_Page
        ...    ${Title}
        ...    ${title}
        Set Calc VP Expected Result With Original And Source
        ...    NEW_Title
        ...    ${VP_Title.strip()}
        ...    ${VP_Title.strip()}
        ...    OMNE_Transaction_Page
        Set Calc VP Expected Result With Original And Source
        ...    NEW_Title_DB
        ...    ${VP_Title.strip()}
        ...    ${VP_Title.strip()}
        ...    OMNE_NameChangePage
        Set Calc VP Actual Result With Original And Source
        ...    Post_OWB_NEW_Title
        ...    ${VP_Title.strip()}
        ...    ${VP_Title.strip()}
        ...    OMNE_Transaction_Page
    END
    ${VP_FirstName}    Get Text    ${${platformName}_${lang}_TransactionFirstName}
    ${VP_MiddleName}    Get Text    ${${platformName}_${lang}_TransactionMiddleName}
    ${VP_LastName}    Get Text    ${${platformName}_${lang}_TransactionLastName}
#    ${VP_MaritalStatus}    Get Text    ${EN_TransactionMarital}
#    ${VP_Completion_Date}    Get Text    ${EN_Completion_Date}
    ${requeststatus}    Get Text    ${${platformName}_${lang}_TransactionStatus}
    IF    '${requeststatus}' == 'Completed'
        ${m_requeststatus}    Set Variable    Approve
        Set Global Variable    ${m_requeststatus}
    END
    IF    '${requeststatus}' == 'In progress'
        ${m_requeststatus}    Set Variable    In Progress
        Set Global Variable    ${m_requeststatus}
    END
    Set Calc VP With Source And Original Values
    ...    Transaction_NEW_FirstName
    ...    ${fname.strip()}
    ...    ${VP_FirstName.strip()}
    ...    OMNE_NameChangePage
    ...    OMNE_Transaction_Page
    ...    ${fname}
    ...    ${VP_FirstName}
    Set Calc VP With Source And Original Values
    ...    Transaction_NEW_LastName
    ...    ${lname.strip()}
    ...    ${VP_LastName.strip()}
    ...    OMNE_NameChangePage
    ...    OMNE_Transaction_Page
    ...    ${lname}
    ...    ${VP_LastName}
    Set Calc VP Expected Result With Original And Source
    ...    Transaction_Status
    ...    ${m_requeststatus.strip()}
    ...    ${requeststatus}
    ...    OMNE_Transaction_Page

    Set Calc VP Expected Result With Original And Source
    ...    NEW_FirstName
    ...    ${VP_FirstName.strip()}
    ...    ${VP_FirstName}
    ...    OMNE_Transaction_Page
    Set Calc VP Expected Result With Original And Source
    ...    NEW_MiddleName
    ...    ${VP_MiddleName.strip()}
    ...    ${VP_MiddleName.strip()}
    ...    OMNE_Transaction_Page
    Set Calc VP Expected Result With Original And Source
    ...    NEW_LastName
    ...    ${VP_LastName.strip()}
    ...    ${VP_LastName}
    ...    OMNE_Transaction_Page
    IF    '${VP_MaritalStatus}' != ''
        Set Calc VP Expected Result With Original And Source
        ...    NEW_MaritalStatus
        ...    ${VP_MaritalStatus}
        ...    ${VP_MaritalStatus}
        ...    OMNE_Transaction_Page
    END

    Set Calc VP Expected Result With Original And Source
    ...    NEW_FirstName_DB
    ...    ${VP_FirstName.strip()}
    ...    ${VP_FirstName}
    ...    OMNE_NameChangePage
    Set Calc VP Expected Result With Original And Source
    ...    NEW_MiddleName_DB
    ...    ${VP_MiddleName.strip()}
    ...    ${VP_MiddleName.strip()}
    ...    OMNE_NameChangePage
    Set Calc VP Expected Result With Original And Source
    ...    NEW_LastName_DB
    ...    ${VP_LastName.strip()}
    ...    ${VP_LastName}
    ...    OMNE_NameChangePage
    Set Calc VP Expected Result With Original And Source
    ...    NEW_MaritalStatus_DB
    ...    ${PersonalDetails_MaritalStatus}
    ...    ${PersonalDetails_MaritalStatus}
    ...    OMNE_NameChangePage

    Set Calc VP Actual Result With Original And Source
    ...    Post_OWB_NEW_FirstName
    ...    ${VP_FirstName.strip()}
    ...    ${VP_FirstName}
    ...    OMNE_Transaction_Page
    Set Calc VP Actual Result With Original And Source
    ...    Post_OWB_NEW_MiddleName
    ...    ${VP_MiddleName.strip()}
    ...    ${VP_MiddleName.strip()}
    ...    OMNE_Transaction_Page
    Set Calc VP Actual Result With Original And Source
    ...    Post_OWB_NEW_LastName
    ...    ${VP_LastName.strip()}
    ...    ${VP_LastName}
    ...    OMNE_Transaction_Page
    Set Calc VP Actual Result With Original And Source
    ...    Post_OWB_NEW_MaritalStatus
    ...    ${VP_MartialStatus.strip()}
    ...    ${VP_MartialStatus}
    ...    OMNE_Transaction_Page
