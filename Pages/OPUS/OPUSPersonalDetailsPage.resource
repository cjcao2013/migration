*** Settings ***
Library     SeleniumLibrary
Library    RPA.Desktop
Resource    ../../PageObjects/OPUS/OPUSLoginPageObject.resource
Resource    ../../PageObjects/OPUS/OPUSInquiryPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    ../../PageObjects/OPUS/OPUSPersonalDetailPageObject.resource
Resource    ../../PageObjects/OPUS/OPUSTaskInquiryPageObjects.resource
Resource     ../../PageObjects/OPUS/OPUSAssignTaskPageObject.resource


*** Keywords ***
OPUS Personal details
    TRY
        ${status}       Run Keyword And Return Status    ${EN_NewMobileNumber}
        IF    '${status}' == 'True'
                  Scroll Element Into View    ${EN_NewMobileNumber}
        END
        #Capture VP  for verfication
        Take OPUS Screenshot        Personal Detail Page
        IF    '${PersonalDetails_WhatChange}' == 'Email'       Change Email VP
        IF    '${PersonalDetails_WhatChange}' == 'MobileNo'    Change Mobile VP
        IF    '${PersonalDetails_WhatChange}' == 'Mailing address'     Change Address VP
        IF    '${PersonalDetails_WhatChange}' == 'Name'        Change Name VP
        IF     '${PersonalDetails_WhatChange}' != 'Name'
             ${VP_TransactionStatus}    Get Text    ${EN_TransactionStatus}
            Set Calc VP Actual Result With Original And Source
            ...    Transaction_Status
            ...    ${VP_TransactionStatus}
            ...    ${VP_TransactionStatus}
            ...    OPUS Application
            Set Global Variable    ${VP_TransactionStatus}
            ${Final_Approve_Status}         Set Variable                 ${VP_TransactionStatus}
            Set Global Variable    ${Final_Approve_Status}
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Flow of ${Insurance_Flow}
    END

Change Email VP
    TRY
        Sleep    1s
        Wait Until Page Contains Element    ${EN_NewEmailAddress}    timeout=30s
        ${VP_New_Email_id}    Get Element Attribute    ${EN_NewEmailAddress}    attribute=title
        Set Calc VP Actual Result With Original And Source
        ...    NEW_Email_id_OWB
        ...    ${VP_New_Email_id}
        ...    ${VP_New_Email_id}
        ...    OPUS Application
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Change Email VP
    END


Change Mobile VP
    TRY
         Wait Until Page Contains Element    ${EN_NewMobileNumber}    timeout=30s

        ${VP_New_MobileNo}    Get Element Attribute    ${EN_NewMobileNumber}    attribute=title
        Set Calc VP Actual Result With Original And Source
        ...    NEW_MobileNo_OWB
        ...    ${VP_New_MobileNo}
        ...    ${VP_New_MobileNo}
        ...    OPUS Application
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Change Mobile VP
    END


Change Address VP
    TRY
        Wait Until Page Contains Element    ${EN_OPUS_Country}          timeout=90s
        Scroll Element Into View        ${EN_OPUS_Country}
        ${VP_Country_Code}    Get Element Attribute    ${EN_OPUS_Country}    attribute=title
        ${VP_Address_Line1}    Get Element Attribute    ${EN_Address_Line1_OPUS}    attribute=title
        ${VP_Address_Line2}    Get Element Attribute    ${EN_Address_Line2_OPUS}    attribute=title
        ${VP_City}    Get Element Attribute    ${EN_City_OPUS}    attribute=title
        ${VP_ZipCode}    Get Element Attribute    ${EN_ZipCode_OPUS}    attribute=title
        ${VP_State}    Get Element Attribute    ${EN_State_OPUS}    attribute=title
        Log    ${EN_State_OPUS}
        ${VP_District}    Get Element Attribute    ${EN_District_OPUS}    attribute=title
        ${VP_Policy_No}    Get Element Attribute    ${EN_Policy_No_txt}    attribute=title
    #    ${VP_Policy_Name}    Get Element Attribute    ${EN_Policy_Name_txt}    attribute=title
        ${VP_Completion_Date}    Get Element Attribute     ${EN_Compeletion_Date}       attribute=title
        IF    '${VP_Country_Code}' == 'ไทย'
            ${VP_Country}    Set Variable    Thailand
            Set Global Variable    ${VP_Country}
        END
        Take Screenshot    ChangeAddressPage

        ${VP_New_Address}    Set Variable
        ...    ${VP_Address_Line1}, ${VP_Address_Line2}, ${VP_State}, ${VP_District}, ${VP_City}, ${VP_ZipCode}, ${VP_Country}
        Set Calc VP Actual Result With Original And Source
        ...    Policy_No
        ...    ${VP_Policy_No}
        ...    ${VP_Policy_No}
        ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
        ...    New Address
        ...    ${VP_New_Address}
        ...    ${VP_New_Address}
        ...    OPUS Application


    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Change Address VP
    END

Change Name VP
    TRY
#   ${CaseStatus}    Set Variable    Pending
        IF    '${CaseStatus}' == 'Pending'
                Wait Until Element Is Visible    ${EN_Envoy}        timeout=20s
                Click Element    ${EN_Envoy}
                Wait Until Element Is Visible    ${EN_Add-Envoy_button}    timeout=25s
                Click Element    ${EN_Add-Envoy_button}
                Wait Until Element Is Visible     ${EN_Select_Pending_reason}    timeout=20s
                Click Element    ${EN_Select_Pending_reason}
                Wait Until Element Is Visible    ${EN_Further_Requirement}    timeout=20s
                Click Element    ${EN_Further_Requirement}
                Pause Execution
                Sleep    10s
                Wait Until Element Is Visible    ${EN_MemoCode}    timeout=10s
                Click Element    ${EN_MemoCode}

                Wait Until Element Is Visible    ${EN_Select_Memocode}      timeout=10s
                Click Element    ${EN_Select_Memocode}

                Wait Until Element Is Visible    ${EN_ReasonCode}    timeout=20s
                Click Element    ${EN_ReasonCode}
                Wait Until Element Is Visible    ${EN_SelectReasonCode}    timeout=20s
                Click Element    ${EN_SelectReasonCode}
                Wait Until Element Is Visible    ${EN_SaveButton}    timeout=20s
                Click Element    ${EN_SaveButton}
                Wait Until Element Is Visible    ${EN_SendButton}    timeout=20s
                Click Element    ${EN_SendButton}
                Wait Until Element Is Visible    ${EN_ResolveButton}    timeout=30s
                Click Element    ${EN_ResolveButton}
                ${Approved_Status}      Get Text    ${EN_OPUS_DecisionStatus}
                Set Global Variable    ${Approved_Status}
                ${Final_Approve_Status}     Set Variable     ${Approved_Status}
                Set Global Variable    ${Final_Approve_Status}
        ELSE
            Change Decision Status if Non STP

        END

            ${VP_new_Title}    Get Element Attribute    ${EN_VP_OPUS_new_Title}    attribute=title
            ${VP_new_Title}     Remove String    ${VP_new_Title}    .
            ${VP_new_FirstName}    Get Element Attribute    ${EN_VP_OPUS_new_FirstName}    attribute=title
            ${VP_new_MiddleName}    Get Element Attribute    ${EN_VP_OPUS_new_MiddleName}    attribute=title
            ${VP_new_LastName}    Get Element Attribute    ${EN_VP_OPUS_new_LastName}    attribute=title
            ${VP_new_MaritalStatus}    Get Element Attribute    ${EN_VP_OPUS_new_MaritalStatus}    attribute=title
    #       ${VP_Completion_Date}    Get Element Attribute    ${EN_Completion_Date}    attribute=title
            ${VP_Policy_No}    Get Element Attribute    ${EN_Policy_No_txt}    attribute=title
    #        ${VP_Policy_Name}    Get Element Attribute    ${EN_Policy_Name_txt}    attribute=title

            IF    '${VP_new_MaritalStatus}' == 'สมรส'
                  ${mVP_new_MaritalStatus}       Set Variable        Married
            ELSE IF   '${VP_new_MaritalStatus}' == 'โสด'
                ${mVP_new_MaritalStatus}       Set Variable        Single
            END
            Set Calc VP Actual Result With Original And Source
            ...    NEW_Title
            ...    ${VP_new_Title.strip()}
            ...    ${VP_new_Title}
            ...    OPUS Application
            Set Calc VP Actual Result With Original And Source
            ...    NEW_FirstName
            ...    ${VP_new_FirstName.strip()}
            ...    ${VP_new_FirstName}
            ...    OPUS Application
            IF    '${VP_new_MiddleName}' != ''
                Set Calc VP Actual Result With Original And Source
                ...    NEW_MiddleName
                ...    ${VP_new_MiddleName.strip()}
                ...    ${VP_new_MiddleName}
                ...    OPUS Application
            END
            Set Calc VP Actual Result With Original And Source
            ...    NEW_LastName
            ...    ${VP_new_LastName.strip()}
            ...    ${VP_new_LastName}
            ...    OPUS Application
            IF    '${VP_new_MaritalStatus}' != ''
                Set Calc VP Actual Result With Original And Source
                ...    NEW_MaritalStatus
                ...    ${mVP_new_MaritalStatus}
                ...    ${VP_new_MaritalStatus}
                ...    OPUS Application
            END

            # postVP
            IF    '${VP_new_Title}' != ''
                Set Calc VP Expected Result With Original And Source
                ...    Post_OWB_NEW_Title
                ...    ${VP_new_Title.strip()}
                ...    ${VP_new_Title}
                ...    OPUS Application
            END
            Set Calc VP Expected Result With Original And Source
            ...    Post_OWB_NEW_FirstName
            ...    ${VP_new_FirstName.strip()}
            ...    ${VP_new_FirstName}
            ...    OPUS Application
            IF    '${VP_new_MiddleName}' != ''
                Set Calc VP Expected Result With Original And Source
                ...    Post_OWB_NEW_MiddleName
                ...    ${VP_new_MiddleName.strip()}
                ...    ${VP_new_MiddleName}
                ...    OPUS Application
            END
            Set Calc VP Expected Result With Original And Source
            ...    Post_OWB_NEW_LastName
            ...    ${VP_new_LastName.strip()}
            ...    ${VP_new_LastName}
            ...    OPUS Application
            IF    '${VP_new_MaritalStatus}' != ''
                Set Calc VP Expected Result With Original And Source
                ...    Post_OWB_NEW_MaritalStatus
                ...    ${mVP_new_MaritalStatus}
                ...    ${VP_new_MaritalStatus}
                ...    OPUS Application
            END
            IF    '${CaseStatus}' != 'Pending'
                ${VP_TransactionStatus}    Get Text    ${EN_TransactionStatus}
                Set Calc VP Actual Result With Original And Source
                ...    Transaction_Status_OPUS
                ...    ${VP_TransactionStatus}
                ...    ${VP_TransactionStatus}
                ...    OPUS Application
                ${VP_TransactionStatus}    Get Text    ${EN_TransactionStatus}
                IF    '${VP_TransactionStatus}' == 'Decline'
                       ${mVP_TransactionStatus}           Set Variable        Declined
                END
                Set Calc VP Expected Result With Original And Source
                ...    Transaction_Status_After_OPUS
                ...    ${mVP_TransactionStatus.strip()}
                ...    ${VP_TransactionStatus}
                ...    OPUS Application

                Set Global Variable    ${VP_TransactionStatus}
                ${Final_Approve_Status}         Set Variable                 ${VP_TransactionStatus}
                Set Global Variable    ${Final_Approve_Status}
                Wait Until Page Contains Element    xpath=//button[@data-trigger='submit']      timeout=20s
                Click Element    xpath=//button[@data-trigger='submit']

                Take OPUS Screenshot    OPUS Inquiry
                Sleep    5s
            END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Change Name VP
    END

OPUS My policy(s)
    TRY
        Take OPUS Screenshot        Personal Detail Page
        Change Address VP
        ${VP_TransactionStatus}    Get Text    ${EN_TransactionStatus}
            Set Calc VP Actual Result With Original And Source
            ...    Transaction_Status
            ...    ${VP_TransactionStatus}
            ...    ${VP_TransactionStatus}
            ...    OPUS Application
            Set Global Variable    ${VP_TransactionStatus}
            ${Final_Approve_Status}         Set Variable                 ${VP_TransactionStatus}
            Set Global Variable    ${Final_Approve_Status}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Change My policy(s)
    END

OPUS Risk profile
    TRY
        ${PersonalDetails_WhatChange}       Set Variable        Name
        Set Global Variable          ${PersonalDetails_WhatChange}
        OPUS Personal details
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OPUS Change Risk profile
    END
