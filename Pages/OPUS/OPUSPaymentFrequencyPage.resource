*** Settings ***
Library     SeleniumLibrary
Library     QraceHelper
Resource    ../../PageObjects/OPUS/OPUSInquiryPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    ../../PageObjects/OPUS/OPUSPaymentFrequencyPageObject.resource
Resource    OPUSInquiryPage.resource


*** Keywords ***
OPUS frequency
    TRY
        Change Decision Status if Non STP
        Wait Until Element Is Visible    ${EN_currentPaymentFrequency}            timeout=100s
        Take OPUS Screenshot    Payment frequency Page
        ${VP_currentFrequency}    Get Text    ${EN_currentPaymentFrequency}
        ${VP_New_Payment_Frequency}    Get Element Attribute     ${EN_NewPaymentFrequency}        attribute=title
        ${VP_NewModalPremium}    Get Element Attribute     ${EN_NewModalPremiumAmt}        attribute=title
        ${VP_frequencyPolicyNo}    Get Element Attribute    ${EN_paymentfrequencyPolicyNo}    attribute=title
        ${MVP_NewModalPremium}    Remove String    ${VP_NewModalPremium}    ,
        ${MVP_NewModalPremium}    Evaluate    "{:.2f}".format(${MVP_NewModalPremium})
        # add vp
        IF    '${VP_New_Payment_Frequency}' == 'Annual'
            ${mVP_New_Payment_Frequency}    Set Variable    Yearly
            Set Calc VP Actual Result With Original And Source
            ...    Transaction_New_Payment_Frequency
            ...    ${mVP_New_Payment_Frequency}
            ...    ${VP_New_Payment_Frequency}
            ...    OPUS Application
            Set Calc VP Expected Result With Original And Source
            ...    Post Transaction New_Payment_Frequency
            ...    ${mVP_New_Payment_Frequency}
            ...    ${VP_New_Payment_Frequency}
            ...    OPUS Application
        ELSE IF    '${VP_New_Payment_Frequency}' == 'Half Annual'
            ${mVP_New_Payment_Frequency}    Set Variable    Half yearly
            Set Calc VP Actual Result With Original And Source
            ...    Transaction_New_Payment_Frequency
            ...    ${mVP_New_Payment_Frequency}
            ...    ${VP_New_Payment_Frequency}
            ...    OPUS Application
            Set Calc VP Expected Result With Original And Source
            ...    Post Transaction New_Payment_Frequency
            ...    ${mVP_New_Payment_Frequency}
            ...    ${VP_New_Payment_Frequency}
            ...    OPUS Application
        ELSE
            Set Calc VP Actual Result With Original And Source
            ...    Transaction_New_Payment_Frequency
            ...    ${VP_New_Payment_Frequency}
            ...    ${VP_New_Payment_Frequency}
            ...    OPUS Application
            Set Calc VP Expected Result With Original And Source
            ...    Post Transaction New_Payment_Frequency
            ...    ${VP_New_Payment_Frequency}
            ...    ${VP_New_Payment_Frequency}
            ...    OPUS Application
        END

        Set Calc VP Actual Result With Original And Source
        ...    OLD_Payment_Frequency
        ...    ${VP_currentFrequency}
        ...    ${VP_currentFrequency}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    Policy No
        ...    ${VP_frequencyPolicyNo}
        ...    ${VP_frequencyPolicyNo}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    Transaction_New_Premium_Amount
        ...    ${MVP_NewModalPremium}
        ...    ${VP_NewModalPremium}
        ...    OPUS Application
        Set Calc VP Expected Result With Original And Source
        ...    Post Transaction New_Premium_Amount
        ...    ${MVP_NewModalPremium}
        ...    ${VP_NewModalPremium}
        ...    OPUS Application
        ${Approved_Status}    Get Element Attribute    ${EN_frequencyStatus}       attribute=title
        Set Global Variable    ${Approved_Status}
        ${Final_Approve_Status}         Set Variable                 ${Approved_Status}
        Set Global Variable    ${Final_Approve_Status}
        Set Global Variable    ${Approved_Status}
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status_After_OPUS
        ...    ${Approved_Status.strip()}
        ...    ${Approved_Status}
        ...    OPUS_Application
        Click Element    xpath=//button[@data-trigger='submit']
        Sleep    2s
        Take OPUS Screenshot    OPUS Inquiry
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       OPUS_Flow   ${reason}   OPUS  ${Insurance_Flow}
    END

