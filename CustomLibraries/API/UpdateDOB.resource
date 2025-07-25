*** Settings ***
Library    RequestsLibrary
Library    ../../Qrace/QraceHelper.py
Library    OperatingSystem
Library    String
Library    Collections

*** Variables ***
${update_DOB_endpoint}            live/auth/v2/api/complete-signup

*** Keywords ***
Update Sign Up DOB
    TRY
        ${host}         Get Environment Attribute        host
        @{DateOfBirth}         Split String     ${SignUpDOB}
        ${Day}          Get From List    ${DateOfBirth}   0
        ${Month}          Get From List    ${DateOfBirth}   1
        ${Year}          Get From List    ${DateOfBirth}   2
        ${Month}=      Month Dic    ${Month}
         ${DateOfBirth}     Set Variable     ${Day.zfill(2)}/${Month}/${Year}
    #   Request body
        &{user_details}     Create Dictionary
        ...     email=${EmailNew}
        ...     gender=${SignUpGender}
        ...     dateOfBirth=${DateOfBirth}

    #   Save Request Body
        ${str_request}      Convert To String    ${user_details}
        Create File     ${screenshotPath}\\update_DOB_request.json       ${str_request}

    #    Call onboardingAPI
        ${updateDOB_response}      POST    url=${host}/${update_DOB_endpoint}     headers=${api_key_headers}   json=${user_details}   expected_status=any

    #   Save Repsonse
        ${str_response}     Convert To String    ${updateDOB_response.json()}
        Create File     ${screenshotPath}\\update_DOB_response.json       ${str_response}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END