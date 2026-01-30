*** Settings ***
Library     SeleniumLibrary
Library     String
Resource    ../../CustomLibraries/common.robot
Resource    ../../PageObjects/OWB/OWBAssignTaskPageObjects.resource


*** Keywords ***
Assign and Change Status Task
    Wait Until Page Contains Element
    ...    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/preceding-sibling::td)[1]//input
    Click Element    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/preceding-sibling::td)[1]//input
    Wait Until Element Is Visible    ${EN_AssignTask}    timeout=200s
    Take OWB Screenshot    Assign_TaskPage
    Click Element    ${EN_AssignTask}
    Wait Until Element Is Visible    ${EN_assigneeOption}    timeout=200s
    Click Element    ${EN_assigneeOption}
    Wait Until Element Is Visible    ${EN_inputassignee}    timeout=200s
    Input Text    ${EN_inputassignee}    ${Assignee}
    Press Keys    ${EN_inputassignee}    RETURN
#    Click Element    xpath=//div[text()='${Assignee}']
    Wait Until Element Is Visible    ${EN_AssigndoneBtn}    timeout=180s
    Take OWB Screenshot    Assign_TaskPage

    Click Element    ${EN_AssigndoneBtn}
    Wait Until Element Is Visible    ${EN_OKBtn}    timeout=180s
    Take OWB Screenshot    Assigned_successfullyPage
    Click Element    ${EN_OKBtn}
    Take OWB Screenshot    InquiryPage
    Wait Until Element Is Visible
    ...    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/preceding-sibling::td)[2]
    Click Element    xpath=((//div[contains(text(),'${Policy_No}')])[1]/ancestor::td/preceding-sibling::td)[2]
    Wait Until Element Is Visible    ${EN_completeBtn}    timeout=180s
    Take OWB Screenshot    InquiryPage
    # add code to write claim no
    IF    '${Insurance_Flow}' == 'Submit'
        ${ranint}    Generate Random String    length=6    chars=[NUMBERS]
        ${ranint}    Convert To Integer    ${ranint}
        Input Text    ${EN_CoreSystemclaimNo}    ${ranint}
    END
    IF    '${Update_Policy_Module}' == 'Policy loan'
        Wait Until Element Is Visible    ${EN_EffectiveDate}
        Click Element    ${EN_EffectiveDate}
        Wait Until Element Is Visible    ${EN_TodayDate}
        Click Element    ${EN_TodayDate}
        Wait Until Element Is Visible    ${EN_PayableAmount}
        Input Text    ${EN_PayableAmount}    ${Loan_Amount}

    END


    IF    '${CaseStatus}' == 'Pending'
        Click Element    ${EN_PendBtn}
        OWB Pending Flow
    ELSE
        Wait Until Element Is Visible    ${EN_completeBtn}        timeout=5s
        Click Element    ${EN_completeBtn}
        Wait Until Element Is Visible    xpath=//span[text()='${CaseStatus}']
        Click Element    xpath=//span[text()='${CaseStatus}']
#    IF    '${CaseStatus}' == 'Decline'
#    Wait Until Element Is Visible    ${EN_declineReasonOption}    timeout=200s
#    Click Element    ${EN_declineReasonOption}
#    Input Text    ${EN_declineReason}    ${Decline_Reason}
#    Sleep    2s
#    Press Keys    ${EN_declineReason}    RETURN
#    END
        Take OWB Screenshot    CompleteCase_Page
        Click Element    ${EN_statuscompleteBtn}
    END
    Wait Until Element Is Visible    ${EN_startNextJobBtn}    timeout=180s
    Take OWB Screenshot    CaseCompleteSuccessfully_Page
    Click Element    ${EN_startNextJobBtn}
    Sleep   2s
    Take OWB Screenshot    InquiryPage
    Wait Until Page Contains Element    ${EN_inquirybackBtn}    timeout=180s
    Click Element    ${EN_inquirybackBtn}
    #    Click Element    ${EN_inquirybackBtn}
#    ${ele}    Get WebElement    ${EN_inquirybackBtn}

OWB Pending Flow
    Wait Until Element Is Visible    ${EN_pendingDocumentTypeOption}

    @{DocumentTypeList}    Split String    ${Pend_DocumentType}    ,
    @{PendingReasonList}    Split String    ${Pend_PendingReason}    ,
    IF    '${Insurance_Flow}' != 'Submit'
        @{ReasonDisplayList}    Split String    ${Pend_Reason_To_display_In_Omne}    ,
    END
    ${TotalPendingDocuments}    Get Length    ${DocumentTypeList}
    Set Global Variable    ${TotalPendingDocuments}
    FOR    ${counter}    IN RANGE    0    ${TotalPendingDocuments}
        Log    ${counter}
        IF    '${counter}' != '0'    Click Element    ${EN_pendAddNewButton}
        ${documentType}    Get From List    ${DocumentTypeList}    ${counter}
        ${pendingreason}    Get From List    ${PendingReasonList}    ${counter}


        Click Element    ${EN_pendingDocumentTypeOption}
        Input Text    ${EN_pendingDocumentType}    ${documentType}
        Press Keys    ${EN_pendingDocumentType}    RETURN

        Click Element    ${EN_pendingReasonOption}
        Input Text    ${EN_pendingReason}    ${pendingreason}
        Press Keys    ${EN_pendingReason}    RETURN
        IF    '${Insurance_Flow}' != 'Submit'
            ${reasontodisplay}    Get From List    ${ReasonDisplayList}    ${counter}
            Input Text    ${EN_ResonDisplayField}    ${reasontodisplay}
        END
        Take Screenshot    Pending RequestPage
    END
    Wait Until Element Is Visible    ${EN_statusPendBtn}        timeout=10s
    Click Element    ${EN_statusPendBtn}
