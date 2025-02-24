*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     String
Library     DateTime
Resource    ../../../CustomLibraries/common.robot
Resource    ../../../PageObjects/Insurance/Claims/ClaimsPageObjects.resource
Resource    ../Common/GUIPage.resource
Resource    ../Common/UploadDocuments.resource
Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/UpdatePoliciesmoduleSelectPageObject.resource
Resource    ClaimsPage.resource

*** Keywords ***
Claim Hospitalisation
    PromptPayHeadsPopup

    #select claim is about
    Select claim is About

    #claim check box
    Click Element    ${${platformName}_${lang}_ClaimchkBox}
    Take Screenshot    Claim_Step2_Page
    Click Element    ${${platformName}_${lang}_nextBtn}

    # add claimdetails
    Wait Until Element Is Visible    ${${platformName}_${lang}_hospitalsaty}    timeout=10s
    Take Screenshot    ClaimDetails_Step2_Page
    IF    '${ClaimIsAbout}' == 'Accident'
        Input Text    ${${platformName}_${lang}_accidentDate}    ${AccidentDate}\n
    END
    # checkin and checkout date
    Click Element    ${${platformName}_${lang}_hospitalsaty}
    Run Keyword    Select CheckIN and CheckOut Date
    Take Screenshot    DateSelection
    Wait Until Element Is Visible    ${${platformName}_${lang}_DobDoneBtn}    timeout=10s
    Click Element    ${${platformName}_${lang}_DobDoneBtn}

    #add medical center
    Add Medical Center

    #add diagnosis
    Add Diagnosis

    Wait Until Element Is Visible    ${${platformName}_${lang}_ClaimchkBox}
    Click Element    ${${platformName}_${lang}_ClaimchkBox}
    Take Screenshot     ClaimDetailsPage
    Sleep    1s
    Click Element    ${${platformName}_${lang}_nextBtn}


Select CheckIN and CheckOut Date
    @{checkinandcheckoutdatevalue}    Split String    ${CheckINAndCheckOutDate}    -
    ${checkinDate}    Get From List    ${checkinandcheckoutdatevalue}    0
    ${checkoutDate}    Get From List    ${checkinandcheckoutdatevalue}    1
    @{checkindatevalues}    Split String    ${checkinDate}
    ${checkinday}    Get From List    ${checkindatevalues}    0
    ${checkinmonth}    Get From List    ${checkindatevalues}    1
    ${checkinmonthsubstring}    Get Substring    ${checkinmonth}    0    3
    ${checkinyear}    Get From List    ${checkindatevalues}    2

    &{dict}    Get Element Rect    ${${platformName}_${lang}_currentmonthandyear}
    ${x}    Get From Dictionary    ${dict}    x
    ${y}    Get From Dictionary    ${dict}    y
    ${x}    Evaluate    ${x}+156    # 82
    ${x}    Convert To Integer    ${x}
    ${y}    Evaluate    ${y}+24    # 659
    ${y}    Convert To Integer    ${y}
    Click Element At Coordinates    ${x}    ${y}
    ${givenyearvalue}    Get Element Attribute    ${${platformName}_${lang}_currentYear}    attribute=value
    ${LoopValue}    Evaluate    int(${givenyearvalue})-int(${checkinyear})
    Log To Console    ${LoopValue}

    FOR    ${counter}    IN RANGE    0    ${LoopValue}
        Log    ${counter}
        IF    ${givenyearvalue} >= ${LoopValue}
            Click Element    ${${platformName}_${lang}_PreviousyearArrow}
        ELSE
            Click Element    ${${platformName}_${lang}_nextyearArrow}
        END
    END
    ${iOS_MonthString}    Set Variable    chain=**/XCUIElementTypeOther[`label == '${checkinmonthsubstring}'`]
    ${Android_MonthString}    Set Variable    xpath=//android.widget.TextView[@text='${checkinmonthsubstring}']
    ${iOS_CheckinDate}    Set Variable    chain=**/XCUIElementTypeButton[`label CONTAINS '${checkinDate}'`]
    ${Android_CheckinDate}    Set Variable    xpath=//android.widget.TextView[@text='${checkinday}']
    ${iOS_CheckoutDate}    Set Variable    chain=**/XCUIElementTypeButton[`label CONTAINS '${checkoutDate}'`]
    ${Android_CheckoutDate}    Set Variable    xpath=//android.widget.TextView[@text='${checkoutDate}']
    Click Element    ${${platformName}_MonthString}
    Sleep    2s
    Click Element    ${${platformName}_CheckinDate}
    # checkout date selection

    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${platformName}_CheckoutDate}
    ...    timeout=5s
    IF    '${status}' == 'True'
        Click Element    ${${platformName}_CheckoutDate}
    ELSE
        &{dict}    Get Element Rect    ${${platformName}_${lang}_currentmonthandyear}
        ${x}    Get From Dictionary    ${dict}    x
        ${y}    Get From Dictionary    ${dict}    y
        ${x}    Evaluate    ${x}+156    # 82
        ${x}    Convert To Integer    ${x}
        ${y}    Evaluate    ${y}+22    # 659
        ${y}    Convert To Integer    ${y}
        Click Element At Coordinates    ${x}    ${y}
        @{checkoutdatevalues}    Split String    ${checkoutDate}
        ${checkoutday}    Get From List    ${checkoutdatevalues}    0
        ${checkoutmonth}    Get From List    ${checkoutdatevalues}    1
        ${checkoutmonthsubstring}    Get Substring    ${checkoutmonth}    0    3
        ${checkoutyear}    Get From List    ${checkoutdatevalues}    2
        ${givenyearvalue}    Get Element Attribute    ${${platformName}_${lang}_currentYear}    attribute=value
        ${LoopValue}    Evaluate    int(${givenyearvalue})-int(${checkoutyear})
        Log To Console    ${LoopValue}
        IF    ${LoopValue}<0
            WHILE    '${givenyearvalue}' != '${checkoutyear}'
                Click Element    ${${platformName}_${lang}_nextyearArrow}
                Sleep    1s
                ${givenyearvalue}    Get Element Attribute    ${${platformName}_${lang}_currentYear}    attribute=value
            END
        ELSE
            FOR    ${counter}    IN RANGE    0    ${LoopValue}
                Log    ${counter}
                IF    ${givenyearvalue} >= ${LoopValue}
                    Click Element    ${${platformName}_${lang}_PreviousyearArrow}
                ELSE
                    Click Element    ${${platformName}_${lang}_nextyearArrow}
                END
            END
        END
        Click Element    ${${platformName}_MonthString}
        Sleep    2s
        Click Element    ${${platformName}_CheckoutDate}
    END

