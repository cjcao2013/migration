*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     String
Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/ChangeMobileAndEmailPageObject.Resource
Resource    ../Common/AddOTP.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/PersonalDetailsPageObject.resource
Library      .../../../../DBQuery/PersonalDetailsDB.py


*** Keywords ***
Name Change
    TRY
        ${iOS_Title}    Set Variable    xpath=//XCUIElementTypeOther[@name="salutation-list-item" and @label="${PersonalDetails_Title}."]

        ${iOS_MaritalStatus}    Set Variable        xpath=//XCUIElementTypeOther[@name="maritalStatus-list-item" and @label="${PersonalDetails_MaritalStatus}"]

        ${Android_Title}    Set Variable    android=new UiSelector().textContains("${PersonalDetails_Title}")
        ${Android_MaritalStatus}    Set Variable
        ...    android=new UiSelector().textContains("${PersonalDetails_MaritalStatus}")
        Wait Until Page Contains Element    ${${platformName}_${lang}_txtTitle}    timeout=10s
        # Capture ALl Detaila
        ${Title}    Get Text    ${${platformName}_${lang}_txtTitle}
        ${Title}    Remove String    ${Title}    Title
        ${Title}    Remove String    ${Title}    .
        ${Current_FirstName}    Get Text    ${${platformName}_${lang}_txtFirstName}
        ${Current_MiddleName}    Get Text    ${${platformName}_${lang}_txtMiddleName}
        ${Current_LastName}    Get Text    ${${platformName}_${lang}_txtLastName}
        ${Current_MaritalStatus}    Get Text    ${${platformName}_${lang}_Marital_Status}
        ${Current_MaritalStatus}    Remove String    ${Current_MaritalStatus}    Marital status (Optional)
        ${fname}    FakerLibrary.First_Name
        ${mname}    FakerLibrary.First_Name
        ${lname}    FakerLibrary.Last_Name
        Take Screenshot    Personal_Details_Page
        # Clear Old Details
        Clear Text    ${${platformName}_${lang}_txtFirstName}

        ${Status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_Error_Messgage_FirstName}
        ...    timeout=5s
        IF    '${Status}' == 'True'
            ${msg}    Get Text    ${${platformName}_${lang}_Error_Messgage_FirstName}
    #    attribute=value
            ${errormsg}    Set Variable    ${msg}
            Take Screenshot    ChangeName_Error
            Set Calc VP With Source And Original Values
            ...    Firstname_ErrorMsg
            ...    ${errormsg}
            ...    ${errormsg}
            ...    Static
            ...    OMNE_Application
            ...    ${errormsg}
            ...    ${errormsg}
        END
        Clear Text    ${${platformName}_${lang}_txtMiddleName}
        Clear Text    ${${platformName}_${lang}_txtLastName}
        ${Status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_Error_Messgage_LasttName}
        ...    timeout=5s
        IF    '${Status}' == 'True'
            ${msg}    Get Text    ${${platformName}_${lang}_Error_Messgage_LasttName}
            #    attribute=value
            ${errormsg}    Set Variable    ${msg}
            Take Screenshot    ChangeName_Error
            Set Calc VP With Source And Original Values
            ...    Lastname_ErrorMsg
            ...    ${errormsg}
            ...    ${errormsg}
            ...    Static
            ...    OMNE_Application
            ...    ${errormsg}
            ...    ${errormsg}
        END
        Close keyboard
        Take Screenshot    Personal_Details_Error_Page
        # Input New ELement
        IF    '${PersonalDetails_Title}' != '${Title}'
            Click Element    ${${platformName}_${lang}_txtTitle}
            Wait Until Element Is Visible     ${${platformName}_Title}          timeout=10s
            Click Element    ${${platformName}_Title}
            
#            Wait Until Element Is Visible    ${${platformName}_${lang}_DoneButton}       timeout=10s
#            Click Element    ${${platformName}_${lang}_DoneButton}

        END
        ${Status}    Run Keyword And Return Status      Wait Until Element Is Visible    ${${platformName}_${lang}_DoneButton}       timeout=10s
        IF    '${Status}' == 'True'
        Click Element    ${${platformName}_${lang}_DoneButton}
        END
        ${new_title_namepage}    Get Text    ${${platformName}_${lang}_txtTitle}
        ${new_title_namepage}    Remove String    ${new_title_namepage}    Title
        ${new_title_namepage}    Remove String    ${new_title_namepage}    .
        Set Global Variable     ${new_title_namepage}
        Wait Until Element Is Visible   ${${platformName}_${lang}_txtFirstName}     timeout=5s
        Click Element    ${${platformName}_${lang}_txtFirstName}
        Input Text    ${${platformName}_${lang}_txtFirstName}    ${fname}
        ${Status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_Error_Messgage_FirstName}
        ...    timeout=5s
        IF    '${Status}' == 'True'
            ${msg}    Get Text    ${${platformName}_${lang}_Error_Messgage_FirstName}
        #    attribute=value
            ${errormsg}    Set Variable    ${msg}
            Set Calc VP With Source And Original Values
            ...    ErrorMsg
            ...    ${errormsg}
            ...    ${errormsg}
            ...    Static
            ...    OMNE_Application
            ...    ${errormsg}
            ...    ${errormsg}
            Set Global Variable    Change Name :${errormsg}
        END
        Close keyboard
        Input Text    ${${platformName}_${lang}_txtMiddleName}    ${mname}
        Close keyboard
        Input Text    ${${platformName}_${lang}_txtLastName}    ${lname}
        Close keyboard
        ${Status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_Error_Messgage_LasttName}
        ...    timeout=5s
        IF    '${Status}' == 'True'
            ${msg}    Get Text    ${${platformName}_${lang}_Error_Messgage_LasttName}
            #    attribute=value
            ${errormsg}    Set Variable    ${msg}
            Set Calc VP With Source And Original Values
            ...    ErrorMsg
            ...    ${errormsg}
            ...    ${errormsg}
            ...    Static
            ...    OMNE_Application
            ...    ${errormsg}
            ...    ${errormsg}
            Set Global Variable    Change Name :${errormsg}
        END
        Set Global Variable    ${Title}
        Set Global Variable    ${fname}
        Set Global Variable    ${mname}
        Set Global Variable    ${lname}
        IF    '${PersonalDetails_MaritalStatus}' != '${Current_MaritalStatus}'
            Wait Until Page Contains Element    ${${platformName}_${lang}_Marital_Status}        timeout=10s
            Click Element    ${${platformName}_${lang}_Marital_Status}
            Wait Until Page Contains Element    ${${platformName}_MaritalStatus}            timeout=10s
            Click Element    ${${platformName}_MaritalStatus}
        END
        Take Screenshot    Personal_Details_Page
        Click Element    ${${platformName}_${lang}_Submit_btn}
        ${status}    Run Keyword And Return Status
        ...    Element Should Be Disabled
        ...    ${${platformName}_${lang}_Personal_particulars}
        IF    '${status}' == 'True'
            Set Calc VP With Source And Original Values
            ...    Update_Personal_Particulars_text_present
            ...    true
            ...    ${status}
            ...    Static
            ...    OMNE_Application
            ...    True
            ...    ${status}
        END
        Wait Until Page Contains Element    ${${platformName}_${lang}_Personal_particulars}    timeout=20s
        Wait Until Element Is Visible    ${${platformName}_${lang}_AddImage}    timeout=20s
        Click Element    ${${platformName}_${lang}_AddImage}
        ${path}    Set Variable    ${EXECDIR}/CustomLibraries/ClaimImages/Certificate.PNG
        Upload Document BS    ${path}
        Take Screenshot    Update_Name/MaritalStatus

        Click Text    Save    exact_match=true
        # Previous OTP from DB
#        Get Details from DB
#        ${Previous_OTP}    Set Variable    ${OTPNumber}
#        Set Global Variable    ${Previous_OTP}
        Sleep   4s
        Wait Until Page Contains Element    ${${platformName}_${lang}_Submit_btn}    timeout=20s
        Click Element    ${${platformName}_${lang}_Submit_btn}
#        ${status}    Run Keyword And Return Status
#        ...    Wait Until Element Is Visible
#        ...    ${${platformName}_${lang}_Submit_btn}
#        ...    timeout=5s
#        IF    '${status}' == 'True'
#            Click Element    ${${platformName}_${lang}_Submit_btn}
#        END
        Take Screenshot    Update_Name/MaritalStatus
        ${status}    Run Keyword And Return Status    Element Should Be Disabled    ${${platformName}_${lang}_Verify_btn}
        IF    '${status}' == 'True'
            Set Calc VP With Source And Original Values
            ...    Verify_Button_Disable_By_Default
            ...    true
            ...    ${status}
            ...    Static
            ...    OMNE_Application
            ...    True
            ...    ${status}
        END
        Run Keyword    Insert OTP
        ...    ${Transaction_OTP_Source}
        ...    ${Transaction_OTP_Expiry_Flag}
        ...    ${Transaction_OTP_Resend_Flag}
        Run Keyword    Check Transaction Status
        Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=20s
        Click Element    ${${platformName}_${lang}_SeeAll}
        Run Keyword    Capture Change Name Transaction Details for ${platformName}    Pre
        Set Global Variable    ${result}    Personal Details Name/Marital Changed Initiate Successfully
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Personal Details Name/Marital Changed
    END
Capture Change Name Transaction Details for iOS
    [Arguments]    ${Transaction_Info}
    TRY
        IF    '${Transaction_Info}'== 'Pre'
            ${iOS_selectCurrentTransaction1}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of personal details In progress' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        ELSE IF    '${Transaction_Info}'== 'Post'
            ${iOS_selectCurrentTransaction1}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of personal details ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        END

        Wait Until Page Contains Element    ${${platformName}_${lang}_TransactionServiceRequest}    timeout=10s
        Click Element    ${${platformName}_${lang}_TransactionServiceRequest}
    #    Log    ${${platformName}_selectCurrentTransaction1}
        RefreshPage
        Scroll Till Transaction Is Visible    ${${platformName}_selectCurrentTransaction1}
        Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction1}    timeout=300s
        Take Screenshot    Transaction Page
        Click Element    ${${platformName}_selectCurrentTransaction1}
        ${CompleteStatus_List}    Get Text    ${${platformName}_selectCurrentTransaction1}
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
        Log     Transaction_Status=${VP_Transaction_Status}
        Log To Console    ListCount=${Count}
        IF    '${VP_Transaction_Status}' == 'progress'
            ${m_VP_Transaction_Status}    Set Variable    In Progress
            Set Global Variable    ${m_VP_Transaction_Status}
            ${OPUSTransactionstatus}    Set Variable    In progress
            Set Global Variable    ${OPUSTransactionstatus}
            Log     ${OPUSTransactionstatus}
        END
        IF    '${VP_Transaction_Status}' == 'Completed'
            ${m_VP_Transaction_Status}    Set Variable    Approve
            Set Global Variable    ${m_VP_Transaction_Status}
            ${OPUSTransactionstatus}    Set Variable    Completed
            Set Global Variable    ${OPUSTransactionstatus}
        END
        IF    '${VP_Transaction_Status}' == 'Declined'
            ${m_VP_Transaction_Status}    Set Variable    Declined
            Set Global Variable    ${m_VP_Transaction_Status}
        END

        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS "Title"`][27]
        ...    timeout=10s
        IF    '${status}'=='True'
            ${NameDetails}    Get Text    chain=**/XCUIElementTypeOther[`label CONTAINS "Title"`][27]
            @{Details}    Split String    ${NameDetails}    Title
            ${NameDetails}    Get From List    ${Details}    1
            @{NameDetails}    Split String    ${NameDetails}    New
            ${title}    Get From List    ${NameDetails}    0
            #    ${title}    Remove String    ${title}    Title
            ${title}    Remove String    ${title}    .
            Log To Console    Title:-${title}
            ${FirstNameList}    Get From List    ${NameDetails}    1
            ${VP_FirstName}    Remove String    ${FirstNameList}    First name
            Log To Console    FirstName=${VP_FirstName}
            ${LastNameList}    Get From List    ${NameDetails}    2

            ${LastNameList}    Get From List    ${NameDetails}    2
            ${VP_MiddleName}    Remove String    ${LastNameList}    Middle name
            Log To Console    MiddleName=${VP_MiddleName}
            ${LastNameList}    Get From List    ${NameDetails}    3
            ${VP_LastName}    Remove String    ${LastNameList}    Last name
            Log To Console    LastName=${VP_LastName}
            ${MartialStatusList}    Get From List    ${NameDetails}    4
            ${VP_MartialStatus}    Remove String    ${MartialStatusList}    Marital status
            Log To Console    LastName=${VP_MartialStatus}
            Set Calc VP With Source And Original Values
            ...    Transaction_NEW_Title
            ...    ${Title.strip()}
            ...    ${title.strip()}
            ...    OMNE_NameChangePage
            ...    OMNE_Transaction_Page
            ...    ${Title.strip()}
            ...    ${title.strip()}
            Set Calc VP Expected Result With Original And Source
            ...    NEW_Title
            ...    ${title.strip()}
            ...    ${title}
            ...    OMNE_Transaction_Page
            Set Calc VP Expected Result With Original And Source
            ...    NEW_Title_DB
            ...    ${title.strip()}
            ...    ${title}
            ...    OMNE_NameChangePage
        ELSE
            ${NameDetails}    Get Text    chain=**/XCUIElementTypeOther[`label CONTAINS "First name"`][27]
            @{NameDetails}    Split String    ${NameDetails}    ${Policy_No}
            ${NameDetails}    Get From List    ${NameDetails}    1
            ${NameDetails}    Split String    ${NameDetails}    New
            ${FirstNameList}    Get From List    ${NameDetails}    1
            ${VP_FirstName}    Remove String    ${FirstNameList}    First name
            Log To Console    FirstName=${VP_FirstName}
            ${LastNameList}    Get From List    ${NameDetails}    2
            ${VP_MiddleName}    Remove String    ${LastNameList}    Middle name
            Log To Console    MiddleName=${VP_MiddleName}
            ${LastNameList}    Get From List    ${NameDetails}    3
            ${VP_LastName}    Remove String    ${LastNameList}    Last name
            Log To Console    LastName=${VP_LastName}
            ${MartialStatusList}    Get From List    ${NameDetails}    4
            ${VP_MartialStatus}    Remove String    ${MartialStatusList}    Marital status
            Log To Console    LastName=${VP_MartialStatus}
        END
        IF    '${Transaction_Info}'== 'Pre'
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
                ...    ${m_VP_Transaction_Status.strip()}
                ...    ${m_VP_Transaction_Status}
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

                Set Calc VP Expected Result With Original And Source
                ...    NEW_FirstName_DB
                ...    ${VP_FirstName.strip()}
                ...    ${VP_FirstName}
                ...    OMNE_NameChangePage

                Set Calc VP Expected Result With Original And Source
                ...    NEW_MiddleName_DB
                ...    ${VP_MiddleName.strip()}
                ...    ${VP_MiddleName.strip()}
                ...    OMNE_NameChangePage

                Set Calc VP Expected Result With Original And Source
                ...    NEW_LastName_DB
                ...    ${VP_LastName.strip()}
                ...    ${VP_LastName}
                ...    OMNE_NameChangePage

                IF    '${VP_MartialStatus}' != ''
                    Set Calc VP Expected Result With Original And Source
                    ...    NEW_MaritalStatus
                    ...    ${VP_MartialStatus.strip()}
                    ...    ${VP_MartialStatus}
                    ...    OMNE_Transaction_Page
                     Set Calc VP Expected Result With Original And Source
                    ...   NEW_MaritalStatus_DB
                    ...   ${PersonalDetails_MaritalStatus}
                    ...   ${PersonalDetails_MaritalStatus}
                    ...   OMNE_NameChangePage
                END

        ELSE IF    '${Transaction_Info}'== 'Post'
                IF    '${VP_MartialStatus}' != ''

                    Set Calc VP Actual Result With Original And Source
                    ...    Post_OWB_NEW_MaritalStatus
                    ...    ${VP_MartialStatus.strip()}
                    ...    ${VP_MartialStatus}
                    ...    OMNE_Transaction_Page
                END

                Set Calc VP Expected Result With Original And Source
                ...    Transaction_Status_OPUS
                ...    ${m_VP_Transaction_Status.strip()}
                ...    ${m_VP_Transaction_Status}
                ...    OMNE_Transaction_Page



                Set Calc VP Actual Result With Original And Source
                ...    Post_OWB_NEW_Title
                ...    ${title.strip()}
                ...    ${title}
                ...    OMNE_Transaction_Page
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
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END

Capture Change Name Transaction Details for Android
    [Arguments]    ${Transaction_Info}
    Wait Until Page Contains Element
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of personal details'])[1]
    ...    timeout=40s
    Click Element
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of personal details'])[1]
    Take Screenshot    Transaction_Page
    Sleep    5s
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_TransactionTitle}
    ...    timeout=10s
    IF    '${status}'=='True'
        ${VP_Title}    Get Text    ${${platformName}_${lang}_TransactionTitle}
        Set Calc VP With Source And Original Values
        ...    Transaction_NEW_Title
        ...    ${new_title_namepage.strip()}
        ...    ${VP_Title.strip()}
        ...    OMNE_NameChangePage
        ...    OMNE_Transaction_Page
        ...    ${new_title_namepage.strip()}
        ...    ${VP_Title.strip()}
        Set Calc VP Expected Result With Original And Source
        ...    NEW_Title
        ...    ${VP_Title.strip()}
        ...    ${VP_Title.strip()}
        ...    OMNE_Transaction_Page
        Set Calc VP Expected Result With Original And Source
        ...    NEW_Title_DB
        ...    ${VP_Title.strip()}
        ...    ${VP_Title.strip()}
        ...    OMNE_NameChangePage
        Set Calc VP Actual Result With Original And Source
        ...    Post_OWB_NEW_Title
        ...    ${VP_Title.strip()}
        ...    ${VP_Title.strip()}
        ...    OMNE_Transaction_Page
    END
    ${VP_FirstName}    Get Text    ${${platformName}_${lang}_TransactionFirstName}
    ${VP_MiddleName}    Get Text    ${${platformName}_${lang}_TransactionMiddleName}
    ${VP_LastName}    Get Text    ${${platformName}_${lang}_TransactionLastName}
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_${lang}_TransactionMarital}
    ...    timeout=10s
    IF    '${status}' == 'True'
        ${VP_MaritalStatus}    Get Text    ${${platformName}_${lang}_TransactionMarital}
        IF    '${VP_MaritalStatus}' != ''
            Set Calc VP Expected Result With Original And Source
            ...    NEW_MaritalStatus
            ...    ${VP_MaritalStatus}
            ...    ${VP_MaritalStatus}
            ...    OMNE_Transaction_Page
        END
         Set Calc VP Expected Result With Original And Source
        ...    NEW_MaritalStatus_DB
        ...    ${PersonalDetails_MaritalStatus}
        ...    ${PersonalDetails_MaritalStatus}
        ...    OMNE_NameChangePage
         Set Calc VP Actual Result With Original And Source
        ...    Post_OWB_NEW_MaritalStatus
        ...    ${VP_MaritalStatus.strip()}
        ...    ${VP_MaritalStatus}
        ...    OMNE_Transaction_Page
    END

#    ${VP_Completion_Date}    Get Text    ${EN_Completion_Date}
    ${requeststatus}    Get Text    ${${platformName}_${lang}_TransactionStatus}
    IF    '${requeststatus}' == 'Completed'
        ${m_requeststatus}    Set Variable    Approve
        Set Global Variable    ${m_requeststatus}
    END
    IF    '${requeststatus}' == 'In progress'
        ${m_requeststatus}    Set Variable    In Progress
        Set Global Variable    ${m_requeststatus}
        ${OPUSTransactionstatus}    Set Variable    In progress
        Set Global Variable    ${OPUSTransactionstatus}
        Log     ${OPUSTransactionstatus}
    END
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
    ...    ${m_requeststatus.strip()}
    ...    ${requeststatus}
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


    Set Calc VP Expected Result With Original And Source
    ...    NEW_FirstName_DB
    ...    ${VP_FirstName.strip()}
    ...    ${VP_FirstName}
    ...    OMNE_NameChangePage
    Set Calc VP Expected Result With Original And Source
    ...    NEW_MiddleName_DB
    ...    ${VP_MiddleName.strip()}
    ...    ${VP_MiddleName.strip()}
    ...    OMNE_NameChangePage
    Set Calc VP Expected Result With Original And Source
    ...    NEW_LastName_DB
    ...    ${VP_LastName.strip()}
    ...    ${VP_LastName}
    ...    OMNE_NameChangePage


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
