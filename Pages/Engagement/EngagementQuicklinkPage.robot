*** Settings ***
Library     AppiumLibrary
Library     Dialogs
Resource    ../../CustomLibraries/common.robot

Resource    ../Insurance/Common/AddOTP.resource
Resource    ../Insurance/Common/CommonMethod.resource
Resource    ../../PageObjects/Engagement/EngagementQuicklinkPageObject.robot

Library     FakerLibrary


*** Variables ***
${VP_ByDefault_Lang}    ${EMPTY}


#*** Keywords ***
#Engagement Quick link
#    TRY
#        #Wait Until Page Contains Element    chain=**/XCUIElementTypeOther[`label CONTAINS '${Engagement_Quick_link_Module}'`][-1]     timeout=10s
#        Take Screenshot    Engagement Quick link
#        Sleep    2s
#
#    #    Click Text    ${Engagement_Quick_link_Module}       exact_match=true
#        IF    '${Engagement_Quick_link_Module}' == 'My policy(s)'
#            Click by Coordinates    78    502
#        ELSE IF     '${Engagement_Quick_link_Module}' == 'Manage policy(s)'
#            Click by Coordinates    322    502
#        ELSE
#            Click by Coordinates    205    502
#        END
#        Take Screenshot    Engagement Quick link
#        Set or enter PIN
#        Take Screenshot    Engagement Quick link
#        Set Global Variable    ${result}   Engagement Quick link Module Successfully Done For ${Engagement_Quick_link_Module}
#        ${OPUS_OR_OWB_App}          Set Variable         ${EMPTY}
#        Set Global Variable        ${OPUS_OR_OWB_App}
#    EXCEPT     AS  ${reason}
#        Set Failed Actual Result and VP       Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
#    END


*** Keywords ***
Engagement Quick link
    TRY
        Run Keyword    ${Engagement_Quick_link_Module}
        Take Screenshot    Engagement Quick link
        Set or enter PIN
        Take Screenshot    Engagement Quick link
        Set Global Variable    ${result}   Engagement Quick link Module Successfully Done For ${Engagement_Quick_link_Module}


    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   FWD Engagement Flow of ${Engagement_Quick_link_Module}
    END
Engagement_My policy(s)
    TRY
        #Wait Until Page Contains Element    chain=**/XCUIElementTypeOther[`label CONTAINS '${Engagement_Quick_link_Module}'`][-1]     timeout=10s
        Take Screenshot    Engagement Quick link
        Sleep    2s
        IF    '${platformName}' == 'iOS'
            Click by Coordinates    78    502
        ELSE
            Wait Until Element Is Visible    ${${platformName}_${lang}_Quicklink_mypolicy}    timeout=5s
            Click Element    ${${platformName}_${lang}_Quicklink_mypolicy}
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   FWD Engagement Flow of ${Engagement_Quick_link_Module}
    END

Engagement_Manage policy(s)
    TRY
        Take Screenshot    Engagement Quick link
        Sleep    2s
        IF    '${platformName}' == 'iOS'
            Click by Coordinates    322    502
        ELSE
            Wait Until Element Is Visible    ${${platformName}_${lang}_Quicklink_mangepolicy}    timeout=5s
            Click Element    ${${platformName}_${lang}_Quicklink_mangepolicy}
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   FWD Engagement Flow of ${Engagement_Quick_link_Module}
    END
Engagement_Submit claim
    TRY
        Take Screenshot    Engagement Quick link
        Sleep    2s
        IF    '${platformName}' == 'iOS'
            Click by Coordinates    205    502
        ELSE
            Wait Until Element Is Visible    ${${platformName}_${lang}_Quicklink_submitClaim}    timeout=5s
            Click Element    ${${platformName}_${lang}_Quicklink_submitClaim}
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   FWD Engagement Flow of ${Engagement_Quick_link_Module}
    END

Engagement_Buy_Insurance
    [Documentation]  To check the Buy insurance flow for Native lead form and microsite
    TRY
        Take Screenshot    Engagement Quick link
        IF    '${platformName}' == 'iOS'
            Click by Coordinates    61    573
        ELSE
            Click Element    xpath=//android.widget.TextView[contains(@text,"Submit")]
        END
        ${${platformName}_${lang}_Cockies}  Set Variable    accessibility_id=OK
        ${status}    Run Keyword And Return Status      Wait Until Element Is Visible    ${${platformName}_${lang}_Cockies}     timeout=20s
        IF    '${status}' == 'True'
             Click Element    ${${platformName}_${lang}_Cockies}
        END
        ${status}    Run Keyword And Return Status  Wait Until Element Is Visible    ${iOS_EN_Continue_with_Omne}   timeout=20s
        IF    '${status}' == 'True'
             Take Screenshot    Thank_you_PopUp
             Click Element    ${iOS_EN_Continue_with_Omne}

             Set Global Variable    ${result}   Engagement Quick link Module Successfully Done For ${Engagement_Quick_link_Module}
        END
        ${Agency_status}    Run Keyword And Return Status      Wait Until Element Is Visible   ${${platformName}_${lang}_LeadFormTitle}    timeout=20s
        ${${platformName}_${lang}_SelectInsuranceToBuy}	    Set Variable	chain=**/XCUIElementTypeStaticText[`name == "${InsuranceName}"`]
        ${DC_status}    Run Keyword And Return Status  Wait Until Element Is Visible    ${${platformName}_${lang}_SelectInsuranceToBuy}    timeout=20s
#       Agency flow
        IF    '${Agency_status}' == 'True'
            Take Screenshot    Native_Lead_Form
            ${${platformName}_${lang}_selectInsuranceCoverage}	    Set Variable	chain=**/XCUIElementTypeOther[`name == "${selectInsuranceCoverage}"`]
            Click Element    ${${platformName}_${lang}_selectInsuranceCoverage}
            Scroll Till Transaction Is Visible    ${${platformName}_${lang}_InsuranceCoverageCheckbox}
            Click Element    ${${platformName}_${lang}_InsuranceCoverageCheckbox}
            Wait Until Element Is Visible    ${${platformName}_${lang}_InsuranceCoverageSubmitButton}    timeout=5s
            Click Element    ${${platformName}_${lang}_InsuranceCoverageSubmitButton}
            Wait Until Element Is Visible    ${${platformName}_${lang}_Continue_with_Omne}   timeout=5s
            Take Screenshot    Thank_you_PopUp
            Click Element    ${${platformName}_${lang}_Continue_with_Omne}
            Take Screenshot    HomePage

            Set Global Variable    ${result}   Engagement Quick link Module Successfully Done For ${Engagement_Quick_link_Module}
#       DC Flow
        ELSE IF     '${DC_status}' == 'True'
            Take Screenshot    Insurance Plans
            Click Element    ${${platformName}_${lang}_SelectInsuranceToBuy}
            Sleep    2s
            RefreshPage
            Wait Until Element Is Visible    ${${platformName}_${lang}_Basic_Information}      timeout=20s
            ${${platformName}_${lang}_Select_Gender}     Set Variable        chain=**/XCUIElementTypeButton[`name == "${SelectGender}"`]
            Click Element    ${${platformName}_${lang}_Select_Gender}
            Input Text    ${${platformName}_${lang}_Enter_Age}    ${Age}
            Close keyboard
            Take Screenshot    Basic Information screen
            Scroll Till Transaction Is Visible    ${${platformName}_${lang}_Buy_Online_Button}
            Click Element    ${${platformName}_${lang}_Buy_Online_Button}
            Wait Until Element Is Visible    ${${platformName}_${lang}_LetUsKnowYouText}    timeout=10s
            Sleep    2s
            Take Screenshot    Let US Know You First Page

            Set Global Variable    ${result}   Engagement Quick link Module Successfully Done For ${Engagement_Quick_link_Module}
        END

    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   FWD Insurance Flow of ${Engagement_Quick_link_Module}
    END

