*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     ../../Qrace/QraceHelper.py
Library     ../../DBQuery/DBQuerySelect.py
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/BenefitPayoutageObjects.resource


*** Keywords ***
Benefit payout
    TRY
        Select Policy
        Take Screenshot    Benefit Payout History
        Click Element    ${${platformName}_${lang}_NextButton}
        ${status}   Run Keyword And Return Status  Wait Until Element Is Visible    ${${platformName}_${lang}_SelectYearDropdown}       timeout=5s
        Take Screenshot    Payout History List
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_SelectYearDropdown}
            Wait Until Element Is Visible    ${${platformName}_${lang}_SelectMaxyear}           timeout=2s
            Take Screenshot    select year dropdown
            Click Element    ${${platformName}_${lang}_SelectMaxyear}
            Take Screenshot    Payout History List
        END
    
        #capture total list and check count
        ${TotalHistoryList}     Get Webelements    ${${platformName}_${lang}_BenefitPayoutHistoryList}
        ${TotalpyoutCount}      Get Length    ${TotalHistoryList}
    
        #capture data of each payout from the list
        FOR    ${counter}    IN RANGE    1    ${TotalpyoutCount}-1
            Log    ${counter}
            #banktype and status
            ${BenefitTypeAndStatus}     Get Text   chain=**/XCUIElementTypeOther[`name == "benefit-payout-flatlist"`]/XCUIElementTypeScrollView/XCUIElementTypeOther[${counter}]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]
            @{splitbankData}    Split String    ${BenefitTypeAndStatus}
            ${BankPayoutStatus}     Get From List    ${splitbankData}    -1
            ${BenefitTypeValue}     Remove String    ${BenefitTypeAndStatus}    ${BankPayoutStatus}
            IF   '${BankPayoutStatus}' == 'Failed'
                 ${mBankPayoutStatus}   Set Variable    Fail
            END
            Set Calc VP Actual Result With Original And Source    PayoutStatus_${counter}    ${mBankPayoutStatus.strip()}    ${BankPayoutStatus.strip()}    Omne_payoutHistory_Page
            Set Calc VP Actual Result With Original And Source    BenefitType_${counter}    ${BenefitTypeValue.strip()}    ${BenefitTypeValue.strip()}    Omne_payoutHistory_Page
    
            #Payout method and amount
            ${PayoutMethodAndAmount}    Get Text    chain=**/XCUIElementTypeOther[`name == "benefit-payout-flatlist"`]/XCUIElementTypeScrollView/XCUIElementTypeOther[${counter}]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]
            @{split_MethodandAmount}    Split String    ${PayoutMethodAndAmount}    THB
            ${payoutAmountValue}    Get From List    ${split_MethodandAmount}    1
            ${payoutAmountValue}    Remove String    ${payoutAmountValue}   ,
            ${payoutMethodValue}    Get From List     ${split_MethodandAmount}    0
            Set Calc VP Actual Result With Original And Source    Payout_Amount_${counter}    ${payoutAmountValue.strip()}     ${payoutAmountValue.strip()}    Omne_payoutHistory_Page
            Set Calc VP Actual Result With Original And Source    Payout_Method_${counter}    ${payoutMethodValue.strip()}     ${payoutMethodValue.strip()}    Omne_payoutHistory_Page
    
            #bank acc details
            ${PayoutBankAccDetails}     Get Text    chain=**/XCUIElementTypeOther[`name == "benefit-payout-flatlist"`]/XCUIElementTypeScrollView/XCUIElementTypeOther[${counter}]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]
            @{splitpayoutBankAccDetails}        Split String    ${PayoutBankAccDetails}
            ${payoutBankNameValue}      Get From List     ${splitpayoutBankAccDetails}    0
            ${PayoutDateValue}      Remove String    ${PayoutBankAccDetails}     ${payoutBankNameValue}
            ${payoutBankAccNumber}      Get From List    ${splitpayoutBankAccDetails}    1
            ${mpayoutBankAccNumber}     Get Substring       ${payoutBankAccNumber}      -4
            ${PayoutDateValue}      Remove String    ${PayoutDateValue}     ${payoutBankAccNumber}
            Set Calc VP Actual Result With Original And Source    Payout_BankName_${counter}    ${payoutBankNameValue.strip()}     ${payoutBankNameValue.strip()}    Omne_payoutHistory_Page
            Set Calc VP Actual Result With Original And Source    Payout_BankAcc_Number_${counter}    ${mpayoutBankAccNumber.strip()}     ${payoutBankAccNumber.strip()}    Omne_payoutHistory_Page
            Set Calc VP Actual Result With Original And Source    Payout_Date_${counter}    ${PayoutDateValue.strip()}     ${PayoutDateValue.strip()}    Omne_payoutHistory_Page
    
        END
        Get Benefit Payout History from DB
        Set Global Variable    ${result}    Benefit Payout History for Policy No: ${Policy_No}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END
    

Get Benefit Payout History from DB
    TRY
         #Read The  Benefit Payout Details from BD
         ${benefitpayoutdf}    Run Keyword
        ...    Get Selected Policy BenefitPayout History from DB
        ...    ${dbhostname}
        ...    ${dbusername}
        ...    ${dbpassword}
        ...    ${dbport}
        ...    ${dbinstance}
        ...    ${Policy_No}
        ...    ${screenshotPath}
        Log    ${benefitpayoutdf}

        ${leng}    Get Length    ${benefitpayoutdf}
        Log    ${leng}
        ${list0}    Get From List    ${benefitpayoutdf}    0
        Log    ${list0}
        ${index1}    Get Index From List    ${list0}    BenefitTypeDisplay
        Log    ${index1}
        ${index2}    Get Index From List    ${list0}    BenefitAmount
        Log    ${index2}
        ${index3}    Get Index From List    ${list0}    PayoutMethodDisplay
        Log    ${index3}
        ${index4}    Get Index From List    ${list0}    BankName
        Log    ${index4}
        ${index5}    Get Index From List    ${list0}    BankAccountNumber
        Log    ${index5}
        ${index6}    Get Index From List    ${list0}    PayoutDate
        Log    ${index6}
        ${index7}    Get Index From List    ${list0}    PayoutStatus
        Log    ${index7}
        FOR    ${counter}    IN RANGE    1    ${leng}
            Log    ${counter}
            ${list}    Get From List    ${benefitpayoutdf}    ${counter}
            ${ExpectedSource}    Set Variable    Benefit Payout DB Query
            ${BenefitTypeDisplay}    Set Variable    ${list}[${index1}]
            ${BenefitAmount}    Set Variable    ${list}[${index2}]
            ${PayoutMethodDisplay}    Set Variable    ${list}[${index3}]
            ${BankName}    Set Variable    ${list}[${index4}]
            ${BankAccountNumber}    Set Variable    ${list}[${index5}]
            ${BankAccountNumber}    AES Decrypt    ${key}    ${BankAccountNumber}
            ${mVPBankAccountNumber}     Get Substring       ${BankAccountNumber}    -4
            ${PayoutDate}    Set Variable    ${list}[${index6}]
            ${mVPPayoutDate}    Convert Date    ${PayoutDate}    result_format=%d %b %Y
            ${PayoutStatus}    Set Variable    ${list}[${index7}]
            #Set  Exepcted Values in Qrace
            Set Calc VP Expected Result With Original And Source    BenefitType_${counter}    ${BenefitTypeDisplay}    ${BenefitTypeDisplay}    ${ExpectedSource}
            Set Calc VP Expected Result With Original And Source    Payout_Amount_${counter}    ${BenefitAmount}    ${BenefitAmount}    ${ExpectedSource}
            Set Calc VP Expected Result With Original And Source    Payout_Method_${counter}    ${PayoutMethodDisplay}    ${PayoutMethodDisplay}    ${ExpectedSource}
            Set Calc VP Expected Result With Original And Source    Payout_BankName_${counter}    ${BankName}    ${BankName}    ${ExpectedSource}
            Set Calc VP Expected Result With Original And Source    Payout_BankAcc_Number_${counter}    ${mVPBankAccountNumber}    ${BankAccountNumber}    ${ExpectedSource}
            Set Calc VP Expected Result With Original And Source    Payout_Date_${counter}    ${mVPPayoutDate}    ${mVPPayoutDate}    ${ExpectedSource}
            Set Calc VP Expected Result With Original And Source    PayoutStatus_${counter}    ${PayoutStatus}    ${PayoutStatus}    ${ExpectedSource}
    END

    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Get Benefit Payout History from DB ${Insurance_Flow}
    END


    

