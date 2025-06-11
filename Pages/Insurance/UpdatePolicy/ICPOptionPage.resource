*** Settings ***
Library     AppiumLibrary
Library     RequestsLibrary
Library    SeleniumLibrary

Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/ICPOptionPageobjects.resource
Resource      ../../../PageObjects/Insurance/Common/CommonObjects.resource
Resource    ../Common/AddOTP.resource
Resource    ../../../CustomLibraries/common.robot


*** Variables ***
${VP_Prodct_Name_PayCashoutapgr}    ${EMPTY}


*** Keywords ***
Preferred payout
    TRY
        Select Policy
        Take Screenshot    ICP_Option_page
        Click Element    ${${platformName}_${lang}_NextButton}
        Wait Until Page Contains Element    ${${platformName}_${lang}_CurrentPayoutOption}  timeout=2s
        ${VP_CureenPayoutOption}    Get Text    ${${platformName}_${lang}_CurrentPayoutOption}
        @{VP_CureenPayoutOption}        Split String    ${VP_CureenPayoutOption}    :
        ${VP_CureenPayoutOption}        Get From List    ${VP_CureenPayoutOption}    1
        ${mVP_CureenPayoutOption}    Convert To Upper Case   ${VP_CureenPayoutOption}
        ${mVP_CureenPayoutOption}       Set Variable        ${VP_CureenPayoutOption}
        IF    '${Transaction_Page_GUI}' == 'Yes'
            VP For Cash Payout Option Page
        END
        #check the current cashout method is same with data
        ${Android_EN_CaspayoutOption}            Set Variable      android=new UiSelector().textContains("${CashPayout_Option}")
        ${iOS_EN_CaspayoutOption}            Set Variable       chain=**/XCUIElementTypeOther[`label == '${CashPayout_Option}'`][-1]
        IF    '${VP_CureenPayoutOption.strip()}' != '${CashPayout_Option.strip()}'
            Wait Until Element Is Visible    ${${platformName}_${lang}_CaspayoutOption}        timeout=20s
            Click Element           ${${platformName}_${lang}_CaspayoutOption}
        END
        Take Screenshot    Cash_Payout_Option_page
        IF    '${CashPayout_Option}' == 'Bank transfer' or '${CashPayout_Option}' == 'Premium settlement'
            Sleep    2s
            ${Status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_Change_Button}     timeout=20s
            IF    '${Status}' == 'True'
                Click Element    ${${platformName}_${lang}_Change_Button}
            ELSE
                Wait Until Element Is Visible    ${${platformName}_${lang}_AddPaymentMethod_Button}    timeout=20s
                Click Element    ${${platformName}_${lang}_AddPaymentMethod_Button}
            END
            Take Screenshot    Cash_Payout_Option_Bank_page
            Run Keyword    Add Payment Methods

        ELSE IF    '${CashPayout_Option}' == 'PromptPay'
                Click Element    ${${platformName}_${lang}_Checkbox_Promatpay}
        END

        Wait Until Page Contains Element    ${${platformName}_Next_button}    timeout=20s
        Click Element    ${${platformName}_Next_button}
        Take Screenshot    Cash_Payout_Option_page
        # Previous OTP from DB
        Get Details from DB
        ${Previous_OTP}    Set Variable    ${OTPNumber}
        Set Global Variable    ${Previous_OTP}

        Wait Until Element Is Visible    ${${platformName}_${lang}_SubmitButton}   timeout=15s
        Click Element    ${${platformName}_${lang}_SubmitButton}
        Take Screenshot    Cash_Payout_Option_page

        Insert OTP      ${Transaction_OTP_Source}       ${Transaction_OTP_Expiry_Flag}      ${Transaction_OTP_Resend_Flag}

        Take Screenshot    Cash_Payout_Option_page
        ${status}    Run Keyword And Return Status
        ...    Wait Until Page Contains Element
        ...    ${${platformName}_${lang}_Change_Success_Txt}
        ...    timeout=5s
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
        Check Transaction Status
        Completion Popup
        Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=10s
        Click Element    ${${platformName}_${lang}_SeeAll}
        Take Screenshot    Transaction_Page
        Wait Until Page Contains Element    ${${platformName}_${lang}_ServiceReuest}    timeout=20s
        Click Element    ${${platformName}_${lang}_ServiceReuest}
        Take Screenshot    Transaction_Page
        Run Keyword      Capture ICP Transaction Details for ${platformName}
        Take Screenshot    Update_Details
        Set Global Variable    ${result}    ICP Option Changed Successfully For Policy No :${Policy_No}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END

VP For Cash Payout Option Page
    TRY
        ${Status}    Run Keyword And Return Status
        ...    Element Should Be Visible
        ...    ${${platformName}_${lang}_BankTansfer_Option}
        Set Calc VP With Source And Original Values
        ...    Cash_Payout_Option_Bank_Transfer_Avalible
        ...    true
        ...    ${status}
        ...    Static
        ...    OMNE_ChangeCashOutPage
        ...    true
        ...    ${status}
        ${Status}    Run Keyword And Return Status
        ...    Element Should Be Visible
        ...    ${${platformName}_${lang}_PromptPay_Option}
        Set Calc VP With Source And Original Values
        ...    Cash_Payout_Option_PromptPay_Avalible
        ...    true
        ...    ${status}
        ...    Static
        ...    OMNE_ChangeCashOutPage
        ...    true
        ...    ${status}
        ${Status}    Run Keyword And Return Status
        ...    Element Should Be Visible
        ...    ${${platformName}_${lang}_Deposit_to_company_Option}
        Set Calc VP With Source And Original Values
        ...    Cash_Payout_Deposit_To_Company_Avalible
        ...    true
        ...    ${status}
        ...    Static
        ...    OMNE_ChangeCashOutPage
        ...    true
        ...    ${status}
        ${Status}    Run Keyword And Return Status
        ...    Element Should Be Visible
        ...    ${${platformName}_${lang}_Premium_settlement_Option}
    #    Set Calc VP With Source And Original Values    Cash_Payout_Option_Premium_Settlement_Avalible    true    ${status}    Static    OMNE_ChangeCashOutPage    true    ${status}
        ${VP_Policy_no}    Get Text    ${${platformName}_${lang}_VP_Policy_No}
        @{VP_Policy_nodetail}    Split String    ${VP_Policy_no}
        ${mVP_Policy_no}    Get From List    ${VP_Policy_nodetail}    0
        Set Calc VP With Source And Original Values
        ...    Cash_Payout_Option_Page_Policy_No
        ...    ${Policy_No}
        ...    ${mVP_Policy_no}
        ...    TestData
        ...    OMNE_ChangeCashOutPage
        ...    ${Policy_No}
        ...    ${mVP_Policy_no}
        ${VP_Prodct_Name}    Get Text    ${${platformName}_${lang}_VP_Product_Name}
        Set Global Variable    ${VP_Prodct_Name_PayCashoutapgr}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   VP For Cash Payout Option Page
    END

Capture ICP Transaction Details for iOS
    TRY
        RefreshPage
        Scroll Till Transaction Is Visible    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of preferred payout' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        Wait Until Page Contains Element
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of preferred payout' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        ...    timeout=50s

        # TransactionStatus
        ${CompleteStatus_List}    Get Text
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of preferred payout' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        @{Transaction_Status_List}    Split String    ${CompleteStatus_List}    Policy no
        Log To Console    Test1
        ${TransactionStatus_list2}    Get From List    ${Transaction_Status_List}    0
        Log To Console    Test2
        @{TransactionStatus_list2}    Split String    ${TransactionStatus_list2}
        Log To Console    Test3
        ${Count}    Get Length    ${TransactionStatus_list2}
        ${Count}    Evaluate    ${Count} - 1
        ${VP_Transaction_Status}    Get From List    ${TransactionStatus_list2}    ${Count}
        Log To Console    Test4
        Log To Console    Transaction_Status=${VP_Transaction_Status}
        Log To Console    ListCount=${Count}
        IF    '${VP_Transaction_Status}' == 'Completed'
            ${m_Vp}    Set Variable    Approve
            ${OPUSTransactionstatus}    Set Variable    Completed
            Set Global Variable    ${OPUSTransactionstatus}
        END
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status
        ...    ${m_Vp}
        ...    ${VP_Transaction_Status}
        ...    OMNE_TransactionPage
        Scroll Till Transaction Is Visible          chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of preferred payout' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        Click Element
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of preferred payout' and label CONTAINS 'Policy no: ${Policy_No}'`][27]

        ${TransactionDeatils}           Get Text    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of preferred payout' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        Log    ${TransactionDeatils}
        Take Screenshot    Transaction_Page
        @{TransactionDeatils}        Split String       ${TransactionDeatils}         New ICP option
        ${TransactionDetialsValue}      Get From List    ${TransactionDeatils}     1
        Log To Console    ${TransactionDetialsValue}
        @{ICPDetailsValue}         Split String      ${TransactionDetialsValue}      Policy applied
        ${ICPDetails}           Get From List    ${ICPDetailsValue}    0
        ${BankTransferstatus}       Run Keyword And Return Status    Should Contain    ${ICPDetails}     Bank transfer
        ${PromptPaystatus}          Run Keyword And Return Status    Should Contain    ${ICPDetails}     PromptPay
        ${Deposittocompanystatus}   Run Keyword And Return Status    Should Contain    ${ICPDetails}     Deposit to company
        IF    '${BankTransferstatus}' == 'True'
            @{TransactionDetialsValue}        Split String      ${ICPDetails}   Payout method Bank account
            ${ICPDetails}          Get From List    ${TransactionDetialsValue}     1
            ${BankNameValue}     Run Keyword And Return Status    Should Contain    ${ICPDetails}    ${Bank_Name}
            ${NewICPOption}         Get From List    ${TransactionDetialsValue}     0
            IF    '${BankNameValue}' == 'True'
                Log    ${Bank_Name}
                @{ICPDetails}      Split String    ${ICPDetails}    ${Bank_Name}
                ${ICPDetails}           Get From List    ${ICPDetails}     0
                Log To Console    ${Bank_Name}
                Set Calc VP Expected Result With Original And Source
                ...    New_Payout_Option
                ...    ${NewICPOption.strip()}
                ...    ${NewICPOption}
                ...    OMNE_TransactionPage
                Set Calc VP Expected Result With Original And Source
                ...    Bank_Name
                ...    ${Bank_Name.strip()}
                ...    ${Bank_Name}
                ...    OMNE_TransactionPage
                @{AccountDeatils}           Split String    ${ICPDetails}     ******
                ${AccountNo}       Get From List    ${AccountDeatils}    1
                Log To Console    ${AccountNo}
                ${AccountName}       Get From List    ${AccountDeatils}    0
                Log To Console    ${AccountName}
                ${mBank_Account_No}    Get Substring    ${Bank_Book_Number}    -4
                Set Calc VP With Source And Original Values
                ...    Transaction_Page_Cashpayout_AccountNo
                ...    ${AccountNo.strip()}
                ...    ${AccountNo.strip()}
                ...    Test_Data
                ...    OMNE_TransactionPage
                ...    ${Bank_Book_Number}
                ...    ${mBank_Account_No.strip()}
                Set Calc VP Expected Result With Original And Source
                ...    Account_No
                ...    ${AccountNo.strip()}
                ...    ${AccountNo.strip()}
                ...    OMNE_TransactionPage
            END
        ELSE IF    '${PromptPaystatus}' == 'True'
            @{NatioanID}         Split String    ${ICPDetails}      National ID :
            ${NewICPOption}     Get From List     ${NatioanID}    0
            Set Calc VP Expected Result With Original And Source
            ...    New_Payout_Option
            ...    ${NewICPOption.strip()}
            ...    ${NewICPOption}
            ...    OMNE_TransactionPage

        ELSE IF    '${Deposittocompanystatus}' == 'True'
            Set Calc VP Expected Result With Original And Source
            ...    New_Payout_Option
            ...    ${ICPDetails.strip()}
            ...    ${ICPDetails}
            ...    OMNE_TransactionPage
        END
        ${PolicyAppled}           Get From List    ${ICPDetailsValue}    1
        Log To Console    ${PolicyAppled}
        @{PolicyAppled}     Split String    ${PolicyAppled}     Policy no:
        ${PolicyAppled}     Get From List    ${PolicyAppled}     0
        Log To Console    ${PolicyAppled}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END

Capture ICP Transaction Details for Android
    TRY

         ${Android_selectCurrentTransaction}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of preferred payout'])[1]

        Scroll Till Transaction Is Visible    ${${platformName}_selectCurrentTransaction}

        ${transactionstatus}    Get Text
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of preferred payout']/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]
        ${transactionstatus}    Convert To Title Case    ${transactionstatus}
        ${policyno}    Get Text
        ...    xpath=//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of preferred payout']/following-sibling::android.widget.TextView[contains(@text,'Policy no:')]
        @{policyno}    Split String    ${policyno}    Policy no:
        ${policyno}    Get From List    ${policyno}    -1

        IF    '${transactionstatus}' == 'Completed'
            ${transactionstatus}    Set Variable    Approve
            ${OPUSTransactionstatus}    Set Variable    Completed
            Set Global Variable    ${OPUSTransactionstatus}
        ELSE
                ${OPUSTransactionstatus}    Set Variable    In progress
                Set Global Variable    ${OPUSTransactionstatus}
        END
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status
        ...    ${OPUSTransactionstatus}
        ...    ${transactionstatus}
        ...    OMNE_TransactionPage
        Click Element    ${${platformName}_selectCurrentTransaction}
        Wait Until Element Is Visible       ${${platformName}_${lang}_New_Payout_Option}
        ${VP_New_Payout_Option}         Get Text                 ${${platformName}_${lang}_New_Payout_Option}
        IF    '${VP_New_Payout_Option}' == 'Bank transfer'
                ${Bank_Name}            Get Text            ${${platformName}_${lang}_ICPBankNameVP}
                ${AccountNo}             Get Text            ${${platformName}_${lang}_ICPAccountNoVP}

                ${mAccountNo}    Get Substring    ${AccountNo}    -4
                ${mBank_Account_No}    Get Substring    ${Bank_Book_Number}    -4
                ${mVP_New_Payout_Option}        Convert To Title Case            ${VP_New_Payout_Option}
                Set Calc VP Expected Result With Original And Source
                ...    New_Payout_Option
                ...    ${mVP_New_Payout_Option.strip()}
                ...    ${VP_New_Payout_Option}
                ...    OMNE_TransactionPage
                Set Calc VP Expected Result With Original And Source
                ...    Bank_Name
                ...    ${Bank_Name.strip()}
                ...    ${Bank_Name}
                ...    OMNE_TransactionPage
                Set Calc VP With Source And Original Values
                ...    Transaction_Page_Cashpayout_AccountNo
                ...    ${mAccountNo.strip()}
                ...    ${AccountNo.strip()}
                ...    Test_Data
                ...    OMNE_TransactionPage
                ...    ${mBank_Account_No.strip()}
                ...    ${Bank_Account_No}

                Set Calc VP Expected Result With Original And Source
                ...    Account_No
                ...    ${AccountNo.strip()}
                ...    ${mAccountNo.strip()}
                ...    OMNE_TransactionPage
        END


    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END