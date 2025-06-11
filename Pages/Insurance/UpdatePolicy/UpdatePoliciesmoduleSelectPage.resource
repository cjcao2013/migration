*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     Dialogs
Library    common
Resource    ../../../PageObjects/Insurance/UpdatePolicy/UpdatePoliciesmoduleSelectPageObject.resource
Resource    PaymentMethodDetailsPage.resource
Resource    TaxConsentDetailsPage.resource
Resource    ChangeBeneficiaryPage.resource
Resource    PersonalDetailsPage.resource
Resource    DeleteRiderPage.resource
Resource    SurrenderPolicyPage.resource
Resource    PartialWithdrawalPage.resource
Resource    PaymentFrequencyPage.resource
Resource    SwitchFundsPage.resource
Resource    FreelookupPage.resource
Resource    RiskProfileDetailsPage.resource
Resource    ICPOptionPage.resource
Resource    CVPolicyLoanPage.resource
Resource    RecurringPaymentPage.resource
Resource     ../../../CustomLibraries/common.robot
Resource    ChequeCancellationPage.resource


*** Keywords ***
Manage
    TRY
        ${Android_EN_InsurancePage}       Set Variable    android=new UiSelector().text("${Flow_Flag}")
        ${iOS_EN_InsurancePage}           Set Variable    chain=**/XCUIElementTypeButton[`label == '${Flow_Flag}'`]
        Wait Until Element Is Visible      ${${platformName}_${lang}_InsurancePage}            timeout=30s
        Take Screenshot     FWD_Insurance_Page
        Click Element       ${${platformName}_${lang}_InsurancePage}
        Set or enter PIN
        #      Select Insurance Flow
        ${Android_EN_Insurance_Module}    Set Variable     android=new UiSelector().textContains("${Insurance_Flow}")
        ${iOS_EN_Insurance_Module}        Set Variable     chain=**/XCUIElementTypeOther[`label CONTAINS '${Insurance_Flow}'`][-1]
        Wait Until Element Is Visible    ${${platformName}_${lang}_Insurance_Module}        timeout=20s
        Click Element    ${${platformName}_${lang}_Insurance_Module}

        ${status}       Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_OKPopup}        timeout=5s
        IF    '${status}' == 'True'
             Click Element    ${${platformName}_${lang}_OKPopup}
        END


        #      Select Update Policy Module
        IF    '${Update_Policy_Module}' != 'Personal details'
             ${Android_EN_Update_Policy_Module}  Set Variable     android=new UiSelector().textContains("${Update_Policy_Module}")
            ${iOS_EN_Update_Policy_Module}      Set Variable     chain=**/XCUIElementTypeOther[`label CONTAINS '${Update_Policy_Module}'`][-1]
            Scroll Till Transaction Is Visible          ${${platformName}_${lang}_Update_Policy_Module}
            Wait Until Element Is Visible    ${${platformName}_${lang}_Update_Policy_Module}    timeout=10s
            Take Screenshot    Update_Policies_Page
            Click Element     ${${platformName}_${lang}_Update_Policy_Module}
        END

        #call specefic module of mnage policy
        Run Keyword     ${Update_Policy_Module}

        ${actualResult}=    Catenate    ${actualResult}     | FWD Insurance Flow of ${Insurance_Flow} Successful   : ${result}
        Set Global Variable    ${actualResult}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END
