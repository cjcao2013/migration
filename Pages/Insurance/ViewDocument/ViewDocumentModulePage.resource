*** Settings ***
Library     AppiumLibrary
Library     SeleniumLibrary
Library     ../../DBQuery/DBQuerySelect.py
Library     QraceHelper
Library     DateTime
Library     ../../DBQuery/ViewPolicyDB.py
Resource    ../../../CustomLibraries/common.robot
Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/UpdatePoliciesmoduleSelectPageObject.resource
Resource    ../../../PageObjects/Insurance/ViewDocument/ViewDocumentModulePageObjects.resource


*** Keywords ***
View Document
    TRY
        #navigate to my policy page
        ${Android_EN_InsurnacePage}       Set Variable    android=new UiSelector().text("Insurance")
        ${iOS_EN_InsurnacePage}           Set Variable    chain=**/XCUIElementTypeButton[`label == '${Flow_Flag}'`]
        Wait Until Element Is Visible      ${${platformName}_${lang}_InsurnacePage}            timeout=30s
        Take Screenshot     FWD_Insurance_Page
        Click Element       ${${platformName}_${lang}_InsurnacePage}
        Set or enter PIN
        ${Android_EN_Insurance_Module}    Set Variable    android=new UiSelector().textContains("Manage")
        ${iOS_EN_Insurance_Module}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS 'View'`][-1]
    #    ...    chain=**/XCUIElementTypeOther[`label == "${Insurance_Flow}"`]
        Wait Until Element Is Visible    ${${platformName}_${lang}_Insurance_Module}
        Click Element    ${${platformName}_${lang}_Insurance_Module}

        #select policy
        ${Android_SelectPolicyNo}    Set Variable    android=new UiSelector().textContains("${Policy_No}")
        ${iOS_SelectPolicyNo}    Set Variable    chain=**/XCUIElementTypeOther[`name CONTAINS "Policy no: ${Policy_No}"`][-1]
        Wait Until Page Contains Element    ${${platformName}_SelectPolicyNo}
        Click Element    ${${platformName}_SelectPolicyNo}
        Sleep    3s
        Take Screenshot    Select Policy
        Wait Until Element Is Visible    ${${platformName}_${lang}_NextButton}
        Click Element    ${${platformName}_${lang}_NextButton}

        #select document
        ${iOS_EN_selectDocument}   Set Variable    chain=**/XCUIElementTypeOther[`name == "${DocumentTypeName}"`]
        Wait Until Element Is Visible    ${${platformName}_${lang}_selectDocument}
        Click Element    ${${platformName}_${lang}_selectDocument}
        Take Screenshot    Document Type Select Page
        Document Preview And Download for iOS
        Set Global Variable    ${result}    Document Download Completed Successfully for policy No: ${Policy_No}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END

Document Preview And Download for iOS
    TRY
        Wait Until Element Is Visible    chain=**/XCUIElementTypeOther[`label CONTAINS "${Preview_Document_Name}"`][-1]
        Click Element    chain=**/XCUIElementTypeOther[`label CONTAINS "${Preview_Document_Name}"`][-1]

        Take Screenshot    ViewPolicy_Documents_Preview_Page

        Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Download_Button}     timeout=100s
        Click Element    ${${platformName}_${lang}_Document_Download_Button}

        Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Popup_Download_Button}   timeout=10s
        Take Screenshot    ViewPolicy_Documents_Download_Page
        Click Element    ${${platformName}_${lang}_Document_Popup_Download_Button}
        Sleep    2s

        Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Download_SaveFiles}     timeout=10s
        Take Screenshot    ViewPolicy_Documents_Download_Options
        Click Element    ${${platformName}_${lang}_Document_Download_SaveFiles}
        Sleep    2s

        Wait Until Element Is Visible       ${${platformName}_${lang}_DocumentName}         timeout=10s
        Clear Text    ${${platformName}_${lang}_DocumentName}
        Input Text    ${${platformName}_${lang}_DocumentName}           ${Preview_Document_Name}.pdf

        ${status}   Run Keyword And Return Status    Click Element    ${${platformName}_${lang}_Document_SaveButton}
        Sleep    2s

        ${status}       Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_SaveNotificationPopUp}      timeout=10s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_SaveNotificationPopUp}
            Sleep    2s
        END
        Wait Until Element Is Visible    ${${platformName}_${lang}_previewDocument_backBtn}        timeout=100s
        Click Element    ${${platformName}_${lang}_previewDocument_backBtn}
        Take Screenshot    ViewPolicy_Documents_Download_Page
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   Document Preview And Download for iOS
    END