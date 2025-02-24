*** Settings ***
Library     SeleniumLibrary
Library     QraceHelper
Resource    ../../PageObjects/OWB/OWBInquiryPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    ../../PageObjects/OWB/OWBPaymentFrequencyPageObjects.resource
Resource    OWBAssignTaskPage.resource


*** Keywords ***
OWB Payment frequency
    Wait Until Element Is Visible    ${${lang}_currentFrequency}
    Take OWB Screenshot    Payment frequency Page
    ${VP_currentFrequency}    Get Text    ${EN_currentFrequency}
    ${VP_New_Payment_Frequency}    Get Text    ${EN_New_Payment_Frequency}
    ${VP_NewModalPremium}    Get Text    ${EN_NewModalPremium}
    ${VP_CurrentModalPremium}    Get Text    ${EN_CurrentModalPremium}
    ${VP_mCurrentModalPremium}    Remove String    ${VP_CurrentModalPremium}    ,
    ${VP_mCurrentModalPremium}    Evaluate    "{:.2f}".format(${VP_mCurrentModalPremium})
    ${VP_frequencyPolicyNo}    Get Element Attribute    ${EN_frequencyPolicyNo}    attribute=title
    ${VP_frequencyProductName}    Get Element Attribute    ${EN_frequencyProductName}    attribute=title
    @{VP_frequencyProductName}    Split String    ${VP_frequencyProductName}    -
    ${VP_frequencyProductName}    Get From List    ${VP_frequencyProductName}    0
    ${MVP_NewModalPremium}    Remove String    ${VP_NewModalPremium}    ,
    ${MVP_NewModalPremium}    Evaluate    "{:.2f}".format(${MVP_NewModalPremium})
    # add vp
#    IF    '${VP_currentFrequency}' == 'Annual'
#    ${mVP_currentFrequency}    Set Variable    Yearly
#    END
#    ELSE IF    '${VP_currentFrequency}' == 'Half-Yearly'
#    ${mVP_currentFrequency}    Set Variable    Semi-annual
#    ELSE
#    ${mVP_currentFrequency}    Set Variable    ${VP_currentFrequency}
#    END
    IF    '${VP_New_Payment_Frequency}' == 'Annual'
        ${mVP_New_Payment_Frequency}    Set Variable    Yearly
        Set Calc VP Actual Result With Original And Source
        ...    Transaction_New_Payment_Frequency
        ...    ${mVP_New_Payment_Frequency}
        ...    ${VP_New_Payment_Frequency}
        ...    OWB Application
        Set Calc VP Expected Result With Original And Source
        ...    Post Transaction New_Payment_Frequency
        ...    ${mVP_New_Payment_Frequency}
        ...    ${VP_New_Payment_Frequency}
        ...    OWB Application
    ELSE
        Set Calc VP Actual Result With Original And Source
        ...    Transaction_New_Payment_Frequency
        ...    ${VP_New_Payment_Frequency}
        ...    ${VP_New_Payment_Frequency}
        ...    OWB Application
        Set Calc VP Expected Result With Original And Source
        ...    Post Transaction New_Payment_Frequency
        ...    ${VP_New_Payment_Frequency}
        ...    ${VP_New_Payment_Frequency}
        ...    OWB Application
    END
#    ELSE IF    '${VP_New_Payment_Frequency}' == 'Half-Yearly'
#    ${mVP_New_Payment_Frequency}    Set Variable    Semi-annual
#    ELSE
#    ${mVP_New_Payment_Frequency}    Set Variable    ${mVP_New_Payment_Frequency}
#    END
#    IF    '${VP_CurrentPaymentMethod}' == 'Direct Billing (Cash)'
#    ${mVP_CurrentPaymentMethod}    Set Variable    Cash
#    ELSE IF    '${VP_CurrentPaymentMethod}' == 'Credit Card'
#    ${mVP_CurrentPaymentMethod}    Set Variable    Credit card
#    END
    Set Calc VP Actual Result With Original And Source
    ...    OLD_Payment_Frequency
    ...    ${VP_currentFrequency}
    ...    ${VP_currentFrequency}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    OLD_Payment_Premium
    ...    ${VP_mCurrentModalPremium}
    ...    ${VP_CurrentModalPremium}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Policy No
    ...    ${VP_frequencyPolicyNo}
    ...    ${VP_frequencyPolicyNo}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Policy_Applied
    ...    ${VP_frequencyProductName.strip()}
    ...    ${VP_frequencyProductName.strip()}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Transaction_New_Premium_Amount
    ...    ${MVP_NewModalPremium}
    ...    ${VP_NewModalPremium}
    ...    OWB Application
#    Set Calc VP Actual Result With Original And Source    Transaction_Facta_Status    ${EN_frequencyfactaStatus}    ${EN_frequencyfactaStatus}    OWB Application
    Set Calc VP Expected Result With Original And Source
    ...    Post Transaction Policy_Applied
    ...    ${VP_frequencyProductName.strip()}
    ...    ${VP_frequencyProductName.strip()}
    ...    OWB Application
    Set Calc VP Expected Result With Original And Source
    ...    Post Transaction New_Premium_Amount
    ...    ${MVP_NewModalPremium}
    ...    ${VP_NewModalPremium}
    ...    OWB Application
#    Set Calc VP Expected Result With Original And Source    Post Transaction Facta_Status    ${EN_frequencyfactaStatus}    ${EN_frequencyfactaStatus}    OWB Application
    Scroll Element Into View    ${${lang}_frequencyApprovalStatus}
    Take OWB Screenshot    Payment frequency Page
    Scroll Element Into View    ${${lang}_frequencyApprovalStatus}
    Take OWB Screenshot    Payment frequency Page
    ${Approved_Status}    Get Text    ${${lang}_frequencyApprovalStatus}
    Set Global Variable    ${Approved_Status}
    Set Calc VP Expected Result With Original And Source
    ...    Transaction_Status_After_OWB
    ...    ${Approved_Status.strip()}
    ...    ${Approved_Status}
    ...    OWB_Application
    Set Calc VP Expected Result With Original And Source
    ...    OWB TransactionStatus
    ...    ${Approved_Status.strip()}
    ...    ${Approved_Status}
    ...    OWB_Application

#    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${EN_viewAllImages}    timeout=3s
#    IF    '${status}' == 'True'
#    #handle switch window
#    Click Element    ${EN_viewAllImages}
#    Switch Window    new
#    Wait Until Element Is Visible    ${EN_totDocumentCount}    timeout=200s
#    Sleep    5s
#    Click Element    ${EN_totDocumentCount}
#    Take OWB Screenshot    Change Frequency Document Page
#    END
