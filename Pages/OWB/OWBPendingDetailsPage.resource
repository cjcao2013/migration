*** Settings ***
Library     SeleniumLibrary
Library     String
Library     QraceHelper
Resource    ../../CustomLibraries/common.robot
Resource    ../../PageObjects/OWB/OWBAssignTaskPageObjects.resource
Resource    ../../PageObjects/OWB/OWBPendingDetailsPageObjects.resource



*** Keywords ***
Capture Pending Request Detail
    TRY
        Click Element    ${EN_PendRequestTab}
        Wait Until Element Is Visible    ${EN_TotalPendingRequest}
        Sleep    2s
        Take OWB Screenshot    Pending Request Page
        ${VP_totPendRequestelements}    Get Webelements    ${EN_TotalPendingRequest}
        ${VP_totPendRequest}    Get Length    ${VP_totPendRequestelements}
        &{Documentlistdic}      Create Dictionary
        FOR    ${counter}    IN RANGE    1    ${VP_totPendRequest}+1
            Log    ${counter}
             ${VP_documentTypeName}     Get Text    xpath=((//tbody[@class='ant-table-tbody'])[1]/tr/td[3])[${counter}]
             ${VP_pendingReason}        Get Text    xpath=((//tbody[@class='ant-table-tbody'])[1]/tr/td[4])[${counter}]
             Set To Dictionary    ${Documentlistdic}    ${VP_documentTypeName}      ${VP_pendingReason}
        END
        @{documentnamelist}     Get Dictionary Keys    ${Documentlistdic}
        ${count}    Set Variable    0
        FOR    ${element}    IN    @{documentnamelist}
            Log    ${element}
             ${documentpendReason}      Get From Dictionary    ${Documentlistdic}    ${element}
             Set Calc VP Expected Result With Original And Source    DocumentName_${count}     ${element}     ${element}    OWB PendRequest Page
             Set Calc VP Expected Result With Original And Source    ${element}_PendingReason     ${documentpendReason}     ${documentpendReason}    OWB PendRequest Page
            ${count}    Evaluate    ${count}+1
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       OWB_Flow   ${reason}  OWB Capture Pending Request Detail
    END