*** Settings ***
Library     AppiumLibrary
Library     ../../../CustomLibraries/upload_image_bs.py
Library     Dialogs
Resource    ../../../PageObjects/Insurance/Common/UploadDocumentObjects.resource
Resource    ../../../CustomLibraries/common.robot


*** Keywords ***
Upload Document BS
    [Arguments]    ${Path}
    TRY
        ${Status}       Run Keyword And Return Status    Wait Until Page Contains Element   ${${platformName}_${lang}_while_using_app}     timeout=2s
        IF    '${Status}' == 'True'
             Click Element    ${${platformName}_${lang}_while_using_app}
        END

        ${Status}       Run Keyword And Return Status    Wait Until Page Contains Element   ${${platformName}_${lang}_dontallow_access}     timeout=2s
        IF    '${Status}' == 'True'
             Click Element    ${${platformName}_${lang}_dontallow_access}
        END
        ${Status}       Run Keyword And Return Status    Wait Until Page Contains Element   ${${platformName}_${lang}_allow_Option}     timeout=2s
        IF    '${Status}' == 'True'
             Click Element    ${${platformName}_${lang}_allow_Option}
        END
        ${Status}       Run Keyword And Return Status    Wait Until Page Contains Element   ${${platformName}_${lang}_UploadDocument_Ok_Popup}   timeout=2s
        IF    '${Status}' == 'True'
             Click Element    ${${platformName}_${lang}_UploadDocument_Ok_Popup}
        END
        Sleep    0.5s
        IF  '${Update_Policy_Module}' == 'Submit'
            ${Status}    Run Keyword And Return Status
            ...    Wait Until Page Contains Element
            ...    ${${platformName}_${lang}_make_claim}
            ...    timeout=2s
            IF    '${Status}' == 'True'
                Click Element    ${${platformName}_${lang}_make_claim}
            END
            ${Status}    Run Keyword And Return Status
            ...    Wait Until Page Contains Element
            ...    ${${platformName}_${lang}_Start_Camera}
            ...    timeout=2s
            IF    '${Status}' == 'True'
                Click Element    ${${platformName}_${lang}_Start_Camera}
            END
        END
        TEST Upload Image    ${Path}    ${user}    ${accessKey}
        Sleep    0.5s
        ${Status}     Run Keyword And Return Status   Wait Until Element Is Visible       ${${platformName}_${lang}_obj_captureImage1}             timeout=3s
        IF    '${Status}' == 'True'
              Click Element    ${${platformName}_${lang}_obj_captureImage1}
        END
        Take Screenshot    Document Upload
#       Pause Execution
        ${Status}     Run Keyword And Return Status   Wait Until Element Is Visible       ${${platformName}_${lang}_GalleryDone}             timeout=5s
        IF    '${Status}' == 'True'
                Sleep    1s
                Click Element       ${${platformName}_${lang}_GalleryDone}
        ELSE
                Click Element       ${${platformName}_${lang}_GalleyNext}
        END

        ${Status}    Run Keyword And Return Status
        ...    Wait Until Page Contains Element
        ...    ${${platformName}_${lang}_UploadDocument_JustConfirm_Yes}
        ...    timeout=20s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_UploadDocument_JustConfirm_Yes}
        END


     EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Upload Document BS
     END

