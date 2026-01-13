*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     DateTime
Library     QraceHelper
Resource    ../../../CustomLibraries/common.robot
Resource    ../Common/CommonMethod.resource
Resource    ../../../PageObjects/Insurance/ViewTransactions/TransactionDetailsPageObjects.resource
Resource    ../UpdatePolicy/PaymentMethodDetailsPage.resource
Resource    ../../OWB/OWBInquiryPage.resource
Resource    ../../../Pages/Insurance/UpdatePolicy/DeleteRiderPage.resource
Resource    ../../../Pages/Insurance/UpdatePolicy/PaymentFrequencyPage.resource
Resource    ../../../Pages/Insurance/UpdatePolicy/SurrenderPolicyPage.resource
Resource    ../../../Pages/Insurance/UpdatePolicy/PersonalDetailsPage.resource
Resource    ../../../Pages/Insurance/UpdatePolicy/FreelookupPage.resource
Resource    ../../../Pages/Insurance/UpdatePolicy/SwitchFundsPage.resource
Resource    ../../../Pages/Insurance/UpdatePolicy/RecurringPaymentPage.resource
Resource    ../../../Pages/Insurance/UpdatePolicy/ChequeCancellationPage.resource
Resource    PendingDetialsPage.resource

*** Variables ***
${VP_Transaction_Status}    ${EMPTY}
${CompleteStatus_List}      ${EMPTY}


*** Keywords ***
Transaction after Complete
    Set Library Search Order    AppiumLibrary       SeleniumLibrary
    TRY
        IF    '${Transaction_After_OWB_Flag}' == 'Yes'
            Set Global Variable    ${VP_Transaction_Status}
            Wait Until Element Is Visible    ${${platformName}_${lang}_Transaction_BackButton}   timeout=20s
            Click Element    ${${platformName}_${lang}_Transaction_BackButton}
            Sleep    3s
            Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=20s
            Click Element    ${${platformName}_${lang}_SeeAll}
            Take Screenshot    Transaction_Page
            Wait Until Element Is Visible     ${${platformName}_${lang}_TransactionServiceRequest}    timeout=50s
            Click Element    ${${platformName}_${lang}_TransactionServiceRequest}
            Sleep    10s
            Take Screenshot    Transaction_Page
            IF    '${CaseStatus}' == 'Decline'
                ${MCaseStatus}    Set Variable    Declined
                Set Global Variable    ${MCaseStatus}
            ELSE IF    '${CaseStatus}' == 'Approve'
                ${MCaseStatus}    Set Variable    Completed
                Set Global Variable    ${MCaseStatus}
            ELSE IF    '${CaseStatus}' == 'Pending'
                ${MCaseStatus}    Set Variable    Action
                Set Global Variable    ${MCaseStatus}
            END
            ${result}    Set Variable    ${SPACE}
            Set Global Variable    ${result}
            Run Keyword    Transaction ${Update_Policy_Module}
            @{Transaction_Status_List}    Split String    ${CompleteStatus_List}    Policy no
            Log To Console    Test1
            Take Screenshot    Transaction_Page
            ${TransactionStatus_list2}    Get From List    ${Transaction_Status_List}    0
            Log To Console    Test2
            @{TransactionStatus_list2}    Split String    ${TransactionStatus_list2}
            Log To Console    Test3
            ${Count}    Get Length    ${TransactionStatus_list2}
            ${Count}    Evaluate    ${Count} - 1
            ${VP_Transaction_Status}    Get From List    ${TransactionStatus_list2}    ${Count}
            Log To Console    Test4
            Log To Console    Transaction_Status=${VP_Transaction_Status}
            Log To Console    ListCount=${Count}
            ${contains}    Run Keyword And Return Status    Should Contain    ${TransactionStatus_list2}    Action
            IF    '${VP_Transaction_Status}' == 'Completed'
                ${m_Vp}    Set Variable    Approve
            ELSE IF    '${VP_Transaction_Status}' == 'Declined'
                ${m_Vp}    Set Variable    Decline
            ELSE IF    '${contains}' == 'True'
                ${m_Vp}    Set Variable    Pending
            ELSE
                ${m_Vp}    Set Variable    ${VP_Transaction_Status}
            END
            IF    '${VP_Transaction_Status}' != ''
                Set Calc VP Actual Result With Original And Source
                ...    Transaction_Status_After_OPUS
                ...    ${m_Vp.strip()}
                ...    ${VP_Transaction_Status}
                ...    OMNE_TransactionPage
                Set Global Variable    ${VP_Transaction_Status}
                Set Global Variable    ${result}    Transaction Status After OWB : ${VP_Transaction_Status}
            ELSE
                ${result}    Set Variable    ${SPACE}
                Set Global Variable    ${result}
            END
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   Transaction After OPUS
    END

Transaction surrender policy
    ${Android_Selectposttransaction}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Surrender policy']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='${MCaseStatus}'])[1]
    ${iOS_Selectposttransaction}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Surrender policy ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    ${CompleteStatus_List}    Get Text    ${${platformName}_Selectposttransaction}
    Set Global Variable    ${CompleteStatus_List}
#    Click Element    ${${platformName}_Selectposttransaction}

    ${sOutput}    Run Keyword And Ignore Error    Capture Surrender Transaction Details for ${platformName}    Post
    IF    ${sOutput} != ('PASS', None)
        ${failure_reason}    Fetch Reason    ${sOutput}
        RETURN    ${failure_reason}
    END

Transaction Cheque cancellation
    ${iOS_Selectposttransaction}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Cheque cancellation request ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    ${Android_Selectposttransaction}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Cheque cancellation request']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='${MCaseStatus}'])[1]
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    ${CompleteStatus_List}    Get Text    ${${platformName}_Selectposttransaction}
    Set Global Variable    ${CompleteStatus_List}
    Run Keyword     Capture Cheque Cancellation Transaction Details for ${platformName}    Post


Transaction Cancel
    ${Android_Selectposttransaction}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Freelook cancellation']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='${MCaseStatus}'])[1]
    ${iOS_Selectposttransaction}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Freelook cancellation ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    ${CompleteStatus_List}    Get Text    ${${platformName}_Selectposttransaction}
    Set Global Variable    ${CompleteStatus_List}
#    Click Element    ${${platformName}_Selectposttransaction}

    ${sOutput}    Run Keyword And Ignore Error    Capture FLC Transaction Details for ${platformName}    Post
    IF    ${sOutput} != ('PASS', None)
        ${failure_reason}    Fetch Reason    ${sOutput}
        RETURN    ${failure_reason}
    END



Transaction frequency
    ${Android_Selectposttransaction}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of payment frequency']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='${MCaseStatus}'])[1]
    ${iOS_Selectposttransaction}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of payment frequency ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    ${CompleteStatus_List}    Get Text    ${${platformName}_Selectposttransaction}
    Set Global Variable    ${CompleteStatus_List}
#    Click Element    ${${platformName}_Selectposttransaction}

    ${sOutput}    Run Keyword And Ignore Error    Capture Payment Frequency Details For ${platformName}    Post
    IF    ${sOutput} != ('PASS', None)
        ${failure_reason}    Fetch Reason    ${sOutput}
        RETURN    ${failure_reason}
    END

Transaction Beneficiary(s) details
    ${Android_Selectposttransaction}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of beneficiary(s) details']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='${MCaseStatus}'])[1]
    ${iOS_Selectposttransaction}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of beneficiary(s) details ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    ${CompleteStatus_List}    Get Text    ${${platformName}_Selectposttransaction}
    Set Global Variable    ${CompleteStatus_List}
    Run Keyword    Capture Beneficiary Transaction Details for ${platformName}    Post

Transaction Delete rider(s)
    ${Android_Selectposttransaction}    Set Variable
    ...    xpath=//android.widget.TextView[@text='${current_month}']/following-sibling::android.widget.TextView[@text='${current_day}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Delete rider(s)']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='${MCaseStatus}']
    ${iOS_Selectposttransaction}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Delete rider(s) ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    ${CompleteStatus_List}    Get Text    ${${platformName}_Selectposttransaction}
    Set Global Variable    ${CompleteStatus_List}
#    Click Element    ${${platformName}_Selectposttransaction}

    ${sOutput}    Run Keyword And Ignore Error    Capture Delete Rider Transaction Details for ${platformName}    Post
    IF    ${sOutput} != ('PASS', None)
        ${failure_reason}    Fetch Reason    ${sOutput}
        RETURN    ${failure_reason}
    END

Transaction Partial withdrawal
      ${Android_Selectposttransaction}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Partial Withdrawal']/following-sibling::android.widget.TextView[@text='Policy no: ${Policy_No}']/preceding-sibling::android.view.ViewGroup//android.widget.TextView[@text='${MCaseStatus}'])[1]
    ${iOS_Selectposttransaction}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Partial Withdrawal ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    Sleep    5s
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    ${CompleteStatus_List}    Get Text    ${${platformName}_Selectposttransaction}
    Set Global Variable    ${CompleteStatus_List}
    Take Screenshot    Post Transaction Page
    Click Element    ${${platformName}_Selectposttransaction}
    Sleep    1s
    Run Keyword     Capture Partial Withdrawal Transaction detail after Owb for ${platformName}

Capture Partial Withdrawal Transaction detail after Owb for Android
    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_Transaction_Total_Estimated_Amount}
    ${Transaction_Total_Estimated_Amount}    Get Text    ${${platformName}_${lang}_Transaction_Total_Estimated_Amount}
    ${Transaction_Total_Estimated_Amount}    Remove String    ${Transaction_Total_Estimated_Amount}    THB${SPACE}
    ${Transaction_Massaged_Total_Estimated_Amount}    Remove String    ${Transaction_Total_Estimated_Amount}    ,
    ${Transaction_Massaged_Total_Estimated_Amount}    Evaluate
    ...    "{:.2f}".format(${Transaction_Massaged_Total_Estimated_Amount})
    Set Calc VP Actual Result With Original And Source
    ...    Post_Transaction_Total_Withdrawal_Amount
    ...    ${Transaction_Massaged_Total_Estimated_Amount}
    ...    ${Transaction_Massaged_Total_Estimated_Amount}
    ...    OMNE_View_Transaction

Capture Partial Withdrawal Transaction detail after Owb for iOS
    Log To Console    Post Transaction Detail
    Wait Until Element Is Visible    ${${platformName}_${lang}_Transaction_Total_Estimated_Amount}    timeout=30s
    ${VP_transactionDataDetails}    Get Text    ${${platformName}_${lang}_Transaction_Total_Estimated_Amount}
    @{VP_transactiondetailList}    Split String    ${VP_transactionDataDetails}    Policy no: ${policyno}
    ${VP_transactionDataDetails}    Get From List    ${VP_transactiondetailList}    1
    # Capture estimate withdrawal value
    @{EstimateWithdrawalValue}    Split String    ${VP_transactionDataDetails}    Please
    ${WithdrawalValue}    Get From List    ${EstimateWithdrawalValue}    0
    ${WithdrawalValue}    Split String    ${WithdrawalValue}    THB
    ${WithdrawalValue}    Get From List    ${WithdrawalValue}    1
    ${Transaction_Massaged_Total_Estimated_Amount}    Remove String    ${WithdrawalValue}    ,
    ${Review_Total_Estimated_Withdrawal_Amount}    Remove String    ${Review_Total_Estimated_Withdrawal_Amount}    ,
    ${Transaction_Massaged_Total_Estimated_Amount}    Evaluate
    ...    "{:.2f}".format(${Transaction_Massaged_Total_Estimated_Amount})

#    Set Calc VP With Source And Original Values    View_Transaction_Withdrawal_Amount    ${Review_Total_Estimated_Withdrawal_Amount}    ${Transaction_Massaged_Total_Estimated_Amount}    OMNE_Review_Withdrawal    OMNE_View_Transaction    ${Review_Total_Estimated_Withdrawal_Amount}    ${Transaction_Massaged_Total_Estimated_Amount}
    Set Calc VP Actual Result With Original And Source
    ...    Post_Transaction_Total_Withdrawal_Amount
    ...    ${Transaction_Massaged_Total_Estimated_Amount}
    ...    ${Transaction_Massaged_Total_Estimated_Amount}
    ...    OMNE_View_Transaction

Transaction Risk profile
      ${Android_Selectposttransaction}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of personal details']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='${MCaseStatus}'])[1]
    ${iOS_Selectposttransaction}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of personal details ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    ${CompleteStatus_List}    Get Text    ${${platformName}_Selectposttransaction}
    Set Global Variable    ${CompleteStatus_List}
    Run Keyword    Capture Risk Profile Transaction Details for ${platformName}    Post

Transaction Personal details
   ${Android_Selectposttransaction}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of personal details']/following-sibling::android.view.ViewGroup/android.widget.TextView[contains(@text,'${MCaseStatus}')])[1]
    ${iOS_Selectposttransaction}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of personal details ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    ${CompleteStatus_List}    Get Text    ${${platformName}_Selectposttransaction}
    Set Global Variable    ${CompleteStatus_List}
    IF    '${CaseStatus}' == 'Pending'
        ${iOS_pendingButton}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of personal details ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        ${Android_pendingButton}    Set Variable    xpath=//android.view.ViewGroup[@content-desc="Pending details"]
        Take Screenshot    Transaction Page

        Wait Until Element Is Visible        ${${platformName}_pendingButton}        timeout=30s
        Click Element    ${${platformName}_pendingButton}
        ${iOS_EN_newstatusobject}      Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of personal details In progress' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        ${Android_EN_newstatusobject}      Set Variable    xpath=(//android.widget.TextView[@text="${current_day}"]/following-sibling::android.widget.TextView[@text="${current_month}"]/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of personal details']/following-sibling::android.widget.TextView[contains(@text,'${Policy_No}')]/preceding-sibling::android.view.ViewGroup[2]/android.widget.TextView[contains(@text,'In progress')])[1]
        Pending Details     ${${platformName}_${lang}_newstatusobject}
        Set Global Variable    ${MCaseStatus}       In progress
    END
    Run Keyword    Capture Change Name Transaction Details for ${platformName}    Post


Transaction Switch funds
    ${iOS_Selectposttransaction}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Fund Switch ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    ${Android_Selectposttransaction}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Fund Switch']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='${MCaseStatus}'])[1]
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    ${CompleteStatus_List}    Get Text    ${${platformName}_Selectposttransaction}
    Set Global Variable    ${CompleteStatus_List}
    Run Keyword    Capture Fund Switch Transaction Details    Post

Capture Fund switch Transaction detail after Owb for Android
    Take Screenshot    FundSwitch_TransactionPage
    ${fundCounterr}    Set Variable    1
    @{SOdata_list}    Split String    ${SwitchFund_SwitchOutFundName}    ,

    ${SOdata_Length}    Get Length    ${SOdata_list}
    Log    ${SOdata_list}

    FOR    ${counter}    IN RANGE    0    ${SOdata_Length}
        Log    ${counter}
#    ${indexcounter}    Evaluate    ${counter}+1
        ${FundName}    Get From List    ${SOdata_list}    ${counter}
        ${indexcounter}    Set Variable    1
        ${capturefundname}    Get Text
        ...    xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[1]
        IF    '${capturefundname.strip()}' == '${FundName}'
            ${status}    Set Variable    True
        ELSE
            ${status}    Set Variable    False
        END
        WHILE    '${status}' == 'False'
            ${indexcounter}    Evaluate    ${indexcounter}+1
            ${capturefundname}    Get Text
            ...    xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[1]
            IF    '${capturefundname.strip()}' == '${FundName}'
                ${status}    Set Variable    True
            ELSE
                ${status}    Set Variable    False
            END
        END
        Scroll Till Transaction Is Visible
        ...    xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[2]
        Scroll Till Transaction Is Visible
        ...    xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[2]
        ${switchinfundperc}    Get Text
        ...    xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[2]
        Log To Console    SwitchOutFund_${FundName}_Percentage : ${switchinfundperc}
        Scroll Till Transaction Is Visible
        ...    xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[3]
        ${switchinfundvalue}    Get Text
        ...    xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[3]
        ${switchinfundvalue}    Remove String    ${switchinfundvalue}    THB
        ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
        ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ${SPACE}
        Log To Console    SwitchOutFund_${FundName}_Value : ${switchinfundvalue}

        Set Calc VP Actual Result With Original And Source
        ...    Post_Transaction_FundName_${fundCounterr}
        ...    ${FundName}
        ...    ${FundName}
        ...    OMNE_TransactionPage
        Set Calc VP Actual Result With Original And Source
        ...    Post_Transaction_switchOutAmount_${FundName}
        ...    ${switchinfundvalue}
        ...    ${switchinfundvalue}
        ...    OMNE_TransactionPage
#    Set Calc VP Actual Result With Original And Source    Post_Transaction_Summary_SwitchOutFundName_${fundCounterr}    ${FundName}    ${FundName}    OMNE_TransactionPage
#    Set Calc VP Actual Result With Original And Source    Post_Transaction_Summary_EstimatedSwitchOutamount_${FundName}    ${switchinfundvalue}    ${switchinfundvalue}    OMNE_TransactionPage
        Set Calc VP Actual Result With Original And Source
        ...    Post_Transaction_switchOutPercentage_${FundName}
        ...    ${switchinfundperc}
        ...    ${switchinfundperc}
        ...    OMNE_TransactionPage

        ${fundCounterr}    Evaluate    ${fundCounterr}+1
    END

    @{SIdata_list}    Split String    ${SwitchFund_SwitchInFundName}    ,
    ${SIdata_Length}    Get Length    ${SIdata_list}
    Log    ${SIdata_list}
    ${summaryfundCounterr}    Set Variable    1
    FOR    ${counter}    IN RANGE    0    ${SIdata_Length}
        Log    ${counter}
#    ${indexcounter}    Evaluate    ${counter}+1
        ${FundName}    Get From List    ${SIdata_list}    ${counter}
        ${indexcounter}    Set Variable    1
        ${capturefundname}    Get Text
        ...    xpath=//android.widget.TextView[contains(@text,'Switch in amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[1]
        IF    '${capturefundname.strip()}' == '${FundName}'
            ${status}    Set Variable    True
        ELSE
            ${status}    Set Variable    False
        END
        WHILE    '${status}' == 'False'
            ${indexcounter}    Evaluate    ${indexcounter}+1
            ${capturefundname}    Get Text
            ...    xpath=//android.widget.TextView[contains(@text,'Switch in amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[1]
            IF    '${capturefundname.strip()}' == '${FundName}'
                ${status}    Set Variable    True
            ELSE
                ${status}    Set Variable    False
            END
        END
        Scroll Till Transaction Is Visible
        ...    xpath=//android.widget.TextView[contains(@text,'Switch in amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[2]
        ${switchinfundperc}    Get Text
        ...    xpath=//android.widget.TextView[contains(@text,'Switch in amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[2]
        Log To Console    SwitchOutFund_${FundName}_Percentage : ${switchinfundperc}
        Scroll Till Transaction Is Visible
        ...    xpath=//android.widget.TextView[contains(@text,'Switch in amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[3]
        ${switchinfundvalue}    Get Text
        ...    xpath=//android.widget.TextView[contains(@text,'Switch in amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[3]
        ${switchinfundvalue}    Remove String    ${switchinfundvalue}    THB
        ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
        ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ${SPACE}
        Log To Console    SwitchOutFund_${FundName}_Value : ${switchinfundvalue}

        Set Calc VP Actual Result With Original And Source
        ...    Post_Transaction_FundName_${fundCounterr}
        ...    ${FundName}
        ...    ${FundName}
        ...    OMNE_TransactionPage
        Set Calc VP Actual Result With Original And Source
        ...    Post_Transaction_switchInAmount_${FundName}
        ...    ${switchinfundvalue}
        ...    ${switchinfundvalue}
        ...    OMNE_TransactionPage
        Set Calc VP Actual Result With Original And Source
        ...    Post_Transaction_switchInPercentage_${FundName}
        ...    ${switchinfundperc}
        ...    ${switchinfundperc}
        ...    OMNE_TransactionPage
        ${fundCounterr}    Evaluate    ${fundCounterr}+1
        ${summaryfundCounterr}    Evaluate    ${summaryfundCounterr}+1
    END

    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_FundTransactionDetails}
    Take Screenshot    FundSwitch_TransactionPage
    ${VP_FundTransactionDetails}    Get Text    ${${platformName}_${lang}_FundTransactionDetails}
#    ${VP_factastatus}    Strip String    ${VP_FundTransactionDetails}
#    Set Calc VP Actual Result With Original And Source    Post_Transaction_Facta_Status    ${VP_factastatus.strip()}    ${VP_factastatus.strip()}    Omne_TransactionPage

Capture Fund switch Transaction detail after Owb for iOS
    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_FundTransactionDetails}
    Take Screenshot    FundSwitch_TransactionPage
    ${VP_FundTransactionDetails}    Get Text    ${${platformName}_${lang}_FundTransactionDetails}
    @{VP_transactiondetailList}    Split String    ${VP_FundTransactionDetails}    Policy no: ${policyno}
    ${VP_FundTransactionDetails}    Get From List    ${VP_transactiondetailList}    1
    ${fundCounterr}    Set Variable    1
    # capture fatca status
#    @{VP_fatcastausdetail}    Split String    ${VP_FundTransactionDetails}    FATCA

#    IF    '${platformName}' == 'Android'
#    ${VP_factastatus}    Strip String    ${VP_FundTransactionDetails}
#    ELSE
#    IF    '${Fatca_Status}' == 'Yes'
#    ${VP_factastatus}    Get From List    ${VP_fatcastausdetail}    1
#    @{factastatus}    Split String    ${VP_factastatus}    Address
#    ${VP_factastatus}    Get From List    ${factastatus}    0
#    ELSE
#    ${VP_factastatus}    Get From List    ${VP_fatcastausdetail}    1
#    @{factastatus}    Split String    ${VP_factastatus}    date
#    ${VP_factastatus}    Get From List    ${factastatus}    0
#    @{factastatus}    Split String    ${VP_factastatus}
#    ${VP_factastatus}    Get From List    ${factastatus}    0
#    END
#    END
#    Set Calc VP Actual Result With Original And Source    Post_Transaction_Facta_Status    ${VP_factastatus.strip()}    ${VP_factastatus.strip()}    Omne_TransactionPage

    # capture switch out funddetails
    @{SOdata_list}    Split String    ${SwitchFund_SwitchOutFundName}    ,
    ${SOdata_Length}    Get Length    ${SOdata_list}
    Log    ${SOdata_list}

    FOR    ${counter}    IN RANGE    0    ${SOdata_Length}
        Log    ${counter}
        ${FundName}    Get From List    ${SOdata_list}    ${counter}
        IF    '${platformName}' == 'Android'
            ${switchinfundperc}    Get Text    ${${platformName}_${lang}_Trans_OutPerc}
            Log To Console    SwitchOutFund_${FundName}_Percentage : ${switchinfundperc}
            ${switchinfundvalue}    Get Text    ${${platformName}_${lang}_Trans_OutFundValue}
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    THB
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ${SPACE}
            Log To Console    SwitchOutFund_${FundName}_Value : ${switchinfundvalue}
        ELSE
            @{transswitchinfunddetails}    Split String    ${VP_FundTransactionDetails}    ${FundName}
            ${transswitchinfunddetails}    Get From List    ${transswitchinfunddetails}    1
            @{sitchinfunddatasplit}    Split String    ${transswitchinfunddetails}
            ${switchinfundperc}    Get From List    ${sitchinfunddatasplit}    0
            Log To Console    SwitchOutFund_${FundName}_Percentage : ${switchinfundperc}
            ${switchinfundvalue}    Get From List    ${sitchinfunddatasplit}    2
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
            Log To Console    SwitchOutFund_${FundName}_Value : ${switchinfundvalue}
        END
        Set Calc VP Actual Result With Original And Source
        ...    Post_Transaction_FundName_${fundCounterr}
        ...    ${FundName}
        ...    ${FundName}
        ...    OMNE_TransactionPage
        Set Calc VP Actual Result With Original And Source
        ...    Post_Transaction_switchOutAmount_${FundName}
        ...    ${switchinfundvalue}
        ...    ${switchinfundvalue}
        ...    OMNE_TransactionPage
#    Set Calc VP Actual Result With Original And Source    Post_Transaction_Summary_SwitchOutFundName_${fundCounterr}    ${FundName}    ${FundName}    OMNE_TransactionPage
#    Set Calc VP Actual Result With Original And Source    Post_Transaction_Summary_EstimatedSwitchOutamount_${FundName}    ${switchinfundvalue}    ${switchinfundvalue}    OMNE_TransactionPage
        Set Calc VP Actual Result With Original And Source
        ...    Post_Transaction_switchOutPercentage_${FundName}
        ...    ${switchinfundperc}
        ...    ${switchinfundperc}
        ...    OMNE_TransactionPage

        ${fundCounterr}    Evaluate    ${fundCounterr}+1
    END

    # capture switch in fund details
    @{SIdata_list}    Split String    ${SwitchFund_SwitchInFundName}    ,
    ${SIdata_Length}    Get Length    ${SIdata_list}
    Log    ${SIdata_list}
    ${summaryfundCounterr}    Set Variable    1
    FOR    ${counter}    IN RANGE    0    ${SIdata_Length}
        Log    ${counter}
        ${FundName}    Get From List    ${SIdata_list}    ${counter}
        IF    '${platformName}' == 'Android'
            ${switchinfundperc}    Get Text    ${${platformName}_${lang}_Trans_INPerc}
            Log To Console    SwitchOutFund_${FundName}_Percentage : ${switchinfundperc}
            ${switchinfundvalue}    Get Text    ${${platformName}_${lang}_Trans_INFundValue}
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    THB
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ${SPACE}
            Log To Console    SwitchOutFund_${FundName}_Value : ${switchinfundvalue}
        ELSE
            @{transswitchinfunddetails}    Split String    ${VP_FundTransactionDetails}    ${FundName}
            ${transswitchinfunddetails}    Get From List    ${transswitchinfunddetails}    1
            @{sitchinfunddatasplit}    Split String    ${transswitchinfunddetails}
            ${switchinfundperc}    Get From List    ${sitchinfunddatasplit}    0
            Log To Console    SwitchInFund_${FundName}_Percentage : ${switchinfundperc}
            ${switchinfundvalue}    Get From List    ${sitchinfunddatasplit}    2
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
            Log To Console    SwitchInFund_${FundName}_Value : ${switchinfundvalue}
        END
        Set Calc VP Actual Result With Original And Source
        ...    Post_Transaction_FundName_${fundCounterr}
        ...    ${FundName}
        ...    ${FundName}
        ...    OMNE_TransactionPage
        Set Calc VP Actual Result With Original And Source
        ...    Post_Transaction_switchInAmount_${FundName}
        ...    ${switchinfundvalue}
        ...    ${switchinfundvalue}
        ...    OMNE_TransactionPage
        Set Calc VP Actual Result With Original And Source
        ...    Post_Transaction_switchInPercentage_${FundName}
        ...    ${switchinfundperc}
        ...    ${switchinfundperc}
        ...    OMNE_TransactionPage
        ${fundCounterr}    Evaluate    ${fundCounterr}+1
        ${summaryfundCounterr}    Evaluate    ${summaryfundCounterr}+1
    END
    SwipePage
    Sleep    4s
    Take Screenshot    FundSwitch_TransactionPage

Transaction Policy loan
    ${Android_Selectposttransaction}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Policy Loan Request']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='${MCaseStatus}'])[1]
    ${iOS_Selectposttransaction}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Policy Loan Request' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    ${CompleteStatus_List}    Get Text    ${${platformName}_Selectposttransaction}
    Set Global Variable    ${CompleteStatus_List}
#    Click Element    ${${platformName}_Selectposttransaction}

    ${sOutput}    Run Keyword And Ignore Error    TransactionDetails for CV Loan ${platformName}    Post
    IF    ${sOutput} != ('PASS', None)
        ${failure_reason}    Fetch Reason    ${sOutput}
        RETURN    ${failure_reason}
    END

Transaction Credit card recurring payment
    ${Android_Selectposttransaction}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Credit card recurring payment']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='${MCaseStatus}'])[1]
    ${iOS_Selectposttransaction}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Credit card recurring payment ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    ${CompleteStatus_List}    Get Text    ${${platformName}_Selectposttransaction}
    Set Global Variable    ${CompleteStatus_List}
#    Click Element    ${${platformName}_Selectposttransaction}

    ${sOutput}    Run Keyword And Ignore Error    Capture RCC Transaction Details for ${platformName}    Post
    IF    ${sOutput} != ('PASS', None)
        ${failure_reason}    Fetch Reason    ${sOutput}
        RETURN    ${failure_reason}
    END

Transaction Renewal premium
    ${Android_Selectposttransaction}    Set Variable
    ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Pay renewal premium']/following-sibling::android.view.ViewGroup/android.widget.TextView[@text='${MCaseStatus}'])[1]
    ${iOS_Selectposttransaction}    Set Variable
    ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Pay renewal premium' and label CONTAINS '${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    Scroll Till Transaction Is Visible    ${${platformName}_Selectposttransaction}
    ${CompleteStatus_List}    Get Text    ${${platformName}_Selectposttransaction}
    Set Global Variable    ${CompleteStatus_List}
#    Click Element    ${${platformName}_Selectposttransaction}

    ${sOutput}    Run Keyword And Ignore Error    Capture Renewal Premium Transaction Details for ${platformName}
    IF    ${sOutput} != ('PASS', None)
        ${failure_reason}    Fetch Reason    ${sOutput}
        RETURN    ${failure_reason}
    END

