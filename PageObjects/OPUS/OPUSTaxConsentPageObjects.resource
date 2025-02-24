*** Variables ***
${EN_OPUS_TaxconsentOption}              xpath=(//div[@id="taxConsentOption"])/div/div/div[1]
${EN_OPUS_TaxconsentPolicyDetails}       xpath=(//*[@class="react-app-process-o-w-b-life-details-servicing-selected-policy-index-item"])
${EN_STP_Result}                    xpath=//div[contains(text(),'STP Result')]
${EN_OPUS_TransactionStatus}           xpath=//div[@id='decision']/div/div/div[1]
${EN_OPUS_RequestDatedata}              xpath=//span[@id='requestDate']/div/input
#(//span[text()='Request Date']/following::div)[1]