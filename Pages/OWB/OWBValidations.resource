*** Settings ***
Library     SeleniumLibrary
Library     ../../Qrace/QraceHelper.py
Resource    ../../PageObjects/OWB/OWBValidationsObject.resource


*** Keywords ***
OWB Validations
    Wait Until Element Is Visible    ${EN_Customer_Name}

    IF    '${Insurance_Flow}' != 'Submit'
        ${Customer_id_blank_status}    Set Variable    Non Blank
        ${count}    Get Element Count    ${EN_Customer_Id}
        IF    ${count} > 0
            ${Customer_id_value}    Get Value    ${EN_Customer_Id}
            IF    '${Customer_id_value}' == ''
                ${Customer_id_blank_status}    Set Variable    Blank
            END
        ELSE
            ${Customer_id_blank_status}    Set Variable    Object Not Found
        END
#        Set Calc VP With Source And Original Values
#        ...    OWB_Customer_ID
#        ...    Non Blank
#        ...    ${Customer_id_blank_status}
#        ...    static
#        ...    OWB_Transaction
#        ...    Non Blank
#        ...    ${Customer_id_blank_status}
    END

    ${Customer_name_blank_status}    Set Variable    Non Blank
    ${count}    Get Element Count    ${EN_Customer_Name}
    IF    ${count} > 0
        ${Customer_Name_value}    Get Value    ${EN_Customer_Name}
        IF    '${Customer_Name_value}' == ''
            ${Customer_name_blank_status}    Set Variable    Blank
        END
    ELSE
        ${Customer_name_blank_status}    Set Variable    Object Not Found
    END
    Set Calc VP With Source And Original Values
    ...    OWB_Customer_Name
    ...    Non Blank
    ...    ${Customer_name_blank_status}
    ...    static
    ...    OWB_Transaction
    ...    Non Blank
    ...    ${Customer_name_blank_status}

    IF    '${Insurance_Flow}' == 'Submit'
        ${Customer_age_blank_status}    Set Variable    Non Blank
        ${count}    Get Element Count    ${EN_Customer_Age_Title}
        IF    ${count} > 0
            ${Customer_Age}    Get Value    ${EN_Cutomer_Age}
            IF    '${Customer_Age}' == ''
                ${Customer_age_blank_status}    Set Variable    Blank
            END
        ELSE
            ${Customer_name_blank_status}    Set Variable    Object Not Found
        END
        Set Calc VP With Source And Original Values
        ...    OWB_Customer_Age
        ...    Non Blank
        ...    ${Customer_age_blank_status}
        ...    static
        ...    OWB_Transaction
        ...    Non Blank
        ...    ${Customer_age_blank_status}
    END
