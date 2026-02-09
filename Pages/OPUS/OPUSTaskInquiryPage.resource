*** Settings ***
Library     SeleniumLibrary
Library     ../../CustomLibraries/DateTimeCompare.py
Library     ../DBQuery/DBQuerySelect.py
Library     DBQuerySelect
Resource    ../../PageObjects/OPUS/OPUSInquiryPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    ../../PageObjects/OPUS/OPUSAssignTaskPageObject.resource
Resource    ../Insurance/UpdatePolicy/PersonalDetailsPage.resource
Resource    ../Insurance/UpdatePolicy/PartialWithdrawalPage.resource
Resource     ../../CustomLibraries/DateTimeCompare.py
Resource    ../../PageObjects/OPUS/OPUSTaskInquiryPageObjects.resource
Resource    OPUSPersonalDetailsPage.resource
Resource    OPUSRenewalPremiumPage.resource
Resource    OPUSRecurringCreditCardPage.resource
Resource    OPUSPartialWithdrawalPage.resource
Resource    OPUSAssignTaskPage.resource
Resource    OPUSSwitchFundsPage.resource
Resource    OPUSPaymentFrequencyPage.resource
Resource    OPUSChangeICPPage.resource
Resource    OPUSTaxConsentPage.resource
Resource    OPUSChequeCancellationPage.resource
Resource    OPUSCVPolicyLoanPage.resource
Resource    OPUSSwitchFundsPage.resource
Resource    OPUSChangeBeneficiaryPage.resource
*** Keywords ***
OPUS Inquiry
    TRY
        Wait Until Element Is Visible    ${EN_search_Icon}      timeout=120s
        Take OWB Screenshot    Home Page
        Click Element    ${EN_search_Icon}
        Wait Until Element Is Visible    ${EN_taskInquiryOption}        timeout=10s
        Take OPUS Screenshot    Task Inquiry Page
        IF    '${OPUSTransactionstatus}' == 'In progress'
            Click Element    ${EN_taskInquiryOption}
        ELSE IF  '${OPUSTransactionstatus}' == 'Completed'
            Click Element    ${EN_caseInquiryOption}
        END

        #capture case no from DB
        Run Keyword     Get OPUS Details From DB

        #enter details to search transaction
        #policynumber

        Set Global Variable    ${OPUS_Case_No}
        Wait Until Element Is Visible    ${EN_inputPolicyNumber}        timeout=10s
        Input Text    ${EN_inputPolicyNumber}    ${Policy_No}
        Take OPUS Screenshot    Inquiry Page

        #input case no
        Wait Until Element Is Visible    ${EN_CaseNo_Search}        timeout=10s
        Input Text    ${EN_CaseNo_Search}    ${OPUS_Case_No}

        #click on search
        Wait Until Element Is Visible    ${EN_search_Button}        timeout=10s
        Click Element    ${EN_search_Button}

        Take OPUS Screenshot    Inquiry Page

        Sleep   5s
        IF    '${OPUSTransactionstatus}' == 'In progress'
            ${status}    Run Keyword And Return Status      Wait Until Element Is Visible     ${EN_RequestStatus}

#            IF    '${status}' == 'True' and '${Update_Policy_Module}' == 'Partial withdrawal' or '${Update_Policy_Module}' == 'Switch funds'
#                ${requeststatus}    Get Text     ${EN_RequestStatus}
#                Click Element    ${EN_caseInquiryOption}
#                Wait Until Element Is Visible    ${EN_CaseNo_Search}        timeout=10s
#                Input Text    ${EN_CaseNo_Search}    ${OPUS_Case_No}
#                Wait Until Element Is Visible    xpath=//a[text()='${OPUS_Case_No}']        timeout=10s
#                Click Element    xpath=//a[text()='${OPUS_Case_No}']
#                Take OPUS Screenshot    Inquiry Page
#                Wait Until Element Is Visible    ${EN_EWorksheet}         timeout=20s
#                Sleep    1s
#                Click Element    ${EN_EWorksheet}
#                ${tab2}    Switch Window    NEW
#                Take OPUS Screenshot    Inquiry Page
#            ELSE
                 ${requeststatus}    Get Text     ${EN_RequestStatus}
                 IF    '${requeststatus}' != 'Completed'
                    OPUS Assign and Change Task Status
                    IF    '${requeststatus}' == 'To Do'
                          ${mrequeststatus}       Set Variable      In Progress
                         Set Calc VP Actual Result With Original And Source    Transaction_Status    ${mrequeststatus.strip()}    ${requeststatus}    OPUS_Inquiry
                    END
#            END
                Sleep    5s
                Wait Until Element Is Visible    ${EN_search_Button}        timeout=10s
                Click Element    ${EN_search_Button}

                Reload Page

                Wait Until Element Is Visible    ${EN_inputPolicyNumber}        timeout=60s
                Input Text    ${EN_inputPolicyNumber}    ${Policy_No}
                Take OPUS Screenshot    Inquiry Page

                #input case no
                Wait Until Element Is Visible    ${EN_CaseNo_Search}        timeout=10s
                Input Text    ${EN_CaseNo_Search}    ${OPUS_Case_No}

                Wait Until Element Is Visible    ${EN_search_Button}        timeout=10s
                Click Element    ${EN_search_Button}

                Wait Until Element Is Visible    xpath=//td[text()='${OPUS_Case_No}']        timeout=10s
                Click Element    xpath=//td[text()='${OPUS_Case_No}']
                Take OPUS Screenshot    Inquiry Page
            END
        ELSE IF  '${OPUSTransactionstatus}' == 'Completed'
            Wait Until Element Is Visible    xpath=//a[text()='${OPUS_Case_No}']        timeout=10s
            Click Element    xpath=//a[text()='${OPUS_Case_No}']
            Take OPUS Screenshot    Inquiry Page
            Sleep    1s
            Wait Until Element Is Visible    ${EN_EWorksheet}         timeout=20s
            Sleep    2s
            Click Element    ${EN_EWorksheet}
            ${tab2}    Switch Window    NEW
            Take OPUS Screenshot    Inquiry Page

        END
        ${sOutput}    Run Keyword And Ignore Error    OPUS ${Update_Policy_Module}
        IF    ${sOutput} != ('PASS', None)
            Take OPUS Screenshot    Error Screenshot
            ${failure_reason}    Fetch Reason    ${sOutput}
            RETURN    ${failure_reason}
        END

    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Inquiry
    END

Get OPUS Details From DB
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
    ...    Get OPUS Details from DB using CustId
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
    ${OPUS_Case_No}    Set Variable    ${list}[${index1}]
    Log    ${OPUS_Case_No}
     Set Global Variable    ${OPUS_Case_No}

    ${owbstatusmsg}    Set Variable    ${list}[${index2}]
    Log    ${owbstatusmsg}

    IF    '${owbstatusmsg}' == 'Completed' or '${owbstatusmsg}' == 'Paid'
        ${owbstatusmsg}    Set Variable    Approve
    ELSE IF    '${owbstatusmsg}' == 'Declined'
        ${owbstatusmsg}    Set Variable    Decline
    END
