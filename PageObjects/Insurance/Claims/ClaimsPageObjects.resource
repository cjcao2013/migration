*** Variables ***
${iOS_EN_confirmPopup}                              chain=**/XCUIElementTypeButton[`label == 'No'`]
${iOS_EN_claimantOption}                            chain=**/XCUIElementTypeOther[`label CONTAINS 'Claimant'`][-1]
${iOS_EN_ClaimTypeOption}                           chain=**/XCUIElementTypeOther[`label CONTAINS 'Claim type'`][-1]
${iOS_EN_PolicyOption}                              chain=**/XCUIElementTypeOther[`label CONTAINS 'Policy'`][-1]
#${iOS_EN_ClaimchkBox}                               chain=**/XCUIElementTypeOther[`label CONTAINS 'I received'`][-1]
${iOS_EN_ClaimchkBox}                               chain=**/XCUIElementTypeOther[`name == "PromptPay-CheckBox"`]
${iOS_EN_declareChkBox}                             chain=**/XCUIElementTypeOther[`label CONTAINS 'All details'`]/XCUIElementTypeOther[-2]
# add payment method
${iOS_EN_select_Bank_Account}                       chain=**/XCUIElementTypeOther[`label == "Bank account"`][2]
${iOS_EN_Add_payment_method}                        chain=**/XCUIElementTypeOther[`label == 'Add payment method'`]
${iOS_EN_uploadBankBookclaim}                       accessibility_id=add-more-photo-button
${iOS_EN_bankNameclaim}                             chain=**/XCUIElementTypeOther[`label CONTAINS 'Bank name'`][-1]
${iOS_EN_bankAccNoclaim}                            chain=**/XCUIElementTypeOther[`label CONTAINS 'Bank account no'`][-1]
# ${iOS_EN_saveBtnclaim}    chain=**/XCUIElementTypeButton[`label == 'Save'`]
${iOS_EN_saveBtn}                                   chain=**/XCUIElementTypeButton[`label == 'Save'`]
${iOS_EN_obj_doneButton}                            chain=**/XCUIElementTypeOther[`label == 'Done'`][1]
${ios_EN_Start_Camera}                              chain=**/XCUIElementTypeButton[`name == "Start camera"`]
# change payment method
${iOS_EN_Changepayment_method}                      chain=**/XCUIElementTypeOther[`label == 'Change'`]
${iOS_EN_prompt_pay_Tab}                            chain=**/XCUIElementTypeOther[`label == 'PromptPay'`][-1]
#${iOS_EN_prmoptPaychkBox}                           chain=**/XCUIElementTypeOther[`label CONTAINS 'registered my PromptPay'`][-1]
${iOS_EN_prmoptPaychkBox}                           chain=**/XCUIElementTypeOther[`label CONTAINS 'PromptPay-CheckBox'`][-1]
${iOS_EN_prompaPayHeadspopup}                       chain=**/XCUIElementTypeButton[`label == 'Yes'`]
${iOS_EN_nextBtn}                                   chain=**/XCUIElementTypeButton[`label == 'Next'`]

# claim details
${iOS_EN_accidentDate}                              chain=**/XCUIElementTypeOther[`label CONTAINS 'Accident date'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
#chain=**/XCUIElementTypeTextField[`name == "date-input"`][1]
${iOS_EN_treatmentdate}                             chain=**/XCUIElementTypeOther[`label CONTAINS 'Treatment date (dd/mm/yyyy)'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
#chain=**/XCUIElementTypeTextField[`name == "date-input"`][2]
${iOS_EN_treatmentdate1}                             chain=**/XCUIElementTypeTextField[`name == "date-input"`]
${iOS_EN_DiagnosisOption}                           chain=**/XCUIElementTypeOther[`label == 'Diagnosis'`][2]
${iOS_EN_medicalCenterOption}                       chain=**/XCUIElementTypeOther[`label == 'Medical centre'`][-1]
${iOS_EN_medicalCenterselectOption}                 chain=**/XCUIElementTypeOther[`label CONTAINS 'Medical centre'`][-1]
${iOS_EN_totalcostPaid}                             chain=**/XCUIElementTypeOther[`label CONTAINS 'Treatment cost'`][-1]
${iOS_EN_totalAmountPaid}                           chain=**/XCUIElementTypeOther[`label CONTAINS 'Total amount'`][-1]
${iOS_EN_treatmentitems}                            chain=**/XCUIElementTypeOther[`label == 'Select treatment items'`][-1]
${iOS_EN_diagnosisDoneBtn}                          chain=**/XCUIElementTypeButton[`label == 'Done'`][1]
${iOS_EN_diagnosisSearch}                           xpath=(//XCUIElementTypeOther[@name="Search here"])[2]
#chain=**/XCUIElementTypeOther[`name == "Search here"`][2]
${iOS_EN_addNewDiagnosis}                           chain=**/XCUIElementTypeButton[`label == 'Add new diagnosis'`]
${iOS_EN_addNewMedicalcenter}                       chain=**/XCUIElementTypeButton[`label == 'Add medical centre'`]
${iOS_EN_surgercymedicalcentreDoneBtn}              chain=**/XCUIElementTypeButton[`label == 'Done'`][1]
${iOS_EN_medicalcentreDoneBtn}                      chain=**/XCUIElementTypeButton[`label == "Done"`][1]
${iOS_EN_treatmentitemsDoneBtn}                     chain=**/XCUIElementTypeButton[`label == "Done"`][2]
${iOS_EN_submitButton}                              chain=**/XCUIElementTypeButton[`label == 'Submit'`]
${iOS_EN_viewclaimtransactiontxt}                   chain=**/XCUIElementTypeOther[`label == 'View claims transactions'`]
${iOS_EN_errorOKpopup}                              chain=**/XCUIElementTypeOther[`label CONTAINS 'identify'`]/XCUIElementTypeOther[`label == 'OK'`]
${iOS_EN_captureerrormsgOKpopup}                    chain=**/XCUIElementTypeOther[`label CONTAINS 'identify'`][-3]
${iOS_EN_capturerrorpopup}                          chain=**/XCUIElementTypeOther[`label CONTAINS 'Whoops'`][-1]
${iOS_EN_minusImg}                                  xpath=(//XCUIElementTypeOther[@name='Vertical scroll bar, 1 page'])[3]/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]
${iOS_EN_captueconfirmerrmsg}                       chain=**/XCUIElementTypeOther[`label CONTAINS 'Just to confirm'`][3]

${iOS_EN_claimantlist}                              xpath=//XCUIElementTypeOther[@name='Select claimant']/following-sibling::XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther
${iOS_EN_claimtypelist}                             xpath=//XCUIElementTypeOther[@name='Select claim type']/following-sibling::XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther
${iOS_EN_claimantfield}                             chain=**/XCUIElementTypeOther[`label == 'Claimant'`][2]
${iOS_EN_claimtypefield}                            chain=**/XCUIElementTypeOther[`label == 'Claim type'`][2]
${iOS_EN_policyfield}                               chain=**/XCUIElementTypeOther[`label == 'Policy'`][2]
${iOS_EN_medicalcertificate}                        chain=**/XCUIElementTypeOther[`label CONTAINS 'Medical certificate(s)'`][-1]
${iOS_EN_medicalreceipt}                            chain=**/XCUIElementTypeOther[`label CONTAINS 'Receipt(s)'`][-1]
${iOS_EN_reviewAccidentdate}                        chain=**/XCUIElementTypeOther[`label CONTAINS 'Accident date'`][-2]/XCUIElementTypeOther[2]
${iOS_EN_reviewTreatmentdate}                       chain=**/XCUIElementTypeOther[`label CONTAINS 'Treatment date'`][-2]/XCUIElementTypeOther[2]
${iOS_EN_reviewDiagnosis}                           chain=**/XCUIElementTypeOther[`label CONTAINS 'Diagnosis'`][-2]/XCUIElementTypeOther[2]
${iOS_EN_reviewMedicalcentre}                       chain=**/XCUIElementTypeOther[`label CONTAINS 'Medical centre'`][-2]/XCUIElementTypeOther[2]
${iOS_EN_reviewtreatmentitems}                      chain=**/XCUIElementTypeOther[`label CONTAINS 'Treatment'`][-3]/XCUIElementTypeOther[2]
${iOS_EN_reviewamountandcurr}                       chain=**/XCUIElementTypeOther[`label CONTAINS 'Total amount you paid'`][-2]/XCUIElementTypeOther[2]
${iOS_EN_reviewtotCostwamountandcurr}               chain=**/XCUIElementTypeOther[`label CONTAINS 'Treatment cost'`][-2]/XCUIElementTypeOther[2]
${iOS_EN_reviewDurationofStay}                      chain=**/XCUIElementTypeOther[`label CONTAINS 'Duration of hospital stay'`][-2]/XCUIElementTypeOther[2]
${iOS_EN_accidentDateErrMsg}                        chain=**/XCUIElementTypeStaticText[`label == 'Accident date must be before the treatment date'`]
${iOS_EN_treatmentDateErrMsg}                       chain=**/XCUIElementTypeStaticText[`label == 'Treatment date must be after the accident date'`]
${iOS_EN_claimreviewPagetext}                       chain=**/XCUIElementTypeStaticText[`label CONTAINS 'Thanks'`]
${iOS_EN_transactionStatus}                         chain=**/XCUIElementTypeOther[`label CONTAINS 'Outpatient Surgery'`][-1]/XCUIElementTypeOther --need to do dynamic
# hospitalization
${iOS_EN_hospitalsaty}                              chain=**/XCUIElementTypeOther[`label == 'Duration of hospital stay'`][-1]
${iOS_EN_Policyeffectivedateerror}                  chain=**/XCUIElementTypeStaticText[`label CONTAINS 'policy effective date'`]
${iOS_EN_invaliddateerror}                          chain=**/XCUIElementTypeStaticText[`label CONTAINS 'Invalid date'`]
${iOS_EN_cancer_relatedChkBox}                      chain=**/XCUIElementTypeOther[`label CONTAINS 'cancer related'`][-1]

# dob selection from calender
${iOS_EN_currentmonthandyear}                       accessibility_id=claimDetails.durationHospitalStay-calendar.header
${iOS_EN_currentYear}                               accessibility_id=claimDetails.durationHospitalStay-year-month-selector-month-year-header-text
${iOS_EN_PreviousyearArrow}                         accessibility_id=claimDetails.durationHospitalStay-year-month-selector-previous-year-arrow-button
${iOS_EN_nextyearArrow}                             accessibility_id=claimDetails.durationHospitalStay-year-month-selector-next-year-arrow-button
${iOS_EN_DobDoneBtn}                                accessibility_id=claimDetails.durationHospitalStay-done-button
${iOS_EN_claimementsingle}                          xpath=//XCUIElementTypeOther[@name="claimantDetails.selectedClaimant-list-item"]

# dob selection from calender
${Android_EN_currentmonthandyear}                   xpath=//android.view.ViewGroup[@resource-id='claimDetails.durationHospitalStay-calendar.header.leftArrow']/following-sibling::android.view.ViewGroup[@resource-id='claimDetails.durationHospitalStay-touchable-header']
${Android_EN_currentYear}                           xpath=(//android.view.ViewGroup[@resource-id='claimDetails.durationHospitalStay-year-month-selector-previous-year-arrow-button']/following-sibling::android.widget.TextView)[1]
${Android_EN_PreviousyearArrow}                     xpath=//android.view.ViewGroup[@resource-id='claimDetails.durationHospitalStay-year-month-selector-previous-year-arrow-button']
${Android_EN_nextyearArrow}                         xpath=//android.view.ViewGroup[@resource-id='claimDetails.durationHospitalStay-year-month-selector-next-year-arrow-button']
${Android_EN_DobDoneBtn}                            xpath=//android.widget.TextView[@text='Done']

${Android_EN_Reimbursement_relatedChkBox}           xpath=(//android.widget.CheckBox[@content-desc="claim-checkbox-I received reimbursement from another insurer for this claim"])[2]

# ----------------------------------Android Object ------------------------------------------------
${Android_EN_errorOKpopup}                          xpath=((//android.widget.TextView[@text='OK'])/preceding::android.widget.TextView)[2]
${Android_EN_captureerrormsgOKpopup1}               xpath=//android.widget.TextView[@text='Whoops!']

${Android_EN_captureerrormsgOKbtn}                  xpath=//android.widget.TextView[contains(@text,'identify')]/following::android.widget.Button
${Android_EN_minusImg}                              xpath=(//android.widget.ImageView/following::android.view.ViewGroup)[1]
${Android_EN_confirmPopup}                          xpath=//android.widget.TextView[@text='No']
${Android_EN_confirmPopupYes}                       xpath=//android.widget.TextView[@text='Yes']
${Android_EN_captueconfirmerrmsg}                   xpath=//android.widget.TextView[@text='Just to confirm']
${Android_EN_captueconfirmerrmsg2}                  xpath=//android.widget.TextView[@text='Are you sure it is a receipt(s)?']
${Android_EN_captueconfirmerrmsg3}                  xpath=//android.widget.TextView[@text='Are you sure it is a receipt(s)?']/following-sibling::android.view.ViewGroup
${Android_EN_claimantOption}                        xpath=//android.widget.TextView[@text='Claimant']
${Android_EN_select_claimant}                       xpath=//android.widget.TextView[@text='Select claimant']
# ${Android_EN_claimant}
${Android_EN_claimantlist}                          xpath=//android.widget.TextView[@text='Select claimant']/following::android.view.ViewGroup/android.view.ViewGroup
${Android_EN_claimantfield}                         xpath=//android.widget.TextView[@text='Claimant']
${Android_EN_ClaimTypeOption}                       xpath=//android.widget.TextView[@text='Claim type']
${Android_EN_claimtypefield}                        xpath=//android.widget.TextView[@text='Select claim type']
${Android_EN_policyfield}                           xpath=//android.widget.TextView[contains(@text,'Policy number')]
${Android_EN_PolicyOption}                          xpath=//android.widget.TextView[@text='Policy']
${Android_EN_ClaimchkBox}                           xpath=(//android.widget.CheckBox[@content-desc="claim-checkbox-I received reimbursement from another insurer for this claim"])[2]
${Android_EN_ClaimCheckBox}                         xpath=(//android.widget.CheckBox[@content-desc="claim-checkbox-I received ICU treatment"])[1]
${Android_EN_treatmentdate}                         xpath=//android.widget.TextView[contains(@text,'Treatment date')]/preceding-sibling::android.view.ViewGroup/android.widget.EditText
${Android_EN_Disabilitytreatmentdate}               xpath=//android.widget.TextView[contains(@text,'Treatment date')]/preceding-sibling::android.view.ViewGroup/android.widget.EditText
${Android_EN_DiagnosisOption}                       xpath=//android.widget.TextView[@text='Diagnosis']
${Android_EN_totalAmountPaid}                       xpath=//android.widget.EditText[@resource-id='currency-input']
${Android_EN_treatmentitems}                        xpath=//android.widget.TextView[contains(@text,'Select treatment items')]
${Android_EN_diagnosisSearch}                       xpath=//android.widget.EditText[@text='Search here']
${Android_EN_addNewDiagnosis}                       xpath=//android.widget.TextView[contains(@text,'Add new diagnosis')]
${Android_EN_addNewMedicalcenter}                   xpath=//android.widget.TextView[contains(@text,'Add medical centre')]
${Android_EN_diagnosisDoneBtn}                      xpath=//android.widget.TextView[contains(@text,'Done')]
${Android_EN_surgercymedicalcentreDoneBtn}          xpath=//android.widget.TextView[contains(@text,'Done')]
${Android_EN_medicalcentreDoneBtn}                  xpath=//android.widget.TextView[contains(@text,'Done')]
${Android_EN_medicalCenterselectOption}             xpath=//android.widget.TextView[contains(@text,'Medical centre')]
${Android_EN_reviewtreatmentitems}                  chain=**/XCUIElementTypeOther[`label CONTAINS 'Treatment'`][-3]/XCUIElementTypeOther[2]
${Android_EN_treatmentitemsDoneBtn}                 xpath=//android.widget.TextView[contains(@text,'Done')]
${Android_EN_medicalcertificate}                    xpath=(//android.view.ViewGroup[@resource-id='preview-photo-remove-button'])[2]
${Android_EN_medicalreceipt}                        xpath=//android.view.ViewGroup[@resource-id='preview-photo-remove-button']
# -------------------------------- Add Payment Method -------------------------------
${Android_EN_Changepayment_method}                  xpath=//android.widget.TextView[@text='Change']
${Android_EN_Add_payment_method}                    xpath=//android.widget.TextView[@text='Add payment method']
${Android_EN_uploadBankBookclaim}                   xpath=(//android.view.ViewGroup[@resource-id='add-more-photo-button'])[1]
${Android_EN_select_Bank_Account}                   xpath=//android.widget.TextView[@text='Bank account']
${Android_EN_bankName}                              xpath=//android.widget.TextView[@text='Bank name']
${Android_EN_BankAccNoInput}                        xpath=(//android.view.ViewGroup[@class='android.view.ViewGroup']/android.widget.EditText)[1]
${Android_EN_BankAccNo}                             xpath=//android.widget.TextView[@text='Bank account no.']
${Android_EN_SearchBankName}                        xpath=//android.widget.EditText[@resource-id='text-input']

# ---------------------change payment method ----------------------------------
${Android_EN_prompt_pay_Tab}                        xpath=//android.widget.TextView[@text='PromptPay']
${Android_EN_prmoptPaychkBox}                       xpath=//android.view.ViewGroup[@resource-id='check-box']
${Android_EN_saveBtn}                               android=new UiSelector().textContains("Save")
${Android_EN_nextBtn}                               android=new UiSelector().textContains("Next")
${Android_EN_obj_doneButton}                        xpath=//android.widget.TextView[@text='Done']

# xpath=//android.widget.TextView[@text='Save']
${Android_EN_prompaPayHeadspopup}                   xpath=//android.widget.TextView[@text='Yes']
${Android_EN_viewclaimtransactiontxt}               xpath=//android.widget.TextView[@text='View claims transactions']
${Android_EN_claimreviewPagetext}                   xpath=//android.widget.TextView[contains(@text,'Thanks ')]
# ----------------------------Transactions Vps Proprties ---------------------------------
${Android_EN_accidentDateErrMsg}                    xpath=//android.widget.TextView[@text='Accident date must be before the treatment date']
${Android_EN_Errortextmsg}                          xpath=//android.widget.TextView[contains(@text,'Are you sure')]
${Android_EN_reviewTreatmentdate}                   xpath=(//android.widget.TextView[@text='Treatment date']/following-sibling::android.widget.TextView)[1]

${Android_EN_reviewDiagnosis}                       xpath=(//android.widget.TextView[@text='Diagnosis']/following-sibling::android.widget.TextView)[1]
${Android_EN_reviewMedicalcentre}                   xpath=(//android.widget.TextView[@text='Medical centre']/following-sibling::android.widget.TextView)[1]
${Android_EN_reviewamountandcurr}                   xpath=(//android.widget.TextView[@text='Treatment cost']/following-sibling::android.widget.TextView)[1]
${Android_EN_reviewtotCostwamountandcurr}           xpath=(//android.widget.TextView[contains(@text,'Total amount you paid')]/following-sibling::android.widget.TextView)[1]
${Android_EN_declareChkBox}                         xpath=(//android.widget.CheckBox[@content-desc="Claim-checkbox-policy-terms"])[2]/android.view.ViewGroup
${Android_EN_submitButton}                          xpath=//android.widget.TextView[@text='Submit']
${Android_EN_TransactionDisabilityClaimStatus}      xpath=(//android.widget.TextView[@text='Disability & Dismemberment']/following::android.widget.TextView[@text='In progress'])[1]
${Android_EN_TransactionClaimStatus}                xpath=(//android.widget.TextView[@text='Outpatient Reimbursement']/following::android.widget.TextView[@text='In progress'])[1]
# ${Android_EN_TransactionPolicyNumber}    xpath=(//android.widget.TextView[@text='Claim(s)']/following::android.view.ViewGroup/following::android.widget.TextView)[8]
# ----------------------------Transactions Vps Proprties Android ---------------------------------
${Android_EN_accidentDate}                          xpath=//android.widget.TextView[contains(@text,'Accident date')]/preceding-sibling::android.view.ViewGroup/android.widget.EditText
${Android_EN_AccidentDateTxt}                       xpath=(//android.widget.TextView[@text='Accident date']/following-sibling::android.widget.TextView)[1]
${Android_EN_Policyeffectivedateerror}              xpath=//android.widget.TextView[contains(@text,'policy effective date')]
${Android_EN_invaliddateerror}                      xpath=//android.widget.TextView[@text='Invalid date value']
${Android_EN_treatmentDateErrMsg}                   xpath=//android.widget.TextView[@text='Treatment date must be after the accident date']
${Android_EN_hospitalsaty}                          xpath=//android.widget.TextView[contains(@text,'Duration of hospital stay')]
# -------------------------------    Select a Claim Type = 'Outpatient_Surgery'    ---------------------------------
${Android_EN_totalcostPaid}                         xpath=//android.widget.EditText[@resource-id='currency-input']
# ----------------------------------Hospita Duration Vps --------------------------

${Android_EN_reviewDurationofStay}                  xpath=(//android.widget.TextView[@text='Duration of hospital stay']/following::android.widget.TextView)[1]
${Android_EN_cancer_relatedChkBox}                  xpath=(//android.widget.CheckBox[@content-desc="claim-checkbox-This claim is cancer related"])[1]

${Android_EN_AddAdditionalDocuments}                xpath=//android.widget.TextView[@text='Add additional documents']
${Android_EN_AddClaimSettlementLetter}              xpath=(//android.view.ViewGroup[@resource-id='add-more-photo-button'])[2]
${Android_EN_PopUp_txt}                             xpath=//android.widget.TextView[@text='We’d love to hear from you']
${Android_EN_claimementsingle}                      id=claimantDetails.selectedClaimant-selected-content-text
