*** Settings ***
Library     AppiumLibrary
Library     ../../Qrace/QraceHelper.py
Resource    ../../../PageObjects/Insurance/UpdatePolicy/SurrenderPolicyPageObjects.resource
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource


*** Keywords ***
surrender policy
    TRY
        Take Screenshot    Surrender Page
        Wait Until Element Is Visible    ${${platformName}_${lang}_SurrenderPolicy_SelectOption}    timeout=40s
        Click Element    ${${platformName}_${lang}_SurrenderPolicy_SelectOption}
        Take Screenshot    Surrender Page
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END