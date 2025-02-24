*** Variables ***
${EN_OPUS_FundSwitch_Decision_Status}        xpath=//div[text()='Approve']
${EN_OPUS_CompletionDate}                    xpath=//span[@id='requestDate']/div/child::input
${EN_SwitchOutFundName}                      xpath=(//div[text()="Fund"])[1]/following::div[1]
${EN_SwitchInFundName}                       xpath=(//div[text()="Fund"])[2]/following::div[1]
${EN_VP_switchOutPercent}                    xpath=(//div[contains(@class,'ant-input-number-input-wrap')])[3]/input
${EN_VP_switchInPercent}                     xpath=(//div[contains(@class,'ant-input-number-input-wrap')])[8]/input
${EN_OPUS_PolicyNumber}                      xpath=//input[@id='policyNo']
${EN_TotalFundList}                          xpath=//div[contains(@class,'tableLayout tableLayout')]/child::div[2]
${EN_OPUS_DecisionStatus}                    xpath=(//div[@id='decision'])/div/div/div
${EN_OPUS_RequestDate}                       xpath=//span[@id='requestDate']/div/input
${EN_DraftButton}                            xpath=//button[contains(@class,'sm ant-btn-icon-only')]
${EN_CatergoryCode}                         xpath=//div[@id="categoryCode"]/div/child::span
${EN_Remark}                                xpath=//li[text()='Remark']
${EN_Remark_Txt}                            xpath=(//textarea[@class='ant-input'])[1]
${EN_InfoSaveButton}                        xpath=//span[contains(@class,'ant-form-item-children')]/child::button
${EN_Draft_Input}                           xpath=(//textarea[@class='ant-input'])[1]
${EN_SubmitButton}                          xpath=(//button[@type='button'])[1]


