*** Variables ***
${EN_StotalFundCount}                       xpath=(//tbody[@class='ant-table-tbody'])[1]/tr
${EN_funddetails}                           xpath=(//tbody[@class='ant-table-tbody'])[1]/tr/td[10]/div/div
${EN_VP_EstimatedTotalSwitchinoutAmount}    xpath=(//div[contains(@class,"-form-item-number-currency-index-field")])[2]
${EN_switchfundfactaStatus}                 xpath=(//div[@id='fATCAStatus']//div/div/div)[1]
${EN_switchfundPolicyNo}                    xpath=(//input[@id='policyNo'])[2]
${EN_switchfundApprovalStatus}              xpath=//div[@id='businessDecision']/div/div/div[2]
