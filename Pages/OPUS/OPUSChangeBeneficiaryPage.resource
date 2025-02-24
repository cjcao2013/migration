*** Settings ***
Library     SeleniumLibrary
Library     String
Library     Collections
Resource    ../../CustomLibraries/Common.robot
Resource    ../../PageObjects/OPUS/OPUSChequeCancellationPageObject.resource
Resource    ../../PageObjects/OPUS/OPUSTaskInquiryPageObjects.resource
Resource    OPUSInquiryPage.resource

*** Keywords ***
OPUS Beneficiary(s) details
    TRY
        Wait Until Page Contains Element    xpath=//input[@id="name"]           timeout=50s
        ${nameLength}   Get Webelements    xpath=//input[@id="name"]
        ${length}    Get Length    ${nameLength}
        ${length}      Evaluate       ${length} + 1
        FOR    ${counter}    IN RANGE    1    ${length}
            IF    '${Edit_Beneficiary_${counter}}' == 'Add'
                IF    '${counter}' == '1'
                     Change Decision Status if Non STP
                END
                ${Beneficiary_Full_Name}   Get Element Attribute    xpath=(//input[@id="name"])[${counter}]     attribute=title
                @{s_Beneficiary_Full_Name}    Split String    ${Beneficiary_Full_Name}
                ${Beneficiary_first_Name}    Get From List    ${s_Beneficiary_Full_Name}    0
                ${Beneficiary_Last_Name}    Get From List     ${s_Beneficiary_Full_Name}    1
                ${Beneficiary_Allocation}    Get Value    xpath=(//input[@id='benefitPercentage'])[${counter}]
                ${Beneficiary_Relationship}    Get Element Attribute    xpath=(//div[text()='Relationship With Insured']/parent::div/child::div[2])[${counter}]    attribute=title
                Set Calc VP Actual Result With Original And Source
                ...    ${Beneficiary_first_Name}_${Beneficiary_Last_Name}_Relationship
                ...    ${Beneficiary_Relationship}
                ...    ${Beneficiary_Relationship}
                ...    OPUS Application
                Set Calc VP Actual Result With Original And Source
                ...    ${Beneficiary_first_Name}_${Beneficiary_Last_Name}_Allocation
                ...    ${Beneficiary_Allocation}%
                ...    ${Beneficiary_Allocation}%
                ...    OPUS Application
                    Set Calc VP Expected Result With Original And Source
                ...    Post_${Beneficiary_first_Name}_${Beneficiary_Last_Name}_Relationship
                ...    ${Beneficiary_Relationship}
                ...    ${Beneficiary_Relationship}
                ...    OPUS Application
                Set Calc VP Expected Result With Original And Source
                ...    Post_${Beneficiary_first_Name}_${Beneficiary_Last_Name}_Allocation
                ...    ${Beneficiary_Allocation}%
                ...    ${Beneficiary_Allocation}%
                ...    OPUS Application
               Take OPUS Screenshot    OPUS Inquiry
            ELSE
                ${Beneficiary_Full_Name}    Get Element Attribute    xpath=(//input[@id="name"])[${counter}]        attribute=title
                @{s_Beneficiary_Full_Name}    Split String    ${Beneficiary_Full_Name}
                ${mBeneficiary_Full_Name}        Remove String    ${Beneficiary_Full_Name}       ${SPACE}
                ${Beneficiary_first_Name}    Get From List    ${s_Beneficiary_Full_Name}    0
                ${Beneficiary_Last_Name}    Get From List     ${s_Beneficiary_Full_Name}    1
                ${Beneficiary_Allocation}    Get Value    xpath=(//input[@id='benefitPercentage'])[${counter}]
                ${Beneficiary_Relationship}    Get Element Attribute    xpath=(//div[text()='Relationship With Insured']/parent::div/child::div[2])[${counter}]    attribute=title
                Set Calc VP Actual Result With Original And Source
                ...    ${mBeneficiary_Full_Name.strip()}_Relationship
                ...    ${Beneficiary_Relationship}
                ...    ${Beneficiary_Relationship}
                ...    OPUS Application
                Set Calc VP Actual Result With Original And Source
                ...    ${mBeneficiary_Full_Name.strip()}_Allocation
                ...    ${Beneficiary_Allocation}%
                ...    ${Beneficiary_Allocation}%
                ...    OPUS Application
            END
        END
        IF    '${OPUSTransactionstatus}' == 'In progress'
             ${Approved_Status}    Get Element Attribute    xpath=//div[@id='decision']/div/div/div[1]      attribute=title
              Set Global Variable    ${Approved_Status}
               ${Final_Approve_Status}         Set Variable                 ${Approved_Status}
               Set Global Variable    ${Final_Approve_Status}
                    Set Global Variable    ${Approved_Status}
                    Set Calc VP Expected Result With Original And Source
                    ...    Transaction_Status_After_OPUS
                    ...    ${Approved_Status}
                    ...    ${Approved_Status}
                    ...    OPUS Application

                    Click Element    xpath=//button[@data-trigger='submit']
                    Sleep    5s
                    Take OPUS Screenshot    OPUS Inquiry
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Flow of ${Insurance_Flow}
    END
