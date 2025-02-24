*** Settings ***
Library     AppiumLibrary
Library     String
Library     FakerLibrary
Resource    ../../../CustomLibraries/common.robot
Resource    ../../../PageObjects/Insurance/Common/CommonMethodObjects.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/PaymentMethodDetailsPageObjects.resource
Resource    ../../../Pages/Insurance/Common/CommonMethod.resource
Resource    ../../../Pages/Insurance/Common/AddOTP.resource
Library     ../../Qrace/QraceHelper.py


*** Variables ***
${m_Vp}     ${EMPTY}


*** Keywords ***
Payment method
    TRY
        Select Policy
        # ---------------------------------------------------Header Text VP----------------------------------
        IF    '${Transaction_Page_GUI}' == 'Yes'
            ${DisclaimerContent}    Set Variable
            ...    1. Change to payment methods should be made 5 business days before the payment cycle is due. Any changes made within 5 business days before the current payment cycle will not take effect until the next payment cycle. 2. If your card or existing account cannot be debited, you can change your payment method within 30 days of the premium payment's due date.
            ${VP_RecurringPayment_HeaderText}    Get Text    ${${platformName}_${lang}_RecurringPayment_HeaderText}
            Set Calc VP With Source And Original Values
            ...    Recurring_Payment_HeaderText
            ...    Recurring payment
            ...    ${VP_RecurringPayment_HeaderText}
            ...    Static
            ...    OMNE_Recurring_Payment_Page
            ...    Recurring payment
            ...    ${VP_RecurringPayment_HeaderText}
            ${VP_RecurringPayment_SubHeaderText}    Get Text    ${${platformName}_${lang}_RecurringPayment_SubHeaderText}
            Set Calc VP With Source And Original Values
            ...    Recurring_Payment_Sub_HeaderText
            ...    Your recurring payment method
            ...    ${VP_RecurringPayment_SubHeaderText}
            ...    Static
            ...    OMNE_Recurring_Payment_Page
            ...    Your recurring payment method
            ...    ${VP_RecurringPayment_SubHeaderText}
            ${VP_RecurringPayment_DisclaimerText}    Get Text    ${${platformName}_${lang}_RecurringPayment_DisclaimerText}
            Set Calc VP With Source And Original Values
            ...    Recurring_Payment_DisclaimerText
            ...    Disclaimer
            ...    ${VP_RecurringPayment_DisclaimerText}
            ...    Static
            ...    OMNE_Recurring_Payment_Page
            ...    Disclaimer
            ...    ${VP_RecurringPayment_DisclaimerText}
            ${VP_RecurringPayment_DisclaimerContent}    Get Text
            ...    ${${platformName}_${lang}_RecurringPayment_DisclaimerContent}
            #    Set Calc VP With Source And Original Values    Recurring_Payment_DisclaimerContent    ${DisclaimerContent.strip()}    ${VP_RecurringPayment_DisclaimerContent.strip()}    Static    OMNE_Recurring_Payment_Page    ${DisclaimerContent.strip()}    ${VP_RecurringPayment_DisclaimerContent.strip()}
        END
        Wait Until Element Is Visible    ${${platformName}_${lang}_RecurringPayment_PolicyNUmber}    timeout=20s
        ${VP_RecurringPayment_PolicyNUmber}    Get Text    ${${platformName}_${lang}_RecurringPayment_PolicyNUmber}
        # Set Calc VP Expected Result With Original And Source    Recurring_Payment_Policy_Number    ${VP_RecurringPayment_PolicyNUmber}    ${VP_RecurringPayment_PolicyNUmber}    OMNE_Recurring_Payment_Page
        Set Calc VP With Source And Original Values
        ...    Recurring_Payment_Policy_Number
        ...    ${Policy_No}
        ...    ${VP_RecurringPayment_PolicyNUmber}
        ...    Test_Data
        ...    OMNE_Recurring_Payment_Page
        ...    ${Policy_No}
        ...    ${VP_RecurringPayment_PolicyNUmber}
        ${VP_RecurringPayment_PolicyName}    Get Text    ${${platformName}_${lang}_RecurringPayment_PolicyName}
        Set Calc VP Expected Result With Original And Source
        ...    Recurring_Payment_Policy_Name
        ...    ${VP_RecurringPayment_PolicyName.strip()}
        ...    ${VP_RecurringPayment_PolicyName}
        ...    OMNE_Recurring_Payment_Page
        IF    '${Transaction_Page_GUI}' == 'Yes'
            ${Status}    Run Keyword And Return Status    Element Should Be Enabled    ${${platformName}_${lang}_SubmitBtn}
            Set Calc VP With Source And Original Values
            ...    Recurring_Payment_Submit_Button_Greyed_Out
            ...    false
            ...    ${Status}
            ...    Static
            ...    OMNE_Recurring_Payment_Page
            ...    false
            ...    ${Status}
        END
        ${sOutput}    Run Keyword And Ignore Error    Add Payment Method RCC
        IF    ${sOutput} != ('PASS', None)
            Take Screenshot    Update Policy
            ${failure_reason}    Fetch Reason    ${sOutput}
            RETURN    ${failure_reason}
        END
        SwipePage
        ${status}    Run Keyword And Return Status
        ...    Wait Until Page Contains Element
        ...    ${${platformName}_${lang}_RecurringPayment_Checkbox}
        ...    timeout=7s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_RecurringPayment_Checkbox}
            Take Screenshot    Payment_method_page
        END

        # CheckBox and Fatatc Status
        ${status}    Run Keyword And Return Status
        ...    Wait Until Page Contains Element
        ...    chain=**/XCUIElementTypeOther[`label == '${Fatca_Status}'`]
        ...    timeout=2s
        IF    '${status}' == 'True'
            Click Element    chain=**/XCUIElementTypeOther[`label == '${Fatca_Status}'`]
        END
        Take Screenshot    Payment_method_page

        # Previous OTP from DB
        Get Details from DB
        ${Previous_OTP}    Set Variable    ${OTPNumber}
        Set Global Variable    ${Previous_OTP}
        Click Element    ${${platformName}_${lang}_SubmitButton}
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_OTP_email}
        IF    '${status}' == 'True'
            Insert OTP    ${Transaction_OTP_Source}    ${Transaction_OTP_Expiry_Flag}    ${Transaction_OTP_Resend_Flag}
        END
        Run Keyword    Completion Popup
        Take Screenshot    Payment_method_page
        Run Keyword    Capture Payment Method Transaction Details for ${platformName}    Pre

        Set Global Variable    ${result}    Recurring Payment Changed Successfully For Policy No : ${Policy_No}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END
Add Payment Method RCC
    TRY
        Take Screenshot    Add_Payment_Method_Page
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_RecurringPayment_EditButton}
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_RecurringPayment_EditButton}
        ELSE
            Click Element    ${${platformName}_${lang}_Add_payment_method}
        END
        Wait Until Page Contains Element    ${${platformName}_${lang}_cardHolderName}
        IF    '${Transaction_Page_GUI}' == 'Yes'
            ${Status}    Run Keyword And Return Status    Element Should Be Enabled    ${${platformName}_${lang}_saveBtn}
            Set Calc VP With Source And Original Values
            ...    Recurring_Payment(AddPaymentMethod)_Save_Button_Greyed_Out
            ...    false
            ...    ${Status}
            ...    Static
            ...    OMNE_Recurring_Payment_Page
            ...    false
            ...    ${Status}
        END
        # HolderName
        ${CardHolderName}    FakerLibrary.First Name
        Input Text    ${${platformName}_${lang}_cardHolderName}    ${CardHolderName}
        Hide Keyboard    return
        # CardNumber
        ${Wrong_Credit_Card_Number}    Set Variable    88667676677
        Input Text    ${${platformName}_${lang}_cardNumber}    ${Wrong_Credit_Card_Number}\n
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_RecurringPayment_CardNumber_Below_16digit_ErrorMsg}
        ...    timeout=5s
        IF    '${status}' == 'True'
            ${msg}    Get Text    ${${platformName}_${lang}_RecurringPayment_CardNumber_Below_16digit_ErrorMsg}
            ${errormsg}    Set Variable    ${msg}
            Set Calc VP With Source And Original Values
            ...    Wrong_CreditCard_ErrorMsg
            ...    ${errormsg}
            ...    ${errormsg}
            ...    Static
            ...    OMNE_AddPaymentMethodPage
            ...    ${errormsg}
            ...    ${errormsg}
        END
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_RecurringPayment_CardNumber_Invalid_ErrorMsg}
        ...    timeout=5s
        IF    '${status}' == 'True'
            ${msg}    Get Text    ${${platformName}_${lang}_RecurringPayment_CardNumber_Invalid_ErrorMsg}
            ${errormsg}    Set Variable    ${msg}
            Set Calc VP With Source And Original Values
            ...    Invalid_CreditCard_ErrorMsg
            ...    ${errormsg}
            ...    ${errormsg}
            ...    Static
            ...    OMNE_AddPaymentMethodPage
            ...    ${errormsg}
            ...    ${errormsg}
        END
        Clear Text    ${${platformName}_${lang}_cardNumber}

        Input Text    ${${platformName}_${lang}_cardNumber}    ${Credit_Card_Number}\n
        ${MCreditCardNumber}    Get Substring    ${Credit_Card_Number}    -4
        Set Calc VP Expected Result With Original And Source
        ...    TrasactionPage_Credit_CardNumber
        ...    ${MCreditCardNumber}
        ...    ${CreditCardNumber}
        ...    OMNE_AddPaymentMethodPage
        ExpireDate
        Input Text    ${${platformName}_${lang}_cardExpiryDate}    ${ExpiryYear}\n
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_RecurringPayment_ExpiryDate_ErrorMsg}
        ...    timeout=5s
        IF    '${status}' == 'True'
            ${msg}    Get Text    ${${platformName}_${lang}_RecurringPayment_ExpiryDate_ErrorMsg}
            ${errormsg}    Set Variable    ${msg}
            Set Calc VP With Source And Original Values
            ...    ErrorMsg
            ...    ${errormsg}
            ...    ${errormsg}
            ...    Static
            ...    OMNE_AddPaymentMethodPage
            ...    ${errormsg}
            ...    ${errormsg}
        END
        Clear Text    ${${platformName}_${lang}_cardExpiryDate}
        Input Text    ${${platformName}_${lang}_cardExpiryDate}    ${ExpiryMonth}${ExpiryYear}\n
        # click on submit button
        Take Screenshot    Add_Payment_Method_Page
        Click Element    ${${platformName}_${lang}_SaveButton}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Add payment method
    END
Capture Payment Method Transaction Details for iOS
    [Arguments]    ${Transaction_Info}
    TRY
        Take Screenshot    Transaction Page
    #    ${currentdate}    Get Current Date
    #    ${currdate}    Convert Date    ${currentdate}    result_format=%b %d %Y
        Wait Until Element Is Visible    ${${platformName}_${lang}_ViewTransaction}    timeout=20s
        Click Element    ${${platformName}_${lang}_ViewTransaction}
        Take Screenshot    Transaction Page
    #    ${Android_selectCurrentTransaction}    Set Variable    xpath
        IF    '${Transaction_Info}'== 'Pre'

            RefreshPage
            ${iOS_selectCurrentTransaction1}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change payment method Completed' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        ELSE IF    '${Transaction_Info}'== 'Post'
            ${iOS_selectCurrentTransaction1}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change payment method ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
            ${iOS_transactionstatusobject}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change payment method ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][26]/XCUIElementTypeOther/XCUIElementTypeOther
        END
        Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction1}    timeout=300s
        Take Screenshot    Transaction Page
        ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction1}
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Policy no
        ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Change payment method
        ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
        ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
        ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
        IF    '${mTransactionstatus}' == 'Completed'
            ${mTransactionstatus}    Set Variable    Approve
        END
        Take Screenshot    Transaction Page
        Click Element    ${${platformName}_selectCurrentTransaction1}

        Take Screenshot    Transaction Page
        # PolicyName
        ${TransactionDetails}    Get Text    ${${platformName}_selectCurrentTransaction1}
        ${Tranaction}    Set Variable    ${TransactionDetails}
        @{TransactionDetailsList}    Split String    ${Tranaction}    Policy applied
        ${Transaction_Policy_name}    Get From List    ${TransactionDetailsList}    1
        @{TransactionDetailsList}    Split String    ${Transaction_Policy_name}    Premium payment method
        ${GetNewList}    Get From List    ${TransactionDetailsList}    1
        ${NewList}    Set Variable    ${GetNewList}
        Log To Console    NewList=${GetNewList}
        @{NewData}    Split String    ${NewList}
        ${Name}    Get From List    ${NewData}    5
        ${HolderName}    Get From List    ${NewData}    0
        Log To Console    HolderName:-${HolderName}
        Log To Console    CardType:-${Name}
        ${VP_Transsaction_Policy_name}    Get From List    ${TransactionDetailsList}    0
        Log To Console    PolicyName=${VP_Transsaction_Policy_name}
        #    Set Calc VP Expected Result With Original And Source    RecurringPayment_PolicyName    ${VP_Transsaction_Policy_name}    ${VP_Transsaction_Policy_name}    OMNE_TransactionPage
        # Account No
        ${AccountNoList}    Get From List    ${TransactionDetailsList}    1
        ${AccountNoList}    Replace String    ${AccountNoList}    ${HolderName}    ${SPACE}
        Log To Console    ${AccountNoList}
        ${AccountNumber}    Split String    ${AccountNoList}    VISA
        ${VP_Transsaction_AccountNumber}    Get From List    ${AccountNumber}    0
        ${M_VP_Transsaction_AccountNumber}    Get Substring    ${VP_Transsaction_AccountNumber}    -5
        Log To Console    Account_No=${M_VP_Transsaction_AccountNumber}
        ${InputCardNumber}    Get Substring    ${Credit_Card_Number}    -4
        # ExpiryDate
        ${ExpiryDate1}    Get From List    ${AccountNumber}    1
        @{ExpiryDateList}    Split String    ${ExpiryDate1}    :
        ${ExpiryDateList2}    Get From List    ${ExpiryDateList}    1
        @{VP_ExpiryDateList}    Split String    ${ExpiryDateList2}    Completion date
        ${VP_ExpiryDate}    Get From List    ${VP_ExpiryDateList}    0
        Log To Console    ExpiryDate=${VP_ExpiryDate}
        @{VP_ExpiryMonth}    Split String    ${VP_ExpiryDate}    /
        ${mVP_ExpiryMonth}    Get From List    ${VP_ExpiryMonth}    0
        Log To Console    ExpiryDateMonth=${mVP_ExpiryMonth}
        ${mVP_ExpiryYear}    Get From List    ${VP_ExpiryMonth}    1
        Log To Console    ExpiryDateYear=${mVP_ExpiryYear}
        # CompletionDate
    #    ${VPcurrentdate}    Get Current Date
        ${VP_CompletonDate}    Get From List    ${VP_ExpiryDateList}    1
        Log To Console    CompletionDate=${VP_CompletonDate}

        ${CardExpiryDate}    Set Variable    ${ExpiryMonth}/${ExpiryYear}

        IF    '${CoreSystem_Flag}' == 'Yes'
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_Credit_Card_ExpirDate_Month
            ...    ${mVP_ExpiryMonth.strip()}
            ...    ${mVP_ExpiryMonth}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_Credit_Card_ExpirDate_Year
            ...    ${mVP_ExpiryYear.strip()}
            ...    ${mVP_ExpiryYear}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_Credit_Card_Number
            ...    ${InputCardNumber.strip()}
            ...    ${VP_Transsaction_AccountNumber}
            ...    OMNE_TransactionPage
        END
        IF    '${Transaction_Info}' == 'Pre'
            Set Calc VP Actual Result With Original And Source
            ...    Recurring_Payment_Policy_Name
            ...    ${VP_Transsaction_Policy_name.strip()}
            ...    ${VP_Transsaction_Policy_name}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Transaction_Status
            ...    ${mTransactionstatus.strip()}
            ...    ${mTransactionstatus.strip()}
            ...    OMNE_Application
            Set Calc VP Expected Result With Original And Source
            ...    Completion_Date
            ...    ${VP_CompletonDate.strip()}
            ...    ${VP_CompletonDate}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Card_Number
            ...    ${M_VP_Transsaction_AccountNumber.strip()}
            ...    ${VP_Transsaction_AccountNumber}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Card_ExpirDate_Month
            ...    ${mVP_ExpiryMonth.strip()}
            ...    ${mVP_ExpiryMonth}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Card_ExpiryDate_Year
            ...    ${mVP_ExpiryYear.strip()}
            ...    ${mVP_ExpiryYear}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Card_Holder_Name
            ...    ${HolderName.strip()}
            ...    ${HolderName}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source    Card_Type    ${Name}    ${Name}    OMNE_TransactionPage
            Set Calc VP With Source And Original Values
            ...    Transaction_Page_Card_ExpiryDate
            ...    ${CardExpiryDate.strip()}
            ...    ${VP_ExpiryDate.strip()}
            ...    Test_Data
            ...    OMNE_TransactionPage
            ...    ${CardExpiryDate}
            ...    ${VP_ExpiryDate}
            Set Calc VP With Source And Original Values
            ...    Transaction_Page_Card_Number
            ...    ${InputCardNumber.strip()}
            ...    ${M_VP_Transsaction_AccountNumber.strip()}
            ...    Test_Data
            ...    OMNE_TransactionPage
            ...    ${Credit_Card_Number}
            ...    ${VP_Transsaction_AccountNumber}
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Payment Method Transaction Details for iOS
    END

Capture Payment Method Transaction Details for Android
    [Arguments]    ${Transaction_Info}
    Take Screenshot    Transaction Page
    Wait Until Element Is Visible    ${${platformName}_${lang}_ViewTransaction}    timeout=20s
    Click Element    ${${platformName}_${lang}_ViewTransaction}
    Take Screenshot    Transaction Page
#    ${Android_selectCurrentTransaction}    Set Variable    xpath
    IF    '${Transaction_Info}'== 'Pre'

        RefreshPage
        ${Android_selectCurrentTransaction1}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Recurring payment'])[1]
    ELSE IF    '${Transaction_Info}'== 'Post'
        ${Android_selectCurrentTransaction1}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Recurring payment'])[1]
    END
    Wait Until Page Contains Element    ${Android_selectCurrentTransaction1}    timeout=50s
    Click Element    ${Android_selectCurrentTransaction1}

    Wait Until Page Contains Element    ${${platformName}_${lang}_Transaction_RCC_PolicyName}    timeout=20s
    ${VP_PolicyName}    Get Text    ${${platformName}_${lang}_Transaction_RCC_PolicyName}
    ${VP_Completion_Date}    Get Text    ${${platformName}_${lang}_Transaction_ComplettionDate}
    ${VP_Card_HolderName}    Get Text    ${${platformName}_${lang}_Transaction_RCC_CardHolderName}
    ${VP_Card_Mumber}    Get Text    ${${platformName}_${lang}_Transaction_RCC_CardNumber}
    ${mVP_Card_Mumber}    Get Substring    ${VP_Card_Mumber}    -4
    ${VP_Card_Type}    Get Text    ${${platformName}_${lang}_Transaction_RCC_cardTyppe}
    ${VP_Card_ExpiryDate}    Get Text    ${${platformName}_${lang}_Transaction_RCC_CardExpiryDate}
    @{VP_Card_ExpiryDate}    Split String    ${VP_Card_ExpiryDate}    :
    ${M_VP_Card_ExpiryDate}    Get From List    ${VP_Card_ExpiryDate}    1
    @{M_Card_ExpiryDate}    Split String    ${M_VP_Card_ExpiryDate}    /
    ${M_Card_ExpiryDateMM}    Get From List    ${M_Card_ExpiryDate}    0
    ${M_Card_ExpiryDateYY}    Get From List    ${M_Card_ExpiryDate}    1
    ${M_VP_Card_ExpiryDate}    Strip String    ${M_VP_Card_ExpiryDate}
    ${mVPQrace_Card_Mumber}    Get Substring    ${Credit_Card_Number}    -4
    ${VP_Transaction_Status}    Get Text    ${${platformName}_${lang}_Transaction_RCC_Status}
    IF    '${VP_Transaction_Status}' == 'Completed'
        ${m_Transaction_Status}    Set Variable    Approve
        Set Global Variable    ${m_Transaction_Status}
    END
    IF    '${CoreSystem_Flag}' == 'Yes'
        Set Calc VP Expected Result With Original And Source
        ...    ${Core_System}_Credit_Card_Type
        ...    ${VP_Card_Type}
        ...    ${VP_Card_Type}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    ${Core_System}_Credit_Card_ExpirDate_Month
        ...    ${M_Card_ExpiryDateMM.strip()}
        ...    ${M_Card_ExpiryDateMM}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    ${Core_System}_Credit_Card_ExpirDate_Year
        ...    ${M_Card_ExpiryDateYY.strip()}
        ...    ${M_Card_ExpiryDateYY}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    ${Core_System}_Credit_Card_Number
        ...    ${mVP_Card_Mumber.strip()}
        ...    ${VP_Card_Mumber}
        ...    OMNE_TransactionPage
    END
    IF    '${Transaction_Info}' == 'Pre'
        Set Calc VP Actual Result With Original And Source
        ...    Recurring_Payment_Policy_Name
        ...    ${VP_PolicyName.strip()}
        ...    ${VP_PolicyName}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status
        ...    ${mTransactionstatus.strip()}
        ...    ${mTransactionstatus.strip()}
        ...    OMNE_Application
        Set Calc VP Expected Result With Original And Source
        ...    Completion_Date
        ...    ${VP_Completion_Date.strip()}
        ...    ${VP_Completion_Date}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    Card_Number
        ...    ${mVP_Card_Mumber.strip()}
        ...    ${VP_Card_Mumber}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    Card_ExpirDate_Month
        ...    ${M_Card_ExpiryDateMM.strip()}
        ...    ${M_Card_ExpiryDateMM}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    Card_ExpiryDate_Year
        ...    ${M_Card_ExpiryDateYY.strip()}
        ...    ${M_Card_ExpiryDateYY}
        ...    OMNE_TransactionPage
        Set Calc VP With Source And Original Values
        ...    Transaction_Page_Card_ExpiryDate
        ...    ${CardExpiryDate.strip()}
        ...    ${M_VP_Card_ExpiryDate.strip()}
        ...    Test_Data
        ...    OMNE_TransactionPage
        ...    ${CardExpiryDate}
        ...    ${VP_Card_ExpiryDate}
        Set Calc VP With Source And Original Values
        ...    Transaction_Page_Card_Number
        ...    ${mVPQrace_Card_Mumber.strip()}
        ...    ${mVP_Card_Mumber.strip()}
        ...    Test_Data
        ...    OMNE_TransactionPage
        ...    ${Credit_Card_Number}
        ...    ${VP_Card_Mumber}
    END
