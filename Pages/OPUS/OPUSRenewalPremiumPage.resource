*** Settings ***
Library     SeleniumLibrary
Library     String
Library     Collections
#Resource    ../../PageObjects/OWB/LoginPageObject.resource
Resource    ../../CustomLibraries/Common.robot
# Resource    ../../PageObjects/OWB/PaymentRealatedServiceVerifactionPointObject.resource
Resource    ../../PageObjects/OPUS/OPUSRenewalPremiumPageObject.resource


*** Keywords ***
OPUS Renewal premium
    TRY
        Take OPUS Screenshot    OPSU Renewal Payment Page
        Wait Until Element Is Visible    ${EN_OPUS_RequestDate}    10s
        Scroll Element Into View    ${EN_OPUS_RequestDate}
        ${VP_Completion_Date}    Get Element Attribute    ${EN_OPUS_RequestDate}      attribute=value
        Wait Until Element Is Visible    ${EN_OPUS_Payment_Reference_Number}    10s
        Scroll Element Into View    ${EN_OPUS_Payment_Reference_Number}
        ${EN_OPUS_Payment_Reference_Number}    Get Element Attribute     ${EN_OPUS_Payment_Reference_Number}    attribute=value
        ${EN_OPUS_Payment_Method}    Get Element Attribute    ${EN_OPUS_Payment_Method}    attribute=value
        ${Payment_Amount}    Get Element Attribute    ${EN_OPUS_Payment_Amount}    attribute=value
        Take OPUS Screenshot    OPSU Renewal Payment Page
    #    ${s_PaymentAmount}    Set Variable    ${Payment_Amount}
    #    @{l_PaymentAmount}    Split String    ${s_PaymentAmount}    THB
    #    ${EN_OPUS_PaymentAmount}    Get From List    ${l_PaymentAmount}    0
        ${EN_OPUS_PaymentStatus}    Get Element Attribute     ${EN_OPUS_PaymentStatus}    attribute=value
        ${VP_TransactionStatus}    Get Text    ${EN_OPUS_TransactionStatus}
        Set Calc VP Actual Result With Original And Source
            ...    Transaction_Status
            ...    ${VP_TransactionStatus}
            ...    ${VP_TransactionStatus}
            ...    OPUS Application
            Set Global Variable    ${VP_TransactionStatus}
            ${Final_Approve_Status}         Set Variable                 ${VP_TransactionStatus}
            Set Global Variable    ${Final_Approve_Status}

        Set Calc VP Actual Result With Original And Source
        ...    Completion_Date
        ...    ${VP_Completion_Date.strip()}
        ...    ${VP_Completion_Date}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    Payment_Reference_Number
        ...    ${EN_OPUS_Payment_Reference_Number.strip()}
        ...    ${EN_OPUS_Payment_Reference_Number}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    Payment_Method
        ...    ${EN_OPUS_Payment_Method.strip()}
        ...    ${EN_OPUS_Payment_Method}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    Premium_Payment_Amount
        ...    ${Payment_Amount.strip()}
        ...    ${Payment_Amount}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    Transaction_Status
        ...    ${EN_OPUS_PaymentStatus.strip()}
        ...    ${EN_OPUS_PaymentStatus}
        ...    OPUS Application
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       OPUS_Flow   ${reason}   OPUS  ${Insurance_Flow}
    END