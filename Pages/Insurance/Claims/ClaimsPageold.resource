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


*** Keywords ***
Submit
    TRY
        DOB
        ${Android_EN_InsurancePage}    Set Variable    android=new UiSelector().text("${Flow_Flag}")
        ${iOS_EN_InsurancePage}    Set Variable    chain=**/XCUIElementTypeButton[`label == '${Flow_Flag}'`]
        Wait Until Element Is Visible    ${${platformName}_${lang}_InsurancePage}    timeout=30s
        Take Screenshot    FWD_Insurance_Page
        IF    '${testtype}'!='NEGATIVE' and '${Transaction_Page_GUI}' == 'Yes'
            Verify FWDInsurance Page GUI
        END
        Click Element    ${${platformName}_${lang}_InsurancePage}
        Set or enter PIN
        # Biometric Page

        Take Screenshot    Claim_Page
    #    ${Android_EN_Insurance_Module}    Set Variable    android=new UiSelector().textContains("${Insurance_Flow}")
    #    ${iOS_EN_Insurance_Module}    Set Variable
    #    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${Insurance_Flow}'`][-1]
        ${Android_EN_Insurance_Module}    Set Variable    android=new UiSelector().textContains("Submit")
        ${iOS_EN_Insurance_Module}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS 'Submit'`][-1]
        Wait Until Element Is Visible    ${${platformName}_${lang}_Insurance_Module}
        Click Element    ${${platformName}_${lang}_Insurance_Module}
        Take Screenshot    Claim_Page

        IF    '${testtype}'!='NEGATIVE' and '${Transaction_Page_GUI}' == 'Yes'
            Verify Claim Step1 Page GUI
        END

        # medical receipt


        Sleep    2s
        IF    '${Claim_Type}'=='Hospitalisation'
            ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/hospClaim.png
            Upload Document BS    ${path}
        ELSE IF     '${Claim_Type}'=='Outpatient reimbursement'
            ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/OPD_Receipt.png
            Upload Document BS    ${path}
        ELSE
            ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimTemplate/ClaimFileOut.jpg
            Upload Document BS    ${path}
        END
        # medical certificate

        IF     '${Claim_Type}'=='Outpatient reimbursement'
            ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/OPD_Certificate.png
            Upload Document BS    ${path}
        ELSE
            ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/Certificate.PNG
            Upload Document BS    ${path}
        END
        Take Screenshot    Claim_Page
        Sleep    1s
        Wait Until Element Is Visible    ${${platformName}_${lang}_claimantOption}    timeout=200s
        IF    '${testtype}'!='NEGATIVE' and '${Transaction_Page_GUI}' == 'Yes'
            Verify Claim Step2 Page GUI
        END
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_claimantfield}
        ...    timeout=5s
        Click Element    ${${platformName}_${lang}_claimantOption}
        @{claimantlist}    Get Webelements    ${${platformName}_${lang}_claimantlist}
        ${totclaimantCount}    Get Length    ${claimantlist}
        ${iOS_Claimant}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Claimant}'`][-1]
        ${Android_Claimant}    Set Variable    xpath=//android.widget.TextView[contains(@text,'${Claimant}')]
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_claimementsingle}
        ...    timeout=10s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_claimementsingle}
        ELSE
            Click Element    ${${platformName}_Claimant}
        END
    #    **/XCUIElementTypeOther[`label CONTAINS 'Select claimant'`][-2]/XCUIElementTypeOther[`label CONTAINS '${Claimant}'`]
        Wait Until Element Is Visible    ${${platformName}_${lang}_ClaimTypeOption}    timeout=20s
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_claimtypefield}
        ...    timeout=5s
        Click Element    ${${platformName}_${lang}_ClaimTypeOption}
    #    @{claimtypelist}    Get Webelements    xpath=//XCUIElementTypeOther[@name='Select claim type']/following-sibling::XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther
    #    ${totclaimtypeCount}    Get Length    ${claimtypelist}
        ${iOS_ClaimType}    Set Variable    chain=**/XCUIElementTypeOther[`label BEGINSWITH "${Claim_Type}"`][-2]
        ${Android_ClaimType}    Set Variable    xpath=//android.widget.TextView[@text='${Claim_Type}']
        Sleep    1s
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_ClaimType}
        ...    timeout=30s
        Click Element    ${${platformName}_ClaimType}
        IF    '${Claim_Type}' == 'Hospitalisation'
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_prompaPayHeadspopup}
            ...    timeout=10s
            IF    '${status}'=='True'
                Take Screenshot    DaySurgeryPopUp
                Click Element    ${${platformName}_${lang}_prompaPayHeadspopup}
            END
        END
        Sleep    2s
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_policyfield}
        ...    timeout=5s
        Click Element    ${${platformName}_${lang}_PolicyOption}
    #    @{policylist}    Get Webelements    xpath=//XCUIElementTypeOther[@name='Select policy']/following-sibling::XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther
    #    ${totpolicyCount}    Get Length    ${policylist}
        ${iOS_SelectPolicy}    Set Variable
        ...    xpath=(//XCUIElementTypeOther[@name='Select policy']//following::XCUIElementTypeOther[contains(@label,'${Policy_No}')])[last()]
        ${Android_SelectPolicy}    Set Variable
        ...    xpath=//android.widget.TextView[@text='Select policy']/following::android.widget.TextView[@text='${Policy_No}']
        ${status}    Run Keyword And Return Status     Wait Until Element Is Visible    ${${platformName}_SelectPolicy}    timeout=150s
        IF    '${status}'=='True'
           Click Element    ${${platformName}_SelectPolicy}
        END
        # add claim is about
        ${iOS_SelectMedicalCentre}    Set Variable    chain=**/XCUIElementTypeOther[`label == '${MedicalCentre}'`][-1]
        ${Android_SelectMedicalCentre}    Set Variable
        ...    xpath=//android.widget.TextView[contains(@text,'${MedicalCentre}')]
        ${iOS_ClaimIsAbout}    Set Variable    chain=**/XCUIElementTypeOther[`label == '${ClaimIsAbout}'`]
        ${Android_ClaimIsAbout}    Set Variable    xpath=//android.widget.TextView[@text='${ClaimIsAbout}']
        ${iOS_SelectDiagnosis}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Diagnosis}'`][-1]
        ${Android_SelectDiagnosis}    Set Variable    xpath=//android.widget.TextView[contains(@text,'${Diagnosis}')]

        IF    '${Claim_Type}' == 'Outpatient surgery' or '${Claim_Type}' == 'Disability and dismemberment' or '${Claim_Type}' == 'Critical illness including cancer'
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_prompaPayHeadspopup}
            ...    timeout=10s
            IF    '${status}'=='True'
                Take Screenshot    DaySurgeryPopUp
                Click Element    ${${platformName}_${lang}_prompaPayHeadspopup}
            END
            Wait Until Element Is Visible    ${${platformName}_${lang}_treatmentdate}    timeout=20s
            SwipePage
            # input if treatment date field is blank
            ${value}    Get Text    ${${platformName}_${lang}_treatmentdate}
    #    IF    '${testtype}'!='NEGATIVE'
            Clear Text    ${${platformName}_${lang}_treatmentdate}
            Input Text    ${${platformName}_${lang}_treatmentdate}    ${dob}\n
    #    END
            Sleep    1s
            IF    '${MedicalCentre}' != '${EMPTY}'
                Click Element    ${${platformName}_${lang}_medicalCenterselectOption}
                ${status}    Run Keyword And Return Status
                ...    Wait Until Element Is Visible
                ...    ${${platformName}_SelectMedicalCentre}
                ...    timeout=20s
                IF    '${status}'=='True'
                    Click Element    ${${platformName}_SelectMedicalCentre}
    #                Sleep    0.5s
    #                Click Element    ${${platformName}_SelectMedicalCentre}
                     Sleep    1s
                     Wait Until Element Is Visible    ${${platformName}_${lang}_surgercymedicalcentreDoneBtn}    timeout=10s
                     Click Element    ${${platformName}_${lang}_surgercymedicalcentreDoneBtn}
                ELSE
                    Input Text    ${${platformName}_${lang}_diagnosisSearch}    ${MedicalCentre}
                    Hide Keyboard    return
                    ${status}    Run Keyword And Return Status
                    ...    Wait Until Element Is Visible
                    ...    ${${platformName}_${lang}_addNewMedicalcenter}
                    ...    timeout=20s
                    IF    '${status}'=='True'
                        Take Screenshot    Add Medical Center
                        Click Element    ${${platformName}_${lang}_addNewMedicalcenter}
                    ELSE
                        Click Element    ${${platformName}_SelectMedicalCentre}
                        Sleep    1s
                        Wait Until Element Is Visible    ${${platformName}_${lang}_surgercymedicalcentreDoneBtn}    timeout=10s
                        Click Element    ${${platformName}_${lang}_surgercymedicalcentreDoneBtn}
                    END
                END
    #            Sleep    1s
    #            Wait Until Element Is Visible    ${${platformName}_${lang}_surgercymedicalcentreDoneBtn}    timeout=10s
    #            Click Element    ${${platformName}_${lang}_surgercymedicalcentreDoneBtn}
            END
            Take Screenshot    Claim_OverwiewPage
            IF    '${Claim_Type}' == 'Outpatient surgery'
                Wait Until Element Is Visible    ${${platformName}_${lang}_totalcostPaid}    timeout=50s
                Input Text    ${${platformName}_${lang}_totalcostPaid}    ${TotalAmountPaid}\n
                Take Screenshot    Claim_OverwiewPage
            END
            IF    '${Claim_Type}' == 'Critical illness including cancer'
                SwipePage
                Wait Until Element Is Visible    ${${platformName}_${lang}_cancer_relatedChkBox}    timeout=120s
                Click Element    ${${platformName}_${lang}_cancer_relatedChkBox}
            END
            IF    '${testtype}'=='NEGATIVE'    Capture Error Message
            Click Element    ${${platformName}_${lang}_ClaimchkBox}
            Take Screenshot    Claim_Step2_Page
            Click Element    ${${platformName}_${lang}_nextBtn}
        ELSE IF    '${Claim_Type}' == 'Outpatient reimbursement'
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_prompaPayHeadspopup}
            ...    timeout=10s
            IF    '${status}'=='True'
                Take Screenshot    DaySurgeryPopUp
                Click Element    ${${platformName}_${lang}_prompaPayHeadspopup}
            END
            Wait Until Element Is Visible    ${${platformName}_ClaimIsAbout}    timeout=120s
            Click Element    ${${platformName}_ClaimIsAbout}
            Click Element    ${${platformName}_${lang}_ClaimchkBox}
            Take Screenshot    Claim_Step2_Page
            Click Element    ${${platformName}_${lang}_nextBtn}
            # add claimdetails
            Wait Until Element Is Visible    ${${platformName}_${lang}_treatmentdate}    timeout=50s
            IF    '${testtype}'!='NEGATIVE' and '${Transaction_Page_GUI}' == 'Yes'
                Verify ClaimDetails Step2 Page GUI
            END
            Take Screenshot    ClaimDetails_Step2_Page
            IF    '${ClaimIsAbout}' == 'Accident'
                Input Text    ${${platformName}_${lang}_accidentDate}    ${AccidentDate}\n
            END
            ${value}    Get Text    ${${platformName}_${lang}_treatmentdate}
    #    IF    '${testtype}'!='NEGATIVE'
            Clear Text    ${${platformName}_${lang}_treatmentdate}
            Input Text    ${${platformName}_${lang}_treatmentdate}    ${dob}\n
    #    END
            Sleep    1s
            # add Diagnosis
            Click Element    ${${platformName}_${lang}_DiagnosisOption}
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_SelectDiagnosis}
            ...    timeout=10s
            IF    '${status}'!='True'
                Click Element    ${${platformName}_${lang}_DiagnosisOption}
            END
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_SelectDiagnosis}
            ...    timeout=10s
            IF    '${status}'=='True'
                Click Element    ${${platformName}_SelectDiagnosis}
            ELSE
                Input Text    ${${platformName}_${lang}_diagnosisSearch}    ${Diagnosis}
                Hide Keyboard    return
                ${status}    Run Keyword And Return Status
                ...    Wait Until Element Is Visible
                ...    ${${platformName}_${lang}_addNewDiagnosis}
                ...    timeout=10s
                IF    '${status}'=='True'
                    Take Screenshot    AddDiagnosis
                    Click Element    ${${platformName}_${lang}_addNewDiagnosis}
                ELSE
                    Sleep    1s
                    Click Element    ${${platformName}_SelectDiagnosis}
                END
            END
            Sleep    3s
            Wait Until Element Is Visible    ${${platformName}_${lang}_diagnosisDoneBtn}    timeout=10s
            Click Element    ${${platformName}_${lang}_diagnosisDoneBtn}
            IF    '${MedicalCentre}' != '${EMPTY}'
                Click Element    ${${platformName}_${lang}_medicalCenterselectOption}
                ${status}    Run Keyword And Return Status
                ...    Wait Until Element Is Visible
                ...    ${${platformName}_SelectMedicalCentre}
                ...    timeout=10s
                IF    '${status}'=='True'
                    Click Element    ${${platformName}_SelectMedicalCentre}
                    Sleep    0.5s
                    Click Element    ${${platformName}_SelectMedicalCentre}
                ELSE
                    Input Text    ${${platformName}_${lang}_diagnosisSearch}    ${MedicalCentre}
                    Hide Keyboard    return
                    ${status}    Run Keyword And Return Status
                    ...    Wait Until Element Is Visible
                    ...    ${${platformName}_${lang}_addNewMedicalcenter}
                    ...    timeout=10s
                    IF    '${status}'=='True'
                        Take Screenshot    Add Medical Center
                        Click Element    ${${platformName}_${lang}_addNewMedicalcenter}
                    ELSE
                        Click Element    ${${platformName}_SelectMedicalCentre}
                    END
                END
                Sleep    1s
                Wait Until Element Is Visible    ${${platformName}_${lang}_medicalcentreDoneBtn}    timeout=10s
                Click Element    ${${platformName}_${lang}_medicalcentreDoneBtn}
            END
            Sleep    1s
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_medicalcentreDoneBtn}
            ...    timeout=10s
            IF    '${status}'=='True'
                Click Element    ${${platformName}_${lang}_medicalcentreDoneBtn}
            END
            SwipePage
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
            IF    '${testtype}'=='NEGATIVE'    Capture Error Message
            Take Screenshot    ClaimDetailsPage
            Click Text    Next    exact_match=true
        ELSE IF    '${Claim_Type}' == 'Hospitalisation'
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_prompaPayHeadspopup}
            ...    timeout=10s
            IF    '${status}'=='True'
                Take Screenshot    DaySurgeryPopUp
                Click Element    ${${platformName}_${lang}_prompaPayHeadspopup}
            END
            Wait Until Element Is Visible    ${${platformName}_ClaimIsAbout}    timeout=10s
            Click Element    ${${platformName}_ClaimIsAbout}
            Click Element    ${${platformName}_${lang}_ClaimchkBox}
            Take Screenshot    Claim_Step2_Page
            Click Element    ${${platformName}_${lang}_nextBtn}
            # add claimdetails
            Wait Until Element Is Visible    ${${platformName}_${lang}_hospitalsaty}    timeout=10s
            Take Screenshot    ClaimDetails_Step2_Page
            IF    '${ClaimIsAbout}' == 'Accident'
                Input Text    ${${platformName}_${lang}_accidentDate}    ${AccidentDate}\n
            END
            # checkin and checkout date
            Click Element    ${${platformName}_${lang}_hospitalsaty}
            Run Keyword    Select CheckIN and CheckOut Date
            Take Screenshot    DateSelection
            Wait Until Element Is Visible    ${${platformName}_${lang}_DobDoneBtn}    timeout=10s
            Click Element    ${${platformName}_${lang}_DobDoneBtn}
            Sleep    1s
            IF    '${MedicalCentre}' != '${EMPTY}'
                Click Element    ${${platformName}_${lang}_medicalCenterselectOption}
                ${status}    Run Keyword And Return Status
                ...    Wait Until Element Is Visible
                ...    ${${platformName}_SelectMedicalCentre}
                ...    timeout=20s
                IF    '${status}'=='True'
                    Click Element    ${${platformName}_SelectMedicalCentre}
                    Sleep    0.5s
    #                Click Element    ${${platformName}_SelectMedicalCentre}
                ELSE
                    Input Text    ${${platformName}_${lang}_diagnosisSearch}    ${MedicalCentre}
                    Hide Keyboard    return
                    ${status}    Run Keyword And Return Status
                    ...    Wait Until Element Is Visible
                    ...    ${${platformName}_${lang}_addNewMedicalcenter}
                    ...    timeout=20s
                    IF    '${status}'=='True'
                        Take Screenshot    Add Medical Center
                        Click Element    ${${platformName}_${lang}_addNewMedicalcenter}
                    ELSE
                        Click Element    ${${platformName}_SelectMedicalCentre}
                    END
                END
                Sleep    1s
                Wait Until Element Is Visible    ${${platformName}_${lang}_surgercymedicalcentreDoneBtn}    timeout=10s
                Click Element    ${${platformName}_${lang}_surgercymedicalcentreDoneBtn}
            END
            Sleep    1s
            Click Element    ${${platformName}_${lang}_DiagnosisOption}
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_SelectDiagnosis}
            ...    timeout=20s
            IF    '${status}'=='True'
                Click Element    ${${platformName}_SelectDiagnosis}
            ELSE
                Input Text    ${${platformName}_${lang}_diagnosisSearch}    ${Diagnosis}
                Hide Keyboard    return
                ${status}    Run Keyword And Return Status
                ...    Wait Until Element Is Visible
                ...    ${${platformName}_${lang}_addNewDiagnosis}
                ...    timeout=10s
                IF    '${status}'=='True'
                    Take Screenshot    AddDiagnosis
                    Click Element    ${${platformName}_${lang}_addNewDiagnosis}
                ELSE
                    Click Element    ${${platformName}_SelectDiagnosis}
                END
            END
            Sleep    5s
            Click Text    Done    exact_match=true
            Wait Until Element Is Visible    ${${platformName}_${lang}_ClaimchkBox}
            Click Element    ${${platformName}_${lang}_ClaimchkBox}
            Capture Error Message
            Take Screenshot    ClaimDetailsPage
            Sleep    1s
            Click Element    ${${platformName}_${lang}_nextBtn}
        END
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_capturerrorpopup}
        ...    timeout=5s
        IF    '${status}' == 'True'
    #    ${msg}    Get Element Attribute    ${${platformName}_${lang}_capturerrorpopup}    attribute=value
            Set Global Variable    ${errormsg}    Duplicate Claim Error
            Take Screenshot    Claim_duplicate_error
    #    Set Calc VP With Source And Original Values    ErrorMsg    Duplicate Claim Error    Duplicate Claim Error    Static    Omne_ClaimPage    Duplicate Claim Error    Duplicate Claim Error
        END
        SwipePage
        Wait Until Element Is Visible    ${${platformName}_${lang}_medicalcertificate}    timeout=15s
        IF    '${platformName}' == 'iOS'
            ${VP_medicalcertificatedoccount}    Get Element Attribute
            ...    ${${platformName}_${lang}_medicalcertificate}
            ...    attribute=label
            @{certificatecountdatasplit}    Split String    ${VP_medicalcertificatedoccount}
            ${totcertificatecount}    Get From List    ${certificatecountdatasplit}    2
            ${VP_medicalreceiptdoccount}    Get Element Attribute
            ...    ${${platformName}_${lang}_medicalreceipt}
            ...    attribute=label
            @{receiptcountdatasplit}    Split String    ${VP_medicalreceiptdoccount}
            ${totreceiptcount}    Get From List    ${receiptcountdatasplit}    1
            ${totCount}    Evaluate    ${totcertificatecount}+${totreceiptcount}
        ELSE
            ${totCount}    Get Webelements    ${${platformName}_${lang}_medicalreceipt}
            ${totCount}    Get Length    ${totCount}
        END
        Set Calc VP Expected Result With Original And Source    TotalDocument    ${totCount}    ${totCount}    Claim
        Wait Until Element Is Visible    ${${platformName}_${lang}_nextBtn}    timeout=10s
        Take Screenshot    Claim_Step2_Page
        SwipePage
        Take Screenshot    Claim_Step2_Page
        Click Element    ${${platformName}_${lang}_nextBtn}
    #    Click Text    Next    exact_match=true
        Take Screenshot    Claim_Step3_Page
        Claim Payment Method
        Set Calc VP Expected Result With Original And Source
        ...    PaymentMethod
        ...    ${PaymentMethod}
        ...    ${PaymentMethod}
        ...    Omne_ClaimReviewPage
        # capture VP
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_reviewTreatmentdate}
        ...    timeout=10s
        IF    '${status}' == 'True'
            ${VP_treatmentdate}    Get Element Attribute
            ...    ${${platformName}_${lang}_reviewTreatmentdate}
            ...    attribute=name
            @{reatmentlist}    Split String    ${VP_treatmentdate}    /
            ${day}    Get From List    ${reatmentlist}    0
            ${month}    Get From List    ${reatmentlist}    1
            ${year}    Get From List    ${reatmentlist}    2
            ${strmonth}    Month Dic    ${month}
            ${strmonth}    Get Substring    ${strmonth}    0    3
            Log To Console    ${strmonth}
            ${converttreatmentdate}    Catenate    ${day}    ${strmonth}
            ${converttreatmentdate}    Catenate    ${converttreatmentdate}    ${year}
            Set Calc VP Expected Result With Original And Source
            ...    DateOfVisit
            ...    ${converttreatmentdate}
            ...    ${converttreatmentdate}
            ...    OMNE_ClaimReviewPage
        END
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_reviewAccidentdate}
        ...    timeout=5s
        IF    '${status}' == 'True'
            ${VP_accidentdate}    Get Element Attribute    ${${platformName}_${lang}_reviewAccidentdate}    attribute=name
            @{accidentdatelist}    Split String    ${VP_accidentdate}    /
            ${day}    Get From List    ${accidentdatelist}    0
            ${month}    Get From List    ${accidentdatelist}    1
            ${year}    Get From List    ${accidentdatelist}    2
            ${strmonth}    Month Dic    ${month}
            ${strmonth}    Get Substring    ${strmonth}    0    3
            Log To Console    ${strmonth}
            ${convertaccidentdate}    Catenate    ${day}    ${strmonth}
            ${convertaccidentdate}    Catenate    ${convertaccidentdate}    ${year}
            Set Calc VP Expected Result With Original And Source
            ...    DateOfAccident
            ...    ${convertaccidentdate}
            ...    ${convertaccidentdate}
            ...    OMNE_ClaimReviewPage
        END
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_reviewDiagnosis}
        ...    timeout=5s
        IF    '${status}' == 'True'
            ${VP_reviewDiagnosis}    Get Element Attribute    ${${platformName}_${lang}_reviewDiagnosis}    attribute=name
            ${VP_reviewDiagnosis}    Replace String    ${VP_reviewDiagnosis}    -    ${SPACE}
            Set Calc VP Expected Result With Original And Source
            ...    Diagnosis
            ...    ${VP_reviewDiagnosis}
            ...    ${VP_reviewDiagnosis}
            ...    OMNE_ClaimReviewPage
        END
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_reviewDurationofStay}
        ...    timeout=5s
        IF    '${status}' == 'True'
            ${VP_reviewDurationofStay}    Get Element Attribute
            ...    ${${platformName}_${lang}_reviewDurationofStay}
            ...    attribute=name
            @{checkinandcheckoutdate}    Split String    ${VP_reviewDurationofStay}    -
            ${checkindate}    Get From List    ${checkinandcheckoutdate}    0
            @{checkindatelist}    Split String    ${checkindate}    /
            ${day}    Get From List    ${checkindatelist}    0
            ${month}    Get From List    ${checkindatelist}    1
            ${year}    Get From List    ${checkindatelist}    2
            ${strmonth}    Month Dic    ${month}
            ${strmonth}    Get Substring    ${strmonth}    0    3
            Log To Console    ${strmonth}
            ${convertcheckindate}    Catenate    ${day}    ${strmonth}
            ${convertcheckindate}    Catenate    ${convertcheckindate}    ${year}

            ${checkoutdate}    Get From List    ${checkinandcheckoutdate}    1
            @{checkoutdatelist}    Split String    ${checkoutdate}    /
            ${day}    Get From List    ${checkoutdatelist}    0
            ${month}    Get From List    ${checkoutdatelist}    1
            ${year}    Get From List    ${checkoutdatelist}    2
            ${strmonth}    Month Dic    ${month}
            ${strmonth}    Get Substring    ${strmonth}    0    3
            Log To Console    ${strmonth}
            ${convertcheckoutdate}    Catenate    ${day}    ${strmonth}
            ${convertcheckoutdate}    Catenate    ${convertcheckoutdate}    ${year}

            Set Calc VP Expected Result With Original And Source
            ...    ChekINDate
            ...    ${convertcheckindate.strip()}
            ...    ${convertcheckindate.strip()}
            ...    OMNE_ClaimReviewPage
            Set Calc VP Expected Result With Original And Source
            ...    ChekOutDate
            ...    ${convertcheckoutdate.strip()}
            ...    ${convertcheckoutdate.strip()}
            ...    OMNE_ClaimReviewPage
        END
        ${VP_reviewMedicalcentre}    Get Element Attribute
        ...    ${${platformName}_${lang}_reviewMedicalcentre}
        ...    attribute=name
        # ${VP_reviewtreatmentitems}    Get Element Attribute    ${${platformName}_${lang}_reviewTreatmentdate}    attribute=name
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_reviewamountandcurr}
        ...    timeout=10s
        IF    '${status}' == 'True'
            ${VP_amountandcurrency}    Get Element Attribute
            ...    ${${platformName}_${lang}_reviewamountandcurr}
            ...    attribute=name
            @{costandCurrelist}    Split String    ${VP_amountandcurrency}
            ${VP_reviewcurrency}    Get From List    ${costandCurrelist}    0
            ${VP_reviewcost}    Get From List    ${costandCurrelist}    1
            Set Calc VP Expected Result With Original And Source
            ...    TreatmentCost
            ...    ${VP_reviewcost}
            ...    ${VP_reviewcost}
            ...    OMNE_ClaimReviewPage
            Set Calc VP Expected Result With Original And Source
            ...    CostCurrency
            ...    ${VP_reviewcurrency}
            ...    ${VP_reviewcurrency}
            ...    OMNE_ClaimReviewPage
        END
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_reviewtotCostwamountandcurr}
        ...    timeout=5s
        IF    '${status}' == 'True'
            ${VP_amountandcurrency}    Get Element Attribute
            ...    ${${platformName}_${lang}_reviewtotCostwamountandcurr}
            ...    attribute=name
            @{costandCurrelist}    Split String    ${VP_amountandcurrency}
            ${VP_reviewcurrency}    Get From List    ${costandCurrelist}    0
            ${VP_reviewcost}    Get From List    ${costandCurrelist}    1
            Set Calc VP Expected Result With Original And Source
            ...    TreatmentCost
            ...    ${VP_reviewcost}
            ...    ${VP_reviewcost}
            ...    OMNE_ClaimReviewPage
            Set Calc VP Expected Result With Original And Source
            ...    CostCurrency
            ...    ${VP_reviewcurrency}
            ...    ${VP_reviewcurrency}
            ...    OMNE_ClaimReviewPage
        END
        Set Calc VP Expected Result With Original And Source
        ...    MedicalProvider
        ...    ${VP_reviewMedicalcentre}
        ...    ${VP_reviewMedicalcentre}
        ...    OMNE_ClaimReviewPage
        SwipePage
        Click Element    ${${platformName}_${lang}_declareChkBox}
        Sleep    1s
        Take Screenshot    Claim_Step3_Page
        Wait Until Element Is Visible      ${${platformName}_${lang}_submitButton}          timeout=100s
        Click Element    ${${platformName}_${lang}_submitButton}
        # New All Done Confirmation Page
        ${sOutput}    Run Keyword And Ignore Error    Check Transaction Status
        IF    ${sOutput} != ('PASS', None)
            Take Screenshot    Update Policy
            ${failure_reason}    Fetch Reason    ${sOutput}
            RETURN    ${failure_reason}
        END
    #    Wait Until Element Is Visible    ${${platformName}_${lang}_viewclaimtransactiontxt}    timeout=120s
        IF    '${Claim_Type}' != 'Outpatient surgery' and '${Claim_Type}' != 'Disability and dismemberment' and '${Claim_Type}' != 'Critical illness including cancer'
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_claimreviewPagetext}
            ...    timeout=20s
            IF     '${Successmsg}' != 'All Done!'
                Set Calc VP Expected Result With Original And Source    InstantPayment    No    No    ClaimReviewPage
            ELSE
                Set Calc VP Expected Result With Original And Source    InstantPayment    Yes    Yes    ClaimReviewPage
            END
        END
        Take Screenshot    Claim_ThanksPage
    #    Click Element    ${${platformName}_${lang}_viewclaimtransactiontxt}
        Sleep    5s

        Sleep    5s
    #    ${sOutput}    Run Keyword And Ignore Error    Completion Popup
    #    IF    ${sOutput} != ('PASS', None)
    #        Take Screenshot    Update Policy
    #        ${failure_reason}    Fetch Reason    ${sOutput}
    #        RETURN    ${failure_reason}
    #    END
        IF    '${Successmsg}' != 'All Done!'
            Claim Feedback
            Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=20s
            Click Element    ${${platformName}_${lang}_SeeAll}
            Take Screenshot    Transaction_Page
            IF    '${platformName}' == 'iOS'
                Wait Until Element Is Visible
                ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS '${Claim_Type}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
                ...    timeout=200s
                Sleep    3s
                Take Screenshot    Claim_TransactionPage
                ${transactionstatus}    Get Text
                ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS '${Claim_Type}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
                ${Mtransactionstatus}    Split String    ${transactionstatus}    ${Claim_Type}
                ${Mtransactionstatus}    Get From List    ${Mtransactionstatus}    1
                Log To Console    ${Mtransactionstatus}
                ${VPtransactionstatus}    Split String    ${Mtransactionstatus}    Policy no
                ${VPtransactionstatus}    Get From List    ${VPtransactionstatus}    0
                ${VPtransactionstatus}    Strip String    ${VPtransactionstatus}
                Log To Console    ${VPtransactionstatus}
                IF    '${VPtransactionstatus}' != 'In progress'
                    ${transactionstatus}    Split String    ${VPtransactionstatus}
                    ${transactionstatus}    Get From List    ${transactionstatus}    2
                    ${transactionstatus}    Remove String    )
                    ${transactionstatus}    Remove String    (
                ELSE
                    ${transactionstatus}    Convert To Title Case    ${VPtransactionstatus}
                END
            ELSE
                Wait Until Element Is Visible
                ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/following-sibling::android.widget.TextView[@text='${current_year}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='${Claim_Type}']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='In progress'])[1]
                ...    timeout=90s
                ${transactionstatus}    Get Text
                ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/following-sibling::android.widget.TextView[@text='${current_year}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='${Claim_Type}']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='In progress'])[1]
                IF    '${transactionstatus}' == 'In progress'
                    ${transactionstatus}    Set Variable    In Progress
                END
        #    Set Calc VP Expected Result With Original And Source    Transaction_Status    ${m_ClaimStatus.strip()}    ${m_ClaimStatus}    Omne_TransactionPage
            END
            Set Calc VP Expected Result With Original And Source
            ...    Transaction_Status
            ...    ${transactionstatus.strip()}
            ...    ${transactionstatus.strip()}
            ...    Omne_TransactionPage
            Set Global Variable    ${result}    Claim Submitted Successfully | Policy No :- ${Policy_No}
        END
        ${actualResult}=    Catenate    ${actualResult}     | FWD Insurance Flow of ${Insurance_Flow} Successful   : ${result}
        Set Global Variable    ${actualResult}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END

Claim Payment Method
    SwipePage
    SwipePage
    ${iOS_BankName}    Set Variable    chain=**/XCUIElementTypeOther[`label == '${Bank_Name}'`][-1]
    ${Android_BankName}    Set Variable    xpath=//android.widget.TextView[contains(@text,'${BankName}')]
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_Add_payment_method}
    ...    timeout=20s
    IF    '${status}' == 'True'
        Take Screenshot    Claim_PaymentMethod_Page
        Click Element    ${${platformName}_${lang}_Add_payment_method}
        IF    '${PaymentMethod}'=='Bank Transfer'
            Sleep    2s
#            Click Element    ${${platformName}_${lang}_select_Bank_Account}
            Pause Execution
            Sleep   1s
#            Wait Until Element Is Visible    ${${platformName}_${lang}_uploadBankBookclaim}     timeout=20s
#            Click Element    ${${platformName}_${lang}_uploadBankBookclaim}

            ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/Certificate.PNG
            Upload Document BS    ${path}
#    ${Status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_obj_doneButton}    timeout=20s
#    IF    '${Status}' == 'True'
#    Click Text    Done    exact_match=true
#    END
            Take Screenshot    Claim_PaymentMethod_Page
            ${Status}    Run Keyword And Return Status
            ...    Wait Until Page Contains Element
            ...    ${${platformName}_${lang}_UploadDocument_JustConfirm_Yes}
            ...    timeout=10s
            IF    '${status}' == 'True'
                Click Element    ${${platformName}_${lang}_UploadDocument_JustConfirm_Yes}
            END
            Wait Until Element Is Visible    ${${platformName}_${lang}_bankNameclaim}
            Click Element    ${${platformName}_${lang}_bankNameclaim}
            Click Element    ${${platformName}_BankName}
            Sleep    1s
            ${Status}    Run Keyword And Return Status    Wait Until Page Contains    Done    timeout=20s
            IF    '${Status}' == 'True'
                Click Text    Done    exact_match=true
            END
            Sleep    2s
            ${Bank_Book_Number}    Generate Random String    length=10    chars=[NUMBERS]
#    ${Bank_Book_Number}    Convert To Integer    ${ranint}
            Set Global Variable    ${Bank_Book_Number}
            Input Text    ${${platformName}_${lang}_bankAccNoclaim}    ${Bank_Book_Number}\n
            Close keyboard
            Take Screenshot    Claim_PaymentMethod_Page
            Click Element    ${${platformName}_${lang}_saveBtn}
        ELSE
            Wait Until Element Is Visible    ${${platformName}_${lang}_prompt_pay_Tab}    timeout=10s
            Click Element    ${${platformName}_${lang}_prompt_pay_Tab}
            Take Screenshot    PromptPay_Page
            Wait Until Element Is Visible    ${${platformName}_${lang}_prmoptPaychkBox}
            Click Element    ${${platformName}_${lang}_prmoptPaychkBox}
            Take Screenshot    PromptPay_Page
            Wait Until Element Is Visible    ${${platformName}_${lang}_saveBtn}
            Click Element    ${${platformName}_${lang}_saveBtn}
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_prompaPayHeadspopup}
            ...    timeout=10s
            IF    '${status}' == 'True'
                Take Screenshot    PromptPay_HeadsPopup
                Click Element    ${${platformName}_${lang}_prompaPayHeadspopup}
            END
        END
    ELSE
        Wait Until Element Is Visible    ${${platformName}_${lang}_Changepayment_method}    timeout=10s
        Click Element    ${${platformName}_${lang}_Changepayment_method}
        Take Screenshot    Change_PaymentMethod_Page
#        IF    '${PaymentMethod}'=='Prompt Pay'
#            Wait Until Element Is Visible    ${${platformName}_${lang}_prompt_pay_Tab}    timeout=10s
#            Click Element    ${${platformName}_${lang}_prompt_pay_Tab}
#            Take Screenshot    PromptPay_Page
#            Wait Until Element Is Visible    ${${platformName}_${lang}_prmoptPaychkBox}
#            Click Element    ${${platformName}_${lang}_prmoptPaychkBox}
#            Take Screenshot    PromptPay_Page
#            Wait Until Element Is Visible    ${${platformName}_${lang}_saveBtn}
#            Click Element    ${${platformName}_${lang}_saveBtn}
#            ${status}    Run Keyword And Return Status
#            ...    Wait Until Element Is Visible
#            ...    ${${platformName}_${lang}_prompaPayHeadspopup}
#            ...    timeout=10s
#            IF    '${status}' == 'True'
#                Take Screenshot    PromptPay_HeadsPopup
#                Click Element    ${${platformName}_${lang}_prompaPayHeadspopup}
#            END
#        ELSE
            Take Screenshot    Bank accountPage
            Click Element    ${${platformName}_${lang}_saveBtn}
    END

Select CheckIN and CheckOut Date
    @{checkinandcheckoutdatevalue}    Split String    ${CheckINAndCheckOutDate}    -
    ${checkinDate}    Get From List    ${checkinandcheckoutdatevalue}    0
    ${checkoutDate}    Get From List    ${checkinandcheckoutdatevalue}    1
    @{checkindatevalues}    Split String    ${checkinDate}
    ${checkinday}    Get From List    ${checkindatevalues}    0
    ${checkinmonth}    Get From List    ${checkindatevalues}    1
    ${checkinmonthsubstring}    Get Substring    ${checkinmonth}    0    3
    ${checkinyear}    Get From List    ${checkindatevalues}    2

    &{dict}    Get Element Rect    ${${platformName}_${lang}_currentmonthandyear}
    ${x}    Get From Dictionary    ${dict}    x
    ${y}    Get From Dictionary    ${dict}    y
    ${x}    Evaluate    ${x}+156    # 82
    ${x}    Convert To Integer    ${x}
    ${y}    Evaluate    ${y}+24    # 659
    ${y}    Convert To Integer    ${y}
    Click by Coordinates    ${x}    ${y}
    ${givenyearvalue}    Get Element Attribute    ${${platformName}_${lang}_currentYear}    attribute=value
    ${LoopValue}    Evaluate    int(${givenyearvalue})-int(${checkinyear})
    Log To Console    ${LoopValue}

    FOR    ${counter}    IN RANGE    0    ${LoopValue}
        Log    ${counter}
        IF    ${givenyearvalue} >= ${LoopValue}
            Click Element    ${${platformName}_${lang}_PreviousyearArrow}
        ELSE
            Click Element    ${${platformName}_${lang}_nextyearArrow}
        END
    END
    ${iOS_MonthString}    Set Variable    chain=**/XCUIElementTypeOther[`label == '${checkinmonthsubstring}'`]
    ${Android_MonthString}    Set Variable    xpath=//android.widget.TextView[@text='${checkinmonthsubstring}']
    ${iOS_CheckinDate}    Set Variable    chain=**/XCUIElementTypeButton[`label CONTAINS '${checkinDate}'`]
    ${Android_CheckinDate}    Set Variable    xpath=//android.widget.TextView[@text='${checkinday}']
    ${iOS_CheckoutDate}    Set Variable    chain=**/XCUIElementTypeButton[`label CONTAINS '${checkoutDate}'`]
    ${Android_CheckoutDate}    Set Variable    xpath=//android.widget.TextView[@text='${checkoutDate}']
    Click Element    ${${platformName}_MonthString}
    Sleep    2s
    Click Element    ${${platformName}_CheckinDate}
    # checkout date selection

    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_CheckoutDate}
    ...    timeout=5s
    IF    '${status}' == 'True'
        Click Element    ${${platformName}_CheckoutDate}
    ELSE
        &{dict}    Get Element Rect    ${${platformName}_${lang}_currentmonthandyear}
        ${x}    Get From Dictionary    ${dict}    x
        ${y}    Get From Dictionary    ${dict}    y
        ${x}    Evaluate    ${x}+156    # 82
        ${x}    Convert To Integer    ${x}
        ${y}    Evaluate    ${y}+22    # 659
        ${y}    Convert To Integer    ${y}
        Click by Coordinates    ${x}    ${y}
        @{checkoutdatevalues}    Split String    ${checkoutDate}
        ${checkoutday}    Get From List    ${checkoutdatevalues}    0
        ${checkoutmonth}    Get From List    ${checkoutdatevalues}    1
        ${checkoutmonthsubstring}    Get Substring    ${checkoutmonth}    0    3
        ${checkoutyear}    Get From List    ${checkoutdatevalues}    2
        ${givenyearvalue}    Get Element Attribute    ${${platformName}_${lang}_currentYear}    attribute=value
        ${LoopValue}    Evaluate    int(${givenyearvalue})-int(${checkoutyear})
        Log To Console    ${LoopValue}
        IF    ${LoopValue}<0
            WHILE    '${givenyearvalue}' != '${checkoutyear}'
                Click Element    ${${platformName}_${lang}_nextyearArrow}
                Sleep    1s
                ${givenyearvalue}    Get Element Attribute    ${${platformName}_${lang}_currentYear}    attribute=value
            END
        ELSE
            FOR    ${counter}    IN RANGE    0    ${LoopValue}
                Log    ${counter}
                IF    ${givenyearvalue} >= ${LoopValue}
                    Click Element    ${${platformName}_${lang}_PreviousyearArrow}
                ELSE
                    Click Element    ${${platformName}_${lang}_nextyearArrow}
                END
            END
        END
        Click Element    ${${platformName}_MonthString}
        Sleep    2s
        Click Element    ${${platformName}_CheckoutDate}
    END

Capture Error Message
    ${status}    Run Keyword And Return Status
    ...    Element Should Be Visible
    ...    ${${platformName}_${lang}_Policyeffectivedateerror}
    IF    '${status}' == 'True'
        ${msg}    Get Element Attribute    ${${platformName}_${lang}_Policyeffectivedateerror}    attribute=value
        Set Global Variable    ${errormsg}    ${msg}
        Set Calc VP With Source And Original Values
        ...    ErrorMsg
        ...    ${ValidationErrorMsg}
        ...    ${errormsg}
        ...    Static
        ...    Omne_ClaimPage
        ...    ${ValidationErrorMsg}
        ...    ${errormsg}
    END
    ${status}    Run Keyword And Return Status
    ...    Element Should Be Visible
    ...    ${${platformName}_${lang}_invaliddateerror}
    IF    '${status}' == 'True'
        ${msg}    Get Element Attribute    ${${platformName}_${lang}_invaliddateerror}    attribute=value
        Set Global Variable    ${errormsg}    ${msg}
        Set Calc VP With Source And Original Values
        ...    ErrorMsg
        ...    ${ValidationErrorMsg}
        ...    ${errormsg}
        ...    Static
        ...    Omne_ClaimPage
        ...    ${ValidationErrorMsg}
        ...    ${errormsg}
    END
    ${status}    Run Keyword And Return Status
    ...    Element Should Be Visible
    ...    ${${platformName}_${lang}_accidentDateErrMsg}
    IF    '${status}' == 'True'
        ${msg}    Get Element Attribute    ${${platformName}_${lang}_accidentDateErrMsg}    attribute=value
        Set Global Variable    ${errormsg}    ${msg}
        Set Calc VP With Source And Original Values
        ...    ErrorMsg
        ...    ${ValidationErrorMsg}
        ...    ${errormsg}
        ...    Static
        ...    Omne_ClaimPage
        ...    ${ValidationErrorMsg}
        ...    ${errormsg}
    END
    ${status}    Run Keyword And Return Status
    ...    Element Should Be Visible
    ...    ${${platformName}_${lang}_treatmentDateErrMsg}
    IF    '${status}' == 'True'
        ${msg}    Get Element Attribute    ${${platformName}_${lang}_treatmentDateErrMsg}    attribute=value
        Set Global Variable    ${errormsg}    ${msg}
        Set Calc VP With Source And Original Values
        ...    ErrorMsg
        ...    ${ValidationErrorMsg}
        ...    ${errormsg}
        ...    Static
        ...    Omne_ClaimPage
        ...    ${ValidationErrorMsg}
        ...    ${errormsg}
    END

DOB
    TRY
        ${current_time}    Get Current Date
        ${current_time}    Replace String    ${current_time}    :    _
        @{current_timeArr}    Split String    ${current_time}    .
        ${current_time}    Get From List    ${current_timeArr}    0
        Log    ${current_time}
        ${dob}    Set Variable    ${TreatmentDate}
        Set Global Variable    ${dob}
        Log    ${dob}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END
