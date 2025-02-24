*** Settings ***
Library     AppiumLibrary
Library     ../../Qrace/QraceHelper.py
Library    common
Resource    ../../CustomLibraries/common.robot
Resource    ../../PageObjects/OWB/OWBCVPolicyLoanPageObjects.resource
Resource    ../../PageObjects/OPUS/OPUSCVPolicyLoanPageObject.resource

Resource   OPUSInquiryPage.resource

*** Keywords ***
OPUS Policy loan
    TRY
        IF    '${Add_Payment_Method_Type}' == 'Bank account'
            ${Transaction_After_OWB_Flag}    Set Variable    No
            Set Global Variable    ${Transaction_After_OWB_Flag}
            Change Decision Status if Non STP
        ELSE
            ${Transaction_After_OWB_Flag}    Set Variable    Yes
            Set Global Variable    ${Transaction_After_OWB_Flag}
        END
        Set Global Variable    ${Transaction_After_OWB_Flag}

    #
    #    Wait Until Element Is Visible    ${EN_PolicyCashValue}    timeout=20s


        # capture values
    #    ${OPUS_Case_No}     Get Text    ${EN_OPUS_CaseNo}
    #    Set Global Variable    ${OPUS_Case_No}
          Wait Until Element Is Visible    ${EN_OPUs_Transtatus}          timeout=20s
         Scroll Element Into View         ${EN_OPUs_Transtatus}
        ${Approved_Status}     Get Element Attribute     ${EN_OPUs_Transtatus}       attribute=title
        Set Global Variable    ${Approved_Status}
        ${Final_Approve_Status}     Set Variable     ${Approved_Status}
        Set Global Variable    ${Final_Approve_Status}
    #    ${VP_Completion_Date}      Get Value     ${EN_OPUS_RequestDate}
    #    Scroll Element Into View    ${EN_OPUS_DecisionStatus}

        ${VP_PolicyCashValue}    Get Text    ${EN_OPUS_NetCvloanValue}
        ${VP_Loan_LimitofToday}    Get Text    ${EN_OPUS_cvlaonLoanAmountAvailable}
    #    ${VP_LoanOutstanding}    Get Element Attribute    ${EN_LoanOutstanding}    attribute=value
        ${VP_Total_Loan}    Get Text    ${EN_OPUS_CVloanPolicy_CurrentLoanAmount}
        ${VP_LoanRequestAmount}    Get Element Attribute    ${EN_OPUS_CVloan_Request_amount}    attribute=value
        ${VP_PayableAmount}    Get Element Attribute    ${EN_OPUS_cvloan_Payable_amount}    attribute=title
    #    IF    '${Add_Payment_Method_Type}' != 'PromptPay'
    #        ${VP_BankName}    Get Element Attribute    ${EN_BankNamePolicyLoan}    attribute=title
    #        Wait Until Page Contains Element    ${EN_BankAccountNumberPolicyLoan}               timeout=90s
    #        ${VP_BankAccountNumber}    Get Element Attribute    ${EN_BankAccountNumberPolicyLoan}    attribute=title
    #        ${VP_BankHolderName}    Get Element Attribute    ${EN_BankHolderNamePolicyLoan}    attribute=title
    #        ${BankName}    Split String    ${VP_BankName}
    #
    #        ${leng}    Get Length    ${BankName}
    #        IF    '${leng}' < '3'
    #            ${VP_BankName}    Split String    ${VP_BankName}    -
    #            ${VP_BankName}    Get From List    ${VP_BankName}    1
    #        END
    #        ${mVP_BankAccountNumber}    Get Substring    ${VP_BankAccountNumber}    -4
    #    END
    #    ${VP_CompletionDate}    Get Element Attribute    ${EN_CompletionDate}    attribute=title
    #    ${VP_Approval_Status}    Get Element Attribute    ${EN_ApprovalStatusPolicyLoan}    attribute=title
    #    ${VP_Policy_Interest_Rate}    Get Element Attribute    ${EN_Policy_Interest_Rate}    attribute=value
    #    Scroll Element Into View    ${EN_ApprovalStatus}
        Take OPUS Screenshot    Policy Loan Page
        ${mVP_LoanRequestAmount}    Remove String    ${VP_LoanRequestAmount}    ,
        ${mVP_PolicyCashValue}    Remove String    ${VP_PolicyCashValue}    ,
        ${mVP_Loan_LimitofToday}    Remove String    ${VP_Loan_LimitofToday}    ,
    #    ${VP_LoanOutstanding}    Remove String    ${VP_LoanOutstanding}    ,
    #    ${VP_Total_Loan}    Remove String    ${VP_Total_Loan}    ,
    #    ${mVP_Policy_Interest_Rate}    Remove String    ${VP_Policy_Interest_Rate}    %
    #    ${mVP_Policy_Interest_Rate}    Remove String    ${mVP_Policy_Interest_Rate}    .00

         IF    '${Add_Payment_Method_Type}' == 'Bank account'
                ${Final_Approve_Status}         Set Variable                 ${Approved_Status}
                Set Global Variable    ${Final_Approve_Status}
                Wait Until Page Contains Element    xpath=//button[@data-trigger='submit']      timeout=20s
                Click Element    xpath=//button[@data-trigger='submit']
                Pause Execution
         END

        IF    '${Checker_Maker_Flag}' == 'No'
    #        Set Calc VP Actual Result With Original And Source
    #        ...    Policy_Loan_Interest_Rate_Per_Year
    #        ...    ${mVP_Policy_Interest_Rate}
    #        ...    ${VP_Policy_Interest_Rate}
    #        ...    OWB Application
            Set Calc VP Actual Result With Original And Source
            ...    Policy_Cash_Value
            ...    ${mVP_PolicyCashValue.strip()}
            ...    ${VP_PolicyCashValue.strip()}
            ...    OWB Application
            Set Calc VP Actual Result With Original And Source
            ...    Policy_Loan_Limit_Today
            ...    ${mVP_Loan_LimitofToday.strip()}
            ...    ${VP_Loan_LimitofToday.strip()}
            ...    OWB Application
    #        Set Calc VP Actual Result With Original And Source
    #        ...    Policy_Loan_Outstanding
    #        ...    ${VP_LoanOutstanding.strip()}
    #        ...    ${VP_LoanOutstanding.strip()}
    #        ...    OWB Application
            Set Calc VP Actual Result With Original And Source
            ...    Policy_Loan_Total_As_Of_Today
            ...    ${VP_Total_Loan.strip()}
            ...    ${VP_Total_Loan.strip()}
            ...    OWB Application
            Set Calc VP Actual Result With Original And Source
            ...    Policy_Loan_Request_Amount
            ...    ${mVP_LoanRequestAmount.strip()}
            ...    ${VP_LoanRequestAmount.strip()}
            ...    OWB Application
            #    Set Calc VP Actual Result With Original And Source    Policy_Payable_Amount    ${VP_LoanRequestAmount.strip()}    ${VP_LoanRequestAmount.strip()}    OWB Application
    #        Set Calc VP Actual Result With Original And Source
    #        ...    Bank_Name
    #        ...    ${VP_BankName.strip()}
    #        ...    ${VP_BankName.strip()}
    #        ...    OWB Application
    #        Set Calc VP Actual Result With Original And Source
    #        ...    Bank_Account_Number
    #        ...    ${mVP_BankAccountNumber.strip()}
    #        ...    ${VP_BankAccountNumber.strip()}
    #        ...    OWB Application
        ELSE
    #        ${BO_Status}    Get Element Attribute    ${EN_BO_Status}    attribute=value
    #        Set Calc VP Expected Result With Original And Source
    #        ...    Policy_Loan_Interest_Rate_Per_Year
    #        ...    ${mVP_Policy_Interest_Rate}
    #        ...    ${VP_Policy_Interest_Rate}
    #        ...    OWB Application
            Set Calc VP Expected Result With Original And Source
            ...    Policy_Cash_Value
            ...    ${mVP_PolicyCashValue.strip()}
            ...    ${VP_PolicyCashValue.strip()}
            ...    OWB Application
            Set Calc VP Expected Result With Original And Source
            ...    Policy_Loan_Limit_Today
            ...    ${mVP_Loan_LimitofToday.strip()}
            ...    ${VP_Loan_LimitofToday.strip()}
            ...    OWB Application
    #        Set Calc VP Expected Result With Original And Source
    #        ...    Policy_Loan_Outstanding
    #        ...    ${VP_LoanOutstanding.strip()}
    #        ...    ${VP_LoanOutstanding.strip()}
    #        ...    OWB Application
            Set Calc VP Expected Result With Original And Source
            ...    Policy_Loan_Total_As_Of_Today
            ...    ${VP_Total_Loan.strip()}
            ...    ${VP_Total_Loan.strip()}
            ...    OWB Application
            Set Calc VP Expected Result With Original And Source
            ...    Policy_Loan_Request_Amount
            ...    ${mVP_LoanRequestAmount.strip()}
            ...    ${VP_LoanRequestAmount.strip()}
            ...    OWB Application
        END
        IF    '${Transaction_After_OWB_Flag}' == 'Yes'
            Set Calc VP Expected Result With Original And Source
            ...    Post_Policy_Loan_Request_Amount
            ...    ${VP_LoanRequestAmount.strip()}
            ...    ${VP_LoanRequestAmount.strip()}
            ...    OWB Application
    #    Set Calc VP Expected Result With Original And Source    Post_Policy_Payable_Amount    ${VP_LoanRequestAmount.strip()}    ${VP_LoanRequestAmount.strip()}    OWB Application
    #        Set Calc VP Expected Result With Original And Source
    #        ...    Post_Bank_Account_Number
    #        ...    ${mVP_BankAccountNumber.strip()}
    #        ...    ${VP_BankAccountNumber}
    #        ...    OWB Application
    #        Set Calc VP Expected Result With Original And Source
    #        ...    Post_Bank_Name
    #        ...    ${VP_BankName.strip()}
    #        ...    ${VP_BankName}
    #        ...    OWB Application
        END
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status_After_OPUS
        ...    ${Approved_Status.strip()}
        ...    ${Approved_Status}
        ...    OPUS_Application
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Flow of ${Insurance_Flow}
    END