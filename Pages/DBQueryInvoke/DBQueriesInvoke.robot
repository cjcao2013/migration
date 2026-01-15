*** Settings ***
Library     RequestsLibrary
Library     OperatingSystem
Library     Collections
Resource    ../../CustomLibraries/common.robot
Library     ../DBQuery/InvestmentDB.py
Library     ../DBQuery/DBQuerySelect.py
Library     ../DBQuery/PersonalDetailsDB.py
Library     ../DBQuery/cancellationdtltempDB.py
Library     ../DBQuery/OTPfromCustIDDB.py
Library     ../DBQuery/OWBDB.py
Library     ../../Qrace/QraceHelper.py


*** Variables ***
${dbhostname}           aurora-mysql-gtf-mmt-apse1-uat-insurance-cluster-02.cluster-ro-crml2op3jxob.ap-southeast-1.rds.amazonaws.com
${dbusername}           seemkari
${dbpassword}           SDfeVKUmpNf:3KxA
${dbport}               3306
${dbinstanceAddon}      fwd_insurance_uat_addon
${dbinstance}           fwd_insurance_uat
${Policy_No}            40752740
${key}                  b'4fe33f022f84d36537a98e5b8f13ba79'
${Policy_No_Decrypt}    ${EMPTY}


*** Keywords ***
Get OWB Payload From DB
    ${requesttype}    Set Variable    Servicing
    ${caseno}    Set Variable    7231656
    ${owbPayload}    Get Freq and RCC Details
    ...    ${dbhostname}
    ...    ${dbusername}
    ...    ${dbpassword}
    ...    ${dbport}
    ...    ${dbinstanceAddon}
    ...    ${requesttype}
    ...    ${caseno}
    Log    ${owbPayload}
    ${ResBody}    Evaluate    json.loads(${owbPayload})    json
#    ${response_body}    Convert To String    ${Res_body}
#    Create File    ${screenshotDir}\\getMessages_response.json    ${response_body}
#    Log    ${PDdf}
#    ${leng}    Get Length    ${PDdf}
#    Log    ${leng}
#    ${list0}    Get From List    ${PDdf}    0
#    Log    ${list0}
#    ${index1}    Get Index From List    ${list0}    Payload
#    Log    ${index1}
#    ${counter}    Set Variable    1
##    Log    ${counter}
#    ${list}    Get From List    ${PDdf}    ${counter}
##    ${type_list}    Evaluate    type(${list})
##    Log    ${type_list}
##    ${ActualSource}    Set Variable    View Investment DB Query
#    ${owbPayload}    Set Variable    ${list}[${index1}]

Get OTP from CustID
    [Arguments]    ${OwnerUserCol}    ${tablename}    ${orderbycol}    ${OTPCol}
#    ${OwnerUserCol}    Set Variable    owneruserid
#    ${tablename}    Set Variable    taxconsenttemp
#    ${orderbycol}    Set Variable    otpgenerateddatetime
#    ${OTPCol}    Set Variable    Otp
#    ${OwnerUserId}    Run Keyword
#    ...    Get Owner User ID from DB
#    ...    ${dbhostname}
#    ...    ${dbusername}
#    ...    ${dbpassword}
#    ...    ${dbport}
#    ...    ${dbinstanceAddon}
#    ...    ${Policy_No}
#    Log    ${OwnerUserId}
#    ownercol, owneruserid,tablename,orderbycol
    ${PDdf}    Get OTP from Customer ID
    ...    ${dbhostname}
    ...    ${dbusername}
    ...    ${dbpassword}
    ...    ${dbport}
    ...    ${dbinstanceAddon}
    ...    ${OwnerUserCol}
    ...    ${OwnerUserId}
    ...    ${tablename}
    ...    ${orderbycol}
    Log    ${PDdf}
    ${leng}    Get Length    ${PDdf}
    Log    ${leng}
    ${list0}    Get From List    ${PDdf}    0
    Log    ${list0}
    log     ${OTPCol}
    ${index1}    Get Index From List    ${list0}    ${OTPCol}
    Log    ${index1}

    IF    '${leng}' > '1'
        ${counter}    Set Variable    1
        ${list}    Get From List    ${PDdf}    ${counter}
        Log     ${list}
        ${OTPNumber}    Set Variable    ${list}[${index1}]
        Log    ${OTPNumber}
    ELSE
        ${OTPNumber}    Set Variable
    END
#    Set Global Variable    ${OTPNumber}
    IF    '${OTPCol}' == 'EncryptedOTP'
         ${OTPNumber}   AES Decrypt    ${key}    ${OTPNumber}
    END

    Set Global Variable    ${OTPNumber}

# Get Delete Rider OTP

Get OTP from Cancellation Table
#    ${BankAccountNo}    Set Variable    654345679
#    ${OwnerUserId}    Run Keyword
#    ...    Get Owner User ID from DB
#    ...    ${dbhostname}
#    ...    ${dbusername}
#    ...    ${dbpassword}
#    ...    ${dbport}
#    ...    ${dbinstanceAddon}
#    ...    ${Policy_No}
#    Log    ${OwnerUserId}
    ${PDdf}    Get OTP From Cancellation DB
    ...    ${dbhostname}
    ...    ${dbusername}
    ...    ${dbpassword}
    ...    ${dbport}
    ...    ${dbinstanceAddon}
    ...    ${OwnerUserId}
    ...    ${Bank_Book_Number}
    Log    ${PDdf}
    ${leng}    Get Length    ${PDdf}
    Log    ${leng}
    ${list0}    Get From List    ${PDdf}    0
    Log    ${list0}
    ${index1}    Get Index From List    ${list0}    OTP
    Log    ${index1}
    IF    '${leng}' > '1'
        ${counter}    Set Variable    1
        ${list}    Get From List    ${PDdf}    ${counter}
        ${OTPNumber}    Set Variable    ${list}[${index1}]
        Log    ${OTPNumber}
    ELSE
        ${OTPNumber}    Set Variable
    END
    Set Global Variable    ${OTPNumber}

Get SignUp OTP
#    ${Customer_ID}    Set Variable    1088888888378
#    ${SignUpDOB}    Set Variable    19 January 1989
    @{DOB}    Split String    ${SignUpDOB}
    ${date}    Get From List    ${DOB}    0
    ${month}    Get From List    ${DOB}    1
    ${MonthNum}    Get Month Num    ${month}
    ${year}    Get From List    ${DOB}    2
    ${dobDB}    Catenate    ${year}${MonthNum}${date}
#    ${Country}    Set Variable    Thailand
    ${OTPNumber}    Run Keyword
    ...    Get Onboarding OTP from DB
    ...    ${dbhostname}
    ...    ${dbusername}
    ...    ${dbpassword}
    ...    ${dbport}
    ...    ${dbinstanceAddon}
    ...    ${country}
    ...    ${dobDB}
    ...    ${Customer_ID}
    Log    ${OTPNumber}
    Set Global Variable    ${OTPNumber}

Get Name Marital Status Details
#    ${OwnerUserId}    Run Keyword
#    ...    Get Owner User ID from DB
#    ...    ${dbhostname}
#    ...    ${dbusername}
#    ...    ${dbpassword}
#    ...    ${dbport}
#    ...    ${dbinstanceAddon}
#    ...    ${Policy_No}
#    Log    ${OwnerUserId}
    ${PDdf}    Get Personal Details with OTP
    ...    ${dbhostname}
    ...    ${dbusername}
    ...    ${dbpassword}
    ...    ${dbport}
    ...    ${dbinstanceAddon}
    ...    ${OwnerUserId}
    ...    ${Policy_No}
    Log    ${PDdf}
    ${leng}    Get Length    ${PDdf}
    Log    ${leng}
    ${list0}    Get From List    ${PDdf}    0
    Log    ${list0}
    ${index1}    Get Index From List    ${list0}    FirstName
    Log    ${index1}
    ${index2}    Get Index From List    ${list0}    MiddleName
    Log    ${index2}
    ${index3}    Get Index From List    ${list0}    LastName
    Log    ${index3}
    ${index4}    Get Index From List    ${list0}    MaritalStatus
    Log    ${index4}
    ${index5}    Get Index From List    ${list0}    EncryptedOTP
    Log    ${index5}
    ${index6}    Get Index From List    ${list0}    Salutation
    Log    ${index6}
    ${counter}    Set Variable    1
#    Log    ${counter}
    ${list}    Get From List    ${PDdf}    ${counter}
#    ${type_list}    Evaluate    type(${list})
#    Log    ${type_list}
#    ${ActualSource}    Set Variable    View Investment DB Query
    ${fnval}    Set Variable    ${list}[${index1}]
    Log    ${fnval}
    IF    '${fnval}' == 'None'
        ${fnval}    Set Variable    ${EMPTY}
    END
    ${mnval}    Set Variable    ${list}[${index2}]
    Log    ${mnval}
    IF    '${mnval}' == 'None'
        ${mnval}    Set Variable    ${EMPTY}
    END
    ${lnval}    Set Variable    ${list}[${index3}]
    Log    ${lnval}
    IF    '${lnval}' == 'None'
        ${lnval}    Set Variable    ${EMPTY}
    END
    ${msval}    Set Variable    ${list}[${index4}]
    Log    ${msval}
    IF    '${msval}' == 'None'
        ${msval}    Set Variable    ${EMPTY}
    END
    ${OTPNumber}    Set Variable    ${list}[${index5}]
    Log    ${OTPNumber}
    IF    '${OTP_Column_Name}' == 'EncryptedOTP'
      ${OTPNumber}   AES Decrypt    ${key}    ${OTPNumber}
    END
    Set Global Variable    ${OTPNumber}
    ${Salval}    Set Variable    ${list}[${index6}]
    Log    ${Salval}
    IF    '${Salval}' != 'None'
        ${Salval}       Remove String       ${Salval}       .
    END
    Set Calc VP Actual Result With Original And Source    NEW_Title_DB    ${Salval}    ${Salval}    Personal Details DB
    Set Calc VP Actual Result With Original And Source
    ...    NEW_FirstName_DB
    ...    ${fnval}
    ...    ${fnval}
    ...    Personal Details DB
    Set Calc VP Actual Result With Original And Source
    ...    NEW_MiddleName_DB
    ...    ${mnval}
    ...    ${mnval}
    ...    Personal Details DB
    Set Calc VP Actual Result With Original And Source
    ...    NEW_LastName_DB
    ...    ${lnval}
    ...    ${lnval}
    ...    Personal Details DB
    Set Calc VP Actual Result With Original And Source
    ...    NEW_MaritalStatus_DB
    ...    ${msval}
    ...    ${msval}
    ...    Personal Details DB

Get Email or Mobile Details
    [Arguments]    ${FetchCol}
#    ${OwnerUserId}    Run Keyword
#    ...    Get Owner User ID from DB
#    ...    ${dbhostname}
#    ...    ${dbusername}
#    ...    ${dbpassword}
#    ...    ${dbport}
#    ...    ${dbinstanceAddon}
#    ...    ${Policy_No}
#    Log    ${OwnerUserId}
    ${PDdf}    Get Personal Details with OTP
    ...    ${dbhostname}
    ...    ${dbusername}
    ...    ${dbpassword}
    ...    ${dbport}
    ...    ${dbinstanceAddon}
    ...    ${OwnerUserId}
    ...    ${Policy_No}
    Log    ${PDdf}
    ${leng}    Get Length    ${PDdf}
    Log    ${leng}
    ${list0}    Get From List    ${PDdf}    0
    Log    ${list0}
    ${index1}    Get Index From List    ${list0}    ${FetchCol}
    Log    ${index1}
    ${index2}    Get Index From List    ${list0}    EncryptedOTP
    Log    ${index2}
#    ${index2}    Get Index From List    ${list0}    MobileNumber
#    Log    ${index2}
    ${counter}    Set Variable    1
#    Log    ${counter}
    ${list}    Get From List    ${PDdf}    ${counter}
#    ${type_list}    Evaluate    type(${list})
#    Log    ${type_list}
#    ${ActualSource}    Set Variable    View Investment DB Query
    ${fetchValue}    Set Variable    ${list}[${index1}]
    Log    ${fetchValue}
    ${pdotp}    Set Variable    ${list}[${index2}]
    Log    ${pdotp}
    IF    '${OTP_Column_Name}' == 'EncryptedOTP'
      ${pdotp}   AES Decrypt    ${key}    ${pdotp}
    END
    Set Global Variable     ${pdotp}
#    ${mobileNum}    Set Variable    ${list}[${index2}]
#    Log    ${mobileNum}
    RETURN    ${pdotp}~${fetchValue}

Get Address Details from DB
#    ${OwnerUserId}    Run Keyword
#    ...    Get Owner User ID from DB
#    ...    ${dbhostname}
#    ...    ${dbusername}
#    ...    ${dbpassword}
#    ...    ${dbport}
#    ...    ${dbinstanceAddon}
#    ...    ${Policy_No}
#    Log    ${OwnerUserId}
    ${PDdf}    Get Personal Details with OTP
    ...    ${dbhostname}
    ...    ${dbusername}
    ...    ${dbpassword}
    ...    ${dbport}
    ...    ${dbinstanceAddon}
    ...    ${OwnerUserId}
    ...    ${Policy_No}
    Log    ${PDdf}
    ${leng}    Get Length    ${PDdf}
    Log    ${leng}
    ${list0}    Get From List    ${PDdf}    0
    Log    ${list0}
    ${index1}    Get Index From List    ${list0}    AddressLineOne
    Log    ${index1}
    ${index2}    Get Index From List    ${list0}    AddressLineTwo
    Log    ${index2}
    ${index3}    Get Index From List    ${list0}    Province
    Log    ${index3}
    ${index4}    Get Index From List    ${list0}    Zipcode
    Log    ${index4}
    ${index5}    Get Index From List    ${list0}    City
    Log    ${index5}
    ${index6}    Get Index From List    ${list0}    EncryptedOTP
    Log    ${index6}
    ${counter}    Set Variable    1
#    Log    ${counter}
    ${list}    Get From List    ${PDdf}    ${counter}
#    ${type_list}    Evaluate    type(${list})
#    Log    ${type_list}
#    ${ActualSource}    Set Variable    View Investment DB Query
    ${AddLine1DB}    Set Variable    ${list}[${index1}]
    Log    ${AddLine1DB}
    ${AddLine2DB}    Set Variable    ${list}[${index2}]
    Log    ${AddLine2DB}
    IF    '${AddLine1DB}' == 'None'
        ${AddLine1DB}    Set Variable    ${EMPTY}
    END
    ${addtwoval}    Set Variable    ${list}[${index6}]
    Log    ${addtwoval}
    IF    '${AddLine2DB}' == 'None'
        ${AddLine2DB}    Set Variable    ${EMPTY}
    END
    ${provinceDB}    Set Variable    ${list}[${index3}]
    Log    ${provinceDB}
    ${zipcodeDB}    Set Variable    ${list}[${index4}]
    Log    ${zipcodeDB}
    ${cityDB}    Set Variable    ${list}[${index5}]
    Log    ${cityDB}
    ${OTPNumber}    Set Variable    ${list}[${index6}]
    IF    '${OTP_Column_Name}' == 'EncryptedOTP'
      ${OTPNumber}   AES Decrypt    ${key}    ${OTPNumber}
    END
    Set Global Variable    ${OTPNumber}

    Log    ${OTPNumber}
    Set Global Variable    ${OTPNumber}
    Set Calc VP Actual Result With Original And Source
    ...    New_Address_Line1_DB
    ...    ${AddLine1DB}
    ...    ${AddLine1DB}
    ...    Personal Details DB
    Set Calc VP Actual Result With Original And Source
    ...    New_Address_Line2_DB
    ...    ${AddLine2DB}
    ...    ${AddLine2DB}
    ...    Personal Details DB
    Set Calc VP Actual Result With Original And Source
    ...    New_Address_State_DB
    ...    ${provinceDB}
    ...    ${provinceDB}
    ...    Personal Details DB
#    Set Calc VP Actual Result With Original And Source    New_Address_District_DB    ${PersonalDetails_Address_District}    ${PersonalDetails_Address_District}    Personal Details DB
    Set Calc VP Actual Result With Original And Source
    ...    New_Address_City_DB
    ...    ${cityDB}
    ...    ${cityDB}
    ...    Personal Details DB
    Set Calc VP Actual Result With Original And Source
    ...    New_Address_ZipCode_DB
    ...    ${zipcodeDB}
    ...    ${zipcodeDB}
    ...    Personal Details DB
