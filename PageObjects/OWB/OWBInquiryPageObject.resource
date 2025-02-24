*** Comments ***
# *** Variables ***
# ${EN_AdvanceSearch_link}    xpath=//div[contains(text(),'Advanced Search')]
# ${EN_Policy_no_txt}    id=policyNo
# ${EN_Apply_btn}    xpath=//span[text()='Apply']/parent::button
# ${EN_VP_old_Email_id}    xpath=(//input[@id='email'])[1]
# ${EN_VP_New_Email_id}    xpath=(//input[@id='email'])[2]
# ${EN_Approved_Status}    xpath=(//div[@class='ant-select-selection-selected-value'])[2]
# ${EN_NextArrow}    xpath=//i[@class='anticon anticon-right']
# ${EN_totalpagecount}    xpath=//ul[@class='ant-pagination ant-table-pagination']/li[last()-2]
# ${EN_datesort}    xpath=//span[text()='SUBMISSION DATE']/parent::div
# ${EN_VP_old_MobileNo}    xpath=(//input[@id='mobile'])[2]
# ${EN_VP_New_MobileNo}    xpath=(//input[@id='mobile'])[3]
# ${EN_RequestType}    xpath=(//div[@id='businessTypes'])[1]
# ${EN_RequestInput}    xpath=(//input[@id='businessTypes'])[1]
# ${EN_Approved_Status_Lastinedx}    xpath=(//div[@class='ant-select-selection-selected-value'])[last()]
# ${EN_Approved_Status_fourthIndex}    xpath=(//div[@class='ant-select-selection-selected-value'])[4]
#
#
##((//div[contains(text(),'B00007790')])[1]/ancestor::td/preceding-sibling::td)[1]//input---click on check box
##//div[text()='ServicingAdmin1']=select assignee
##//span[text()='Approve']---status approve or decline


*** Variables ***
${EN_AdvanceSearch_link}                xpath=//div[contains(text(),'Advanced Search')]
${EN_Policy_no_txt}                     id=policyNo
${EN_Apply_btn}                         xpath=//span[text()='Apply']/parent::button
${EN_VP_old_Email_id}                   xpath=(//input[@id='email'])[1]
${EN_VP_New_Email_id}                   xpath=(//input[@id='email'])[2]
${EN_Approved_Status}                   xpath=(//div[@class='ant-select-selection-selected-value'])[last()]
${EN_NextArrow}                         xpath=//i[@class='anticon anticon-right']
${EN_totalpagecount}                    xpath=//ul[@class='ant-pagination ant-table-pagination']/li[last()-2]
${EN_datesort}                          xpath=//span[text()='SUBMISSION DATE']/parent::div
${EN_VP_old_MobileNo}                   xpath=(//input[@id='mobile'])[2]
${EN_VP_New_MobileNo}                   xpath=(//input[@id='mobile'])[3]
${EN_RequestType}                       xpath=(//div[@id='businessTypes'])[1]
${EN_RequestInput}                      xpath=(//input[@id='businessTypes'])[1]
${EN_Approved_Status_Lastinedx}         xpath=(//div[@class='ant-select-selection-selected-value'])[last()]
# address change vp
${EN_currentAdd}                        xpath=//div[text()='CURRENT ADDRESS']
${EN_Curr_Add}                          xpath=//input[@id='currentAddress']
${EN_OWB_Country}                       xpath=//input[@id='countryCode']
${EN_Address_Line1_OWB}                 xpath=//input[@id='addressLine1']
${EN_Address_Line2_OWB}                 xpath=//input[@id='addressLine2']
${EN_City_OWB}                          xpath=//input[@id='addressLine4']
${EN_ZipCode_OWB}                       xpath=//input[@id='zipCode']
${EN_State_OWB}                         xpath=//input[@id='addressLine5']
${EN_District_OWB}                      xpath=//input[@id='addressLine3']
${EN_Comp_Date}                         xpath=//input[@id='endTime']
${EN_Policy_no_txt}                     id=policyNo
${EN_Policy_Name_txt}                   id=productName
${EN_Approved_Status1}                  xpath=(//div[@class='ant-select-selection-selected-value'])
${EN_approve_value}                     xpath=//div[@id='businessDecision']/div/div/div[2]
${EN_Approved_Status_fourthIndex}       xpath=(//div[@class='ant-select-selection-selected-value'])[4]
${EN_personalDetail_CompletionDate}     xpath=//input[@id="endTime"]
${EN_Input_case_no}                     xpath=//input[@id='procInstId']
# ((//div[contains(text(),'B00007790')])[1]/ancestor::td/preceding-sibling::td)[1]//input---click on check box
# //div[text()='ServicingAdmin1']=select assignee
# //span[text()='Approve']---status approve or decline
