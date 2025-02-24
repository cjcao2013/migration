*** Variables ***
# ----IOS Variables-------
${iOS_EN_SubmitButton}                                  chain=**/XCUIElementTypeButton[`label == 'Submit'`]
${iOS_EN_Verify}                                        chain=**/XCUIElementTypeButton[`label == 'Verify'`]
${iOS_EN_Fatca_Yes}                                     chain=**/XCUIElementTypeOther[`label == 'Yes'`]
${iOS_EN_Fatca_No}                                      chain=**/XCUIElementTypeOther[`label == 'No'`]
${iOS_EN_acknowledgeChkBox}                             chain=**/XCUIElementTypeOther[`label CONTAINS 'I acknowledge that'`]/XCUIElementTypeOther[-1]
${iOS_EN_NextButton}                                    chain=**/XCUIElementTypeButton[`label == 'Next'`][-1]
${iOS_EN_DoneButton}                                    chain=**/XCUIElementTypeButton[`label == 'Done'`][-1]
${iOS_EN_SaveButton}                                    chain=**/XCUIElementTypeButton[`label == 'Save'`]
${iOS_EN_serviceRequestTransaction}                     chain=**/XCUIElementTypeStaticText[`label == 'View servicing request transactions'`]
${iOS_EN_TransactionServiceRequest}                     chain=**/XCUIElementTypeOther[`label == "Service request(s)"`][2]
${iOS_EN_Thank_you_message}                             chain=**/XCUIElementTypeStaticText[`label CONTAINS 'Thanks'`][-1]
${iOS_EN_TransactionDetail}                             chain=**/XCUIElementTypeOther[`label CONTAINS 'Policy applied'`][-1]
${iOS_EN_ViewTransaction}                               chain=**/XCUIElementTypeOther[`label == "View transactions"`]
${iOS_EN_FeedbackTxt}                                   chain=**/XCUIElementTypeStaticText[`label == 'We’d love to hear from you'`]
${iOS_EN_View_Servicing_Request_Transactions}           chain=**/XCUIElementTypeStaticText[`label == "View servicing request transactions"`]

# ----Android Variables-------
${Android_EN_Fatca_Yes}                                 android=new UiSelector().text("Yes")
${Android_EN_Fatca_No}                                  android=new UiSelector().text("No")
${Android_EN_Verify}                                    android=new UiSelector().text("Verify")
${Android_EN_SubmitButton}                              android=new UiSelector().text("Submit")
${Android_EN_SaveButton}                                android=new UiSelector().text("Save")
${Android_EN_acknowledgeChkBox}                         android=new UiSelector().description("fwd-checkbox-terms")
${Android_EN_DoneButton}                                android=new UiSelector().text("Done")
${Android_EN_NextButton}                                android=new UiSelector().text("Next")
${Android_EN_serviceRequestTransaction}                 android=new UiSelector().textContains("View servicing request transactions")
${Android_EN_Thank_you_message}                         android=new UiSelector().textContains("Thanks")
${Android_EN_TransactionServiceRequest}                 android=new UiSelector().text("Service request(s)")
${Android_EN_FeedbackTxt}                               xpath=//android.widget.TextView[@text="We’d love to hear from you"]
${Android_EN_ViewTransaction}                           android=new UiSelector().text("View transactions")
${Android_EN_View_Servicing_Request_Transactions}       xpath=//android.widget.TextView[@text='View servicing request transactions']
