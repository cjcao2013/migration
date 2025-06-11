*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     DateTime
Resource    ../../../PageObjects/Insurance/UpdatePolicy/ChequeCancellationPageObject.resource
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource
Resource    ../../../PageObjects/Insurance/Common/CommonObjects.resource

*** Keywords ***
Cheque cancellation
    TRY
        #Select Policy
        Select Policy
        Take Screenshot    Cheque Cancellation
        Click Element    ${${platformName}_${lang}_NextButton}
        #Wait for  Page loading  for 2s
        Wait Until Element Is Visible    ${${platformName}_${lang}_Title}        timeout=10s
        #Select Cheque Type
        Click Element    ${${platformName}_${lang}_Type_Of_Cheque}
        ${iOS_EN_Cheque_Type}    Set Variable      chain=**/XCUIElementTypeOther[`name == "${Type_Of_Cheque}"`][2]
        ${Android_EN_Cheque_Type}    Set Variable      xpath=//android.widget.TextView[@text="${Type_Of_Cheque}"]
        Take Screenshot    Type of cheque cancellation
        Wait Until Element Is Visible    ${${platformName}_${lang}_Type_Of_Cheque_Title}     timeout=2s
        Click Element    ${${platformName}_${lang}_Cheque_Type}
        Click Element    ${${platformName}_${lang}_Done_Button}
        #Select Cheque Reason for Cancelation
        Click Element    ${${platformName}_${lang}_ReasonForCancellation}
        Take Screenshot    Cheque cancellation Page
        ${iOS_EN_Cancellation_reason}    Set Variable       chain=**/XCUIElementTypeOther[`name == "${Reason_For_Cancellation}"`][2]
        ${Android_EN_Cancellation_reason}    Set Variable       xpath=//android.widget.TextView[@text="${Reason_For_Cancellation}"]
        Click Element    ${${platformName}_${lang}_Cancellation_reason}
        Click Element    ${${platformName}_${lang}_Done_Button}
        #Input Payable Amount
        Click Element    ${${platformName}_${lang}_AmountPayable}
        Input Text    ${${platformName}_${lang}_AmountPayable}    ${Amount_Payable}
        IF    '${platformName}' == 'iOS'
             Click Element    ${${platformName}_${lang}_DoneKeybordButton}
        ELSE
            Close keyboard
        END
        Take Screenshot    Cheque cancellation Page
        ${Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_AddPaymentMethod}       timeout=2s
        IF    '${Status}' == 'True'
            Click Element    ${${platformName}_${lang}_AddPaymentMethod}
        END
        #select Payment Method
        Wait Until Element Is Visible    ${${platformName}_${lang}_addPaymentMethodTitle}     timeout=2s
        ${iOS_EN_methodOfPayment}    Set Variable    chain=**/XCUIElementTypeOther[`name == "${Payment_Method}"`][2]
        ${Android_EN_methodOfPayment}    Set Variable       xpath=//android.widget.TextView[@text="${Payment_Method}"]
        Click Element    ${${platformName}_${lang}_methodOfPayment}
        Wait Until Element Is Visible    ${iOS_EN_PromtPayCheckBox}     timeout=2s
        Click Element    ${${platformName}_${lang}_PromtPayCheckBox}
        Element Should Be Enabled    ${${platformName}_${lang}_promtpaySaveButton}
        Click Element    ${${platformName}_${lang}_promtpaySaveButton}
        Element Should Be Enabled    ${${platformName}_${lang}_ChequeCancelNextButton}
        Take Screenshot    Cheque cancellation Page
        Click Element    ${${platformName}_${lang}_ChequeCancelNextButton}

        Take Screenshot    Cancellation Cheque View Summary
        IF    '${platformName}' == 'iOS'
             #Capture Summary page VP
            ${VP_chequeType}    Get Text        chain=**/XCUIElementTypeStaticText[`name == "${Type_Of_Cheque}"`]
            ${VP_cancellationReason}    Get Text        chain=**/XCUIElementTypeStaticText[`name == "${Reason_For_Cancellation}"`]
            ${AmountPayableText}    Get Text        xpath=//XCUIElementTypeStaticText[contains(@name,'${Amount_Payable}')]
            @{sAmount1}    Split String        ${AmountPayableText}
            ${listamount1}    Get From List       ${sAmount1}    1
            @{samount2}    Split String    ${listamount1}    .
            ${VP_AmountPay}    Get From List    ${samount2}    0
            IF    '${Payment_Method}' == 'PromptPay'
                ${promtpay}    Set Variable    PromptPay
                ${vPromptPay}    Set Global Variable    ${promtpay}
                ${VP_PaymentMethod}    Get Text        chain=**/XCUIElementTypeStaticText[`name == "${promtpay}"`]
            ELSE
                ${VP_PaymentMethod}    Get Text        chain=**/XCUIElementTypeStaticText[`name == "${Payment_Method}"`]
            END
        ELSE
            ${VP_chequeType}    Get Text    xpath=(//android.widget.TextView[@text="Type of cheque"]//following-sibling::android.widget.TextView)[1]
            ${VP_cancellationReason}    Get Text    xpath=(//android.widget.TextView[@text="Reason for cancellation"]//following-sibling::android.widget.TextView)[1]
            ${AmountPayableText}        Get Text    xpath=(//android.widget.TextView[@text="Amount payable"]//following-sibling::android.widget.TextView)[1]
            @{AmountPayableText}    Split String    ${AmountPayableText}    .
            ${VP_AmountPayableText}     Get From List    ${AmountPayableText}    0
            ${VP_PaymentMethod}     Get Text    xpath=(//android.widget.TextView[@text="Payout method"]//following-sibling::android.widget.TextView)[1]
        END
        Get Details from DB
        ${Previous_OTP}    Set Variable    ${OTPNumber}
        Set Global Variable    ${Previous_OTP}
        Take Screenshot    OTP
    #    Element Should Be Enabled    ${iOS_EN_SummaryPageNextButton}
        Click Element    ${${platformName}_${lang}_SubmitButton}
        Take Screenshot    Cheque cancellation Page

        ${sOutput}    Run Keyword And Ignore Error
        ...    Insert OTP
        ...    ${Transaction_OTP_Source}
        ...    ${Transaction_OTP_Expiry_Flag}
        ...    ${Transaction_OTP_Resend_Flag}

        Check Transaction Status
        Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=20s
        Click Element    ${${platformName}_${lang}_SeeAll}
        Take Screenshot    Transaction_Page
        Wait Until Page Contains Element    ${${platformName}_${lang}_ServiceReuest}    timeout=10s
        Click Element    ${${platformName}_${lang}_ServiceReuest}
        Take Screenshot    Transaction_Page
        #Capture Transaction Deatils
        Run Keyword     Capture Cheque Cancellation Transaction Details for ${platformName}     Pre

        Set Global Variable    ${result}    Cheque Cancellation for Policy No: ${Policy_No}

    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END

Capture Cheque Cancellation Transaction Details for iOS
    [Arguments]    ${Transaction_Info}
    TRY
         ${iOS_selectCurrentTransaction}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Cheque cancellation request' and label CONTAINS 'Policy no: ${Policy_No}'`][27]

        Take Screenshot    Transaction Page details
        Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction}    timeout=60s
        Scroll Till Transaction Is Visible    ${${platformName}_selectCurrentTransaction}
        Click Element    ${${platformName}_selectCurrentTransaction}
        Take Screenshot    Transaction Page details

        ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction}
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Policy no
        ${policyno}    Get From List    ${transactionstatusdetail}    1
        ${policyno}    Remove String    ${policyno}    :
        ${NewChecquCancelDetails}     Split String    ${policyno}     Type of cheque
        ${policyno}     Get From List    ${NewChecquCancelDetails}       0
         ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Cheque cancellation request
        ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
        ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
        ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
        IF    '${mTransactionstatus}' == 'Completed'
                    ${mTransactionstatus}    Set Variable    Approve
                    ${OPUSTransactionstatus}    Set Variable    Completed
                    Set Global Variable    ${OPUSTransactionstatus}
        ELSE
            ${OPUSTransactionstatus}    Set Variable    In progress
            Set Global Variable    ${OPUSTransactionstatus}
        END
        ${transactionDetails}    Get From List    ${NewChecquCancelDetails}    1
        @{newDetailsList}    Split String    ${transactionDetails}    Amount payable
        ${tCancellationReason}    Get From List    ${newDetailsList}    0
        @{NewCancelReasonlist}    Split String    ${tCancellationReason}    Reason for cancellation
        ${VP_ResonForCancel}    Get From List    ${NewCancelReasonlist}    1
        ${VP_ChequeType}    Get From List    ${NewCancelReasonlist}    0
        ${newDetailsList1}    Get From List    ${newDetailsList}    1
        @{newDetailsList2}    Split String    ${newDetailsList1}    Payout method
        ${m_tAmountPayable}    Get From List    ${newDetailsList2}    0
        ${VP_tAmountPayable}    Remove String    ${m_tAmountPayable}     THB
        ${VP_tPaymentMethod}    Get From List    ${newDetailsList2}    1

         IF    '${Transaction_Info}' == 'Pre'
                Set Calc VP Expected Result With Original And Source
                ...    Transaction_Status
                ...    ${mTransactionstatus}
                ...    ${mTransactionstatus}
                ...    OMNE_View_Transaction
                Set Calc VP Expected Result With Original And Source
                ...    Transaction_CancellationReason
                ...    ${VP_ResonForCancel.strip()}
                ...    ${VP_ResonForCancel.strip()}
                ...    OMNE_View_Transaction
                Set Calc VP Expected Result With Original And Source
                ...    Transaction_ChequeType
                ...    ${VP_ChequeType.strip()}
                ...    ${VP_ChequeType.strip()}
                ...    OMNE_View_Transaction
                Set Calc VP Expected Result With Original And Source
                ...    Transaction_AmountPayable
                ...    ${VP_tAmountPayable.strip()}
                ...    ${VP_tAmountPayable.strip()}
                ...    OMNE_View_Transaction
                Set Calc VP Expected Result With Original And Source
                ...    Transaction_PaymentMethod
                ...    ${VP_tPaymentMethod.strip()}
                ...    ${VP_tPaymentMethod.strip()}
                ...    OMNE_View_Transaction
         END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Cheque Cancellation Transaction Details for iOS ${Insurance_Flow}
    END

Capture Cheque Cancellation Transaction Details for Android
    [Arguments]    ${Transaction_Info}
    TRY
        IF    '${Transaction_Info}' == 'Pre'
            ${Android_selectCurrentTransaction}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Cheque cancellation request']/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]
        ELSE
             ${Android_selectCurrentTransaction}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Cheque cancellation request']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='${MCaseStatus}'])[1]
        END
        Take Screenshot    Transaction Page details
        Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction}    timeout=60s
        Scroll Till Transaction Is Visible    ${${platformName}_selectCurrentTransaction}
        Click Element    ${${platformName}_selectCurrentTransaction}
        Take Screenshot    Transaction Page details

        ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction}
        IF    '${Transaction_Info}' == 'Pre'
            IF    '${transactionstatus}' == 'Completed'
                        ${transactionstatus}    Set Variable    Approve
                        ${OPUSTransactionstatus}    Set Variable    Completed
                        Set Global Variable    ${OPUSTransactionstatus}
            ELSE
                ${OPUSTransactionstatus}    Set Variable    In progress
                Set Global Variable    ${OPUSTransactionstatus}
            END
        ELSE
            IF    '${transactionstatus}' == 'Declined'
                 ${mtransactionstatus}    Set Variable    Decline
                 Set Global Variable    ${mtransactionstatus}
            END
        END
         ${VP_ChequeType}    Get Text    xpath=(//android.widget.TextView[@text="Type of cheque"]//following-sibling::android.widget.TextView)[1]
         ${VP_ResonForCancel}    Get Text    xpath=(//android.widget.TextView[@text="Reason for cancellation"]//following-sibling::android.widget.TextView)[1]
         ${AmountPayableText}        Get Text    xpath=(//android.widget.TextView[@text="Amount payable"]//following-sibling::android.widget.TextView)[1]
         ${VP_tAmountPayable}    Remove String    ${AmountPayableText}     THB
#         ${VP_tAmountPayable}    Get From List    ${VP_tAmountPayable}    1
         ${VP_tPaymentMethod}     Get Text    xpath=(//android.widget.TextView[@text="Payout method"]//following-sibling::android.widget.TextView)[1]

         IF    '${Transaction_Info}' == 'Pre'
                Set Calc VP Expected Result With Original And Source
                ...    Transaction_Status
                ...    ${transactionstatus.strip()}
                ...    ${transactionstatus.strip()}
                ...    OMNE_View_Transaction
                Set Calc VP Expected Result With Original And Source
                ...    Transaction_CancellationReason
                ...    ${VP_ResonForCancel.strip()}
                ...    ${VP_ResonForCancel.strip()}
                ...    OMNE_View_Transaction
                Set Calc VP Expected Result With Original And Source
                ...    Transaction_ChequeType
                ...    ${VP_ChequeType.strip()}
                ...    ${VP_ChequeType.strip()}
                ...    OMNE_View_Transaction
                Set Calc VP Expected Result With Original And Source
                ...    Transaction_AmountPayable
                ...    ${VP_tAmountPayable.strip()}
                ...    ${VP_tAmountPayable.strip()}
                ...    OMNE_View_Transaction
                Set Calc VP Expected Result With Original And Source
                ...    Transaction_PaymentMethod
                ...    ${VP_tPaymentMethod.strip()}
                ...    ${VP_tPaymentMethod.strip()}
                ...    OMNE_View_Transaction
         ELSE
                Set Calc VP Actual Result With Original And Source
                ...    Post Transaction_CancellationReason
                ...    ${VP_ResonForCancel.strip()}
                ...    ${VP_ResonForCancel.strip()}
                ...    OMNE_View_Transaction
                Set Calc VP Actual Result With Original And Source
                ...    Post Transaction_ChequeType
                ...    ${VP_ChequeType.strip()}
                ...    ${VP_ChequeType.strip()}
                ...    OMNE_View_Transaction
                Set Calc VP Actual Result With Original And Source
                ...    Post Transaction_AmountPayable
                ...    ${VP_tAmountPayable.strip()}
                ...    ${VP_tAmountPayable.strip()}
                ...    OMNE_View_Transaction
                Set Calc VP Actual Result With Original And Source
                ...    Post Transaction_PaymentMethod
                ...    ${VP_tPaymentMethod.strip()}
                ...    ${VP_tPaymentMethod.strip()}
                ...    OMNE_View_Transaction
                Set Calc VP Actual Result With Original And Source
                ...    Transaction_Status_After_OPUS
                ...    ${mtransactionstatus.strip()}
                ...    ${mtransactionstatus.strip()}
                ...    OMNE_View_Transaction
         END

    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Cheque Cancellation Transaction Details for Android ${Insurance_Flow}
    END



