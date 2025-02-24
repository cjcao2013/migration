*** Settings ***
Library     SeleniumLibrary
Resource    ../../PageObjects/OWB/LoginPageObject.resource
Resource    ../../CustomLibraries/Common.robot
# Resource    ../../PageObjects/OWB/PaymentRealatedServiceVerifactionPointObject.resource
Resource    ../../PageObjects/OWB/OWBPaymentMethodPageObject.resource


*** Keywords ***
OWB Recurring payment
    ${VP_Completion_Date}    Get Element Attribute    ${EN_VP_CompletionDate}    attribute=title
    ${VP_Card_HolderName}    Get Element Attribute    ${EN_OWB_CardHolderName}    attribute=title
    ${VP_Card_Number}    Get Element Attribute    ${EN_OWB_CardNumber}    attribute=title
    ${mVP_Card_Number}    Get Substring    ${VP_Card_Number}    -4
    ${VP_Card_Type}    Get Element Attribute    ${EN_OWB_cardTyppe}    attribute=title
    ${VP_Card_ExpiryDateMM}    Get Element Attribute    ${EN_OWB_CardExpiryDateMM}    attribute=title
    ${VP_Card_ExpiryDateYY}    Get Element Attribute    ${EN_OWB_CardExpiryDateYY}    attribute=title
    ${mVP_Card_ExpiryDateYY}    Get Substring    ${VP_Card_ExpiryDateYY}    -2
#    Set Calc VP Actual Result With Original And Source    Policy_Name    ${VP_PolicyName}    ${VP_PolicyName}    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Completion_Date
    ...    ${VP_Completion_Date.strip()}
    ...    ${VP_Completion_Date}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Card_Holder_Name
    ...    ${VP_Card_HolderName.strip()}
    ...    ${VP_Card_HolderName}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Card_Number
    ...    ${mVP_Card_Number.strip()}
    ...    ${VP_Card_Number}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Card_ExpiryDate_Month
    ...    ${VP_Card_ExpiryDateMM.strip()}
    ...    ${VP_Card_ExpiryDateMM}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Card_ExpiryDate_Year
    ...    ${mVP_Card_ExpiryDateYY.strip()}
    ...    ${VP_Card_ExpiryDateYY}
    ...    OWB Application
    IF    '${STP_Status}' == 'Yes'
        Set Calc VP Actual Result With Original And Source
        ...    Post_Card_Number
        ...    ${mVP_Card_Number.strip()}
        ...    ${VP_Card_Number}
        ...    OWB Application
        Set Calc VP Actual Result With Original And Source
        ...    Post_Card_ExpiryDate_Month
        ...    ${VP_Card_ExpiryDateMM.strip()}
        ...    ${VP_Card_ExpiryDateMM}
        ...    OWB Application
        Set Calc VP Actual Result With Original And Source
        ...    Post_Card_ExpiryDate_Year
        ...    ${mVP_Card_ExpiryDateYY.strip()}
        ...    ${VP_Card_ExpiryDateYY}
        ...    OWB Application
    END