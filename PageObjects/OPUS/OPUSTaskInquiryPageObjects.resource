*** Variables ***
${EN_search_Icon}       xpath=//i[@class='anticon react-app-layouts-workspace-layout-search-icon']
${EN_inputPolicyNumber}     xpath=//input[@id='policyNo']
${EN_taskInquiryOption}     xpath=(//i[@class='anticon'])[2]
${EN_caseInquiryOption}     xpath=(//i[@class='anticon'])[1]
${EN_CaseCategoryOption}       xpath=(//div[@id='caseCategory'])[2]
# select case category=//li[text()='POS Decision']
${EN_input_businessType}      xpath=(//div[@id='businessType'])[2]//child::input
${EN_input_policystatus}      xpath=(//input[@id='taskStatus'])    #ToDo
${EN_search_Button}         xpath=(//button[@class='ant-btn react-app-components-table-search-search-vetical-btnSubmit ant-btn-primary'])[1]
${EN_DueDate_Sort}          xpath=(//span[text()='Due Date'])[2]/following-sibling::span/div[@title='Sort']
${EN_CaseNo_Search}        xpath=//input[@id='processInstanceId']
#${EN_input_CaseNo}      xpath=//input[@id='processInstanceId']
${EN_input_caseNo}      xpath=//input[@id='processInstanceId']
${EN_EWorksheet}            xpath=//span[contains(text(),'E-Worksheet')]
${EN_EWorksheet_txt}        xpath=//span[contains(text(),'WORKSHEET')]

${EN_Envoy}                        xpath=(//div[contains(@class,'switch-drawer-tab-item-icon')])[4]
${EN_Add-Envoy_button}             xpath=//button[contains(@class,'btnAddEnvoy ant-btn-sm')]
${EN_Select_Pending_reason}        xpath=//div[contains(text(),'Please select a pending reason.')]
${EN_Further_Requirement}          xpath=//li[text()='Further Requirement']
#${EN_MemoCode}                     xpath=(//div[@id='memoCode'])[1]
${EN_MemoCode}                     xpath=(//div[@id='memoCode'])[1]//descendant::span[3]
${EN_Select_Memocode}              xpath=//li[contains(text(),'M0001')]
${EN_ReasonCode}                   xpath=(//div[@id='reasonCode'])[1]
${EN_SelectReasonCode}             xpath=//li[contains(text(),'RS0001')]
${EN_SaveButton}                   xpath=(//button[@class='ant-btn Save'])[1]
${EN_SendButton}                   xpath=(//button[@class='ant-btn Send'])[1]
${EN_ResolveButton}                xpath=(//button[@class='ant-btn Resolve'])[1]
${EN_OPUS_DecisionStatus}           xpath=(//span[text()='Decision']/following::div)[1]



${EN_VP_old_Title}              xpath=(//input[@id='newSalutation'])[1]
${EN_VP_old_FirstName}          xpath=(//input[@id='firstName'])[1]
${EN_VP_old_MiddleName}         xpath=(//input[@id='middleName'])[1]
${EN_VP_old_LastName}           xpath=(//input[@id='surname'])[1]
${EN_VP_old_MaritalStatus}      xpath=(//input[@id='maritalStatus'])[1]
${EN_VP_OPUS_new_Title}              xpath=(//div[text()='Title'])/following-sibling::div[1]
${EN_VP_OPUS_new_FirstName}          xpath=(//input[@id='firstName'])
${EN_VP_OPUS_new_MiddleName}         xpath=(//input[@id='middleName'])
${EN_VP_OPUS_new_LastName}           xpath=(//input[@id='surname'])
${EN_VP_OPUS_new_MaritalStatus}      xpath=(//div[text()='Marital Status'])/following-sibling::div[1]

${EN_TransactionStatus}         xpath=(//div[@id='decision'])/div/div






