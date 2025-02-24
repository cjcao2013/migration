*** Settings ***
Library     SeleniumLibrary
Resource    ../../PageObjects/OPUS/OPUSLoginPageObject.resource
Resource    ../../PageObjects/OPUS/OPUSInquiryPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    ../../PageObjects/OPUS/OPUSRecurringCreditCardPageObject.resource
Resource    OPUSInquiryPage.resource

*** Keywords ***
OPUS Recurring payment
    TRY
        Wait Until Element Is Visible    ${EN_OPUS_CaseNo}       timeout=50s
        Take OPUS Screenshot        Recurring Credit Card
        ${OPUS_Case_No}     Get Text    ${EN_OPUS_CaseNo}
        Set Global Variable    ${OPUS_Case_No}
        ${status}       Run Keyword And Return Status    ${EN_CreditCardHolderNmae}
        IF    '${status}' != 'True'
                  Scroll Element Into View    ${EN_CreditCardHolderNmae}
        END
        #Capture VP  for verfication
        Take OPUS Screenshot        Recurring Credit Card
        ${VP_CreditCardholderName}     Get Element Attribute    ${EN_CreditCardHolderNmae}    attribute=title
        ${VP_CreditCardNumber}         Get Element Attribute    ${EN_CreditCardNumber}   attribute=title
        ${VP_CreditCardExpiryDate}     Get Element Attribute     ${EN_CreditCardExpiryData}     attribute=value
        ${VP_completionDate}            Get Text    ${EN_RCCsubmissionDate}

        #Maassing for VP for coompare
        ${mVP_CreditCardNumber}          Get Substring    ${VP_CreditCardNumber}    -4
        @{VP_CreditCardExpiryDate}         Split String    ${VP_CreditCardExpiryDate}       /
        ${VP_CreditCardExpiryMonth}         Get From List    ${VP_CreditCardExpiryDate}    0
        ${VP_CreditCardExpiryYear}         Get From List    ${VP_CreditCardExpiryDate}    1
        ${VP_CreditCardExpiryYear}         Get Substring    ${VP_CreditCardExpiryYear}    -2
    #    IF    '${OPUSTransactionstatus}' == 'In progress'
    #        Change Decision Status if Non STP
    #    END

        ${VP_TransactionStatus}    Get Text    ${EN_TransactionStatus}
        Set Calc VP Actual Result With Original And Source
        ...    Transaction_Status
        ...    ${VP_TransactionStatus}
        ...    ${VP_TransactionStatus}
        ...    OPUS Application
        Set Global Variable    ${VP_TransactionStatus}
        ${Final_Approve_Status}         Set Variable                 ${VP_TransactionStatus}
        Set Global Variable    ${Final_Approve_Status}

        #set VP for Qrace
    #    Set Calc VP Actual Result With Original And Source
    #    ...    Completion_Date
    #    ...    ${VP_Completion_Date.strip()}
    #    ...    ${VP_Completion_Date}
    #    ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    Card_Holder_Name
        ...    ${VP_CreditCardholderName.strip()}
        ...    ${VP_CreditCardholderName}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    Card_Number
        ...    ${mVP_CreditCardNumber.strip()}
        ...    ${VP_CreditCardNumber}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    Card_ExpiryDate_Month
        ...    ${VP_CreditCardExpiryMonth.strip()}
        ...    ${VP_CreditCardExpiryMonth}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    Card_ExpiryDate_Year
        ...    ${VP_CreditCardExpiryYear.strip()}
        ...    ${VP_CreditCardExpiryYear}
        ...    OPUS Application
    #    Set Calc VP Actual Result With Original And Source
    #        ...    Post_Card_Number
    #        ...    ${mVP_CreditCardNumber.strip()}
    #        ...    ${VP_CreditCardNumber}
    #        ...    OPUS Application
    #        Set Calc VP Actual Result With Original And Source
    #        ...    Post_Card_ExpiryDate_Month
    #        ...    ${VP_CreditCardExpiryMonth.strip()}
    #        ...    ${VP_CreditCardExpiryMonth}
    #        ...    OPUS Application
    #        Set Calc VP Actual Result With Original And Source
    #        ...    Post_Card_ExpiryDate_Year
    #        ...    ${VP_CreditCardExpiryYear.strip()}
    #        ...    ${VP_CreditCardExpiryYear}
    #        ...    OPUS Application
        IF    '${OPUSTransactionstatus}' == 'In progress'
            Click Element    xpath=//button[@data-trigger='submit']
            Take OPUS Screenshot    OPUS Inquiry
        END
     EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       OPUS_Flow   ${reason}   OPUS ${Insurance_Flow}
    END