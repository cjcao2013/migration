*** Settings ***
Library     SeleniumLibrary
Library     Dialogs
Library     String
Resource    ../../CustomLibraries/common.robot
Resource    ../../PageObjects/IL/ClientEnquiryObjects.robot
Resource    ../../PageObjects/IL/ProposalsandContractsObject.robot
Library     ../DBQuery/DBQuerySelect.py
Library     ../DBQuery/PersonalDetailsDB.py

*** Variables ***
${IL_Actual}


*** Keywords ***
IL_Proposals and Contracts
    TRY
        ${ClientIddec}    Get Client ID based on Policy Number from DB
        ...    ${dbhostname}
        ...    ${dbusername}
        ...    ${dbpassword}
        ...    ${dbport}
        ...    ${dbinstance}
        ...    ${Policy_No}
        ...    ${screenshotPath}
        Log    ${ClientIddec}

        ${IL_ClientNumber}    AES Decrypt    ${key}    ${ClientIddec}
        Log    ${IL_ClientNumber}
        Set Global Variable    ${IL_ClientNumber}
        Switch Window    NEW
        Maximize Browser Window
        Wait Until Element Is Visible    ${obj_enq_drag_controls}       timeout=10s
        Click Element    ${obj_enq_drag_controls}
        Wait Until Element Is Visible    ${obj_enq_ProposalsandContracts}   10s
        Click Element    ${obj_enq_ProposalsandContracts}
        Wait Until Element Is Visible    ${obj_enq_contractEnquiry}         timeout=10s
        Click Element    ${obj_enq_contractEnquiry}
        Wait Until Element Is Visible    ${obj_enq_ContractDetails}         timeout=10s
        Click Element    ${obj_enq_ContractDetails}
        Take IL Screenshot    Proposals and Contracts
        Wait Until Element Is Visible    ${obj_enq_contractNumber}      timeout=10s
        Input Text    ${obj_enq_contractNumber}    ${Policy_No}
        Take IL Screenshot    Proposals and Contracts
        Click Element    ${obj_OK_btn}
        Take IL Screenshot    Proposals and Contracts
        Run Keyword    ${CoreSystem_SubFlow}_${Core_System}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       IL_Flow   ${reason}  IL_Proposals and Contracts
    END
View Policy_IL
    TRY
        Wait Until Element Is Visible    ${obj_planComponent}       timeout=10s
        Input Text    ${obj_planComponent}    x
        Take IL Screenshot    Proposals and Contracts
        Click Element    ${obj_OK_btn}
        Wait Until Element Is Visible    ${obj_BUPlan_Dropdown}         timeout=10s
        Click Element    ${obj_BUPlan_Dropdown}
        Select From List By Label    ${obj_BUPlan_Dropdown}    Component Details
    #    Select From List By Value    ${obj_BUPlan_Dropdown}    Component Details
        Wait Until Element Is Visible    ${obj_OK_btn}              timeout=10s
        Click Element    ${obj_OK_btn}
        Take IL Screenshot    Proposals and Contracts
        Wait Until Element Is Visible    ${obj_ViewPolicySumAssured}            timeout=10s
        ${SumAssured}    Get Text    ${obj_ViewPolicySumAssured}
        ${mSumAssured}    Remove String    ${SumAssured}    ,
        ${mSumAssured}    Replace String    ${mSumAssured}    .00    .0
        Set Calc VP Actual Result With Original And Source
        ...    IL_SumAssured
        ...    ${mSumAssured.strip()}
        ...    ${SumAssured}
        ...    IL_Application
        Close Browser
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       IL_Flow   ${reason}  IL_View Polic
    END
address_IL
    TRY
        Wait Until Element Is Visible     ${obj_Extra_Details}      timeout=10s
        Click Element    ${obj_Extra_Details}
        Wait Until Element Is Visible    ${obj_address_street1}     timeout=10s
        ${street1}    Get Text    ${obj_address_street1}
        ${street2}    Get Text    ${obj_address_street2}
        ${subdistrict}    Get Text    ${obj_address_subdistrict}
        ${district}    Get Text    ${obj_address_district}
        ${city}    Get Text    ${obj_address_city}
        ${countrycode}    Get Text    ${obj_address_country}

        Take IL Screenshot    IL_AddressDetails
        Set Calc VP Actual Result With Original And Source    IL_AddressLine1    ${street1}    ${street1}    IL_Application
        Set Calc VP Actual Result With Original And Source    IL_AddressLine2    ${street2}    ${street2}    IL_Application
        Set Calc VP Actual Result With Original And Source
        ...    IL_AddressState
        ...    ${subdistrict}
        ...    ${subdistrict}
        ...    IL_Application
        Set Calc VP Actual Result With Original And Source
        ...    IL_AddressDistrict
        ...    ${district}
        ...    ${district}
        ...    IL_Application
        Set Calc VP Actual Result With Original And Source    IL_AddressCity    ${city}    ${city}    IL_Application
        Set Calc VP Actual Result With Original And Source
        ...    IL_AddressZipCode
        ...    ${countrycode}
        ...    ${countrycode}
        ...    IL_Application
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       IL_Flow   ${reason}  IL_Address
    END

View Investment_IL
    TRY
        Wait Until Element Is Visible     ${obj_Extra_Details}      timeout=10s
        Take IL Screenshot    IL_Contract Details
        Click Element    ${obj_Extra_Details}
        Wait Until Element Is Visible     ${obj_Fund_Portfolio}      timeout=10s
        Take IL Screenshot    IL_Contract Details
        Click Element    ${obj_Fund_Portfolio}
        Wait Until Element Is Visible    ${obj_investment_list}
        Take IL Screenshot    IL_Fund_details
        &{investemntfundnamedetails}      Create Dictionary
        &{investmentfunddetails}        Create Dictionary
            #capture fund details
        @{investment_fund_elements}     Get WebElements    ${obj_investment_list}
        ${Total_fundCount}      Get Length     ${investment_fund_elements}
        FOR    ${counter}    IN RANGE    1    ${Total_fundCount}+1

            Log    ${counter}
            ${IL_fundname}      Get Text    xpath=//div[contains(@id,"SZ448_SHORTDESC" )][${counter}]/div/span
            ${IL_fundUnitHoldingValue}      Get Text    xpath=//div[contains(@id,"SZ448_NOFUNT" )][${counter}]/div/span
            ${IL_fundPercentage}      Get Text    xpath=//div[contains(@id,"SZ448_PRCNT" )][${counter}]/div/span
            ${newfundcounter}    Get From Dictionary    ${Fund_dic}    ${IL_fundname}
            Set Calc VP Actual Result With Original And Source    IL_Fund${newfundcounter}_FundName    ${IL_fundname}    ${IL_fundname}    IL Application
            Set Calc VP Actual Result With Original And Source    IL_Fund${newfundcounter}_Percentage    ${IL_fundPercentage}%    ${IL_fundPercentage}%    IL Application
    #        ${IL_fundUnitHoldingValue}      Evaluate    "{:.2f}".format(${IL_fundUnitHoldingValue})
            Set Calc VP Actual Result With Original And Source    IL_Fund${newfundcounter}_UnitHolding   ${IL_fundUnitHoldingValue}    ${IL_fundUnitHoldingValue}    IL Application
            ${newfundcounter}   Evaluate    ${newfundcounter}+1
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       IL_Flow   ${reason}  IL_View Investment
    END
TaxConsent_IL
    TRY
        Wait Until Element Is Visible     ${obj_Extra_Details}      timeout=10s
        Take IL Screenshot    IL_Contract Details
        Click Element    ${obj_Extra_Details}
        Wait Until Element Is Visible     ${obj_TaxConsentValue}      timeout=10s
        Take IL Screenshot    IL_Extra_Detils
        ${VP_IL_TaxConsentValue}    Get Text    ${obj_TaxConsentValue}
        IF    '${VP_IL_TaxConsentValue}' == 'N'
            ${mVP_IL_TaxConsentValue}   Set Variable    No
        ELSE IF      '${VP_IL_TaxConsentValue}' == 'Y'
            ${mVP_IL_TaxConsentValue}   Set Variable    Yes
        END
        Set Calc VP Actual Result With Original And Source
            ...    IL_TaxConsent_acknowledgement_status
            ...    ${mVP_IL_TaxConsentValue}
            ...    ${mVP_IL_TaxConsentValue}
            ...    TestData
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       IL_Flow   ${reason}  IL_Tax Consent
    END
