*** Settings ***
Library     SeleniumLibrary
Resource    ../../PageObjects/OWB/LoginPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    ../../PageObjects/OWB/OWBCancelSurrenderPolicyPageObjects.resource


*** Keywords ***
OWB surrender policy
    ${VP_holderName}    Get Element Attribute    ${EN_holderName}    attribute=value
    ${VP_BankName}    Get Element Attribute    ${EN_BankName}    attribute=value
    ${BankName}    Split String    ${VP_BankName}
    ${leng}    Get Length    ${BankName}
    IF    '${leng}' < '3'
        ${VP_BankName}    Split String    ${VP_BankName}    -
        ${VP_BankName}    Get From List    ${VP_BankName}    1
        ${VP_BankName}    Strip String    ${VP_BankName}
    END
    ${VP_BankAccountNumber}    Get Element Attribute    ${EN_BankAccountNumber}    attribute=value
    ${massagedaccountnumber}    Get Substring    ${VP_BankAccountNumber}    -4
    ${VP_surrenderPolicyNo}    Get Element Attribute    ${EN_surrendertPolicyNo}    attribute=title
    ${VP_Surrender_reason}    Get Element Attribute    ${EN_surrenderReason}    attribute=title
    ${VP_SurrenderProductName}    Get Element Attribute    ${EN_SurrendertProductName}    attribute=title
    @{VP_surrenderProductName}    Split String    ${VP_surrenderProductName}    -
    ${VP_surrenderProductName}    Get From List    ${VP_surrenderProductName}    0
    ${VP_completiondate}    Get Element Attribute    ${EN_Surrendertcompletiondate}    attribute=title

#    Scroll Element Into View    ${EN_surrenderFactaStatus}
    Sleep    2s
    Take OWB Screenshot    Surrender Page

    Set Calc VP With Source And Original Values
    ...    PolicyNumber
    ...    ${Policy_No}
    ...    ${VP_surrenderPolicyNo}
    ...    TestData
    ...    OWB Application
    ...    ${Policy_No}
    ...    ${VP_surrenderPolicyNo}
    Set Calc VP Actual Result With Original And Source
    ...    Policy_Applied
    ...    ${VP_surrenderProductName.strip()}
    ...    ${VP_surrenderProductName.strip()}
    ...    OWB Application
#    Set Calc VP Actual Result With Original And Source    Bank Account Holder Name    ${VP_holderName}    ${VP_holderName}    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Bank Name
    ...    ${VP_BankName}
    ...    ${VP_BankName}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Surrender Reason
    ...    ${VP_Surrender_reason.strip()}
    ...    ${VP_Surrender_reason.strip()}
    ...    OWB_Application
    Set Calc VP Actual Result With Original And Source
    ...    Bank Account Number
    ...    ${massagedaccountnumber}
    ...    ${massagedaccountnumber}
    ...    OWB Application

    # post transaction
    Set Calc VP Expected Result With Original And Source
    ...    Post_Transaction Policy_Applied
    ...    ${VP_surrenderProductName.strip()}
    ...    ${VP_surrenderProductName.strip()}
    ...    OWB Application
    Set Calc VP Expected Result With Original And Source
    ...    Post_Transaction Bank Name
    ...    ${VP_BankName}
    ...    ${VP_BankName}
    ...    OWB Application
    Set Calc VP Expected Result With Original And Source
    ...    Post_Transaction Surrender Reason
    ...    ${VP_Surrender_reason.strip()}
    ...    ${VP_Surrender_reason.strip()}
    ...    OWB_Application
    ${massagedaccountnumber}    Get Substring    ${VP_BankAccountNumber}    -4

    Set Calc VP Expected Result With Original And Source
    ...    Post_Transaction Bank Account Number
    ...    ${massagedaccountnumber}
    ...    ${VP_BankAccountNumber}
    ...    OWB Application
    Set Calc VP Expected Result With Original And Source
    ...    Completion Date
    ...    ${VP_completiondate.strip()}
    ...    ${VP_completiondate.strip()}
    ...    OWB Application
