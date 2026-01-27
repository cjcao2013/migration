*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     String
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource
Resource    LoanRepaymentPage.resource
Resource    ../../../PageObjects/Insurance/PayPremium/RenewalPremiumPageObjects.resource
Resource    ../../../PageObjects/Insurance/ViewTransactions/TransactionDetailsPageObjects.resource


*** Keywords ***
Renewal premium
    TRY
        Set or enter PIN
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_EN_PolicyNotAvailable}
        ...    timeout=10s
        IF    '${status}' == 'True'
            Set Global Variable    ${errormsg}    No Eligible Policy
        END
        #    Click On Policy Number
        ${Android_SelectPolicyNo}    Set Variable    android=new UiSelector().textContains("${Policy_No}")
        ${iOS_SelectPolicyNo}    Set Variable    chain=**/XCUIElementTypeOther[`name CONTAINS "${Policy_No} Premium"`][-1]
        Wait Until Page Contains Element    ${${platformName}_SelectPolicyNo}       timeout=30s
        Take Screenshot    Select Policy
        Click Element    ${${platformName}_SelectPolicyNo}

        IF    '${Payment_Method}' == 'Bank Transfer'
            Wait Until Page Contains Element    ${${platformName}_${lang}_QRcode}       timeout=30s
            Take Screenshot    RenewalPremium
            Click Element    ${${platformName}_${lang}_QRcode}
            QR Code

        ELSE
            Wait Until Page Contains Element    ${${platformName}_${lang}_CreditCard}       timeout=3s
            Take Screenshot    RenewalPremium
            Click Element    ${${platformName}_${lang}_CreditCard}
            Take Screenshot    RenewalPremiumPage
            Wait Until Element Is Visible    ${${platformName}_${lang}_lang}       timeout=100s
            Click Element       ${${platformName}_${lang}_lang}
            Pause Execution
#            Wait Until Element Is Visible    ${${platformName}_${lang}_Englang}       timeout=3s
#            Click Element       ${${platformName}_${lang}_Englang}
            Wait Until Element Is Visible    ${${platformName}_${lang}_RP_CreditCardNumber}       timeout=3s
            Input Text    ${${platformName}_${lang}_RP_CreditCardNumber}    ${CrediCardNumber}
            Close keyboard
            Take Screenshot    RenewalPremiumPage
            Wait Until Element Is Visible    ${${platformName}_${lang}_RP_ExpiryDate}       timeout=3s
            Input Text    ${${platformName}_${lang}_RP_ExpiryDate}    ${CrediCardExpiryDate}
            Close keyboard
            Input Text    ${${platformName}_${lang}_RP_CVV}    ${CrediCardCVVNumber}
            Close keyboard
            Input Text    ${${platformName}_${lang}_RP_CardHolderName}    ${CrediCardHolderName}
            TRY
                Click Text      Done    exact_match=True
            EXCEPT
                 Close keyboard
            END
            Input Text    ${${platformName}_${lang}_RP_EmailAddress}    ${Email}

            TRY
                Click Text      Done    exact_match=True
            EXCEPT
                 Close keyboard
            END

            Take Screenshot    RenewalPremiumPage
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_ContinuePayment}
            ...    timeout=5s
            IF    '${status}' == 'True'
                Click Element       ${${platformName}_${lang}_ContinuePayment}
            END

            Wait Until Element Is Visible    ${${platformName}_${lang}_SecureValidation}       timeout=10s
            Input Text    ${${platformName}_${lang}_OTPField}    ${OTP}

            TRY
                Click Text      Done    exact_match=True
            EXCEPT
                 Close keyboard
            END

            Take Screenshot    RenewalPremiumPage
            Wait Until Element Is Visible    ${${platformName}_${lang}_SubmitButton}        timeout=10s
#            Click Element       ${${platformName}_${lang}_SubmitButton}
            Pause Execution
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_SucessfulTransaction}
            ...    timeout=20s
            IF    '${status}' == 'True'
                ${VP_SucessfulTransaction}    Get Text    ${${platformName}_${lang}_SucessfulTransaction}
                Set Global Variable    ${Successmsg}    ${VP_SucessfulTransaction}
                Set Calc VP With Source And Original Values
                ...    OMNE_App
                ...    Sucessful Transaction
                ...    ${VP_SucessfulTransaction}
                ...    Static
                ...    OMNE_Application
                ...    Sucessful Transaction
                ...    ${VP_SucessfulTransaction}
            END
            Take Screenshot    RenewalPremiumPage

            Take Screenshot    RenewalPremiumPage
            Renewal premium Transaction

        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END


#Capture Renewal Premium Transaction Details for iOS
Renewal premium Transaction
        TRY

            ${status}   Run Keyword And Return Status       Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=3s
            IF    '${status}' == 'True'
                Click Element    ${${platformName}_${lang}_SeeAll}
            ELSE
                Wait Until Page Contains Element    ${${platformName}_${lang}_PaymentRequestTransaction}    timeout=2s
               Click Element    ${${platformName}_${lang}_PaymentRequestTransaction}
            END
            Take Screenshot    Transaction_Page
            Wait Until Page Contains Element    ${${platformName}_${lang}_TransactionPremiumRequest}    timeout=50s
            Click Element    ${${platformName}_${lang}_TransactionPremiumRequest}

            Take Screenshot    Transaction_Page

            Run Keyword    Capture Renewal Premium Details For ${platformName}    Pre
        EXCEPT     AS  ${reason}
            Set Failed Actual Result and VP    Omne_Flow   ${reason}   Renewal premium Transaction
        END


Capture Renewal Premium Details For iOS
    [Arguments]    ${Transaction_Info}
    TRY
            ${iOS_selectCurrentTransaction1}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Pay renewal premium' and label CONTAINS 'Policy no: ${Policy_No}'`][27]

        Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction1}    timeout=90s
        Take Screenshot    Transaction Page
        ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction1}
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Policy no
        ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Pay renewal premium
        ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
        @{strtransactionstatus}    Split String        ${transactionstatus}    (
        ${transactionStatusOmne}    Get From List       ${strtransactionstatus}    1
        @{rtransaction}    Split String    ${transactionStatusOmne}    )
        ${finalString}    Get From List    ${rtransaction}    0
        ${mTransactionstatus}    Set Variable    ${finalString}
        IF    '${mTransactionstatus}' == 'Paid'
            ${OPUSTransactionstatus}    Set Variable    Completed
            Set Global Variable    ${OPUSTransactionstatus}
        END

        Take Screenshot    Transaction Page
        Click Element    ${${platformName}_selectCurrentTransaction1}

        Take Screenshot    Transaction Page
        # PolicyName
        ${TransactionDetails}    Get Text    ${${platformName}_selectCurrentTransaction1}
        ${Transaction}    Set Variable    ${TransactionDetails}

        @{substrings}    Split String    ${Transaction}    Policy no:
        ${transactionstatus1}    Get From List    ${substrings}    1

        @{substrings2}    Split String    ${transactionstatus1}    Policy applied
        ${transactionstatus2}    Get From List    ${substrings2}    1

        @{substrings3}    Split String    ${transactionstatus2}    Premium payment amount
        ${VP_Policy_Applied}    Get From List    ${substrings3}    0
        ${transactionstatus3}    Get From List    ${substrings3}    1

        @{substrings4}    Split String    ${transactionstatus3}    Date of payment
        ${paymentandduedate}    Get From List    ${substrings4}    0
        @{spaymentandduedate}    Split String    ${paymentandduedate}    Due date
        ${VP_Premium_Payment_amount}    Get From List    ${spaymentandduedate}    0
        ${VP_DueDate}    Get From List    ${spaymentandduedate}    1

        ${paymentMethodAndCompletionDate}    Get From List    ${substrings4}    1
        @{substrings5}    Split String    ${paymentMethodAndCompletionDate}    Payment method
        ${VP_Date_Of_Payment}    Get From List    ${substrings5}    0
        ${paymentReferenceNumber}    Get From List    ${substrings5}    1

        @{substrings6}    Split String    ${paymentReferenceNumber}    Payment reference no.
        ${VP_Payment_Method}    Get From List    ${substrings6}    0
        ${VP_Payment_Reference_number}    Get From List    ${substrings6}    1


            Set Calc VP Expected Result With Original And Source
            ...    Transaction_Status
            ...    ${mTransactionstatus.strip()}
            ...    ${mTransactionstatus.strip()}
            ...    OMNE_Application
            Set Calc VP Expected Result With Original And Source
            ...    Completion_Date
            ...    ${VP_Date_Of_Payment.strip()}
            ...    ${VP_Date_Of_Payment.strip()}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Payment_Reference_Number
            ...    ${VP_Payment_Reference_number.strip()}
            ...    ${VP_Payment_Reference_number.strip()}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Payment_Method
            ...    ${VP_Payment_Method.strip()}
            ...    ${VP_Payment_Method.strip()}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Premium_Payment_Amount
            ...    ${VP_Premium_Payment_amount.strip()}
            ...    ${VP_Premium_Payment_amount.strip()}
            ...    OMNE_TransactionPage
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Renewal Premium Details For iOS
    END


Capture Renewal Premium Details For Android
    [Arguments]    ${Transaction_Info}
    TRY
            ${Android_selectCurrentTransaction1}    Set Variable
            ...   xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Pay renewal premium'])[1]

            Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction1}    timeout=90s
            Take Screenshot    Transaction Page
            ${VP_TransactionStatus}         Get Text    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Pay renewal premium'])[1]//following-sibling::android.view.ViewGroup/android.widget.TextView
            ${mTransactionstatus}       Run Keyword And Return Status    Should Contain     ${VP_TransactionStatus}       Paid
            IF    '${mTransactionstatus}' == 'True'
               ${OPUSTransactionstatus}    Set Variable    Completed
                Set Global Variable    ${OPUSTransactionstatus}
            END
            ${VP_Date_Of_Payment}         Get Text          xpath=(//android.widget.TextView[@text='Date of payment']/following-sibling::android.widget.TextView)
            ${VP_Payment_Reference_number}         Get Text     xpath=(//android.widget.TextView[@text='Payment reference no.']/following-sibling::android.widget.TextView)
            ${VP_Payment_Method}         Get Text           xpath=(//android.widget.TextView[@text='Payment method']/following-sibling::android.widget.TextView)
            ${VP_Premium_Payment_amount}         Get Text       xpath=(//android.widget.TextView[@text='Premium payment amount']/following-sibling::android.widget.TextView)

            Set Calc VP Expected Result With Original And Source
            ...    Transaction_Status
            ...    ${mTransactionstatus.strip()}
            ...    ${mTransactionstatus.strip()}
            ...    OMNE_Application
            Set Calc VP Expected Result With Original And Source
            ...    Completion_Date
            ...    ${VP_Date_Of_Payment.strip()}
            ...    ${VP_Date_Of_Payment.strip()}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Payment_Reference_Number
            ...    ${VP_Payment_Reference_number.strip()}
            ...    ${VP_Payment_Reference_number.strip()}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Payment_Method
            ...    ${VP_Payment_Method.strip()}
            ...    ${VP_Payment_Method.strip()}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Premium_Payment_Amount
            ...    ${VP_Premium_Payment_amount.strip()}
            ...    ${VP_Premium_Payment_amount.strip()}
            ...    OMNE_TransactionPage
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Renewal Premium Details For iOS
    END