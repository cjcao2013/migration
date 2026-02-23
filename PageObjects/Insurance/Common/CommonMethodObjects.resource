*** Variables ***
${Android_EN_Ack_Popup}                             xpath=//android.widget.TextView[@text='We’d love to hear from you']
${Android_EN_Response_select}                       xpath=//android.widget.TextView[@text='Good']
# ${Android_EN_Response_checkbox}    xpath=(//android.widget.TextView[contains(@text,'Ease of')]/preceding-sibling::android.view.ViewGroup)
${Android_EN_Skip}                                  xpath=(//android.widget.TextView[@text='Skip'])
${Android_EN_Done}                                  xpath=(//android.widget.TextView[@text='Done'])
${Android_EN_Submit_btn}                            android=new UiSelector().textContains("Submit")
${Android_EN_AddImage}                              xpath=//android.view.ViewGroup[@resource-id="add-more-photo-button"]
${Android_EN_BankName}                              xpath=//android.widget.TextView[@text='Bank name']
${Android_EN_BankAccNo}                             xpath=//android.widget.EditText[@resource-id="account-number-text-input"]
${Android_EN_BankAccountNoInput}                    xpath=//android.widget.EditText[@resource-id="account-number-text-input"]
${Android_EN_SearchBankName}                        xpath=//android.widget.EditText[@text='Search here']
${Android_EN_btnSave}                               android=new UiSelector().text("Save")
${Android_EN_btnDone}                               xpath=//android.widget.TextView[@text='Done']
${Android_EN_Error_MSg_bankaccountno_txt}           xpath=//android.widget.TextView[contains(@text,'Invalid bank account no')]
${Android_EN_BankAcc_HolderName}                    xpath=//android.widget.TextView[@text='Bank account holder name']/following-sibling::android.widget.TextView
${Android_EN_insuranceButton}                       android=new UiSelector().textContains("Insurance")
${Android_EN_HomeButton}                            android=new UiSelector().textContains("Home")
${Android_EN_bankNamebtnDone}                       xpath=//android.widget.TextView[@text='Done']
${Android_EN_SelectBank}                            xpath=//android.widget.TextView[@text='Select bank']
${Android_EN_BankSearch}                            xpath=//android.widget.EditText[@text="Search here"]
${Android_EN_AddBankDetails_Txt}                    xpath=//android.widget.TextView[@text="Add payment method"]
${Android_EN_BankBookCode_Input}                    xpath=(//android.widget.EditText[@resource-id="input"])[1]
${Android_EN_BankBookNumber_Input}                  xpath=(//android.widget.EditText[@resource-id="input"])[2]
${Android_EN_ICPAddImage}                           xpath=(//android.view.ViewGroup[@resource-id='add-more-photo-button']//following-sibling::android.view.ViewGroup)[2]

# ----IOS-----
# ${iOS_EN_SelectBank}    chain=**/XCUIElementTypeStaticText[`label == "Select bank"`]
${iOS_EN_BankSearch}                                chain=**/XCUIElementTypeOther[`label == "Search here"`][1]
${iOS_EN_AddBankDetails_Txt}                        chain=**/XCUIElementTypeStaticText[`label == "Add payment method"`]
${iOS_EN_HomeButton}                                chain=**/XCUIElementTypeButton[`label == 'Home'`]
${iOS_EN_insuranceButton}                           chain=**/XCUIElementTypeButton[`label == 'Insurance'`]
${iOS_EN_BankBookCode_Input}                        chain=**/XCUIElementTypeTextField[`name == "input"`][1]
${iOS_EN_BankBookNumber_Input}                      chain=**/XCUIElementTypeTextField[`name == "input"`][2]

# Fatca Status Change
${Android_EN_Fatca_Status_Change_header}            android=new UiSelector().text("FATCA status change")
${Android_EN_us_id_passport_no}                     xpath=//android.widget.TextView[@text='U.S. ID/Passport No. or Green card']/preceding::android.widget.EditText
${Android_EN_us_tax_id_social_security_no}          xpath=//android.widget.TextView[@text='U.S. Tax ID No. /Social Security No.']/preceding::android.widget.EditText[1]
# Address
${Android_EN_street_number}                         xpath=//android.widget.TextView[@text='Number/Street/Apartment No.']/preceding::android.widget.EditText[1]
${Android_EN_City}                                  xpath=//android.widget.TextView[@text='City']/preceding::android.widget.EditText[1]
${Android_EN_State_Dropdown}                        android=new UiSelector().text("State")
${Android_EN_Postal_Code}                           xpath=//android.widget.TextView[@text='Zip/Postal Code']/preceding::android.widget.EditText[1]
${Android_EN_beneficiary_dropdown_search_field}     android=new UiSelector().text("Search here")
${Android_EN_add_document_btn}                      android=new UiSelector().resourceId("iBank-add-image")
${Android_EN_beneficiary_save_btn}                  android=new UiSelector().text("Save")
${Android_EN_Account_Type_Dropdown}                 android=new UiSelector().text("Account type")

${iOS_EN_AddImage}                                  accessibility_id=iBank-add-image
${iOS_EN_BankName}                                  chain=**/XCUIElementTypeOther[`label CONTAINS 'Bank name'`][-1]
${iOS_EN_SelectBank}                                xpath=//XCUIElementTypeOther[@name="Select bank"]/following::XCUIElementTypeOther[1]/XCUIElementTypeOther[1]
${iOS_EN_SearchBankName}                            chain=**/XCUIElementTypeTextField[`value == 'Search here'`]
${iOS_EN_btnDone}                                   chain=**/XCUIElementTypeOther[`label == 'Done'`][-1]
${iOS_EN_bankNamebtnDone}                           chain=**/XCUIElementTypeOther[`label == 'Done'`][1]
${iOS_EN_BankAccNo}                                 chain=**/XCUIElementTypeOther[`label CONTAINS 'Bank account no'`][-1]
${iOS_EN_BankAccountNoInput}                        chain=**/XCUIElementTypeOther[`label CONTAINS 'Bank account no'`][-1]
${iOS_EN_BankAcc_HolderName}                        chain=**/XCUIElementTypeOther[`label CONTAINS 'Bank account holder name'`][-1]/XCUIElementTypeStaticText[2]
${iOS_EN_Account_Type_Dropdown}                     accessibility_id=Account type
${iOS_EN_btnSave}                                   chain=**/XCUIElementTypeButton[`label == 'Save'`]
${iOS_EN_BranchName}                                chain=**/XCUIElementTypeOther[`label == 'Bank branch'`]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_DeleteRider_AddImage}                      accessibility_id=add-more-photo-button

${iOS_EN_PolicyNotAvailable}                        chain=**/XCUIElementTypeStaticText[`label == "No eligible policy"`][-1]
${Android_EN_PolicyNotAvailable}                    xpath=//android.widget.TextView[@text="No eligible policy"]

# --Facta Yes Page Objects---#
${iOS_EN_Fatca_Status_Change_header}                chain=**/XCUIElementTypeStaticText[`label == 'FATCA status change'`][-1]
${iOS_EN_us_id_passport_no}                         chain=**/XCUIElementTypeOther[`label == 'U.S. ID/Passport No. or Green card'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_us_tax_id_social_security_no}              chain=**/XCUIElementTypeOther[`label == 'U.S. Tax ID No. /Social Security No.'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
# Addreds
${iOS_EN_street_number}                             chain=**/XCUIElementTypeOther[`label == 'Number/Street/Apartment No.'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_City}                                      chain=**/XCUIElementTypeOther[`label == 'City'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_State_Dropdown}                            chain=**/XCUIElementTypeOther[`label CONTAINS 'State'`][-1]
${iOS_EN_Postal_Code}                               chain=**/XCUIElementTypeOther[`label == 'Zip/Postal Code'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_beneficiary_dropdown_search_field}         chain=**/XCUIElementTypeTextField[`value == 'Search here'`]
${iOS_EN_add_document_btn}                          accessibility_id=iBank-add-image
${iOS_EN_ICPAddImage}                               chain=**/XCUIElementTypeOther[`name == "add-more-photo-button"`]
${iOS_EN_UpdatePolicyBackButton}           accssiblity_id=back-button
${iOS_EN_NavigateBackButton}               chain=**/XCUIElementTypeButton[`name == "back-button"`]
${iOS_EN_NavigateBackButton1}               chain=**/XCUIElementTypeOther[`name == "back-arrow-icon"`]

${iOS_EN_FeedbackPage_Title}            chain=**/XCUIElementTypeStaticText[`label == 'We’d love to hear from you'`][1]
${iOS_EN_FeebackEmoji_Option}           chain=**/XCUIElementTypeOther[`label == "Good"`][2]
${iOS_EN_Feedback_CheckBox}             chain=**/XCUIElementTypeOther[`label == "Ease of performing my request"`][2]/XCUIElementTypeOther
${iOS_EN_FeedbackSubmit_Btn}            chain=**/XCUIElementTypeButton[`label == "Submit"`]
${iOS_EN_FeedbackSkip_Btn}              chain=**/XCUIElementTypeOther[`label == "Skip"`]
${iOS_EN_FeedbackDone_Btn}              chain=**/XCUIElementTypeOther[`label == "Done"`][2]
${iOS_EN_FeedbackComment_Txt}           chain=**/XCUIElementTypeTextView[`name == "Type here"`]
${iOS_EN_TellUsMoreTxt}                 chain=**/XCUIElementTypeStaticText[`label == "Tell us more"`]

${iOS_EN_All_Done_Txt}                                  chain=**/XCUIElementTypeStaticText[`label == "All done!"`]
${iOS_EN_Submitted_Txt}                                  chain=**/XCUIElementTypeStaticText[`label == "Submitted"`]
${iOS_EN_Feedback_Txt}              chain=**/XCUIElementTypeStaticText[`label == "We’d love to hear from you"`][2]
${iOS_EN_Seven_Txt}                 chain=**/XCUIElementTypeOther[`label == "7"`][2]
${iOS_EN_Feedback_Claim_CheckBox}             chain=**/XCUIElementTypeOther[`label == "Ease of claim submission"`][2]/XCUIElementTypeOther

${Android_EN_Submitted_Txt}                 android=new UiSelector().text("Submitted")

${iOS_EN_SetPinButton}                          chain=**/XCUIElementTypeButton[`name == "Set Now"`]
${iOS_EN_PIN_input}                 chain=**/XCUIElementTypeTextField
${iOS_Next_button}              chain=**/XCUIElementTypeOther[`label == "Next"`][-1]
${iOS_EN_Confirm_button}            chain=**/XCUIElementTypeButton[`name == "Confirm"`]
${iOS_EN_PaymentRequestTransaction}                     chain=**/XCUIElementTypeButton[`name == "View payments history"`]
${Android_EN_ConfirmButton}               xpath=//android.widget.TextView[@text="Confirm"]
${Android_Next_button}              xpath=//android.widget.Button[@content-desc="Next"]
${Android_EN_PaymentRequestTransaction}         xpath=//android.widget.TextView[@text="View payments history"]

#pin page objects
${iOS_EN_SetPin}               chain=**/XCUIElementTypeButton[`name == "Set Now"`]
${iOS_EN_SetPinField}           chain=**/XCUIElementTypeOther[`name CONTAINS "Set up your PIN"`][-2]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_EnterPinField}         chain=**/XCUIElementTypeOther[`name CONTAINS "your pin"`][-2]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_ConfirmPinField}       chain=**/XCUIElementTypeOther[`name CONTAINS "Almost there"`][-2]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_SkipButton}            chain=**/XCUIElementTypeOther[`name == "Skip"`]

${Android_EN_SetNowPin}                             android=new UiSelector().textContains("Set Now")
${Android_EN_SetPin}                                xpath=(//android.widget.TextView[contains(@text,"Set up your PIN code")]//ancestor::android.view.ViewGroup)[last()-2]//following-sibling::android.widget.EditText
${Android_EN_EnterPinField}                         xpath=(//android.widget.TextView[contains(@text,"your pin")]//ancestor::android.view.ViewGroup)[last()-2]//following-sibling::android.widget.EditText
${Android_EN_ConfirmPinField}                       xpath=(//android.widget.TextView[contains(@text,"Almost there")]//ancestor::android.view.ViewGroup)[last()-2]//following-sibling::android.widget.EditText
${Android_EN_SkipButton}                            android=new UiSelector().textContains("Skip")


#feedback objects
${iOS_EN_FeedbackRangeoption}       chain=**/XCUIElementTypeOther[`label == "8"`][-1]
${iOS_EN_FeedbackReviewOption}       chain=**/XCUIElementTypeOther[`label == "Ease of claims submission"`][2]/XCUIElementTypeOther
${iOS_EN_FeedbackSubmit_Btn}            chain=**/XCUIElementTypeButton[`label == "Submit"`]
${iOS_EN_FeedbackSkip_Btn}              chain=**/XCUIElementTypeOther[`label == "Skip"`]
${iOS_EN_FeedbackDone_Btn}              chain=**/XCUIElementTypeOther[`label == "Done"`][2]
${iOS_EN_FeedbackComment_Txt}           chain=**/XCUIElementTypeTextView[`name == "Type here"`]
${iOS_EN_TellUsMoreTxt}                 chain=**/XCUIElementTypeStaticText[`label == "Tell us more"`]
${iOS_EN_FeedbackPage_Title}            chain=**/XCUIElementTypeStaticText[`label == 'We’d love to hear from you'`][1]
${iOS_EN_FeebackEmoji_Option}           chain=**/XCUIElementTypeOther[`label == "Good"`][2]
${iOS_EN_Feedback_CheckBox}             chain=**/XCUIElementTypeOther[`label == "Ease of performing my request"`][2]/XCUIElementTypeOther
${iOS_EN_Appexperience}                 chain=**/XCUIElementTypeOther[`name == "feedback-star-pressable-4"`][-1]
${iOS_EN_Feedback_NextButton}           accessibility_id=feedback-submit-pressable

${Android_EN_Appexperience}         xpath=(//android.view.ViewGroup[@resource-id="feedback-star-pressable-3"])[1]/android.view.ViewGroup
${Android_EN_Feedback_NextButton}   xpath=//android.widget.Button[@content-desc="Next"]
${Android_EN_TellUsMoreTxt}             xpath=//android.widget.TextView[@text="Tell us more"]
${Android_EN_EditTypeHere}                 xpath=//android.widget.EditText[@text="Type here"]
${Android_EN_FeedbackSubmitButton}     xpath=//android.widget.TextView[@text="Submit"]
${Android_EN_FeedbackDoneButton}          xpath=//android.widget.TextView[@text="Done"


${iOS_EN_Next_button}               xpath=//XCUIElementTypeButton[@name="next-button"]
${iOS_EN_Disclaimer}                chain=**/XCUIElementTypeStaticText[`name == "Disclaimer"`]
${iOS_EN_DisPageNextButton}         chain=**/XCUIElementTypeButton[`name == "Next"`][1]
${iOS_EN_ChangeRecuPageNextButton}  xpath=(//XCUIElementTypeButton[@name="Next"])[1]


${iOS_EN_OverAllAppExperience}                          accessibility_id=overall app experience?
${iOS_EN_FeedBackStars}                                 accessibility_id=feedback-star-pressable-4
${iOS_EN_Awesome}                                        accessibility_id: Awesome!



# regestration feedbcak
${iOS_EN_RegestrationExp}       accessibility_id=registration experience?
${iOS_EN_Regestration_StartFeedback}        chain=**/XCUIElementTypeOther[`name == "feedback-StarUnselectedIcon-4"`]/XCUIElementTypeOther/XCUIElementTypeOther

#monthly Reminder and extra popup
${iOS_EN_Popup_Confirm_btn}           accessibility_id=Confirm
${iOS_EN_Popup_SKIP}                            accessibility_id=Skip

${Android_EN_Popup_Confirm_btn}          android=new UiSelector().text("Confirm")
${Android_EN_Popup_SKIP}                            android=new UiSelector().text("Skip")
${Android_EN_DisPageNextButton}         xpath=//android.widget.Button[@content-desc="Next"]

${Android_EN_UpdatePolicyBackButton}           xpath=//android.widget.Button[@resource-id="back-button"]
${Androdi_EN_DeleteRider_AddImage}              xpath=//android.widget.Button[@content-desc="Next"]
${Android_EN_FeedbackPage_Title}            android=new UiSelector().text("We’d love to hear from you")
${Android_EN_FeebackEmoji_Option}           xpath=//android.view.ViewGroup[@content-desc="Good"]
${Android_EN_Feedback_CheckBox}             xpath=//android.widget.TextView[@text="Ease of performing my request"]/parent::android.view.ViewGroup/child::android.view.ViewGroup
${Android_EN_FeedbackSubmit_Btn}            android=new UiSelector().text("Submit")
${Android_EN_FeedbackSkip_Btn}              android=new UiSelector().text("Skip")
${Android_EN_FeedbackDone_Btn}              android=new UiSelector().text("Done")
${Android_EN_FeedbackComment_Txt}               android=new UiSelector().text("Type here")
${Android_EN_TellUsMoreTxt}                     android=new UiSelector().text("Tell us more")
${Android_EN_All_Done_Txt}                          xpath=//android.widget.TextView[@text='All Done!']