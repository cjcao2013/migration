*** Settings ***
Library     SeleniumLibrary
Resource    ../../PageObjects/OWB/LoginPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    ../../PageObjects/OWB/OWBPersonalDetailsPageObject.resource


*** Keywords ***
OWB Personal details
    IF    '${PersonalDetails_WhatChange}' == 'Email'       Change Email VP
    IF    '${PersonalDetails_WhatChange}' == 'MobileNo'    Change Mobile VP
    IF    '${PersonalDetails_WhatChange}' == 'Mailing address'     Change Address VP
    IF    '${PersonalDetails_WhatChange}' == 'Name'        Change Name VP

Change Email VP
    Sleep    1s
    Wait Until Page Contains Element    ${EN_VP_old_Email_id}    timeout=30s
    Scroll Element Into View    ${EN_VP_old_Email_id}
    ${VP_old_Email_id}    Get Element Attribute    ${EN_VP_old_Email_id}    attribute=title
    ${VP_New_Email_id}    Get Element Attribute    ${EN_VP_New_Email_id}    attribute=title
    Set Calc VP Actual Result With Original And Source
    ...    OLD_Email_id_OWB
    ...    ${VP_old_Email_id}
    ...    ${VP_old_Email_id}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    NEW_Email_id_OWB
    ...    ${VP_New_Email_id}
    ...    ${VP_New_Email_id}
    ...    OWB Application

Change Mobile VP
    Wait Until Page Contains Element    ${EN_VP_old_MobileNo}    timeout=30s
    Scroll Element Into View    ${EN_VP_old_MobileNo}
    ${VP_old_MobileNo}    Get Element Attribute    ${EN_VP_old_MobileNo}    attribute=title
    ${VP_New_MobileNo}    Get Element Attribute    ${EN_VP_New_MobileNo}    attribute=title
    Set Calc VP Actual Result With Original And Source
    ...    OLD_MobileNo_OWB
    ...    ${VP_old_MobileNo}
    ...    ${VP_old_MobileNo}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    NEW_MobileNo_OWB
    ...    ${VP_New_MobileNo}
    ...    ${VP_New_MobileNo}
    ...    OWB Application

Change Address VP
    Wait Until Element Is Visible    ${EN_Curr_Add}    timeout=5s
    ${Add}    Get Element Attribute    ${EN_Curr_Add}    attribute=title

    Take Screenshot    ChangeAddressPage
    Execute JavaScript
    ...    window.document.evaluate("//span[text()='Zipcode']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView(true);
    Sleep    2s
    ${VP_Country_Code}    Get Element Attribute    ${EN_OWB_Country}    attribute=title
    ${VP_Address_Line1}    Get Element Attribute    ${EN_Address_Line1_OWB}    attribute=title
    ${VP_Address_Line2}    Get Element Attribute    ${EN_Address_Line2_OWB}    attribute=title
    ${VP_City}    Get Element Attribute    ${EN_City_OWB}    attribute=title
    ${VP_ZipCode}    Get Element Attribute    ${EN_ZipCode_OWB}    attribute=title
    ${VP_State}    Get Element Attribute    ${EN_State_OWB}    attribute=title
    ${VP_District}    Get Element Attribute    ${EN_District_OWB}    attribute=title
    ${VP_Policy_No}    Get Element Attribute    ${EN_Policy_No_txt}    attribute=title
    ${VP_Policy_Name}    Get Element Attribute    ${EN_Policy_Name_txt}    attribute=title
    ${VP_Completion_Date}    Get Element Attribute    ${EN_Comp_Date}    attribute=title
    IF    '${VP_Country_Code}' == 'THA'
        ${VP_Country}    Set Variable    Thailand
        Set Global Variable    ${VP_Country}
    END
    Take Screenshot    ChangeAddressPage
    @{CurrAdd}    Split String    ${Add}    ,
    ${CurrAddLine1}    Get From List    ${CurrAdd}    0
    ${CurrAddLine1}    Strip String    ${CurrAddLine1}
    ${CurrAddLine2}    Get From List    ${CurrAdd}    1
    ${CurrAddLine2}    Strip String    ${CurrAddLine2}
    ${CurrAddState}    Get From List    ${CurrAdd}    4
    ${CurrAddState}    Strip String    ${CurrAddState}
    ${CurrAddDistrict}    Get From List    ${CurrAdd}    3
    ${CurrAddDistrict}    Strip String    ${CurrAddDistrict}
    ${CurrAddCity}    Get From List    ${CurrAdd}    2
    ${CurrAddCity}    Strip String    ${CurrAddCity}
    Set Calc VP Actual Result With Original And Source
    ...    Current_Address_Line1
    ...    ${CurrAddLine1}
    ...    ${CurrAddLine1}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Current_Address_Line2
    ...    ${CurrAddLine2}
    ...    ${CurrAddLine2}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Current_Address_State
    ...    ${CurrAddState}
    ...    ${CurrAddState}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Current_Address_District
    ...    ${CurrAddDistrict}
    ...    ${CurrAddDistrict}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Current_Address_City
    ...    ${CurrAddCity}
    ...    ${CurrAddCity}
    ...    OWB Application


    ${VP_New_Address}    Set Variable
    ...    ${VP_Address_Line1}, ${VP_Address_Line2}, ${VP_District}, ${VP_City}, ${VP_State}, ${VP_ZipCode}, ${VP_Country}
    Set Calc VP Actual Result With Original And Source
    ...    Policy_No
    ...    ${VP_Policy_No}
    ...    ${VP_Policy_No}
    ...    OWB Application
#    Set Calc VP Actual Result With Original And Source    Policy_Name    ${VP_Policy_Name}    ${VP_Policy_Name}    OWB Application
#    Set Calc VP Actual Result With Original And Source    Current Address    ${VP_Current_Address}    ${VP_Current_Address}    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    New Address
    ...    ${VP_New_Address}
    ...    ${VP_New_Address}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    Completion Date
    ...    ${VP_Completion_Date}
    ...    ${VP_Completion_Date}
    ...    OWB Application

Change Name VP
    Sleep    2s
    ${VP_old_Title}    Get Element Attribute    ${EN_VP_old_Title}    attribute=title
    ${VP_old_Title}     Remove String    ${VP_old_Title}    .
    ${VP_old_FirstName}    Get Element Attribute    ${EN_VP_old_FirstName}    attribute=title
    ${VP_old_MiddleName}    Get Element Attribute    ${EN_VP_old_MiddleName}    attribute=title
    ${VP_old_LastName}    Get Element Attribute    ${EN_VP_old_LastName}    attribute=title
    ${VP_new_Title}    Get Element Attribute    ${EN_VP_new_Title}    attribute=title
    ${VP_new_Title}     Remove String    ${VP_new_Title}    .
    ${VP_new_FirstName}    Get Element Attribute    ${EN_VP_new_FirstName}    attribute=title
    ${VP_new_MiddleName}    Get Element Attribute    ${EN_VP_new_MiddleName}    attribute=title
    ${VP_new_LastName}    Get Element Attribute    ${EN_VP_new_LastName}    attribute=title
    ${VP_new_MaritalStatus}    Get Element Attribute    ${EN_VP_new_MaritalStatus}    attribute=title
#    ${VP_Completion_Date}    Get Element Attribute    ${EN_Completion_Date}    attribute=title
    ${VP_Policy_No}    Get Element Attribute    ${EN_Policy_No_txt}    attribute=title
    ${VP_Policy_Name}    Get Element Attribute    ${EN_Policy_Name_txt}    attribute=title
#    Set Calc VP Actual Result With Original And Source    Policy_No    ${VP_Policy_No}    ${VP_Policy_No}    OWB Application
#    Set Calc VP Actual Result With Original And Source    Policy_Name    ${VP_Policy_Name}    ${VP_Policy_Name}    OWB Application
#    Set Calc VP Actual Result With Original And Source    Completion Date    ${VP_Completion_Date}    ${VP_Completion_Date}    OWB Application
#    Set Calc VP Actual Result With Original And Source    OLD_Title    ${VP_old_Title}    ${VP_old_Title}    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    OLD_FirstName
    ...    ${VP_old_FirstName.strip()}
    ...    ${VP_old_FirstName}
    ...    OWB Application
    IF    '${VP_old_MiddleName}' != ''
        Set Calc VP Actual Result With Original And Source
        ...    OLD_MiddleName
        ...    ${VP_old_MiddleName.strip()}
        ...    ${VP_old_MiddleName}
        ...    OWB Application
    END
    Set Calc VP Actual Result With Original And Source
    ...    OLD_LastName
    ...    ${VP_old_LastName.strip()}
    ...    ${VP_old_LastName}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    NEW_Title
    ...    ${VP_new_Title.strip()}
    ...    ${VP_new_Title}
    ...    OWB Application
    Set Calc VP Actual Result With Original And Source
    ...    NEW_FirstName
    ...    ${VP_new_FirstName.strip()}
    ...    ${VP_new_FirstName}
    ...    OWB Application
    IF    '${VP_new_MiddleName}' != ''
        Set Calc VP Actual Result With Original And Source
        ...    NEW_MiddleName
        ...    ${VP_new_MiddleName.strip()}
        ...    ${VP_new_MiddleName}
        ...    OWB Application
    END
    Set Calc VP Actual Result With Original And Source
    ...    NEW_LastName
    ...    ${VP_new_LastName.strip()}
    ...    ${VP_new_LastName}
    ...    OWB Application
    IF    '${VP_new_MaritalStatus}' != ''
        Set Calc VP Actual Result With Original And Source
        ...    NEW_MaritalStatus
        ...    ${VP_new_MaritalStatus}
        ...    ${VP_new_MaritalStatus}
        ...    OWB Application
    END

    # postVP
    IF    '${VP_new_Title}' != ''
        Set Calc VP Expected Result With Original And Source
        ...    Post_OWB_NEW_Title
        ...    ${VP_new_Title.strip()}
        ...    ${VP_new_Title}
        ...    OWB Application
    END
    Set Calc VP Expected Result With Original And Source
    ...    Post_OWB_NEW_FirstName
    ...    ${VP_new_FirstName.strip()}
    ...    ${VP_new_FirstName}
    ...    OWB Application
    IF    '${VP_new_MiddleName}' != ''
        Set Calc VP Expected Result With Original And Source
        ...    Post_OWB_NEW_MiddleName
        ...    ${VP_new_MiddleName.strip()}
        ...    ${VP_new_MiddleName}
        ...    OWB Application
    END
    Set Calc VP Expected Result With Original And Source
    ...    Post_OWB_NEW_LastName
    ...    ${VP_new_LastName.strip()}
    ...    ${VP_new_LastName}
    ...    OWB Application
    IF    '${VP_new_MaritalStatus}' != ''
        Set Calc VP Expected Result With Original And Source
        ...    Post_OWB_NEW_MaritalStatus
        ...    ${VP_new_MaritalStatus}
        ...    ${VP_new_MaritalStatus}
        ...    OWB Application
    END
