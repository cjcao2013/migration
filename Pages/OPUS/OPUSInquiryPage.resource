*** Settings ***
Library     SeleniumLibrary
Library     ../../CustomLibraries/DateTimeCompare.py
Library     ../DBQuery/DBQuerySelect.py
Library     DBQuerySelect
Resource    ../../PageObjects/OPUS/OPUSInquiryPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    OPUSAssignTaskPage.resource
Resource    OPUSSwitchFundsPage.resource
Resource    ../Insurance/UpdatePolicy/PartialWithdrawalPage.resource
Resource        ../../CustomLibraries/DateTimeCompare.py
Resource    OPUSPartialWithdrawalPage.resource

*** Keywords ***
OPUS Inquiryjj
#    Add time of transaction
    TRY

        Wait Until Element Is Visible    ${EN_Search_link}    timeout=10s
        Take OPUS Screenshot    HomePage
        Click Element    ${EN_Search_link}
        Take OPUS Screenshot    HomePage

                ${strtransactionstatus}    Set Variable    Inprogress
                Log To Console    ${strtransactionstatus}
    #    If Omne tansaction status is completed then goes to case inquiry else goes to task inquiry
            IF    '${strtransactionstatus}'=='Completed'
                ${sOutput}    Run Keyword And Ignore Error    Case Inquiry
                IF    ${sOutput} != ('PASS', None)
                    ${failure_reason}    Fetch Reason    ${sOutput}
                    RETURN    ${failure_reason}
                END
            ELSE
                ${sOutput}    Run Keyword And Ignore Error    Task Inquiry
                IF    ${sOutput} != ('PASS', None)
                    ${failure_reason}    Fetch Reason    ${sOutput}
                    RETURN    ${failure_reason}
                END
            END

    #    ${sOutput}    Run Keyword And Ignore Error    OPUS ${Update_Policy_Module}
         ${sOutput}    Run Keyword And Ignore Error    OPUS Partial withdrawal
        IF    ${sOutput} != ('PASS', None)
            ${failure_reason}    Fetch Reason    ${sOutput}
            RETURN    ${failure_reason}
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Inquiry Flow ${Insurance_Flow}
    END
Task Inquiry
    TRY
        Wait Until Element Is Visible    ${EN_AdvancedSearch_TaskInquiry}    timeout=5s
        Click Element    ${EN_AdvancedSearch_TaskInquiry}
        Wait Until Element Is Visible    ${EN_Policy_no_txt}    timeout=5s
#        Input Text    ${EN_Policy_no_txt}    ${Policy_No}
        Input Text    ${EN_Policy_no_txt}       ${Policy_No}
        Click Element    ${EN_CaseCategory}
        Click Element    ${EN_POS_Decision}
        Click Element    ${EN_CurrentActivity}
        Click Element    ${EN_POS_Decision}
        Input Text    ${EN_BusinessType}    ${Update_Policy_Module}
        Click Element    xpath=//li[text()='${Update_Policy_Module}']

        Click Element    ${EN_Search_btn}
        Wait Until Element Is Visible    ${EN_CaseNo_text}    timeout=5s
        Click Element    ${EN_CaseNo_text}
        Sleep    0.5s
        Click Element    ${EN_CaseNo_text}
        Take OPUS Screenshot    InquiryPage
        Sleep    1s
#        Date and Time comapre
        ${requeststatus}    Get Text    ${EN_RequestStatus}
        IF    '${requeststatus}' != 'Completed'
                OPUS Assign and Change Task Status
        END
        Click Element    ${EN_CaseNo}
        Wait Until Element Is Visible    ${EN_STP_Info}    timeout=5s
        Click Element    ${EN_STP_Info}
        Wait Until Element Is Visible    ${EN_STP_Result_txt3}
        Click Element    ${EN_STP_Result_txt3}
        ${STP_Result}    Get Text    ${EN_STP_Result_MSG1}
        Set Global Variable    ${STP_Result}
        Take OPUS Screenshot    STPResultPage
        IF    '${STP_Result}'=='All STP rules passed.'
             ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${EN_Exceptional_Message_txt}    timeout=5s
                   IF    '${status}'=='True'
                        Wait Until Element Is Visible    ${EN_Exceptional_Message_txt}    timeout=5s
                        Click Element    ${EN_Exceptional_Message_txt}
                        ${exception_msg}    Get Text    ${EN_Exceptional_Msg1}
                        Set Global Variable    ${exception_msg}
                        Fail    Found Exception Message:    ${exception_msg}

                   END
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP  OPUS_Flow   ${reason}   OPUS Task Inquiry ${Insurance_Flow}
    END

Case Inquiry
    TRY
        Wait Until Element Is Visible    ${EN_AdvancedSearch_CaseInquiry}    timeout=5s
        Click Element    ${EN_AdvancedSearch_CaseInquiry}
        Wait Until Element Is Visible    ${EN_Policy_no_txt}    timeout=5s
#            Input Text    ${EN_Policy_no_txt}    ${Policy_No}
        Input Text    ${EN_Policy_no_txt}    40779487
        Click Element    ${EN_CaseCategory}
        Click Element    ${EN_POS_Decision}
        Click Element    ${EN_CurrentActivity}
        Click Element    ${EN_Completed}
        Input Text    ${EN_BusinessType}    ${Update_Policy_Module}
        Click Element    xpath=//li[text()='${Update_Policy_Module}']
        Click Element    ${EN_Search_btn}
        Wait Until Element Is Visible    ${EN_CaseNo_text}    timeout=5s
#           ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${EN_searchToStartInquiry_TXT}    timeout=5s
#            Take OPUS Screenshot    InquiryPage
        Click Element    ${EN_CaseNo_text}
        Sleep    0.5s
        Click Element    ${EN_CaseNo_text}
        Take OPUS Screenshot    InquiryPage
        Sleep    1s
#            Date and Time comapre
        ${requeststatus1}    Get Text    ${EN_RequestStatus}
        IF    '${requeststatus1}' = 'Completed'
            Click Element    ${EN_CaseNo}
            Wait Until Element Is Visible    ${EN_STP_Info}    timeout=5s
            Click Element    ${EN_STP_Info}
            Wait Until Element Is Visible    ${EN_STP_Result_txt3}
            Click Element    ${EN_STP_Result_txt3}
            ${STP_Result1}    Get Text    ${EN_STP_Result_MSG1}
            Set Global Variable    ${STP_Result}
            Take OPUS Screenshot    CaseInquiryPage
            IF    '${STP_Result1}'=='All STP rules passed.'
#               E-WorkSheet
#               Wait Until Element Is Visible    ${EN_EWorksheet}    timeout=200s
                Click Element    ${EN_EWorksheet}
#               handle switch window
                Switch Window    new
                Wait Until Element Is Visible    ${EN_EWorksheet_txt}    timeout=200s
                Take OPUS Screenshot    EWorksheetPage
            END
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Case Inquiry ${Insurance_Flow}
    END

Change Decision Status if Non STP
    TRY
        Take OPUS Screenshot        OPUSAssignPage
        Wait Until Page Contains Element    ${EN_OPUS_DecisionStatus}              timeout=40s
        Click Element    ${EN_OPUS_DecisionStatus}
        Sleep    0.5s
        Wait Until Page Contains Element    xpath=//li[text()='${CaseStatus}']      timeout=40s
        Click Element    xpath=//li[text()='${CaseStatus}']
        Sleep    0.5s
        IF    '${CaseStatus}' == 'Decline'
            Wait Until Page Contains Element    ${EN_DelineReason}      timeout=40s
            Click Element    ${EN_DelineReason}
            Sleep    0.5s
            Wait Until Page Contains Element    xpath=//li[text()='Others']     timeout=40s
            Click Element    xpath=//li[text()='Others']
            Sleep    0.5s

            Input Text    ${EN_EditDeclineReason}    Testing Purpose
            Sleep    0.5s
            Take OPUS Screenshot        OPUSAssignPage
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Change Decision Status if Non STP
    END


Date and Time comapre
    ${OPUS_Transaction_Time}    Get Text
    ...    xpath=(//div[contains(text(),'${Policy_No}')])[1]/ancestor::tr/td[16]
    ${DatecompareResult}    Date Compare   ${OWB_Transaction_Time}    ${omnecurrent_datetime}
#    ${counter}    Set Variable    0
#    WHILE    '${DatecompareResult}' == 'false' and ${counter} < 20
#        Sleep    10s
#        Click Element    ${EN_Apply_btn}
#        Sleep    1s
#        ${OWB_Transaction_Time}    Get Text
#        ...    xpath=(//div[contains(text(),'${Policy_No}')])[1]/ancestor::tr/td[16]
#        ${DatecompareResult}    Date Compare    ${OWB_Transaction_Time}    ${omnecurrent_datetime}
#        ${counter}    Evaluate    ${counter}+1
#    END
    IF    '${DatecompareResult}' == 'false'
        Fail    Transaction Not found in OPUS
    END











