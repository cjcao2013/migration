*** Settings ***
Library     SeleniumLibrary
Library     String
Library     Collections
Resource    ../../CustomLibraries/Common.robot
Resource    ../../PageObjects/OPUS/OPUSChequeCancellationPageObject.resource
Resource    ../../PageObjects/OPUS/OPUSTaskInquiryPageObjects.resource
Resource    OPUSInquiryPage.resource


*** Keywords ***
OPUS Cheque cancellation
    TRY
        Wait Until Element Is Visible    ${EN_RequestDate}    timeout=10s
        Scroll Element Into View    ${EN_RequestDate}
        ${VP_Completion_Date}    Get Element Attribute    ${EN_RequestDate}      attribute=value

        ${VP_OPUS_ChequeType}    Get Element Attribute     ${EN_ChequeType}    attribute=title
        ${OPUS_CancellationReason}    Get Element Attribute      ${EN_ChequeCancellationReason}    attribute=title
        IF    '${OPUS_CancellationReason}' == 'Lost cheque/draft'
            ${m_OPUS_CancellationReason}    Set Variable    Lost cheque or draft
        END

        ${VP_OPUS_Payable_Amount}    Get Element Attribute    ${EN_PayableAmount}    attribute=value
        ${Final_Approve_Status}     Get Element Attribute    ${EN_TransactionStatusAfterOpus}     attribute=tilte
        Set Global Variable     ${Final_Approve_Status}
        IF    '${Payment_Method}' == 'PromptPay'
            ${promtpay}    Set Variable    Prompt Pay
            ${VP_Paymethod}    Get Text    xpath=//span[text()='${promtpay}']
        ELSE
             ${VP_Paymethod}    Get Text    xpath=//span[text()='${Payment_Method}']
        END
        Set Calc VP Actual Result With Original And Source
        ...    Transaction_CancellationReason
        ...    ${m_OPUS_CancellationReason.strip()}
        ...    ${m_OPUS_CancellationReason.strip()}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    Transaction_ChequeType
        ...    ${VP_OPUS_ChequeType.strip()}
        ...    ${VP_OPUS_ChequeType.strip()}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    Transaction_AmountPayable
        ...    ${VP_OPUS_Payable_Amount.strip()}
        ...    ${VP_OPUS_Payable_Amount.strip()}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    Transaction_PaymentMethod
        ...    ${VP_Paymethod.strip()}
        ...    ${VP_Paymethod.strip()}
        ...    OPUS Application

        Change Decision Status if Non STP
        Wait Until Page Contains Element    xpath=//button[@data-trigger='submit']      timeout=20s
        Click Element    xpath=//button[@data-trigger='submit']
        Sleep    5s
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Flow of ${Insurance_Flow}
    END

