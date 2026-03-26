*** Settings ***
Library    BuiltIn
Library     String
Library       Collections



*** Test Cases ***
Compare Using Keyword
    ${a}    Set Variable    Feb 11 2026 Change mailing preference Completed Policy no: 40779327 New mailing preference: Email Policy applied ยูนิต ลิงค์ เลกาซี (1)
    @{transactionstatusdetail}    Split String      ${a}        Policy no:
    ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
    @{transactionstatus}    Split String    ${transactionstatus}    Change mailing preference
    ${transactionstatus}    Get From List    ${transactionstatus}    1

    Log To Console    Transaction_Status=${transactionstatus}

    ${ChangeMailingPreference_Transaction_Detail}           Get From List    ${transactionstatusdetail}    1
    @{ChangeMailingPreference_Transaction_Detail}         Split String    ${ChangeMailingPreference_Transaction_Detail}       New mailing preference:
    ${VP_PolicyNumber}     Get From List    ${ChangeMailingPreference_Transaction_Detail}     0
    Log To Console    PolicyNUmber=${VP_PolicyNumber}

    ${ChangeMailingPreference_Transaction_Detail}           Get From List    ${ChangeMailingPreference_Transaction_Detail}         1
    @{ChangeMailingPreference_Transaction_Detail}         Split String    ${ChangeMailingPreference_Transaction_Detail}       Policy applied

    ${VP_Mailing_Preference}        Get From List    ${ChangeMailingPreference_Transaction_Detail}     0
    ${VP_Policy_Applied}            Get From List    ${ChangeMailingPreference_Transaction_Detail}     1
    Log To Console    New_Mailing_Address=${VP_Mailing_Preference}
    Log To Console    PolicyApplied=${VP_Policy_Applied}













