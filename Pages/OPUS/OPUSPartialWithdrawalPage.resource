*** Settings ***
Library     SeleniumLibrary
Library     Dialogs
Library     QraceHelper
Library    String
Resource    ../../PageObjects/OPUS/OPUSInquiryPageObject.resource
Resource    ../../PageObjects/OPUS/OPUSPartialWithdrawalPageObject.resource


*** Keywords ***
OPUS Partial withdrawal
    TRY
        Wait Until Element Is Visible    ${EN_OPUS_CaseNo}       timeout=50s
        Take OPUS Screenshot        OPUSAssignPage
        ${OPUS_Case_No}     Get Text    ${EN_OPUS_CaseNo}
        Set Global Variable    ${OPUS_Case_No}
        ${Approved_Status}      Get Text    ${EN_OPUS_DecisionStatus}
        ${VP_Completion_Date}      Get Value     ${EN_OPUS_RequestDate}
        Scroll Element Into View    ${EN_OPUS_DecisionStatus}
        Take OPUS Screenshot        OPUSAssignPage
        IF    '${OPUSTransactionstatus}' == 'In progress'
            Click Element    ${EN_OPUS_DecisionStatus}
            Sleep    0.5s
            Click Element    xpath=//li[text()='${CaseStatus}']
            Sleep    0.5s
            IF    '${CaseStatus}' == 'Decline'
                Click Element    ${EN_DelineReason}
                Sleep    0.5s
                Click Element    ${EN_DeclineReason_txt}
                Sleep    0.5s
                Input Text    ${EN_EditDeclineReason}    Testing Purpose
                Sleep    0.5s
                Take OPUS Screenshot        OPUSAssignPage
            END

            Sleep    0.5s
            Click Element    ${EN_Save_Btn}
        END
        Take OPUS Screenshot        OPUSPartialWithdrawalPage
        Set Global Variable    ${Approved_Status}
        ${Final_Approve_Status}     Set Variable     ${Approved_Status}
        Set Global Variable    ${Final_Approve_Status}
        Scroll Element Into View    ${${lang}_OPUS_totalFundCount}
        Wait Until Element Is Visible    ${${lang}_OPUS_totalFundCount}
        Take OPUS Screenshot    OPUSPartialWithdrawalPage
        ${VP_totalFundlist}    Get Webelements    ${${lang}_OPUS_totalFundCount}
        ${VP_fundcount}    Get Length    ${VP_totalFundlist}
        ${fundcounter}    Set Variable    1
        FOR    ${counter}    IN RANGE    0    ${VP_fundcount}-1

            ${VP_Fund}    Get Element Attribute
            ...    xpath=(//div[text()="Fund"])[1]/following::div[${fundcounter}]
            ...    attribute=title
            ${VP_FundName}    Get Substring    ${VP_Fund}    5
            ${Fund_Name}    Set Variable    ${VP_FundName}

            ${VP_UnitHolding}    Get Element Attribute
            ...    xpath=//input[@id="unitHolding"][${fundcounter}]
            ...    attribute=title

            ${VP_CurrentValue}    Get Element Attribute
            ...    xpath=//input[@id="accountValue"][${fundcounter}]
            ...    attribute=value

            ${VP_WithdrawalAmount}    Get Element Attribute
            ...    xpath=//input[@id="totalAmount"][${fundcounter}]
            ...    attribute=value
            ${VP_WithdrawalAmount}    Remove String    ${VP_WithdrawalAmount}    ,
            ${VP_WithdrawalAmount}    Remove String    ${VP_WithdrawalAmount}    THB
            ${VP_WithdrawalAmount}      Strip String    ${VP_WithdrawalAmount}
            ${VP_WithdrawalAmount}    Evaluate    "{:.2f}".format(${VP_WithdrawalAmount.strip()})

            ${VP_CurrentValue}    Remove String    ${VP_CurrentValue}    ,
    #    ${VP_CurrentValue}    Evaluate    "{:.2f}".format(${VP_CurrentValue.strip()})
            Set Calc VP Actual Result With Original And Source
            ...    Fund_${fundcounter}_Current_Value
            ...    ${VP_CurrentValue}
            ...    ${VP_CurrentValue}
            ...    OPUS

            Set Calc VP Actual Result With Original And Source
            ...    Fund_${fundcounter}_Withdrawal_Amount
            ...    ${VP_WithdrawalAmount.strip()}
            ...    ${VP_WithdrawalAmount.strip()}
            ...    OPUS

            ${fundcounter}    Evaluate    ${fundcounter}+1
        END
        ${VP_TotalWithdrwalAmount}    Get Element Attribute    ${EN_OPUS_TotalWithdrwalAmount}      attribute=title
        ${VP_TotalWithdrwalAmount}    Remove String    ${VP_TotalWithdrwalAmount}    ,
        ${VP_TotalWithdrwalAmount}    Remove String    ${VP_TotalWithdrwalAmount}    THB
        ${VP_TotalWithdrwalAmount}      Strip String    ${VP_TotalWithdrwalAmount}
        ${VP_TotalWithdrwalAmount}    Evaluate    "{:.2f}".format(${VP_TotalWithdrwalAmount})
        Set Calc VP Actual Result With Original And Source
        ...    Total_Withdrawal_Amount
        ...    ${VP_TotalWithdrwalAmount.strip()}
        ...    ${VP_TotalWithdrwalAmount.strip()}
        ...    OPUS
        Set Calc VP Expected Result With Original And Source
        ...    Post_Transaction_Total_Withdrawal_Amount
        ...    ${VP_TotalWithdrwalAmount.strip()}
        ...    ${VP_TotalWithdrwalAmount.strip()}
        ...    OPUS
        ${Approved_Status}      Get Text    ${EN_OPUS_DecisionStatus}
        ${Final_Approve_Status}     Set Global Variable    ${Approved_Status}
        ${VP_Completion_Date}      Get Value     ${EN_OPUS_RequestDate}
    #    Set Calc VP Expected Result With Original And Source    PostTransaction_Status    ${Approved_Status}    ${Approved_Status}    OPUS Application
        Set Calc VP With Source And Original Values
        ...    ApprovalStatus
        ...    ${CaseStatus}
        ...    ${Approved_Status}
        ...    Static
        ...    OPUS
        ...    ${CaseStatus}
        ...    ${Approved_Status}
        Set Global Variable    ${Approved_Status}
        Take OPUS Screenshot    Partial Withdrwal Page
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status_After_OPUS
        ...    ${Approved_Status.strip()}
        ...    ${Approved_Status}
        ...    OPUS_Application

        ${Final_Approve_Status}     Set Variable     ${Approved_Status}
        Set Global Variable    ${Final_Approve_Status}

        #submit the transaction
        IF    '${OPUSTransactionstatus}' == 'In progress'
            Wait Until Element Is Visible    ${EN_Submit_btn}       timeout=10s
            Click Element    ${EN_Submit_btn}
            Sleep    6s
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       OPUS_Flow   ${reason}   OPUS  ${Insurance_Flow}
    END