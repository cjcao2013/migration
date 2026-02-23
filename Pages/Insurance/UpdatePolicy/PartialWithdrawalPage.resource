*** Settings ***
Library     AppiumLibrary
Library     QraceHelper
Library     Dialogs
Library     DateTime
Library     SeleniumLibrary
Resource    ../../../CustomLibraries/common.robot
Resource    ../../../PageObjects/Insurance/UpdatePolicy/PartialWithdrawalPageObjects.resource
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource


*** Variables ***
${Calcualted_Total_Withdrawal_Amount}       ${EMPTY}


*** Keywords ***
Partial withdrawal
    TRY
    #    Click On Policy Number
        ${Android_SelectPolicyNo}    Set Variable    android=new UiSelector().textContains("${Policy_No}")
        ${iOS_SelectPolicyNo}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Policy_No}'`][-1]
        Wait Until Page Contains Element    ${${platformName}_SelectPolicyNo}       timeout=2s
        Take Screenshot    Policy Number
        Click Element    ${${platformName}_SelectPolicyNo}
    #    Select Funds
#        SwipePage
        IF    '${BasePlan_Fund_Name}' != ''
            @{List_BasePlan_Fund_Name}    Split String    ${BasePlan_Fund_Name}    ,
            ${Total_Number_OF_Fund}    Get Length    ${List_BasePlan_Fund_Name}
            FOR    ${FundCounter}    IN RANGE    0    ${Total_Number_OF_Fund}
                ${Fund_Name}    Get From List    ${List_BasePlan_Fund_Name}    ${FundCounter}
                ${iOS_selectFundName}    Set Variable       xpath=((//XCUIElementTypeOther[@name="Base plan"])[1]/following::XCUIElementTypeOther[contains(@name,'${Fund_Name}')])[3]
                ${Android_selectFundName}    Set Variable   xpath=(//android.widget.TextView[@text="${PolicyType}"]/following::android.widget.TextView)[1]
                Wait Until Element Is Visible    ${${platformName}_selectFundName}    timeout=25s
                ${FundName}    Get Text    ${${platformName}_selectFundName}
                IF    '${platformName}' == 'iOS'
                    ${FundName}    Split String    ${FundName}    AS OF
                    ${FundName}    Get From List    ${FundName}    0
                    ${FundName}    Strip String    ${FundName}
                END
                Set Global Variable    ${FundName}
                Click Element    ${${platformName}_selectFundName}
            END
        END
        Take Screenshot    Fund Selected
        Click Element    ${${platformName}_${lang}_NextButton}
    #    Input Withdrawal Percentage
        Wait Until Element Is Visible    ${${platformName}_${lang}_Withdrawal_Percentage}       timeout=5s
        IF    '${BasePlan_Partial_Withdrawal_Percentage}' != ''
            @{List_BasePlan_Fund_Perc}    Split String    ${Partial_Withdrawal_Percentage}    ,
            ${Total_Number_OF_Fund_Perc}    Get Length    ${List_BasePlan_Fund_Perc}
            ${fundcounter}      Set Variable    1
            FOR    ${FundCounter_Perc}    IN RANGE    0    ${Total_Number_OF_Fund_Perc}
                ${Fund_Perc}    Get From List    ${List_BasePlan_Fund_Perc}    ${FundCounter_Perc}
                ${iOS_withdrawalPercField}    Set Variable      xpath=//XCUIElementTypeOther[contains(@name,'${FundName}')]/following::XCUIElementTypeTextField[@name="spi-input"][1]
                ${Android_withdrawalPercField}    Set Variable      xpath=//android.widget.TextView[@text='${FundName}']//following::android.widget.EditText[@resource-id="spi-input"][1]
                ${Status}    Run Keyword And Return Status       Wait Until Element Is Visible      ${${platformName}_withdrawalPercField}      timeout=5s
                IF    '${Status}' == 'True'
                    Click Element    ${${platformName}_withdrawalPercField}
                    Input Text    ${${platformName}_withdrawalPercField}    ${Fund_Perc}\n
                    Close keyboard
                ELSE
                    SwipePage
                    Click Element    ${${platformName}_withdrawalPercField}
                    Input Text    ${${platformName}_withdrawalPercField}    ${Fund_Perc}\n
                    Close keyboard
                END
                IF    '${platformName}' == 'Android'
                    # Capture Unit Price
                    ${Fund_Unit_Price}    Get Text      xpath=//android.widget.TextView[@text="${Fund_Name}"]//following::android.widget.TextView[@text="Unit price (THB)"]//following-sibling::android.widget.TextView
                    Set Calc VP Expected Result With Original And Source     ${Fund_Name}_Unit_Price        ${Fund_Unit_Price.strip()}      ${Fund_Unit_Price.strip()}       OMNE_Partial_Withdrawal
                    #    Capture Valuation Date
                    ${Fund_Valuation_Date}    Get Text      xpath=//android.widget.TextView[@text="${Fund_Name}"]//following::android.widget.TextView[contains(@text,'AS')]
                    @{Fund_Valuation_Date}    Split String    ${Fund_Valuation_Date}    AS OF${SPACE}
                    ${Fund_Valuation_Date}    Set Variable    ${Fund_Valuation_Date}[-1]
                    ${mFund_Valuation_Date}    Convert To Title Case    ${Fund_Valuation_Date.lower()}
                    #    Capture Current Value of Current Fund
                    ${Current_Value}    Get Text     xpath=//android.widget.TextView[@text="${Fund_Name}"]//following::android.widget.TextView[@text="Current value (THB)"]//following-sibling::android.widget.TextView
                    ${Massaged_Current_Value}    Remove String    ${Current_Value}    ,
                    ${Massaged_Current_Value}    Evaluate    "{:.2f}".format(${Massaged_Current_Value})
                    Set Calc VP Expected Result With Original And Source        Fund_${fundcounter}_Current_Value       ${Massaged_Current_Value}       ${Massaged_Current_Value}       OMNE_Partial_Withdrawal
                    Set Calc VP Expected Result With Original And Source        ${Fund_Name}_Withdrawal_Percentage      ${Fund_Perc}%       ${Fund_Perc}%       Test_Data
                ELSE IF    '${platformName}' == 'iOS'
                    # capture ecah fund data
                    ${currentFundData}    Get Text    chain=**/XCUIElementTypeOther[`label CONTAINS '${FundName}'`][-1]
                    # Capture vluation Date
                    @{VP_currentvaluationDate}    Split String    ${currentFundData}    AS OF
                    ${currentvaluationDate}    Get From List    ${VP_currentvaluationDate}    1
                    @{valuationDateSplit}    Split String    ${currentvaluationDate}    Unit price (THB)
                    ${Fund_Valuation_Date}    Get From List    ${valuationDateSplit}    0
                    ${mFund_Valuation_Date}    Convert To Title Case    ${Fund_Valuation_Date.lower()}
                    # capture unit price and current value
                    ${VP_unitpriceandCurrentValue}    Get From List    ${valuationDateSplit}    1
                    @{VP_unitpriceandCurrentValue}    Split String    ${VP_unitpriceandCurrentValue}
                    ${Fund_Unit_Price}    Get From List    ${VP_unitpriceandCurrentValue}    0
                    ${Fund_CurrentValue}    Get From List    ${VP_unitpriceandCurrentValue}    4
                    ${Massaged_Current_Value}    Remove String    ${Fund_CurrentValue}    ,
                    ${Massaged_Current_Value}    Evaluate    "{:.2f}".format(${Massaged_Current_Value})
                    Set Calc VP Expected Result With Original And Source        Fund_${fundcounter}_Current_Value   ${Massaged_Current_Value}   ${Massaged_Current_Value}   OMNE_Partial_Withdrawal
                END
                #Capture Estimated AMount of Current Fund
                ${iOS_captureEstimateWithdrawalAmount}    Set Variable       xpath=(//XCUIElementTypeOther[contains(@name,'${FundName}')])[last()]/following::XCUIElementTypeStaticText[@name='Estimated withdrawal amount: ']//following-sibling::XCUIElementTypeStaticText[2]
                ${Android_captureEstimateWithdrawalAmount}    Set Variable      xpath=//android.widget.TextView[@text="${FundName}"]//following::android.widget.TextView[contains(@text,"Estimated withdrawal amount")]/following-sibling::android.widget.TextView[last()]
                ${Estimated_Withdrawal_Amount}    Get Text    ${${platformName}_captureEstimateWithdrawalAmount}
                ${Massaged_Estimated_Withdrawal_Amount}    Remove String    ${Estimated_Withdrawal_Amount}    ,
                ${Massaged_Estimated_Withdrawal_Amount}    Evaluate     "{:.2f}".format(${Massaged_Estimated_Withdrawal_Amount})
                Set Calc VP Expected Result With Original And Source        Fund_${fundcounter}_Withdrawal_Amount       ${Massaged_Estimated_Withdrawal_Amount}     ${Massaged_Estimated_Withdrawal_Amount}     OMNE_Partial_Withdrawal
                 #    Calculate current fund amount and add it to total
                ${Calculated_Fund_Withdrawal_Amount}    Evaluate    ${Fund_Perc} * ${Massaged_Current_Value} / 100
                ${Calculated_Fund_Withdrawal_Amount}    Evaluate    "{:.2f}".format(${Calculated_Fund_Withdrawal_Amount})
                ${Calcualted_Total_Withdrawal_Amount}    Evaluate       ${Calcualted_Total_Withdrawal_Amount}+${Massaged_Estimated_Withdrawal_Amount}
                Set Calc VP With Source And Original Values     ${FundName}_Withdrawal_Amount_OMNE          ${Calculated_Fund_Withdrawal_Amount}        ${Massaged_Estimated_Withdrawal_Amount}        Static_Calculation       OMNE_Partial_Withdrawal         ${Calculated_Fund_Withdrawal_Amount}        ${Estimated_Withdrawal_Amount}
                ${fundcounter}    Evaluate    ${fundcounter}+1
            END
        END
        Take Screenshot    Estimated Withdrawal Amount

    #    Capture Total Estimated Amount
        ${Estimated_Total_Withdrawal_Amount}    Get Text    ${${platformName}_${lang}_Estimated_Total_Amount}
        ${Estimated_Total_Withdrawal_Amount}    Remove String    ${Estimated_Total_Withdrawal_Amount}    THB${SPACE}
        ${Massaged_Estimated_Total_Withdrawal_Amount}    Remove String    ${Estimated_Total_Withdrawal_Amount}    ,
        ${Massaged_Estimated_Total_Withdrawal_Amount}    Evaluate            "{:.2f}".format(${Massaged_Estimated_Total_Withdrawal_Amount})
        Set Calc VP With Source And Original Values     Total_Estimated_Withdrawal_Amount        ${Calcualted_Total_Withdrawal_Amount}   ${Massaged_Estimated_Total_Withdrawal_Amount}      Static_Calculation      OMNE_Partial_Withdrawal     ${Calcualted_Total_Withdrawal_Amount}       ${Estimated_Total_Withdrawal_Amount}
        Click Element    ${${platformName}_${lang}_NextButton}

    #    Review Your Withdrawal
        Wait Until Element Is Visible    ${${platformName}_${lang}_Your_Withdrawal_Label}
        ${Review_Total_Estimated_Withdrawal_Amount}    Get Text    ${${platformName}_${lang}_Total_Estimated_Withdrawal}
        ${Review_Total_Estimated_Withdrawal_Amount}    Remove String        ${Review_Total_Estimated_Withdrawal_Amount}     THB${SPACE}
        ${Review_Total_Estimated_Withdrawal_Amount}    Remove String        ${Review_Total_Estimated_Withdrawal_Amount}     ,
        ${Massaged_Estimated_Total_Withdrawal_Amount}    Evaluate            "{:.1f}".format(${Review_Total_Estimated_Withdrawal_Amount})
        Set Global Variable    ${Review_Total_Estimated_Withdrawal_Amount}
        Set Calc VP With Source And Original Values     Review_Total_Withdrawal_Amount      ${Estimated_Total_Withdrawal_Amount}        ${Review_Total_Estimated_Withdrawal_Amount}     OMNE_Partial_Withdrawal     OMNE_Review_Withdrawal      ${Estimated_Total_Withdrawal_Amount}  ${Review_Total_Estimated_Withdrawal_Amount}

    #    Fatca Status
        SwipePage
        SwipePage
         ${status}    Run Keyword And Return Status       Wait Until Element Is Visible      ${${platformName}_${lang}_PW_addPaymentMethod}      timeout=5s
        IF    '${status}'=='True'
            Log To Console    addPayment Method
            Click Element    ${${platformName}_${lang}_PW_addPaymentMethod}
           Run Keyword   Add Payment Methods

        END
        Wait Until Element Is Visible    ${${platformName}_${lang}_partial__acknowledgeChkBox}       timeout=20s

        Click Element    ${${platformName}_${lang}_partial__acknowledgeChkBox}
        Take Screenshot    Review Withdrawal Fatca Status
        # Previous OTP from DB
        Get Details from DB
        ${Previous_OTP}    Set Variable    ${OTPNumber}
        Set Global Variable    ${Previous_OTP}
        Click Element    ${${platformName}_${lang}_SubmitButton}
        Sleep   5s
        Insert OTP      ${Transaction_OTP_Source}       ${Transaction_OTP_Expiry_Flag}      ${Transaction_OTP_Resend_Flag}
        # New All Done Confirmation Page
        Run Keywords     Transaction Success Page

        Take Screenshot    Transaction_Page
        Run Keyword    Capture Partial Withdrawal Transaction Details For ${platformName}       Pre
        Set Global Variable    ${result}    Partial Fund Withdrawal Successfully for Policy No: ${Policy_No}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END

Capture Partial Withdrawal Transaction Details For Android
    [Arguments]    ${Transaction_Info}
    TRY
        ${Android_selectCurrentTransaction1}    Set Variable
        ...     xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Partial Withdrawal']/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]
        Wait Until Element Is Visible   ${Android_selectCurrentTransaction1}    timeout=120s
        Take Screenshot    Partial Withdrawal Transaction
        Click Element   ${Android_selectCurrentTransaction1}
        Take Screenshot    Partial Withdrawal Transaction
        ${Transaction_Policy_Status}    Get Text    ${${platformName}_${lang}_Transaction_Policy_Status}
        ${Transaction_Policy_Status}    Convert To Title Case    ${Transaction_Policy_Status}
        ${Trans_PolicyNumber}       Set Variable    xpath=//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Partial Withdrawal']/parent::android.view.ViewGroup/android.widget.TextView[2]
        ${Transaction_Policy_No}    Get Text    ${Trans_PolicyNumber}
        @{Transaction_Policy_No}    Split String    ${Transaction_Policy_No}    Policy no:
        ${Transaction_Policy_No}    Get From List    ${Transaction_Policy_No}   1
        IF    '${Transaction_Policy_Status}' == 'Completed'
            ${mTransactionstatus}    Set Variable    Approve
            ${OPUSTransactionstatus}    Set Variable    Completed
        ELSE
            ${OPUSTransactionstatus}    Set Variable    In progress
        END
        Set Global Variable    ${OPUSTransactionstatus}
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status
        ...    ${Transaction_Policy_Status}
        ...    ${Transaction_Policy_Status}
        ...    OMNE_View_Transaction

        Scroll Till Transaction Is Visible    ${${platformName}_${lang}_Transaction_Total_Estimated_Amount}
        ${Transaction_Total_Estimated_Amount}    Get Text    ${${platformName}_${lang}_Transaction_Total_Estimated_Amount}
        ${Transaction_Total_Estimated_Amount}    Remove String    ${Transaction_Total_Estimated_Amount}    THB${SPACE}
        ${Transaction_Massaged_Total_Estimated_Amount}    Remove String    ${Transaction_Total_Estimated_Amount}    ,
        ${Review_Total_Estimated_Withdrawal_Amount}    Remove String    ${Review_Total_Estimated_Withdrawal_Amount}    ,
        ${Transaction_Massaged_Total_Estimated_Amount}    Evaluate
        ...    "{:.2f}".format(${Transaction_Massaged_Total_Estimated_Amount})
        Set Calc VP With Source And Original Values
        ...    View_Transaction_Withdrawal_Amount
        ...    ${Review_Total_Estimated_Withdrawal_Amount}
        ...    ${Transaction_Massaged_Total_Estimated_Amount}
        ...    OMNE_Review_Withdrawal
        ...    OMNE_View_Transaction
        ...    ${Review_Total_Estimated_Withdrawal_Amount}
        ...    ${Transaction_Massaged_Total_Estimated_Amount}
        Set Calc VP Expected Result With Original And Source
        ...    Total_Withdrawal_Amount
        ...    ${Transaction_Massaged_Total_Estimated_Amount}
        ...    ${Transaction_Massaged_Total_Estimated_Amount}
        ...    OMNE_View_Transaction
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Partial WIthdrawal Transaction Details For Android
    END
Capture Partial WIthdrawal Transaction Details For iOS
    [Arguments]    ${Transaction_Info}
    TRY
        ${iOS_selectCurrentTransaction}    Set Variable     chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Partial Withdrawal' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction}    timeout=200s
        ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction}
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Policy no
        ${policyno}    Get From List    ${transactionstatusdetail}    1
        ${policyno}    Remove String    ${policyno}    :
        ${policyno}    Strip String    ${policyno}
        ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
        @{transactionstatusdetail}    Split String    ${transactionstatus}    Withdrawal
        ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
        ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
        ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
        IF    '${mTransactionstatus}' == 'Completed'
            ${mTransactionstatus}    Set Variable    Approve
            ${OPUSTransactionstatus}    Set Variable    Completed
        ELSE
            ${OPUSTransactionstatus}    Set Variable    In progress
        END
        Set Global Variable    ${OPUSTransactionstatus}
        Take Screenshot    Partial Withdrawal Transaction
        IF    '${Transaction_Info}' == 'Pre'
             Set Calc VP Expected Result With Original And Source
            ...    Transaction_Status
            ...    ${mTransactionstatus.strip()}
            ...    ${mTransactionstatus.strip()}
            ...    Omne_TransactionPage
        END

        Click Element    ${${platformName}_selectCurrentTransaction}
        Wait Until Element Is Visible    ${${platformName}_${lang}_Transaction_Total_Estimated_Amount}    timeout=30s
    #    SwipePage
        Take Screenshot    Partial Withdrawal Transaction
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
        IF    '${Transaction_Info}' == 'Pre'
            Set Calc VP With Source And Original Values
            ...    View_Transaction_Withdrawal_Amount
            ...    ${Review_Total_Estimated_Withdrawal_Amount}
            ...    ${Transaction_Massaged_Total_Estimated_Amount}
            ...    OMNE_Review_Withdrawal
            ...    OMNE_View_Transaction
            ...    ${Review_Total_Estimated_Withdrawal_Amount}
            ...    ${Transaction_Massaged_Total_Estimated_Amount}
            Set Calc VP Expected Result With Original And Source
            ...    Total_Withdrawal_Amount
            ...    ${Transaction_Massaged_Total_Estimated_Amount}
            ...    ${Transaction_Massaged_Total_Estimated_Amount}
            ...    OMNE_View_Transaction
        END


        Log To Console    Post Transaction Detail
        Wait Until Element Is Visible    ${${platformName}_${lang}_Transaction_Total_Estimated_Amount}    timeout=30s
        ${VP_transactionDataDetails}    Get Text    ${${platformName}_${lang}_Transaction_Total_Estimated_Amount}
        # Capture estimate withdrawal value
        @{EstimateWithdrawalValue}    Split String    ${VP_transactionDataDetails}    Please
        ${WithdrawalValue}    Get From List    ${EstimateWithdrawalValue}    0
        ${WithdrawalValue}    Split String    ${WithdrawalValue}    THB
        ${WithdrawalValue}    Get From List    ${WithdrawalValue}    1
        ${Transaction_Massaged_Total_Estimated_Amount}    Remove String    ${WithdrawalValue}    ,
        ${Review_Total_Estimated_Withdrawal_Amount}    Remove String    ${Review_Total_Estimated_Withdrawal_Amount}    ,
        ${Transaction_Massaged_Total_Estimated_Amount}    Evaluate
        ...    "{:.2f}".format(${Transaction_Massaged_Total_Estimated_Amount})
        IF    '${Transaction_Info}' == 'Post'
            Set Calc VP Actual Result With Original And Source
            ...    Post_Transaction_Total_Withdrawal_Amount
            ...    ${Transaction_Massaged_Total_Estimated_Amount}
            ...    ${Transaction_Massaged_Total_Estimated_Amount}
            ...    OMNE_View_Transaction
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Partial WIthdrawal Transaction Details For iOS
    END
