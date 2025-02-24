*** Settings ***
Library     SeleniumLibrary
Resource    ../../PageObjects/OWB/LoginPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    ../../PageObjects/OWB/OWBBeneficiaryDetailsPageObject.resource


*** Keywords ***
OWB Beneficiary(s) details
    FOR    ${counter}    IN RANGE    1    6
        IF    '${Edit_Beneficiary_${counter}}' == 'Add'
            ${New_Beneficiary_First_Name}    Get Value
            ...    xpath=(//div[text()='NEW']/following::input[@id='firstName'])[${counter}]
            ${New_Beneficiary_Last_Name}    Get Value
            ...    xpath=(//div[text()='NEW']/following::input[@id='surname'])[${counter}]
            ${New_Beneficiary_Gender}    Get Value    xpath=(//div[text()='NEW']/following::input[@id='gender'])[${counter}]
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    xpath=(//input[@id='dateOfBirth'])[${counter}]
            ...    timeout=5s
            IF    '${status}'=='True'
                ${New_Beneficiary_DOB}    Get Value    xpath=(//input[@id='dateOfBirth'])[${counter}]
            ELSE
                ${New_Beneficiary_DOB}    Get Value
                ...    xpath=(//div[text()='NEW']/following::input[contains(@class,'calendar')])[${counter}]
            END
            ${New_Beneficiary_Relationship}    Get Value
            ...    xpath=(//div[text()='NEW']/following::input[@id='relationship'])[${counter}]
            ${status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    xpath=(//input[@id='benefitPercentage'])[${counter}]
            ...    timeout=5s
            IF    '${status}'=='True'
                ${New_Beneficiary_Allocation}    Get Value    xpath=(//input[@id='benefitPercentage'])[${counter}]
            ELSE
                ${New_Beneficiary_Allocation}    Get Value
                ...    xpath=(//div[text()='NEW']/following::input[@id='benefitPercentage'])[${counter}]
            END
#    ${New_Beneficiary_Beneficiary_Type}    Get Value    ${${lang}_New_Beneficiary_1_Beneficiary_Type}
            ${counterAdd}    Set Variable    1
            Set Calc VP Actual Result With Original And Source
            ...    New_Beneficiary_${counter}_First_Name
            ...    ${New_Beneficiary_First_Name}
            ...    ${New_Beneficiary_First_Name}
            ...    OWB
            Set Calc VP Actual Result With Original And Source
            ...    New_Beneficiary_${counter}_Last_Name
            ...    ${New_Beneficiary_Last_Name}
            ...    ${New_Beneficiary_Last_Name}
            ...    OWB
            Set Calc VP Actual Result With Original And Source
            ...    New_Beneficiary_${counter}_Relationship
            ...    ${New_Beneficiary_Relationship}
            ...    ${New_Beneficiary_Relationship}
            ...    OWB
            Set Calc VP Actual Result With Original And Source
            ...    New_Beneficiary_${counter}_Allocation
            ...    ${New_Beneficiary_Allocation}
            ...    ${New_Beneficiary_Allocation}
            ...    OWB

            # post transaction
            Set Calc VP Expected Result With Original And Source
            ...    Post_Transaction_New_Beneficiary_${counter}_First_Name
            ...    ${New_Beneficiary_First_Name}
            ...    ${New_Beneficiary_First_Name}
            ...    OWB
            Set Calc VP Expected Result With Original And Source
            ...    Post_Transaction_New_Beneficiary_${counter}_Last_Name
            ...    ${New_Beneficiary_Last_Name}
            ...    ${New_Beneficiary_Last_Name}
            ...    OWB
            Set Calc VP Expected Result With Original And Source
            ...    Post_Transaction_New_Beneficiary_${counter}_Relationship
            ...    ${New_Beneficiary_Relationship}
            ...    ${New_Beneficiary_Relationship}
            ...    OWB
            Set Calc VP Expected Result With Original And Source
            ...    Post_Transaction_New_Beneficiary_${counter}_Allocation
            ...    ${New_Beneficiary_Allocation}
            ...    ${New_Beneficiary_Allocation}
            ...    OWB
            ${counterAdd}    Set Variable    ${counterAdd}+1
        ELSE IF    '${Edit_Beneficiary_${counter}}' == 'Change'
            ${Updated_Beneficiary_First_Name}    Get Value    ${${lang}_Updated_Beneficiary_First_Name}
            ${Updated_Beneficiary_Last_Name}    Get Value    ${${lang}_Updated_Beneficiary_Last_Name}
            ${Updated_Beneficiary_Allocation}    Get Value    ${${lang}_Updated_Beneficiary_Allocation}
            ${Updated_Beneficiary_Relationship}    Get Value    ${${lang}_Updated_Beneficiary_Relationship}
#    ${Updated_Beneficiary_Beneficiary_Type}    Get Value    ${${lang}_Updated_Beneficiary_Beneficiary_Type}

            Set Calc VP Actual Result With Original And Source
            ...    Updated_Beneficiary_First_Name
            ...    ${Updated_Beneficiary_First_Name}
            ...    ${Updated_Beneficiary_First_Name}
            ...    OWB
            Set Calc VP Actual Result With Original And Source
            ...    Updated_Beneficiary_Last_Name
            ...    ${Updated_Beneficiary_Last_Name}
            ...    ${Updated_Beneficiary_Last_Name}
            ...    OWB
            Set Calc VP Actual Result With Original And Source
            ...    Updated_Beneficiary_Relationship
            ...    ${Updated_Beneficiary_Relationship}
            ...    ${Updated_Beneficiary_Relationship}
            ...    OWB
            Set Calc VP Actual Result With Original And Source
            ...    Updated_Beneficiary_Allocation
            ...    ${Updated_Beneficiary_Allocation}
            ...    ${Updated_Beneficiary_Allocation}
            ...    OWB

            # post transaction
            Set Calc VP Expected Result With Original And Source
            ...    Post_Transaction_Updated_Beneficiary_First_Name
            ...    ${Updated_Beneficiary_First_Name}
            ...    ${Updated_Beneficiary_First_Name}
            ...    OWB
            Set Calc VP Expected Result With Original And Source
            ...    Post_Transaction_Updated_Beneficiary_Last_Name
            ...    ${Updated_Beneficiary_Last_Name}
            ...    ${Updated_Beneficiary_Last_Name}
            ...    OWB
            Set Calc VP Expected Result With Original And Source
            ...    Post_Transaction_Updated_Beneficiary_Relationship
            ...    ${Updated_Beneficiary_Relationship}
            ...    ${Updated_Beneficiary_Relationship}
            ...    OWB
            Set Calc VP Expected Result With Original And Source
            ...    Post_Transaction_Updated_Beneficiary_Allocation
            ...    ${Updated_Beneficiary_Allocation}
            ...    ${Updated_Beneficiary_Allocation}
            ...    OWB
        END
    END
