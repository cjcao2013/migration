*** Settings ***
Library     SeleniumLibrary
Library     Dialogs
Library     QraceHelper
Resource    OWBAssignTaskPage.resource
Resource    ../../PageObjects/OWB/OWBRiskProfileDetailsPageObjects.resource


*** Keywords ***
OWB Risk profile
    Sleep    2s
    ${VP_old_Title}    Get Element Attribute    ${EN_VP_old_Title}    attribute=title
    ${VP_old_FirstName}    Get Element Attribute    ${EN_VP_old_FirstName}    attribute=title
    ${VP_old_MiddleName}    Get Element Attribute    ${EN_VP_old_MiddleName}    attribute=title
    ${VP_old_LastName}    Get Element Attribute    ${EN_VP_old_LastName}    attribute=title
    ${VP_new_Title}    Get Element Attribute    ${EN_VP_new_Title}    attribute=title
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
#    Set Calc VP Actual Result With Original And Source    NEW_Title    ${VP_new_Title.strip()}    ${VP_new_Title}    OWB Application
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
#    Set Calc VP Expected Result With Original And Source    Post_OWB_NEW_Title    ${VP_new_Title.strip()}    ${VP_new_Title}    OWB Application
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
