*** Settings ***
Library     SeleniumLibrary
Library     QraceHelper
Resource    ../../PageObjects/OWB/OWBInquiryPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    ../../Qrace/QraceHelper.py
Resource    ../../PageObjects/OWB/OWBFreelookupCancellationPageObjects.resource


*** Keywords ***
OWB Cancel
    Wait Until Element Is Visible    ${EN_cancelReason}
    Take OWB Screenshot    Freelook Cancellation Page
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
#    ${VP_surrenderFactaStatus}    Get Text    ${EN_surrenderFactaStatus}
    ${VP_surrenderPolicyNo}    Get Element Attribute    ${EN_surrendertPolicyNo}    attribute=title
    ${VP_cancel_reason}    Get Element Attribute    ${EN_cancelReason}    attribute=title
    ${VP_SurrenderProductName}    Get Element Attribute    ${EN_SurrendertProductName}    attribute=title
#    IF    '${VP_SurrenderProductName}' != 'FWD Golden 7 Investment-linked Insurance'
#    @{VP_surrenderProductName}    Split String    ${VP_surrenderProductName}    -
#    ${VP_surrenderProductName}    Get From List    ${VP_surrenderProductName}    0
#    END
    ${VP_completiondate}    Get Element Attribute    ${EN_Surrendertcompletiondate}    attribute=title
#    ${VP_graceStartDate}    Get Element Attribute    ${EN_GracePeriod_StartDate}    attribute=title
#    ${VP_graceEndDate}    Get Element Attribute    ${EN_GracePeriod_EndDate}    attribute=title

#    Scroll Element Into View    ${EN_surrenderFactaStatus}
    Sleep    2s
    Take OWB Screenshot    Freelook Cancellation Page

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
    ...    Cancellation Reason
    ...    ${VP_cancel_reason.strip()}
    ...    ${VP_cancel_reason.strip()}
    ...    OWB_Application
#    Set Calc VP Actual Result With Original And Source    GracePeriod Start Date    ${VP_graceStartDate.strip()}    ${VP_graceStartDate.strip()}    OWB_Application
#    Set Calc VP Actual Result With Original And Source    GracePeriod End Date    ${VP_graceEndDate.strip()}    ${VP_graceEndDate.strip()}    OWB_Application

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
    ...    Post_Transaction Cancellation Reason
    ...    ${VP_cancel_reason.strip()}
    ...    ${VP_cancel_reason.strip()}
    ...    OWB_Application
#    Set Calc VP Expected Result With Original And Source    Post_Transaction GracePeriod Start Date    ${VP_graceStartDate.strip()}    ${VP_graceStartDate.strip()}    OWB_Application
#    Set Calc VP Expected Result With Original And Source    Post_Transaction GracePeriod END Date    ${VP_graceEndDate.strip()}    ${VP_graceEndDate.strip()}    OWB_Application

    ${massagedaccountnumber}    Get Substring    ${VP_BankAccountNumber}    -4
    Set Calc VP Actual Result With Original And Source
    ...    Bank Account Number
    ...    ${massagedaccountnumber}
    ...    ${VP_BankAccountNumber}
    ...    OWB Application
#    Set Calc VP Actual Result With Original And Source    FactaStaus    ${VP_surrenderFactaStatus}    ${VP_surrenderFactaStatus}    OWB Application
    Set Calc VP Expected Result With Original And Source
    ...    Post_Transaction Bank Account Number
    ...    ${massagedaccountnumber}
    ...    ${VP_BankAccountNumber}
    ...    OWB Application
#    Set Calc VP Expected Result With Original And Source    Post_Transaction FactaStaus    ${VP_surrenderFactaStatus}    ${VP_surrenderFactaStatus}    OWB Application

    Set Calc VP Expected Result With Original And Source
    ...    Completion Date
    ...    ${VP_completiondate.strip()}
    ...    ${VP_completiondate.strip()}
    ...    OWB Application
