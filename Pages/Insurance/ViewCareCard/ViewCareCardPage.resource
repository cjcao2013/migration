*** Settings ***

Library    AppiumLibrary
Resource    ../../../PageObjects/Insurance/ViewCareCard/ViewCareCardPageObjects.resource
Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/Common/CommonMethodObjects.resource


*** Keywords ***
View care card
    TRY
        ${Android_EN_InsurancePage}       Set Variable    android=new UiSelector().text("${Flow_Flag}")
        ${iOS_EN_InsurancePage}           Set Variable    chain=**/XCUIElementTypeButton[`label == '${Flow_Flag}'`]
        Wait Until Element Is Visible      ${${platformName}_${lang}_InsurancePage}            timeout=30s
        Take Screenshot     FWD_Insurance_Page
        Click Element       ${${platformName}_${lang}_InsurancePage}
        Set or enter PIN
        Sleep   0.5s
        #      Select Insurance Flow
        ${Android_EN_Insurance_Module}    Set Variable     android=new UiSelector().textContains("${Insurance_Flow}")
        ${iOS_EN_Insurance_Module}        Set Variable     chain=**/XCUIElementTypeOther[`label CONTAINS '${Insurance_Flow}'`][-1]
        Wait Until Element Is Visible    ${${platformName}_${lang}_Insurance_Module}        timeout=20s
        Click Element    ${${platformName}_${lang}_Insurance_Module}
        Sleep   1s
        ${status}       Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_ClosePopup}        timeout=5s
        IF    '${status}' == 'True'
             Click Element    ${${platformName}_${lang}_ClosePopup}
        END


        ${status}       Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_OKPopup}        timeout=5s
        IF    '${status}' == 'True'
             Click Element    ${${platformName}_${lang}_OKPopup}
        END

        #select policy  number
        ${iOS_EN_selectViewcardPolicy}      Set Variable     chain=**/XCUIElementTypeOther[`name CONTAINS " Policy no: ${Policy_No}"`][-1]
        ${Android_EN_selectViewcardPolicy}      Set Variable     android=
        Wait Until Element Is Visible   ${${platformName}_${lang}_selectViewcardPolicy}
        Take Screenshot     Select policy
        Click Element   ${${platformName}_${lang}_selectViewcardPolicy}
        Run Keyword     Download View Care Card Document for ${platformName}

        ${actualResult}=    Catenate    ${actualResult}     | FWD Insurance Flow of ${Insurance_Flow} Successful   : View care card for policy ${Policy_No}
        Set Global Variable    ${actualResult}

        Wait Until Element Is Visible   ${${platformName}_${lang}_carecardpreviewDocument_backBtn}
        Click Element   ${${platformName}_${lang}_carecardpreviewDocument_backBtn}

        Wait Until Element Is Visible   ${${platformName}_${lang}_UpdatePolicyBackButton}
        Click Element   ${${platformName}_${lang}_UpdatePolicyBackButton}

        #now check view care card in my policy section
         #      Select My Policy Flow
          Wait Until Element Is Visible    ${${platformName}_${lang}_MyPolicy_SellAll_Tab}
          Take Screenshot   Insurance Page
          Click Element    ${${platformName}_${lang}_MyPolicy_SellAll_Tab}
          ${iOS_EN_selectedPolicyView}      Set Variable    xpath=//XCUIElementTypeOther[contains(@name, "${Policy_No}")]/following-sibling::XCUIElementTypeOther[@name="More details"]
          ${Android_EN_selectedPolicyView}      Set Variable
          Scroll Till Transaction Is Visible    ${${platformName}_${lang}_selectedPolicyView}
          Take Screenshot   View Policy Page
          Click Element     ${${platformName}_${lang}_selectedPolicyView}

          Wait Until Element Is Visible    ${${platformName}_${lang}_MyPolicyCareCardOption}
          Take Screenshot   View Policy Page
          Click Element    ${${platformName}_${lang}_MyPolicyCareCardOption}

          Wait Until Element Is Visible   ${${platformName}_${lang}_carecardpreviewDocument_backBtn}
          Take Screenshot   Preview care card document

           #download document from view policy section
          Run Keyword     Download View Care Card Document for ${platformName}


        ${actualResult}=    Catenate    ${actualResult}     | FWD Insurance Flow of View care card for policy ${Policy_No} from My Policy Successful
        Set Global Variable    ${actualResult}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END

Download View Care Card Document for iOS

    Wait Until Element Is Visible    ${${platformName}_${lang}_viewcardDocument_Download_Button}     timeout=100s
    Click Element    ${${platformName}_${lang}_viewcardDocument_Download_Button}

    Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Popup_Download_Button}   timeout=10s
    Take Screenshot    ViewPolicy_Documents_Download_Page
    Click Element    ${${platformName}_${lang}_Document_Popup_Download_Button}

    Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Download_SaveFiles}     timeout=10s
    Take Screenshot    ViewPolicy_Documents_Download_Options
    Click Element    ${${platformName}_${lang}_Document_Download_SaveFiles}

    Wait Until Element Is Visible       ${${platformName}_${lang}_DocumentName}         timeout=10s
    Clear Text    ${${platformName}_${lang}_DocumentName}
    Input Text    ${${platformName}_${lang}_DocumentName}           ViewcareCard.pdf
    Take Screenshot     Document Downloaded

    ${status}   Run Keyword And Return Status    Click Element    ${${platformName}_${lang}_Document_SaveButton}

    ${status}       Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_SaveNotificationPopUp}      timeout=10s
    IF    '${status}' == 'True'
        Click Element    ${${platformName}_${lang}_SaveNotificationPopUp}
    END