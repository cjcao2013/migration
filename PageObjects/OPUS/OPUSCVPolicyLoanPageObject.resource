*** Variables ***
${EN_OPUS_CVloan_Request_amount}            xpath=((//span[contains(text(),'Loan Request Amount')]/ancestor::div)[22]/following-sibling::div[1]/descendant::div)[last()]/input
${EN_OPUS_EffectiveDate}                      xpath=(//span[contains(text(),'Effective Date')]/ancestor::div)[22]/following-sibling::div[1]
${EN_OPUS_NetCvloanValue}                          xpath=(//div[contains(@class,'components-policy-loan-index-value')])[4]
${EN_OPUS_cvloan_Payable_amount}            xpath=(//span[contains(text(),'Payable Amount')]/parent::div/parent::label/parent::div/following-sibling::div/descendant::div)[last()]/input
${EN_OPUS_CVloanPolicy_DecisionStatus}        xpath=(//span[text()='Decision']/following::div)[1]
${EN_OPUS_CVloanPolicy_RequestDate}           xpath=//span[@id='requestDate']/div/input
${EN_OPUS_CVloanPolicy_CurrentLoanAmount}     xpath=(//div[contains(@class,'components-policy-loan-index-value')])[2]
${EN_OPUS_cvloanPromtPayID}                     xpath=//input[@id='promptPayId']
${EN_OPUS_cvlaonPaymentMethod}                  xpath=//span[text()='Prompt Pay']
${EN_OPUS_cvlaonLoanAmountAvailable}            xpath=//div[contains(@class,'loanAmountAvailable')]
${EN_OPUs_Transtatus}                xpath=(//div[@id='decision'])/div/div/div

