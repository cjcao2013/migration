*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     String
Library     DateTime
Resource    ../../../CustomLibraries/common.robot
Resource    ../../../PageObjects/Insurance/Claims/ClaimsPageObjects.resource
Resource    ../Common/GUIPage.resource
Resource    ../Common/UploadDocuments.resource
Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/UpdatePoliciesmoduleSelectPageObject.resource
Resource    ClaimsPage.resource

*** Keywords ***
Claim Critical illness including cancer
    PromptPayHeadsPopup
    Wait Until Element Is Visible    ${${platformName}_${lang}_treatmentdate}    timeout=20s
    SwipePage
    # input treatment date field
    Clear Text    ${${platformName}_${lang}_treatmentdate}
    Input Text    ${${platformName}_${lang}_treatmentdate}    ${dob}\n
    #add medical center
    Add Medical Center
    SwipePage
    Wait Until Element Is Visible    ${${platformName}_${lang}_cancer_relatedChkBox}    timeout=120s
    Click Element    ${${platformName}_${lang}_cancer_relatedChkBox}
    Wait Until Element Is Visible    ${${platformName}_${lang}_ClaimchkBox}    timeout=20s
    Click Element    ${${platformName}_${lang}_ClaimchkBox}
    Take Screenshot    Claim_Step2_Page
    Click Element    ${${platformName}_${lang}_nextBtn}