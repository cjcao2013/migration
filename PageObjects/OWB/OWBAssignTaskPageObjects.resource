*** Variables ***
${EN_AssignTask}                    xpath=//div[text()='Assign Tasks']
${EN_assigneeOption}                xpath=//div[@id='assignee']
${EN_inputassignee}                 xpath=//input[@id='assignee']
${EN_AssigndoneBtn}                 xpath=//span[text()='Done']//parent::button
${EN_OKBtn}                         xpath=//span[text()='OK']//parent::button
${EN_completeBtn}                   xpath=(//span[text()='Complete']//parent::button)[1]
${EN_statuscompleteBtn}             xpath=(//span[text()='Complete']//parent::button)[last()]
${EN_startNextJobBtn}               xpath=(//span[text()='Start Next Job']//parent::button)[1]
${EN_inquirybackBtn}                xpath=//button[@class='ant-btn react-app-process-o-w-b-life-customer-header-index-leftButton']
${EN_declineReason}                 xpath=//input[@id='declineCode']
${EN_declineReasonOption}           xpath=//div[@id='declineCode']/div/div/div
${EN_pendingDocumentType}           xpath=(//input[@id='memoCode'])[last()]
${EN_pendingDocumentTypeOption}     xpath=(//div[@id='memoCode']/div/div)[last()]
${EN_pendingReason}                 xpath=(//input[@id='subTypeCode'])[last()]
${EN_pendingReasonOption}           xpath=(//div[@id='subTypeCode']/div/div)[last()]
${EN_ResonDisplayField}             xpath=(//textarea[@id='memoDesc'])[last()]
${EN_pendAddNewButton}              xpath=//span[text()='Add new']//parent::button
${EN_PendBtn}                       xpath=(//span[text()='Pend']//parent::button)[1]
${EN_statusPendBtn}                 xpath=(//span[text()='Pend']//parent::button)[last()]
${EN_PendRequestPage}               xpath=//div[text()='Pend Request']
${EN_CoreSystemclaimNo}             xpath=(//input[@id='coreSystemClaimNo'])[1]
${EN_EffectiveDate}                 xpath=(//i[contains(@class,'ant-calendar-picker-icon')])[2]
${EN_TodayDate}                     xpath=//td[contains(@class,'ant-calendar-today')]
${EN_PayableAmount}                 xpath=//input[@id='payableAmount']
${EN_Comment}                       xpath=//textarea[@id='note']
${EN_Complete_Btn}                  xpath=(//span[text()='Complete'])[2]
