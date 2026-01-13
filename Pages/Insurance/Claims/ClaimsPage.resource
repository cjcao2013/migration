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
Resource    HospitalisationClaimPage.resource
Resource    Critical_Illness_Including_cancer_ClaimPage.resource
Resource    OutpatientReimbursementClaimPage.resource
Resource    OutpatientSurgeryClaimPage.resource
Resource    DisabilityAndDismembermentClaimPage.resource


*** Keywords ***
Submit
    TRY
        DOB
        ${Android_EN_InsurancePage}    Set Variable    android=new UiSelector().text("Insurance")
        ${iOS_EN_InsurancePage}    Set Variable    chain=**/XCUIElementTypeButton[`label == 'Insurance'`]
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_InsurnacePage}
          IF    '${status}' == 'True'
                Take Screenshot     FWD_Insurance_Page
                Click Element       ${${platformName}_${lang}_InsurnacePage}
          END
        ${Android_EN_InsurancePage}    Set Variable    android=new UiSelector().text("${Flow_Flag}")
        ${iOS_EN_InsurancePage}    Set Variable    chain=**/XCUIElementTypeButton[`label == '${Flow_Flag}'`]

        Wait Until Element Is Visible    ${${platformName}_${lang}_InsurancePage}    timeout=30s
        Take Screenshot    FWD_Insurance_Page
#        IF    '${testtype}'!='NEGATIVE' and '${Transaction_Page_GUI}' == 'Yes'
#            Verify FWDInsurance Page GUI
#        END
        Click Element    ${${platformName}_${lang}_InsurancePage}

        #enter pin
        Set or enter PIN

        #biometric check
        Biometric Check
        Take Screenshot    Claim_Page

        #select submit claim on insurance page
        ${Android_EN_Insurance_Module}    Set Variable    android=new UiSelector().textContains("Submit")
        ${iOS_EN_Insurance_Module}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS 'Submit'`][-1]
        Wait Until Element Is Visible    ${${platformName}_${lang}_Insurance_Module}
        Click Element    ${${platformName}_${lang}_Insurance_Module}
        Take Screenshot    Claim_Page

        IF    '${testtype}'!='NEGATIVE' and '${Transaction_Page_GUI}' == 'Yes'
            Verify Claim Step1 Page GUI
        END

        #medical receipt
        Medical Receipt Negative Scenario

        #upload correct medical receipt
        ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/${Claim_ReceiptDocumentName}.png
        Upload Document BS    ${path}

        #medical certificate
        Medical Certificate Negative Senario

        #upload correct medical certificate
        ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/${Claim_CertificateDocumentName}.png
        Upload Document BS    ${path}
        Take Screenshot    Claim_Page

        # claim page
        Wait Until Element Is Visible    ${${platformName}_${lang}_claimantOption}    timeout=200s
        IF    '${testtype}'!='NEGATIVE' and '${Transaction_Page_GUI}' == 'Yes'
            Verify Claim Step2 Page GUI
        END

        #select claimant
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visibl  ${${platformName}_${lang}_claimantfield}    timeout=5s
        Click Element    ${${platformName}_${lang}_claimantOption}
        @{claimantlist}    Get Webelements    ${${platformName}_${lang}_claimantlist}
        ${totclaimantCount}    Get Length    ${claimantlist}
        ${iOS_Claimant}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Claimant}'`][-1]
        ${Android_Claimant}    Set Variable    xpath=//android.widget.TextView[contains(@text,'${Claimant}')]
        ${status}    Run Keyword And Return Status  Wait Until Element Is Visible   ${${platformName}_${lang}_claimementsingle}     timeout=3s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_claimementsingle}
        ELSE
            Click Element    ${${platformName}_Claimant}

        END

        #select claim type
        Wait Until Element Is Visible    ${${platformName}_${lang}_ClaimTypeOption}    timeout=20s
        Click Element    ${${platformName}_${lang}_ClaimTypeOption}
        ${iOS_ClaimType}    Set Variable    chain=**/XCUIElementTypeOther[`label BEGINSWITH "${Claim_Type}"`][-2]
        ${Android_ClaimType}    Set Variable    xpath=//android.widget.TextView[@text='${Claim_Type}']
        Click Element    ${${platformName}_ClaimType}

        #pop for hospitalisation
        IF    '${Claim_Type}' == 'Hospitalisation'
            PromptPayHeadsPopup
        END

        #select policy
        Wait Until Element Is Visible  ${${platformName}_${lang}_PolicyOption}      timeout=5s
        Click Element    ${${platformName}_${lang}_PolicyOption}
        ${iOS_SelectPolicy}    Set Variable
        ...    xpath=(//XCUIElementTypeOther[@name='Select policy']//following::XCUIElementTypeOther[contains(@label,'${Policy_No}')])[last()]
        ${Android_SelectPolicy}    Set Variable
        ...    xpath=//android.widget.TextView[@text='Select policy']/following::android.widget.TextView[@text='${Policy_No}']
        Wait Until Element Is Visible    ${${platformName}_SelectPolicy}    timeout=10s
        Click Element    ${${platformName}_SelectPolicy}

        #call specefic claim keyword
        Run keyword     Claim ${Claim_Type}
        #check duplicate claim
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_capturerrorpopup}
        ...    timeout=5s
        IF    '${status}' == 'True'
            Set Global Variable    ${errormsg}    Duplicate Claim Error
            Take Screenshot    Claim_duplicate_error
        END
        SwipePage
        #capture document count
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
#       Set Calc VP Expected Result With Original And Source    TotalDocument    ${totCount}    ${totCount}    Claim
        Wait Until Element Is Visible    ${${platformName}_${lang}_nextBtn}    timeout=10s
        Take Screenshot    Claim_Step2_Page
        SwipePage
        Take Screenshot    Claim_Step2_Page
        Click Element    ${${platformName}_${lang}_nextBtn}
        Take Screenshot    Claim_Step3_Page
        Claim Payment Method
        #capture details
        Capture Review Page Details
        SwipePage
        Wait Until Element Is Visible      ${${platformName}_${lang}_declareChkBox}          timeout=10s
        Click Element    ${${platformName}_${lang}_declareChkBox}
        Wait Until Element Is Visible      ${${platformName}_${lang}_submitButton}          timeout=100s
        Take Screenshot    Claim_Step3_Page
        Click Element    ${${platformName}_${lang}_submitButton}
        # New All Done Confirmation Page
        Run Keyword    Check Transaction Status
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
        #transaction page
        IF    '${Successmsg}' != 'All Done!'
#            Claim Feedback
            Pause Execution
            Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=20s
            Click Element    ${${platformName}_${lang}_SeeAll}
            Take Screenshot    Transaction_Page
            IF    '${platformName}' == 'iOS'
                Wait Until Element Is Visible
                ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS '${Claim_Type}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
                ...    timeout=200s
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



Capture Review Page Details
    Set Calc VP Expected Result With Original And Source
    ...    PaymentMethod
    ...    ${PaymentMethod}
    ...    ${PaymentMethod}
    ...    Omne_ClaimReviewPage
    # capture VP
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_reviewTreatmentdate}
    ...    timeout=2s
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
    ...    timeout=2s
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
    ...    ${${platformName}_${lang}_Recipt_Number}
    ...    timeout=2s
    IF    '${status}' == 'True'
        ${VP_Recipt_Number}     Get Element Attribute    ${${platformName}_${lang}_Recipt_Number}   attribute=name
        Set Calc VP Expected Result With Original And Source
        ...    DateOfAccident
        ...    ${VP_Recipt_Number}
        ...    ${VP_Recipt_Number}
        ...    OMNE_ClaimReviewPage
    END

    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_reviewDiagnosis}
    ...    timeout=2s
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
    ...    timeout=2s
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
    ...    timeout=2s
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
    ...    timeout=2s
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

Claim Payment Method
    SwipePage
    SwipePage
    ${iOS_BankName}    Set Variable    chain=**/XCUIElementTypeOther[`label == '${Bank_Name}'`][-1]
    ${Android_BankName}    Set Variable    xpath=//android.widget.TextView[contains(@text,'${BankName}')]
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_Add_payment_method}
    ...    timeout=5s
    IF    '${status}' == 'True'
        Take Screenshot    Claim_PaymentMethod_Page
        Click Element    ${${platformName}_${lang}_Add_payment_method}
        IF    '${PaymentMethod}'=='Bank Transfer'
            Click Element    ${${platformName}_${lang}_select_Bank_Account}

            Wait Until Element Is Visible    ${${platformName}_${lang}_uploadBankBookclaim}     timeout=20s
            Click Element    ${${platformName}_${lang}_uploadBankBookclaim}

            ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/Certificate.PNG
            Upload Document BS    ${path}
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
            ${Status}    Run Keyword And Return Status    Wait Until Page Contains    Done    timeout=4s
            IF    '${Status}' == 'True'
                Click Text    Done    exact_match=true
            END
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
        Take Screenshot    Bank accountPage
        Click Element    ${${platformName}_${lang}_saveBtn}
    END


Add Diagnosis
    Wait Until Element Is Visible       ${${platformName}_${lang}_DiagnosisOption}      timeout=10s
    Click Element    ${${platformName}_${lang}_DiagnosisOption}
    ${iOS_SelectDiagnosis}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS "${Diagnosis}"`][-1]
    ${Android_SelectDiagnosis}    Set Variable    xpath=//android.widget.TextView[contains(@text,'${Diagnosis}')]
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_SelectDiagnosis}
    ...    timeout=3s
    IF    '${status}'=='True'
        Click Element    ${${platformName}_SelectDiagnosis}
    ELSE
        Input Text    ${${platformName}_${lang}_diagnosisSearch}    ${Diagnosis}
        Hide Keyboard    return
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_addNewDiagnosis}
        ...    timeout=3s
        IF    '${status}'=='True'
            Take Screenshot    AddDiagnosis
            Click Element    ${${platformName}_${lang}_addNewDiagnosis}
        ELSE
            Click Element    ${${platformName}_SelectDiagnosis}
        END
    END
    Wait Until Element Is Visible    ${${platformName}_${lang}_diagnosisDoneBtn}    timeout=10s
    Click Element    ${${platformName}_${lang}_diagnosisDoneBtn}

PromptPayHeadsPopup
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_prompaPayHeadspopup}
    ...    timeout=4s
    IF    '${status}'=='True'
        Take Screenshot    DaySurgeryPopUp
        Click Element    ${${platformName}_${lang}_prompaPayHeadspopup}
    END

Add Medical Center
    IF    '${MedicalCentre}' != '${EMPTY}'
        ${iOS_SelectMedicalCentre}    Set Variable    chain=**/XCUIElementTypeOther[`label == '${MedicalCentre}'`][-1]
        ${Android_SelectMedicalCentre}    Set Variable
        ...    xpath=//android.widget.TextView[contains(@text,'${MedicalCentre}')]
        Click Element    ${${platformName}_${lang}_medicalCenterselectOption}
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_SelectMedicalCentre}
        ...    timeout=4s
        IF    '${status}'=='True'
            Click Element    ${${platformName}_SelectMedicalCentre}
        ELSE
            Input Text    ${${platformName}_${lang}_diagnosisSearch}    ${MedicalCentre}
            Hide Keyboard    return
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_addNewMedicalcenter}
            ...    timeout=3s
            IF    '${status}'=='True'
                Take Screenshot    Add Medical Center
                Click Element    ${${platformName}_${lang}_addNewMedicalcenter}
            ELSE
                Click Element    ${${platformName}_SelectMedicalCentre}
            END
        END
        Wait Until Element Is Visible    ${${platformName}_${lang}_surgercymedicalcentreDoneBtn}    timeout=10s
        Click Element    ${${platformName}_${lang}_surgercymedicalcentreDoneBtn}
    END


Select claim is About
    ${iOS_ClaimIsAbout}    Set Variable    chain=**/XCUIElementTypeOther[`label == '${ClaimIsAbout}'`]
    ${Android_ClaimIsAbout}    Set Variable    xpath=//android.widget.TextView[@text='${ClaimIsAbout}']
    Wait Until Element Is Visible    ${${platformName}_ClaimIsAbout}    timeout=10s
    Click Element    ${${platformName}_ClaimIsAbout}



Medical Certificate Negative Senario
    IF    '${Claim_Type}'=='Outpatient reimbursement' and '${testtype}'=='NEGATIVE' and '${ValidationErrorMsg}' != 'Treatment date is before policy effective date' and '${ValidationErrorMsg}' != 'Treatment date must be after the accident date' and '${ValidationErrorMsg}' != 'Invalid date value' and '${ValidationErrorMsg}' != 'Accident date is before policy effective date'
            ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/blur.PNG
            Upload Document BS    ${path}
            Take Screenshot    Invalid_MedicalCertificate_Page
            Wait Until Element Is Visible    ${${platformName}_${lang}_errorOKpopup}    timeout=10s
            Take Screenshot    Invalid_MedicalCertificate_Page
            ${receiptErrmsgokpopup}    Get Element Attribute
            ...    ${${platformName}_${lang}_captureerrormsgOKpopup}
            ...    attribute=name
            @{receiptErrmsgokpopuplist}    Split String    ${receiptErrmsgokpopup}    OK
            ${receiptErrmsgokpopup}    Get From List    ${receiptErrmsgokpopuplist}    0
            @{errorlist}    Split To Lines    ${receiptErrmsgokpopup}
            ${error1}    Get From List    ${errorlist}    0
            ${error2}    Get From List    ${errorlist}    2
            ${receiptpopupmsg}    Catenate    ${error1}    ${error2}
            Set Calc VP With Source And Original Values
            ...    MedicalCertificateDocument_ErrorMsg
            ...    ${ValidationDocumentErrorMsg}
            ...    ${receiptpopupmsg.strip()}
            ...    Static
            ...    Omne_ClaimmedicalcertificatePage
            ...    ${ValidationDocumentErrorMsg}
            ...    ${receiptpopupmsg.strip()}
            Click Element    ${${platformName}_${lang}_errorOKpopup}
            Wait Until Element Is Visible    ${${platformName}_${lang}_minusImg}    timeout=5s
            Take Screenshot    Invalid_MedicalCertificate_Page
            Click Element    ${${platformName}_${lang}_minusImg}
            ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/images.PNG
            Upload Document BS    ${path}
            Wait Until Element Is Visible    ${${platformName}_${lang}_confirmPopup}    timeout=20s
            ${receiptErrmsgconfirmpopup}    Get Element Attribute
            ...    ${${platformName}_${lang}_captueconfirmerrmsg}
            ...    attribute=name
            @{receiptErrmsgconfirmpopuplist}    Split String    ${receiptErrmsgconfirmpopup}    Horizontal
            ${receiptErrmsgconfirmpopup}    Get From List    ${receiptErrmsgconfirmpopuplist}    0
            Set Global Variable    ${errormsg}    ${receiptErrmsgconfirmpopup}
            Set Calc VP With Source And Original Values
            ...    MedicalCertificateDocumentConfirm_ErrorMsg
            ...    ${ValidationConfirmCertificateErrorMsg}
            ...    ${receiptErrmsgconfirmpopup.strip()}
            ...    Static
            ...    Omne_ClaimmedicalReceiptPage
            ...    ${ValidationConfirmCertificateErrorMsg}
            ...    ${receiptErrmsgconfirmpopup.strip()}
            Take Screenshot    Invalid_MedicalCertificate_Page
            Click Element    ${${platformName}_${lang}_confirmPopup}
        END

Medical Receipt Negative Scenario
    IF    '${Claim_Type}'=='Outpatient reimbursement' and '${testtype}'=='NEGATIVE' and '${ValidationErrorMsg}' != 'Treatment date is before policy effective date' and '${ValidationErrorMsg}' != 'Treatment date must be after the accident date' and '${ValidationErrorMsg}' != 'Invalid date value' and '${ValidationErrorMsg}' != 'Accident date is before policy effective date'
            ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/blur.PNG
            Upload Document BS    ${path}
            Take Screenshot    Invalid_MedicalReceipt_Page
            Wait Until Element Is Visible    ${${platformName}_${lang}_errorOKpopup}    timeout=20s
            Take Screenshot    Invalid_MedicalReceipt_Page
            ${receiptErrmsgokpopup}    Get Element Attribute    ${${platformName}_${lang}_errorOKpopup}    attribute=name
            @{receiptErrmsgokpopuplist}    Split String    ${receiptErrmsgokpopup}    OK
            ${receiptErrmsgokpopup}    Get From List    ${receiptErrmsgokpopuplist}    0
            @{errorlist}    Split To Lines    ${receiptErrmsgokpopup}
            ${error1}    Get From List    ${errorlist}    0
            ${error2}    Get From List    ${errorlist}    2
            ${receiptpopupmsg}    Catenate    ${error1}    ${error2}
            Set Global Variable    ${errormsg}    ${receiptErrmsgokpopup}
            Set Calc VP With Source And Original Values
            ...    MedicalReceiptDocument_ErrorMsg
            ...    ${ValidationDocumentErrorMsg}
            ...    ${receiptpopupmsg.strip()}
            ...    Static
            ...    Omne_ClaimmedicalReceiptPage
            ...    ${ValidationDocumentErrorMsg}
            ...    ${receiptpopupmsg.strip()}
            Click Element    ${${platformName}_${lang}_errorOKpopup}
            Wait Until Element Is Visible    ${${platformName}_${lang}_minusImg}    timeout=5s
            Take Screenshot    Invalid_MedicalReceipt_Page
            Click Element    ${${platformName}_${lang}_minusImg}
            ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/images.PNG
            Upload Document BS    ${path}
            Take Screenshot    Invalid_MedicalReceipt_Page
            Wait Until Element Is Visible    ${${platformName}_${lang}_confirmPopup}    timeout=10s
            Take Screenshot    Invalid_MedicalReceipt_Page
            ${receiptErrmsgconfirmpopup}    Get Element Attribute
            ...    ${${platformName}_${lang}_captueconfirmerrmsg}
            ...    attribute=name
            @{receiptErrmsgconfirmpopuplist}    Split String    ${receiptErrmsgconfirmpopup}    Horizontal
            ${receiptErrmsgconfirmpopup}    Get From List    ${receiptErrmsgconfirmpopuplist}    0
            Set Calc VP With Source And Original Values
            ...    MedicalReceiptDocumentConfirm_ErrorMsg
            ...    ${ValidationConfirmErrorMsg}
            ...    ${receiptErrmsgconfirmpopup.strip()}
            ...    Static
            ...    Omne_ClaimmedicalReceiptPage
            ...    ${ValidationConfirmErrorMsg}
            ...    ${receiptErrmsgconfirmpopup.strip()}
            Click Element    ${${platformName}_${lang}_confirmPopup}
            Take Screenshot    Invalid_MedicalReceipt_Page
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
