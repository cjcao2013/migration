*** Settings ***
Library     AppiumLibrary
Resource    ../../PageObjects/OWB/OWBICPOptionPageObjects.resource


*** Keywords ***
OWB ICP option
    Wait Until Element Is Visible    ${EN_VP_CurrentPayoutOtion}    timeout=5s
    ${VP_CurrentPayoutOtion}    Get Element Attribute    ${EN_VP_CurrentPayoutOtion}    attribute=title
    ${VP_PayoutOption}    Get Element Attribute    ${EN_VP_PayoutOption}    attribute=title
    ${VP_NationalID}    Get Element Attribute    ${EN_VP_NationalID}    attribute=title
    ${VP_CompletionDate}    Get Element Attribute    ${EN_VP_CompletionDate}    attribute=title
    ${VP_BankName}    Get Element Attribute    ${EN_OWBbankName}    attribute=title
    ${BankName}    Split String    ${VP_BankName}
    ${leng}    Get Length    ${BankName}
    IF    '${leng}' < '3'
        ${VP_BankName}    Split String    ${VP_BankName}    -
        ${VP_BankName}    Get From List    ${VP_BankName}    1
    END
    ${VP_Account_No}    Get Element Attribute    ${EN_VP_Account_No}    attribute=title
    ${mVP_Account_No}    Get Substring    ${VP_Account_No}    -4
    ${mVP_CurrentPayoutOtion}    Convert To Lower Case    ${VP_CurrentPayoutOtion}
    ${mVP_PayoutOption}    Convert To Lower Case    ${VP_PayoutOption}

    Set Calc VP Actual Result With Original And Source
    ...    New_Payout_Option
    ...    ${mVP_PayoutOption.strip()}
    ...    ${VP_PayoutOption}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Current_Payout_Option
    ...    ${mVP_CurrentPayoutOtion.strip()}
    ...    ${VP_CurrentPayoutOtion}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Bank_Name
    ...    ${VP_BankName}
    ...    ${VP_Bank_Name}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Completion_Date
    ...    ${VP_CompletionDate}
    ...    ${VP_CompletionDate}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Account_No
    ...    ${mVP_Account_No.strip()}
    ...    ${VP_Account_No}
    ...    OWB Application
