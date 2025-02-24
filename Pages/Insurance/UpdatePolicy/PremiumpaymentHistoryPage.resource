*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     ../../Qrace/QraceHelper.py
Library     ../../DBQuery/DBQuerySelect.py
Library     ../../DBQuery/DBQuerySelect.py
Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/PremiumpaymentHistoryPageObjects.resource


*** Keywords ***
Premium payment history
    TRY
        #selet the policy
        Select Policy
        Wait Until Element Is Visible       ${${platformName}_${lang}_NextButton}       timeout=10s
        Take Screenshot    Payment History Policy Select Page
        Click Element    ${${platformName}_${lang}_NextButton}
        Wait Until Element Is Visible    ${${platformName}_${lang}_PaymentHistoryTitleText}     timeout=5s
        Take Screenshot    Payment History Page

        #fetch total count of  History list
        ${PaymentHistoryList}      Get Webelements      ${${platformName}_${lang}_PaymentHistoryList}
        ${HistoryListcount}     Get Length     ${PaymentHistoryList}

        #fetch Details of premium history
        FOR    ${counter}    IN RANGE    1    ${HistoryListcount}+1
            Log    ${counter}
        ${VP_PaymentHistory_ReceiptNumber}  Get Text    chain=**/XCUIElementTypeOther[`name BEGINSWITH "Receipt number:"`][-${counter}]/XCUIElementTypeStaticText[-1]
        ${VP_PaymentHistory_PaymentDueDate}  Get Text    chain=**/XCUIElementTypeOther[`name BEGINSWITH "Due date:"`][-${counter}]/XCUIElementTypeStaticText[-1]
        ${VP_PaymentHistory_PaymentAmount}  Get Text    chain=**/XCUIElementTypeOther[`name BEGINSWITH "Amount:"`][-${counter}]/XCUIElementTypeStaticText[-1]
        ${VP_PaymentHistory_PaymentAmount}      Remove String    ${VP_PaymentHistory_PaymentAmount}     ,
        ${VP_PaymentHistory_PaymentAmount}      Remove String    ${VP_PaymentHistory_PaymentAmount}     THB
        Set Calc VP Actual Result With Original And Source    Receipt Number_${counter}    ${VP_PaymentHistory_ReceiptNumber.strip()}    ${VP_PaymentHistory_ReceiptNumber.strip()}    OMNE Payment History Page
        Set Calc VP Actual Result With Original And Source    Due Date_${counter}    ${VP_PaymentHistory_PaymentDueDate.strip()}    ${VP_PaymentHistory_PaymentDueDate.strip()}    OMNE Payment History Page
        Set Calc VP Actual Result With Original And Source    Payment Amount_${counter}    ${VP_PaymentHistory_PaymentAmount.strip()}    ${VP_PaymentHistory_PaymentAmount.strip()}    OMNE Payment History Page
        END
         #fetch Details of premium history from DB
        Get Policy Payment History Details from DB

        Set Global Variable    ${result}    View Premium Payment History for Policy No: ${Policy_No}
        ${actualResult}  Catenate    ${actualResult}     | FWD Insurance Flow of ${Insurance_Flow} Successful   : ${result}
        Set Global Variable    ${actualResult}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END






Get Policy Payment History Details from DB
    ${ExpectedSource}    Set Variable     DB Query
    ${HistList}    Run Keyword
    ...    Get Premium Payment History Detail from DB
    ...    ${dbhostname}
    ...    ${dbusername}
    ...    ${dbpassword}
    ...    ${dbport}
    ...    ${dbinstance}
    ...    ${Policy_No}
    ...    ${screenshotPath}
    Log    ${HistList}
    ${leng}    Get Length    ${HistList}
    Log    ${leng}
    ${list0}    Get From List    ${HistList}    0
    Log    ${list0}
    ${index1}    Get Index From List    ${list0}    ReceiptNo
    Log    ${index1}
    ${index2}    Get Index From List    ${list0}    DueDate
    Log    ${index2}
    ${index3}    Get Index From List    ${list0}    Amount
    Log    ${index3}
    FOR    ${counter}    IN RANGE    1    ${leng}
        Log    ${counter}
        ${list}    Get From List    ${HistList}    ${counter}

        ${ReceiptNumber}    Set Variable    ${list}[${index1}]
        ${ReceiptNumber}    Strip String    ${ReceiptNumber}

        ${Duedate}    Set Variable    ${list}[${index2}]
         ${mvp_Duedate}    Convert Date    ${Duedate}    result_format=%d %b %Y

        ${PaymentAmount}    Set Variable    ${list}[${index3}]
        ${PaymentAmount}      Evaluate    "{:.2f}".format(${PaymentAmount})
        Set Calc VP Expected Result With Original And Source    Receipt Number_${counter}    ${ReceiptNumber.strip()}    ${ReceiptNumber.strip()}    ${ExpectedSource}
        Set Calc VP Expected Result With Original And Source    Due Date_${counter}    ${mvp_Duedate.strip()}    ${mvp_Duedate.strip()}    ${ExpectedSource}
        Set Calc VP Expected Result With Original And Source    Payment Amount_${counter}    ${PaymentAmount}    ${PaymentAmount}    ${ExpectedSource}
    END