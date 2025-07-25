*** Settings ***
Library     AppiumLibrary
Library     String
Library     Collections
Library     Operation.py
Library     OperatingSystem
Library     Collections
Library     Dialogs
Library     DateTime
Library     ../Qrace/QraceHelper.py

Resource    UploadAppinBS/Appcenter.robot

*** Variables ***
${count}            0
${screenshotDir}    ${EMPTY}
${url}              https://totp-online.tobythe.dev/
${browser}          chrome
${headless}         false
@{_tmp}
...                 browserName: ${browser},
...                 platform: WINDOWS,
...                 platformName: WINDOWS
${capabilities}     ${EMPTY.join(${_tmp})}
${deviceName}       ${EMPTY}
${platformName}     ${EMPTY}
${udid}             NA
${executionDetailFile}


*** Keywords ***
Get Details from Qrace Environment
    TRY
        ${env}                  Get Environment Attribute    Env
        ${mailSacKey}           Get Environment Attribute    mailSacKey
        ${TimeZone}             Get Environment Attribute    TimeZone
        ${dbhostname}           Get Environment Attribute    DB_hostname
        ${dbusername}           Get Environment Attribute    DB_Username
        ${dbpassword}           Get Environment Attribute    DB_password
        ${dbport}               Get Environment Attribute    DB_port
        ${dbinstanceAddon}      Get Environment Attribute    DBinstanceAddonTable
        ${dbinstance}           Get Environment Attribute    DBinstanceTable
        ${key}                  Get Environment Attribute    DB_Encrpt_AND_Decrpt_key
        ${ivkey}                Get Environment Attribute    DB_Encrpt_AND_Decrpt_IVkey
        ${samplemobileno}       Get Environment Attribute    listofmobileno
        ${key}                  Set Variable    b'${key}'
        ${env}=     Get EnvironmentName
        ${runId}=     Get TestRunId
        ${release}=     Get ReleaseName
        @{releaseNamelist}      Split String    ${release}      _
        ${buildversion}     Get From List    ${releaseNamelist}    0
        ${buildid}     Get From List    ${releaseNamelist}    1
        ${testtype}    Get TestType
        ${testCaseId}         Get TestCaseId
        Set Global Variable    ${testCaseId}
        Set Global Variable    ${testtype}
        Set Global Variable    ${runId}
        Set Global Variable    ${release}
        Set Global Variable    ${buildversion}
        Set Global Variable    ${buildid}
        Set Global Variable    ${env}
        Set Global Variable    ${mailSacKey}
        Set Global Variable    ${TimeZone}
        Set Global Variable    ${dbhostname}
        Set Global Variable    ${dbusername}
        Set Global Variable    ${dbpassword}
        Set Global Variable    ${dbport}
        Set Global Variable    ${dbinstanceAddon}
        Set Global Variable    ${dbinstance}
        Set Global Variable    ${key}
        Set Global Variable    ${ivkey}
        Set Global Variable    ${samplemobileno}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Launch OMNE Application
    TRY
        ${bool}    Convert To Boolean    true
        AppiumLibrary.Register Keyword To Run On Failure    Nothing
        ${bundleid}    Get Environment Attribute    bundleID
        ${appBS}    Get Environment Attribute    BS_link_${platformName}
        ${user}    Get Environment Attribute    BS_user
        ${accessKey}    Get Environment Attribute    BS_accessKey
        Set Global Variable    ${user}
        Set Global Variable    ${accessKey}

        ${udid}    Set Variable    NA
        ${releaseName}      Get ReleaseName

    #    ${appBS}        Set Variable        bs://8ac60c393229be6d0cbdf85f470d3f9b103e0dc1
        IF    '${udid}' == 'NA'
            # BS Capabilites
            &{bstackOption}    Create Dictionary
            ...    appiumVersion=2.0.0
            ...    automationVersion=latest
            ...    enableBiometric=true
            ...    enableCameraImageInjection=true
            #    ...    geoLocation=HK
            IF    '${platformName}' == 'iOS'
                ${buildName}    Set Variable    TH_iOS_Regression
            ELSE
                ${buildName}    Set Variable    TH_Android_Regression
            END
            ${capability}    Create dictionary
            ...    deviceName=${deviceName}
            ...    project=OMNE
            ...    build=${buildName}
            ...    name=${runId}
            ...    app=${appBS}
            ...    ensureWebviewsHavePages=true
            ...    nativeWebScreenshot=true
            ...    newCommandTimeout=3600
            ...    connectHardwareKeyboard=true
            ...    enforceXPath1=${bool}
            ...    browserstack.debug=true
            ...    interactiveDebugging=true
            ...    video=true
            ...    browserstack.idleTimeout=300
            ...    bstack:options=${bstackOption}
            Open Application    remote_url=https://${user}:${accessKey}@hub-cloud.browserstack.com/wd/hub
            ...    &{capability}
            ${session_id}    Get Appium SessionId
    #    Set BrowserStack SessionUrl For TestJob    ${testjobId}    ${session_id}
            Log    SessionID:${session_id}
            Log    ${capability}
            Set Appium Timeout    60s
        ELSE
            IF    '${platformName}' == 'iOS'
                ${bundleIdKey}    Set Variable    bundleId
                ${appActivity}    Set Variable    ${EMPTY}
            ELSE
                ${bundleIdKey}    Set Variable    appPackage
                ${appActivity}    Set Variable    appActivity=global.fwd.omne.NotificationLaunchActivity
            END
            ${capability}    Create dictionary
            ...    platformName=${platformName}
            ...    deviceName=${deviceName}
            ...    udid=${udid}
            ...    platformVersion=${platformVersion}
            ...    ${bundleIdKey}=${bundleid}
            ...    appActivity=global.fwd.omne.NotificationLaunchActivity
            ...    appium:newCommandTimeout=10000
    #        ...    automationName=${automationName}
            ...    useNativeCachingStrategy=false
            ...    enforceXPath1=${bool}
            ...    autoGrantPermissions=${bool}

            Open Application    remote_url=http://127.0.0.1:4723/wd/hub
            ...    &{capability}
        END
        Set Appium Timeout    60s
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Before Test Setup
    TRY
        ${testtype}    Get TestType
        Set Global Variable    ${testtype}
        Log    ${testtype}
        Set Library Search Order    AppiumLibrary    SeleniumLibrary
        ${env}    Get Environment Attribute    Env
        ${mailSacKey}    Get Environment Attribute    mailSacKey
        # fetch db details from env
        ${dbhostname}    Get Environment Attribute    DB_hostname
        Set Global Variable    ${dbhostname}
        ${dbusername}    Get Environment Attribute    DB_Username
        Set Global Variable    ${dbusername}
        ${dbpassword}    Get Environment Attribute    DB_password
        Set Global Variable    ${dbpassword}
        ${dbport}    Get Environment Attribute    DB_port
        Set Global Variable    ${dbport}
        ${dbinstanceAddon}    Get Environment Attribute    DBinstanceAddonTable
        Set Global Variable    ${dbinstanceAddon}
        ${dbinstance}    Get Environment Attribute    DBinstanceTable
        Set Global Variable    ${dbinstance}
        ${key}    Get Environment Attribute    DB_Encrpt_AND_Decrpt_key
        ${ivkey}    Get Environment Attribute    DB_Encrpt_AND_Decrpt_IVkey
        ${key}    Set Variable    b'${key}'
        Set Global Variable    ${key}
        Set Global Variable    ${testtype}
        ${platformName}    Set Variable    IOS
        Set Global Variable    ${platformName}
        Set Global Variable    ${Policy_No}
        Set Appium Timeout    80s
        Set Custom Directory    ${screenshotDir}
        ${testCaseId}    Get TestCaseId
        ${omnecurrent_datetime}    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
        Set Global Variable    ${omnecurrent_datetime}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Take Screenshot
    [Arguments]    ${name}
    TRY
        ${count}    Evaluate    ${count} + 1
        Set Global Variable    ${count}
        ${count}    Evaluate    format(${count}, '05d')
        Capture Page Screenshot    ${screenshotPath}//${count}_OMNE_${name}.png
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Take OWB Screenshot
    [Arguments]    ${name}
    TRY
        ${count}    Evaluate    ${count} + 1
        Set Global Variable    ${count}
        ${count}    Evaluate    format(${count}, '05d')
        Capture Page Screenshot    ${screenshotPath}/${count}_OWB_${name}.png
#       Log    ${screenshotDir}/${count}_OWB_${name}.png
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END

Take IL Screenshot
    [Arguments]    ${name}
    TRY
        ${count}    Evaluate    ${count} + 1
        Set Global Variable    ${count}
        ${count}    Evaluate    format(${count}, '05d')
        Capture Page Screenshot    ${screenshotPath}/${count}_IL_${name}.png
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Take LA Screenshot
    [Arguments]    ${name}
    TRY
        ${count}    Evaluate    ${count} + 1
        Set Global Variable    ${count}
        ${count}    Evaluate    format(${count}, '05d')
        Capture Page Screenshot    ${screenshotPath}/${count}_LA_${name}.png
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Take OPUS Screenshot
    [Arguments]    ${name}
    TRY
        ${count}    Evaluate    ${count} + 1
        Set Global Variable    ${count}
        ${count}    Evaluate    format(${count}, '05d')
        Capture Page Screenshot    ${screenshotPath}/${count}_OPUS_${name}.png
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
SwipePage
    TRY
        ${hight}    Get Window Height
        ${width}    Get Window Width
        ${hight}    Evaluate    ${hight}/2
        ${width}    Evaluate    ${width}/2
        Swipe    ${width}    ${hight}    ${width}    50
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
RefreshPage
    TRY
        ${window_height}    Get Window Height
        ${window_width}    Get Window Width
        ${start_Y}    Evaluate    (${window_height}*0.8)
        ${start_Y}    Convert To Integer    ${start_Y}
        ${start_X}    Evaluate    (${window_width}*0.5)
        ${start_x}    Convert To Integer    ${start_x}
    #    ${end_x}=    Evaluate    ${element_location['x']} + (${element_size['width']} * 0.5)
        ${end_y}    Evaluate    (${window_height}*0.3)
        ${end_y}    Convert To Integer    ${end_y}
        Swipe    ${start_x}    ${end_y}    ${start_x}    ${start_Y}    2000
        Sleep    0.5s
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Fetch Reason
    [Arguments]    ${sOutput}
    TRY
        Convert To List    ${sOutput}
        ${value}    Get From List    ${sOutput}    1
        ${value}    Convert To String    ${value}
        @{split}    Split To Lines    ${value}
        ${value}    Get From List    ${split}    0
        RETURN    ${value}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Close keyboard
    TRY
        IF    '${platformName}' == 'iOS'
            TRY
                Hide Keyboard    return
            EXCEPT
                TRY
                    Hide Keyboard    next
                EXCEPT
                    TRY
                        Hide Keyboard    done
                    EXCEPT
                        TRY
                            Hide Keyboard    Done
                        EXCEPT
                            Click Text    Done      exact_match=True
                        END
                    END
                END
            END
        ELSE
            Hide Keyboard
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Get Month Num
    [Arguments]    ${month}
    TRY
        &{Month_dic}    Create Dictionary
        ...    Jan=1
        ...    Feb=2
        ...    Mar=3
        ...    Apr=4
        ...    May=5
        ...    Jun=6
        ...    Jul=7
        ...    Aug=8
        ...    Sep=9
        ...    Oct=10
        ...    Nov=11
        ...    Dec=12
        ...    January=01
        ...    Feburary=02
        ...    March=03
        ...    April=04
        ...    May=05
        ...    June=06
        ...    July=07
        ...    August=08
        ...    September=09
        ...    October=10
        ...    November=11
        ...    December=12
        ${Month_value}    Get From Dictionary    ${Month_dic}    ${month}
        RETURN    ${Month_value}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Horizontal Swipe
#    Swipe    812 739 225 739 500
    TRY
        ${window_height}    Get Window Height
        ${window_width}    Get Window Width
        ${start_X}    Evaluate    (${window_width}-90)
        ${start_x}    Convert To Integer    ${start_x}
        ${start_Y}    Evaluate    (${window_height}*2)/3
        ${start_Y}    Convert To Integer    ${start_Y}
        ${end_x}    Evaluate    (${window_width})/16
        ${end_x}    Convert To Integer    ${end_x}
        Swipe    ${start_x}    ${start_y}    ${end_x}    ${start_y}
        Sleep    0.5s
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Horizontal Swipe Rider
    [Arguments]    &{coordinateDic}
    TRY
        ${xaxis}    Get From Dictionary    ${coordinateDic}    x
        ${yaxis}    Get From Dictionary    ${coordinateDic}    y

        ${start_X}    Evaluate    (${xaxis}+780)
        ${start_x}    Convert To Integer    ${start_x}
        ${start_Y}    Evaluate    (${yaxis}-300)
        ${start_Y}    Convert To Integer    ${start_Y}
        ${end_x}    Evaluate    (${xaxis}+25)
        ${end_x}    Convert To Integer    ${end_x}
    #    Click Element At Coordinates    ${start_x}    ${start_y}
        Swipe    ${start_x}    ${start_y}    ${end_x}    ${start_y}
        Sleep    0.5s
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Get English To Thai Value
    [Arguments]    ${English_data}
    TRY
        &{Month_dic}    Create Dictionary
        ...    Physical therapy=ค่าบริการทางกายภาพบำบัด
        ...    Acupuncture=ค่าบริการฝังเข็ม
        ...    Medical expenses=ค่ารักษาพยาบาล/ค่าบริการ

    #    ${month}    Evaluate    str(${month}).zfill(2)
        ${Thai_Name}    Get From Dictionary    ${Month_dic}    ${English_data}
        RETURN    ${Thai_Name}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Reset Screenshot Count
    TRY
        Log    ${count}
        ${count}    Set Variable    0
        Set Global Variable         ${count}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Set Executed TestJob
    [arguments]     ${testJobId}
    TRY
        Append To File    ${executionDetailFile}    ${testJobId}\n     encoding=UTF-8
        Log To Console    '${testJobId}' Appended to ExecutionDetail File.
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Get Current Date and Time
    TRY
        @{country_date_time}      Get Country Specific DateTime       ${TimeZone}
        ${currdate}     Get From List    ${country_date_time}    0
        ${currTime}     Get From List    ${country_date_time}    1
        Log To Console    ${currdate}
        Set Global Variable      ${currdate}
        @{dateparts}    Split String    ${currdate}
        ${current_month}    Get From List    ${dateparts}    0
        ${current_day}      Get From List    ${dateparts}    1
        ${current_year}     Get From List    ${dateparts}    2
        Set Global Variable    ${current_month}
        Set Global Variable    ${current_day}
        Set Global Variable    ${current_year}
        ${omnecurrent_datetime}    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
        Set Global Variable    ${omnecurrent_datetime}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Set Failed Actual Result and VP
    [Arguments]     ${flowname}     ${reason}   ${actualresultText}
    TRY
        Set Calc VP With Source And Original Values    ${flowname}    Flow_Successful    Flow_Failed    Static    Omne_Application_Flow   Flow_Successful    Flow_Failed
#        Take Screenshot    ${flowname} Error Screenshot
        ${actualResult}     Catenate    ${actualResult}     | ${actualresultText} Failed due to :${reason}
        Set Global Variable    ${actualResult}
        Set Actual Result      ${actualResult}
        Fail
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Set Failed Actual Result and VP
    END