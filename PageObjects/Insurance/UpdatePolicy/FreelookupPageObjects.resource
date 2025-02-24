*** Variables ***
${iOS_EN_FreelookCancelation_Option}            chain=**/XCUIElementTypeOther[`label == "Freelook cancellation"`]
${iOS_EN_CancellationReason_DropDown}           chain=**/XCUIElementTypeOther[`label == "Cancellation reason"`]
${iOS_EN_yourpayoutMethodText}                  chain=**/XCUIElementTypeStaticText[`label == 'Your payout method'`]
${iOS_EN_freelookTransactionDetails}            chain=**/XCUIElementTypeOther[`label CONTAINS "Policy applied"`][-1]
${iOS_EN_gracestartDate}                        chain=**/XCUIElementTypeOther[`label CONTAINS 'Started on'`][-1]/XCUIElementTypeStaticText[-1]
${iOS_EN_graceEndDate}                          chain=**/XCUIElementTypeOther[`label CONTAINS 'Ends on'`][-1]/XCUIElementTypeStaticText[-1]
${iOS_EN_ChangePaymentMethod}                   chain=**/XCUIElementTypeOther[`label == 'Change'`]
${iOS_EN_addBankdetails}                        chain=**/XCUIElementTypeOther[`label == 'Add payment method'`][-1]
${iOS_EN_FLC_Terms_Cond}                        accessibility_id=Cancellation-terms-text
${iOS_EN_FLC_Terms_Cond_Header}                 chain=**/XCUIElementTypeStaticText[`label == "Policy Free Look Cancellation Terms and Conditions"`]
#chain=**/XCUIElementTypeStaticText[`label CONTAINS "Terms and conditions"`]
${iOS_EN_FLC_Acknowledgment_Checkbox}           chain=**/XCUIElementTypeOther[`label == "fwd-checkbox-terms"`]
${iOS_EN_recommendMsg}                          accessibility_id=We recommend to continue your policy
${iOS_EN_Close}                                 chain=**/XCUIElementTypeButton[`name == "Close"`]
${Android_EN_FreelookCancelation_Option}        android=new UiSelector().textContains("Freelook cancellation")
${Android_EN_gracestartDate}                    xpath=//android.widget.TextView[contains(@text,'Started on')]/following-sibling::android.widget.TextView
${Android_EN_graceEndDate}                      xpath=//android.widget.TextView[contains(@text,'Ends on')]/following-sibling::android.widget.TextView
${Android_EN_CancellationReason_DropDown}       android=new UiSelector().textContains("Cancellation reason")
${Android_EN_yourpayoutMethodText}              android=new UiSelector().text("Your payout method")
${Android_EN_Policy_applied}                    xpath=//android.widget.TextView[@text='Policy applied']/following-sibling::android.widget.TextView
${Android_EN_Fatca_Status}                      xpath=//android.widget.TextView[@text='FATCA']/following-sibling::android.widget.TextView[1]
${Android_EN_Fatca_Address}                     xpath=//android.widget.TextView[@text='Address']/following-sibling::android.widget.TextView[1]
${Android_EN_Passport_no}                       xpath=//android.widget.TextView[contains(@text,'Passport No')]/following-sibling::android.widget.TextView[1]
${Android_EN_Tax_ID}                            xpath=//android.widget.TextView[contains(@text,'Tax ID No')]/following-sibling::android.widget.TextView[1]
${Android_EN_Cancellation_Reason}               xpath=//android.widget.TextView[contains(@text,'Cancellation reason')]/following-sibling::android.widget.TextView[1]
${Android_EN_Account_Number}                    xpath=//android.widget.TextView[contains(@text,'Payout method')]/following-sibling::android.widget.TextView[1]
${Android_EN_Transaction_Bank_Name}             xpath=//android.widget.TextView[contains(@text,'Payout method')]/following-sibling::android.widget.TextView[2]
