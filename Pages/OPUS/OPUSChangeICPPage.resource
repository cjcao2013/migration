*** Settings ***
Library     AppiumLibrary
Library     ../../Qrace/QraceHelper.py
Resource    ../../CustomLibraries/common.robot

Resource    ../../PageObjects/OPUS/OPUSChangeICPPageObject.resource
Resource    ../../PageObjects/OPUS/OPUSAssignTaskPageObject.resource
Resource   OPUSInquiryPage.resource

*** Keywords ***
OPUS Preferred payout
     TRY
        Wait Until Page Contains Element   ${EN_OPUS_NewPayoutOption}    timeout=20s
        Scroll Element Into View    ${EN_OPUS_NewPayoutOption}
        ${VP_PayoutOption}    Get Text   ${EN_OPUS_NewPayoutOption}
        ${VP_CompletionDate}    Get Text     ${EN_CompletionDateOpus}
        IF    '${Cash_Payout_Option}' == 'Bank transfer' or '${Cash_Payout_Option}' == 'Premium settlement'
             ${VP_BankName}    Get Text     ${EN_OPUSBank_Name}
            ${BankName}    Split String    ${VP_BankName}
            ${leng}    Get Length    ${BankName}
            IF    '${leng}' < '3'
                ${VP_BankName}    Split String    ${VP_BankName}    -
                ${VP_BankName}    Get From List    ${VP_BankName}    1
            END


            ${VP_Account_No}    Get Element Attribute    ${EN_OPUS_Account_No}          attribute=title
            ${mVP_Account_No}    Get Substring    ${VP_Account_No}    -4
        END

        ${mVP_PayoutOption}    Convert To Title Case    ${VP_PayoutOption}

        ${VP_TransactionStatus}    Get Text    ${EN_TransactionStatus}
        Take OPUS Screenshot    OPUS ICP Page
        Set Calc VP Actual Result With Original And Source
        ...    Transaction_Status
        ...    ${VP_TransactionStatus}
        ...    ${VP_TransactionStatus}
        ...    OPUS Application
        Set Global Variable    ${VP_TransactionStatus}
        ${Final_Approve_Status}         Set Variable                 ${VP_TransactionStatus}
        Set Global Variable    ${Final_Approve_Status}
        IF    '${CashPayout_Option}' == 'PromptPay'
             ${mVP_PayoutOption}    Remove String   ${mVP_PayoutOption}     ${SPACE}
        END

         Set Calc VP Actual Result With Original And Source
        ...    New_Payout_Option
        ...    ${mVP_PayoutOption.strip()}
        ...    ${VP_PayoutOption}
        ...    OPUS Application

        IF    '${Cash_Payout_Option}' == 'Bank transfer'
            Set Calc VP Actual Result With Original And Source
            ...    Bank_Name
            ...    ${VP_BankName}
            ...    ${VP_Bank_Name}
            ...    OPUS Application

            Set Calc VP Actual Result With Original And Source
            ...    Account_No
            ...    ${mVP_Account_No.strip()}
            ...    ${VP_Account_No}
            ...    OPUS Application
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Flow of ${Insurance_Flow}
    END