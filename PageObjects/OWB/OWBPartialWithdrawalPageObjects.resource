*** Variables ***
${EN_partial_withdrawal_header}             xpath=//div[text()='Partial Withdrawal' and contains(@class,'header')]
${EN_Total_Withdrawal_Amount}               xpath=//span[text()='Total Withdrawal Amount']//following::div[contains(@class,'currency-index-field')][last()]
${EN_Payout_Option}                         id:payoutOption
${EN_Current_Fund_Value}                    id:accountValue
${EN_Withdrawal_Percentage}                 class:withdrawalPct
${EN_Withdrawal_Amount}                     class:withdrawalAmt
${EN_Fund_Code}                             xpath=(//div[@class='fund'])[last()]
# ${EN_Bank_Name}    id:bankName
${EN_Fatca_Status1}                         id=fATCAStatus
# //div[@id='fATCAStatus']/descendant::div[contains(@class,'selected-value')]
${EN_US_ID_Passport}                        id:passportGreenCardNo
${EN_US_Tax_Id_social_security}             id:usTissNumber
${EN_Street_Address}                        id:fatcaAddress
${EN_City}                                  id:city
${EN_State}                                 id:state
${EN_Zipcode}                               id:zipCode

${EN_TotalWithdrwalAmount}                  xpath=//span[text()='Total Withdrawal Amount']/ancestor::div[4]/div/div/div[2]/div[1]
# xpath=//span[text()='Total Withdrawal Amount']/ancestor::div[last()-19]/div/div/div[2]/div
${EN_ChargeAmount}                          xpath=//input[@role='spinbutton']
${EN_Netwithdrawl}                          xapth=//span[text()='Net Withdrawal Amount']/ancestor::div[last()-19]/div/div/div[2]/div
${EN_payoutOption}                          xpath=(//input[@id='payoutOption'])[1]
${EN_totalFundCount}                        xpath=(//tbody[@class='ant-table-tbody'])[1]/tr
${EN_funddetails}                           xpath=(//tbody[@class='ant-table-tbody'])[1]/tr/td[10]/div/div
${EN_owbCompletionDate}                     xpath=//input[@id='endTime']
${EN_Bank_Name}                             xpath=//input[@id='bankName']
${EN_CardNumber}                            xpath=//input[@id='accountNumber']
${EN_partialwithdrawlApprovalStatus}        xpath=//div[@id='businessDecision']/div/div/div[2]
${EN_VP_FundName}                           xpath=//div[@class='fund']
${EN_VP_switchOutAmount}                    xpath=//div[@class='switchOutAmount']
${EN_VP_switchOutPerc}                      xpath=//div[@class='switchOutPerc']
${EN_VP_switchInAmount}                     xpath=//div[@class='switchInAmount']
${EN_VP_switchInPerc}                       xpath=//div[@class='switchInPerc']
${EN_VP_valuationDate}                      xpath=//div[@class='valuationDate']
${EN_VP_EstimatedTotalSwitchinoutAmount}    xpath=(//div[contains(@class,"-form-item-number-currency-index-field")])[2]
${EN_VP_Bank_Name}                          xpath=//input[@id='bankName']
${EN_VP_Account_No}                         xpath=//input[@id='accountNumber']
${EN_totDocumentCount}                      xpath=//div[@class='react-app-pages-document-styles-documentList']/div
${EN_VP_holdername}                         xpath=//input[@id='holderName']
