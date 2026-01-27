*** Settings ***
Documentation    Suite description
Library    RequestsLibrary
Library    Collections
Resource        ../common.robot
Resource        ../../Pages/OPUS/OPUSTaskInquiryPage.resource
#Resource        ../Pages/TaskInquiry.robot


*** Variables ***
${login_url}         https://uat-${env}.fwd.com.th/api/workspace/user/login
${adb_search}        https://uat-${env}.fwd.com.th/api/dw/task/inquiry/advSearch
${assign_task}       https://uat-${env}.fwd.com.th/api/bpm/task/assignTask


*** Keywords ***
OWB API
    TRY
        Create Session    OWB    url=https://opus-${environment}.fwd.com/api/
        Sleep    10s
        ${login_token}      Login To OWB API
        ${task_Id}   Advance Search      ${login_token}
        Assign Task     ${task_Id}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OWB API
    END



Login To OWB API
    TRY
        &{login_req}    Create Dictionary
        ...     username=${OPUS_Username}
        ...     password=${OPUS_Password}
        ...     userId=${OPUS_Username}
    
        ${login_response}     POST On Session   OWB    url=workspace/user/login    json=${login_req}
        ${login_result}     Get From Dictionary    ${login_response.json()}     resultData
        ${token}    Set Variable    ${login_result}[token]
        Log To Console    ${token}
        RETURN       ${token}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Login To OWB API
    END
    


Advance Search
    [Arguments]     ${token}
    TRY
         &{param}    Create Dictionary
        ...     policyNo=${policy_no}
        ...     remainingTime={},
        ...     defaultSortName=inquiryBusinessNo
        ...    regionCode=TH
        &{advSearch_req}        Create Dictionary
        ...     params=${param}
        ...     currentPage= 1
        ...     pageSize=10
        ...     sortName=procInstId
        ...     sortOrder=desc
        ...     sortOrders=[]
        ...     defaultSortName=policyNo

        ${advSearch_response}     POST On Session   OWB    url=dw/task/inquiry/advSearch?token=${token}    json=${advSearch_req}
        ${advSearch_result}     Get From Dictionary    ${advSearch_response.json()}     resultData
        ${rows}    Set Variable    ${advSearch_result}[rows]
        ${row_size}     Get Length    ${rows}
        Log To Console    ${row_size}
        Log    ${advSearch_result}
        FOR    ${counter}    IN RANGE    0    ${row_size}
    #        ${row_size}     Evaluate    ${row_size}-1
            &{temp}     Get From List    ${rows}     ${counter}
            ${taskStatus}     Get From Dictionary    ${temp}    taskStatus
            ${procInstId}     Get From Dictionary    ${temp}    procInstId
            IF    '${taskStatus}' == 'todo' or '${taskStatus}' == 'pending' and '${procInstId}' == '${OPUS_Case_No}'
                 ${taskID}      Get From Dictionary    ${temp}    taskId
                 ${task_category}      Get From Dictionary    ${temp}    caseCategory
                 log        ${task_category}
                 Set Global Variable    ${task_category}
                 Exit For Loop
            END
        END
        RETURN       ${taskID}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Advance Search
    END


Assign Task
    [Arguments]     ${taskID}
    TRY
        &{assignTask_req}               Create Dictionary
        ...     assignee=${OPUS_Username}
        ...     assigner=${Assigner}
        ...     taskId=${taskID}
        ...     caseCategory=${task_category}
        ${assignTask_response}     POST On Session   OWB    url=bpm/task/assignTask    json=${assignTask_req}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Assign Task
    END