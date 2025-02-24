*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     QraceHelper
Library     DateTime
Resource    ../../../CustomLibraries/common.robot
Resource    ../../../PageObjects/Insurance/UpdatePolicy/FreelookupPageObjects.resource
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource


*** Keywords ***
Cancel
    TRY
        Take Screenshot    FLC Page
        Wait Until Element Is Visible    ${${platformName}_${lang}_FreelookCancelation_Option}    timeout=10s
        Take Screenshot    FLC Page
        Take Screenshot    Freelookcancelation Option
        Click Element    ${${platformName}_${lang}_FreelookCancelation_Option}
        Select Policy
        Take Screenshot    recommendation msg
        Wait Until Element Is Visible    ${iOS_EN_recommendMsg}    timeout=2w
        ${VP_Recommendation_Msg}    Get Text    ${iOS_EN_recommendMsg}
        Set Calc VP With Source And Original Values
            ...    Recommendation_msg
            ...    We recommend to continue your policy
            ...    ${VP_Recommendation_Msg}
            ...    Static
            ...    Omne Application
            ...    We recommend to continue your policy
            ...    ${VP_Recommendation_Msg}

        Click Element    ${iOS_EN_Close}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END
