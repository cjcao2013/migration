*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     String
Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/PersonalDetailsPageObject.resource
Resource    ../Common/AddOTP.resource
Resource    ChnageAddress.resource
Resource    ChangeMobileAndEmailPage.resource
Resource    ChnageName.resource

*** Keywords ***
Personal details
    TRY
        ${Android_PersonalDetail_WhatChange}    Set Variable        xpath=//android.widget.TextView[contains(@text,'${PersonalDetails_WhatChange}')]
        ${iOS_PersonalDetail_WhatChange}    Set Variable            chain=**/XCUIElementTypeOther[`label CONTAINS '${PersonalDetails_WhatChange}'`][-1]
        ${Android_PolicyName}    Set Variable    xpath=//android.widget.TextView[@text='${Policy_Name}']
        ${iOS_PolicyName}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Policy_Name}'`][-1]
        ${Android_PolicyNo}    Set Variable    xpath=//android.widget.TextView[@text='${Policy_No}']
        ${iOS_PolicyNo}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Policy_No}'`][-1]
        ${iOS_CountryCode}    Set Variable    chain=**/XCUIElementTypeOther[`label == "${CountryCode}"`][3]
        IF    '${Transaction_Page_GUI}' == 'Yes'
            ${status}    Run Keyword And Return Status   Element Should Be Visible      ${${platformName}_${lang}_What_Change_Txt}
            IF    '${status}' == 'True'
                Set Calc VP With Source And Original Values     What_would_like_to_change_Options_Present   true    ${status}      Static  OMNE_Applicatio True   ${status}
            END
            ${status}    Run Keyword And Return Status      Element Should Be Visible   ${${platformName}_${lang}_Address_Txt}
            IF    '${status}' == 'True'
                Set Calc VP With Source And Original Values     Address_Options_Present    true    ${status}   Status   OMNE_Applicatio   True   ${status}
            END
            ${status}    Run Keyword And Return Status      Element Should Be Visible     ${${platformName}_${lang}_Email_Mobile_Txt}
            IF    '${status}' == 'True'
                Set Calc VP With Source And Original Value      Email_Mobile_Options_Presen  true   ${status}   Static  OMNE_Application    True    ${status}
            END
            ${status}    Run Keyword And Return Status      Element Should Be Visible   ${${platformName}_${lang}_Name_Martial_Status_Txt}
            IF    '${status}' == 'True'
                Set Calc VP With Source And Original Values     Name_Martial_Status_Options_Present     true   ${status}   Static  OMNE_Application    True    ${status}
            END
        END
        Take Screenshot    Personal_Details_Page
        IF    '${PersonalDetails_WhatChange}' == 'MobileNo' and '${platformName}' == 'iOS'
            Click Element    chain=**/XCUIElementTypeOther[`label CONTAINS 'mobile'`][-1]
        ELSE
            ${iOS_Select_Personal_Detail_FLow}      Set Variable        chain=**/XCUIElementTypeOther[`label CONTAINS '${PersonalDetails_WhatChange}'`][-1]
            ${Android_Select_Personal_Detail_FLow}      Set Variable        xpath= xpath=//android.widget.TextView[contains(@text,'${PersonalDetails_WhatChange}')]
            Click Element               ${${platformName}_Select_Personal_Detail_FLow}
        END
        IF    '${PersonalDetails_WhatChange}' == 'Mailing address'
            Address Change
        ELSE IF    '${PersonalDetails_WhatChange}' == 'Name'
            Name Change
        ELSE IF    '${PersonalDetails_WhatChange}' == 'Email' or '${PersonalDetails_WhatChange}' == 'MobileNo'
            Mobile and Email Change
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END


