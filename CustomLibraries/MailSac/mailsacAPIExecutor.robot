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

    [Arguments]     ${Email}
    ${mailId}       Set Variable    ${Email}

    Set Global Variable    ${base_url}
    ${mailSacKey}       Get Environment Attribute    mailSacKey
    Set Global Variable    ${mailSacKey}
    Set Global Variable     ${mailId}
    Set Global Variable    ${screenshotDir}
#    Set Global Variable    ${messageId}
    Get Latest Message ID
    IF    '${messageId}' != '${EMPTY}'
        Get OTP from Message ID
    ELSE
        ${OTPNumber}    Set Variable
        Set Global Variable    ${OTPNumber}
    END


Get Email
    [Arguments]    ${ChangeEmail}   ${EmailType}
        ${mailId}       Set Variable    ${ChangeEmail}
        Set Global Variable    ${base_url}
        ${mailSacKey}       Get Environment Attribute    mailSacKey
        Set Global Variable    ${mailSacKey}
        Set Global Variable     ${mailId}
        Set Global Variable    ${screenshotPath}
    #    Set Global Variable    ${messageId}
        Get Latest Message ID
        IF    '${messageId}' != '${EMPTY}'
            Get Transaction Confirmation Email    ${mailId}        ${EmailType}
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

Fetch Insurance Mobile Number from API
    ${api_Sign_in_endpoint}     Set Variable    /live/auth/v9/api/signin

    #create header dict
    ${api_headers}      Create Dictionary
    ...     ${api_key_name}=${api_key_valueauth}
    ...     App-Version=${omneapp_version}

    #create request body dictionary
    ${request_body_data}    Create Dictionary
    ...        email=${Email}
    ...        language=en-GB
    ...        deviceId=5545314F-0AC8-41E2-B330-3FE8BB0234C7
    ...        isAdditionalDeviceSignIn=true

    #   Save Request Body
    ${str_request}      Convert To String    ${request_body_data}
    Create File     ${screenshotDir}//fetch_mobile_number_request.json       ${str_request}

#    API Call
    ${response}     POST    url=${api_host}/${api_Sign_in_endpoint}      headers=${api_headers}     json=${request_body_data}    expected_status=200

    #   Save Repsonse
    ${str_response}     Convert To String    ${response.json()}
    Create File     ${screenshotDir}//fetch_mobile_number_response.json       ${str_response}

    ${insurance_mobile_number}       Set Variable    ${response.json()}[unmaskedPhoneNumber]
    ${insurance_mobile_number}      Remove String    ${insurance_mobile_number}     +
    ${countrycode_contains_status}      Run Keyword And Return Status    Should Start With    ${insurance_mobile_number}    81

    [Return]    ${insurance_mobile_number}

Check Mailing Prefrence Confirmation Email
    [Arguments]     ${Emailid}
    ${mailId}       Set Variable    ${Emailid}
        Set Global Variable    ${base_url}
        ${mailSacKey}       Get Environment Attribute    mailSacKey
        Set Global Variable    ${mailSacKey}
        Set Global Variable     ${mailId}
        Set Global Variable    ${screenshotPath}
    #    Set Global Variable    ${messageId}
        Get Latest Message ID
        IF    '${messageId}' != '${EMPTY}'
            Verify Mailing Prefrence Confirmation Email    ${mailId}
        END


