*** Variables ***
${EN_OPUS_TotalWithdrwalAmount}                  xpath=//input[@id="totalAmount"]
# xpath=//span[text()='Total Withdrawal Amount']/ancestor::div[last()-19]/div/div/div[2]/div
${EN_OPUS_totalFundCount}                        xpath=//div[text()="Fund"]/parent::div
${EN_OPUS_DecisionStatus}                   xpath=(//span[text()='Decision']/following::div)[1]
${EN_OPUS_RequestDate}                      xpath=//span[@id='requestDate']/div/input
