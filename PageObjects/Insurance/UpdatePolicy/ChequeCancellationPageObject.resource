*** Variables ***
${iOS_EN_Cheque_Cancellation}                               accessibility_id=menu-item-ChequeCancellation
${iOS_EN_NextButton}                                        chain=**/XCUIElementTypeOther[`label == "Next"`][-1]
${iOS_EN_Title}                                             chain=**/XCUIElementTypeOther[`label CONTAINS 'Cheque cancellation request'`][-1]
${iOS_EN_Type_Of_Cheque_Title}                              chain=**/XCUIElementTypeStaticText[`name == "Type of cheque"`]
${iOS_EN_Type_Of_Cheque}                                    chain=**/XCUIElementTypeOther[`name == "Type of cheque"`]
${iOS_EN_Done_Button}                                       chain=**/XCUIElementTypeOther[`name CONTAINS 'Done'`][-1]
${iOS_EN_ReasonForCancellation}                             chain=**/XCUIElementTypeOther[`name == "Reason for cancellation"`]
${iOS_EN_AmountPayable}                                     accessibility_id=Amount payable (THB)
${iOS_EN_DoneKeybordButton}                                 chain=**/XCUIElementTypeButton[`name == "Done"`]
${iOS_EN_AddPaymentMethod}                                  chain=**/XCUIElementTypeOther[`label CONTAINS 'Add payment method'`][-1]
${iOS_EN_addPaymentMethodTitle}                             chain=**/XCUIElementTypeStaticText[`name == "Add payment method"`]
${iOS_EN_PromtPayCheckBox}                                  accessibility_id=PromptPay-CheckBox
${iOS_EN_promtpaySaveButton}                                accessibility_id=prompt-pay-submit-button
${iOS_EN_ChequeCancelNextButton}                            chain=**/XCUIElementTypeButton[`name == "ChequeCancelDetails-Next"`]
${iOS_EN_SummaryPage}                                       chain=**/XCUIElementTypeStaticText[`name == "Cheque cancellation request"`]
${iOS_EN_SummaryPageNextButton}                             chain=**/XCUIElementTypeButton[`name == "Submit"`]
${iOS_EN_Dispay_Message}                                    chain=**/XCUIElementTypeStaticText[`name CONTAINS  "This change will affect cheque"`]
${iOS_EN_ConfirmationScreen_STPText_Status}                 chain=**/XCUIElementTypeStaticText[`name == "Your default preferred payout is updated."`]
${iOS_EN_ConfirmationScreen_VanillaText_Status}             chain=**/XCUIElementTypeStaticText[`name CONTAINS "Change of preferred payout is received"`]


${Android_EN_Title}                                         android=new UiSelector().text("Cheque cancellation request")
${Android_EN_Type_Of_Cheque_Title}                          android=new UiSelector().text("Type of cheque")
${Android_EN_Type_Of_Cheque}                                android=new UiSelector().text("Type of cheque")
${Android_EN_Done_Button}                                   android=new UiSelector().text("Done")
${Android_EN_ReasonForCancellation}                         android=new UiSelector().text("Reason for cancellation")
${Android_EN_AmountPayable}                                 android=new UiSelector().resourceId("currency-input")
${Android_EN_AddPaymentMethod}                              android=new UiSelector().text("Add payment method")
${Android_EN_addPaymentMethodTitle}                         android=new UiSelector().text("Add payment method")
${Android_EN_PromtPayCheckBox}                              xpath=(//android.widget.CheckBox[@content-desc="PromptPay-CheckBox"])[1]
${Android_EN_promtpaySaveButton}                            android=new UiSelector().text("Save")
${Android_EN_ChequeCancelNextButton}                        android=new UiSelector().text("Next")
${Android_EN_SummaryPage}                                   android=new UiSelector().text("Cheque cancellation request")
${Android_EN_SummaryPageNextButton}                         android=new UiSelector().description("Submit")




