*** Settings ***
#Library     SeleniumLibrary
Library     RequestsLibrary
Library     OperatingSystem
Resource    getMessages.robot
Resource    getMailBody.robot
Library   ../../Qrace/QraceHelper.py
Resource    ../common.robot

*** Variables ***
${base_url}    https://mailsac.com/
${mailSacKey}       k_9n9B24Ug7eHBD92Tw9N2Wazj9KmrMbscdGTKraycwrwA567d
#k_Ppf3EVdg5JPd5s4i6YNxyuLWjbZZEzr22htgff37
${mailId}
${screenshotPath}    D:\RF\mailsacapiresponse
${messageId}

*** Keywords ***
Get OTP
#    Set Screenshot Directory     ${screenshotPath}\\
    TRY
#        ${mailId}       Set Variable    ${Email}
#        Set Global Variable    ${base_url}
#        ${mailSacKey}       Get Environment Attribute    mailSacKey
#        Set Global Variable    ${mailSacKey}
#        Set Global Variable     ${mailId}
#        Set Global Variable    ${screenshotPath}
#    #    Set Global Variable    ${messageId}
#        Get Latest Message ID
#        IF    '${messageId}' != '${EMPTY}'
#            Get OTP from Message ID
#        ELSE
#            ${OTPNumber}    Set Variable
#            Set Global Variable    ${OTPNumber}
#        END
        ${OTPNumber}    Set Variable    123456
        Set Global Variable    ${OTPNumber}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Get COI Information
    [Arguments]     ${Email_Send_ID}
     TRY
    #    Set Screenshot Directory     ${screenshotPath}\\
        ${mailId}       Set Variable    ${Email_Send_ID}
        Set Global Variable    ${base_url}
        ${mailSacKey}       Get Environment Attribute    mailSacKey
        Set Global Variable    ${mailSacKey}
        Set Global Variable     ${mailId}
        Set Global Variable    ${screenshotPath}
        Set Global Variable    ${messageId}
        Get COI Latest Message ID       ${mailId}
        Get COI Information from mail       ${mailId}
     EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
     END