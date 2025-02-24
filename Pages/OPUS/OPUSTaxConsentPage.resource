*** Settings ***
Library     SeleniumLibrary
Resource    ../../PageObjects/OPUS/OPUSTaxConsentPageObjects.resource


*** Keywords ***
OPUS Tax consent
    TRY
        Wait Until Element Is Visible    ${EN_OPUS_TaxconsentOption}        timeout=10s
        Scroll Element Into View    ${EN_OPUS_TaxconsentOption}
        ${VP_OPUS_TaxconsentOption}    Get Text    ${EN_OPUS_TaxconsentOption}
        ${Approved_Status}      Get Text    ${EN_OPUS_TransactionStatus}
        ${VP_Completion_Date}      Get Element Attribute     ${EN_OPUS_RequestDatedata}     attribute==value
    #    ${VP_Completion_Datemsg}    Convert Date    ${VP_Completion_Date}    result_format=%d %b %Y
        Take OPUS Screenshot        OPUS TaxConsentPage
        Set Global Variable    ${Approved_Status}
        ${Final_Approve_Status}     Set Variable     ${Approved_Status}
        Set Global Variable    ${Final_Approve_Status}
         Set Calc VP Actual Result With Original And Source
        ...    Transaction_Status
        ...    ${Approved_Status.strip()}
        ...    ${Approved_Status}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    TaxConsent_Option
        ...    ${VP_OPUS_TaxconsentOption.strip()}
        ...    ${VP_OPUS_TaxconsentOption}
        ...    OPUS Application

        Take OPUS Screenshot    TaxConsentPage
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       OPUS_Flow   ${reason}   OPUS  ${Insurance_Flow}
    END