*** Variables ***
# edit beneficiary
${EN_ViewPolicy_BeneficiaryTab}                             chain=**/XCUIElementTypeOther[`label == "Beneficiary(s)"`][-1]
${iOS_EN_editbeneficiaryBtn}                                chain=**/XCUIElementTypeButton[`label CONTAINS 'Edit beneficiary'`]
${iOS_EN_add_beneficiary_btn}                               chain=**/XCUIElementTypeOther[`name == "Add beneficiary"`]
${iOS_EN_beneficiary_first_name}                            chain=**/XCUIElementTypeTextField[`name == "beneficiary-firstName"`]
${iOS_EN_beneficiary_middle_name}                           chain=**/XCUIElementTypeOther[`label CONTAINS 'Middle name'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_beneficiary_last_name}                             chain=**/XCUIElementTypeTextField[`name == "beneficiary-lastName"`]
${iOS_EN_beneficiary_dob}                                   chain=**/XCUIElementTypeTextField[`name == "beneficiary-dateOfBirth"`]
${iOS_EN__beneficiary_gender}                               chain=**/XCUIElementTypeOther[`label CONTAINS 'Gender'`][-1]
${iOS_EN_document_type_dropdown}                            chain=**/XCUIElementTypeOther[`label == 'Document type'`][-1]
${iOS_EN_document_number_text_field}                        chain=**/XCUIElementTypeTextField[`name == "beneficiary-docNumber"`]
${iOS_EN_beneficiary_next_done_btn}                         chain=**/XCUIElementTypeButton[`label == 'Done'`][-1]
${iOS_EN_ConfirmBtn}                                        chain=**/XCUIElementTypeButton[`label == 'Confirm'`][-1]
${iOS_EN_beneficiary_relationship}                          chain=**/XCUIElementTypeOther[`label CONTAINS 'Relationship'`][-1]
${iOS_EN_beneficiary_nationality_dropdown}                  chain=**/XCUIElementTypeOther[`label CONTAINS 'Nationality'`][-1]
${iOS_EN_beneficiary_dropdown_search_field}                 chain=**/XCUIElementTypeTextField[`value == 'Search here'`]
${iOS_EN_clickbeneficiary}                                  chain=**/XCUIElementTypeOther[`label == 'Beneficiary(s)'`][-1]
${iOS_EN_uploadsupprotdoc}                                  xpath=//XCUIElementTypeStaticText[contains(@name,'Upload supporting')]/following-sibling::XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]
${iOS_EN_totalallocatopn}                                   chain=**/XCUIElementTypeOther[`label CONTAINS 'Total'`][-2]/XCUIElementTypeOther[1]
${iOS_EN_viewtransaction}                                   chain=**/XCUIElementTypeStaticText[`label CONTAINS 'request transactions'`]
${iOS_EN_transactionPage}                                   chain=**/XCUIElementTypeOther[`label CONTAINS 'beneficiary'`][24]
${iOS_EN_transactiondetails}                                chain=**/XCUIElementTypeOther[`label CONTAINS 'Policy applied'`][-1]
${iOS_EN_add_document_btn}                                  chain=**/XCUIElementTypeOther[`label == 'add-image'`][-1]
${iOS_EN_NewText}                                           chain=**/XCUIElementTypeStaticText[`label == "New!"`]
${iOS_EN_NewEditBtn}                                        chain=**/XCUIElementTypeOther[`name == "beneficiary-edit-new-button"`]
${iOS_EN_policyApplied}                                     chain=**/XCUIElementTypeOther[`label CONTAINS 'Policy applied'`][-1]
${iOS_EN_NewBeneficiaryDetails}                                     chain=**/XCUIElementTypeOther[`label CONTAINS 'New beneficiary(s) details'`][-1]
${iOS_EN_beneficiary_total}                                 chain=**/XCUIElementTypeOther[`label == "Total"`]
${iOS_EN_beneNextButton}                                        chain=**/XCUIElementTypeOther[`label == "Next"`][-1]
${iOS_EN_ChangeBeneficiarydetails}                          chain=**/XCUIElementTypeStaticText[`label == "Change beneficiary(s) details"`]
${iOS_EN_DeleteBeneBtn}                                     chain=**/XCUIElementTypeOther[`name == "beneficiary-delete-button"`]
# delete beneficiary
${iOS_EN_yesBtn}                                            chain=**/XCUIElementTypeButton[`label == 'Yes'`]
${Android_EN_editbeneficiaryBtn}                            android=new UiSelector().textContains("Edit beneficiary(s)")
${Android_EN_add_beneficiary_btn}                           xpath=//android.widget.TextView[@text='Add beneficiary']
${Android_EN_beneficiary_first_name}                        xpath=//android.widget.EditText[@resource-id='beneficiary-firstName']
${Android_EN_beneficiary_middle_name}                       xpath=//android.widget.TextView[@text='Middle name (Optional)']/preceding::android.widget.EditText[1]
${Android_EN_beneficiary_last_name}                         xpath=//android.widget.EditText[@resource-id='beneficiary-lastName']
${Android_EN_beneficiary_nationality_dropdown}              android=new UiSelector().text("Nationality")
${Android_EN_beneficiary_dropdown_search_field}             android=new UiSelector().text("Search here")
${Android_EN_beneficiary_gender}                            xpath=//android.view.ViewGroup[@resource-id='beneficiary-gender']
${Android_EN_beneficiary_dob}                               xpath=//android.widget.EditText[@resource-id='beneficiary-dateOfBirth']
${Android_EN_beneficiary_relationship}                      xpath=//android.view.ViewGroup[@content-desc="Relationship"]
${Android_EN_beneficiary_next_done_btn}                     android=new UiSelector().className("android.widget.Button")
${Android_EN_document_type_dropdown}                        xpath=//android.view.ViewGroup[@resource-id='beneficiary-docType']
${Android_EN_document_number_text_field}                    xpath=//android.widget.EditText[@resource-id='beneficiary-docNumber']
${Android_EN_add_document_btn}                              android=new UiSelector().resourceId("add-image")
${Android_EN_beneficiary_save_btn}                          android=new UiSelector().text("Save")
${Android_EN_Beneficiary_Allocation_Field}                  android=new UiSelector().className("android.widget.EditText")
${Android_EN_Last_Beneficiary_Allocation}                   xpath:(//android.widget.EditText)[last()]
${Android_EN_Fatca_Yes}                                     android=new UiSelector().text("Yes")
${Android_EN_Fatca_No}                                      android=new UiSelector().text("No")
${Android_EN_terms_checkbox}                                android=new UiSelector().description("fwd-checkbox-terms")
${Android_EN_beneficiary_next_btn}                          android=new UiSelector().text("Next")
${Android_EN_NewText}                                       android=new UiSelector().text("New!")
${Android_EN_NewEditBtn}                                    android=new UiSelector().resourceId("beneficiary-edit-new-button")
${Android_EN_beneficiary_total}                             xpath=//android.widget.TextView[@text='Total']
${Android_EN_OTP_Verify_Btn}                                android=new UiSelector().text("Verify")
${Android_EN_Thank_you_message}                             android=new UiSelector().textContains("Thanks")
${Android_EN_View_Transactions}                             android=new UiSelector().textContains("View servicing request transactions")
${Android_EN_Change_Beneficiary}                            android=new UiSelector().text("Change of beneficiary")
${Android_EN_Product_Name}                                  xpath=//android.widget.TextView[@text='Policy applied']/following-sibling::android.view.ViewGroup/android.widget.TextView[1]
${Android_EN_Policy_No}                                     xpath=//android.widget.TextView[@text='Policy applied']/following-sibling::android.view.ViewGroup/android.widget.TextView[2]
${Android_EN_Policy_Status}                                 xpath=//android.widget.TextView[@text='Change of beneficiary(s) details']/following-sibling::android.view.ViewGroup/android.widget.TextView
${Android_EN_Current_Month}                                 xpath=//android.widget.TextView[@text='Change of beneficiary']/preceding-sibling::android.view.ViewGroup/android.widget.TextView[1]
${Android_EN_Current_Date}                                  xpath=//android.widget.TextView[@text='Change of beneficiary']/preceding-sibling::android.view.ViewGroup/android.widget.TextView[2]
${Android_EN_Current_Year}                                  xpath=//android.widget.TextView[@text='Change of beneficiary']/preceding-sibling::android.view.ViewGroup/android.widget.TextView[3]
${Android_EN_Fatca_Status}                                  xpath=//android.widget.TextView[@text='FATCA']/following-sibling::android.widget.TextView[1]
${Android_EN_Address}                                       xpath=//android.widget.TextView[@text='Address']/following-sibling::android.widget.TextView[1]
${Android_EN_capture_US_ID_passport_no}                     xpath=//android.widget.TextView[@text='U.S. ID/Passport No. or Green card']/following-sibling::android.widget.TextView[1]
${Android_EN_capture_US_tax_id_social_security}             xpath=//android.widget.TextView[@text='U.S. Tax ID No. /Social Security No.']/following-sibling::android.widget.TextView[1]
${Android_EN_Expand_Details_Icon}                           xpath=//android.widget.TextView[@text='Change of beneficiary']/following-sibling::android.view.ViewGroup[last()]
${Android_EN_beneficiary_relationship2_edit_dropdown}       xpath=(//android.view.ViewGroup[@resource-id='beneficiary-edit-relation-button'])[2]
${iOS_EN_beneficiary_relationship2_edit_dropdown}           chain=**/XCUIElementTypeOther[`name == "beneficiary-edit-relation-button"`][2]
${Android_EN_OverviewTab}                                   xpath=//android.widget.TextView[@text='Overview']
${Android_EN_BeneficiarysTab}                               xpath=//android.widget.TextView[@text='Beneficiary(s)']
${Android_EN_ChangeBeneficiarydetails}                      xpath=//android.widget.TextView[@text='Change beneficiary(s) details']
${Android_EN_totalBenecountinTransaction}                   xpath=//android.widget.TextView[@text='New beneficiary(s) details']/following-sibling::android.widget.TextView
${Android_EN_beneNextButton}                                xpath=//android.widget.Button[@content-desc="Next"]