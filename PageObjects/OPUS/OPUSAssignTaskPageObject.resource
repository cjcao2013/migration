*** Variables ***
${EN_Messanger}             xpath=(//div[contains(@class,'switch-drawer-tab-item-icon')])[2]
${EN_STP_Info}              xpath=(//div[contains(@class,'switch-drawer-tab-item-icon')])[3]
${EN_STP_Result_txt}        xpath=//div[contains(text(),'STP Result')]
#${EN_STPResult}             xpath=//div[contains(@class,'renderContent')]

${EN_Msg_Search}            xpath=//input[@placeholder="search"]
${EN_Msg_Name}              xpath=//div[contains(@class,'meta-title')]/div/span[1]
${EN_Assignee_Name}         xpath=//h4[contains(@class,'meta-title')]/span/span[1]
#(//h4[contains(@class,'meta-title')]/span/span[text()='POS Test User 01'])[2]
#${EN_Draft_Btn}             xpath=//i[contains(@class,'anticon-plus')]/parent::button
${EN_Draft_Btn}    xpath=//button[contains(@class,'sm ant-btn-icon-only')]
${EN_Info_Category}         xpath=//div[contains(text(),'Please select an information category')]
${EN_Remark}                xpath=//li[text()='Remark']
${EN_Remark_Txt}            xpath=//textarea[@id="content"]
${EN_Save_Btn}              xpath=//span[contains(@class,'ant-form-item-children')]/child::button
#//li[text()='Approve']
${EN_DelineReason}          xpath=//div[@id='declineReason']
${EN_DeclineReason_txt}     xpath=//li[text()='Others']
${EN_EditDeclineReason}     xpath=//input[@id='editDeclineReason']
${EN_Submit_btn}            xpath=//span[text()='Submit']/parent::button
${EN_RequestStatus}         xpath=((//span[contains(text(),"Status")]/parent::div)[1]/following::td)[5]
${EN_OPUS_DecisionStatus}                   xpath=(//span[text()='Decision']/following::div)[1]
${EN_OPUS_RequestDate}                      xpath=//span[@id='requestDate']/div/input
${EN_OPUS_CaseNo}           xpath=//span[@id="caseno"]