*** Settings ***
Library     AppiumLibrary
Resource    ../../../PageObjects/Insurance/UpdatePolicy/RiskProfileDetailsPageObject.resource
Library     FakerLibrary
Resource    PersonalDetailsPage.resource
Library     QraceHelper
Library     SeleniumLibrary
Resource    ../Common/AddOTP.resource
Resource    ../../../PageObjects/Insurance/ViewTransactions/TransactionDetailsPageObjects.resource


*** Keywords ***
Risk profile
    TRY
        Update And Complete Page
        Update Particulars
        Suitablity Assessmaent
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END
Update And Complete Page
    TRY
        SwipePage
        Take Screenshot    Risk_Profile_Page
        ${VP_RiskProfile_HeaderText}    Get Text    ${${platformName}_${lang}_RiskProfile_HeaderText}
        ${VP_ContentWith_HeaderText}    Get Text    ${${platformName}_${lang}_ContentWith_HeaderText}
        ${VP_UpdateAndCompleteText}    Get Text    ${${platformName}_${lang}_UpdateAndCompleteTxt}

        ${VP_PersonalParticularAndSuitabilityAssessmentText}    Get Text    ${${platformName}_${lang}_UpdateAndCompleteTxt}

        IF    '${platformName}' == 'iOS'
            ${status}    Run Keyword And Return Status
            ...    Element Should Be Visible
            ...    ${${platformName}_${lang}_YourCurrentRiskProfileText}
            IF    '${status}' == 'True'
                ${VP_YourCurrentRiskProfileText}    Get Text    ${${platformName}_${lang}_YourCurrentRiskProfileText}
                ${YourCurrentRisk}    Split String    ${VP_YourCurrentRiskProfileText}    Last update
                ${VP_YourCurrentRisk}    Get From List    ${YourCurrentRisk}    0
                ${VP_YourCurrentRisk}    Strip String    ${VP_YourCurrentRisk}
                ${LastUpdateDate}    Get From List    ${YourCurrentRisk}    1
                ${LastUpdateDate}    Split String    ${LastUpdateDate}    Total score
                ${VP_LastUpdateDate}    Get From List    ${LastUpdateDate}    0
                ${VP_LastUpdateDate}    Strip String    ${VP_LastUpdateDate}
                ${TotalScore}    Get From List    ${LastUpdateDate}    1
                ${TotalScore}    Split String    ${TotalScore}    Risk level
                ${VP_TotalScore}    Get From List    ${TotalScore}    0
                ${VP_TotalScore}    Strip String    ${VP_TotalScore}
                ${RiskLevel}    Get From List    ${TotalScore}    1
                ${RiskLevel}    Split String    ${RiskLevel}    Investor type
                ${VP_RiskLevel}    Get From List    ${RiskLevel}    0
                ${VP_RiskLevel}    Strip String    ${VP_RiskLevel}
                ${VP_InvestorType}    Get From List    ${RiskLevel}    1
                ${VP_InvestorType}    Strip String    ${VP_InvestorType}
                Set Calc VP WIth Source And Original Values
                ...    KYC_YourCurrentRiskProfileText
                ...    Your current risk profile
                ...    ${VP_YourCurrentRisk}
                ...    OMNE_App
                ...    Static
                ...    ${VP_YourCurrentRisk}
                ...    Your current risk profile

                Set Calc VP With Source And Original Values
                ...    KYC_LastUpdateDate
                ...    ${VP_LastUpdateDate}
                ...    ${VP_LastUpdateDate}
                ...    Static
                ...    OMNE_APP
                ...    ${VP_LastUpdateDate}
                ...    ${VP_LastUpdateDate}
                Set Calc VP With Source And Original Values
                ...    KYC_TotalScore
                ...    ${VP_TotalScore}
                ...    ${VP_TotalScore}
                ...    Static
                ...    OMNE_APP
                ...    ${VP_TotalScore}
                ...    ${VP_TotalScore}
                Set Calc VP With Source And Original Values
                ...    KYC_RiskLevel
                ...    ${VP_RiskLevel}
                ...    ${VP_RiskLevel}
                ...    Static
                ...    OMNE_APP
                ...    ${VP_RiskLevel}
                ...    ${VP_RiskLevel}
                Set Calc VP With Source And Original Values
                ...    KYC_InvestorType
                ...    ${VP_InvestorType}
                ...    ${VP_InvestorType}
                ...    Static
                ...    OMNE_APP
                ...    ${VP_InvestorType}
                ...    ${VP_InvestorType}
            END
            ${VP_UpdateAndCompleteText}    Split String    ${VP_UpdateAndCompleteText}    image
            ${VP_UpdateAndCompleteText}    Get From List    ${VP_UpdateAndCompleteText}    1
            ${VP_UpdateAndCompleteText}    Split String    ${VP_UpdateAndCompleteText}    Personal
            ${VP_UpdateAndCompleteText}    Get From List    ${VP_UpdateAndCompleteText}    0

            ${VP_PersonalParticular}    Split String    ${VP_PersonalParticularAndSuitabilityAssessmentText}    complete
            ${VP_PersonalParticular}    Get From List    ${VP_PersonalParticular}    1
            ${VP_PersonalParticular}    Split String    ${VP_PersonalParticular}    Your
            ${VP_PersonalParticular}    Get From List    ${VP_PersonalParticular}    0
        ELSE
            ${VP_PersonalParticular}    Get Text
            ...    ${${platformName}_${lang}_PersonalParticularAndSuitabilityAssessmentText}
            ${VP_YourCurrentRisk}    Get Text    ${${platformName}_${lang}_YourCurrentRiskProfileText}
            ${status}    Run Keyword And Return Status
            ...    Element Should Be Visible
            ...    ${${platformName}_${lang}_LastUpdateDate}
            IF    '${status}' == 'True'
                ${VP_LastUpdateDate}    Get Text    ${${platformName}_${lang}_LastUpdateDate}
                ${VP_TotalScore}    Get Text    ${${platformName}_${lang}_TotalScore}
                ${VP_RiskLevel}    Get Text    ${${platformName}_${lang}_RiskLevel}
                ${VP_InvestorType}    Get Text    ${${platformName}_${lang}_InvestorType}
                Set Calc VP WIth Source And Original Values
                ...    KYC_YourCurrentRiskProfileText
                ...    Your current risk profile
                ...    ${VP_YourCurrentRisk}
                ...    OMNE_App
                ...    Static
                ...    ${VP_YourCurrentRisk}
                ...    Your current risk profile

                Set Calc VP With Source And Original Values
                ...    KYC_LastUpdateDate
                ...    ${VP_LastUpdateDate}
                ...    ${VP_LastUpdateDate}
                ...    Static
                ...    OMNE_APP
                ...    ${VP_LastUpdateDate}
                ...    ${VP_LastUpdateDate}
                Set Calc VP With Source And Original Values
                ...    KYC_TotalScore
                ...    ${VP_TotalScore}
                ...    ${VP_TotalScore}
                ...    Static
                ...    OMNE_APP
                ...    ${VP_TotalScore}
                ...    ${VP_TotalScore}
                Set Calc VP With Source And Original Values
                ...    KYC_RiskLevel
                ...    ${VP_RiskLevel}
                ...    ${VP_RiskLevel}
                ...    Static
                ...    OMNE_APP
                ...    ${VP_RiskLevel}
                ...    ${VP_RiskLevel}
                Set Calc VP With Source And Original Values
                ...    KYC_InvestorType
                ...    ${VP_InvestorType}
                ...    ${VP_InvestorType}
                ...    Static
                ...    OMNE_APP
                ...    ${VP_InvestorType}
                ...    ${VP_InvestorType}
            END
        END
    # Your current risk profile Last update 31 Oct 2023 Total score 19 Risk level 2 Investor type Medium to Low Risk
        Set Calc VP With Source And Original Values
        ...    KYC_RiskProfile_HeaderText
        ...    Update risk profile
        ...    ${VP_RiskProfile_HeaderText}
        ...    OMNE_App
        ...    Static
        ...    Update risk profile
        ...    ${VP_RiskProfile_HeaderText}
        Set Calc VP With Source And Original Values
        ...    KYC_ContentWith_HeaderText
        ...    Let’s get started on getting your risk profile up to date
        ...    ${VP_ContentWith_HeaderText}
        ...    OMNE_App
        ...    Static
        ...    Let’s get started on getting your risk profile up to date
        ...    ${VP_ContentWith_HeaderText}
        Set Calc VP With Source And Original Values
        ...    KYC_UpdateAndCompleteText
        ...    Update & complete
        ...    ${VP_UpdateAndCompleteText.strip()}
        ...    OMNE_App
        ...    Static
        ...    Update & complete
        ...    ${VP_UpdateAndCompleteText.strip()}
        Set Calc VP With Source And Original Values
        ...    KYC_PersonalParticularAndSuitabilityAssessmentText
        ...    Personal particulars & Suitability assessment
        ...    ${VP_PersonalParticular.strip()}
        ...    OMNE_App
        ...    Static
        ...    ${VP_PersonalParticular.strip()}
        ...    Personal particulars & Suitability assessment
        Click Element    ${${platformName}_${lang}_UpdateAndCompleteTxt}
        Take Screenshot    Risk_Profile_Page
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Update And Complete Page
    END

Update Particulars
    TRY
        Wait Until Element Is Visible    ${${platformName}_${lang}_PersonalDetails_FirstName}    timeout=10s
        ${VP_PersonalDetails_FirstName}    Get Text    ${${platformName}_${lang}_PersonalDetails_FirstName}

        ${VP_PersonalDetails_MiddleName}    Get Text    ${${platformName}_${lang}_PersonalDetails_Flowtails_MiddleName}

        ${VP_PersonalDetails_LastName}    Get Text    ${${platformName}_${lang}_PersonalDetails_LastName}

        ${VP_PersonalDetails_DOB}    Get Text    ${${platformName}_${lang}_PersonalDetails_DOB}

        ${VP_PersonalDetails_Citizenship}    Get Text    ${${platformName}_${lang}_PersonalDetails_Citizenship}

        ${VP_PersonalDetails_NumberOfDependent}    Get Text    ${${platformName}_${lang}_PersonalDetails_NoOfDependent}

        ${VP_PersonalDetails_MaritalStatus}    Get Text    ${${platformName}_${lang}_PersonalDetails_MartialStatus}
        Set Calc VP With Source And Original Values
        ...    KYC_Old_PersonalDetails_DOB
        ...    ${VP_PersonalDetails_DOB}
        ...    ${VP_PersonalDetails_DOB}
        ...    Static
        ...    OMNE_APP
        ...    ${VP_PersonalDetails_DOB}
        ...    ${VP_PersonalDetails_DOB}
        Set Calc VP With Source And Original Values
        ...    KYC_Old_PersonalDetails_NumberOfDependent
        ...    ${VP_PersonalDetails_NumberOfDependent}
        ...    ${VP_PersonalDetails_NumberOfDependent}
        ...    Static
        ...    OMNE_APP
        ...    ${VP_PersonalDetails_NumberOfDependent}
        ...    ${VP_PersonalDetails_NumberOfDependent}
        ${Status}    Run Keyword And Return Status
        ...    Element Should Be Enabled
        ...    ${${platformName}_${lang}_Next_Button}

        #    _________________PersoanlDetails_Update_---------------
        IF    '${VP_PersonalDetails_FirstName}' != ''
            Clear Text    ${${platformName}_${lang}_PersonalDetails_FirstName}
            ${fname}    FakerLibrary.First Name
            Input Text    ${${platformName}_${lang}_PersonalDetails_FirstName}    ${fname}
        END
        ${mname}    FakerLibrary.First Name
        Input Text    ${${platformName}_${lang}_PersonalDetails_Flowtails_MiddleName}    ${mname}
        IF    '${VP_PersonalDetails_LastName}' != ''
            Clear Text    ${${platformName}_${lang}_PersonalDetails_LastName}
            ${lname}    FakerLibrary.Last Name
            Input Text    ${${platformName}_${lang}_PersonalDetails_LastName}    ${lname}
        END
        Close keyboard
        IF    '${VP_PersonalDetails_Citizenship}' != ''
            Clear Text    ${${platformName}_${lang}_PersonalDetails_Citizenship}

            Input Text    ${${platformName}_${lang}_PersonalDetails_Citizenship}    ${Update_Risk_Profile_Citizenship}
        ELSE
            Input Text    ${${platformName}_${lang}_PersonalDetails_Citizenship}    ${Update_Risk_Profile_Citizenship}
        END

        Set Global Variable    ${fname}
        Set Global Variable    ${mname}
        Set Global Variable    ${lname}
        IF    '${VP_PersonalDetails_DOB}' != ''
            ${VP_DOB_AutoPopulated}    Set Variable    true
            Set Calc VP WIth Source And Original Values
            ...    KYC_PersonalDetials_DOBField_Autopopulated
            ...    true
            ...    ${VP_DOB_AutoPopulated}
            ...    OMNE_App
            ...    Static
            ...    true
            ...    ${VP_DOB_AutoPopulated}
        ELSE
            ${VP_DOB_AutoPopulated}    Set Variable    false
            Set Calc VP WIth Source And Original Values
            ...    KYC_PersonalDetials_DOBField_Autopopulated
            ...    false
            ...    ${VP_DOB_AutoPopulated}
            ...    OMNE_App
            ...    Static
            ...    false
            ...    ${VP_DOB_AutoPopulated}
        END
        Close keyboard

        IF    '${VP_PersonalDetails_MaritalStatus}' != ''
            Wait Until Element Is Visible    ${${platformName}_${lang}_PersonalDetails_MartialStatus}   timeout=5s
            Click Element    ${${platformName}_${lang}_PersonalDetails_MartialStatus}
            Take Screenshot    Risk_Profile_Page
            Wait Until Element Is Visible    ${${platformName}_${lang}_MartialStatus_Single}    timeout=5s
            ${Android_Marital_Status_Change}    Set Variable
            ...    xpath=//android.widget.TextView[@text='${Update_Risk_Profile_Martial_Status_Change}']
            ${IOS_Marital_Status_Change}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label == "${Update_Risk_Profile_Martial_Status_Change}"`][2]

            Click Element    ${${platformName}_Marital_Status_Change}
            Wait Until Element Is Visible    ${${platformName}_${lang}_Done_Button}     timeout=5s
            Click Element    ${${platformName}_${lang}_Done_Button}
        END
        IF    '${VP_PersonalDetails_NumberOfDependent}' == ''
            Input Text
            ...    ${${platformName}_${lang}_PersonalDetails_NumberOfDependent}
            ...    ${Update_Risk_Profile_Number_Of_Dependents_Change}
        END
        Take Screenshot    Risk_Profile_Page
        Wait Until Element Is Visible    ${${platformName}_${lang}_Next_Button}     timeout=10s
        Click Element    ${${platformName}_${lang}_Next_Button}
        Take Screenshot    Risk_Profile_Page
        Wait Until Element Is Visible    ${${platformName}_${lang}_PersonalParticularsTxt}    timeout=5s
        ${VP_PersonalParticulars}    Get Text    ${${platformName}_${lang}_PersonalParticularsTxt}
        ${VP_PleaseProvideDetails}    Get Text    ${${platformName}_${lang}_PleaseProvideTxt}
        Set Calc VP With Source And Original Values
        ...    KYC_PersonalParticulars_HeaderText
        ...    ${VP_PersonalParticulars}
        ...    ${VP_PersonalParticulars}
        ...    OMNE_App
        ...    Static
        ...    ${VP_PersonalParticulars}
        ...    ${VP_PersonalParticulars}
        Set Calc VP With Source And Original Values
        ...    KYC_PleaseProvide_HeaderText
        ...    ${VP_PleaseProvideDetails}
        ...    ${VP_PleaseProvideDetails}
        ...    OMNE_App
        ...    Static
        ...    ${VP_PleaseProvideDetails}
        ...    ${VP_PleaseProvideDetails}

        Click Element    ${${platformName}_${lang}_RiskAddImage}
        ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/hospClaim.png
        Upload Document BS    ${path}
        Wait Until Element Is Visible    ${${platformName}_${lang}_Save_Button}     timeout=5s
        Click Element    ${${platformName}_${lang}_Save_Button}

        Scroll Till Transaction Is Visible    ${${platformName}_${lang}_Next_Button}
        Wait Until Element Is Visible    ${${platformName}_${lang}_Next_Button}     timeout=10s
        Click Element    ${${platformName}_${lang}_Next_Button}

        # _________________________________addressChange_____________________________
        Wait Until Page Contains Element   ${${platformName}_${lang}_ResidentialAddress_HeaderText}    timeout=20s
        ${VP_ResidentialAddress_HeaderText}    Get Text    ${${platformName}_${lang}_ResidentialAddress_HeaderText}
        Set Calc VP WIth Source And Original Values
        ...    KYC_AddressDetails_Header
        ...    Residential address
        ...    ${VP_ResidentialAddress_HeaderText}
        ...    OMNE_App
        ...    Static
        ...    Residential address
        ...    ${VP_ResidentialAddress_HeaderText}
        Wait Until Element Is Visible    ${${platformName}_${lang}_AddressDetails_AddressLine1}    timeout=10s
        Clear Text    ${${platformName}_${lang}_AddressDetails_AddressLine1}
        ${PersonalDetails_Address_Line1}    Set Variable    ${EMPTY}
        FOR    ${counter}    IN RANGE    1    7
            Log    ${counter}
            ${randomnum}    FakerLibrary.Random Uppercase Letter
            ${PersonalDetails_Address_Line1}    Set Variable    ${PersonalDetails_Address_Line1}${randomnum}
        END
        Input Text    ${${platformName}_${lang}_AddressDetails_AddressLine1}    ${PersonalDetails_Address_Line1}\n
        Clear Text    ${${platformName}_${lang}_AddressDetails_AddressLine2}
        ${PersonalDetails_Address_Line2}    Set Variable    ${EMPTY}
        FOR    ${counter}    IN RANGE    1    7
            Log    ${counter}
            ${randomnum}    FakerLibrary.Random Uppercase Letter
             ${PersonalDetails_Address_Line2}    Set Variable    ${PersonalDetails_Address_Line2}${randomnum}
        END
        Input Text    ${${platformName}_${lang}_AddressDetails_AddressLine2}    ${PersonalDetails_Address_Line2}\n
        Clear Text    ${${platformName}_${lang}_AddressDetails_ZipCode}
        IF    '${platformName}'=='Android'
            Click Element    ${${platformName}_${lang}_AddressDetails_ZipCode}
            Input Text Into Current Element    ${Update_Risk_Profile_Residential_Address_ZipCode}
        ELSE
            Input Text
            ...    ${${platformName}_${lang}_AddressDetails_ZipCode}
            ...    ${Update_Risk_Profile_Residential_Address_ZipCode}
        END
        Wait Until Page Contains Element   ${${platformName}_${lang}_ResidentialAddress_HeaderText}           timeout=20s
        Click Element    ${${platformName}_${lang}_ResidentialAddress_HeaderText}
        Close keyboard

        Take Screenshot    Risk_Profile_Page
        SwipePage
        ${status}    Run Keyword And Return Status
        ...    Element Should Be Enabled
        ...    ${${platformName}_${lang}_MyIDCardAddressSame_chkbox}
        IF    '${status}' == 'True'
            Set Calc VP With Source And Original Values
            ...    KYC_My_ID_Card_chkbox_Checked
            ...    true
            ...    ${Status}
            ...    Static
            ...    OMNE_APP
            ...    true
            ...    ${Status}
        END
        ${status}    Run Keyword And Return Status
        ...    Element Should Be Visible
        ...    ${${platformName}_${lang}_IDCardAddress_HeaderText}
        IF    '${status}' == 'True'
            Set Calc VP With Source And Original Values
            ...    KYC_ID_Card_Address_chkbox_Checked
            ...    true
            ...    ${Status}
            ...    Static
            ...    OMNE_APP
            ...    true
            ...    ${Status}
        END
#        Wait Until Element Is Visible    ${${platformName}_${lang}_MyIDCardAddressSame_chkbox}      timeout=5s
#        Click Element    ${${platformName}_${lang}_MyIDCardAddressSame_chkbox}
#        Wait Until Element Is Visible    ${${platformName}_${lang}_MyIDCardAddressSame_chkbox}      timeout=5s
#        Click Element    ${${platformName}_${lang}_MyIDCardAddressSame_chkbox}
        SwipePage
        Click Element    ${${platformName}_${lang}_Next_Button}
        Wait Until Element Is Visible    ${${platformName}_${lang}_EducationalLevel}    timeout=15s
        ${Current_Education}    Get Element Attribute    ${${platformName}_${lang}_EducationalLevel}    attribute=name
        ${Current_Occupation}    Get Element Attribute    ${${platformName}_${lang}_Occupation}    attribute=name
        ${Current_Education}    Remove String    ${Current_Education}    Educational level (Optional)
        ${Current_Education}    Strip String    ${Current_Education}
        ${Current_Occupation}    Remove String    ${Current_Occupation}    Occupation
        ${Current_Occupation}    Strip String    ${Current_Occupation}
        Take Screenshot    Risk_Profile_Page
        ${Android_Education}    Set Variable    xpath=//android.widget.TextView[@text='${Update_Risk_Profile_Education}']
        ${IOS_Education}    Set Variable    xpath=(//XCUIElementTypeOther[@name="${Update_Risk_Profile_Education}"])[2]
        Wait Until Element Is Visible    ${${platformName}_${lang}_PleaseCheckUpdateParticularsTxt}    timeout=5s
        IF    '${Update_Risk_Profile_Education}' != '${Current_Education}'
            Click Element    ${${platformName}_${lang}_EducationalLevel}
            Wait Until Element Is Visible    ${${platformName}_Education}    timeout=2s
            Click Element    ${${platformName}_Education}

            Click Element    ${${platformName}_${lang}_Done_Button}
        END
        IF    '${Update_Risk_Profile_Occupation}' != '${Current_Occupation}'
            Click Element    ${${platformName}_${lang}_Occupation}
            IF    '${platformName}'=='Android'

                Click Element    xpath=//android.widget.TextView[@text='${Update_Risk_Profile_Occupation}']
            ELSE
                Scroll Till Transaction Is Visible     ${${platformName}_${lang}_Others}
                Wait Until Element Is Visible     ${${platformName}_${lang}_Others}     timeout=2s
                Clear Text    ${${platformName}_${lang}_Others}
                Wait Until Element Is Visible    ${${platformName}_${lang}_Others}      timeout=2s
                Input Text    ${${platformName}_${lang}_Others}    ${Update_Risk_Profile_Occupation}\n
            END
            Wait Until Element Is Visible     ${${platformName}_${lang}_Done_Button}    timeout=2s
            Click Element    ${${platformName}_${lang}_Done_Button}
        END
        Take Screenshot    Risk_Profile_Page
        Click Element    ${${platformName}_${lang}_Next_Button}
        Take Screenshot    Risk_Profile_Page
        Wait Until Element Is Visible    ${${platformName}_${lang}_MonthlyIncome}    timeout=10s
        Take Screenshot    Risk_Profile_Page
        ${Current_MonthlyIncome}    Get Text    ${${platformName}_${lang}_MonthlyIncome}
        ${Current_MonthlyIncome}    Split String    ${Current_MonthlyIncome}    (Optional)
        ${Current_MonthlyIncome}    Get From List    ${Current_MonthlyIncome}    1
        ${Current_MonthlyIncome}    Strip String    ${Current_MonthlyIncome}
        ${Android_MonthlyIncome}    Set Variable
        ...    xpath=//android.widget.TextView[@text='${Update_Risk_Profile_MonthlyIncome}']
        ${IOS_MonthlyIncome}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label == "${Update_Risk_Profile_MonthlyIncome}"`][2]
        IF    '${Update_Risk_Profile_MonthlyIncome}' != '${Current_MonthlyIncome}'
            Click Element    ${${platformName}_${lang}_MonthlyIncome}
            Wait Until Element Is Visible    ${${platformName}_MonthlyIncome}    timeout=20s
            Click Element    ${${platformName}_MonthlyIncome}
            Click Element    ${${platformName}_${lang}_Done_Button}
        END
        Wait Until Element Is Visible    ${${platformName}_${lang}_MonthlyExpenses}
        Clear Text    ${${platformName}_${lang}_MonthlyExpenses}

        Input Text    ${${platformName}_${lang}_MonthlyExpenses}    ${Update_Risk_Profile_MonthlyExpenses}\n
        @{currentasset}    Split String    ${Update_Risk_Profile_Current_Asset}    ,
        ${assetcount}    Get Length    ${currentasset}
        FOR    ${counter}    IN RANGE    0    ${assetcount}
            ${asset}    Get From List    ${currentasset}    ${counter}
            ${asset}    Strip String    ${asset}

            ${Android_AssetValue}    Set Variable
            ...    xpath=//android.widget.TextView[contains(@text,'${asset}')]/preceding-sibling::android.view.ViewGroup
            ${IOS_AssetValue}    Set Variable    xpath=//XCUIElementTypeOther[@name="${asset}"]/XCUIElementTypeOther
            Wait Until Element Is Visible    ${${platformName}_AssetValue}    timeout=10s
            Click Element    ${${platformName}_AssetValue}
        END
        Wait Until Element Is Visible    ${${platformName}_${lang}_Estimated_Asset_Value}       timeout=10s
        Clear Text    ${${platformName}_${lang}_Estimated_Asset_Value}
        Input Text    ${${platformName}_${lang}_Estimated_Asset_Value}    ${Update_Risk_Profile_EstimatedAssetValue}
        SwipePage
#        Wait Until Element Is Visible    ${${platformName}_${lang}_Objective_Investment}    timeout=5s
#        ${Android_Objective}    Set Variable
#        ...    xpath=//android.widget.TextView[contains(@text,'${Update_Risk_Profile_Objective_Investment}')]
#        ${IOS_Objective}    Set Variable
#        ...    xpath=(//XCUIElementTypeOther[@name="${Update_Risk_Profile_Objective_Investment}"])[2]
#        Click Element    ${${platformName}_${lang}_Objective_Investment}
#        Wait Until Element Is Visible    ${${platformName}_Objective}       timeout=10s
#
#        ${Objective_value}      Get Element Attribute    ${${platformName}_Objective}       attribute=label
#        IF    ' ${Objective_value} ' != '${Update_Risk_Profile_Objective_Investment}'
#            Click Element    ${${platformName}_Objective}
#        END


#        Wait Until Element Is Visible    ${${platformName}_${lang}_Done_Button}     timeout=10s
#        Click Element    ${${platformName}_${lang}_Done_Button}

        SwipePage
        SwipePage
        Wait Until Element Is Visible    ${${platformName}_${lang}_Confimation_Chekbox}     timeout=10s
        Click Element    ${${platformName}_${lang}_Confimation_Chekbox}
        Take Screenshot    Risk_Profile_Page
        Wait Until Element Is Visible    ${${platformName}_${lang}_Next_Button}     timeout=10s
        Click Element    ${${platformName}_${lang}_Next_Button}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Update Particulars
    END
Suitablity Assessmaent
    TRY
        Wait Until Element Is Visible    ${${platformName}_${lang}_SUitablityAssement_Header}   timeout=10s
        ${VP_SUitablityAssement_Header}    Get Text    ${${platformName}_${lang}_SUitablityAssement_Header}
        Set Calc VP WIth Source And Original Values
        ...    KYC_Suitability_assessment_Header
        ...    Suitability assessment
        ...    ${VP_SUitablityAssement_Header}
        ...    OMNE_App
        ...    Static
        ...    Suitability assessment
        ...    ${VP_SUitablityAssement_Header}

        ${VP_SuitablityAssment_YourAgeGroup}    Get Text    ${${platformName}_${lang}_SuitablityAssment_YourAgeGroup}
        Set Calc VP With Source And Original Values
        ...    KYC_Suitability_assessment_Your_age_Group
        ...    ${VP_SuitablityAssment_YourAgeGroup}
        ...    ${VP_SuitablityAssment_YourAgeGroup}
        ...    Static
        ...    OMNE_App
        ...    ${VP_SuitablityAssment_YourAgeGroup}
        ...    ${VP_SuitablityAssment_YourAgeGroup}
        # Question One
        FOR    ${counter}    IN RANGE    1    11

            ${Android_Question_Anwser}    Set Variable
            ...    xpath=//android.widget.TextView[@text='${Suitablity_Assessment_Question_${counter}}']
            ${IOS_Question_Anwser}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label == "${Suitablity_Assessment_Question_${counter}}"`]
            Wait Until Element Is Visible    ${${platformName}_Question_Anwser}    timeout=20s
            Click Element    ${${platformName}_Question_Anwser}
            Take Screenshot    Risk_Profile_Page
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_Next_Button}
            ...    timeout=30s
            IF    '${status}' == 'True'
                Click Element    ${${platformName}_${lang}_Next_Button}
            ELSE
                # Previous OTP from DB
                Get Details from DB
                ${Previous_OTP}    Set Variable    ${OTPNumber}
                Set Global Variable    ${Previous_OTP}
                Click Element    ${${platformName}_${lang}_Submit_Button}
            END
        END

        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_OTP_email}         timeout=10s
        IF    '${status}' == 'True'
            Insert OTP    ${Transaction_OTP_Source}    ${Transaction_OTP_Expiry_Flag}    ${Transaction_OTP_Resend_Flag}
        END

        ${status}    Run Keyword And Return Status
        ...    Element Should Be Visible
        ...    ${${platformName}_${lang}_RiskProfileUpdated}
        IF    '${status}' == 'True'
            Take Screenshot    Risk_Profile_Updated
            ${VP_Change_Success_Pass}    Get Text    ${${platformName}_${lang}_RiskProfileUpdated}
            Set Calc VP WIth Source And Original Values
            ...    KYC_Risk_Profile_Update
            ...    Risk profile updated
            ...    ${VP_Change_Success_Pass}
            ...    Static
            ...    OMNE_App
            ...    Risk profile updated
            ...    ${VP_Change_Success_Pass}
        END
        Set Global Variable    ${result}    Risk Profile Updated Sucessfully

        Wait Until Page Contains Element    ${${platformName}_${lang}_Back_Button}    timeout=30s
        Click Element    ${${platformName}_${lang}_Back_Button}

        Wait Until Page Contains Element    ${${platformName}_${lang}_Update_BackButton}    timeout=30s
        Click Element    ${${platformName}_${lang}_Update_BackButton}

        ${status}    Run Keyword And Return Status  Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=20s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_SeeAll}
        END
        Pause Execution
        Take Screenshot    Transaction_Page
        Wait Until Page Contains Element    ${${platformName}_${lang}_TransactionServiceRequest}    timeout=20s
        Click Element    ${${platformName}_${lang}_TransactionServiceRequest}
        Take Screenshot    Transaction_Page
        Run Keyword    Capture Risk Profile Transaction Details For ${platformName}    Pre
        Set Global Variable    ${result}    KYC Successfully for Policy No: ${Policy_No}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Update Particulars
    END
Capture Risk Profile Transaction Details For iOS
    [Arguments]    ${Transaction_Info}
    TRY

        Take Screenshot    Transaction_Page
        IF    '${Transaction_Info}'== 'Pre'
            ${iOS_selectCurrentTransaction1}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of personal details In progress' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
            ${iOS_transactionstatusobject}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of personal details In progress' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        ELSE IF    '${Transaction_Info}'== 'Post'
            ${iOS_selectCurrentTransaction1}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of personal details ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
            ${iOS_transactionstatusobject}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of personal details ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        END
        Wait Until Page Contains Element    ${iOS_selectCurrentTransaction1}
        Click Element    ${iOS_selectCurrentTransaction1}
        ${CompleteStatus_List}    Get Text    ${iOS_transactionstatusobject}
        @{Transaction_Status_List}    Split String    ${CompleteStatus_List}    Policy no
        Log To Console    Test1
        Take Screenshot    Transaction_Page
        ${TransactionStatus_list2}    Get From List    ${Transaction_Status_List}    0
        Log To Console    Test2
        @{TransactionStatus_list2}    Split String    ${TransactionStatus_list2}
        Log To Console    Test3
        ${Count}    Get Length    ${TransactionStatus_list2}
        ${Count}    Evaluate    ${Count} - 1
        ${VP_Transaction_Status}    Get From List    ${TransactionStatus_list2}    ${Count}
        Log To Console    Test4
        Log To Console    Transaction_Status=${VP_Transaction_Status}
        Log To Console    ListCount=${Count}
        IF    '${VP_Transaction_Status}' == 'progress'
            ${m_Vp}    Set Variable    In Progress
            ${m_Vp1}    Convert To Lower Case    ${m_Vp}
            ${OPUSTransactionstatus}    Set Variable    In progress
            Set Global Variable    ${OPUSTransactionstatus}
            Log     ${OPUSTransactionstatus}
        END
        IF    '${VP_Transaction_Status}' == 'Completed'
            ${m_Vp}    Set Variable    Approve
            ${PreTxnStatus}    Set Variable    approve
            Set Global Variable    ${PreTxnStatus}
            ${OPUSTransactionstatus}    Set Variable    Completed
            Set Global Variable    ${OPUSTransactionstatus}
        END
        ${NameDetails}    Get Text    chain=**/XCUIElementTypeOther[`label CONTAINS "First name"`][27]
        @{NameDetails}    Split String    ${NameDetails}    ${Policy_No}
        ${NameDetails}    Get From List    ${NameDetails}    1
        ${NameDetails}    Split String    ${NameDetails}    New
        ${FirstNameList}    Get From List    ${NameDetails}    0
        ${VP_FirstName}    Remove String    ${FirstNameList}    First name
        Log To Console    FirstName=${VP_FirstName}
        ${LastNameList}    Get From List    ${NameDetails}    1
        ${VP_MiddleName}    Remove String    ${LastNameList}    Middle name
        Log To Console    MiddleName=${VP_MiddleName}
        ${LastNameList}    Get From List    ${NameDetails}    2
        ${VP_LastName}    Remove String    ${LastNameList}    Last name
        Log To Console    LastName=${VP_LastName}
        IF    '${Transaction_Info}' == 'Pre'
            Set Calc VP With Source And Original Values
            ...    Transaction_NEW_FirstName
            ...    ${fname.strip()}
            ...    ${VP_FirstName.strip()}
            ...    OMNE_NameChangePage
            ...    OMNE_Transaction_Page
            ...    ${fname}
            ...    ${VP_FirstName}
            Set Calc VP With Source And Original Values
            ...    Transaction_NEW_LastName
            ...    ${lname.strip()}
            ...    ${VP_LastName.strip()}
            ...    OMNE_NameChangePage
            ...    OMNE_Transaction_Page
            ...    ${lname}
            ...    ${VP_LastName}
            Set Calc VP Expected Result With Original And Source
            ...    Transaction_Status
            ...    ${m_Vp.strip()}
            ...    ${m_Vp}
            ...    OMNE_Transaction_Page
            Set Calc VP Expected Result With Original And Source
            ...    NEW_FirstName
            ...    ${VP_FirstName.strip()}
            ...    ${VP_FirstName}
            ...    OMNE_Transaction_Page
            Set Calc VP Expected Result With Original And Source
            ...    NEW_MiddleName
            ...    ${VP_MiddleName.strip()}
            ...    ${VP_MiddleName.strip()}
            ...    OMNE_Transaction_Page
            Set Calc VP Expected Result With Original And Source
            ...    NEW_LastName
            ...    ${VP_LastName.strip()}
            ...    ${VP_LastName}
            ...    OMNE_Transaction_Page
        ELSE IF    '${Transaction_Info}' == 'Post'
            Set Calc VP Actual Result With Original And Source
            ...    Post_OWB_NEW_FirstName
            ...    ${VP_FirstName.strip()}
            ...    ${VP_FirstName}
            ...    OMNE_Transaction_Page
            Set Calc VP Actual Result With Original And Source
            ...    Post_OWB_NEW_MiddleName
            ...    ${VP_MiddleName.strip()}
            ...    ${VP_MiddleName.strip()}
            ...    OMNE_Transaction_Page
            Set Calc VP Actual Result With Original And Source
            ...    Post_OWB_NEW_LastName
            ...    ${VP_LastName.strip()}
            ...    ${VP_LastName}
            ...    OMNE_Transaction_Page
        END
     EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Risk Profile Transaction Details For iOS
    END

Capture Risk Profile Transaction Details For Android
    [Arguments]    ${Transaction_Info}
    Sleep    5s
#    ${currentdate}    Get Current Date
#    ${currdate}    Convert Date    ${currentdate}    result_format=%b %d %Y
    Take Screenshot    Transaction_Page
    IF    '${Transaction_Info}'== 'Pre'
        ${Android_selectCurrentTransaction1}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of personal details']/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]
    ELSE IF    '${Transaction_Info}'== 'Post'
        ${Android_selectCurrentTransaction1}    Set Variable
        ...    xpath=xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of personal details']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='${MCaseStatus}'])[1]
    END
    Wait Until Page Contains Element    ${Android_selectCurrentTransaction1}
    Click Element    ${Android_selectCurrentTransaction1}
    Take Screenshot    Transaction Page
    ${VP_FirstName}    Get Text    ${${platformName}_${lang}_TransactionFirstName}
    ${VP_MiddleName}    Get Text    ${${platformName}_${lang}_TransactionMiddleName}
    ${VP_LastName}    Get Text    ${${platformName}_${lang}_TransactionLastName}
#    ${VP_MaritalStatus}    Get Text    ${EN_TransactionMarital}
#    ${VP_Completion_Date}    Get Text    ${EN_Completion_Date}
    ${requeststatus}    Get Text    ${Android_selectCurrentTransaction1}
    IF    '${requeststatus}' == 'In progress'
        ${m_Vp}    Set Variable    In Progress
        ${m_Vp1}    Convert To Lower Case    ${m_Vp}
        ${OPUSTransactionstatus}    Set Variable    In progress
        Set Global Variable    ${OPUSTransactionstatus}
        Log     ${OPUSTransactionstatus}
    END
    IF    '${VP_Transaction_Status}' == 'Completed'
        ${m_Vp}    Set Variable    Approve
        ${PreTxnStatus}    Set Variable    approve
        Set Global Variable    ${PreTxnStatus}
        ${OPUSTransactionstatus}    Set Variable    Completed
        Set Global Variable    ${OPUSTransactionstatus}
    END
    Sleep    2s
    IF    '${Transaction_Info}' == 'Pre'
        Set Calc VP With Source And Original Values
        ...    Transaction_NEW_FirstName
        ...    ${fname.strip()}
        ...    ${VP_FirstName.strip()}
        ...    OMNE_NameChangePage
        ...    OMNE_Transaction_Page
        ...    ${fname}
        ...    ${VP_FirstName}
        Set Calc VP With Source And Original Values
        ...    Transaction_NEW_LastName
        ...    ${lname.strip()}
        ...    ${VP_LastName.strip()}
        ...    OMNE_NameChangePage
        ...    OMNE_Transaction_Page
        ...    ${lname}
        ...    ${VP_LastName}
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status
        ...    ${m_Vp.strip()}
        ...    ${m_Vp}
        ...    OMNE_Transaction_Page
        Set Calc VP Expected Result With Original And Source
        ...    NEW_FirstName
        ...    ${VP_FirstName.strip()}
        ...    ${VP_FirstName}
        ...    OMNE_Transaction_Page
        Set Calc VP Expected Result With Original And Source
        ...    NEW_MiddleName
        ...    ${VP_MiddleName.strip()}
        ...    ${VP_MiddleName.strip()}
        ...    OMNE_Transaction_Page
        Set Calc VP Expected Result With Original And Source
        ...    NEW_LastName
        ...    ${VP_LastName.strip()}
        ...    ${VP_LastName}
        ...    OMNE_Transaction_Page
    ELSE IF    '${Transaction_Info}' == 'Post'
        Set Calc VP Actual Result With Original And Source
        ...    Post_OWB_NEW_FirstName
        ...    ${VP_FirstName.strip()}
        ...    ${VP_FirstName}
        ...    OMNE_Transaction_Page
        Set Calc VP Actual Result With Original And Source
        ...    Post_OWB_NEW_MiddleName
        ...    ${VP_MiddleName.strip()}
        ...    ${VP_MiddleName.strip()}
        ...    OMNE_Transaction_Page
        Set Calc VP Actual Result With Original And Source
        ...    Post_OWB_NEW_LastName
        ...    ${VP_LastName.strip()}
        ...    ${VP_LastName}
        ...    OMNE_Transaction_Page
    END
