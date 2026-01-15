*** Settings ***
Library    RequestsLibrary
Resource    ../MailSac/mailsacAPIExecutor.robot
Resource    ../common.robot



*** Variables ***
${confirm_sign_up_OTP_endpoint}            live/auth/v2/api/confirm-otp

*** Keywords ***
Confirm Sign Up OTP
    TRY
        Sleep    10s
        Get OTP     ${Email}
        ${host}         Get Environment Attribute        host
        &{request_body}     Create Dictionary
        ...     email=${EmailNew}
        ...     confirmationCode=${OTPNumber}

        #   Save Request Body
        ${str_request}      Convert To String    ${request_body}
        Create File     ${screenshotPath}\\confirm_sign_up_OTP_request.json       ${str_request}

        #    Call onboardingAPI
        ${confirm_signup_OTP_response}      POST    url=${host}/${confirm_sign_up_OTP_endpoint}     headers=${api_key_headers}   json=${request_body}   expected_status=200

        #   Save Repsonse
        ${str_response}     Convert To String    ${confirm_signup_OTP_response.json()}
        Create File     ${screenshotPath}\\confirm_sign_up_OTP_response.json       ${str_response}

        Set Calc VP With Source And Original Values    confirm_sign_up_OTP_Status_Code    200     ${confirm_signup_OTP_response.status_code}    static    API Response    200    ${confirm_signup_OTP_response.status_code}*** Settings ***
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END