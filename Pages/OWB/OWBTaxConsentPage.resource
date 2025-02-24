*** Settings ***
Library     SeleniumLibrary
Resource    ../../PageObjects/OWB/LoginPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    ../../PageObjects/OWB/OWBTaxConsentPageObjects.resource


*** Keywords ***
OWB Tax consent
    ${VP_OWB_TaxconsentOption}    Get Text    ${EN_TaxconsentOption}
    ${VP_TaxconsentPolicyDetails}    Get Text    ${EN_TaxconsentPolicyDetails}

    ${VP_OWB_Policy_Name}    Remove String    ${VP_TaxconsentPolicyDetails}    ${Policy_No}
    Log To Console    PolicyName=${VP_OWB_Policy_Name}

    ${VP_OWB_PolicyNumber}    Remove String    ${VP_TaxconsentPolicyDetails}    ${VP_OWB_Policy_Name}
    Log To Console    PolicyNumber=${VP_OWB_PolicyNumber}

    ${VP_Completion_Date}    Get Element Attribute    ${EN_VP_CompletionDate}    attribute=title

    Set Calc VP Actual Result With Original And Source
    ...    TaxConsent_Option
    ...    ${VP_OWB_TaxconsentOption.strip()}
    ...    ${VP_OWB_TaxconsentOption}
    ...    OWB Application
#    Set Calc VP Actual Result With Original And Source    TaxConsent_PolicyNumber    ${VP_OWB_PolicyNumber.strip()}    ${VP_OWB_PolicyNumber}    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    TaxConsent_PolicyName
    ...    ${VP_OWB_Policy_Name.strip()}
    ...    ${VP_OWB_Policy_Name}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Completion_Date
    ...    ${VP_Completion_Date.strip()}
    ...    ${VP_Completion_Date}
    ...    OWB Application
    Take OWB Screenshot    Tax Consent Page
