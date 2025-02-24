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