*** Settings ***
Library     SeleniumLibrary
Resource    ../../PageObjects/OWB/LoginPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    ../../PageObjects/OWB/OWBDeleteRidersPageObjects.resource


*** Keywords ***
OWB Delete rider(s)
    Wait Until Element Is Visible    ${EN_OWBProductCode}    timeout=90s
    ${VP_ProductCode}    Get Element Attribute    ${EN_OWBProductCode}    attribute=title
    ${VP_productName}    Get Element Attribute    ${EN_OWBproductName}    attribute=title
    Wait Until Element Is Visible    ${EN_OWBbankName}    timeout=90s
    ${VP_holderName}    Get Element Attribute    ${EN_OWBholderName}    attribute=title
    ${VP_BankName}    Get Element Attribute    ${EN_OWBbankName}    attribute=title
    ${BankName}    Split String    ${VP_BankName}
    ${leng}    Get Length    ${BankName}
    IF    '${leng}' < '3'
        ${VP_BankName}    Split String    ${VP_BankName}    -
        ${VP_BankName}    Get From List    ${VP_BankName}    1
        ${VP_BankName}    Strip String    ${VP_BankName}
    END
    ${VP_BankAccNumber}    Get Element Attribute    ${EN_OWBaccountNumber}    attribute=title
    ${InputCardNumber}    Get Substring    ${VP_BankAccNumber}    -4
    ${VP_completiondate}    Get Element Attribute    ${EN_ridercompletiondate}    attribute=title
    ${VP_riderCode}    Get Element Attribute    ${EN_DeleteriderProductName}    attribute=title
    ${VP_PolicyNo}    Get Element Attribute    ${EN_riderPolicyNo}    attribute=title

    Set Calc VP With Source And Original Values
    ...    PolicyNumber
    ...    ${Policy_No}
    ...    ${VP_PolicyNo}
    ...    TestData
    ...    OWB Application
    ...    ${Policy_No}
    ...    ${VP_PolicyNo}
#    Set Calc VP Actual Result With Original And Source    Bank Account Holder Name    ${VP_holderName.strip()}    ${VP_holderName}    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Bank Name
    ...    ${VP_BankName.strip()}
    ...    ${VP_BankName.strip()}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Rider to delete
    ...    ${VP_riderCode.strip()}
    ...    ${VP_riderCode.strip()}
    ...    OWB_Application
    Set Calc VP Actual Result With Original And Source
    ...    Bank Account Number
    ...    ${InputCardNumber.strip()}
    ...    ${VP_BankAccNumber}
    ...    OWB Application

    # post transaction
    Set Calc VP Expected Result With Original And Source
    ...    Post_Transaction Bank Name
    ...    ${VP_BankName}
    ...    ${VP_BankName}
    ...    OWB Application
    Set Calc VP Expected Result With Original And Source
    ...    Post_Transaction Rider to delete
    ...    ${VP_riderCode.strip()}
    ...    ${VP_riderCode.strip()}
    ...    OWB_Application
    Set Calc VP Expected Result With Original And Source
    ...    Post_Transaction Bank Account Number
    ...    ${InputCardNumber.strip()}
    ...    ${VP_BankAccNumber}
    ...    OWB Application
    Set Calc VP Expected Result With Original And Source
    ...    Completion Date
    ...    ${VP_completiondate.strip()}
    ...    ${VP_completiondate.strip()}
    ...    OWB Application
