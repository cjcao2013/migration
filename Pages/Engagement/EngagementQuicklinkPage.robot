*** Settings ***
Library     AppiumLibrary
Library     Dialogs
Resource    ../../CustomLibraries/common.robot

Resource    ../Insurance/Common/AddOTP.resource
Resource    ../Insurance/Common/CommonMethod.resource

Library     FakerLibrary


*** Variables ***
${VP_ByDefault_Lang}    ${EMPTY}


*** Keywords ***
Engagement Quick link
    TRY
        #Wait Until Page Contains Element    chain=**/XCUIElementTypeOther[`label CONTAINS '${Engagement_Quick_link_Module}'`][-1]     timeout=10s
        Take Screenshot    Engagement Quick link
        Sleep    2s

    #    Click Text    ${Engagement_Quick_link_Module}       exact_match=true
        IF    '${Engagement_Quick_link_Module}' == 'My policy(s)'
            Click Element At Coordinates    78    502
        ELSE IF     '${Engagement_Quick_link_Module}' == 'Manage policy(s)'
            Click Element At Coordinates    322    502
        ELSE
            Click Element At Coordinates    205    502
        END
        Take Screenshot    Engagement Quick link
        Set or enter PIN
        Take Screenshot    Engagement Quick link
        Set Global Variable    ${result}   Engagement Quick link Module Successfully Done For ${Engagement_Quick_link_Module}
        ${OPUS_OR_OWB_App}          Set Variable         ${EMPTY}
        Set Global Variable        ${OPUS_OR_OWB_App}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END