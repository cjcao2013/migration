*** Settings ***
Library     SeleniumLibrary
Library     QraceHelper
Library     Collections
Library     DateTime
Resource    ../../PageObjects/OWB/OWBClaimsPageObjects.resource
Resource    ../../CustomLibraries/common.robot
Resource    ../../PageObjects/OWB/OWBInquiryPageObject.resource
Resource    OWBValidations.resource
Resource    OWBInquiryPage.resource


*** Keywords ***
OWB Submit
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${EN_dateOfVisit}    timeout=2s
    IF    '${status}'=='True'
        ${VP_dateOfVisit}    Get Element Attribute    ${EN_dateOfVisit}    attribute=title
        Set Calc VP Actual Result With Original And Source
        ...    DateOfVisit
        ...    ${VP_dateOfVisit}
        ...    ${VP_dateOfVisit}
        ...    OWB_ClaimPage
    END
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${EN_dateOfAccident}    timeout=2s
    IF    '${status}'=='True'
        ${VP_dateOfAccident}    Get Element Attribute    ${EN_dateOfAccident}    attribute=title
        Set Calc VP Actual Result With Original And Source
        ...    DateOfAccident
        ...    ${VP_dateOfAccident}
        ...    ${VP_dateOfAccident}
        ...    OWB_ClaimPage
    END
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${EN_medicalProvider}    timeout=2s
    IF    '${status}'=='True'
        ${VP_medicalProvider}    Get Element Attribute    ${EN_medicalProvider}    attribute=title
        @{VP_medicalProviderlist}    Split String    ${VP_medicalProvider}    -
        ${VP_medicalProvidervalue}    Get From List    ${VP_medicalProviderlist}    1
        Set Calc VP Actual Result With Original And Source
        ...    MedicalProvider
        ...    ${VP_medicalProvidervalue.strip()}
        ...    ${VP_medicalProvidervalue.strip()}
        ...    OWB_ClaimPage
    END

    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${EN_diagnosis}    timeout=2s
    IF    '${status}'=='True'
        ${VP_diagnosis}    Get Text    ${EN_diagnosis}
        @{VP_diagnosislist}    Split String    ${VP_diagnosis}    -
        ${diagnosislistcount}    Get Length    ${VP_diagnosislist}
        ${finalVP_diagnosisvalue}    Set Variable
        FOR    ${counter}    IN RANGE    1    ${diagnosislistcount}
            ${VP_diagnosisvalue}    Get From List    ${VP_diagnosislist}    ${counter}
            ${finalVP_diagnosisvalue}    Catenate    ${finalVP_diagnosisvalue} ${VP_diagnosisvalue}
        END

        Set Calc VP Actual Result With Original And Source
        ...    Diagnosis
        ...    ${finalVP_diagnosisvalue.strip()}
        ...    ${finalVP_diagnosisvalue.strip()}
        ...    OWB_ClaimPage
    END

    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${EN_treatmentcostcurrency}
    ...    timeout=2s
    IF    '${status}'=='True'
        ${VP_treatmentcostcurrency}    Get Element Attribute    ${EN_treatmentcostcurrency}    attribute=title
        Set Calc VP Actual Result With Original And Source
        ...    CostCurrency
        ...    ${VP_treatmentcostcurrency}
        ...    ${VP_treatmentcostcurrency}
        ...    OWB_ClaimPage
    END

    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${EN_treatmentcost}    timeout=2s
    IF    '${status}'=='True'
        ${VP_treatmentcost}    Get Element Attribute    ${EN_treatmentcost}    attribute=title
        Set Calc VP Actual Result With Original And Source
        ...    TreatmentCost
        ...    ${VP_treatmentcost}
        ...    ${VP_treatmentcost}
        ...    OWB_ClaimPage
    END

    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${EN_treatmentcost}    timeout=2s
    IF    '${status}'=='True'
        ${VP_treatmentcost}    Get Element Attribute    ${EN_treatmentcost}    attribute=title
        Set Calc VP Actual Result With Original And Source
        ...    TreatmentCost
        ...    ${VP_treatmentcost}
        ...    ${VP_treatmentcost}
        ...    OWB_ClaimPage
    END
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${EN_dateOfAddmission}    timeout=2s
    IF    '${status}'=='True'
        ${VP_dateOfAddmission}    Get Element Attribute    ${EN_dateOfAddmission}    attribute=title
        ${VP_dateOfDischargen}    Get Element Attribute    ${EN_dateOfDischarge}    attribute=title
        Set Calc VP Actual Result With Original And Source
        ...    ChekINDate
        ...    ${VP_dateOfAddmission.strip()}
        ...    ${VP_dateOfAddmission.strip()}
        ...    OWB_ClaimPage
        Set Calc VP Actual Result With Original And Source
        ...    ChekOutDate
        ...    ${VP_dateOfDischargen.strip()}
        ...    ${VP_dateOfDischargen.strip()}
        ...    OWB_ClaimPage
    END

    ${VP_paymentmethod}    Get Element Attribute    ${EN_paymentmethod}    attribute=title
    ${VP_instantpayment}    Get Element Attribute    ${EN_instantpayment}    attribute=title
    ${VP_acknowledgment}    Get Element Attribute    ${EN_acknowledgment}    attribute=title
    ${VP_claimWithOtherInsurer}    Get Element Attribute    ${EN_claimWithOtherInsurer}    attribute=title
    ${VP_completiondate}    Get Element Attribute    ${EN_OWB_completiondate}    attribute=title
    IF    '${Claim_Type}' != 'Outpatient surgery'
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${EN_treatmentlist}
        ...    timeout=2s
        IF    '${status}'=='True'
            @{totaltreatmentlist}    Get Webelements    ${EN_treatmentlist}
            ${listlenght}    Get Length    ${totaltreatmentlist}
            # Set Calc VP Actual Result With Original And Source    Total_TreatmentCount    ${listlenght}    ${listlenght}    OWB_ClaimPage
            FOR    ${counter}    IN RANGE    0    ${listlenght}
                ${webelement}    Get From List    ${totaltreatmentlist}    ${counter}
                ${treatment}    Get Text    ${webelement}
                Set Calc VP Actual Result With Original And Source
                ...    Treatment_${counter}
                ...    ${treatment}
                ...    ${treatment}
                ...    OWB_ClaimPage
            END
        END
    END
    # stpfailure reason
#    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${EN_stpfailurereason}    timeout=10s
#    #add column in data container
#    ${STPReasonPresent}    Set Variable    false
#    Set Calc VP With Source And Original Values    STP FailureReason Present    ${STPReasonPresent}    ${status}    static    OWB_ClaimPage    ${STPReasonPresent}    ${status}

    # SETVP

    Set Calc VP Actual Result With Original And Source
    ...    PaymentMethod
    ...    ${VP_paymentmethod}
    ...    ${VP_paymentmethod}
    ...    OWB_ClaimPage
    IF    '${Claim_Type}' != 'Outpatient surgery' and '${Claim_Type}' != 'Disability and dismemberment' and '${Claim_Type}' != 'Critical illness including cancer'
        Set Calc VP Actual Result With Original And Source
        ...    InstantPayment
        ...    ${VP_instantpayment}
        ...    ${VP_instantpayment}
        ...    OWB_ClaimPage
    END

    Set Calc VP With Source And Original Values
    ...    AcknowledgeT&Cs
    ...    Yes
    ...    ${VP_acknowledgment}
    ...    Static
    ...    OWB_ClaimPage
    ...    Yes
    ...    ${VP_acknowledgment}
    Set Calc VP With Source And Original Values
    ...    Claim With Other Insurer
    ...    Yes
    ...    ${VP_claimWithOtherInsurer}
    ...    Static
    ...    OWB_ClaimPage
    ...    Yes
    ...    ${VP_claimWithOtherInsurer}
    ${date}    Get Current Date
    Log To Console    ${date}
    ${date}    Convert Date    ${date}    result_format=%d %b %Y
    Set Calc VP With Source And Original Values
    ...    Completion Date
    ...    ${date}
    ...    ${VP_completiondate}
    ...    Static
    ...    OWB_ClaimPage
    ...    ${date}
    ...    ${VP_completiondate}
    ${Approved_Status}    Get Text    ${EN_claimApprovalStatus}
    Set Global Variable    ${Approved_Status}

    # check total documents
    Click Element    ${EN_viewAllImages}
    # handle switch window
    Switch Window    new
    Wait Until Element Is Visible    ${EN_totDocumentCount}    timeout=200s
    Take OWB Screenshot    ClaimDocumentPage
    @{totalDoclist}    Get WebElements    ${EN_totDocumentCount}
    ${DocCountlength}    Get Length    ${totalDoclist}
#    Set Calc VP Actual Result With Original And Source
#    ...    TotalDocument
#    ...    ${DocCountlength}
#    ...    ${DocCountlength}
#    ...    DocumentPage
    FOR    ${counter}    IN RANGE    0    ${DocCountlength}
        ${webelement}    Get From List    ${totalDoclist}    ${counter}
        Click Element    ${webelement}
        Take OWB Screenshot    ClaimDocument
    END
    Switch Window    main
