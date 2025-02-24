*** Settings ***
Library     AppiumLibrary
Library     QraceHelper
Resource    ../../../PageObjects/Insurance/Common/GUIPageObjects.resource


*** Keywords ***
Verify FWDInsurance Page GUI
    # Code for GUI VP in for Insurnace Task Cards
    IF    '${FWD_Insurance_Page_Task_GUI}' == 'Yes'
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_viewpolicy}
        ...    timeout=20s
        Set Calc VP With Source And Original Values
        ...    ViewANDInvestmentPolicy_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_FwdInsurancePage
        ...    true
        ...    ${status}
        # make a claim
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_viewclaim}
        ...    timeout=5s
        Set Calc VP With Source And Original Values
        ...    MakeClaim_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_FwdInsurancePage
        ...    true
        ...    ${status}
        # service request
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_servicerequest}
        ...    timeout=5s
        Set Calc VP With Source And Original Values
        ...    UpdatePolicies_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_FwdInsurancePage
        ...    true
        ...    ${status}
        # make payment
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_payment}
        ...    timeout=5s
        Set Calc VP With Source And Original Values
        ...    MakePayment_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_FwdInsurancePage
        ...    true
        ...    ${status}

        # transaction
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_viewtransactiontab}
        ...    timeout=5s
        Set Calc VP With Source And Original Values
        ...    ViewTransaction_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_FwdInsurancePage
        ...    true
        ...    ${status}
    END

Update Policy VP
    IF    '${Sub_Task_Page_GUI}' == 'Yes'
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_PaymentFrequecy}
        ...    timeout=25s
        Set Calc VP With Source And Original Values
        ...    PaymentFrequecy_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_PaymentRelaedServicesPage
        ...    true
        ...    ${status}
        # make transaction
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_PremiumPaymentMethod}
        ...    timeout=25s
        Set Calc VP With Source And Original Values
        ...    PremiumPaymentMethod_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_PaymentRelaedServicesPage
        ...    true
        ...    ${status}

        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_CashPayoutOption}
        ...    timeout=25s
        Set Calc VP With Source And Original Values
        ...    CashPayoutOption_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_PaymentRelaedServicesPage
        ...    true
        ...    ${status}
        # make transaction
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_PartailWithDrwal}
        ...    timeout=25s
        Set Calc VP With Source And Original Values
        ...    PartailWithDrwal_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_PaymentRelaedServicesPage
        ...    true
        ...    ${status}

        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_SwitchFund}
        ...    timeout=25s
        Set Calc VP With Source And Original Values
        ...    SwitchFund_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_PaymentRelaedServicesPage
        ...    true
        ...    ${status}

        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_PersonalDetails}
        ...    timeout=25s
        Set Calc VP With Source And Original Values
        ...    PersonalDetails_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_PolicyServicesPage
        ...    true
        ...    ${status}

        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_BeneficiaryDetails}
        ...    timeout=25s
        Set Calc VP With Source And Original Values
        ...    BeneficiaryDetails_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_PolicyServicesPage
        ...    true
        ...    ${status}

        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_RiderDetails}
        ...    timeout=25s
        Set Calc VP With Source And Original Values
        ...    RiderDetails_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_PolicyServicesPage
        ...    true
        ...    ${status}

        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_YourPolicyDetails}
        ...    timeout=25s
        Set Calc VP With Source And Original Values
        ...    YourPolicyDetails_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_PolicyServicesPage
        ...    true
        ...    ${status}

        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_TaxConsentDetails}
        ...    timeout=25s
        Set Calc VP With Source And Original Values
        ...    TaxConsentDetails_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_PolicyServicesPage
        ...    true
        ...    ${status}

        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_PolicyLoanDetails}
        ...    timeout=25s
        Set Calc VP With Source And Original Values
        ...    PolicyLoanDetails_TabVisible
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne_PolicyServicesPage
        ...    true
        ...    ${status}
    END

Verify Claim Step1 Page GUI
    # backbtn
    Sleep    5s
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_backBtn}
    ...    timeout=25s
    # Set Calc VP With Source And Original Values    Step1Page_BackButtonVisible    true    ${status}    Static    Omne_Claim_Step1Page    true    ${status}
    # Guide btn
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_Guidebtn}
    ...    timeout=5s
#    Set Calc VP With Source And Original Values    Step1Page_GuideButtonVisible    true    ${status}    Static    Omne_Claim_Step1Page    true    ${status}
    # header
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_capturetext}
    ...    timeout=5s
    IF    '${status}' == 'True'
        ${headertext}    Get Element Attribute    ${${platformName}_${lang}_capturetext}    attribute=label
        Set Calc VP With Source And Original Values
        ...    Step1Page_ClaimPage_HeaderText
        ...    Capture all your receipts
        ...    ${headertext}
        ...    Static
        ...    Omne_Claim_Step1Page
        ...    Capture all your receipts
        ...    ${headertext}
    END

    # navigation panel
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_navigationPanel}
    ...    timeout=5s
    # galleryBtn
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_galleryBtn}
    ...    timeout=5s
#    Set Calc VP With Source And Original Values    Step1Page_GalleryButtonVisible    true    ${status}    Static    Omne_Claim_Step1Page    true    ${status}
    # captureBtn
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_captureimgBtn}
    ...    timeout=5s
#    Set Calc VP With Source And Original Values    Step1Page_CameraCaptureButtonVisible    true    ${status}    Static    Omne_Claim_Step1Page    true    ${status}
    # checknextBtn
    ${status}    Run Keyword And Return Status
    ...    Element Should Be Enabled
    ...    ${${platformName}_${lang}_nextBtnEnabled}
    ...    timeout=5s
    Set Calc VP With Source And Original Values
    ...    Step1Page_NextButtonEnabled
    ...    false
    ...    ${status}
    ...    Static
    ...    Omne_Claim_Step1Page
    ...    false
    ...    ${status}

Verify Claim Step2 Page GUI
    Sleep    4s
    ${VP_headertext}    Get Element Attribute    ${${platformName}_${lang}_headertext}    attribute=name
    Set Calc VP With Source And Original Values
    ...    Step2Page_HeaderText
    ...    Submit a claim Overview
    ...    ${VP_headertext}
    ...    Static
    ...    Omne_Claim_Step2Page
    ...    Submit a claim Overview
    ...    ${VP_headertext}
    # navigation panel
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_navigationPanel}
    ...    timeout=5s
    Set Calc VP With Source And Original Values
    ...    Step2Page_NavigationPanelVisible
    ...    true
    ...    ${status}
    ...    Static
    ...    Omne_Claim_Step2Page
    ...    true
    ...    ${status}
    # header text
    ${VP_headerverifytext}    Get Element Attribute    ${${platformName}_${lang}_verifytext}    attribute=label
    Set Calc VP With Source And Original Values
    ...    Step2Page_HeaderText1
    ...    Verify your details
    ...    ${VP_headerverifytext}
    ...    Static
    ...    Omne_Claim_Step2Page
    ...    Verify your details
    ...    ${VP_headerverifytext}
    # claimant field
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_claimant}
    ...    timeout=5s
    Set Calc VP With Source And Original Values
    ...    Step2Page_ClaimantField_Visible
    ...    true
    ...    ${status}
    ...    Static
    ...    Omne_Claim_Step2Page
    ...    true
    ...    ${status}
    # claim type field
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_claimtype}
    ...    timeout=5s
    Set Calc VP With Source And Original Values
    ...    Step2Page_ClaimTypeField_Visible
    ...    true
    ...    ${status}
    ...    Static
    ...    Omne_Claim_Step2Page
    ...    true
    ...    ${status}
    # checkpolicy fieldBtn
#    ${status}    Run Keyword And Return Status    Element Should Be Enabled    ${${platformName}_${lang}_policy}    timeout=5s
#    Set Calc VP With Source And Original Values    Step2Page_PolicyField_Enabled    false    ${status}    Static    Omne_Claim_Step2Page    false    ${status}
#    #checknextBtn
#    ${status}    Run Keyword And Return Status    Element Should Be Enabled    ${${platformName}_${lang}_step2NextBtn}    timeout=5s
#    Set Calc VP With Source And Original Values    Step2Page_NextButtonEnabled    false    ${status}    Static    Omne_Claim_Step2Page    false    ${status}
    # check checkbox
#    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_chkBox}    timeout=5s
#    Set Calc VP With Source And Original Values    Step2Page_CheckBox_Visible    true    ${status}    Static    Omne_Claim_Step2Page    true    ${status}

Verify ClaimDetails Step2 Page GUI
    Sleep    4s
    ${VP_headertext}    Get Element Attribute
    ...    ${${platformName}_${lang}_claimdetailspageheadertext}
    ...    attribute=name
    Set Calc VP With Source And Original Values
    ...    Step2ClaimDetailPage_HeaderText
    ...    Submit a claim Claim details
    ...    ${VP_headertext}
    ...    Static
    ...    Omne_ClaimDetails_Step2Page
    ...    Submit a claim Claim details
    ...    ${VP_headertext}
    # navigation panel
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_navigationPanel}
    ...    timeout=5s
    Set Calc VP With Source And Original Values
    ...    Step2ClaimDetailPage_NavigationPanelVisible
    ...    true
    ...    ${status}
    ...    Static
    ...    Omne_ClaimDetails_Step2Page
    ...    true
    ...    ${status}
    # header text
    ${VP_headerverifytext}    Get Element Attribute
    ...    ${${platformName}_${lang}_claimdetaispageheader1}
    ...    attribute=label
    ${claimabout}    Convert To Lower Case    ${ClaimIsAbout}
    Set Calc VP With Source And Original Values
    ...    Step2ClaimDetailPage_HeaderText1
    ...    Details about your ${claimabout}
    ...    ${VP_headerverifytext}
    ...    Static
    ...    Omne_ClaimDetails_Step2Page
    ...    Details about your ${claimabout}
    ...    ${VP_headerverifytext}
#    IF    '${ClaimIsAbout}' == 'Accident'
#    #accidentdate
#    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_accidentDate}    timeout=5s
#    ${value}    Get Text    ${${platformName}_${lang}_accidentDate}
#    IF    '${value}' != ''
#    Set Calc VP With Source And Original Values    Step2ClaimDetailPage_AccidentDateField_Autopopulated    Yes    Yes    Static    Omne_ClaimDetails_Step2Page    Yes    Yes
#    ELSE
#    Set Calc VP With Source And Original Values    Step2ClaimDetailPage_AccidentDateField_Autopopulated    Yes    No    Static    Omne_ClaimDetails_Step2Page    Yes    No
#    END
#    Set Calc VP With Source And Original Values    Step2ClaimDetailPage_AccidentDateFieldVisible    true    ${status}    Static    Omne_ClaimDetails_Step2Page    true    ${status}

#    END
    # treatmentdate
    Sleep    5s
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_treatmentdate}
    ...    timeout=5s
    Set Calc VP With Source And Original Values
    ...    Step2ClaimDetailPage_TreatmentDateFieldVisible
    ...    true
    ...    ${status}
    ...    Static
    ...    Omne_Claim_Step2Page
    ...    true
    ...    ${status}
    ${value}    Get Text    ${${platformName}_${lang}_treatmentdate}
    IF    '${value}' != ''
        Set Calc VP With Source And Original Values
        ...    Step2ClaimDetailPage_TreatmentDateField_Autopopulated
        ...    Yes
        ...    Yes
        ...    Static
        ...    Omne_ClaimDetails_Step2Page
        ...    Yes
        ...    Yes
    ELSE
        Set Calc VP With Source And Original Values
        ...    Step2ClaimDetailPage_TreatmentDateField_Autopopulated
        ...    Yes
        ...    No
        ...    Static
        ...    Omne_ClaimDetails_Step2Page
        ...    Yes
        ...    No
    END
    # diagnosis tab
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_DiagnosisOption}
    ...    timeout=5s
    Set Calc VP With Source And Original Values
    ...    Step2ClaimDetailPage_DiagnosisFieldVisible
    ...    true
    ...    ${status}
    ...    Static
    ...    Omne_ClaimDetails_Step2Page
    ...    true
    ...    ${status}

    # totalamount
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_totalAmountPaid}
    ...    timeout=5s
    Set Calc VP With Source And Original Values
    ...    Step2ClaimDetailPage_TotalAmountFieldVisible
    ...    true
    ...    ${status}
    ...    Static
    ...    Omne_ClaimDetails_Step2Page
    ...    true
    ...    ${status}
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_totalAmountfieldvaluepopulated}
    ...    timeout=50s
    IF    '${status}' == 'True'
        Set Calc VP With Source And Original Values
        ...    Step2ClaimDetailPage_TotalAmount_Autopopulated
        ...    No
        ...    No
        ...    Static
        ...    Omne_ClaimDetails_Step2Page
        ...    No
        ...    No
    ELSE
        Set Calc VP With Source And Original Values
        ...    Step2ClaimDetailPage_TotalAmount_Autopopulated
        ...    Yes
        ...    Yes
        ...    Static
        ...    Omne_ClaimDetails_Step2Page
        ...    Yes
        ...    Yes
    END
    SwipePage
    # treatmentitems
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_treatmentitems}
    ...    timeout=50s
    Set Calc VP With Source And Original Values
    ...    Step2ClaimDetailPage_TreamentItemFieldVisible
    ...    true
    ...    ${status}
    ...    Static
    ...    Omne_ClaimDetails_Step2Page
    ...    true
    ...    ${status}

    # medical centre
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_medicalCenterOption}
    ...    timeout=50s
    IF    '${status}' == 'True'
        Set Calc VP With Source And Original Values
        ...    Step2ClaimDetailPage_MedicalCentre_Autopopulated
        ...    Yes
        ...    No
        ...    Static
        ...    Omne_ClaimDetails_Step2Page
        ...    Yes
        ...    No
    ELSE
        Set Calc VP With Source And Original Values
        ...    Step2ClaimDetailPage_MedicalCentre_Autopopulated
        ...    Yes
        ...    Yes
        ...    Static
        ...    Omne_ClaimDetails_Step2Page
        ...    Yes
        ...    Yes
    END
