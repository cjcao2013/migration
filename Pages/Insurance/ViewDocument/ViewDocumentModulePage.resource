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
        ${Android_EN_InsurnacePage}       Set Variable    android=new UiSelector().text("${Flow_Flag}")
        ${iOS_EN_InsurnacePage}           Set Variable    chain=**/XCUIElementTypeButton[`label == '${Flow_Flag}'`]
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_InsurnacePage}
          IF    '${status}' == 'True'
                Take Screenshot     FWD_Insurance_Page
                Click Element       ${${platformName}_${lang}_InsurnacePage}
          END

#        Set or enter PIN
        Pause Execution
        ${Android_EN_Insurance_Module}    Set Variable    android=new UiSelector().textContains("View")
        ${iOS_EN_Insurance_Module}    Set Variable        chain=**/XCUIElementTypeOther[`label CONTAINS 'View'`][-1]
    #    ...    chain=**/XCUIElementTypeOther[`label == "${Insurance_Flow}"`]
        Wait Until Element Is Visible    ${${platformName}_${lang}_Insurance_Module}
        Click Element    ${${platformName}_${lang}_Insurance_Module}

        #select policy
        Select Policy
        Sleep    3s
        Take Screenshot    Select Policy
        ${status}       Run Keyword And Return Status    Wait Until Element Is Visible      ${${platformName}_${lang}_NextButton}       timeout=5s
        IF  '${status}' == 'True'
                Click Element    ${${platformName}_${lang}_NextButton}
        END


        #select document
        ${iOS_EN_selectDocument}   Set Variable    chain=**/XCUIElementTypeOther[`name == "${DocumentTypeName}"`]
        ${Android_EN_selectDocument}    Set Variable    xpath=(//android.widget.TextView[@text="${DocumentTypeName}"])[last()]
        Wait Until Element Is Visible    ${${platformName}_${lang}_selectDocument}
        Click Element    ${${platformName}_${lang}_selectDocument}
        Take Screenshot    Document Type Select Page
        Run Keyword        Document Preview And Download for ${platformName}
        Set Global Variable    ${result}    ${DocumentTypeName} Document Download Completed Successfully for policy No: ${Policy_No}
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

Document Preview And Download for Android
    # Document Preview & Download
    TRY
            Wait Until Element Is Visible    xpath=//android.widget.TextView[@text='${Preview_Document_Name}'][last()]
            Take Screenshot    View Policy Document Page
            Click Element    xpath=//android.widget.TextView[@text='${Preview_Document_Name}'][last()]

            Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Preview_Document}    timeout=10s
            Take Screenshot    ViewPolicy_Documents_Preview_Page

            Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Download_Button}     timeout=10s
            Click Element    ${${platformName}_${lang}_Document_Download_Button}

            Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Popup_Download_Button}   timeout=10s
            Take Screenshot    ViewPolicy_Documents_Download_Page
            Click Element    ${${platformName}_${lang}_Document_Popup_Download_Button}

            Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Download_Document_Name}  timeout=10s
            ${Document_Download_Name}       Get Text        ${${platformName}_${lang}_Document_Download_Document_Name}
            ${Document_Download_Name}      Strip String     ${Document_Download_Name}

            Take Screenshot    ViewPolicy_Documents_Download_Name_${Document_Download_Name}

            #            CommonMethod.Scroll Till Transaction Is Visible    ${${platformName}_${lang}_Document_Print_Button}
            ${Status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Print_Button}    timeout=10s
            WHILE    '${Status}' != 'True'
                ${hight}    Get Window Height
                ${width}    Get Window Width
                ${mid}    Evaluate    ${hight}/2
                ${hight}    Evaluate    ${hight}/1.1
                ${width}    Evaluate    ${width}/2
                Swipe    ${width}    ${hight}    ${width}    ${mid}
                ${Status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Print_Button}    timeout=10s
            END
            Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Print_Button}    timeout=10s
            Click Element    ${${platformName}_${lang}_Document_Print_Button}

            Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Dropdown_List}   timeout=10s
            Click Element    ${${platformName}_${lang}_Document_Dropdown_List}

            Wait Until Element Is Visible    ${${platformName}_${lang}_Document_SaveAsPDF_txt}   timeout=10s
            Click Element    ${${platformName}_${lang}_Document_SaveAsPDF_txt}

            Take Screenshot    Save_Documents_As_PDF

            Wait Until Element Is Visible    ${${platformName}_${lang}_Document_Save_To_PDF}   timeout=10s
            Click Element    ${${platformName}_${lang}_Document_Save_To_PDF}
            Sleep    10s
            Take Screenshot    Save_PDF_File_Path

            Wait Until Element Is Visible    ${${platformName}_${lang}_Document_PDF_Name_TextBox}    timeout=10s
            Clear Text    ${${platformName}_${lang}_Document_PDF_Name_TextBox}
            Click Element    ${${platformName}_${lang}_Document_PDF_Name_TextBox}
            Input Text Into Current Element    ${Document_Download_Name}
            Hide Keyboard
            Take Screenshot    Download_Document_Name_Change
            Wait Until Element Is Visible    ${${platformName}_${lang}_Document_SAVE_Button}     timeout=10s
            Click Element    ${${platformName}_${lang}_Document_SAVE_Button}
            Sleep    1s
            Take Screenshot    Save_PDF_File_Name

            # Move File From Mobile Storage To Screenshot Folder
            Sleep    5s
            ${file}      Pull File              path=/storage/emulated/0/Download/${Document_Download_Name}
            Convert Base64 To File              ${Document_Download_Name}     ${file}    ${screenshotPath}

            Wait Until Element Is Visible    ${${platformName}_${lang}_previewDocument_backBtn}
            Click Element    ${${platformName}_${lang}_previewDocument_backBtn}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   Document Preview And Download for iOS
    END
