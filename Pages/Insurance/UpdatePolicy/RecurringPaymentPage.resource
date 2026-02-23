*** Settings ***
Library     AppiumLibrary
Library     String
Library     FakerLibrary
Resource    ../../../CustomLibraries/common.robot
Resource    ../../../PageObjects/Insurance/Common/CommonMethodObjects.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/PaymentFrequencyPageObjects.resource
Resource    ../../../Pages/Insurance/Common/CommonMethod.resource
Resource    ../../../Pages/Insurance/Common/AddOTP.resource
Library     ../../Qrace/QraceHelper.py
Resource    ../../../PageObjects/Insurance/UpdatePolicy/PaymentMethodDetailsPageObjects.resource

*** Keywords ***
Credit card recurring payment
    TRY
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_EN_PolicyNotAvailable}
        ...    timeout=10s
        IF    '${status}' == 'True'
            Set Global Variable    ${errormsg}    No Eligible Policy
        END
        #Select Policy
        Select Policy
        Take Screenshot    Cheque Cancellation
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

        Wait Until Element Is Visible    ${${platformName}_SelectPolicyNo}    timeout=20s
        ${VP_RecurringPayment_PolicyDetails}    Get Text    ${${platformName}_SelectPolicyNo}
        IF    '${platformName}' == 'iOS'
            ${VP_PolicyName_Details}    Split String    ${VP_RecurringPayment_PolicyDetails}    :
            ${VP_PolicyName}    Get From List    ${VP_PolicyName_Details}    0
            ${VP_PolicyName}    Remove String    ${VP_PolicyName}    Policy no
            ${VP_PolicyNumber}    Get From List    ${VP_PolicyName_Details}    1
            ${VP_PolicyNumber}    Remove String    ${VP_PolicyNumber}    Premium
            ${VP_PolicyNumber}    Strip String    ${VP_PolicyNumber}
            ${VP_PremiumDetails}    Get From List    ${VP_PolicyName_Details}    2
            ${VP_PremiumDetails}    Remove String    ${VP_PremiumDetails}    Due date
            ${VP_DueDate}    Get From List    ${VP_PolicyName_Details}    3
            ${VP_DueDate}    Remove String    ${VP_DueDate}    Frequency
            ${VP_Frequency}    Get From List    ${VP_PolicyName_Details}    4
            ${VP_Frequency}    Remove String    ${VP_Frequency}    Payment method
            ${VP_PaymentMethod1}    Get From List    ${VP_PolicyName_Details}    5
            ${VP_PaymentMethod1}    Split String    ${VP_PaymentMethod1}
        ELSE
            ${VP_PolicyNumber}    Remove String    ${VP_RecurringPayment_PolicyDetails}    Policy no:
            ${VP_PolicyName}    Get Text
            ...    xpath=(//android.widget.TextView[contains(@text,'${Policy_No}')]/preceding::android.widget.TextView)[3]
            ${VP_Premium}    Get Text
            ...    xpath=(//android.widget.TextView[@text='Policy no: ${Policy_No}']/following::android.widget.TextView)[1]
            ${VP_DueDate}    Get Text
            ...    xpath=(//android.widget.TextView[@text='Policy no: ${Policy_No}']/following::android.widget.TextView)[2]
            ${VP_Frequency}    Get Text
            ...    xpath=(//android.widget.TextView[@text='Policy no: ${Policy_No}']/following::android.widget.TextView)[3]
            ${VP_PaymentMethod}    Get Text
            ...    xpath=(//android.widget.TextView[@text='Policy no: ${Policy_No}']/following::android.widget.TextView)[5]
            ${VP_CreditCardNo}    Get Text
            ...    xpath=(//android.widget.TextView[@text='Policy no: ${Policy_No}']/following::android.widget.TextView)[6]
        END
        # Set Calc VP Expected Result With Original And Source    Recurring_Payment_Policy_Number    ${VP_RecurringPayment_PolicyNUmber}    ${VP_RecurringPayment_PolicyNUmber}    OMNE_Recurring_Payment_Page
        Set Calc VP With Source And Original Values
        ...    Recurring_Payment_Policy_Number
        ...    ${Policy_No}
        ...    ${VP_PolicyNumber.strip()}
        ...    Test_Data
        ...    OMNE_Recurring_Payment_Page
        ...    ${Policy_No}
        ...    ${VP_PolicyNumber}
        Set Calc VP Expected Result With Original And Source
        ...    Recurring_Payment_Policy_Name
        ...    ${VP_PolicyName.strip()}
        ...    ${VP_PolicyName}
        ...    OMNE_Recurring_Payment_Page
        IF    '${Transaction_Page_GUI}' == 'Yes'
            ${Status}    Run Keyword And Return Status
            ...    Element Should Be Enabled
            ...    ${${platformName}_${lang}_NextButton}
            Set Calc VP With Source And Original Values
            ...    Recurring_Payment_Next_Button_Greyed_Out
            ...    false
            ...    ${Status}
            ...    Static
            ...    OMNE_Recurring_Payment_Page
            ...    false
            ...    ${Status}
        END

        Click Element    ${${platformName}_${lang}_NextButton}
        Take Screenshot   Disclaimer Page
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_DisPageNextButton}
        ...    timeout=10s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_DisPageNextButton}
        END
        Wait Until Element Is Visible    ${${platformName}_${lang}_HeaderText}    timeout=30s
        ${VP_RecurringPayment_Note}    Get Text    ${${platformName}_${lang}_RecurringPayment_NoteText}
         ${Static_Text}     Set Variable        Requests to update credit card information or cancel recurring payment must be submitted at least 10 days before the due date.
            Set Calc VP With Source And Original Values
            ...    Recurring_Payment_Note_Text
            ...    ${Static_Text}
            ...    ${VP_RecurringPayment_Note}
            ...    Static
            ...    OMNE_Recurring_Payment_Page
            ...    ${Static_Text}
            ...    ${VP_RecurringPayment_Note}
        Run Keyword    Add Payment Method RCC
        SwipePage
        ${status}    Run Keyword And Return Status
        ...    Wait Until Page Contains Element
        ...    ${${platformName}_${lang}_RecurringPayment_Checkbox}
        ...    timeout=7s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_RecurringPayment_Checkbox}
            Take Screenshot    Payment_method_page
        END
        Click Element    ${${platformName}_${lang}_NextButton}
        IF    '${platformName}' == 'iOS'
            Wait Until Element Is Visible    ${${platformName}_${lang}_SummaryPage_paymentMethod}
            ${SummaryText}    Get Text    ${${platformName}_${lang}_SummaryPage_paymentMethod}
            ${PaymentDetails}    Split String    ${SummaryText}    Payment method
            ${PaymentDetails}    Get From List    ${PaymentDetails}    1
            ${CardDetails}    Split String    ${PaymentDetails}    Cardholder name
            ${PaymentMethod}    Get From List    ${CardDetails}    0
            ${CardDetails1}    Get From List    ${CardDetails}    1
            ${PaymentMethod1}    Split String    ${CardDetails1}    Credit card no.
            ${CreditCardHolderName}    Get From List    ${PaymentMethod1}    0
            ${CardDetails1}    Get From List    ${PaymentMethod1}    1
            ${CardDetails3}    Split String    ${CardDetails1}    Expiry date
            ${CreditCardNo}    Get From List    ${CardDetails3}    0
            ${ExpiryDate}    Get From List    ${CardDetails3}    1
            ${PolicySummaryText}    Get Text    ${${platformName}_${lang}_SummaryPage_PolicyApplied}
        ELSE
            Wait Until Element Is Visible    ${${platformName}_${lang}_SummaryPage_paymentMethod}
            ${PaymentMethod}    Get Text    ${${platformName}_${lang}_SummaryPage_paymentMethod}
            ${CreditCardNo}    Get Text    ${${platformName}_${lang}_SummaryPage_CreditCardNo}
            ${CreditCardHolderName}    Get Text    ${${platformName}_${lang}_SummaryPage_CardHolderName}
            ${ExpiryDate}    Get Text    ${${platformName}_${lang}_SummaryPage_ExpiryDate}
            ${Policyname}    Get Text    ${${platformName}_${lang}_SummaryPage_PolicyName}
            ${Policyno}    Get Text    ${${platformName}_${lang}_SummaryPage_PolicyNo}
        END
        Set Calc VP Expected Result With Original And Source
        ...    Card_Number
        ...    ${CreditCardNo.strip()}
        ...    ${CreditCardNo.strip()}
        ...    View_Summary_Page
        Set Calc VP Expected Result With Original And Source
        ...    Card_ExpiryDate
        ...    ${ExpiryDate.strip()}
        ...    ${ExpiryDate.strip()}
        ...    View_Summary_Page
        Set Calc VP Expected Result With Original And Source
        ...    Card_Holder_Name
        ...    ${CreditCardHolderName.strip()}
        ...    ${CreditCardHolderName.strip()}
        ...    View_Summary_Page
        Take Screenshot    Recurring Payment Overview page
        ${VP_SummaryPage_NewPaymentMethod}    Get Text    ${${platformName}_${lang}_SummaryPage_paymentMethod}
        # Previous OTP from DB
        Get Details from DB
#        ${Previous_OTP}    Set Variable    ${OTPNumber}
#        Set Global Variable    ${Previous_OTP}
        Click Element    ${${platformName}_${lang}_SubmitButton}
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_OTP_email}
        IF    '${status}' == 'True'
            Insert OTP    ${Transaction_OTP_Source}    ${Transaction_OTP_Expiry_Flag}    ${Transaction_OTP_Resend_Flag}
        END
#        Pause Execution
        Take Screenshot    Payment_method_pag
       # New All Done Confirmation Page
        Run Keyword    Transaction Success Page
        Run Keyword    Completion Popup

        Take Screenshot    Transaction_Page
        Run Keyword    Capture RCC Transaction Details for ${platformName}    Pre

        Set Global Variable    ${result}    Recurring Payment Changed Successfully For Policy No : ${Policy_No}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END



Add Payment Method RCC
    TRY
        Take Screenshot    Add_Payment_Method_Page
        Wait Until Page Contains Element    ${${platformName}_${lang}_cardHolderName}       timeout=10s
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
        ${cardHoldername}  Set Variable   Suntec  City
        Input Text    ${${platformName}_${lang}_cardHolderName}    ${cardHoldername}
        Clear Text    ${${platformName}_${lang}_cardHolderName}

        Hide Keyboard    return
        # Check Error 'required field'
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_Required_Error_TXT}
        IF    '${status}' == 'True'
                Take Screenshot    Cardholdername Required
                ${VP_Required_Error_Pass}    Get Text    ${${platformName}_${lang}_Required_Error_TXT}
                Set Global Variable    ${errormsg}    ${VP_Required_Error_Pass}
                Set Calc VP With Source And Original Values
                ...    Card_Holder_Name_Required_Error_Msg
                ...    Required
                ...    ${VP_Required_Error_Pass}
                ...    Static
                ...    OMNE_Application
                ...    Required
                ...    ${VP_Required_Error_Pass}
        END
    #           Validation 'No single char input is allowed'
        ${singleCharcardHoldername}  Set Variable   S
        Input Text    ${${platformName}_${lang}_cardHolderName}    ${singleCharcardHoldername}
        Hide Keyboard    return
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_No_SingleCharAllow_Error_TXT}
        IF    '${status}' == 'True'
            Take Screenshot    No single Char allowed
            ${VP_NoSingleChar_Error_Pass}    Get Text    ${${platformName}_${lang}_No_SingleCharAllow_Error_TXT}
            Set Global Variable    ${errormsg}    ${VP_NoSingleChar_Error_Pass}
            Set Calc VP With Source And Original Values
            ...    No_Single_Char_Allow_Error_Msg
            ...    No single character input allowed
            ...    ${VP_NoSingleChar_Error_Pass}
            ...    Static
            ...    OMNE_Application
            ...    No single character input allowed
            ...    ${VP_NoSingleChar_Error_Pass}
        END
        Clear Text    ${${platformName}_${lang}_cardHolderName}
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
        ...    Card_Number
        ...    ${MCreditCardNumber}
        ...    ${CreditCardNumber}
        ...    OMNE_AddPaymentMethodPage
    #    ExpireDate
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

    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   RCC Add Payment Method
    END
Capture RCC Transaction Details for iOS
    [Arguments]    ${Transaction_Info}
    TRY
        Wait Until Page Contains Element    ${${platformName}_${lang}_ServiceReuest}    timeout=120s
        Click Element    ${${platformName}_${lang}_ServiceReuest}
        SwipePage
        Take Screenshot    Transaction_Page
        IF    '${Transaction_Info}'== 'Pre'

            ${iOS_selectCurrentTransaction1}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Credit card recurring payment' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        ELSE IF    '${Transaction_Info}'== 'Post'
            ${iOS_selectCurrentTransaction1}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Credit card recurring payment ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
            ${iOS_transactionstatusobject}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Credit card recurring payment ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][26]/XCUIElementTypeOther/XCUIElementTypeOther
        END
        Scroll Till Transaction Is Visible    ${${platformName}_selectCurrentTransaction1}
#        Wait Until Element Is Visible      timeout=300s
        Take Screenshot    Transaction Page
        ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction1}
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Policy no
        ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Credit card recurring payment
        ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
        ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
        ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
        IF    '${mTransactionstatus}' == 'Completed'
            ${mTransactionstatus}    Set Variable    Approve
            ${OPUSTransactionstatus}    Set Variable    Completed
            Set Global Variable    ${OPUSTransactionstatus}
        END
        IF    '${mTransactionstatus}' == 'In Progress'
            ${mTransactionstatus}    Set Variable    In Progress
            Set Global Variable    ${mTransactionstatus}
            ${OPUSTransactionstatus}    Set Variable    In progress
            Set Global Variable    ${OPUSTransactionstatus}
            Log     ${OPUSTransactionstatus}
        END
        Take Screenshot    Transaction Page
        Click Element    ${${platformName}_selectCurrentTransaction1}

        Take Screenshot    Transaction Page
        # PolicyName
        ${TransactionDetails}    Get Text    ${${platformName}_selectCurrentTransaction1}
        ${Transaction}    Set Variable    ${TransactionDetails}
        @{TransactionDetailsList}    Split String    ${Transaction}    New payment method
        ${Transaction_Policy_name}    Get From List    ${TransactionDetailsList}    1
        @{TransactionDetailsList}    Split String    ${Transaction_Policy_name}    Policy applied
        ${GetNewList}    Get From List    ${TransactionDetailsList}    0
        ${NewList}    Set Variable    ${GetNewList}
        Log To Console    NewList=${GetNewList}
        @{NewData}    Split String    ${NewList}    Cardholder name
        ${PaymentMethod}    Get From List    ${NewData}    0
        ${NewData1}    Get From List    ${NewData}    1
        ${AccountNumber}    Split String    ${NewData1}    Credit card no.
        ${HolderName}    Get From List    ${AccountNumber}    0
        ${CreditCardNoDetails}    Get From List    ${AccountNumber}    1
        ${ExpiryDate1}    Split String    ${CreditCardNoDetails}    Expiry date
        ${CreditCardNo}    Get From List    ${ExpiryDate1}    0
        ${InputCardNumber}    Get Substring    ${CreditCardNo}    -5
        # ExpiryDate
        ${ExpiryDate}    Get From List    ${ExpiryDate1}    1
        ${ExpiryDate2}    Split String    ${ExpiryDate}    /
        ${VP_ExpiryMonth}    Get From List    ${ExpiryDate2}    0
        ${VP_ExpiryYear}    Get From List    ${ExpiryDate2}    1
        ${PolicyDetailsList}    Get From List    ${TransactionDetailsList}    1
        ${PolicyDetails}    Split String    ${PolicyDetailsList}    Policy no:
        ${PolicyName}    Get From List    ${PolicyDetails}    0
        ${PolicyNo}    Get From List    ${PolicyDetails}    1
        ${Status}    Run Keyword And Return Status    Should Contain    ${PolicyDetailsList}    Completion date
        IF    '${Status}' == 'True'
            @{VP_CompletionDateList}    Split String    ${PolicyDetailsList}    Completion date
            ${VP_CompletionDate1}    Get From List    ${VP_CompletionDateList}    1
            @{VP_CompletionDateList1}    Split String    ${VP_CompletionDate1}    We
            ${VP_CompletionDate}    Get From List    ${VP_CompletionDateList1}    0
        END
        IF    '${CoreSystem_Flag}' == 'Yes'
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_Credit_Card_ExpiryDate_Month
            ...    ${VP_ExpiryMonth.strip()}
            ...    ${VP_ExpiryMonth}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_Credit_Card_ExpiryDate_Year
            ...    ${VP_ExpiryYear.strip()}
            ...    ${VP_ExpiryYear}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_Credit_Card_Number
            ...    ${InputCardNumber.strip()}
            ...    ${CreditCardNo}
            ...    OMNE_TransactionPage
        END
        IF    '${Transaction_Info}' == 'Pre'
            Set Calc VP Actual Result With Original And Source
            ...    Recurring_Payment_Policy_Name
            ...    ${PolicyName.strip()}
            ...    ${PolicyName.strip()}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Transaction_Status
            ...    ${mTransactionstatus.strip()}
            ...    ${mTransactionstatus.strip()}
            ...    OMNE_Application
            Set Calc VP Expected Result With Original And Source
            ...    Card_Number
            ...    ${InputCardNumber.strip()}
            ...    ${CreditCardNo.strip()}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Card_ExpiryDate_Month
            ...    ${VP_ExpiryMonth.strip()}
            ...    ${VP_ExpiryMonth.strip()}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Card_ExpiryDate_Year
            ...    ${VP_ExpiryYear.strip()}
            ...    ${VP_ExpiryYear.strip()}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Card_Holder_Name
            ...    ${HolderName.strip()}
            ...    ${HolderName}
            ...    OMNE_TransactionPage
            Set Calc VP With Source And Original Values
            ...    Card_ExpiryDate
            ...    ${ExpiryDate.strip()}
            ...    ${ExpiryDate.strip()}
            ...    Test_Data
            ...    OMNE_TransactionPage
            ...    ${ExpiryDate.strip()}
            ...    ${ExpiryDate.strip()}
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture RCC Transaction Details for iOS
    END
Capture RCC Transaction Details for Android
    [Arguments]    ${Transaction_Info}
    Sleep    10s

    ${Android_selectCurrentTransaction}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Credit card recurring payment'])[1]

    Scroll Till Transaction Is Visible    ${${platformName}_selectCurrentTransaction}
    SwipePage
    ${transactionstatus}    Get Text
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Credit card recurring payment']/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]
    ${transactionstatus}    Convert To Title Case    ${transactionstatus}
    ${policyno}    Get Text
    ...    xpath=//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Credit card recurring payment']/following-sibling::android.widget.TextView[contains(@text,'Policy no:')]
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
    Click Element    ${${platformName}_selectCurrentTransaction}
    Sleep    10s
    Wait Until Page Contains Element    ${${platformName}_${lang}_Transaction_PaymentMethod}    timeout=20s
    ${VP_PaymentMethod}    Get Text    ${${platformName}_${lang}_Transaction_PaymentMethod}
    ${VP_PolicyName}    Get Text    ${${platformName}_${lang}_Transaction_PolicyName}
    ${VP_Card_HolderName}    Get Text    ${${platformName}_${lang}_Transaction_CardHolderName}
    ${VP_Card_Number}    Get Text    ${${platformName}_${lang}_Transaction_CreditCardNo}
    ${mVP_Card_Number}    Get Substring    ${VP_Card_Number}    -5
    ${VP_Card_ExpiryDate}    Get Text    ${${platformName}_${lang}_Transaction_ExpiryDate}
    ${M_Card_ExpiryDate}    Split String    ${VP_Card_ExpiryDate}    /
    ${M_Card_ExpiryDateMM}    Get From List    ${M_Card_ExpiryDate}    0
    ${M_Card_ExpiryDateYY}    Get From List    ${M_Card_ExpiryDate}    1
    ${VP_Card_ExpiryDate}    Strip String    ${VP_Card_ExpiryDate}
#    ${mVPQrace_Card_Mumber}    Get Substring    ${Credit_Card_Number}    -4
    ${Status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_Transaction_CompletionDate}
    ...    timeout=2s
    IF    '${Status}' == 'True'
        ${VP_Completion_Date}    Get Text    ${${platformName}_${lang}_Transaction_CompletionDate}
        Set Calc VP Expected Result With Original And Source
        ...    Completion_Date
        ...    ${VP_Completion_Date.strip()}
        ...    ${VP_Completion_Date}
        ...    OMNE_TransactionPage
    END
    IF    '${CoreSystem_Flag}' == 'Yes'
        Set Calc VP Expected Result With Original And Source
        ...    ${Core_System}_Credit_Card_ExpiryDate_Month
        ...    ${M_Card_ExpiryDateMM.strip()}
        ...    ${M_Card_ExpiryDateMM}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    ${Core_System}_Credit_Card_ExpiryDate_Year
        ...    ${M_Card_ExpiryDateYY.strip()}
        ...    ${M_Card_ExpiryDateYY}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    ${Core_System}_Credit_Card_Number
        ...    ${mVP_Card_Number.strip()}
        ...    ${VP_Card_Number}
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
        ...    ${VP_Transaction_Status.strip()}
        ...    ${VP_Transaction_Status.strip()}
        ...    OMNE_Application
        Set Calc VP Expected Result With Original And Source
        ...    Card_Number
        ...    ${mVP_Card_Number.strip()}
        ...    ${VP_Card_Number}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    Card_ExpiryDate_Month
        ...    ${M_Card_ExpiryDateMM.strip()}
        ...    ${M_Card_ExpiryDateMM}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    Card_ExpiryDate_Year
        ...    ${M_Card_ExpiryDateYY.strip()}
        ...    ${M_Card_ExpiryDateYY}
        ...    OMNE_TransactionPage
        Set Calc VP With Source And Original Values
        ...    Card_ExpiryDate
        ...    ${VP_Card_ExpiryDate.strip()}
        ...    ${VP_Card_ExpiryDate.strip()}
        ...    Test_Data
        ...    OMNE_TransactionPage
        ...    ${VP_Card_ExpiryDate.strip()}
        ...    ${VP_Card_ExpiryDate.strip()}
    ELSE
        Set Calc VP Expected Result With Original And Source
        ...    Post_Card_Number
        ...    ${mVP_Card_Number.strip()}
        ...    ${VP_Card_Number}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    Post_Card_ExpiryDate_Month
        ...    ${M_Card_ExpiryDateMM.strip()}
        ...    ${M_Card_ExpiryDateMM}
        ...    OMNE_TransactionPage
        Set Calc VP Expected Result With Original And Source
        ...    Post_Card_ExpiryDate_Year
        ...    ${M_Card_ExpiryDateYY.strip()}
        ...    ${M_Card_ExpiryDateYY}
        ...    OMNE_TransactionPage
    END
