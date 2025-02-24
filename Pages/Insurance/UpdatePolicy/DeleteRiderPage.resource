*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     Dialogs
Library     ../../Qrace/QraceHelper.py
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/DeleteRiderPageObjects.resource


*** Keywords ***
Delete rider(s)
    Sleep   5s
#    Switch Window    new
#    Wait Until Element Is Visible    ${${platformName}_${lang}_SurrenderCancel}    timeout=30s
    Take Screenshot    Rider Page
#    SwipePage
#    SwipePage
#    Take Screenshot    Rider Page
#    Select Policy
#    Wait Until Element Is Visible    ${${platformName}_${lang}_yourpayoutMethodText}    timeout=10s
#    Take Screenshot    Rider Page
#    # select rider to delete
#    IF    '${Delete_Rider_Name}' != ''
#        ${Android_EN_SelectRider}    Set Variable    xpath=//android.widget.TextView[@text='${Delete_Rider_Name}'][1]
#        ${iOS_EN_SelectRider}    Set Variable
#        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${Delete_Rider_Name}'`][-1]
#    ELSE
#        ${Android_EN_SelectRider}    Set Variable    xpath=//android.widget.TextView[@text='${Delete_Rider_Name}'][1]
#        ${iOS_EN_SelectRider}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS "Insured"`][-1]
#    END
#    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_SelectRider}
#    Wait Until Element Is Visible    ${${platformName}_${lang}_SelectRider}
#    ${RiderName}    Get Text    ${${platformName}_${lang}_SelectRider}
#    Click Element    ${${platformName}_${lang}_SelectRider}
#    Take Screenshot    Selected Rider
#    ${status}    Run Keyword And Return Status
#    ...    Wait Until Element Is Visible
#    ...    ${${platformName}_${lang}_PaymentMethod_Option}
#    ...    timeout=5s
#    IF    '${status}'=='True'
#        Log To Console    addPayment Method
#        Click Element    ${${platformName}_${lang}_PaymentMethod_Option}
#        ${sOutput}    Run Keyword And Ignore Error    Add Payment Methods
#        IF    ${sOutput} != ('PASS', None)
#            ${failure_reason}    Fetch Reason    ${sOutput}
#            RETURN    ${failure_reason}
#        END
#    END
#
#    Take Screenshot    Delete Rider Page
#    SwipePage
#    # Previous OTP from DB
#    Get Details from DB
#    ${Previous_OTP}    Set Variable    ${OTPNumber}
#    Set Global Variable    ${Previous_OTP}
#    Click Element    ${${platformName}_${lang}_SubmitButton}
#    # enter otp
#    ${sOutput}    Run Keyword And Ignore Error
#    ...    Insert OTP
#    ...    ${Transaction_OTP_Source}
#    ...    ${Transaction_OTP_Expiry_Flag}
#    ...    ${Transaction_OTP_Resend_Flag}
#    IF    ${sOutput} != ('PASS', None)
#        Take Screenshot    Error Screenshot
#        ${failure_reason}    Fetch Reason    ${sOutput}
#        RETURN    ${failure_reason}
#    END
#
##    Sleep    90s
#    Take Screenshot    Transaction_OTP_Page
##    Wait Until Element Is Visible    ${${platformName}_${lang}_serviceRequestTransaction}    timeout=180s
#    ${status}    Run Keyword And Return Status
#    ...    Wait Until Element Is Visible
#    ...    ${${platformName}_${lang}_Thank_you_message}
#    ...    timeout=2s
#    IF    '${status}' == 'True'
#        Set Calc VP With Source And Original Values
#        ...    Thanks Page Present
#        ...    true
#        ...    ${status}
#        ...    Static
#        ...    Omne Application
#        ...    true
#        ...    ${status}
#    END
#    Take Screenshot    Submission Thanks Page
#    Sleep    2s
#    # New All Done Confirmation Page
#    ${sOutput}    Run Keyword And Ignore Error    Check Transaction Status
#    IF    ${sOutput} != ('PASS', None)
#        Take Screenshot    Update Policy
#        ${failure_reason}    Fetch Reason    ${sOutput}
#        RETURN    ${failure_reason}
#    END
##    Click Element    ${${platformName}_${lang}_serviceRequestTransaction}
#    Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=20s
#    Click Element    ${${platformName}_${lang}_SeeAll}
#    ${sOutput}    Run Keyword And Ignore Error    Capture Delete Rider Transaction Details for ${platformName}    Pre
#    IF    ${sOutput} != ('PASS', None)
#        Take Screenshot    Error Screenshot
#        ${failure_reason}    Fetch Reason    ${sOutput}
#        RETURN    ${failure_reason}
#    END
#    Set Global Variable    ${result}    Delete Rider flow Successful for ${Policy_No}

    Set Global Variable    ${result}    Delete Rider flow Completed
#Capture Delete Rider Transaction Details for Android
#    [Arguments]    ${Transaction_Info}
#
#    ${Android_selectCurrentTransaction}    Set Variable
#    ...    xpath=(//android.widget.TextView[@text='${current_month}']/following-sibling::android.widget.TextView[@text='${current_day}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Delete rider(s)'])[1]
#    Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction}    timeout=300s
#    Take Screenshot    Transaction Page
#    ${transactionstatus}    Get Text
#    ...    xpath=(//android.widget.TextView[@text='${current_month}']/following-sibling::android.widget.TextView[@text='${current_day}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Delete rider(s)']/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]
#    ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
#    ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
#    IF    '${mTransactionstatus}' == 'Completed'
#        ${mTransactionstatus}    Set Variable    Approve
#    END
#
#    # capture transaction detail
#    Click Element    ${${platformName}_selectCurrentTransaction}
#    Sleep    6s
#    Take Screenshot    Delete Rider Transaction Details
#    # rider to delete
#    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_RdierToDelete}
#    Wait Until Element Is Visible    ${${platformName}_${lang}_RdierToDelete}    timeout=4s
#    ${VP_ridertodelete}    Get Text    ${${platformName}_${lang}_RdierToDelete}
#
#    # payout details
#    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_Bank_AccountNo_VP}
#    Wait Until Element Is Visible    ${${platformName}_${lang}_Bank_AccountNo_VP}    timeout=4s
#    ${accountnumber}    Get Text    ${${platformName}_${lang}_Bank_AccountNo_VP}
#    ${BankName}    Get Text    ${${platformName}_${lang}_BankName_VP}
#    ${massagedaccnumber}    Get Substring    ${accountnumber.strip()}    -4
#
#    Log To Console    Massaged acc no : ${massagedaccnumber}
##    IF    '${BranchName}' != '${EMPTY}'
##    ${branchname}    Get From List    ${accdetailssplit}    1
##    IF    '${Transaction_Info}' == 'Pre'
##    Set Calc VP Expected Result With Original And Source    Bank Branch Name    ${branchname.strip()}    ${branchname.strip()}    Omne_TransactionPage
##    ELSE IF    '${Transaction_Info}' == 'Post'
##    Set Calc VP Actual Result With Original And Source    Post_Transaction Bank Branch Name    ${branchname.strip()}    ${branchname.strip()}    Omne_TransactionPage
##    END
##    END
#    IF    '${Transaction_Info}' == 'Pre'
#        Set Calc VP Expected Result With Original And Source
#        ...    Rider to delete
#        ...    ${VP_ridertodelete.strip()}
#        ...    ${VP_ridertodelete.strip()}
#        ...    Omne_TransactionPage
#        Set Calc VP Expected Result With Original And Source
#        ...    Transaction_Status
#        ...    ${mTransactionstatus.strip()}
#        ...    ${mTransactionstatus.strip()}
#        ...    Omne_TransactionPage
#        Set Calc VP Expected Result With Original And Source
#        ...    Bank Name
#        ...    ${BankName}
#        ...    ${BankName}
#        ...    Omne_TransactionPage
#        Set Calc VP Expected Result With Original And Source
#        ...    Bank Account Number
#        ...    ${massagedaccnumber}
#        ...    ${accountnumber}
#        ...    Omne_TransactionPage
#    ELSE IF    '${Transaction_Info}' == 'Post'
#        Set Calc VP Actual Result With Original And Source
#        ...    Post_Transaction Rider to delete
#        ...    ${VP_ridertodelete.strip()}
#        ...    ${VP_ridertodelete.strip()}
#        ...    Omne_TransactionPage
#        Set Calc VP Actual Result With Original And Source
#        ...    Post_Transaction Bank Name
#        ...    ${BankName}
#        ...    ${BankName}
#        ...    Omne_TransactionPage
#        Set Calc VP Actual Result With Original And Source
#        ...    Post_Transaction Bank Account Number
#        ...    ${massagedaccnumber}
#        ...    ${accountnumber}
#        ...    Omne_TransactionPage
#        Wait Until Element Is Visible    ${${platformName}_${lang}_CompletionDate_VP}
#        ${Completion_Date}    Get Text    ${${platformName}_${lang}_CompletionDate_VP}
#        Set Calc VP Actual Result With Original And Source
#        ...    Completion Date
#        ...    ${Completion_Date.strip()}
#        ...    ${Completion_Date}
#        ...    Omne_TransactionPage
#    END
#
#Capture Delete Rider Transaction Details for iOS
#    [Arguments]    ${Transaction_Info}
##    ${Android_selectCurrentTransaction}    Set Variable    xpath
#    IF    '${Transaction_Info}'== 'Pre'
#        ${iOS_selectCurrentTransaction1}    Set Variable
#        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Delete rider(s)' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
#        ${iOS_transactionstatusobject}    Set Variable
#        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Delete rider(s)' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
#    ELSE IF    '${Transaction_Info}'== 'Post'
#        ${iOS_selectCurrentTransaction1}    Set Variable
#        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Delete rider(s) ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
#        ${iOS_transactionstatusobject}    Set Variable
#        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Delete rider(s) ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
#    END
#    Sleep    3s
#    Wait Until Element Is Visible    ${${platformName}_${lang}_TransactionServiceRequest}   timeout=20s
#    Click Element    ${${platformName}_${lang}_TransactionServiceRequest}
##    Log    ${${platformName}_selectCurrentTransaction1}
#    RefreshPage
#    Sleep    5s
#    Scroll Till Transaction Is Visible    ${${platformName}_selectCurrentTransaction1}
#    Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction1}    timeout=300s
#    Take Screenshot    Transaction Page
#    ${transactionstatus}    Get Text    ${${platformName}_transactionstatusobject}
#    @{transactionstatusdetail}    Split String    ${transactionstatus}    Policy no
#    ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
#    @{transactionstatusdetail}    Split String    ${transactionstatus}    Delete rider(s)
#    ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
#    ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
#    ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
#    IF    '${mTransactionstatus}' == 'Completed'
#        ${mTransactionstatus}    Set Variable    Approve
#    END
#    Log    ${${platformName}_selectCurrentTransaction1}
#    Click Element    ${${platformName}_selectCurrentTransaction1}
#    ${status}    Run Keyword And Return Status
#    ...    Wait Until Element Is Visible
#    ...    ${${platformName}_${lang}_DeleteRiderTransactionDetails}
#    ...    timeout=5s
#    IF    '${status}' != 'True'    SwipePage
#    Take Screenshot    Delete Rider Transaction Detail
#    ${VP_TransactionDetailedData}    Get Text    ${${platformName}_${lang}_DeleteRiderTransactionDetails}
#
#    @{VP_transactiondetailsplit}    Split String    ${VP_TransactionDetailedData}    Policy applied
#
#    # deleterider
#    ${VP_getdataridertodelete}    Get From List    ${VP_transactiondetailsplit}    1
#    @{VP_ridertodelete}    Split String    ${VP_getdataridertodelete}    Refund method
#    ${RidertoDelete}    Get From List    ${VP_ridertodelete}    0
#    @{RidertoDelete}    Split String    ${RidertoDelete}    Rider to delete
#    ${RidertoDelete}    Get From List    ${RidertoDelete}    1
#
#    # payout details
#    ${accountdetails}    Get From List    ${VP_ridertodelete}    1
#    @{accdetailssplit}    Split String    ${accountdetails}
#    ${accountnumber}    Get From List    ${accdetailssplit}    0
#    ${massagedaccnumber}    Get Substring    ${accountnumber.strip()}    -4
#    Log To Console    Massaged acc no : ${massagedaccnumber}
#    ${BankNamedata}    Remove String    ${accountdetails}    ${accountnumber}
#    ${BankNamedata}    Strip String    ${BankNamedata}
#
#    IF    '${Transaction_Info}' == 'Pre'
#        Set Calc VP Expected Result With Original And Source
#        ...    Transaction_Status
#        ...    ${mTransactionstatus.strip()}
#        ...    ${mTransactionstatus.strip()}
#        ...    Omne_TransactionPage
#        Set Calc VP Expected Result With Original And Source
#        ...    Rider to delete
#        ...    ${RidertoDelete.strip()}
#        ...    ${RidertoDelete.strip()}
#        ...    Omne_TransactionPage
#        Set Calc VP Expected Result With Original And Source
#        ...    Bank Name
#        ...    ${BankNamedata.strip()}
#        ...    ${BankNamedata.strip()}
#        ...    Omne_TransactionPage
#        Set Calc VP Expected Result With Original And Source
#        ...    Bank Account Number
#        ...    ${massagedaccnumber}
#        ...    ${accountnumber}
#        ...    Omne_TransactionPage
#    ELSE IF    '${Transaction_Info}' == 'Post'
#        ${BankNamedata}    Split String    ${BankNamedata}    Reason(s)
#        ${BankNamedata}    Get From List    ${BankNamedata}    0
#        @{VP_TransactionDetailedData}    Split String    ${VP_TransactionDetailedData}    date
#        ${VP_declineDate}    Get From List    ${VP_TransactionDetailedData}    1
#        Set Calc VP Actual Result With Original And Source
#        ...    Post_Transaction Rider to delete
#        ...    ${RidertoDelete.strip()}
#        ...    ${RidertoDelete.strip()}
#        ...    Omne_TransactionPage
#        Set Calc VP Actual Result With Original And Source
#        ...    Post_Transaction Bank Name
#        ...    ${BankNamedata.strip()}
#        ...    ${BankNamedata.strip()}
#        ...    Omne_TransactionPage
#        Set Calc VP Actual Result With Original And Source
#        ...    Post_Transaction Bank Account Number
#        ...    ${massagedaccnumber}
#        ...    ${accountnumber}
#        ...    Omne_TransactionPage
#        Set Calc VP Actual Result With Original And Source
#        ...    Completion Date
#        ...    ${VP_declineDate.strip()}
#        ...    ${VP_declineDate.strip()}
#        ...    Omne Transaction Page
#    END
