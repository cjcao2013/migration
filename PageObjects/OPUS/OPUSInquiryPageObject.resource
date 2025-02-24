*** Variables ***
${EN_Search_link}           xpath=//div[contains(@class,"search-container")]
${EN_Policy_no_txt}         id=policyNo
${EN_Case_No_txt}           id=processInstanceId
${EN_Search_btn}            xpath=//span[text()="Search"]/parent::button
${EN_Policy_text}           xpath=//td[contains(@class,"Policy No")]
${EN_searchToStartInquiry_TXT}    xpath=//span[contains(.,'Search’ to start inquiry')]
${EN_CaseNo_text}           xpath=(//span[contains(text(),"Case No.")]/parent::div)[1]
${EN_PolicyDetails}         xpath=//div[text()='Policy Details']
${EN_TransactionDetails}    xpath=//div[text()='Transaction Details']
${EN_OPUS_ApprovedStatus}   xpath=//div[@id="decision"]
${EN_CaseNo}                xpath=((//span[contains(text(),"Case No.")]/parent::div)[1]/following::td)[3]
${EN_SubmissionDate}        xpath=//th[@class="Submission Date]
${EN_AdvancedSearch_CaseInquiry}        xpath=(//div[contains(@class,'advanced-query-switch')])[1]
${EN_AdvancedSearch_TaskInquiry}        xpath=(//div[contains(@class,'advanced-query-switch')])[2]

${EN_OPUS_CaseNo}           xpath=//span[@id="caseno"]
#Shweta
${EN_CaseCategory}          xpath=(//label[text()='Case Category'])[1]/parent::div/following-sibling::div
${EN_CurrentActivity}       xpath=(//label[text()='Current Activity'])[1]/parent::div/following-sibling::div
${EN_BusinessType}          xpath=(//label[text()='Business Type'])[1]/parent::div/following-sibling::div/descendant::input
${EN_POS_Decision}          xpath=//li[text()='POS Decision']
${EN_Completed}             xpath=//li[text()='Completed']


${EN_STP_Info}              xpath=(//div[contains(@class,'switch-drawer-tab-item-icon')])[3]
#${EN_STP_Result_txt}        xpath=//div[contains(text(),'STP Result')]
#${EN_STP_Result_txt}        xptah=(//div[contains(@class,'content-list-scrollWrap')])[2]/child::div/child::i
${EN_STP_Result_txt2}        xpath=//*[@id="hotkey_SidebarPage"]/div/div[2]/div[1]/div/div[3]/div[2]/div[2]/div[2]/div/div[2]/div/i
${EN_STP_Result_txt3}        xpath=//*[@id="hotkey_SidebarPage"]/div/div[2]/div[1]/div/div[3]/div[2]/div[2]/div[2]/div/div[3]/div/i
${EN_STP_Result_txt1}        xpath=//*[@id="hotkey_SidebarPage"]/div/div[2]/div[1]/div/div[3]/div[2]/div[2]/div[2]/div/div[1]/div/i
${EN_Exceptional_Message_txt}    xpath=//*[@id="hotkey_SidebarPage"]/div/div[2]/div[1]/div/div[3]/div[2]/div[2]/div[2]/div/div[2]/div/i
${EN_Exceptional_Msg1}           xpath=(//div[contains(@class,'renderContent')])[1]
${EN_STP_Result_MSG1}             xpath=//div[contains(@class,'renderContent')]

#${EN_STP_Result}             xpath=//div[contains(text(),'STP Result')]/parent::div/following-sibling::div//descendant::div[25]

