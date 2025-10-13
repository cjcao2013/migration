*** Variables ***
${EN_TransactionStatus}         xpath=(//div[@id='decision'])/div/div
${EN_CurrentPayoutOtion}     xpath=//input[@id='originalPayoutOption']
${EN_OPUS_NewPayoutOption}           xpath=(//div[@id='icpOption']/div/div/div)[1]
${EN_NationalID}             xpath=//input[@id='promptpayId']
${EN_CompletionDateOpus}         xpath=(//span[@id='requestDate'])/div/input
${EN_OPUSBank_Name}              xpath=(//div[text()='Bank Name'])[last()]/following-sibling::div[1]
${EN_OPUS_Account_No}             xpath=(//input[@id='bankAccountNo'])[last()]
${EN_OPUS_PromptPayAccount_No}    xpath=(//input[@id='promptPayId'])[last()]
