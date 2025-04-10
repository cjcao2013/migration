*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     DateTime
Resource    ../../../PageObjects/Insurance/UpdatePolicy/PaymentFrequencyPageObjects.resource
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource


*** Keywords ***
frequency
    TRY
#        Select Policy
        # select chnaged frequency
        ${Status}       Run Keyword And Return Status       Wait Until Page Contains Element        ${iOS_EN_PayerPolicy}       timeout=50s
        IF    '${Status}' != 'True'

                ${Android_SelectChangedfrequecny}    Set Variable       android=new UiSelector().textContains("${Change_Payment_mode}")
                ${iOS_SelectChangedfrequecny}    Set Variable       chain=**/XCUIElementTypeOther[`label CONTAINS '${Change_Payment_mode}'`][-1]
                Wait Until Page Contains Element    ${${platformName}_SelectChangedfrequecny}    timeout=30s
                Click Element    ${${platformName}_SelectChangedfrequecny}

                # capture premium
                ${Android_SelectChangedfrequecny}    Set Variable         xpath=//android.widget.TextView[@text='${Change_Payment_mode}']//following::android.widget.TextView[1]
                ${VP_PaymentfrequecyPremium}    Get Text    ${${platformName}_SelectChangedfrequecny}
                ${VP_PaymentfrequecyPremium}    Remove String    ${VP_PaymentfrequecyPremium}    ${Change_Payment_mode}
                @{Ppremium_Value}    Split String    ${VP_PaymentfrequecyPremium}
                ${VP_PaymentfrequecyPremium}    Get From List    ${Ppremium_Value}    1
                ${VP_PaymentfrequecyPremium}    Remove String    ${VP_PaymentfrequecyPremium}    ,
                ${VP_PaymentfrequecyPremium}    Evaluate    "{:.2f}".format(${VP_PaymentfrequecyPremium})

                Set Calc VP Expected Result With Original And Source
                ...    New_Premium_Amount
                ...    ${VP_PaymentfrequecyPremium.strip()}
                ...    ${VP_PaymentfrequecyPremium}
                ...    OMNE_Payment_Frequency_Page
                Set Calc VP Expected Result With Original And Source
                ...    New_Payment_Frequency
                ...    ${Change_Payment_mode}
                ...    ${Change_Payment_mode}
                ...    OMNE_Payment_Frequency_Page
                # capture frequency details
                ${VP_OLD_PaymentMode}    Get Text    ${${platformName}_${lang}_CurrentPaymentFrequency}
                ${VP_OLD_PaymentPremium}    Get Text    ${${platformName}_${lang}_CurrentPaymentPremium}
                @{VP_OLD_PaymentPremium}    Split String    ${VP_OLD_PaymentPremium}
                ${VP_OLD_PaymentPremium}    Get From List    ${VP_OLD_PaymentPremium}    1
                ${VP_OLD_PaymentPremium}    Remove String    ${VP_OLD_PaymentPremium}    ,
                ${VP_OLD_PaymentPremium}    Evaluate    "{:.2f}".format(${VP_OLD_PaymentPremium})
                IF    '${VP_OLD_PaymentMode}' == 'Yearly'
                    ${VP_OLD_PaymentMode}    Set Variable    Annual
                END
                Set Calc VP Expected Result With Original And Source
                ...    OLD_Payment_Frequency
                ...    ${VP_OLD_PaymentMode.strip()}
                ...    ${VP_OLD_PaymentMode.strip()}
                ...    OMNE_Payment_Frequency_Page
               Take Screenshot    Payment_frequency_page

                # Previous OTP from DB
                Get Details from DB
                ${Previous_OTP}    Set Variable    ${OTPNumber}
                Set Global Variable    ${Previous_OTP}
                Click Element    ${${platformName}_${lang}_SubmitButton}
                Run Keyword         Insert OTP          ${Transaction_OTP_Source}       ${Transaction_OTP_Expiry_Flag}      ${Transaction_OTP_Resend_Flag}
                Take Screenshot    Transaction_OTP_Page
                Run Keyword     Payment frequency Transaction

                Set Global Variable    ${result}    Payment Frequency Changed Successfully For Policy No : ${Policy_No}
        ELSE
                Set Global Variable    ${result}    Payment Frequency Not able To Change Successfully For Policy No : ${Policy_No}
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END

Payment frequency Transaction
    TRY
        ${status}    Run Keyword And Return Status       Wait Until Element Is Visible      ${${platformName}_${lang}_serviceRequestTransaction}        timeout=10s
        IF    '${status}' == 'True'
            Take Screenshot    submission Thanks Page
            Wait Until Element Is Visible    ${${platformName}_${lang}_serviceRequestTransaction}       timeout=10s
            Click Element    ${${platformName}_${lang}_serviceRequestTransaction}
            Take Screenshot    Transaction complete status
            Set Calc VP With Source And Original Values         Thanks Page Present     true    ${status}   Static      Omne Application    true    ${status}
        ELSE
            # New All Done Confirmation Page
            Run Keyword    Check Transaction Status
            Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=50s
            Take Screenshot    Transaction_Page
            Click Element    ${${platformName}_${lang}_SeeAll}
            Wait Until Page Contains Element    ${${platformName}_${lang}_TransactionServiceRequest}    timeout=20s
            Click Element    ${${platformName}_${lang}_TransactionServiceRequest}
            Take Screenshot    Transaction_Page
        END
        Run Keyword    Capture Payment Frequency Details For ${platformName}    Pre
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Payment frequency Transaction
    END

Capture Payment Frequency Details For Android
    [Arguments]    ${Transaction_Info}
    TRY
        ${Android_selectCurrentTransaction}    Set Variable
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of payment frequency'])[1]

        Scroll Till Transaction Is Visible    ${${platformName}_selectCurrentTransaction}

        ${transactionstatus}    Get Text
        ...    xpath=(//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of payment frequency']/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]
        ${transactionstatus}    Convert To Title Case    ${transactionstatus}
        ${policyno}    Get Text
        ...    xpath=//android.widget.TextView[@text='${current_day}']/following-sibling::android.widget.TextView[@text='${current_month}']/parent::android.view.ViewGroup/following-sibling::android.widget.TextView[@text='Change of payment frequency']/following-sibling::android.widget.TextView[contains(@text,'Policy no:')]
        @{policyno}    Split String    ${policyno}    Policy no:
        ${policyno}    Get From List    ${policyno}    -1

        IF    '${transactionstatus}' == 'Completed'
            ${transactionstatus}    Set Variable    Approve
        END
        Click Element    ${${platformName}_selectCurrentTransaction}
        Wait Until Element Is Visible    ${${platformName}_${lang}_FrequencyTransactionDetail}
        Take Screenshot    Transaction Page details
        ${VP_policyapplied}    Get Text    ${${platformName}_${lang}_FrequencyTransactionDetail}
        ${VP_changepaymentfrequency}    Get Text    ${${platformName}_${lang}_Payment_Frequency}
        IF    '${VP_changepaymentfrequency}' == 'Yearly'
            ${VP_changepaymentfrequency}    Set Variable    Annual
        END
        Scroll Till Transaction Is Visible    ${${platformName}_${lang}_New_Premium_Amount}

        ${VP_newpremiumamountdata}    Get Text    ${${platformName}_${lang}_New_Premium_Amount}
        ${VP_newpremiumamount}    Remove String    ${VP_newpremiumamountdata}    THB
        ${mVP_newpremiumamount}    Remove String    ${VP_newpremiumamount}    ,
        ${mVP_newpremiumamount}    Evaluate    "{:.2f}".format(${mVP_newpremiumamount})
        IF    '${Transaction_Info}' == 'Pre'
            Set Calc VP Expected Result With Original And Source
            ...    Policy No
            ...    ${policyno.strip()}
            ...    ${policyno.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Policy_Applied
            ...    ${VP_policyapplied.strip()}
            ...    ${VP_policyapplied.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Transaction_Status
            ...    ${transactionstatus.strip()}
            ...    ${transactionstatus.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Actual Result With Original And Source
            ...    New_Payment_Frequency
            ...    ${VP_changepaymentfrequency.strip()}
            ...    ${VP_changepaymentfrequency.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Transaction_New_Payment_Frequency
            ...    ${VP_changepaymentfrequency.strip()}
            ...    ${VP_changepaymentfrequency.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Actual Result With Original And Source
            ...    New_Premium_Amount
            ...    ${mVP_newpremiumamount.strip()}
            ...    ${mVP_newpremiumamount.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Transaction_New_Premium_Amount
            ...    ${VP_newpremiumamountdata.strip()}
            ...    ${VP_newpremiumamountdata.strip()}
            ...    Omne_TransactionPage
        ELSE IF    '${Transaction_Info}' == 'Post'
            Set Calc VP Actual Result With Original And Source
            ...    Post Transaction Policy_Applied
            ...    ${VP_policyapplied.strip()}
            ...    ${VP_policyapplied.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Actual Result With Original And Source
            ...    Post Transaction New_Payment_Frequency
            ...    ${VP_changepaymentfrequency.strip()}
            ...    ${VP_changepaymentfrequency.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Actual Result With Original And Source
            ...    Post Transaction New_Premium_Amount
            ...    ${mVP_newpremiumamount.strip()}
            ...    ${VP_newpremiumamountdata.strip()}
            ...    Omne_TransactionPage
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Payment Frequency Details For Android
    END
Capture Payment Frequency Details For iOS
    [Arguments]    ${Transaction_Info}
    TRY
        IF    '${Transaction_Info}' == 'Pre'
            ${iOS_selectCurrentTransaction}    Set Variable      chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of payment frequency' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        ELSE
             ${iOS_selectCurrentTransaction}    Set Variable         chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Change of payment frequency ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
        END
        ${status}    Run Keyword And Return Status       Wait Until Element Is Visible       ${${platformName}_selectCurrentTransaction}      timeout=150s
        IF    '${status}' != 'True'
            WHILE    '${status}' != 'True'
                SwipePage
                ${status}    Run Keyword And Return Status
                ...    Wait Until Element Is Visible
                ...    ${${platformName}_selectCurrentTransaction}
                ...    timeout=2s
                IF    '${status}' == 'True'
                    ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction}
                    @{transactionstatusdetail}    Split String    ${transactionstatus}    Policy no
                    ${policyno}    Get From List    ${transactionstatusdetail}    1
                    ${policyno}    Remove String    ${policyno}    :
                    ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
                    @{transactionstatusdetail}    Split String    ${transactionstatus}    Change of payment frequency
                    ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
                    ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
                    ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
                END
            END
        ELSE
            ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction}
            @{transactionstatusdetail}    Split String    ${transactionstatus}    Policy no
            ${policyno}    Get From List    ${transactionstatusdetail}    1
            ${policyno}    Remove String    ${policyno}    :
            ${policyno}    Strip String    ${policyno}
            IF    '${Transaction_Info}' == 'Post'
                ${policyno}    Split String    ${policyno}    Policy applied
                ${policyno}    Get From List    ${policyno}    0
                ${policyno}    Strip String    ${policyno}
            END
            ${transactionstatus}    Get From List    ${transactionstatusdetail}    0
            @{transactionstatusdetail}    Split String    ${transactionstatus}    Change of payment frequency
            ${transactionstatus}    Get From List    ${transactionstatusdetail}    1
            ${strtransactionstatus}    Convert To Title Case    ${transactionstatus}
            ${mTransactionstatus}    Set Variable    ${strtransactionstatus.strip()}
            IF    '${mTransactionstatus}' == 'Completed'
                ${mTransactionstatus}    Set Variable    Approve
                ${OPUSTransactionstatus}    Set Variable    Completed
                Set Global Variable    ${OPUSTransactionstatus}
            ELSE
                ${OPUSTransactionstatus}    Set Variable    In progress
                Set Global Variable    ${OPUSTransactionstatus}
            END
        END
        Click Element    ${${platformName}_selectCurrentTransaction}
        Wait Until Element Is Visible    ${${platformName}_${lang}_FrequencyTransactionDetail}      timeout=10s
        Take Screenshot    Transaction Page details
        ${VP_transactiondetail}    Get Text    ${${platformName}_${lang}_FrequencyTransactionDetail}
        Log    ${policyno}
        @{VP_transactiondetailList}    Split String    ${VP_transactiondetail}    Policy no: ${policyno.strip()}
        ${VP_transactiondetail}    Get From List    ${VP_transactiondetailList}    1

        @{VP_policyapplieddata}    Split String    ${VP_transactiondetail}    Payment frequency
        ${VP_policyapplied}    Get From List    ${VP_policyapplieddata}    0
        ${VP_policyapplied}    Remove String    ${VP_policyapplied}    Policy applied
        ${VP_paymentfrequency}    Get From List    ${VP_policyapplieddata}    1
        @{VP_paymentfrequencydata}    Split String    ${VP_paymentfrequency}    New Premium Amount
        ${VP_changepaymentfrequency}    Get From List    ${VP_paymentfrequencydata}    0
        IF    '${VP_changepaymentfrequency}' == 'Yearly'
            ${VP_changepaymentfrequency}    Set Variable    Annual
        END
        ${VP_newpremiumamountdata}    Get From List    ${VP_paymentfrequencydata}    1
        ${VP_newpremiumamountdata}    Remove String    ${VP_newpremiumamountdata}    THB    ,
        IF    '${Transaction_Info}' == 'Post'
            ${Status}       Run Keyword And Return Status    Should Contain    ${VP_newpremiumamountdata}    Completion date
            IF    '${Status}' == 'True'
                ${VP_premiumamountdata}    Split String    ${VP_newpremiumamountdata}    Completion date
                ${VP_newpremiumamountdata}    Get From List    ${VP_premiumamountdata}    0
            ELSE
                ${VP_premiumamountdata}    Split String    ${VP_newpremiumamountdata}    Decline date
                ${VP_newpremiumamountdata}    Get From List    ${VP_premiumamountdata}    0
            END
        END
        ${VP_newpremiumamountdata}    Evaluate    "{:.2f}".format(${VP_newpremiumamountdata})
        IF    '${Transaction_Info}' == 'Pre'
            Set Calc VP Expected Result With Original And Source
            ...    Policy No
            ...    ${policyno.strip()}
            ...    ${policyno.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Transaction_Status
            ...    ${mTransactionstatus.strip()}
            ...    ${mTransactionstatus.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Actual Result With Original And Source
            ...    New_Payment_Frequency
            ...    ${VP_changepaymentfrequency.strip()}
            ...    ${VP_changepaymentfrequency.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Transaction_New_Payment_Frequency
            ...    ${VP_changepaymentfrequency.strip()}
            ...    ${VP_changepaymentfrequency.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Actual Result With Original And Source
            ...    New_Premium_Amount
            ...    ${VP_newpremiumamountdata.strip()}
            ...    ${VP_newpremiumamountdata.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    Transaction_New_Premium_Amount
            ...    ${VP_newpremiumamountdata.strip()}
            ...    ${VP_newpremiumamountdata.strip()}
            ...    Omne_TransactionPage
        ELSE IF    '${Transaction_Info}' == 'Post'
            Set Calc VP Actual Result With Original And Source
            ...    Post Transaction New_Payment_Frequency
            ...    ${VP_changepaymentfrequency.strip()}
            ...    ${VP_changepaymentfrequency.strip()}
            ...    Omne_TransactionPage
            Set Calc VP Actual Result With Original And Source
            ...    Post Transaction New_Premium_Amount
            ...    ${VP_newpremiumamountdata.strip()}
            ...    ${VP_newpremiumamountdata.strip()}
            ...    Omne_TransactionPage
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Payment Frequency Details For iOS
    END