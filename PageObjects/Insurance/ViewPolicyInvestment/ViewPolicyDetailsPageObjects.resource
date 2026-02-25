*** Settings ***
Library     AppiumLibrary


*** Variables ***
# FWD Insurance
${Android_EN_insuranceButton}                           android=new UiSelector().textContains("Insurance")
${iOS_EN_insuranceButton}                               chain=**/XCUIElementTypeButton[`label == "Insurance"`]
${iOS_EN_ViewPoliciesInvestments}                       chain=**/XCUIElementTypeOther[`label == "View policies and investments"`]
${Android_EN_ViewPoliciesInvestments}                   xpath=//android.widget.TextView[@text='View policies and investments']

# View Policies & Investments
${Android_EN_PolicyBackArrow}                           xpath=//android.view.ViewGroup[@resource-id='back-arrow-icon']
${iOS_EN_PolicyBackArrow}                               accessibility_id=back-arrow-icon

# Premium Amount
${Android_EN_Overview}                                  xpath=//android.widget.TextView[@text='Overview']
${iOS_EN_Overview}                                      chain=**/XCUIElementTypeOther[`label == "Overview"`][2]

${Android_EN_Plyname}                                   xpath=((//android.view.ViewGroup[@clickable="true"])[1]/following-sibling::android.widget.TextView)[2]
${iOS_EN_Plyname}                                       xpath=//XCUIElementTypeStaticText[@name="header-product-name"]

${Android_EN_policystatus_txt}                          xpath=//android.widget.TextView[@text="Active" or @text="Inactive" or @text="Lapsed"]
${iOS_EN_policystatus_txt}                              xpath=(//XCUIElementTypeOther[contains(@name,'Overview Document(s)')])[last()-4]/preceding::XCUIElementTypeOther[1]

${Android_EN_plyNo}                                     xpath=(//android.widget.TextView[@resource-id="header-product-name"]/following-sibling::android.view.ViewGroup//child::android.widget.TextView)[1]
${iOS_EN_plyNo}                                         xpath=(//XCUIElementTypeOther[contains(@name,'Overview Document(s)')])[last()-4]/preceding::XCUIElementTypeOther[3]

${Android_EN_policyName_txt}                            android=new UiSelector().resourceId("header-product-name")
${iOS_EN_policyName_txt}                                accessibility_id=header-product-name

${Android_EN_YouAreCoveredFor_txt}                      xpath=(//android.widget.TextView[@text="Sum assured"]/following-sibling::android.widget.TextView)[1]
${iOS_EN_YouAreCoveredFor_txt}                          chain=**/XCUIElementTypeOther[`label CONTAINS "Sum assured"`][-1]/XCUIElementTypeStaticText[2]

${Android_EN_InsuredFor_txt}                            xpath=//android.widget.TextView[@text="Insured for"]/following-sibling::android.view.ViewGroup//android.widget.TextView
${iOS_EN_InsuredFor_txt}                                chain=**/XCUIElementTypeOther[`label CONTAINS "Sum assured"`][-1]/XCUIElementTypeOther/XCUIElementTypeStaticText

${Android_EN_frequency_txt}                             xpath=(//android.widget.TextView[@text="FREQUENCY"]/following-sibling::android.view.ViewGroup)[1]//android.widget.TextView
${Android_EN_method_txt}                                xpath=((//android.widget.TextView[@text="METHOD"]/following-sibling::android.view.ViewGroup)[2]//android.widget.TextView)[1]
${iOS_EN_FrequencyMethod_text}                          chain=**/XCUIElementTypeOther[`label CONTAINS "Premium amount"`][-1]

${Android_EN_nextPaymentOnDate_txt}                     xpath=//android.widget.TextView[@text="Next payment on:"]/following-sibling::android.widget.TextView
${iOS_EN_nextPaymentOnDate_txt}                         chain=**/XCUIElementTypeOther[`label CONTAINS "Next payment on:"`][-1]/XCUIElementTypeStaticText[2]

${Android_EN_policyStartedOnDate_txt}                   xpath=//android.widget.TextView[@text="Policy started on:"]/following-sibling::android.widget.TextView
${iOS_EN_policyStartedOnDate_txt}                       chain=**/XCUIElementTypeOther[`label CONTAINS "Policy started on:"`][-1]/XCUIElementTypeStaticText[2]

${Android_EN_policyEndsOnDate_txt}                      xpath=//android.widget.TextView[@text="Policy ends on:"]/following-sibling::android.widget.TextView
${iOS_EN_policyEndsOnDate_txt}                          chain=**/XCUIElementTypeOther[`label CONTAINS "Policy ends on:"`][-1]/XCUIElementTypeStaticText[2]

${Android_EN_PremiumAmt}                                xpath=(//android.widget.TextView[@text="Premium amount"]/following-sibling::android.widget.TextView)[1]
${iOS_EN_PremiumAmt}                                    chain=**/XCUIElementTypeOther[`label CONTAINS "Premium amount "`]/XCUIElementTypeOther[-3]
# View Payment History
${Android_EN_View_Payment_History}                      xpath=//android.widget.TextView[@text='View payment history']
${iOS_EN_View_Payment_History}                          chain=**/XCUIElementTypeOther[`label == "View payment history"`]
${Android_EN_PaymentCount}                              xpath=//android.widget.TextView[contains(@text,'Here are your')]//following::android.view.ViewGroup[2]/android.view.ViewGroup
${iOS_EN_PaymentCount}                                  chain=**/XCUIElementTypeScrollView[-1]/XCUIElementTypeOther[2]/XCUIElementTypeOther

${Android_EN_VPH_Email_Button}                          xpath=//android.widget.TextView[@text='View payment history']/following-sibling::android.view.ViewGroup[1]
${iOS_EN_VPH_Email_Button}                              chain=**/XCUIElementTypeOther[`label == "View payment history"`]/XCUIElementTypeOther

${Android_EN_VPH_Email_Confirm_Button}                  xpath=//android.widget.TextView[@text='Confirm']
${iOS_EN_VPH_Email_Confirm_Button}                      chain=**/XCUIElementTypeOther[`label == "Confirm"`]

${Android_EN_VPH_Email_Sent_Msg}                        xpath=//android.widget.TextView[@text='Email sent!']
${iOS_EN_VPH_Email_Sent_Msg}                            chain=**/XCUIElementTypeOther[`label CONTAIN "Email sent!"`][-1]

${Android_EN_VPH_Payment_Period_txt}                    xpath=//android.widget.TextView[@text='View payment history']/following-sibling::android.widget.TextView
${iOS_EN_VPH_Payment_Period_txt}                        chain=**/XCUIElementTypeStaticText[`label CONTAINS "Here are your payment records"`][-1]

${Android_EN_VPH_Count}                                 xpath=//android.widget.TextView[@text='View payment history']/following-sibling::android.view.ViewGroup/android.widget.ScrollView/android.view.ViewGroup/android.view.ViewGroup

# Rider
${Android_EN_Rider}                                     xpath=//android.widget.TextView[@text='Rider(s)']
${iOS_EN_Rider}                                         chain=**/XCUIElementTypeOther[`label == "Rider(s)"`]

${iOS_EN_RiderList}                                     xpath=//XCUIElementTypeOther[@name="collapsible-header" and @label="Rider(s)"]/parent::XCUIElementTypeOther[last()]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther/XCUIElementTypeOther
${Android_EN_RiderList}                                 xpath=//android.view.ViewGroup[@content-desc="Rider(s)"]/following-sibling::android.view.ViewGroup/descendant::android.widget.HorizontalScrollView/android.view.ViewGroup/android.view.ViewGroup

${Android_EN_Riders_YouAreCoveredFor_txt}               xpath=(//android.widget.TextView[@text="Insured for"]/preceding-sibling::android.widget.TextView)[2]

${Android_EN_Riders_policy_name_txt}                    xpath=(//android.widget.TextView[@text="Insured for"]/preceding-sibling::android.widget.TextView)[1]
${iOS_EN_Riders_policy_name_txt}                        chain=**/XCUIElementTypeScrollView[-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeStaticText[1]

${Android_EN_Riders_PremiumAmount_txt}                  xpath=(//android.widget.TextView[@text="Insured for"]/preceding-sibling::android.widget.TextView)[2]
${iOS_EN_Riders_PremiumAmount_txt}                      chain=**/XCUIElementTypeOther[`label CONTAINS "Premium amount "`]/XCUIElementTypeOther[-3]

${Android_EN_Riders_InsuredFor_txt}                     xpath=//android.widget.TextView[@text="Insured for"]/following-sibling::android.widget.TextView
${iOS_EN_Riders_InsuredFor_txt}                         xpath=//XCUIElementTypeStaticText[@name="Insured for"]//following-sibling::XCUIElementTypeOther/XCUIElementTypeStaticText

${Android_EN_StartedOnDate_txt}                         xpath=//android.widget.TextView[@text="Policy started on:"]/following-sibling::android.widget.TextView
${iOS_EN_StartedOnDate_txt}                             xpath=//XCUIElementTypeStaticText[@name="Policy started on:"]/following-sibling::XCUIElementTypeStaticText

${Android_EN_EndsOnDate_txt}                            xpath=//android.widget.TextView[@text="Policy ends on:"]/following-sibling::android.widget.TextView
${iOS_EN_EndsOnDate_txt}                                xpath=//XCUIElementTypeStaticText[@name="Policy ends on:"]/following-sibling::XCUIElementTypeStaticText

${Android_EN_Riders_StartedOnDate_txt}                  xpath=//android.widget.TextView[@text="Started on"]/following-sibling::android.widget.TextView
${Android_EN_Riders_EndsOnDate_txt}                     xpath=//android.widget.TextView[@text="Ends on"]/following-sibling::android.widget.TextView

${Android_EN_NextPremiumDate_txt}                       xpath=//android.widget.TextView[@text="Next payment on:"]/following-sibling::android.widget.TextView
${iOS_EN_NextPremiumDate_txt}                           xpath=//XCUIElementTypeStaticText[@name="Next payment on:"]/following-sibling::XCUIElementTypeStaticText

${Android_EN_Riders_PayPeriod_txt}                      xpath=//android.widget.TextView[@text='Pay period']/following-sibling::android.widget.TextView
${iOS_EN_Riders_PayPeriod_txt}                          chain=**/XCUIElementTypeScrollView[-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeStaticText[-1]

${Android_EN_Riders_policy_status_txt}                  xpath=//android.widget.TextView[@text="Insured for"]/parent::android.view.ViewGroup/following-sibling::android.view.ViewGroup//android.widget.TextView
${iOS_EN_Riders_policy_status_txt}                      chain=**/XCUIElementTypeScrollView[-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeStaticText

# Detail's
${Android_EN_Details}                                   xpath=//android.widget.TextView[@text='Details']
${iOS_EN_Details}                                       chain=**/XCUIElementTypeOther[`label == "Details"`]

${Android_EN_Details_MailingAddress_txt}                xpath=//android.widget.TextView[@text="Mailing address"]/following-sibling::android.widget.TextView[1]
${iOS_EN_Details_MailingAddress_txt}                    chain=**/XCUIElementTypeOther[`label BEGINSWITH "Mailing address"`][-1]/XCUIElementTypeOther[1]

${Android_EN_Details_EditAddress_Button}                xpath=//android.widget.TextView[@text="Mailing address"]/following-sibling::android.view.ViewGroup[1]//android.view.ViewGroup
#${iOS_EN_Details_EditAddress_Button}                    chain=**/XCUIElementTypeOther[`label BEGINSWITH "Mailing address"`][-1]/XCUIElementTypeOther[1]
${iOS_EN_Details_EditAddress_Button}                    chain=**/XCUIElementTypeOther[`label BEGINSWITH "Mailing address"`][-1]/XCUIElementTypeOther[1]/XCUIElementTypeOther

${Android_EN_Details_Address_Title}                     xpath=//android.widget.TextView[@text='Update address']
${iOS_EN_Details_Address_Title}                         chain=**/XCUIElementTypeStaticText[`label == "Update address"`]

${Android_EN_Details_AgentContact_txt}                  xpath=//android.widget.TextView[@text="Want to add on? Contact your agent!"]/following-sibling::android.widget.TextView
${iOS_EN_Details_AgentContact_txt}                      chain=**/XCUIElementTypeOther[`label BEGINSWITH "Mailing address"`][-1]/XCUIElementTypeStaticText[3]

${Android_EN_Details_CallYourAgent_txt}                 xpath=//android.widget.TextView[@text='Call your agent']
${iOS_EN_Details_CallYourAgent_txt}                     chain=**/XCUIElementTypeOther[`label == "Call your agent"`]

${iOS_EN_Details_AgentAvaiblity_Messgae_Text}           xpath=//XCUIElementTypeStaticText[contains(@name,'Want to add on')]/following-sibling::XCUIElementTypeStaticText
${Android_EN_Details_AgentAvaiblity_Messgae_Text}           xpath=//android.widget.TextView[contains(@name,'Want to add on')]/following-sibling::android.widget.TextView

${iOS_EN_Calling_number}                            xpath=//XCUIElementTypeAlert
${Android_EN_Calling_number}                        xpath=//XCUIElementTypeAlert

${iOS_EN_Agent_Number}                                  chain=**/XCUIElementTypeStaticText[`label CONTAINS "Call"`][-1]
${iOS_EN_CancelButton}                                  chain=**/XCUIElementTypeButton[`label == "Cancel"`][1]

${Android_EN_Details_EmailYourAgent_txt}                xpath=//android.widget.TextView[@text='Email your agent']
${iOS_EN_Details_EmailYourAgent_txt}                    chain=**/XCUIElementTypeOther[`label == "Email your agent"`]

# Document's
${Android_EN_Document}                                  xpath=//android.widget.TextView[@text='Document(s)']
${iOS_EN_Document}                                      chain=**/XCUIElementTypeOther[`label == "Document(s)"`][2]

${iOS_EN_TaxDocument}                                   chain=**/XCUIElementTypeOther[`label CONTAINS 'Tax Certificate'`][-1]

${Android_EN_DocumentList}                              xpath=//android.widget.ScrollView/android.view.ViewGroup/android.view.ViewGroup
${iOS_EN_DocumentList}                                  chain=**/XCUIElementTypeScrollView[-1]/XCUIElementTypeOther/XCUIElementTypeOther

${Android_EN_Document_Policy_Contract}                  xpath=//android.widget.TextView[@text='Policy Contract']
${iOS_EN_Document_Policy_Contract}                      chain=**/XCUIElementTypeOther[`label == "Policy Contract"`]

${Android_EN_Document_Policy_Statements}                xpath=//android.widget.TextView[@text='Policy Statements']
${iOS_EN_Document_Policy_Statements}                    chain=**/XCUIElementTypeOther[`label == "Policy Statements"`]

${Android_EN_Document_Billing_Statements}               xpath=//android.widget.TextView[@text='Billing Statements']
${iOS_EN_Document_Billing_Statements}                   chain=**/XCUIElementTypeOther[`label == "Billing Statements"`]

${Android_EN_Document_Official_Receipts}                xpath=//android.widget.TextView[@text='Official Receipts']
${iOS_EN_Document_Official_Receipts}                    chain=**/XCUIElementTypeOther[`label == "Official Receipts"`]

${Android_EN_Document_Confirmation_Letters}             xpath=//android.widget.TextView[@text='Confirmation letters']
${iOS_EN_Document_Confirmation_Letters}                 chain=**/XCUIElementTypeOther[`label == "Confirmation letters"`]

${Android_EN_Document_Insurance_Certificate}            xpath=//android.widget.TextView[@text='Insurance Certificate']
${iOS_EN_Document_Insurance_Certificate}                chain=**/XCUIElementTypeOther[`label == "Insurance Certificate"`]

${Android_EN_Document_View_All}                         xpath=//android.widget.TextView[@text='View all']
${iOS_EN_Document_View_All}                             chain=**/XCUIElementTypeOther[`label == "View all"`]

${Android_EN_Document_Last3Months}                      xpath=//android.widget.TextView[@text='Last 3 months']
${iOS_EN_Document_Last3Months}                          chain=**/XCUIElementTypeOther[`label == "Last 3 months"`][1]

${Android_EN_Document_Last6Months}                      xpath=//android.widget.TextView[@text='Last 6 months']
${iOS_EN_Document_Last6Months}                          chain=**/XCUIElementTypeOther[`label == "Last 6 months"`][1]

${Android_EN_Document_Last9Months}                      xpath=//android.widget.TextView[@text='Last 9 months']
${iOS_EN_Document_Last9Months}                          chain=**/XCUIElementTypeOther[`label == "Last 9 months"`][1]

${Android_EN_Document_Last1Year}                        xpath=//android.widget.TextView[@text='Last 1 year']
${iOS_EN_Document_Last1Year}                            chain=**/XCUIElementTypeOther[`label == "Last 1 year"`][1]

${Android_EN_Document_Policy_Contract_RightArrow}       xpath=//android.widget.TextView[@text='Policy Pack']/following-sibling::android.view.ViewGroup[1]

${Android_EN_Document_Preview_Document}                 xpath=//android.widget.TextView[@text='Preview document']
${Android_EN_Document_Download_Button}                  xpath=//android.widget.TextView[@text='Preview document']/following-sibling::android.view.ViewGroup[1]/android.view.ViewGroup
${iOS_EN_Document_Download_Button}                      chain=**/XCUIElementTypeOther[`label == "Preview document"`]/XCUIElementTypeOther

${Android_EN_Document_Popup_Download_Button}            xpath=//android.widget.TextView[@text='Download']
${iOS_EN_Document_Popup_Download_Button}                chain=**/XCUIElementTypeOther[`label == "Download"`]

${Android_EN_Document_Download_Document_Name}           xpath=//android.widget.TextView[contains(@text, '.pdf')]

${Android_EN_Document_Print_Button}                     xpath=//android.widget.TextView[@text='Print']
${Android_EN_Document_Dropdown_List}                    xpath=//android.widget.Spinner[@resource-id='com.android.printspooler:id/destination_spinner']
${Android_EN_Document_SaveAsPDF_txt}                    xpath=//android.widget.TextView[@text='Save as PDF']
${Android_EN_Document_Save_To_PDF}                      accessibility_id=Save to PDF
${Android_EN_Document_PDF_Name_TextBox}                 xpath=//android.widget.EditText[@resource-id='android:id/title']
${Android_EN_Document_SAVE_Button}                      xpath=//android.widget.Button[@text='SAVE']

${Android_EN_previewDocument_backBtn}                   xpath=//android.widget.TextView[@text='Preview document']/preceding::android.view.ViewGroup[1]
${iOS_EN_previewDocument_backBtn}                       chain=**/XCUIElementTypeOther[`label CONTAINS "Preview document"`][-2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]

${iOS_EN_Document_Download_SaveFiles}                   accessibility_id=Save to Files
${iOS_EN_Document_Download_BackBtn}                     chain=**/XCUIElementTypeButton[`label == "Browse"`]
${iOS_EN_Document_Download_Folder}                      chain=**/XCUIElementTypeImage[`label == "Forward"`][7]
${iOS_EN_Download_SaveBtn}                              chain=**/XCUIElementTypeButton[`label == "Save"`]

# Insurance Certificate Details
${Android_EN_COI_Policy_Number}                         xpath=//android.widget.TextView[contains(@text,'Policy number')]
${iOS_EN_COI_Policy_Number}                             chain=**/XCUIElementTypeStaticText[`label CONTAINS "Policy number"`]

${Android_EN_COI_Policy_Owner_Name}                     xpath=//android.widget.TextView[contains(@text,'Policy owner name')]
${iOS_EN_COI_Policy_Owner_Name}                         chain=**/XCUIElementTypeStaticText[`label CONTAINS "Policy owner name"`]

${Android_EN_COI_Insureds_Name}                         xpath=//android.widget.TextView[contains(@text,'Insured’s name')]
${iOS_EN_COI_Insureds_Name}                             chain=**/XCUIElementTypeStaticText[`label CONTAINS "Insured’s name"`]

${Android_EN_COI_Plan_Name}                             xpath=//android.widget.TextView[contains(@text,'Plan name')]
${iOS_EN_COI_Plan_Name}                                 chain=**/XCUIElementTypeStaticText[`label CONTAINS "Plan name"`]

${Android_EN_COI_Sum_Assured}                           xpath=//android.widget.TextView[contains(@text,'Sum assured')]
${iOS_EN_COI_Sum_Assured}                               chain=**/XCUIElementTypeStaticText[`label CONTAINS "Sum assured"`]

${Android_EN_COI_Premium}                               xpath=//android.widget.TextView[contains(@text,'Premium')]
${iOS_EN_COI_Premium}                                   chain=**/XCUIElementTypeStaticText[`label CONTAINS "Premium"`]

${Android_EN_COI_Issue_Date}                            xpath=//android.widget.TextView[contains(@text,'Issue date')]
${iOS_EN_COI_Issue_Date}                                chain=**/XCUIElementTypeStaticText[`label CONTAINS "Issue date"`]

${Android_EN_COI_Status}                                xpath=//android.widget.TextView[contains(@text,'Status')]
${iOS_EN_COI_Status}                                    chain=**/XCUIElementTypeStaticText[`label CONTAINS "Status"`]

${Android_EN_Email_Me_Button}                           xpath=//android.widget.TextView[@text='Email me']
${iOS_EN_Email_Me_Button}                               chain=**/XCUIElementTypeButton[`label == "Email me"`]

${Android_EN_Email_Send_ID}                             xpath=//android.widget.TextView[@text='Email me']/following-sibling::android.widget.TextView
${iOS_EN_Email_Send_ID}                                 xpath=//XCUIElementTypeStaticText[@name="Email me"]/following-sibling::XCUIElementTypeStaticText

${Android_EN_Confirm_Button}                            xpath=//android.widget.TextView[@text='Confirm']
${iOS_EN_Confirm_Button}                                chain=**/XCUIElementTypeOther[`label == "Confirm"`]

${Android_EN_Email_Sent_Msg}                            xpath=//android.widget.TextView[contains(@text,'Email sent!')]
${iOS_EN_Email_Sent_Msg}                                chain=**/XCUIElementTypeStaticText[`label CONTAINS "Email sent!"`][-1]

${Android_EN_Policy_List}                               xpath=//android.widget.TextView[@text="More details"]
${iOS_EN_Policy_List}                                   chain=**/XCUIElementTypeButton[`label == "More details"`]
#chain=**/XCUIElementTypeScrollView[-1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther

${Android_EN_Document_Names_List}                       xpath=//android.widget.ScrollView/child::android.view.ViewGroup
${Android_EN_document_loadingSymbol}                    xpath=//android.widget.ScrollView/child::android.view.ViewGroup//android.widget.ImageView

# Beneficiary's
${Android_EN_Beneficiary}                               xpath=//android.widget.TextView[@text='Beneficiary(s)']
${Android_EN_beneficiaryPer}                            xpath=(//android.widget.TextView[@text='100%'])[1]
${Android_EN_editbeneficiaryBtn}                        xpath=(//android.widget.TextView[contains(@text,'Edit beneficiary(s)')])
${iOS_EN_Beneficiary}                                   chain=**/XCUIElementTypeOther[`label == 'Beneficiary(s)'`][-1]
${iOS_EN_beneficiaryPer}                                chain=**/XCUIElementTypeStaticText[`label == "100%"`][1]
${iOS_EN_editbeneficiaryBtn}                            chain=**/XCUIElementTypeButton[`label == 'Edit beneficiary(s)'`]
${iOS_EN_addBeneficiaryBtn}                             chain=**/XCUIElementTypeOther[`label == 'Add new'`][-1]

# Common Objects
${Android_EN_BackButton}                                xpath=//android.widget.Button[@resource-id='back-button']
${iOS_EN_BackButton}                                    chain=**/XCUIElementTypeButton[`name == "back-button"`]

${iOS_EN_MyPhoneFolder}                                 chain=**/XCUIElementTypeStaticText[`label == "On My iPhone"`]
${iOS_EN_CromeFolder}                                   chain=**/XCUIElementTypeStaticText[`label == "Chrome"`][2]
${iOS_EN_Documentsave}                                  chain=**/XCUIElementTypeButton[`label == "Save"`]

${iOS_EN_OnMyIPhoneFolderTxt}                           chain=**/XCUIElementTypeStaticText[`label == "On My iPhone"`]
${iOS_EN_DowloadFolder}                                 chain=**/XCUIElementTypeCell[`label == "Downloads, 0 items"`]/XCUIElementTypeOther[2]/XCUIElementTypeOther[1]/XCUIElementTypeImage
${iOS_EN_DocumentName}                                  chain=**/XCUIElementTypeTextField[-1]
${iOS_EN_Document_SaveButton}                           chain=**/XCUIElementTypeButton[`label == "Save"`]
${iOS_EN_SaveNotificationPopUp}                         chain=**/XCUIElementTypeButton[`label == "Replace"`]

${iOS_EN_Policy_List}                       chain=**/XCUIElementTypeOther[`name='fwd-mypolicies-flatlist'`]/XCUIElementTypeScrollView/XCUIElementTypeOther/XCUIElementTypeOther

#Indicative_dividend
${iOS_EN_Indicative_dividend}							chain=**/XCUIElementTypeOther[`label == "Indicative dividend"`]
${iOS_EN_Indicative_dividend_View details}				chain=**/XCUIElementTypeButton[`name == "View details"`]

${iOS_EN_first30PerPortion_1}							xpath=(//XCUIElementTypeOther[@label="Indicative dividend"]//parent::XCUIElementTypeOther//descendant::XCUIElementTypeStaticText)[1]
${iOS_EN_first70PerPortion_1}							xpath=(//XCUIElementTypeOther[@label="Indicative dividend"]//parent::XCUIElementTypeOther//descendant::XCUIElementTypeStaticText)[2]

${iOS_EN_Indicative_dividend_Page_Title}			chain=**/XCUIElementTypeStaticText[`name == "Indicative dividend"`]

${iOS_EN_Data_as_per_initial_valuation_date_of}		xpath=//XCUIElementTypeStaticText[@name="Data as per initial valuation date of"]//parent::XCUIElementTypeOther//child::XCUIElementTypeStaticText[2]
${iOS_EN_Underlying_index_level}					xpath=//XCUIElementTypeStaticText[@name="Data as per initial valuation date of"]//parent::XCUIElementTypeOther//following-sibling::XCUIElementTypeOther[1]//child::XCUIElementTypeOther[1]//XCUIElementTypeStaticText[last()]
${iOS_EN_Exchange_rate_from_USD_to_THB_1}				xpath=//XCUIElementTypeStaticText[@name="Data as per initial valuation date of"]//parent::XCUIElementTypeOther//following-sibling::XCUIElementTypeOther[1]//child::XCUIElementTypeOther[2]//XCUIElementTypeStaticText[last()]
${iOS_EN_Participation_rate_(PR)}					xpath=//XCUIElementTypeStaticText[@name="Data as per initial valuation date of"]//parent::XCUIElementTypeOther//following-sibling::XCUIElementTypeOther[1]//child::XCUIElementTypeOther[3]//XCUIElementTypeStaticText[last()]

${iOS_EN_Index_data_as_of}							xpath=//XCUIElementTypeStaticText[@name="Index data as of"]//parent::XCUIElementTypeOther//child::XCUIElementTypeStaticText[2]
${iOS_EN_Index_level_of}							xpath=//XCUIElementTypeStaticText[@name="Index data as of"]//parent::XCUIElementTypeOther//following-sibling::XCUIElementTypeOther[1]//child::XCUIElementTypeOther[1]//XCUIElementTypeStaticText[last()]
${iOS_EN_Exchange_rate_from_USD_to_THB_2}		    xpath=//XCUIElementTypeStaticText[@name="Index data as of"]//parent::XCUIElementTypeOther//following-sibling::XCUIElementTypeOther[1]//child::XCUIElementTypeOther[2]//XCUIElementTypeStaticText[last()]
${iOS_EN_first30PerPortion_2}                       xpath=(//XCUIElementTypeStaticText[@name="Indicative dividend amount overview"]//following-sibling::XCUIElementTypeOther[1]//child::XCUIElementTypeStaticText)[1]
${iOS_EN_first70PerPortion_2}                       xpath=(//XCUIElementTypeStaticText[@name="Indicative dividend amount overview"]//following-sibling::XCUIElementTypeOther[1]//child::XCUIElementTypeStaticText)[4]

${iOS_EN_Indicative_dividend_BackArrow}             xpath=(//XCUIElementTypeOther[@name="Indicative dividend"])[3]/XCUIElementTypeOther[1]/XCUIElementTypeOther