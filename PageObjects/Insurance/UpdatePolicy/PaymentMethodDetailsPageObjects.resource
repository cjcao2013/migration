*** Variables ***
${iOS_EN_Add_payment_method}                                        chain=**/XCUIElementTypeOther[`label == 'Add payment method'`]
${iOS_EN_cardHolderName}                                            chain=**/XCUIElementTypeTextField[`name == "RecurringPayment-card-holder-name-input"`]
# **/XCUIElementTypeOther[`label == 'Cardholder name'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_cardNumber}                                                chain=**/XCUIElementTypeTextField[`name == "RecurringPayment-credit-card-number-input"`]
# **/XCUIElementTypeOther[`label == "Credit card no."`][2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
# **/XCUIElementTypeTextField[`name == "input"`][2]
# **/XCUIElementTypeOther[`label == 'Credit card no.'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_cardExpiryDate}                                            chain=**/XCUIElementTypeTextField[`name == "RecurringPayment-credit-card-expiry-input"`]
# **/XCUIElementTypeOther[`label == "Expiry MM/YY"`][2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
# **/XCUIElementTypeTextField[`name == "input"`][3]
# **/XCUIElementTypeOther[`label CONTAINS 'Expiry'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_RecurringPayment_HeaderText}                               accessibility_id=Recurring payment
${iOS_EN_RecurringPayment_SubHeaderText}                            chain=**/XCUIElementTypeStaticText[`label == "Your recurring payment method"`]
${iOS_EN_RecurringPayment_DisclaimerText}                           chain=**/XCUIElementTypeStaticText[`label == "Disclaimer"`]
${iOS_EN_RecurringPayment_DisclaimerContent}                        xpath=//XCUIElementTypeOther[@name="Disclaimer"]/following-sibling::XCUIElementTypeStaticText
${iOS_EN_RecurringPayment_PolicyNUmber}                             xpath=//XCUIElementTypeStaticText[@label="This recurring payment will be applied to"]//following::XCUIElementTypeStaticText[1]
${iOS_EN_RecurringPayment_PolicyName}                               xpath=//XCUIElementTypeStaticText[@label="This recurring payment will be applied to"]//following::XCUIElementTypeStaticText[2]
${iOS_EN_RecurringPayment_Checkbox}                                 chain=**/XCUIElementTypeOther[`name == "RecurringPayment-terms-checkbox"`]
${iOS_EN_RecurringPayment_CardNumber_Below_16digit_ErrorMsg}        chain=**/XCUIElementTypeStaticText[`label == "Please input at least 16 digits"`]
${iOS_EN_RecurringPayment_CardNumber_Invalid_ErrorMsg}              chain=**/XCUIElementTypeStaticText[`label == "Please input a valid credit card number"`]
${iOS_EN_RecurringPayment_ExpiryDate_ErrorMsg}                      chain=**/XCUIElementTypeOther[`label == "Please input a credit card with an expiry date of at least 6 months from today"`][3]
${iOS_EN_RecurringPayment_SucessMessage}                            chain=**/XCUIElementTypeOther[`label == "Change success! Just confirming we’ve successfully submitted your service request."`][5]
${iOS_EN_RecurringPayment_EditButton}                               chain=**/XCUIElementTypeOther[`label == "Edit"`]
${iOS_EN_HeaderText}                                                chain=**/XCUIElementTypeStaticText[`label == "Change recurring payment"`]
${iOS_EN_Recurring_ViewSummary}                                     chain=**/XCUIElementTypeStaticText[`label == "View summary"`]
${iOS_EN_SummaryPage_paymentMethod}                                 chain=**/XCUIElementTypeOther[`label BEGINSWITH "New recurring payment details"`][1]
${iOS_EN_SummaryPage_PolicyApplied}                                 xpath=(//XCUIElementTypeOther[contains(@name,"Policy applied")])[last()-1]
${iOS_EN_BackButton_Arrow}                                          chain=**/XCUIElementTypeOther[`label BEGINSWITH "Update policies"`][3]/XCUIElementTypeOther[1]/XCUIElementTypeOther
${iOS_EN_Transaction_Tab}                                           chain=**/XCUIElementTypeOther[`label CONTAINS 'View transactions'`][-1]
${iOS_EN_ServiceRequest_section}                                    chain=**/XCUIElementTypeOther[`label == "Service request(s)"`][2]
${iOS_EN_TransactionVPRCC}                                          chain=**/XCUIElementTypeOther[`label CONTAINS "Policy applied"`][27]
${iOS_EN_Required_Error_TXT}                                        chain=**/XCUIElementTypeStaticText[`label == "Required"`]
${iOS_EN_No_SingleCharAllow_Error_TXT}                              chain=**/XCUIElementTypeStaticText[`label == "No single character input allowed"`]
${iOS_EN_RecurringPayment_NoteText}                                 accessibility_id=RecurringPayment-note-text


${Android_EN_RecurringPayment_NoteText}                             android=new UiSelector().resourceId("RecurringPayment-note-text")
${Android_EN_Add_payment_method}                                    xpath=(//android.widget.TextView[contains(@text,'Add payment method')])
${Android_EN_cardHolderName}                                        xpath=//android.widget.EditText[@resource-id='RecurringPayment-card-holder-name-input']
${Android_EN_cardNumber}                                            xpath=//android.widget.EditText[@resource-id='RecurringPayment-credit-card-number-input']
${Android_EN_cardExpiryDate}                                        xpath=//android.widget.EditText[@resource-id='RecurringPayment-credit-card-expiry-input']
${Android_EN_RecurringPayment_HeaderText}                           xpath=//android.widget.TextView[@text='Change recurring payment']
${Android_EN_RecurringPayment_SubHeaderText}                        xpath=//android.widget.TextView[@text="Your recurring payment method"]
${Android_EN_RecurringPayment_DisclaimerText}                       xpath=//android.widget.TextView[@text='Disclaimer']
${Android_EN_RecurringPayment_DisclaimerContent}                    xpath=(//android.widget.TextView[@text='Disclaimer']/following::android.widget.TextView)[1]
${Android_EN_RecurringPayment_Checkbox}                             xpath=//android.view.ViewGroup[contains(@resource-id,"terms-checkbox")]/android.view.ViewGroup
${Android_EN_RecurringPayment_CardNumber_Below_16digit_ErrorMsg}    xpath=//android.widget.TextView[@text='Please input at least 16 digits']
${Android_EN_RecurringPayment_CardNumber_Invalid_ErrorMsg}          xpath=//android.widget.TextView[@text='Please input a valid credit card number']
${Android_EN_RecurringPayment_ExpiryDate_ErrorMsg}                  xpath=//android.widget.TextView[@text='Please input a credit card with an expiry date of at least 6 months from today']
${Android_EN_RecurringPayment_SucessMessage}                        xpath=(//android.widget.TextView[@text ='Just confirming we’ve successfully submitted your service request.'])
${Android_EN_RecurringPayment_EditButton}                           xpath=//android.widget.TextView[@text='Edit']
${Android_EN_HeaderText}                                            xpath=//android.widget.TextView[@text='Change recurring payment']
${Android_EN_Recurring_ViewSummary}                                 xpath=//android.widget.TextView[@text='View summary']
${Android_EN_SummaryPage_paymentMethod}                             xpath=(//android.widget.TextView[@text='Payment method']/following::android.widget.TextView)[1]
${Android_EN_SummaryPage_CardHolderName}                            xpath=(//android.widget.TextView[@text='Cardholder name']/following::android.widget.TextView)[1]
${Android_EN_SummaryPage_CreditCardNo}                              xpath=(//android.widget.TextView[@text='Credit card no.']/following::android.widget.TextView)[1]
${Android_EN_SummaryPage_ExpiryDate}                                xpath=(//android.widget.TextView[@text='Expiry date']/following::android.widget.TextView)[1]
${Android_EN_SummaryPage_PolicyName}                                xpath=(//android.widget.TextView[@text='Policy applied']/following::android.widget.TextView)[1]
${Android_EN_SummaryPage_PolicyNo}                                  xpath=(//android.widget.TextView[@text='Policy applied']/following::android.widget.TextView)[2]
${Android_EN_BackButton_Arrow}                                      xpath=(//android.widget.TextView[@text='Update policies']/preceding::android.view.ViewGroup)[3]
${Android_EN_Transaction_Tab}                                       android=new UiSelector().textContains("View transactions")
${Android_EN_ServiceRequest_section}                                android=new UiSelector().textContains("Service request(s)")
${Android_EN_Transaction_PaymentMethod}                             xpath=(//android.widget.TextView[@text='New payment method']/following::android.widget.TextView)[1]
${Android_EN_Transaction_CardHolderName}                            xpath=(//android.widget.TextView[@text='Cardholder name']/following::android.widget.TextView)[1]
${Android_EN_Transaction_CreditCardNo}                              xpath=(//android.widget.TextView[@text='Credit card no.']/following::android.widget.TextView)[1]
${Android_EN_Transaction_PolicyName}                                xpath=(//android.widget.TextView[@text='Policy applied']/following::android.widget.TextView)[1]
${Android_EN_Transaction_PolicyNo}                                  xpath=(//android.widget.TextView[@text='Policy applied']/following::android.widget.TextView)[2]
${Android_EN_Transaction_ExpiryDate}                                xpath=(//android.widget.TextView[@text='Expiry date']/following::android.widget.TextView)[1]
${Android_EN_Transaction_CompletionDate}                            xpath=(//android.widget.TextView[@text='Completion date']/following::android.widget.TextView)[1]
${Android_EN_Update_BackButton}                                     xpath=(//android.widget.TextView[@text='Update policies']/preceding::android.view.ViewGroup)[3]
