*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     String
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/CVPolicyLoanPageObjects.resource


*** Keywords ***
Policy loan
    TRY
        ${iOS_EN_PolicySelect}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Policy_No}'`][-1]
        ${iOS_EN_PolicyLoan_RequestAMount}    Set Variable    chain=**/XCUIElementTypeOther[`label == "${Request_Amount}"`]
        ${iOS_AddPaymentTypeSelect}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label == "${Add_Payment_Method_Type}"`][2]
        ${Android_EN_PolicyLoan_RequestAMount}    Set Variable      xpath=//android.widget.TextView[@text="${Request_Amount}"]/preceding-sibling::android.view.ViewGroup
        ${Android_AddPaymentTypeSelect}    Set Variable     xpath=//android.widget.TextView[@text="${Add_Payment_Method_Type}"]
        Sleep    2s
#        Select Policy
        Pause Execution
        Wait Until Element Is Visible    ${${platformName}_${lang}_PolicyCashValue}    timeout=20
        ${VP_PolicyCashValue}    Get Text    ${${platformName}_${lang}_PolicyCashValue}
        ${mVP_PolicyCashValue}    Remove String    ${VP_PolicyCashValue}    THB
        ${mVP_PolicyCashValue}    Remove String    ${mVP_PolicyCashValue}    ,
        Set Calc VP Expected Result With Original And Source
        ...    Policy_Cash_Value
        ...    ${mVP_PolicyCashValue.strip()}
        ...    ${VP_PolicyCashValue}
        ...    OMNE_Application
        ${VP_Loanlimitasoftoday}    Get Text    ${${platformName}_${lang}_Loanlimitasoftoday}
        ${mVP_Loanlimitasoftoday}    Remove String    ${VP_Loanlimitasoftoday}    THB
        ${mVP_Loanlimitasoftoday}    Remove String    ${mVP_Loanlimitasoftoday}    ,
        Set Calc VP Expected Result With Original And Source
        ...    Policy_Loan_Limit_Today
        ...    ${mVP_Loanlimitasoftoday.strip()}
        ...    ${VP_Loanlimitasoftoday}
        ...    OMNE_Application
        ${VP_Loanoutstanding}    Get Text    ${${platformName}_${lang}_Loanoutstanding}
        ${mVP_Loanoutstanding}    Remove String    ${VP_Loanoutstanding}    THB
        ${mVP_Loanoutstanding}    Remove String    ${mVP_Loanoutstanding}    ,
        Set Calc VP Expected Result With Original And Source
        ...    Policy_Loan_Outstanding
        ...    ${mVP_Loanoutstanding.strip()}
        ...    ${VP_Loanoutstanding}
        ...    OMNE_Application
        ${VP_Loaninterestrateperyear}    Get Text    ${${platformName}_${lang}_Loaninterestrateperyear}
        ${mVP_Loaninterestrateperyear}    Remove String    ${VP_Loaninterestrateperyear}    %
        Set Calc VP Expected Result With Original And Source
        ...    Policy_Loan_Interest_Rate_Per_Year
        ...    ${mVP_Loaninterestrateperyear.strip()}
        ...    ${VP_Loaninterestrateperyear}
        ...    OMNE_Application
        ${VP_Totalasoftoday}    Get Text    ${${platformName}_${lang}_Totalasoftoday}
        ${mVP_Totalasoftoday}    Remove String    ${VP_Totalasoftoday}    THB
        ${mVP_Totalasoftoday}    Remove String    ${mVP_Totalasoftoday}    ,
        Set Calc VP Expected Result With Original And Source
        ...    Policy_Loan_Total_As_Of_Today
        ...    ${mVP_Totalasoftoday.strip()}
        ...    ${VP_Totalasoftoday}
        ...    OMNE_Application
        IF    '${Request_Amount}' == 'Specify amount (THB)'
            Click Element    ${${platformName}_${lang}_PolicyLoan_RequestAMount}
            ${Loanlimitasoftoday}    Convert To Number    ${mVP_Loanlimitasoftoday}
            # Calculate Policy Max Limit
            ${Max_LoanLimit}    Evaluate    ${Loanlimitasoftoday} + 100
            Input Text    ${${platformName}_${lang}_PolicyLoanAMountInput}    ${Max_LoanLimit}\n
            # Capture Policy Max Limit Error
            ${status}    Run Keyword And Return Status
            ...    Element Should Be Visible
            ...    ${${platformName}_${lang}_Error_Max_LoanLimit}
            IF    '${status}' == 'True'
                Take Screenshot    CV_Loan_Max_Limit_Error
                ${Error_MaxLoanLimit}    Get Text    ${${platformName}_${lang}_Error_Max_LoanLimit}
                Set Calc VP With Source And Original Values
                ...    CVLoan_MaxLimit_ErrorMsg
                ...    ${Error_MaxLoanLimit}
                ...    ${Error_MaxLoanLimit}
                ...    static
                ...    Omne Application
                ...    ${Error_MaxLoanLimit}
                ...    ${Error_MaxLoanLimit}
            END
            Sleep    0.5s
            Click Element    ${${platformName}_${lang}_HighestLoanLimit}
            Sleep    0.5s
            Click Element    ${${platformName}_${lang}_PolicyLoan_RequestAMount}
            Input Text    ${${platformName}_${lang}_PolicyLoanAMountInput}    ${Loan_Amount}\n
        ELSE
            Click Element    ${${platformName}_${lang}_PolicyLoan_RequestAMount}
        END
        Take Screenshot    Policy_Loan
        SwipePage
        IF    '${Bank_Account_Details_Change}' == 'Yes'
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_AddPaymentMethod}
            ...    timeout=2s
            IF    '${status}' == 'True'
                Click Element    ${${platformName}_${lang}_AddPaymentMethod}
            ELSE
                Click Element    ${${platformName}_${lang}_Change_BankDetails}
            END
            Sleep    1s
            Click Element    ${${platformName}_AddPaymentTypeSelect}
            IF    '${Add_Payment_Method_Type}' == 'PromptPay'
                Click Element    ${${platformName}_${lang}_PromentpayCheckbox}
                Wait Until Element Is Visible    ${${platformName}_${lang}_saveBtn}
                Click Element    ${${platformName}_${lang}_saveBtn}
            ELSE
    #    Add Payment Method PolicyLoan
                Add Payment Methods

            END
        END
                ${Status}    Run Keyword And Return Status
                ...    Wait Until Page Contains Element
                ...    ${${platformName}_${lang}_UploadDocument_JustConfirm_Yes}
                ...    timeout=10s
                IF    '${status}' == 'True'
                    Click Element    ${${platformName}_${lang}_UploadDocument_JustConfirm_Yes}
                END
        SwipePage
        # Previous OTP from DB
        Get Details from DB
        ${Previous_OTP}    Set Variable    ${OTPNumber}
        Set Global Variable    ${Previous_OTP}
        Sleep    1s
        Wait Until Element Is Visible    ${${platformName}_${lang}_CVloan_TermsandConCheckbox}    timeout=20s
        Click Element    ${${platformName}_${lang}_CVloan_TermsandConCheckbox}
        Take Screenshot    Policy_Loan
        Click Text    Submit    exact_match=true
        ${iOS_PolicyLoanConfirmEmailPopup}    Set Variable    chain=**/XCUIElementTypeOther[`label == "Yes"`]
        ${Android_PolicyLoanConfirmEmailPopup}    Set Variable    xpath=//android.view.ViewGroup[@content-desc="Yes"]
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_PolicyLoanConfirmEmailPopup}
        ...    timeout=7s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_PolicyLoanConfirmEmailPopup}
        END
        Take Screenshot    Policy_Loan
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_OTP_email}
        IF    '${status}' == 'True'
            Insert OTP    ${Transaction_OTP_Source}    ${Transaction_OTP_Expiry_Flag}    ${Transaction_OTP_Resend_Flag}
        END
    #    Wait Until Element Is Visible    ${${platformName}_${lang}_CVLoanTransaction}    timeout=50s
    #    Click Element    ${${platformName}_${lang}_CVLoanTransaction}

            # New All Done Confirmation Page
        ${sOutput}    Run Keyword And Ignore Error    Check Transaction Status
        IF    ${sOutput} != ('PASS', None)
            Take Screenshot    Update Policy
            ${failure_reason}    Fetch Reason    ${sOutput}
            RETURN    ${failure_reason}
        END

        ${sOutput}    Run Keyword And Ignore Error    Completion Popup
        IF    ${sOutput} != ('PASS', None)
            Take Screenshot    Update Policy
            ${failure_reason}    Fetch Reason    ${sOutput}
            RETURN    ${failure_reason}
        END

        Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=20s
        Click Element    ${${platformName}_${lang}_SeeAll}
        Take Screenshot    Transaction_Page
        Wait Until Page Contains Element    ${${platformName}_${lang}_ServiceReuest}    timeout=50s
        Click Element    ${${platformName}_${lang}_ServiceReuest}
        Take Screenshot    Transaction_Page
        Run Keyword    TransactionDetails for CV Loan ${platformName}    Pre
        Set Global Variable    ${result}    PolicyLoan Request Submitted Successfully
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END

Add Payment Method PolicyLoan
    TRY
        Take Screenshot    Add Payment Method
        Wait Until Page Contains Element        ${${platformName}_${lang}_uploadDocPlusButton}      timeout=10s
        Click Element    ${${platformName}_${lang}_uploadDocPlusButton}
    #    Upload Document Static BS
        ${path}    Set Variable    ${EXECDIR}/Pages/Common/ClaimImages/Certificate.PNG
        Upload Document BS    ${path}
        Click Element    ${${platformName}_${lang}_BankName_DropDown}

        SwipePage
        ${${platformName}_${lang}_BankName}    Set Variable    chain=**/XCUIElementTypeOther[`label == '${BankName}'`][-1]
        Wait Until Page Contains Element    ${${platformName}_${lang}_BankName}     timeout=10s
        Click Element    ${${platformName}_${lang}_BankName}
        Wait Until Page Contains Element    ${${platformName}_${lang}_Done_Button}    timeout=10s
        Click Element    ${${platformName}_${lang}_Done_Button}
        Take Screenshot    BankDetails_Page
        ${ranint}    Generate Random String    length=10    chars=[NUMBERS]
        ${BankNo}    Convert To Integer    ${ranint}
        Input Text    ${${platformName}_${lang}_Bank_Account_No}    ${BankNo}\n
        Take Screenshot    Add Payment Method
        Click Text    Save    exact_match=true
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Add Payment Method PolicyLoan
    END

TransactionDetails for CV Loan iOS
    [Arguments]    ${Transaction_Info}
    TRY
        IF    '${Transaction_Info}'== 'Pre'
            ${iOS_selectCurrentTransaction1}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Policy Loan Request' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
            ${iOS_transactionstatusobject}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Policy Loan Request' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        ELSE IF    '${Transaction_Info}'== 'Post'
            ${iOS_selectCurrentTransaction1}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Policy Loan Request' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
            ${iOS_transactionstatusobject}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Policy Loan Request' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        END

        Log    ${${platformName}_selectCurrentTransaction1}
        Scroll Till Transaction Is Visible   ${${platformName}_selectCurrentTransaction1}
        Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction1}    timeout=300s

        Take Screenshot    Transaction Page
        ${transactionstatus}    Get Text    ${${platformName}_transactionstatusobject}
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Policy no
        ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Policy Loan Request
        ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
        ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
        ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
        IF    '${mTransactionstatus}' == 'Completed'
            ${mTransactionstatus}    Set Variable    Approve
            ${OPUSTransactionstatus}    Set Variable    Completed
            Set Global Variable    ${OPUSTransactionstatus}
        ELSE
            IF     '${Add_Payment_Method_Type}' == 'PromptPay'
                ${OPUSTransactionstatus}    Set Variable    Completed
                Set Global Variable    ${OPUSTransactionstatus}
            ELSE
                 ${OPUSTransactionstatus}    Set Variable    In progress
                Set Global Variable    ${OPUSTransactionstatus}
            END
        END


        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status
        ...    ${mTransactionstatus.strip()}
        ...    ${mTransactionstatus}
        ...    Omne_Transaction Page

        # capture transaction detail
        Log    ${${platformName}_selectCurrentTransaction1}
        Click Element    ${${platformName}_selectCurrentTransaction1}
        Take Screenshot    Transaction Page
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_TransactionDetailspolicyloan}
        ...    timeout=5s
        IF    '${status}' != 'True'
            SwipePage
            ${VP_BankName}    Get Text    ${${platformName}_${lang}_TransactionDetailspolicyloan}
            @{LoanList_1}    Split String    ${VP_BankName}    Request Amount
            ${LoanList_2}    Get From List    ${LoanList_1}    1
            @{LoanList_2}    Split String    ${LoanList_2}    Payout method
            ${VP_RequestAmount}    Get From List    ${LoanList_2}    0
            ${mVP_RequestAmount}    Remove String    ${VP_RequestAmount}    THB
            ${mVP_RequestAmount}    Remove String    ${mVP_RequestAmount}    ,
            ${mVP_Amount}    Split String    ${mVP_RequestAmount}
            ${leng}    Get Length    ${mVP_Amount}
            IF    '${leng}' > '1'
                ${VP_RequestAmount}    Split String    ${VP_RequestAmount}    Payable amount
                ${VP_RequestAmount}    Get From List    ${VP_RequestAmount}    0
                ${mVP_RequestAmount}    Get From List    ${mVP_Amount}    0
                ${VP_PayableAmount}    Get From List    ${mVP_Amount}    2
            END
            IF    '${Transaction_Info}' == 'Pre'
                Set Calc VP Expected Result With Original And Source
                ...    Policy_Loan_Request_Amount
                ...    ${mVP_RequestAmount.strip()}
                ...    ${VP_RequestAmount.strip()}
                ...    Omne_Transaction Page
                IF    '${leng}' < '1'
                    Set Calc VP Expected Result With Original And Source
                    ...    Policy_Payable_Amount
                    ...    ${mVP_PayableAmount.strip()}
                    ...    ${VP_PayableAmount.strip()}
                    ...    Omne_Transaction Page
                END
            ELSE IF    '${Transaction_Info}' == 'Post'
                Set Calc VP Actual Result With Original And Source
                ...    Post_Policy_Loan_Request_Amount
                ...    ${mVP_RequestAmount.strip()}
                ...    ${VP_RequestAmount.strip()}
                ...    Omne_Transaction Page
                IF    '${leng}' < '1'
                    Set Calc VP Actual Result With Original And Source
                    ...    Post_Policy_Payable_Amount
                    ...    ${mVP_PayableAmount.strip()}
                    ...    ${VP_PayableAmount.strip()}
                    ...    Omne_Transaction Page
                END
            END
        END
        Sleep    3s
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   TransactionDetails for CV Loan iOS
    END
TransactionDetails for CV Loan Android
    [Arguments]    ${Transaction_Info}
    Sleep    20s
    IF    '${Transaction_Info}'== 'Pre'
        Sleep    3s

        ${Android_Selectposttransaction}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Policy Loan Request'])[1]
    ELSE IF    '${Transaction_Info}'== 'Post'
        ${Android_Selectposttransaction}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Policy Loan Request'])[1]
    END
    Sleep    10s
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    Wait Until Element Is Visible    ${${platformName}_Selectposttransaction}    timeout=300s
    Take Screenshot    Transaction Page
    ${transactionstatus}    Get Text    ${${platformName}_${lang}_cv_loan_TransactionStatus}
    IF    '${transactionstatus}' == 'Completed'
        ${mTransactionstatus}    Set Variable    Approve
    ELSE
        ${mTransactionstatus}    Set Variable    In Progress
    END
    Set Calc VP Expected Result With Original And Source
    ...    Transaction_Status
    ...    ${mTransactionstatus}
    ...    ${mTransactionstatus}
    ...    Omne_Transaction Page

    # capture transaction detail
    Log    ${${platformName}_Selectposttransaction}
    Click Element    ${${platformName}_Selectposttransaction}
    Take Screenshot    Transaction Page
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_TransactionDetailspolicyloan}
    ...    timeout=5s
    IF    '${status}' != 'True'    SwipePage

#    Click Element    ${${platformName}_Selectposttransaction}
    Take Screenshot    Transaction Page
    ${VP_RequestAmount}    Get Text    ${${platformName}_${lang}_TransactionRequestAmount}
    ${mVP_RequestAmount}    Remove String    ${VP_RequestAmount}    THB
    ${mVP_RequestAmount}    Remove String    ${mVP_RequestAmount}    ,
    ${status}    Run Keyword And Return Status
    ...    Element Should Be Visible
    ...    ${${platformName}_${lang}_TransactionPayableAmount}
    IF    '${status}' == 'True'
        ${VP_PayableAmount}    Get Text    ${${platformName}_${lang}_TransactionPayableAmount}
        ${mVP_PayableAmount}    Remove String    ${VP_PayableAmount}    THB
        ${mVP_PayableAmount}    Remove String    ${mVP_PayableAmount}    ,
        IF    '${Transaction_Info}' == 'Pre'
            Set Calc VP Expected Result With Original And Source
            ...    Policy_Payable_Amount
            ...    ${mVP_PayableAmount.strip()}
            ...    ${VP_PayableAmount.strip()}
            ...    Omne_Transaction Page
        ELSE IF    '${Transaction_Info}' == 'Post'
            Set Calc VP Actual Result With Original And Source
            ...    Post_Policy_Payable_Amount
            ...    ${mVP_PayableAmount.strip()}
            ...    ${VP_PayableAmount.strip()}
            ...    Omne_Transaction Page
        END
    END
    ${accountnumber}    Get Text    ${${platformName}_${lang}_TransactionPayoutmethodAccounNo}
    ${massagedaccnumber}    Get Substring    ${accountnumber}    -4
    ${Bank_Name}    Get Text    ${${platformName}_${lang}_TransactionPayoutmethodBankName}
    IF    '${mTransactionstatus}' == 'Completed'
            ${mTransactionstatus}    Set Variable    Approve
            ${OPUSTransactionstatus}    Set Variable    Completed
            Set Global Variable    ${OPUSTransactionstatus}
        ELSE
            IF     '${Add_Payment_Method_Type}' == 'PromptPay'
                ${OPUSTransactionstatus}    Set Variable    Completed
                Set Global Variable    ${OPUSTransactionstatus}
            ELSE
                 ${OPUSTransactionstatus}    Set Variable    In progress
                Set Global Variable    ${OPUSTransactionstatus}
            END
    END

    IF    '${Transaction_Info}' == 'Pre'
        Set Calc VP Expected Result With Original And Source
        ...    Policy_Loan_Request_Amount
        ...    ${mVP_RequestAmount.strip()}
        ...    ${VP_RequestAmount.strip()}
        ...    Omne_Transaction Page
        Set Calc VP Expected Result With Original And Source
        ...    Bank_Account_Number
        ...    ${massagedaccnumber.strip()}
        ...    ${accountnumber.strip()}
        ...    Omne_Transaction Page
        Set Calc VP Expected Result With Original And Source
        ...    Bank_Name
        ...    ${Bank_Name.strip()}
        ...    ${Bank_Name}
        ...    Omne_Transaction Page
    ELSE IF    '${Transaction_Info}' == 'Post'
        Set Calc VP Actual Result With Original And Source
        ...    Post_Policy_Loan_Request_Amount
        ...    ${mVP_RequestAmount.strip()}
        ...    ${VP_RequestAmount.strip()}
        ...    Omne_Transaction Page
        Set Calc VP Actual Result With Original And Source
        ...    Post_Bank_Account_Number
        ...    ${massagedaccnumber.strip()}
        ...    ${accountnumber.strip()}
        ...    Omne_Transaction Page
        Set Calc VP Actual Result With Original And Source
        ...    Post_Bank_Name
        ...    ${Bank_Name.strip()}
        ...    ${Bank_Name}
        ...    Omne_Transaction Page
    END
