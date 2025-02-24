*** Settings ***
Library     SeleniumLibrary
Library     Dialogs
Library     String
Resource    ../../CustomLibraries/common.robot
Resource    ../../PageObjects/IL/ClientEnquiryObjects.robot
Library     ../DBQuery/DBQuerySelect.py
Library     ../DBQuery/PersonalDetailsDB.py


*** Variables ***
${key}      b'f057ecb7c8ed51ac'
${IL_Actual}

*** Keywords ***
IL_Client Inquiry
    TRY
        Switch Window    NEW
        Maximize Browser Window

        Click Element    ${obj_enq_drag_controls}
        Click Element    ${obj_enq_clients_groups}
        Click Element    ${obj_enq_Client_Maintenance}
        Client Maintenance Sub Menu
         ${IL_Actual}=    Catenate    ${IL_Actual}     |   IL_Client Inquiry Completed Successfully
        Set Global Variable    ${IL_Actual}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       IL_Flow   ${reason}   Client Inquiry
    END
Client Maintenance Sub Menu
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

        ${IL_ClientNumber}    AES Decrypt    ${key}    ${ClientIddec}
        Log    ${IL_ClientNumber}
        Set Global Variable    ${IL_ClientNumber}
        Wait Until Element Is Visible    ${obj_client_number}           timeout=20s
        Input Text    ${obj_client_number}    ${IL_ClientNumber}
    #    ${Client_Id}
    #    inquiry on client details is selected by default
        Take IL Screenshot    Client Maintenance
        Click Element    ${obj_OK_btn}
        Sleep    5s
        Run Keyword    ${Core_System} ${CoreSystem_SubFlow}

    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       IL_Flow   ${reason}  Client Maintenance Sub Menu
    END
IL email
   TRY
         Wait Until Element Is Visible    ${obj_email_address}       timeout=10s
        ${email_value}    Get Value    ${obj_email_address}
        Take IL Screenshot    Client Maintenance
        Log    ${email_value}
        Set Calc VP Actual Result With Original And Source
        ...    IL_Email_ID
        ...    ${email_value}
        ...    ${email_value}
        ...    IL_Application
   EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       IL_Flow   ${reason}  IL Email
   END
IL mobile
    TRY
        Wait Until Element Is Visible    ${obj_telephone}       timeout=20s
        ${telephone_value}    Get Value    ${obj_telephone}
        Log    ${telephone_value}
        Take IL Screenshot    Client Maintenance
        ${mtelephone_value}    Get Substring    ${telephone_value}    -8

        Set Calc VP Actual Result With Original And Source
        ...    IL_Mobile
        ...    ${mtelephone_value.strip()}
        ...    ${telephone_value}
        ...    IL_Application
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       IL_Flow   ${reason}  IL Mobile
    END
IL address
    TRY
        Wait Until Element Is Visible    ${obj_Extra_Details}       timeout=20s
        Click Element    ${obj_Extra_Details}
        Wait Until Element Is Visible    ${obj_address_street1}             timeout=20s
        ${street1}    Get Value    ${obj_address_street1}
        ${street2}    Get Value    ${obj_address_street2}
        ${subdistrict}    Get Value    ${obj_address_subdistrict}
        ${district}    Get Value    ${obj_address_district}
        ${city}    Get Value    ${obj_address_city}
        ${country}    Get Text    ${obj_address_country}

        Take IL Screenshot    IL_AddressDetails
        Set Calc VP Actual Result With Original And Source    IL_AddressCity    ${city}    ${city}    IL_Application
        Set Calc VP Actual Result With Original And Source
        ...    IL_Addresscountry
        ...    ${country}
        ...    ${country}
        ...    IL_Application
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       IL_Flow   ${reason}  IL Address
    END
