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
Claim Outpatient surgery
    PromptPayHeadsPopup
    Wait Until Element Is Visible    ${${platformName}_${lang}_treatmentdate}    timeout=20s
    SwipePage


     # Input recript number
    ${Recript_number}      generate random string  10  [NUMBERS]
    Set Global Variable    ${Recript_number}

    Input Text    ${${platformName}_${lang}_ReceiptNumber}    ${Recript_number}\n

    # input treatment date field
    Clear Text    ${${platformName}_${lang}_treatmentdate}
    Input Text    ${${platformName}_${lang}_treatmentdate}    ${dob}\n
    #add medical center
    Add Medical Center

    #treatment item and amount type
    Wait Until Element Is Visible    ${${platformName}_${lang}_totalcostPaid}    timeout=50s
    Input Text    ${${platformName}_${lang}_totalcostPaid}    ${TotalAmountPaid}\n
    Take Screenshot    Claim_OverwiewPage
    SwipePage
    Wait Until Element Is Visible    ${${platformName}_${lang}_ClaimchkBox}    timeout=20s
    Click Element    ${${platformName}_${lang}_ClaimchkBox}
    Take Screenshot    Claim_Step2_Page
    Click Element    ${${platformName}_${lang}_nextBtn}
