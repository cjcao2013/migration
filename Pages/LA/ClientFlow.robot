*** Settings ***
Documentation       MainFrame Demo

Library             Mainframe3270
Library             BuiltIn
Library             Screenshot
Library             OperatingSystem
Library             ../../Qrace/QraceHelper.py
Library             SeleniumLibrary
Resource            ../../CustomLibraries/LA/AS400Utility.robot
Library             ../DBQuery/DBQuerySelect.py
Library             ../DBQuery/DBQuerySelect.py
Library             ../DBQuery/PersonalDetailsDB.py
Resource            ../../CustomLibraries/common.robot


*** Keywords ***
Client Inquiry
    TRY
        ${ClientIddec}    Get Client ID based on Policy Number from DB
        ...    ${dbhostname}
        ...    ${dbusername}
        ...    ${dbpassword}
        ...    ${dbport}
        ...    ${dbinstance}
        ...    ${Policy_No}
        ...    ${screenshotPath}
        Log    ${ClientIddec}

        ${LA_ClientNumber}    AES Decrypt    ${key}    ${ClientIddec}
        Log    ${LA_ClientNumber}
        Set Global Variable    ${LA_ClientNumber}

        Execute Command    MoveCursor(7, 13)
        Send Enter
        Send Enter
        Write Bare In position    ${LA_ClientNumber}    17    37
        Write Bare In position    D    21    37
        Take AS400 Screenshot
        Send Enter
        ${Client_Flow}    Convert To Lower Case    ${CoreSystem_SubFlow}
        IF    '${Client_Flow}' == 'email'
            ${EmailLA}    Mainframe3270.Read    16    15    50
            ${EmailLA}    Strip String    ${EmailLA}
            Take AS400 Screenshot
            Set Calc VP Actual Result With Original And Source    LA_Email_ID    ${EmailLA}    ${EmailLA}    LA_Application
        ELSE IF    '${Client_Flow}' == 'mobile'
            ${TelephoneLA}    Mainframe3270.Read    15    15    16
            ${TelephoneLA}    Strip String    ${TelephoneLA}
            ${TelephoneLA_msg}    Get Substring    ${TelephoneLA}    -8
            Take AS400 Screenshot
            Set Calc VP Actual Result With Original And Source
            ...    LA_Mobile
            ...    ${TelephoneLA_msg.strip()}
            ...    ${TelephoneLA}
            ...    LA_Application
        ELSE IF    '${Client_Flow}' == 'name'
    #    ${SalCodeLA}    Mainframe3270.Read    4    15    8
    #    ${SalCodeLA}    Strip String    ${SalCodeLA}
            ${SalTextLA}    Mainframe3270.Read    4    23    10
            ${SalTextLA}    Strip String    ${SalTextLA}
            ${MarriedLA}    Mainframe3270.Read    9    56    1
            ${MarriedLA}    Strip String    ${MarriedLA}
            ${MarriedLA}    Mainframe3270.Read    9    56    1
            ${MarriedLA}    Strip String    ${MarriedLA}
            ${GivenNameLA}    Mainframe3270.Read    5    15    50
            ${GivenNameLA}    Strip String    ${GivenNameLA}
            ${MiddleNameLA}    Mainframe3270.Read    6    15    50
            ${MiddleNameLA}    Strip String    ${MiddleNameLA}
            ${SurNameLA}    Mainframe3270.Read    7    15    50
            ${SurNameLA}    Strip String    ${SurNameLA}
            ${MaritalStatus}    Get Substring    ${PersonalDetails_MaritalStatus}    0    1
            Set Calc VP With Source And Original Values
            ...    LA_Salutation
            ...    ${Title}
            ...    ${SalTextLA}
            ...    Static
            ...    LA_Flow
            ...    ${Title}
            ...    ${SalTextLA}
            Set Calc VP With Source And Original Values
            ...    LA_MaritalStatus
            ...    ${MaritalStatus}
            ...    ${MarriedLA}
            ...    Static
            ...    LA_Flow
            ...    ${Title}
            ...    ${MarriedLA}
            Set Calc VP With Source And Original Values
            ...    LA_FirstName
            ...    ${fname}
            ...    ${GivenNameLA}
            ...    Static
            ...    LA_Flow
            ...    ${Title}
            ...    ${fname}
            Set Calc VP With Source And Original Values
            ...    LA_MiddleName
            ...    ${mname}
            ...    ${MiddleNameLA}
            ...    Static
            ...    LA_Flow
            ...    ${Title}
            ...    ${mname}
            Set Calc VP With Source And Original Values
            ...    LA_LastName
            ...    ${lname}
            ...    ${SurNameLA}
            ...    Static
            ...    LA_Flow
            ...    ${Title}
            ...    ${lname}
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       LA_Flow   ${reason}   LA Client Inquiry
    END
#    ${GenderLA}    Mainframe3270.Read    8    56    1
#    ${GenderLA}    Strip String    ${GenderLA}
