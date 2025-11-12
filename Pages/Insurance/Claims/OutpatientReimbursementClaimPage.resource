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
Claim Outpatient reimbursement
    PromptPayHeadsPopup
    #select claim is about
    Select claim is About

    #claim check box
    Click Element    ${${platformName}_${lang}_ClaimchkBox}
    Take Screenshot    Claim_Step2_Page
    Click Element    ${${platformName}_${lang}_nextBtn}



    # Input recript number
    ${Recript_number}      generate random string  10  [NUMBERS]
    Set Global Variable    ${Recript_number}
    
    Input Text    ${${platformName}_${lang}_ReceiptNumber}    ${Recript_number}\n

    # add claimdetails
    Wait Until Element Is Visible    ${${platformName}_${lang}_treatmentdate}    timeout=50s
    IF    '${testtype}'!='NEGATIVE' and '${Transaction_Page_GUI}' == 'Yes'
        Verify ClaimDetails Step2 Page GUI
    END
    Take Screenshot    ClaimDetails_Step2_Page
    IF    '${ClaimIsAbout}' == 'Accident'
        Input Text    ${${platformName}_${lang}_accidentDate}    ${AccidentDate}\n
    END

    #treatment date
    ${value}    Get Text    ${${platformName}_${lang}_treatmentdate}
    Clear Text    ${${platformName}_${lang}_treatmentdate}
    Input Text    ${${platformName}_${lang}_treatmentdate}    ${dob}\n

    #add diagnosis
    Add Diagnosis

    #add medical center
    Add Medical Center

    #treatment item and amount type
    Wait Until Element Is Visible    ${${platformName}_${lang}_totalAmountPaid}    timeout=20s
    Input Text    ${${platformName}_${lang}_totalAmountPaid}    ${TotalAmountPaid}\n
    Take Screenshot    ClaimDetailsPage
    Wait Until Element Is Visible    ${${platformName}_${lang}_treatmentitems}    timeout=20s
    Click Element    ${${platformName}_${lang}_treatmentitems}
    @{medicaltreatment}    Split String    ${MedicalTreatment}    ,
    ${treatmentcount}    Get Length    ${medicaltreatment}
    FOR    ${counter}    IN RANGE    0    ${treatmentcount}
        ${treatment}    Get From List    ${medicaltreatment}    ${counter}
        IF    '${testtype}'!='NEGATIVE'
            ${mtreatment}    Get English To Thai Value    ${treatment}
            Set Calc VP Expected Result With Original And Source
            ...    Treatment_${counter}
            ...    ${mtreatment}
            ...    ${treatment}
            ...    OMNE_ClaimPage
        END
        ${iOS_SelectTreatment}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${treatment}'`][-1]
        ${Android_SelectTreatment}    Set Variable
        ...    xpath=//android.widget.TextView[contains(@text,'${treatment}')]
        Wait Until Element Is Visible    ${${platformName}_SelectTreatment}    timeout=10s
        Click Element    ${${platformName}_SelectTreatment}
    END
    Wait Until Element Is Visible    ${${platformName}_${lang}_treatmentitemsDoneBtn}    timeout=10s
    Click Element    ${${platformName}_${lang}_treatmentitemsDoneBtn}
    Wait Until Element Is Visible    ${${platformName}_${lang}_nextBtn}    timeout=10s
    Take Screenshot    ClaimDetailsPage
    Click Text    Next    exact_match=true


