*** Settings ***
Library     SeleniumLibrary
Library     Dialogs
Library     QraceHelper
Resource    OWBAssignTaskPage.resource
Resource    ../../PageObjects/OWB/OWBPartialWithdrawalPageObjects.resource


*** Keywords ***
OWB Partial withdrawal
    Wait Until Element Is Visible    ${${lang}_totalFundCount}
    Take OWB Screenshot    Partial withdrawal Page
    ${VP_totalFundlist}    Get Webelements    ${${lang}_totalFundCount}
    ${VP_fundcount}    Get Length    ${VP_totalFundlist}
    ${fundcounter}    Set Variable    1
    FOR    ${counter}    IN RANGE    0    ${VP_fundcount}
        ${VP_Component}    Get Element Attribute
        ...    xpath=((//tbody[@class='ant-table-tbody'])[1]/tr/td[1]/div/div)[${fundcounter}]
        ...    attribute=title
        ${VP_Fund}    Get Element Attribute
        ...    xpath=((//tbody[@class='ant-table-tbody'])[1]/tr/td[2]/div/div)[${fundcounter}]
        ...    attribute=title
        ${VP_FundName}    Get Substring    ${VP_Fund}    5
        ${Fund_Name}    Set Variable    ${VP_FundName}
#    Get From List    ${VP_FundName}    1
#    ${fundnamesplitcountcount}    Get Length    ${VP_FundName}
#    ${finalVP_fundname}    Set Variable
#    FOR    ${counter}    IN RANGE    1    ${fundnamesplitcountcount}
#    ${VP_fundvalue}    Get From List    ${VP_FundName}    ${counter}
#    ${VP_fundvalue}    Set Variable    ${Fund_Name}
#    ${finalVP_fundname}    Catenate    ${finalVP_fundname} ${VP_fundvalue}
#    END
        ${VP_UnitHolding}    Get Element Attribute
        ...    xpath=((//tbody[@class='ant-table-tbody'])[1]/tr/td[3]/div/div)[${fundcounter}]
        ...    attribute=title
        ${VP_UnitPrice}    Get Element Attribute
        ...    xpath=((//tbody[@class='ant-table-tbody'])[1]/tr/td[4]/div/div)[${fundcounter}]
        ...    attribute=title
        ${VP_CurrentValue}    Get Element Attribute
        ...    xpath=((//tbody[@class='ant-table-tbody'])[1]/tr/td[5]/div/div)[${fundcounter}]
        ...    attribute=title
        ${VP_WithdrawalPercentage}    Get Element Attribute
        ...    xpath=((//tbody[@class='ant-table-tbody'])[1]/tr/td[6]/div/div)[${fundcounter}]
        ...    attribute=title
        ${VP_WithdrawalAmount}    Get Element Attribute
        ...    xpath=((//tbody[@class='ant-table-tbody'])[1]/tr/td[7]/div/div)[${fundcounter}]
        ...    attribute=title
        ${VP_WithdrawalAmount}    Remove String    ${VP_WithdrawalAmount}    ,
        ${VP_WithdrawalAmount}    Evaluate    "{:.2f}".format(${VP_WithdrawalAmount.strip()})
#    ${VP_UnitPrice}    Remove String    ${VP_UnitPrice}    ,
#    ${VP_UnitPrice}    Evaluate    "{:.2f}".format(${VP_UnitPrice.strip()})
        ${VP_ValuationDate}    Get Element Attribute
        ...    xpath=(//div[text()="Valuation Date"]//following::div[@class="valuationDate"])[${fundcounter}]
        ...    attribute=title
        Set Calc VP Actual Result With Original And Source
        ...    ${Fund_Name.strip()}_Unit_Price
        ...    ${VP_UnitPrice.strip()}
        ...    ${VP_UnitPrice.strip()}
        ...    OWB
        Set Calc VP Actual Result With Original And Source
        ...    ${Fund_Name.strip()}_Valuation_Date
        ...    ${VP_ValuationDate.strip()}
        ...    ${VP_ValuationDate.strip()}
        ...    OWB
        ${VP_CurrentValue}    Remove String    ${VP_CurrentValue}    ,
#    ${VP_CurrentValue}    Evaluate    "{:.2f}".format(${VP_CurrentValue.strip()})
        Set Calc VP Actual Result With Original And Source
        ...    ${Fund_Name.strip()}_Current_Value
        ...    ${VP_CurrentValue}
        ...    ${VP_CurrentValue}
        ...    OWB
        Set Calc VP Actual Result With Original And Source
        ...    ${Fund_Name.strip()}_Withdrawal_Percentage
        ...    ${VP_WithdrawalPercentage.strip()}
        ...    ${VP_WithdrawalPercentage.strip()}
        ...    OWB
        Set Calc VP Actual Result With Original And Source
        ...    ${Fund_Name.strip()}_Withdrawal_Amount
        ...    ${VP_WithdrawalAmount.strip()}
        ...    ${VP_WithdrawalAmount.strip()}
        ...    OWB

        ${fundcounter}    Evaluate    ${fundcounter}+1
    END
    ${VP_TotalWithdrwalAmount}    Get Text    ${EN_TotalWithdrwalAmount}
    ${VP_CompletionDate}    Get Element Attribute    ${EN_owbCompletionDate}    attribute=title
    ${VP_Bank_Name}    Get Element Attribute    ${EN_VP_BankName}    attribute=title
    ${VP_Card_Number}    Get Element Attribute    ${EN_VP_Account_No}    attribute=title
    ${VP_holdername}    Get Element Attribute    ${EN_VP_holdername}    attribute=title
#    ${VP_holdername}    Strip String    ${VP_holdername}
    ${VP_TotalWithdrwalAmount}    Remove String    ${VP_TotalWithdrwalAmount}    ,
    ${VP_TotalWithdrwalAmount}    Evaluate    "{:.2f}".format(${VP_TotalWithdrwalAmount})
    Set Calc VP Actual Result With Original And Source
    ...    Total_Withdrawal_Amount
    ...    ${VP_TotalWithdrwalAmount.strip()}
    ...    ${VP_TotalWithdrwalAmount.strip()}
    ...    OWB
    Set Calc VP Expected Result With Original And Source
    ...    Post_Transaction_Total_Withdrawal_Amount
    ...    ${VP_TotalWithdrwalAmount.strip()}
    ...    ${VP_TotalWithdrwalAmount.strip()}
    ...    OWB
#    Set Calc VP Actual Result With Original And Source    Bank Account Holder Name    ${VP_holdername.strip()}    ${VP_holdername.strip()}    OWB
#    Set Calc VP Actual Result With Original And Source    Bank_Name    ${VP_Bank_Name}    ${VP_Bank_Name}    OWB
#    Set Calc VP Expected Result With Original And Source    Post_Transaction_Total_Withdrawal_Amount    ${Total_Withdrawal_Amount}    ${Total_Withdrawal_Amount}    OWB
#    Set Calc VP Expected Result With Original And Source    Post_Transaction_Bank_Name    ${VP_Bank_Name}    ${VP_Bank_Name}    OWB
#    Set Calc VP Actual Result With Original And Source    Bank_AccountNumber    ${VP_Card_Number}    ${VP_Card_Number}    OWB Application
    ${Approved_Status}    Get Text    ${EN_partialwithdrawlApprovalStatus}
#    Set Calc VP Expected Result With Original And Source    PostTransaction_Status    ${Approved_Status}    ${Approved_Status}    OWB Application
    Set Calc VP With Source And Original Values
    ...    ApprovalStatus
    ...    ${CaseStatus}
    ...    ${Approved_Status}
    ...    Static
    ...    OWB
    ...    ${CaseStatus}
    ...    ${Approved_Status}
    Set Global Variable    ${Approved_Status}
    Take OWB Screenshot    Partial Withdrwal Page
#    Click Element    ${EN_viewAllImages}
#    #handle switch window
#    Switch Window    new
#    Wait Until Element Is Visible    ${EN_totDocumentCount}    timeout=60s
#    Take OWB Screenshot    DocumentPage
#    @{totalDoclist}    Get WebElements    ${EN_totDocumentCount}
#    ${DocCountlength}    Get Length    ${totalDoclist}
#    FOR    ${counter}    IN RANGE    0    ${DocCountlength}
#    ${webelement}    Get From List    ${totalDoclist}    ${counter}
#    Wait Until Element Is Visible    ${webelement}    timeout=50s
#    Click Element    ${webelement}
#    Sleep    5s
#    Take OWB Screenshot    Document
#    END

#    ${Fund_Name}    Get Text    ${${lang}_Fund_Code}
#    ${Fund_Current_Value}    Get Value    ${${lang}_Current_Fund_Value}
#    ${Fund_Withdrawal_Percentage}    Get Value    ${${lang}_Withdrawal_Percentage}
#    ${Fund_Withdrawal_Amount}    Get Value    ${${lang}_Withdrawal_Amount}
#    ${Total_Withdrawal_Amount}    Get Text    ${${lang}_Total_Withdrawal_Amount}
#    ${Total_Withdrawal_Amount}    Remove String    ${Total_Withdrawal_Amount}    ,
#    ${Total_Withdrawal_Amount}    Evaluate    "{:.2f}".format(${Total_Withdrawal_Amount})
#
#    ${Bank_Name}    Get Value    ${${lang}_Bank_Name}
#    ${US_ID_Passport_No}    Get Value    ${${lang}_US_ID_Passport}
#    ${US_Tax_Id}    Get Value    ${${lang}_US_Tax_Id_social_security}
#    ${Street_Address}    Get Value    ${${lang}_Street_Address}
#    ${City}    Get Value    ${${lang}_City}
#    ${State}    Get Value    ${${lang}_State}
#    ${Zip_Code}    Get Value    ${${lang}_Zipcode}

#    Scroll Element Into View    ${${lang}_Zipcode}
    Take OWB Screenshot    Partial Withdrwal Page
#    Set Calc VP With Source And Original Values    Fund_Name    ${BasePlan_Fund_Name}    ${Fund_Name}    Test_Data    OWB    ${BasePlan_Fund_Name}    ${Fund_Name}
#    Set Calc VP Actual Result With Original And Source    ${Fund_Name}_Current_Value    ${Fund_Current_Value}    ${Fund_Current_Value}    OWB
#    Set Calc VP Actual Result With Original And Source    ${Fund_Name}_Withdrawal_Amount    ${Fund_Withdrawal_Amount}    ${Fund_Withdrawal_Amount}    OWB
#    Set Calc VP Actual Result With Original And Source    Total_Withdrawal_Amount    ${Total_Withdrawal_Amount}    ${Total_Withdrawal_Amount}    OWB
#    Set Calc VP Actual Result With Original And Source    Bank_Name    ${Bank_Name}    ${Bank_Name}    OWB
#    Set Calc VP Actual Result With Original And Source    Fatca_Status    ${Fatca_Status}    ${Fatca_Status}    OWB
#    Set Calc VP Actual Result With Original And Source    Street_Number    ${Street_Address.strip()}    ${Street_Address.strip()}    OWB
#    Set Calc VP Actual Result With Original And Source    City    ${City.strip()}    ${City.strip()}    OWB
#    Set Calc VP Actual Result With Original And Source    State    ${State.strip()}    ${State.strip()}    OWB
#    Set Calc VP Actual Result With Original And Source    Zip_Code    ${Zip_Code.strip()}    ${Zip_Code.strip()}    OWB

#    Post Transaction
#    Set Calc VP Expected Result With Original And Source    Post_Transaction_Total_Withdrawal_Amount    ${Total_Withdrawal_Amount}    ${Total_Withdrawal_Amount}    OWB
#    Set Calc VP Expected Result With Original And Source    Post_Transaction_Bank_Name    ${Bank_Name}    ${Bank_Name}    OWB

#    Set Calc VP Expected Result With Original And Source    Post_Transaction_Street_Number    ${Street_Address.strip()}    ${Street_Address.strip()}    OWB
#    Set Calc VP Expected Result With Original And Source    Post_Transaction_City    ${City.strip()}    ${City.strip()}    OWB
#    Set Calc VP Expected Result With Original And Source    Post_Transaction_State    ${State.strip()}    ${State.strip()}    OWB
#    Set Calc VP Expected Result With Original And Source    Post_Transaction_Zip_Code    ${Zip_Code.strip()}    ${Zip_Code.strip()}    OWB
    Set Calc VP Expected Result With Original And Source
    ...    Transaction_Status_After_OWB
    ...    ${Approved_Status.strip()}
    ...    ${Approved_Status}
    ...    OWB_Application
