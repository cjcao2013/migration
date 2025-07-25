*** Settings ***
Library     OperatingSystem
Library   ../Qrace/QraceHelper.py
Library    Collections
Library    JSONLibrary
#Library           HttpLibrary.HTTP
Library     Upload_app_on_BS.py
Resource    ../common.robot


*** Variables ***
${org}    FWD-Innovation
${app}    Your-Turn-iOS-UAT
${apitoken}    87ddc86127c4c425490427b8026e46d1695dc84d
${bs_username}    seemakaria_ENTHMO
${bs_password}    KdUGPBposqsFzzD2Mbsx

*** Keywords ***
Upload Build in BS
    [Arguments]       ${bs_username}    ${bs_password}  ${releaseName}
    TRY
        @{words}       Split String    ${releaseName}          _
        ${version}   Get From List           ${words}        0
        ${buildNo}   Get From List           ${words}        1
        ${app}  Get From List           ${words}        2
        ${id}   Get From List           ${words}        3

        ${org}    Get Environment Attribute    AppOrg
        ${apitoken}    Get Environment Attribute    AppCenterAPIToken

    #    Log To Console    ${id}
        ${install_url}    Get Appcenter APP URL    ${app}    ${org}    ${apitoken}    ${id}
        Log To Console       ${install_url}
        ${bs_app}    Upload App on BS    ${install_url}    ${bs_username}    ${bs_password}
        Log To Console    ${bs_app}
        [Return]       ${bs_app}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END