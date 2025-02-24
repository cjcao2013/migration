*** Variables ***
# FWD Insuarance page
${iOS_EN_hellotext}                             chain=**/XCUIElementTypeOther[`label CONTAINS 'Hello'`][-1]
${iOS_EN_viewpolicy}                            chain=**/XCUIElementTypeOther[`label BEGINSWITH "View policies and investments"`]
${iOS_EN_viewclaim}                             chain=**/XCUIElementTypeOther[`label BEGINSWITH "Submit"`][-1]
${iOS_EN_servicerequest}                        chain=**/XCUIElementTypeOther[`label CONTAINS 'Update policies'`][-1]
${iOS_EN_payment}                               chain=**/XCUIElementTypeOther[`label CONTAINS 'Make a payment'`][-1]
${iOS_EN_viewinvestment}                        chain=**/XCUIElementTypeOther[`label CONTAINS 'VIEW ALL Investment(s)'`][-1]
${iOS_EN_viewtransactiontab}                    chain=**/XCUIElementTypeOther[`label CONTAINS 'View transactions'`][-1]
${iOS_EN_SwitchFund}                            chain=**/XCUIElementTypeOther[`label BEGINSWITH "Switch funds"`][-1]
${iOS_EN_PartailWithDrwal}                      chain=**/XCUIElementTypeOther[`label BEGINSWITH "Partial withdrawal"`][-1]
${iOS_EN_CashPayoutOption}                      chain=**/XCUIElementTypeOther[`label BEGINSWITH "ICP option"`][-1]
${iOS_EN_PremiumPaymentMethod}                  chain=**/XCUIElementTypeOther[`label BEGINSWITH "Payment method"`][-1]
${iOS_EN_PaymentFrequecy}                       chain=**/XCUIElementTypeOther[`label BEGINSWITH "Payment frequency"`][-1]
${iOS_EN_Guidebtn}                              chain=**/XCUIElementTypeOther[`label == 'Guide'`][-1]
${iOS_EN_backBtn}                               chain=**/XCUIElementTypeOther[`label == 'Guide'`][1]/XCUIElementTypeOther[1]
${iOS_EN_capturetext}                           chain=**/XCUIElementTypeStaticText[`label == 'Capture all your receipts'`]
${iOS_EN_navigationPanel}                       chain=**/XCUIElementTypeOther[`label == 'Step 1 Step 2 Step 3'`][-1]
${iOS_EN_galleryBtn}                            chain=**/XCUIElementTypeOther[`label == 'Gallery'`][-1]
${iOS_EN_nextBtnEnabled}                        chain=**/XCUIElementTypeOther[`label == 'Next'`][-1]    # --check disable r enable
${iOS_EN_captureimgBtn}                         chain=**/XCUIElementTypeOther[`label == 'Gallery Next'`][2]/XCUIElementTypeOther[2]
# step2 claim page
${iOS_EN_headertext}                            Chain=**/XCUIElementTypeOther[`label == 'Submit a claim Overview'`][-1]
${iOS_EN_verifytext}                            chain=**/XCUIElementTypeStaticText[`label == 'Verify your details'`]
${iOS_EN_claimant}                              chain=**/XCUIElementTypeOther[`label CONTAINS 'Claimant'`][-1]
${iOS_EN_claimtype}                             chain=**/XCUIElementTypeOther[`label CONTAINS 'Claim type'`][-1]
${iOS_EN_policy}                                chain=**/XCUIElementTypeOther[`label CONTAINS 'Policy'`][-1]    # check enabled?
${iOS_EN_chkBox}                                chain=**/XCUIElementTypeStaticText[`label == "I received reimbursement from another insurer for this claim"`]
${iOS_EN_step2NextBtn}                          chain=**/XCUIElementTypeButton[`label == 'Next'`]
# step2 claimdetails page
${iOS_EN_claimdetailspageheadertext}            chain=**/XCUIElementTypeOther[`label == 'Submit a claim Claim details'`][-1]
${iOS_EN_claimdetaispageheader1}                chain=**/XCUIElementTypeStaticText[`label CONTAINS 'Details about your'`]
${iOS_EN_treatmentdatefield}                    chain=**/XCUIElementTypeOther[`label CONTAINS 'Treatment date (dd/mm/yyyy)'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField    # check its value attribute is present or not
${iOS_EN_totalAmountfieldvaluepopulated}        chain=**/XCUIElementTypeOther[`label == 'Total amount you paid (THB)'`]
${iOS_EN_PersonalDetails}                       chain=**/XCUIElementTypeOther[`label BEGINSWITH "Personal details"`][-1]
${iOS_EN_BeneficiaryDetails}                    chain=**/XCUIElementTypeOther[`label BEGINSWITH "Beneficiary details"`][-1]
${iOS_EN_RiderDetails}                          chain=**/XCUIElementTypeOther[`label BEGINSWITH "Delete rider(s)"`][-1]
${iOS_EN_YourPolicyDetails}                     chain=**/XCUIElementTypeOther[`label BEGINSWITH "Cancel or surrender policy"`][-1]
${iOS_EN_TaxConsentDetails}                     chain=**/XCUIElementTypeOther[`label BEGINSWITH "Tax consent"`][-1]
${iOS_EN_PolicyLoanDetails}                     chain=**/XCUIElementTypeOther[`label BEGINSWITH "Policy loan"`][-1]

# FWD Insuarance page
${Android_EN_hellotext}                         android=new UiSelector().textContains("Hello")
${Android_EN_viewpolicy}                        xpath=(//android.widget.TextView[@text='View policies and investments'])
${Android_EN_updatepolicies}                    xpath=(//android.widget.TextView[@text='View policies and investments'])
${Android_EN_viewclaim}                         xpath=(//android.widget.TextView[@text='Make a claim'])
${Android_EN_makepayment}                       xpath=(//android.widget.TextView[@text='Make a payment'])
${Android_EN_servicerequest}                    xpath=(//android.widget.TextView[@text='Service Request'])
${Android_EN_payment}                           xpath=(//android.widget.TextView[@text='Payment'])
${Android_EN_viewinvestment}                    xpath=(//android.widget.TextView[@text='Investment(s)'])
${Android_EN_viewtransactiontab}                xpath=(//android.widget.TextView[@text='View transactions'])

# ----------------------------------- Claim Page Object -------------------------------------------
${Android_EN_Guidebtn}                          xpath=//android.widget.TextView[@text='Guide']
${Android_EN_backBtn}                           xpath=(//android.widget.TextView[@text='Guide']/preceding::android.view.ViewGroup)[2]
${Android_EN_capturetext}                       xpath=//android.widget.TextView[@text='Capture all your receipts']
${Android_EN_galleryBtn}                        xpath=//android.widget.TextView[@text='Gallery']
${Android_EN_nextBtnEnabled}                    xpath=//android.widget.TextView[@text='Next']/preceding-sibling::android.view.ViewGroup    # --check disable r enable
${Android_EN_captureimgBtn}                     xpath=(//android.widget.TextView[@text='Gallery']/following::android.view.ViewGroup)[1]
${Android_EN_headertext}                        xpath=//android.widget.TextView[@text='Submit a claim']
${Android_EN_verifytext}                        xpath=//android.widget.TextView[@text='Verify your details']
${Android_EN_claimant}                          xpath=//android.widget.TextView[@text='Claimant']
${Android_EN_claimtype}                         xpath=//android.widget.TextView[@text='Claim type']
${Android_EN_policy}                            xpath=//android.widget.TextView[@text='Policy']
${Android_EN_step2NextBtn}                      xpath=//android.widget.TextView[@text='Next']
${Android_EN_chkBox}                            xpath=(//android.widget.CheckBox[@content-desc="claim-checkbox-I received reimbursement from another insurer for this claim"])[2]

# service request
${Android_EN_PolicyServices}                    xpath=(//android.widget.TextView[@text='Policy services'])
${Android_EN_PaymentRelatedServices}            xpath=(//android.widget.TextView[@text='Payment-related services'])

# Service Request    policy services
${Android_EN_PersonalDeatils}                   xpath=(//android.widget.TextView[@text='Personal details'])
${Android_EN_BeneficiaryDetails}                xpath=(//android.widget.TextView[@text='Beneficiary details'])
${Android_EN_Riders}                            xpath=(//android.widget.TextView[@text='Delete rider(s)'])
${Android_EN_YourPolicy}                        xpath=(//android.widget.TextView[@text='Your policy'])

${Android_EN_TaxConsent}                        xpath=(//android.widget.TextView[@text='Tax consent'])
${Android_EN_PolicyLoan}                        xpath=(//android.widget.TextView[@text='Policy loan'])
${Android_EN_RiskProfile}                       xpath=(//android.widget.TextView[@text='Risk profile'])

# Payment relataed service
${Android_EN_GUI_PaymentFrequency}              xpath=//android.widget.TextView[@text='Payment frequency']
${Android_EN_PaymentMethod}                     xpath=(//android.widget.TextView[@text='Payment method'])
${Android_EN_CashPayoutOption}                  xpath=(//android.widget.TextView[@text='ICP option'])
${Android_EN_GUI_Partialwithdrawal}             xpath=//android.widget.TextView[@text='Partial withdrawal']
${Android_EN_Funds}                             xpath=(//android.widget.TextView[@text='Switch funds'])
${Android_EN_CancelOrSurrenderPolicy}           xpath=(//android.widget.TextView[@text='Cancel or surrender policy'])

${Android_EN_FreelookCancellation}              xpath=//android.widget.TextView[@text='Freelook cancellation']
${Android_EN_SurrenderPolicy}                   xpath=//android.widget.TextView[@text='Surrender policy']

# step2 claimdetails page
${Android_EN_claimdetailspageheadertext1}       xpath=//android.widget.TextView[@text='Submit a claim']
${Android_EN_claimdetailspageheadertext2}       xpath=//android.widget.TextView[@text='Claim details']
${Android_EN_claimdetaispageheader1}            xpath=//android.widget.TextView[contains(@text,'Details about')]
${Android_EN_treatmentdate}                     xpath=//android.widget.TextView[contains(@text,'Treatment date')]/preceding-sibling::android.view.ViewGroup/android.widget.EditText    # check its value attribute is present or not
${Android_EN_totalAmountPaid}                   xpath=//android.widget.EditText[@resource-id='currency-input']
${Android_EN_navigationPanel}                   xpath=//android.widget.TextView[@text='Step 2']
${Android_EN_DiagnosisOption}                   xpath=//android.widget.TextView[@text='Diagnosis']
${Android_EN_medicalCenterOption}               xpath=//android.widget.TextView[contains(@text,'Medical centre')]/following-sibling::android.widget.TextView
${Android_EN_treatmentitems}                    xpath=//android.widget.TextView[@text='Select treatment items']
# xpath=(//android.widget.TextView[@text='Claim details']/following::android.view.ViewGroup)[5]
${Android_EN_accidentDate}                      xpath=(//android.widget.TextView[contains(@text,'Details about')]/following-sibling::android.view.ViewGroup/android.view.ViewGroup/android.widget.EditText)[1]
