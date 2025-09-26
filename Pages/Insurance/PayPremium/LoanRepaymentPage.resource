*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     String
Resource    ../Common/CommonMethod.resource
Resource    ../Common/AddOTP.resource
Resource    ../../../PageObjects/Insurance/PayPremium/LoanRepaymentPageObjects.resource
Resource    RenewalPremiumPage.resource


*** Keywords ***
Pay now
    TRY
          ${Android_EN_InsurnacePage}       Set Variable    android=new UiSelector().text("Insurance")
          ${iOS_EN_InsurnacePage}           Set Variable    chain=**/XCUIElementTypeButton[`label == '${Flow_Flag}'`]
          Wait Until Element Is Visible      ${${platformName}_${lang}_InsurnacePage}            timeout=10s
          Take Screenshot     FWD_Insurance_Page
          Sleep    1s
          Click Element       ${${platformName}_${lang}_InsurnacePage}
          Set or enter PIN
          #      Select Insurance Flow
          ${Android_EN_Insurance_Module}    Set Variable     android=new UiSelector().textContains("${Insurance_Flow}")
          ${iOS_EN_Insurance_Module}        Set Variable     chain=**/XCUIElementTypeOther[`label == "${Insurance_Flow}"`][-1]
          Wait Until Element Is Visible    ${${platformName}_${lang}_Insurance_Module}      timeout=3s
          Click Element    ${${platformName}_${lang}_Insurance_Module}

         #      Select Manage Policy Option
          ${Android_EN_Update_Policy_Module}    Set Variable    android=new UiSelector().textContains("${Update_Policy_Module}")
          ${iOS_EN_Update_Policy_Module}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Update_Policy_Module}'`][-1]
          Wait Until Element Is Visible    ${${platformName}_${lang}_Update_Policy_Module}      timeout=3s
          Take Screenshot    Update_Policies_Page
          Click Element    ${${platformName}_${lang}_Update_Policy_Module}

           Run Keyword    ${Update_Policy_Module}

        Set Global Variable    ${result}    ${Update_Policy_Module} Completed Successfully for policy No: ${Policy_No}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END


Loan repayment
    TRY
        Pause Execution
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_EN_PolicyNotAvailable}
        ...    timeout=2s
        IF    '${status}' == 'True'
            Set Global Variable    ${errormsg}    No Eligible Policy
        END
        #    Click On Policy Number
        ${Android_SelectPolicyNo}    Set Variable    android=new UiSelector().textContains("${Policy_No}")
        ${iOS_SelectPolicyNo}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${Policy_No}'`][2]
        ${iOS_EN_PolicyLoan_RequestAmount}    Set Variable    chain=**/XCUIElementTypeOther[`label == "${Request_Amount}"`]
        ${Android_EN_PolicyLoan_RequestAmount}    Set Variable      xpath=//android.widget.TextView[@text="${Request_Amount}"]

        Wait Until Page Contains Element    ${${platformName}_SelectPolicyNo}       timeout=5s
        Take Screenshot    Select Policy
        Click Element    ${${platformName}_SelectPolicyNo}
          Pause Execution
        ${PolicyDetails}    Get Text    ${${platformName}_SelectPolicyNo}
        Set Global Variable    ${${platformName}_SelectPolicyNo}

        Wait Until Page Contains Element    ${${platformName}_${lang}_PolicyLoanRepayment_txt}       timeout=3s
        Wait Until Element Is Visible    ${${platformName}_${lang}_Loanoutstanding}    timeout=2s
        ${VP_Loanoutstanding}    Get Text    ${${platformName}_${lang}_Loanoutstanding}
        ${mVP_Loanoutstanding}    Remove String    ${VP_Loanoutstanding}    THB
        ${mVP_Loanoutstanding}    Remove String    ${mVP_Loanoutstanding}    ,

        ${VP_Loaninterest}    Get Text    ${${platformName}_${lang}_Loaninterest}
        ${mVP_Loaninterest}    Remove String    ${VP_Loaninterest}    THB
        ${mVP_Loaninterest}    Remove String    ${mVP_Loaninterest}    ,

        ${VP_Interestrate}    Get Text    ${${platformName}_${lang}_Interestrate}
        ${mVP_Interestrate}    Remove String    ${VP_Interestrate}    %

        ${VP_Totalasoftoday}    Get Text    ${${platformName}_${lang}_Totalasoftoday}
        ${mVP_Totalasoftoday}    Remove String    ${VP_Totalasoftoday}    THB
        ${mVP_Totalasoftoday}    Remove String    ${mVP_Totalasoftoday}    ,

            Take Screenshot    Loan_Repayment
            IF    '${Request_Amount}' == 'Specify amount (THB)'
                Click Element    ${${platformName}_${lang}_PolicyLoan_RequestAmount}
                ${Loanlimitasoftoday}    Convert To Number    ${mVP_Totalasoftoday}
                # Calculate Policy Max Limit
                ${Max_LoanLimit}    Evaluate    ${Loanlimitasoftoday} + 100
                Wait Until Element Is Visible    ${${platformName}_${lang}_PolicyLoanAmt}       timeout=5s
                Input Text    ${${platformName}_${lang}_PolicyLoanAmt}    ${Max_LoanLimit}\n
                # Capture Policy Max limit Error
                ${status}    Run Keyword And Return Status
                ...    Element Should Be Visible
                ...    ${${platformName}_${lang}_Max_LoanLimit_Error}
                IF    '${status}' == 'True'
                    Take Screenshot    Policy_Loan_Max_Limit_Error
                    ${Error_MaxLoanLimit}    Get Text    ${${platformName}_${lang}_Max_LoanLimit_Error}
                    Set Calc VP With Source And Original Values
                    ...    PolicyLoan_MaxLimit_ErrorMsg
                    ...    ${Error_MaxLoanLimit}
                    ...    ${Error_MaxLoanLimit}
                    ...    static
                    ...    Omne Application
                    ...    ${Error_MaxLoanLimit}
                    ...    ${Error_MaxLoanLimit}
                END
                Wait Until Element Is Visible    ${${platformName}_${lang}_Totalasoftoday_txt}  timeout=1s
                Click Element    ${${platformName}_${lang}_Totalasoftoday_txt}
                Wait Until Element Is Visible    ${${platformName}_${lang}_PolicyLoan_RequestAmount}       timeout=1s
                Click Element    ${${platformName}_${lang}_PolicyLoan_RequestAmount}
                Input Text    ${${platformName}_${lang}_PolicyLoanAmt}    ${Min_LoanLimit}\n
                Take Screenshot    Min Loan Limit
                # Capture Policy Min limit Error
                ${status}    Run Keyword And Return Status
                ...    Element Should Be Visible
                ...    ${${platformName}_${lang}_Min_LoanLimit_Error}
                IF    '${status}' == 'True'
                    Take Screenshot    Policy_Loan_Max_Limit_Error
                    ${Error_MinLoanLimit}    Get Text    ${${platformName}_${lang}_Min_LoanLimit_Error}
                    Set Calc VP With Source And Original Values
                    ...    PolicyLoan_MinLimit_ErrorMsg
                    ...    ${Error_MinLoanLimit}
                    ...    ${Error_MinLoanLimit}
                    ...    static
                    ...    Omne Application
                    ...    ${Error_MinLoanLimit}
                    ...    ${Error_MinLoanLimit}
                END
                Wait Until Element Is Visible    ${${platformName}_${lang}_Totalasoftoday_txt}  timeout=1s
                Click Element    ${${platformName}_${lang}_Totalasoftoday_txt}
                Wait Until Element Is Visible    ${${platformName}_${lang}_PolicyLoan_RequestAmount}       timeout=1s
                Click Element    ${${platformName}_${lang}_PolicyLoan_RequestAmount}
                Input Text    ${${platformName}_${lang}_PolicyLoanAmt}    ${Loan_Amount}\n
            ELSE
                Click Element   ${${platformName}_${lang}_PolicyLoan_RequestAmount}
                ${status}    Run Keyword And Return Status  Wait Until Element Is Visible    ${${platformName}_${lang}_PolicyLoanAmt}   timeout=5s
                IF    '${status}' == 'False'
                    ${status}   Run Keyword And Return Status   Element Should Be Disabled    chain=**/XCUIElementTypeOther[`label == "Specify amount (THB)"`]
                END
            END
            Take Screenshot    Loan_Repayment
            SwipePage
            Click Element    ${${platformName}_${lang}_PayNow}
            # QR Scan Page
             QR Code
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Loan repayment ${Insurance_Flow}
    END




QR Code
    # QR Scan Page
    TRY
        Wait Until Element Is Visible    ${${platformName}_${lang}_QRcode_txt}      timeout=10s
        ${VP_PolicyNumber}      Get Text    ${${platformName}_${lang}_PolicyNumber_txt}
        ${VP_PolicyNumber}      Remove String    ${VP_PolicyNumber}     Policy number

        IF    '${Update_Policy_Module}' == 'Loan repayment'
            ${VP_PaymentAmount}     Get Text    ${${platformName}_${lang}_PaymentAmount_txt}
            ${VP_PaymentAmount}      Remove String    ${VP_PaymentAmount}     Payment amount
        ELSE
            ${VP_PremiumAmount}     Get Text    ${${platformName}_${lang}_PremiumAmount_txt}
            ${VP_PremiumAmount}      Remove String    ${VP_PremiumAmount}     Premium amount
        END

        Take Screenshot    Loan_Repayment_Details
        Click Element    ${${platformName}_${lang}_DownloadQRCode}
        Sleep     3s

        TRY
              Click Text    OK    exact_match=true
        EXCEPT
               Click Text    Allow    exact_match=true
#               Click Text    OK    exact_match=true
        END


        ${status}    Run Keyword And Return Status
        ...    Wait Until Page Contains
        ...    QR code is saved to your device album        timeout=5s
        IF    '${status}' == 'True'
            Take Screenshot    QRCodeSaved
            Set Calc VP With Source And Original Values
            ...    QR code is saved to your device album
            ...    true
            ...    ${status}
            ...    Static
            ...    OMNE_Application
            ...    true
            ...    ${status}
        END
            Click Element    ${${platformName}_${lang}_BackToDashboard}
            Take Screenshot    DashboardPage

    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   OR Code
    END
