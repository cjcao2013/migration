*** Settings ***
Library     SeleniumLibrary
Library     String



Resource    ../../CustomLibraries/common.robot
Resource    ../../PageObjects/OPUS/OPUSAssignTaskPageObject.resource
Resource    ../../CustomLibraries/OPUS_API/TaskAssigner.robot


*** Keywords ***
OPUS Assign and Change Task Status
    TRY
        Wait Until Page Contains Element    ${EN_CaseNo}        timeout=15s
        Click Element    ${EN_Messanger}
        Sleep    1s
        ${Assignee_Name}    Get Text    ${EN_Msg_Name}
        Click Element    ${EN_Msg_Search}
        Input Text    ${EN_Msg_Search}    ${Assignee_Name}
        Take OPUS Screenshot    Assign_TaskPage
         Pause Execution
#        OWB API

    #    Drag And Drop   ${EN_CaseNo}    xpath=(//h4[contains(@class,'meta-title')]/span/span[text()='${Assignee_Name}'])[2]
        Take OPUS Screenshot    Assign_TaskPage
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Assign and Change Task Status
    END






