*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     String
Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/ChangeMobileAndEmailPageObject.Resource
Resource    ../Common/AddOTP.resource
Library      .../../../../DBQuery/PersonalDetailsDB.py


*** Keywords ***
Mobile and Email Change
    TRY
        ${AgentDetaillistdf}    Run Keyword
        ...    Get Servicing Agent Details
        ...    ${dbhostname}
        ...    ${dbusername}
        ...    ${dbpassword}
        ...    ${dbport}
        ...    ${dbinstance}
        ...    ${Policy_No}
        ...    ${screenshotPath}
        Log    ${AgentDetaillistdf}
        ${leng}    Get Length    ${AgentDetaillistdf}
        Log    ${leng}
        ${list0}    Get From List    ${AgentDetaillistdf}    0
        Log    ${list0}
        ${index1}    Get Index From List    ${list0}    EmailAddress
        Log    ${index1}
        ${index2}    Get Index From List    ${list0}    MobileNumber
        Log    ${index2}
        ${list}    Get From List    ${AgentDetaillistdf}    1
        # agentemailaddress
        ${AgentEmailAddress}    Set Variable    ${list}[${index1}]
        IF    '${AgentEmailAddress}' != ''
            ${AgentEmailAddress}    Strip String    ${AgentEmailAddress}
            ${AgentEmailAddress}    AES Decrypt    ${key}    ${AgentEmailAddress}
            Set Global Variable    ${AgentEmailAddress}
        END
        # agent mobileno
        ${AgentMobileNumber}    Set Variable    ${list}[${index2}]
        IF    '${AgentMobileNumber}' != ''
            ${AgentMobileNumber}    Strip String    ${AgentMobileNumber}
            ${AgentMobileNumber}    AES Decrypt    ${key}    ${AgentMobileNumber}
            Set Global Variable    ${AgentMobileNumber}
        END
   #    ${AgentMobileNumber}    Strip String    ${AgentMobileNumber}
#       ${AgentMobileNumber}    AES Decrypt    ${key}    ${AgentMobileNumber}
#       Set Global Variable    ${AgentMobileNumber}
        ${status}    Run Keyword And Return Status       Wait Until Element Is Visible      ${${platformName}_${lang}_Email_Mobile_Txt}
        IF    '${status}' == 'True'
            Set Calc VP With Source And Original Values     Email_Mobile_Options_Present    true    ${status}      Static  OMNE_Applicatio True   ${status}
        END
        IF    '${Transaction_Page_GUI}' == 'Yes'
            ${status}    Run Keyword And Return Status      Wait Until Element Is Visible   ${${platformName}_${lang}_Update_personal_details_Txt}      timeout=2s
        IF    '${status}' == 'True'
            Set Calc VP With Source And Original Values     Update_Personal_Details_Present    true    ${status}      Static  OMNE_Applicatio True   ${status}
        END
        ${status}    Run Keyword And Return Status      Wait Until Element Is Visible       ${${platformName}_${lang}_updatemobilefield}        timeout=2s
        IF    '${status}' == 'True'
            Set Calc VP With Source And Original Values     Enter_Mobile_Details_Present    true    ${status}      Static  OMNE_Applicatio True   ${status}
        END
        ${status}    Run Keyword And Return Status      Wait Until Element Is Visible       ${${platformName}_${lang}_updateemailfield}     timeout=2s
        IF    '${status}' == 'True'
            Set Calc VP With Source And Original Values     Enter_Email_Details_Present    true    ${status}      Static  OMNE_Applicatio True   ${status}
        END
        Wait Until Page Contains Element    ${${platformName}_${lang}_updateemailfield}    timeout=50s
        # Capture existing email and mobile details
        ${oldUsername}    Get Text    ${${platformName}_${lang}_updateemailfield}
        Set Global Variable    ${oldUsername}
        Wait Until Element Is Visible    ${${platformName}_${lang}_CountryCode}    timeout=10s
        ${CCode}    Get Text    ${${platformName}_${lang}_CountryCode}
        ${CCode}    Replace String    ${CCode}    +    ${EMPTY}
        ${oldMobileNo}    Get Text    ${${platformName}_${lang}_updatemobilefield}
        ${Mob}    Set Variable    ${CCode}
        ${MobNo}    Set Variable    ${Mob}${oldMobileNo}
        Set Global Variable    ${MobNo}
        Take Screenshot    Update_Details
    END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END