*** Settings ***
Library     AppiumLibrary
Library     Dialogs
Resource    ../../../CustomLibraries/common.robot
Resource    ../../../PageObjects/Insurance/Common/LoginPageObjects.resource
Resource    ../../Pages/Insurance/Common/Common/AddOTP.resource
Resource    ../../Pages/Insurance/Common/CommonMethod.resource
Resource    ../../PageObjects/Engagement/EngagementBannerPageObject.robot
Library     FakerLibrary


*** Variables ***
${VP_ByDefault_Lang}    ${EMPTY}


*** Keywords ***
Engagement Banner
    TRY
        Take Screenshot    Engagement Banner
        Sleep    3s
        Run Keyword    ${Engagement_Quick_link_Module}
        Take Screenshot    Engagement Quick link
        Set Global Variable    ${result}   Engagement Quick link Module Successfully Done For ${Engagement_Quick_link_Module}
        ${OPUS_OR_OWB_App}          Set Variable         ${EMPTY}
        Set Global Variable        ${OPUS_OR_OWB_App}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END

Tax Season Banner Link Redirection
    Take Screenshot    Engagement Banner

    Wait Until Element Is Visible       ${${platformName}_${lang}_TaxDeducationBanner}       timeout=10s
    IF    '${platformName}' == 'iOS'
        Click by Coordinates    202    426
    ELSE
        Click Element    ${${platformName}_${lang}_TaxDeducationBanner}
    END
    Set or enter PIN

    Take Screenshot    Engagement Banner
    Wait Until Element Is Visible       ${${platformName}_${lang}_TaxDeducationPage}       timeout=10s
    Click Element    ${${platformName}_${lang}_TaxDeducationPage}

    Take Screenshot    Engagement Banner
    Click Element    ${${platformName}_${lang}_UpdatePolicyBackButton}

    Take Screenshot    Engagement Banner
    Wait Until Element Is Visible       ${${platformName}_${lang}_TaxDeducationViewOrDownload}       timeout=10s
    Click Element    ${${platformName}_${lang}_TaxDeducationViewOrDownload}
    Sleep    5s
    Take Screenshot    Engagement Banner

Timely services link redirection
   Take Screenshot    Engagement Banner
    ${Android_EN_InsurancePage}    Set Variable    android=new UiSelector().text("Insurance")
    ${iOS_EN_InsurancePage}    Set Variable    chain=**/XCUIElementTypeButton[`label == 'Insurance'`]
    Wait Until Element Is Visible    ${${platformName}_${lang}_InsurancePage}    timeout=30s
    Take Screenshot    FWD_Insurance_Page
    Click Element    ${${platformName}_${lang}_InsurancePage}
    Set or enter PIN
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    ${${platformName}_${lang}_HelpUsProvideInfoQuickLink}    timeout=30s
    IF    '${status}' == 'True'
        Click Element   ${${platformName}_${lang}_HelpUsProvideInfoQuickLink}
        Sleep    3s
        Take Screenshot     update_Personal_details_page
#        Click Element   ${${platformName}_${lang}_UpdatePolicyBackButton}
    END
    Take Screenshot    Engagement Banner

Health Journey Link Redirection
    Take Screenshot    Engagement Banner

    Scroll Till Transaction Is Visible      ${${platformName}_${lang}_HealthBeginsWithYouQuickLink}
    Click Element    ${${platformName}_${lang}_HealthBeginsWithYouQuickLink_LetsStart}
    Take Screenshot    Engagement Banner
    Click Element   ${${platformName}_${lang}_UpdatePolicyBackButton}
    Take Screenshot    Engagement Banner

Geolocator Link redirection
    Take Screenshot    Engagement Banner
    ${Android_EN_InsurancePage}    Set Variable    android=new UiSelector().text("Insurance")
    ${iOS_EN_InsurancePage}    Set Variable    chain=**/XCUIElementTypeButton[`label == 'Insurance'`]
    Wait Until Element Is Visible    ${${platformName}_${lang}_InsurancePage}    timeout=30s
    Take Screenshot    FWD_Insurance_Page
    Click Element    ${${platformName}_${lang}_InsurancePage}
    Set or enter PIN
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    ${${platformName}_${lang}_GeolocatorLink}    timeout=30s
    IF    '${status}' == 'True'
        Click Element   ${${platformName}_${lang}_GeolocatorLink}
        Take Screenshot    Engagement Banner

        ${Status}    Run Keyword And Return Status
        ...    Wait Until Page Contains Element
        ...    ${${platformName}_${lang}_dontallow_access}
        ...    timeout=20s
        IF    '${Status}' == 'True'
            Click Element    ${${platformName}_${lang}_dontallow_access}
        END
        Wait Until Element Is Visible    ${${platformName}_${lang}_CountineWithoutSharing}   timeout=30s
        Click Element   ${${platformName}_${lang}_CountineWithoutSharing}

        Take Screenshot    Engagement Banner
#        Click Element   ${${platformName}_${lang}_UpdatePolicyBackButton}
    END