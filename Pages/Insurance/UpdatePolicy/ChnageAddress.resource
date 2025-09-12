*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     String
Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/ChangeMobileAndEmailPageObject.Resource
Resource    ../Common/AddOTP.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/PersonalDetailsPageObject.resource
Library      .../../../../DBQuery/PersonalDetailsDB.py


*** Keywords ***
Address Change
    ${Android_SelectPolicyNo}    Set Variable
    ...    xpath=//android.widget.TextView[contains(@text,'${Policy_No}')]/following-sibling::android.widget.TextView[2]
    ${iOS_SelectPolicyNo}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Policy_No}'`][-1]
    Wait Until Page Contains Element    ${${platformName}_SelectPolicyNo}           timeout=10s
    Take Screenshot    Update Details
    Click Element    ${${platformName}_SelectPolicyNo}

    IF   '${Agent_Verification}' == 'Yes'
        Click Element    ${${platformName}_${lang}_NextButton}
        Take Screenshot    Update Details
        Agent Address Verifcation
        Set Global Variable    ${result}    Agent Address Not Changed Successfully
    ELSE
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
    END

Agent Address Verifcation
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

        Input Text    ${${platformName}_${lang}_AddressLineOne}    ${AgentAddressLine1}
        Input Text    ${${platformName}_${lang}_AddressLineTwo}    ${AgentAddressLine2}
        IF    '${platformName}' == 'iOS'
            Input Text    ${${platformName}_${lang}_txtZipCode}    ${AgentZipCode}
        ELSE
             Click Element    ${${platformName}_${lang}_txtZipCode}
             Sleep    3s
             Input Text Into Current Element    ${AgentZipCode}
             Close keyboard
        END
        Sleep    1s
        Click Element    ${${platformName}_${lang}_AddressLineOne}
        Close keyboard
        Take Screenshot    ServicingAgent_Address
        Click Element    ${${platformName}_${lang}_btnNext}
        Wait Until Element Is Visible    ${${platformName}_${lang}_SubmitButton}
        Click Element    ${${platformName}_${lang}_SubmitButton}
        # Capture Servicng Agent Error
        Wait Until Element Is Visible    ${${platformName}_${lang}_AddresserrorMessage}    timeout=20s
        ${vp_errormsg}    Get Text    ${${platformName}_${lang}_AddresserrorMessage}
        Take Screenshot    Servicing_Agent_Error
        Set Calc VP With Source And Original Values    Address_Validation_ErrorMsg    ${vp_errormsg}    ${vp_errormsg}    static    Omne Application    ${vp_errormsg}    ${vp_errormsg}

Capture Address Transaction Details for iOS
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
#     ${VP_Completion_Date}    Convert Date    ${currdate}    result_format=%d %b %Y
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



Capture Address Transaction Details for Android
    Take Screenshot    Transaction Page
    Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=50s
    Click Element    ${${platformName}_${lang}_SeeAll}
    Take Screenshot    Transaction_Page
    Wait Until Page Contains Element    ${${platformName}_${lang}_ServiceReuest}    timeout=50s
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
        ${OPUSTransactionstatus}    Set Variable    Completed
        Set Global Variable    ${OPUSTransactionstatus}
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
