*** Settings ***
Library     SeleniumLibrary
Library     ../../CustomLibraries/DateTimeCompare.py
Library     ../DBQuery/DBQuerySelect.py
Library     DBQuerySelect
Resource    ../../PageObjects/OWB/LoginPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Library     ../Qrace/QraceHelper.py
Resource    OWBAssignTaskPage.resource
Resource    ../../PageObjects/OWB/OWBInquiryPageObject.resource
Resource    OWBValidations.resource
Resource    OWBTaxConsentPage.resource
Resource    OWBBeneficiaryDetailsPage.resource
Resource    OWBPersonalDetailsPage.resource
Resource    OWBPaymentMethodPage.resource
Resource    OWBDeleteRidersPage.resource
Resource    OWBCancelSurrenderPolicyPage.resource
Resource    OWBFreelookupCancellationPage.resource
Resource    OWBPartialWithdrawalPage.resource
Resource    OWBPaymentFrequencyPage.resource
Resource    OWBSwitchFundsPage.resource
Resource    OWBRiskProfileDetailsPage.resource
Resource    OWBClaimsPage.resource
Resource    OWBCVPolicyLoanPage.resource
Resource    OWBICPOptionPage.resource
Resource    ../../Executor/OWB/OWBExecutor.robot


*** Keywords ***
OWB Inquiry
#    Add time of transaction
    Wait Until Element Is Visible    ${EN_AdvanceSearch_link}    timeout=200s
    Take OWB Screenshot    HomePage
    Click Element    ${EN_AdvanceSearch_link}
    Take OWB Screenshot    HomePage
    Wait Until Element Is Visible    ${EN_Policy_no_txt}    timeout=200s
    Input Text    ${EN_Policy_no_txt}    ${Policy_No}
    Wait Until Element Is Visible    ${EN_RequestType}    timeout=200s
    Click Element    ${EN_RequestType}
    Wait Until Element Is Visible    ${EN_RequestInput}
    Input Text    ${EN_RequestInput}    ${Request_Type}
    Press Keys    ${EN_RequestInput}    RETURN

#    Wait Until Element Is Visible    ${EN_Input_case_no}        timeout=200s
#    Input Text    ${EN_Input_case_no}    ${owbcaseno}

    Take OWB Screenshot    PolicyInputPage
    Wait Until Element Is Visible    ${EN_Apply_btn}    timeout=200s
    Click Element    ${EN_Apply_btn}
    Take OWB Screenshot    PolicyInquiryPage
    Wait Until Element Is Visible    ${EN_NextArrow}    timeout=200s
    Click Element    ${EN_datesort}
    Click Element    ${EN_datesort}
    Sleep    3s
    Wait Until Element Is Visible
    ...    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/preceding-sibling::td)[4]
    ...    timeout=10s
    Take OWB Screenshot    PolicyInquiryPage
    ${OWB_Transaction_Time}    Get Text
    ...    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/preceding-sibling::td)[4]
    ${DatecompareResult}    Date Compare    ${OWB_Transaction_Time}    ${omnecurrent_datetime}
    ${counter}    Set Variable    0
    WHILE    '${DatecompareResult}' == 'false' and ${counter} < 20
        Click Element    ${EN_Apply_btn}
        Sleep    10s
        ${OWB_Transaction_Time}    Get Text
        ...    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/preceding-sibling::td)[4]
        ${DatecompareResult}    Date Compare    ${OWB_Transaction_Time}    ${omnecurrent_datetime}
        ${counter}    Evaluate    ${counter}+1
    END
    IF    '${DatecompareResult}' == 'false'
        Fail    Transaction Not found in OWB after 3 minutes
    END

    Wait Until Element Is Visible
    ...    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/preceding-sibling::td)[2]
    ...    timeout=200s
    ${OWB_Case_No}    Get Text
    ...    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/preceding-sibling::td)[2]//div
    Set Global Variable    ${OWB_Case_No}
    Set Calc VP Expected Result With Original And Source
    ...    OWB Case No
    ...    ${OWB_Case_No.strip()}
    ...    ${OWB_Case_No.strip()}
    ...    OWB Application
    ${requeststatus}    Get Text
    ...    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/preceding-sibling::td)[5]//div
    ${Instant_Pay}    Get Text
    ...    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/following-sibling::td)[6]
    ${STP_Status}    Get Text
    ...    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/following-sibling::td)[6]
    Set Global Variable    ${Instant_Pay}
    Set Global Variable    ${STP_Status}
    IF    '${requeststatus}' == 'Approve'
        Set Calc VP Actual Result With Original And Source
        ...    Transaction_Status
        ...    Approve
        ...    ${requeststatus}
        ...    OWB Application
    ELSE
        Set Calc VP Actual Result With Original And Source
        ...    Transaction_Status
        ...    ${requeststatus.strip()}
        ...    ${requeststatus}
        ...    OWB Application
    END
    Set Global Variable    ${requeststatus}
    ${Final_Approve_Status}    Set Variable    ${requeststatus}
    Set Global Variable    ${Final_Approve_Status}
#    Run Keyword    OWB ${Update_Policy_Module}
    IF    '${requeststatus}' == 'In Progress'
        Run Keyword    Assign and Change Status Task
    END
    Click Element    ${EN_Apply_btn}
    Sleep   1s
    Take OWB Screenshot    OWB Inquiry Page
    ${Approved_Status}    Get Text
    ...    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/preceding-sibling::td)[5]//div
    Set Global Variable    ${Approved_Status}
    IF    '${Approved_Status}' == 'Paid'
        ${Approved_Status}    Set Variable    Approve
        Set Global Variable    ${Approved_Status}
    END
    IF    '${Final_Approve_Status}' != 'Approve' and '${Update_Policy_Module}' != 'Submit' and '${Update_Policy_Module}' != 'Policy loan' and '${Update_Policy_Module}' != 'Recurring payment'
        ${Transaction_After_OWB_Flag}    Set Variable    Yes
        Set Global Variable    ${Transaction_After_OWB_Flag}
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status_After_OWB
        ...    ${Approved_Status.strip()}
        ...    ${Approved_Status}
        ...    OWB_Application
    END
    IF    '${Update_Policy_Module}' == 'My policy(s)'
        ${Update_Policy_Module}    Set Variable    Personal details
    END
    Set Calc VP Expected Result With Original And Source
    ...    OWB TransactionStatus
    ...    ${Approved_Status.strip()}
    ...    ${Approved_Status}
    ...    OWB_Application
    Sleep    1s
    Click Element    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/preceding-sibling::td)[2]
    Take OWB Screenshot    ${Update_Policy_Module} Page
    Run Keyword    OWB ${Update_Policy_Module}
    Run Keyword    OWB Validations
    Run Keyword    Get OWB Details From DB




Get OWB Details From DB
    ${OwnerUserId}    Run Keyword
    ...    Get Owner User ID from DB
    ...    ${dbhostname}
    ...    ${dbusername}
    ...    ${dbpassword}
    ...    ${dbport}
    ...    ${dbinstanceAddon}
    ...    ${Policy_No}
    ...    ${dbinstance}
    Log    ${OwnerUserId}
    Set Global Variable    ${OwnerUserId}

    ${owbdf}    Run Keyword
    ...    Get OWB Details from DB using CustId
    ...    ${dbhostname}
    ...    ${dbusername}
    ...    ${dbpassword}
    ...    ${dbport}
    ...    ${dbinstanceAddon}
    ...    ${OwnerUserId}
    ...    ${screenshotPath}
    Log    ${owbdf}
    ${leng}    Get Length    ${owbdf}
    Log    ${leng}
#    Get Index for Column Header
    ${headerlist}    Get From List    ${owbdf}    0
    Log    ${headerlist}
    ${index1}    Get Index From List    ${headerlist}    CaseNo
    Log    ${index1}
    ${index2}    Get Index From List    ${headerlist}    StatusMessage
    Log    ${index2}
    ${list}    Get From List    ${owbdf}    1
    ${ActualSource}    Set Variable    View OWB Details DB Query
    ${owbcaseno}    Set Variable    ${list}[${index1}]
    Log    ${owbcaseno}
    Set Global Variable    ${owbcaseno}
    ${owbstatusmsg}    Set Variable    ${list}[${index2}]
    Log    ${owbstatusmsg}

    IF    '${owbstatusmsg}' == 'Completed' or '${owbstatusmsg}' == 'Paid'
        ${owbstatusmsg}    Set Variable    Approve
    ELSE IF    '${owbstatusmsg}' == 'Declined'
        ${owbstatusmsg}    Set Variable    Decline
    END
    Set Calc VP Actual Result With Original And Source
    ...    OWB Case No
    ...    ${owbcaseno.strip()}
    ...    ${owbcaseno.strip()}
    ...    ${ActualSource}
    Set Calc VP Actual Result With Original And Source
    ...    OWB TransactionStatus
    ...    ${owbstatusmsg}
    ...    ${owbstatusmsg}
    ...    ${ActualSource}

Get BO Status from DB
    ${PDdf}    Check BO Status
    ...    ${dbhostname}
    ...    ${dbusername}
    ...    ${dbpassword}
    ...    ${dbport}
    ...    ${dbinstanceAddon}
    ...    ${Policy_No}
    ...    ${screenshotDir}
    Log    ${PDdf}
    ${leng}    Get Length    ${PDdf}
    Log    ${leng}
    ${list0}    Get From List    ${PDdf}    0
    Log    ${list0}
    ${index1}    Get Index From List    ${list0}    Status
    Log    ${index1}
    ${index2}    Get Index From List    ${list0}    SentPayload
    ${counter}    Set Variable    1
    #    Log    ${counter}
    ${list}    Get From List    ${PDdf}    ${counter}
    ${BOStatus}    Set Variable    ${list}[${index1}]
    Log    ${BOStatus}
    ${BOSentPayLoad}    Set Variable    ${list}[${index2}]
    Log    ${BOSentPayLoad}
    IF    '${BOStatus}' == 'None'
        ${BOStatus}    Set Variable    ${EMPTY}
    END
    IF    '${BOSentPayLoad}' == 'None'
        ${BOSentPayLoad}    Set Variable    ${EMPTY}
    END
    Set Global Variable    ${BOStatus}
    Set Calc VP Actual Result With Original And Source    BOStatus_DB    ${BOStatus}    ${BOStatus}    BO Status DB
