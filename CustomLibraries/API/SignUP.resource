*** Settings ***
Library    RequestsLibrary
Library    ../../Qrace/QraceHelper.py
Library    OperatingSystem
Library         AppiumLibrary
Library         FakerLibrary
Library    Dialogs
Library    DateTime
Library        ../../../../Qrace/QraceHelper.py
Library    XML
Library     String
Resource    ../common.robot
*** Variables ***
${sign_up_endpoint}            live/auth/v2/api/signup

*** Keywords ***
Sign Up API
    TRY
        #   Header
        ${APIKeyname}       Get Environment Attribute    APIKeyname
        ${APIKeyValueauth}       Get Environment Attribute    APIKeyValueauth
        ${APIKeyvalue}         Get Environment Attribute    APIKeyvalue
        ${host}         Get Environment Attribute        host
        &{api_key_headers}  Create Dictionary   ${APIKeyname}=${APIKeyValueauth}
        Set Global Variable    ${api_key_headers}
        IF    '${lang}' == 'EN'
             ${lang}   Set Variable   en-GB
        END
        IF    '${Country}' == 'Indonesia'
             ${SignupLocation}   Set Variable   ID
        END
        ${emailname}    FakerLibrary.first_name
        ${emaillname}   FakerLibrary.last_name
        ${RandNum}      FakerLibrary.Random Digit
        ${EmailNew}    Convert To Lowercase    ${emailname}_${emaillname}_${RandNum}@mailsac.com
         Set Global Variable    ${EmailNew}
         ${Email}     Set Variable          ${EmailNew}
         Set Global Variable    ${Email}
    #    Request Body
        &{user_details}     Create Dictionary
        ...     email=${EmailNew}
        ...     name=${SignUpName}
        ...     language=${lang}
        ...     signupLocation=${SignupLocation}
        ...     signupIpAddress=${SignupIpAddress}
        ...     tcFlag=${TcFlag}
        ...     tcVersion=${TcVersion}
        ...     appVersion=${AppVersion}
        ...     osVersion=${OsVersion}

    #   Save Request Body
        ${str_request}      Convert To String    ${user_details}
        Create File     ${screenshotPath}\\sign_up_request.json       ${str_request}

    #    Call onboardingAPI
        ${signup_response}      POST    url=${host}/${sign_up_endpoint}     headers=${api_key_headers}   json=${user_details}   expected_status=200

    #   Save Repsonse
        ${str_response}     Convert To String    ${signup_response.json()}
        Create File     ${screenshotPath}\\sign_up_response.json       ${str_response}

        Set Calc VP With Source And Original Values    Sign_UP_Status_Code    200     ${signup_response.status_code}    static    API Response    200    ${signup_response.status_code}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END