*** Settings ***
Library  RequestsLibrary
Library  OperatingSystem
Library    Collections
#Library   ../../Qrace/QraceHelper.py
Resource    ../common.robot

*** Variables ***
${url}

*** Keywords ***
Get Latest Message ID
    TRY
        ${url}      Set Variable      ${base_url}api/addresses/${mailId}/messages
        &{header}=    Create Dictionary       Mailsac-Key=${mailSacKey}
        ${response}=     GET         url=${url}     headers=${header}       verify=${False}
        ${responselength}    Get Length       ${response.json()}
        IF    '${responselength}' != '0'
            ${messageId}=       Get From Dictionary     ${response.json()}[0]      _id
        ELSE
            ${messageId}     Set Variable
        END
        Set Global Variable    ${messageId}
        Log To Console    ${response.status_code}
       ${ResBody}   Evaluate       json.dumps(${Response.json()})
        ${response_body}   Convert To String    ${Res_body}
        Create File     ${screenshotPath}\\getMessages_response.json     ${response_body}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Get COI Latest Message ID
    [Arguments]     ${emailId}
    TRY
        ${url}      Set Variable      ${base_url}api/addresses/${emailId}/messages
        &{header}=    Create Dictionary       Mailsac-Key=${mailSacKey}
        ${response}=     GET         url=${url}     headers=${header}       verify=${False}
        ${messageId}=       Get From Dictionary     ${response.json()}[0]      _id
        Set Global Variable    ${messageId}
        Log To Console    ${response.status_code}
        ${ResBody}   Evaluate       json.dumps(${Response.json()})
        ${response_body}   Convert To String    ${Res_body}
        Create File     ${screenshotPath}\\getCOIMessages_response.json     ${response_body}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
