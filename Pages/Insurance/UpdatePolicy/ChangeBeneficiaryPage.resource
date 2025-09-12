*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     ../../Qrace/QraceHelper.py
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/ChangeBeneficiaryPageObjects.resource


*** Variables ***
${errormsg}     ${EMPTY}


*** Keywords ***
Beneficiary(s) details
    TRY
        Wait Until Element Is Visible    ${${platformName}_${lang}_ChangeBeneficiarydetails}      timeout=5s
        Select Policy
        Wait Until Element Is Visible   ${${platformName}_${lang}_beneNextButton}           timeout=5s
        Take Screenshot    Beneficiary_Details
        Click Element    ${${platformName}_${lang}_beneNextButton}
        @{Existing_bene_dict}       Create List
        Set Global Variable     ${Existing_bene_dict}
        FOR    ${counter}    IN RANGE    1    6
            IF    '${Edit_Beneficiary_${counter}}' == 'Add'
                #    Add New Beneficiary
                Wait Until Element Is Visible    ${${platformName}_${lang}_add_beneficiary_btn}     timeout=2s
                Click Element    ${${platformName}_${lang}_add_beneficiary_btn}
                Add new beneficiary    ${counter}
            ELSE IF    '${Edit_Beneficiary_${counter}}' == 'Change'
                #    Change First Beneficiary Allocation
                IF    '${platformName}' == 'Android'
                    ${Android_EN_change_existingbene_Perc}  Set Variable
                    ...    xpath=(//android.widget.TextView[@text='${Existing_Beneficiary_Name_${counter}}']/following::android.widget.EditText[@resource-id='beneficiary-ratio'])[1]
                    Wait Until Element Is Visible    ${${platformName}_${lang}_change_existingbene_Perc}    timeout=5s
                    Take Screenshot    Existing Beneficiary
                    Clear Text    ${${platformName}_${lang}_change_existingbene_Perc}
                    Click Element    ${${platformName}_${lang}_change_existingbene_Perc}
                    @{CustID_len}    Split String To Characters     ${Change_Beneficiary_Percentage_${counter}}
                    FOR    ${char}    IN    @{CustID_len}
                        Input Text Into Current Element    ${char}
                    END
                    Close keyboard
                    Take Screenshot    Existing Beneficiary After Change
                ELSE
                    ${change_existingbene_Perc}    Set Variable
                    ...    xpath=(//XCUIElementTypeOther[contains(@name,'${Existing_Beneficiary_Name_${counter}}')])[last()]//following-sibling::XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeTextField
                    Wait Until Element Is Visible    ${change_existingbene_Perc}        timeout=2s
                    Take Screenshot    Existing Beneficiary
                    Clear Text    ${change_existingbene_Perc}
                    Input Text    ${change_existingbene_Perc}    ${Change_Beneficiary_Percentage_${counter}}\n
    #               Click Element    ${${platformName}_${lang}_add_beneficiary_btn}
                END
            END
        END
    #    Fatca Status
        SwipePage
        Click Element    ${${platformName}_${lang}_acknowledgeChkBox}
        Take Screenshot    Beneficiary_New_Details
        Click Element    ${${platformName}_${lang}_beneNextButton}
        IF    '${Fatca_Status}' == 'Yes'
            Run Keyword    FATCA Status Change
        END
        # Previous OTP from DB
        Get Details from DB
        ${Previous_OTP}    Set Variable    ${OTPNumber}
        Set Global Variable    ${Previous_OTP}
        Take Screenshot    Beneficiary_View_Summary
        Click Element    ${${platformName}_${lang}_SubmitButton}
        ${sOutput}    Run Keyword And Ignore Error
        ...    Insert OTP
        ...    ${Transaction_OTP_Source}
        ...    ${Transaction_OTP_Expiry_Flag}
        ...    ${Transaction_OTP_Resend_Flag}
        ${success_message}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_Thank_you_message}     timeout=2s
        Take Screenshot    Success Message
        Run Keyword    Check Transaction Status
        Run Keyword    Handle Feedback
        Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=20s
        Click Element    ${${platformName}_${lang}_SeeAll}
        Take Screenshot    Transaction_Page
        Wait Until Page Contains Element    ${${platformName}_${lang}_ServiceReuest}    timeout=50s
        Click Element    ${${platformName}_${lang}_ServiceReuest}
        Take Screenshot    Transaction_Page
        Run Keyword    Capture Beneficiary Transaction Details for ${platformName}    Pre
        Set Global Variable    ${result}    Beneficiary Details Changed Successfully for Policy No: ${Policy_No}

    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END

Add new beneficiary
    [Arguments]    ${counter}
    TRY
        #    Beneficiary Details
        ${beneficiaryfname}    FakerLibrary.first_name
        ${beneficiarymname}    FakerLibrary.first_name
        ${beneficiarylname}    FakerLibrary.last_name
        Wait Until Element Is Visible    ${${platformName}_${lang}_beneficiary_first_name}      timeout=2s
        Input Text    ${${platformName}_${lang}_beneficiary_first_name}    ${beneficiaryfname}
        Close keyboard
        #beneficiary middle name (optional)
        Input Text    ${${platformName}_${lang}_beneficiary_last_name}    ${beneficiarylname}
        Close Keyboard
        #beneficiary National ID
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_beneficiary_nationality_dropdown}      timeout=3s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_beneficiary_nationality_dropdown}
            Wait Until Element Is Visible    ${${platformName}_${lang}_beneficiary_dropdown_search_field}       timeout=2s
            Input Text
            ...    ${${platformName}_${lang}_beneficiary_dropdown_search_field}
            ...    ${Change_Beneficiary_Nationality_${counter}}
            Close Keyboard
            ${Android_selectNationality}    Set Variable
            ...    android=new UiSelector().text("${Change_Beneficiary_Nationality_${counter}}").instance(1)
            ${iOS_selectNationality}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${Change_Beneficiary_Nationality_${counter}}'`][-1]
            Wait Until Element Is Visible    ${${platformName}_selectNationality}       timeout=2s
            Click Element    ${${platformName}_selectNationality}
        END
        #beneficiary DOB
        Wait Until Element Is Visible    ${${platformName}_${lang}_beneficiary_dob}     timeout=2s
        Click Element    ${${platformName}_${lang}_beneficiary_dob}
        Input Text    ${${platformName}_${lang}_beneficiary_dob}    ${Change_Beneficiary_DOB_${counter}}\n
        #beneficiary Gender
        Wait Until Element Is Visible    ${${platformName}_${lang}_beneficiary_gender}      timeout=2s
        Click Element    ${${platformName}_${lang}_beneficiary_gender}
        Click Element    ${${platformName}_${lang}_beneficiary_gender}
        ${Android_selectGender}    Set Variable    android=new UiSelector().text("${Change_Beneficiary_Gender_${counter}}")
        ${iOS_selectGender}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${Change_Beneficiary_Gender_${counter}}'`][-1]
        Wait Until Element Is Visible    ${${platformName}_selectGender}
        Click Element    ${${platformName}_selectGender}
        Wait Until Element Is Visible    ${${platformName}_${lang}_document_type_dropdown}    timeout=20s
        Click Element    ${${platformName}_${lang}_document_type_dropdown}
        ${iOS_selectDocumentType}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${Change_Beneficiary_Document_${counter}}'`][-1]
        ${Android_selectDocumentType}    Set Variable
        ...    android=new UiSelector().className("android.widget.TextView").text("${Change_Beneficiary_Document_${counter}}")
        #beneficiary Dodcument Type
        Wait Until Element Is Visible    ${${platformName}_selectDocumentType}    timeout=20s
        Click Element    ${${platformName}_selectDocumentType}
        IF    '${Change_Beneficiary_Document_${counter}}' == 'Password'
            ${Invalid_Passport_Number}      Get Substring    ${Change_Beneficiary_Document_Number_${counter}}    5
            Wait Until Element Is Visible    ${${platformName}_${lang}_document_number_text_field}   timeout=20s
            Click Element    ${${platformName}_${lang}_document_number_text_field}
            Input Text
            ...    ${${platformName}_${lang}_document_number_text_field}
            ...    ${Invalid_Passport_Number} 
            ${Status}       Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_bene_Inavlid_Passport_Error}
            IF    '${Status} ' == True
                 ${Error_Message}       Get Text    ${${platformName}_${lang}_bene_Inavlid_Passport_Error}
                 ${VP_Message}      Set Variable        Please enter a valid Passport Number
                 Set Calc VP With Source And Original Values    Invalid_Passport_Number_Eror_With_5_Digit_Number   ${VP_Message.strip()}     ${Error_Message.strip()}    Static    OMNE_SignInDocumentPage    ${VP_Message.strip()}     ${Error_Message.strip()}
            END
            ${Invalid_Passport_Number}      Set Variable    12345678901234567
            Click Element    ${${platformName}_${lang}_document_number_text_field}
            Clear Text    ${${platformName}_${lang}_document_number_text_field}
            Input Text
            ...    ${${platformName}_${lang}_document_number_text_field}
            ...    ${Invalid_Passport_Number}
            ${Status}       Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_bene_Inavlid_Passport_Error}
            IF    '${Status} ' == True
                 ${Error_Message}       Get Text    ${${platformName}_${lang}_bene_Inavlid_Passport_Error}
                 ${VP_Message}      Set Variable        Please enter a valid Passport Number
                 Set Calc VP With Source And Original Values    Invalid_Passport_Number_Eror_With_17_Digit_Number   ${VP_Message.strip()}     ${Error_Message.strip()}    Static    OMNE_SignInDocumentPage    ${VP_Message.strip()}     ${Error_Message.strip()}
            END
            Click Element    ${${platformName}_${lang}_document_number_text_field}
            Clear Text    ${${platformName}_${lang}_document_number_text_field}
            Input Text
            ...    ${${platformName}_${lang}_document_number_text_field}
            ...    ${Change_Beneficiary_Document_Number_${counter}}
        ELSE
            Wait Until Element Is Visible    ${${platformName}_${lang}_document_number_text_field}   timeout=20s
            Click Element    ${${platformName}_${lang}_document_number_text_field}
            Input Text
            ...    ${${platformName}_${lang}_document_number_text_field}
            ...    ${Change_Beneficiary_Document_Number_${counter}}
        END

        #beneficiary Last Name
        Wait Until Element Is Visible    ${${platformName}_${lang}_beneficiary_last_name}   timeout=20s
        Click Element    ${${platformName}_${lang}_beneficiary_last_name}
        IF    '${platformName}' == 'iOS'
            Click Element    ${${platformName}_${lang}_beneficiary_gender}
        END
        Close Keyboard
        #beneficiary  Realationship
        ${status}    Run Keyword And Return Status
        ...    Element Should Be Visible
        ...    ${${platformName}_${lang}_beneficiary_relationship}
        IF    '${status}' == 'True'
            Wait Until Element Is Visible    ${${platformName}_${lang}_beneficiary_relationship}        timeout=3s
            Click Element    ${${platformName}_${lang}_beneficiary_relationship}
            ${iOS_selectRelationship}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${Change_Beneficiary_Relationship_${counter}}'`][-1]
            ${Android_selectRelationship}    Set Variable
            ...    android=new UiSelector().text("${Change_Beneficiary_Relationship_${counter}}")
            Wait Until Element Is Visible    ${${platformName}_selectRelationship}      timeout=3s
            Click Element    ${${platformName}_selectRelationship}
            Wait Until Element Is Visible    ${${platformName}_${lang}_beneficiary_next_done_btn}   timeout=3s
            Click Element    ${${platformName}_${lang}_beneficiary_next_done_btn}
        END
        #Pree Next button and
        Wait Until Element Is Visible    ${${platformName}_${lang}_beneNextButton}      timeout=2s
        Take Screenshot    Beneficiary Document Details
        Click Element    ${${platformName}_${lang}_beneNextButton}
        Wait Until Element Is Visible    ${${platformName}_${lang}_NewText}         timeout=10s
        #Bene Percentage
        ${allocation_instance}    Evaluate    ${counter}-1
        ${iOS_percTextField}    Set Variable
        ...    xpath=(//XCUIElementTypeOther[contains(@name,'${beneficiaryfname}')])[last()]//following-sibling::XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeTextField
        ${Android_percTextField}    Set Variable
        ...    android=new UiSelector().className("android.widget.EditText").instance(${allocation_instance})
        Clear Text    ${${platformName}_percTextField}
        IF    '${platformName}' == 'iOS'
            Input Text    ${${platformName}_percTextField}    ${Change_Beneficiary_Percentage_${counter}}\n
        ELSE
            Click Element    ${${platformName}_percTextField}
            @{Bene_Allocation_Field}    Split String To Characters    ${Change_Beneficiary_Percentage_${counter}}
            FOR    ${char}    IN    @{Bene_Allocation_Field}
                  Input Text Into Current Element    ${char}
            END
            Close keyboard
            Take Screenshot    Existing Beneficiary After Change
        END
        Close Keyboard
        #Bene Percentage
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_beneficiary_relationship2_edit_dropdown}   timeout=2s
        IF    '${status}' == 'True'
            Wait Until Element Is Visible    ${${platformName}_${lang}_beneficiary_relationship2_edit_dropdown}
            Click Element    ${${platformName}_${lang}_beneficiary_relationship2_edit_dropdown}
            ${iOS_selectRelationship}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${Change_Beneficiary_Relationship_${counter}}'`][-1]
            ${Android_selectRelationship}    Set Variable
            ...    android=new UiSelector().text("${Change_Beneficiary_Relationship_${counter}}")
            Wait Until Element Is Visible    ${${platformName}_selectRelationship}      timeout=2s
            Click Element    ${${platformName}_selectRelationship}
            Wait Until Element Is Visible    ${${platformName}_${lang}_beneficiary_next_done_btn}       timeout=2s
            Click Element    ${${platformName}_${lang}_beneficiary_next_done_btn}
            Click Element    ${${platformName}_${lang}_beneficiary_total}
            Take Screenshot    Beneficiary Relationship
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Add new beneficiary
    END

Capture Beneficiary Transaction Details for Android
    [Arguments]    ${Transaction_Info}
    Take Screenshot    Transaction Page
    RefreshPage
    ${Android_selectCurrentTransaction1}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of beneficiary(s) details'])[1]
    Scroll Till Transaction Is Visible  ${${platformName}_selectCurrentTransaction1}
    Wait Until Page Contains Element    ${${platformName}_selectCurrentTransaction1}    timeout=50s
    Click Element    ${${platformName}_selectCurrentTransaction1}

    Wait Until Element Is Visible    ${${platformName}_${lang}_Product_Name}        timeout=30s
    Take Screenshot    Transaction Details
    ${Product_name}    Get Text    ${${platformName}_${lang}_Product_Name}
    ${Policy_Number}    Get Text    ${${platformName}_${lang}_Policy_No}
    ${VP_Transaction_Status}    Get Text    ${${platformName}_${lang}_Policy_Status}
    ${mTransactionstatus}    Convert To Title Case    ${VP_Transaction_Status}
    ${mTransactionstatus}    Strip String    ${mTransactionstatus}
    IF    '${mTransactionstatus}' == 'Completed'
                ${mTransactionstatus}    Set Variable    Approve
                ${OPUSTransactionstatus}        Set Variable    Completed
                Set Global Variable    ${OPUSTransactionstatus}
    ELSE
                ${OPUSTransactionstatus}        Set Variable    In progress
                Set Global Variable    ${OPUSTransactionstatus}
    END
    ${Total_beneCountelements}      Get Webelements    ${${platformName}_${lang}_totalBenecountinTransaction}
    ${Total_beneCount}      Get Length    ${Total_beneCountelements}
    ${Total_beneCount}      Evaluate    ${Total_beneCount}/2
    ${namecounter}      Set Variable    1
    ${benenamecounter}      Set Variable    1
    ${new_beneficiary_count}    Set Variable    1
    ${update_beneficiary_count}     Set Variable    1
    FOR    ${counter}    IN RANGE    1    ${Total_beneCount}+1
        ${status}   Run Keyword And Return Status    Wait Until Page Contains Element    xpath=//android.widget.TextView[@text='New beneficiary(s) details']   timeout=1s
        IF    '${status}' == 'True'
            ${Beneficiary_Name}      Get Text    xpath=//android.widget.TextView[@text='New beneficiary(s) details']/following-sibling::android.widget.TextView[1]
            @{Name_Part}    Split String    ${Beneficiary_Name}
            ${Beneficiary_First_Name}       Get From List    ${Name_Part}    0
            ${Beneficiary_Last_Name}       Get From List    ${Name_Part}    -1
            ${Beneficiary_Details}    Get Text    xpath=//android.widget.TextView[@text='New beneficiary(s) details']/following-sibling::android.widget.TextView[2]
            @{Bene_Part}     Split String       ${Beneficiary_Details}
            ${Beneficiary_Relationship}    Get From List    ${Bene_Part}    0
            ${Beneficiary_Allocation}    Get From List    ${Bene_Part}    2
            ${existingbenename}     Catenate    ${Beneficiary_First_Name} ${Beneficiary_Last_Name}
            ${Existing_Bene}   Run Keyword And Return Status    List Should Contain Value    ${Existing_bene_dict}    ${existingbenename}
            IF    '${Existing_Bene}' == 'False'
                IF   '${Transaction_Info}' == 'Pre'
                    Set Calc VP Expected Result With Original And Source    ${Beneficiary_First_Name}_${Beneficiary_Last_Name}_Relationship    ${Beneficiary_Relationship}    ${Beneficiary_Relationship}    OMNE_View_Transaction
                    Set Calc VP Expected Result With Original And Source    ${Beneficiary_First_Name}_${Beneficiary_Last_Name}_Allocation    ${Beneficiary_Allocation}    ${Beneficiary_Allocation}    OMNE_View_Transaction
                ELSE IF   '${Transaction_Info}' == 'Post'
                    Set Calc VP Actual Result With Original And Source    Post_${Beneficiary_First_Name}_${Beneficiary_Last_Name}_Relationship    ${Beneficiary_Relationship}    ${Beneficiary_Relationship}    OMNE_View_Transaction
                    Set Calc VP Actual Result With Original And Source    Post_${Beneficiary_First_Name}_${Beneficiary_Last_Name}_Allocation    ${Beneficiary_Allocation}    ${Beneficiary_Allocation}    OMNE_View_Transaction
                END
                ${new_beneficiary_count}    Evaluate    ${new_beneficiary_count}+1
            ELSE
                IF   '${Transaction_Info}' == 'Pre'
                    Set Calc VP Expected Result With Original And Source    ${Beneficiary_First_Name}_${Beneficiary_Last_Name}_Relationship    ${Beneficiary_Relationship}    ${Beneficiary_Relationship}    OMNE_View_Transaction
                    Set Calc VP Expected Result With Original And Source    ${Beneficiary_First_Name}_${Beneficiary_Last_Name}_Allocation    ${Beneficiary_Allocation}    ${Beneficiary_Allocation}    OMNE_View_Transaction
                ELSE IF     '${Transaction_Info}' == 'Post'
                    Set Calc VP Actual Result With Original And Source    Post_${Beneficiary_First_Name}_${Beneficiary_Last_Name}_Relationship    ${Beneficiary_Relationship}    ${Beneficiary_Relationship}    OMNE_View_Transaction
                    Set Calc VP Actual Result With Original And Source    Post_${Beneficiary_First_Name}_${Beneficiary_Last_Name}_Allocation    ${Beneficiary_Allocation}    ${Beneficiary_Allocation}    OMNE_View_Transaction
                END
                ${update_beneficiary_count}     Evaluate    ${update_beneficiary_count}+1
            END
            ${benenamecounter}      Evaluate        ${counter}+${namecounter}+1
        END
    END
    IF    '${Transaction_Info}' == 'Pre'
        Set Calc VP Expected Result With Original And Source
        ...    Product Name
        ...    ${Product_name}
        ...    ${Product_name}
        ...    OMNE_View_Transaction
        Set Calc VP Expected Result With Original And Source
        ...    Policy Number
        ...    ${Policy_Number}
        ...    ${Policy_Number}
        ...    OMNE_View_Transaction
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status
        ...    ${mTransactionstatus.strip()}
        ...    ${mTransactionstatus.strip()}
        ...    OMNE_Application
    ELSE IF    '${Transaction_Info}' == 'Post'
        Set Calc VP Actual Result With Original And Source
        ...    Product Name
        ...    ${Product_name}
        ...    ${Product_name}
        ...    OMNE_View_Transaction
        Set Calc VP Actual Result With Original And Source
        ...    Policy Number
        ...    ${Policy_Number}
        ...    ${Policy_Number}
        ...    OMNE_View_Transaction
     END

Capture Beneficiary Transaction Details for iOS
    [Arguments]    ${Transaction_Info}
    TRY
        ${iOS_selectCurrentTransaction}    Set Variable
         ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of beneficiary(s) details' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        Take Screenshot    Transaction Page details
        Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction}    timeout=190s
        Scroll Till Transaction Is Visible    ${${platformName}_selectCurrentTransaction}
        ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction}
        IF    '${Edit_Beneficiary_1}' == 'Add'
            @{transactionstatusdetail}    Split String    ${transactionstatus}    Policy no
            ${policyno}    Get From List    ${transactionstatusdetail}    1
            ${policyno}    Remove String    ${policyno}    :
            ${NewBeneDetails}     Split String    ${policyno}     New beneficiary(s) details
            ${policyno}     Get From List    ${NewBeneDetails}       0
            IF    '${Transaction_Info}' == 'Post'
                ${policyno}    Split String    ${policyno}    Policy applied
                ${policyno}    Get From List    ${policyno}    0
            END
            ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
            @{transactionstatusdetail}    Split String    ${transactionstatus}    Change of beneficiary(s) details
            ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
            ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
            ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
            IF    '${mTransactionstatus}' == 'Completed'
                ${mTransactionstatus}    Set Variable    Approve
                ${OPUSTransactionstatus}        Set Variable    Completed
                Set Global Variable    ${OPUSTransactionstatus}
            ELSE
                ${OPUSTransactionstatus}        Set Variable    In progress
                Set Global Variable    ${OPUSTransactionstatus}
            END
            Click Element    ${${platformName}_selectCurrentTransaction}
            Wait Until Element Is Visible    ${${platformName}_${lang}_NewBeneficiaryDetails}
            ${VP_transactiondetail}      Get Text    ${${platformName}_${lang}_NewBeneficiaryDetails}
            Take Screenshot    Transaction Page details
            ${Benedetails}     Split String    ${VP_transactiondetail}     New beneficiary(s) details
            ${VP_transactiondetail}    Get From List    ${Benedetails}       1
            ${VP_transactiondetailsplit}    Split String    ${VP_transactiondetail}    Policy applied
            # policy applied
            ${VP_policyapplied}    Get From List    ${VP_transactiondetailsplit}    1
            IF    '${Transaction_Info}' == 'Post'
                ${VP_policyapplied}    Split String    ${VP_policyapplied}    Completion date
                ${VP_policyapplied}    Get From List    ${VP_policyapplied}    0
                ${VP_policyapplied}    Strip String    ${VP_policyapplied}
            END
            ${beneficiarydetail}    Get From List    ${VP_transactiondetailsplit}    0
            ${VP_beneficiarydetail}    Strip String    ${beneficiarydetail}
            ${new_beneficiary_count}    Set Variable    1
            ${VP_beneficiarydetail}         Remove String    ${VP_beneficiarydetail}    |
            @{specific_beneData}    Split String    ${VP_beneficiarydetail}
            @{beneData}    Split String    ${VP_beneficiarydetail}      %
            ${getbenelength}    Get Length    ${beneData}
            Log To Console    ${getbenelength}
            FOR    ${counter}    IN RANGE    1    ${getbenelength}
                ${Beneficiary_Allocation}    Get From List    ${specific_beneData}    3
                ${Beneficiary_Allocation}   Remove String   ${Beneficiary_Allocation}   %
                Log To Console    Percentage${counter} : ${Beneficiary_Allocation}
                ${Beneficiary_Relationship}    Get From List    ${specific_beneData}    2
                Log To Console    Relationship${counter} : ${Beneficiary_Relationship}
                ${Beneficiary_First_Name}    Get From List    ${specific_beneData}    0
                Log To Console    fname${counter} : ${Beneficiary_First_Name}
                ${Beneficiary_Last_Name}    Get From List    ${specific_beneData}    1
                Log To Console    lname${counter} : ${Beneficiary_Last_Name}
                 ${existingbenename}     Catenate    ${Beneficiary_First_Name} ${Beneficiary_Last_Name}
                ${status}   Run Keyword And Return Status    List Should Contain Value    ${Existing_bene_dict}    ${existingbenename}
                IF    '${Transaction_Info}' == 'Pre'
                    Set Calc VP Expected Result With Original And Source
                    ...    ${Beneficiary_First_Name}_${Beneficiary_Last_Name}_Relationship
                    ...    ${Beneficiary_Relationship}
                    ...    ${Beneficiary_Relationship}
                    ...    OMNE_View_Transaction
                    Set Calc VP Expected Result With Original And Source
                    ...    ${Beneficiary_First_Name}_${Beneficiary_Last_Name}_Allocation
                    ...    ${Beneficiary_Allocation}%
                    ...    ${Beneficiary_Allocation}%
                    ...    OMNE_View_Transaction
                ELSE IF    '${Transaction_Info}' == 'Post'
                    ${counterAdd}    Set Variable    1
                    Set Calc VP Actual Result With Original And Source
                    ...    Post_${Beneficiary_First_Name}_${Beneficiary_Last_Name}_Relationship
                    ...    ${Beneficiary_Relationship}
                    ...    ${Beneficiary_Relationship}
                    ...    OMNE_View_Transaction
                    Set Calc VP Actual Result With Original And Source
                    ...    Post_${Beneficiary_First_Name}_${Beneficiary_Last_Name}_Allocation
                    ...    ${Beneficiary_Allocation}%
                    ...    ${Beneficiary_Allocation}%
                    ...    OMNE_View_Transaction
                    ${counterAdd}    Set Variable    ${counterAdd}+1
                END
                ${mgetbenelength}=        Evaluate    ${getbenelength} - 1
                Log To Console    ${mgetbenelength}
                IF    '${counter}' != '${mgetbenelength}'

                    Remove From List    ${specific_beneData}     0
                    Remove From List    ${specific_beneData}     0
                    Remove From List    ${specific_beneData}     0
                    Remove From List    ${specific_beneData}     0
                END

            END
            IF    '${Transaction_Info}' == 'Pre'
                Set Calc VP Expected Result With Original And Source
                ...    Transaction_Status
                ...    ${mTransactionstatus.strip()}
                ...    ${mTransactionstatus.strip()}
                ...    Omne_TransactionPage
                Set Calc VP Expected Result With Original And Source
                ...    Policy Number
                ...    ${policyno.strip()}
                ...    ${policyno.strip()}
                ...    Omne_TransactionPage
            ELSE IF    '${Transaction_Info}' == 'Post'
                Set Calc VP Actual Result With Original And Source
                ...    Policy Number
                ...    ${policyno.strip()}
                ...    ${policyno.strip()}
                ...    Omne_TransactionPage
            END
        ELSE
            Click Element    ${${platformName}_selectCurrentTransaction}
            Wait Until Element Is Visible    ${${platformName}_${lang}_NewBeneficiaryDetails}
            ${VP_transactiondetailOmne}      Get Text    ${${platformName}_${lang}_NewBeneficiaryDetails}
            Take Screenshot    Transaction Page details
            @{transactionstatusdetail}    Split String    ${VP_transactiondetailOmne}    Policy no
            ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
            @{transactionstatus}     Split String     ${transactionstatus}          beneficiary(s) details
            ${transactionstatus}    Get From List    ${transactionstatus}    1
            ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
            ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
            IF    '${mTransactionstatus}' == 'Completed'
                ${mTransactionstatus}    Set Variable    Approve
                ${OPUSTransactionstatus}        Set Variable    Completed
                Set Global Variable    ${OPUSTransactionstatus}
            ELSE
                ${OPUSTransactionstatus}        Set Variable    In progress
                Set Global Variable    ${OPUSTransactionstatus}
            END
            ${policyno}    Get From List    ${transactionstatusdetail}    1
            ${policyno}    Remove String    ${policyno}    :
            ${NewBeneDetails}     Split String    ${policyno}     New beneficiary(s) details
            ${policyno}     Get From List    ${NewBeneDetails}       0
            ${BenDetails1}     Get From List    ${NewBeneDetails}       1
            ${benDetails2}    Replace String    ${BenDetails1}    |    ${EMPTY}
            @{bendetails3}    Split String    ${benDetails2}    Policy applied
            ${bendetails4}    Get From List    ${bendetails3}    0
            @{bendetails5}    Split String    ${bendetails4}    %
            ${getbenelength}    Get Length    ${bendetails5}
            Log To Console    ${getbenelength}
            FOR    ${counter}    IN RANGE    1    ${getbenelength}
    #          ${BeneDetail}    Get From List    ${bendetails5}    ${counter}
                ${result} =    Run Keyword And Return Status    Should Contain    ${bendetails4}     ${Existing_Beneficiary_Name_${counter}}
                IF    '${result}' == 'True'
                    ${VP_Beneficiary_Name}    Set Variable    ${Existing_Beneficiary_Name_${counter}}
                    ${mVP_Beneficiary_Name}         Remove String    ${VP_Beneficiary_Name}     ${SPACE}
                END
                ${result} =    Run Keyword And Return Status    Should Contain    ${bendetails4}     ${Change_Beneficiary_Relationship_${counter}}
                IF    '${result}' == 'True'
                    ${VP_Beneficiary_relationship}    Set Variable    ${Change_Beneficiary_Relationship_${counter}}
                END
                ${result} =    Run Keyword And Return Status    Should Contain    ${bendetails4}     ${Change_Beneficiary_Percentage_${counter}}
                IF    '${result}' == 'True'
                    ${VP_Beneficiary_allocation}    Set Variable    ${Change_Beneficiary_Percentage_${counter}}
                END
                Set Calc VP Expected Result With Original And Source
                ...    ${mVP_Beneficiary_Name.strip()}_Relationship
                ...    ${VP_Beneficiary_relationship}
                ...    ${VP_Beneficiary_relationship}
                 ...    OMNE_View_Transaction
                Set Calc VP Expected Result With Original And Source
                ...    ${mVP_Beneficiary_Name.strip()}_Allocation
                ...    ${VP_Beneficiary_allocation}%
                ...    ${VP_Beneficiary_allocation}%
                ...    OMNE_View_Transaction
            END
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Beneficiary Transaction Details for iOS ${Insurance_Flow}
    END

