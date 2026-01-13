*** Variables ***
${iOS_EN_Transaction_Tab}                               chain=**/XCUIElementTypeOther[`label CONTAINS 'View transactions'`][-1]
${iOS_EN_ServiceRequest_section}                        chain=**/XCUIElementTypeOther[`label == "Service request(s)"`][2]
${iOS_EN_TransactionVP}                                 chain=**/XCUIElementTypeOther[`label BEGINSWITH "Policy applied"`][2]
${iOS_EN_BackArrow}                                     chain=**/XCUIElementTypeButton[`name == "back-button"`]
${iOS_EN_Transaction_BackButton}    chain=**/XCUIElementTypeOther[`name == "My transaction(s)"`][2]/XCUIElementTypeOther[1]/XCUIElementTypeOther

${IOS_EN_TransactionTab}                                chain=**/XCUIElementTypeOther[`label == "My transaction(s) See all"`]/XCUIElementTypeOther
${IOS_EN_SeeAll}                                        chain=**/XCUIElementTypeOther[`label == "My transaction(s) See all"`]/XCUIElementTypeOther[-1]
${IOS_EN_ServiceReuest}                                 chain=**/XCUIElementTypeOther[`label == "Service request(s)"`][2]
${IOS_EN_Transactions_first_PersonalDetail}             chain=**/XCUIElementTypeOther[`label == "Oct 11 2023 Change of personal details Completed Policy no: 40763685"`][1]
# **/XCUIElementTypeOther[`label CONTAINS 'Change of personal details Completed' and label CONTAINS 'Policy no: 40763685'`][3]/XCUIElementTypeOther
# **/XCUIElementTypeOther[`label CONTAINS 'Change of personal details'`][1]
${IOS_EN_Transactions_first_PersonalDetail_Address}     chain=**/XCUIElementTypeOther[`label CONTAINS 'Change of address'`][1]
${Swipe}                                                android=new UiSelector().textContains("Change of beneficiary").instance(0)
${IOS_EN_Updated_Email}                                 chain=**/XCUIElementTypeOther[`label CONTAINS 'Email'`][1]
${IOS_EN_TransactionEmail}                              chain=**//XCUIElementTypeOther[`label CONTAINS 'Email'`][2]
# xpath=//XCUIElementTypeOther[`label CONTAINS 'Email'`]/following-sibling::XCUIElementTypeOther[1]
${IOS_EN_TransactionMobile}                             chain=**//XCUIElementTypeOther[`label CONTAINS 'Mobile number'`][2]
# xpath=//XCUIElementTypeOther[@name="Mobile number"]/following-sibling::XCUIElementTypeOther[1]
# xpath=//XCUIElementTypeOther[`label CONTAINS 'Mobile number'`]/following-sibling::XCUIElementTypeOther[1]
${IOS_EN_TransactionTitle}                              xpath=//XCUIElementTypeOther[`label CONTAINS 'Title'`]/following-sibling::XCUIElementTypeOther[1]
${IOS_EN_TransactionFirstName}                          xpath=//XCUIElementTypeOther[`label CONTAINS 'First name'`]/following-sibling::XCUIElementTypeOther[1]
${IOS_EN_TransactionMiddleName}                         xpath=//XCUIElementTypeOther[`label CONTAINS 'Middle name'`]/following-sibling::XCUIElementTypeOther[1]
${IOS_EN_TransactionLastName}                           xpath=//XCUIElementTypeOther[`label CONTAINS 'Last name'`]/following-sibling::XCUIElementTypeOther[1]
${IOS_EN_PolicyNo}                                      xpath=//XCUIElementTypeOther[`label CONTAINS 'Change of personal details'`]/following-sibling::XCUIElementTypeOther[1]
${IOS_EN_TransactionPolicyNo}                           xpath=//XCUIElementTypeOther[`label CONTAINS 'Policy applied'`]/following-sibling::XCUIElementTypeOther/XCUIElementTypeOther[1]
${IOS_EN_TransactionPolicyName}                         xpath=//XCUIElementTypeOther[`label CONTAINS 'Policy applied'`]/following-sibling::XCUIElementTypeOther/XCUIElementTypeOther[1]
${IOS_EN_New_Address}                                   xpath=//XCUIElementTypeOther[`label CONTAINS 'New address'`]/following-sibling::XCUIElementTypeOther[1]
${IOS_EN_Completion_Date}                               chain=**//XCUIElementTypeOther[`label CONTAINS 'Completion date'`][2]
# xpath=//XCUIElementTypeOther[@name="Completion date"]/following-sibling::XCUIElementTypeOther[-1]
# xpath=//XCUIElementTypeOther[`label CONTAINS 'Completion date'`]/following-sibling::XCUIElementTypeOther[1]
${IOS_EN_TransactionStatus}                             xpath=//XCUIElementTypeOther[`label CONTAINS 'Change of personal details'`]/following-sibling::XCUIElementTypeOther/XCUIElementTypeOther[1]
${IOS_EN_Address_TransactionStatus}                     xpath=//XCUIElementTypeOther[`label CONTAINS 'Change of address'`]/following-sibling::XCUIElementTypeOther/XCUIElementTypeOther[1]
# ${IOS_EN_Completed_txt}    chain=**/XCUIElementTypeOther[`label CONTAINS 'Change of personal details Completed Policy no: B00259911'`][24]/XCUIElementTypeOther/XCUIElementTypeOther[11]/XCUIElementTypeOther
${IOS_EN_InProgress_txt}                                chain=**/XCUIElementTypeOther[`label CONTAINS "In progress`][1]
${iOS_EN_Surrender_TransactionPolicyApplied}            chain=**/XCUIElementTypeOther[`label BEGINSWITH "Policy applied"`][-1]
${iOS_EN_TransactionServiceRequest}                     chain=**/XCUIElementTypeOther[`label == "Service request(s)"`][2]
${iOS_EN_TransactionPremiumRequest}                     chain=**/XCUIElementTypeOther[`label == "Premium payment(s)"`][2]

${Android_EN_BackArrow}                                 xpath=//android.widget.Button[@resource-id='back-button']
${Android_EN_TransactionTab}                            android=new UiSelector().textContains("View transactions")
${Android_EN_TransactionServiceRequest}                 android=new UiSelector().textContains("Service request(s)")
${Android_EN_SeeAll}                                    xpath=//android.widget.TextView[@text='My transaction(s)']/following-sibling::android.view.ViewGroup
${Android_EN_TransactionPremiumRequest}                 xpath=//android.widget.TextView[@text="Premium payment(s)"]
