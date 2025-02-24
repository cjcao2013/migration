*** Settings ***
Library     AppiumLibrary


*** Variables ***
${iOS_EN_yourpayoutMethodText}                      chain=**/XCUIElementTypeStaticText[`label == 'Your refund method'`]
${Android_EN_yourpayoutMethodText}                  xpath=//android.widget.TextView[@text='Your refund method']

${iOS_EN_surrenderTransactionDetails}               chain=**/XCUIElementTypeOther[`label CONTAINS "Surrender reason"`][-1]
${Android_EN_surrenderTransactionDetails}           xpath=//android.widget.TextView[@text='Policy applied']

${iOS_EN_FWDInsurance_Option}                       chain=**/XCUIElementTypeButton[`label == "Insurance"`]
${Android_EN_FWDInsurance_Option}                   xpath=//android.widget.TextView[@text='Insurance']

${iOS_EN_UpdatePolicies_Option}                     chain=**/XCUIElementTypeOther[`label == "Update policies"`]
${Android_EN_UpdatePolicies_Option}                 xpath=//android.widget.TextView[@text='Update policies']

${iOS_EN_CancelSurrenderPolicy_OPtion}              chain=**/XCUIElementTypeOther[`label == "Cancel or surrender policy"`]\
${Android_EN_CancelSurrenderPolicy_OPtion}          xpath=//android.widget.TextView[@text='Cancel or surrender policy']

${iOS_EN_SurrenderPolicy_SelectOption}              chain=**/XCUIElementTypeOther[`label == "Surrender policy"`]
${Android_EN_SurrenderPolicy_SelectOption}          xpath=//android.widget.TextView[@text='Surrender policy']

${iOS_EN_LoadingStatus}                             chain=**/XCUIElementTypeOther[`label == "Horizontal scroll bar, 1 page"`][3]

${iOS_EN_Surr_PolicyObj}                            chain=**/XCUIElementTypeOther[`label CONTAINS "88004154"`][-1]
${Android_EN_Surr_PolicyObj}                        xpath=//android.widget.TextView[@text='88004154']

${iOS_EN_SurrenderPolicy_Page}                      chain=**/XCUIElementTypeStaticText[`label == "Surrender Request"`]
${Android_EN_SurrenderPolicy_Page}                  xpath=//android.widget.TextView[@text='Surrender Request']

${iOS_EN_SurrenderReason_DropDown}                  chain=**/XCUIElementTypeOther[`label == "Surrender reason"`]
${Android_EN_SurrenderReason_DropDown}              xpath=//android.widget.TextView[@text='Surrender reason']

${iOS_EN_Reason}                                    chain=**/XCUIElementTypeOther[`label == "I want to use my budget elsewhere"`][1]
# ${Android_EN_Reason}    xpath=//android.widget.TextView[@text='I want to use my budget elsewhere']
${Android_EN_SelectSurrenderReason}                 xpath=//android.widget.TextView[@text='I want to use my budget elsewhere']

${iOS_EN_ReasonSubmission_Btn}                      chain=**/XCUIElementTypeButton[`label == "Done"`]
${Android_EN_ReasonSubmission_Btn}                  xpath=//android.widget.TextView[@text="Done"]

${iOS_EN_Surr_PaymentMethod_Option}                 chain=**/XCUIElementTypeOther[`label == "Add payment method"`]
${Android_EN_Surr_PaymentMethod_Option}             xpath=//android.widget.TextView[@text='Add payment method']
# ${Android_EN_addPaymentMethod}    xpath=//android.widget.TextView[@text='Add payment method']

${iOS_EN_EditBankDetaisl_Page}                      chain=**/XCUIElementTypeStaticText[`label == "Edit bank account"`]
${Android_EN_EditBankDetaisl_Page}                  xpath=//android.widget.TextView[@text='Edit bank account']

${iOS_EN_BankOptions_DropDown}                      chain=**/XCUIElementTypeOther[`label == "Bank name"`][2]
${Android_EN_BankOptions_DropDown}                  xpath=//android.widget.TextView[@text='Bank name']

${iOS_EN_BankName}                                  chain=**/XCUIElementTypeOther[`label == "BDO UNIBANK"`][2]
${Android_EN_BankName}                              xpath=//android.widget.TextView[@text='BDO UNIBANK']

${iOS_EN_BankNameSubmit_Btn}                        chain=**/XCUIElementTypeOther[`label == "Done"`]
${Android_EN_BankNameSubmit_Btn}                    xpath=//android.widget.TextView[@text='Done']

${iOS_EN_AccounNo_InputField}                       chain=**/XCUIElementTypeOther[`label == "Bank account no."`]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${Android_EN_AccounNo_InputField}                   xpath=//android.widget.TextView[@text='Bank account no.']

${iOS_EN_UploadDocuments_Option}                    chain=**/XCUIElementTypeOther[`name == "add-image"`]
${Android_EN_UploadDocuments_Option}                xpath=//android.view.ViewGroup[@resource-id='iBank-add-image']

${iOS_EN_PhotosPermission_PopUp}                    chain=**/XCUIElementTypeStaticText[`label == "“Omne UAT” Would Like to Access Your Photo Library"`]
${Android_EN_PhotosPermission_PopUp}                xpath=//android.widget.TextView[@text='Allow Omne UAT to take pictures and record video?']

${iOS_EN_AllowAccessForAll_Option}                  chain=**/XCUIElementTypeButton[`label == "Allow Full Access"`]
${Android_EN_AllowAccessForAll_Option}              xpath=//android.widget.Button[@text='While using the app']

${iOS_EN_CameraPermission_PopUp}                    chain=**/XCUIElementTypeStaticText[`label == "“Omne UAT” Would Like to Access the Camera"`]
${Android_EN_CameraPermission_PopUp}                xpath=//android.widget.TextView[@text='Allow Omne UAT to access photos and media on your device?']

${iOS_EN_CameraAccessAllow_Btn}                     chain=**/XCUIElementTypeButton[`label == "OK"`]
${Android_EN_CameraAccessAllow_Btn}                 xpath=//android.widget.Button[@text='Allow']

${iOS_EN_UploadPhoto_Page}                          chain=**/XCUIElementTypeStaticText[`label == "Upload bank book"`]
${iOS_EN_CameraSnap_Btn}                            chain=**/XCUIElementTypeOther[`label == "Gallery Done"`]/XCUIElementTypeOther[2]

${iOS_EN_SumbitPhoto_Btn}                           chain=**/XCUIElementTypeOther[`label == "Done"`][1]
${Android_EN_SumbitPhoto_Btn}                       xpath=//android.widget.TextView[@text='Done']

${iOS_BankDetailsSubmit_Btn}                        chain=**/XCUIElementTypeButton[`label == "Save"`]
${Android_BankDetailsSubmit_Btn}                    xpath=//android.widget.TextView[@text='Save']

${iOS_EN_FATCH_status}                              chain=**/XCUIElementTypeOther[`label == "Yes"`]
${Android_EN_FatcaStatus_Yes}                       xpath=//android.widget.TextView[@text='Yes']

${iOS_EN_Surr_Terms_Cond}                           accessibility_id=Surrender-terms-text
${Android_EN_Surr_Terms_Cond}                       accessibility_id=Surrender-terms-text

${iOS_EN_Surr_Terms_Cond_Header}                    chain=**/XCUIElementTypeStaticText[`label == "Policy Surrender Terms and Conditions"`]


${iOS_EN_Surr_Acknowledgment_Checkbox}              chain=**/XCUIElementTypeOther[`label == "fwd-checkbox-terms"`]
${Android_EN_Surr_Acknowledgment_Checkbox}          accessibility_id=fwd-checkbox-terms

${iOS_EN_SurrenderPolicySubmit_Btn}                 chain=**/XCUIElementTypeButton[`label == "Submit"`]
${Android_EN_Fatca_SubmitButton}                    xpath=//android.widget.TextView[@text='Submit']

${iOS_EN_FATCA_Status_Page}                         chain=**/XCUIElementTypeStaticText[`label == "FATCA status change"`]
${Android_EN_FATCA_Status_Page}                     xpath=//android.widget.TextView[@text='FATCA status change']

${iOS_EN_FATCA_Passport_InputField}                 chain=**/XCUIElementTypeOther[`label == "U.S. ID/Passport No. or Green card"`][2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${Android_EN_FATCA_Passport_InputField}             xpath=//android.widget.TextView[@text='U.S. ID/Passport No. or Green card']/preceding-sibling::android.view.ViewGroup//android.widget.EditText

${iOS_EN_FATCA_Tax_InputField}                      chain=**/XCUIElementTypeOther[`label == "U.S. Tax ID No. /Social Security No."`]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${Android_EN_FATCA_Tax_InputField}                  xpath=//android.widget.TextView[@text='U.S. Tax ID No. /Social Security No.']/preceding-sibling::android.view.ViewGroup//android.widget.EditText

${iOS_EN_FATCA_Address_StreetNo_InputFiled}         chain=**/XCUIElementTypeOther[`label == "Number/Street/Apartment No."`][2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${Android_EN_FATCA_Address_StreetNo_InputFiled}     xpath=//android.widget.TextView[@text='Number/Street/Apartment No.']/preceding-sibling::android.view.ViewGroup//android.widget.EditText

${iOS_EN_FATCA_Address_City_InputFiled}             chain=**/XCUIElementTypeOther[`label == "City"`][2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${Android_EN_FATCA_Address_City_InputFiled}         xpath=//android.widget.TextView[@text='City']/preceding-sibling::android.view.ViewGroup//android.widget.EditText

${iOS_EN_FATCA_Address_State_DropDown}              chain=**/XCUIElementTypeOther[`label == "State"`][2]
${Android_EN_FATCA_Address_State_DropDown}          xpath=//android.widget.TextView[@text='State']

${iOS_EN_FATCA_Address_ZipCode}                     chain=**/XCUIElementTypeOther[`label == "Zip/Postal Code"`][2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${Android_EN_FATCA_Address_ZipCode}                 xpath=//android.widget.TextView[@text='Zip/Postal Code']/preceding-sibling::android.view.ViewGroup//android.widget.EditText

${iOS_EN_Tap}                                       chain=**/XCUIElementTypeStaticText[`label == "Address"`]

${iOS_EN_FATCA_Save_Btn}                            chain=**/XCUIElementTypeButton[`label == "Save"`]
${Android_EN_FATCA_Save_Btn}                        xpath=//android.widget.TextView[@text='Save']

${iOS_EN_OTP_Page_Title}                            chain=**/XCUIElementTypeStaticText[`label == "We sent you a code"`]
${Android_EN_OTP_Page_Title}                        xpath=//android.widget.TextView[@text='We sent you a code']

${iOS_EN_ErrorMsg_InvalidOTP}                       chain=**/XCUIElementTypeOther[`label CONTAINS "OTP is invalid"`]

${iOS_SurrenderConformation_Page}                   chain=**/XCUIElementTypeStaticText[`label CONTAINS "Thanks"`]
${Android_SurrenderConformation_Page}               xpath=//android.widget.TextView[contains(@text,"Thanks")]

${iOS_TransactionPage_Link}                         chain=**/XCUIElementTypeOther[`label == "View servicing request transactions"`]

${iOS_EN_ViewTransactionsPage_Title}                chain=**/XCUIElementTypeStaticText[`label == "Transaction(s)"`]
${Android_EN_ViewTransactionsPage_Title}            xpath=//android.widget.TextView[@text='Transaction(s)']

${iOS_EN_RequestServices_Option}                    chain=**/XCUIElementTypeOther[`label == "Service request(s)"`]
${Android_EN_RequestServices_Option}                xpath=//android.widget.TextView[@text='Service request(s)']

${PolicyDetails_arrow}                              xpath=//android.widget.TextView[@text='Surrender policy']/following-sibling::android.view.ViewGroup
${Android_EN_Transaction_Status_VP}                 xpath=//android.widget.TextView[@text='Surrender policy']/following-sibling::android.view.ViewGroup//android.widget.TextView
${Android_EN_Fatca_status_VP}                       xpath=//android.widget.TextView[@text='FATCA']/following-sibling::android.widget.TextView[1]
${Android_EN_Policy_applied_VP}                     xpath=//android.widget.TextView[@text='Policy applied']/following-sibling::android.widget.TextView
${Android_EN_Surrender_reason_VP}                   xpath=//android.widget.TextView[@text='Surrender reason']/following-sibling::android.widget.TextView
${Android_EN_Surrender_estimate_value_VP}           xpath=//android.widget.TextView[@text='Estimated surrender value']/following-sibling::android.widget.TextView
${Android_EN_BankName_VP}                           xpath=(//android.widget.TextView[@text='Refund method']/following-sibling::android.widget.TextView)[2]
${Android_EN_Bank_AccountNo_VP}                     xpath=(//android.widget.TextView[@text='Refund method']/following-sibling::android.widget.TextView)[1]

${FatcaAdd_VP}                                      xpath=//android.widget.TextView[@text='Address']/following-sibling::android.widget.TextView[1]
${ID_No_VP}                                         xpath=//android.widget.TextView[@text='U.S. ID/Passport No. or Green card']/following-sibling::android.widget.TextView[1]
${TaxNo_VP}                                         xpath=//android.widget.TextView[@text='U.S. Tax ID No. /Social Security No.']/following-sibling::android.widget.TextView[1]
