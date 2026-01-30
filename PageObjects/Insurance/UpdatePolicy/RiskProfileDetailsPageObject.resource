*** Variables ***
# ---------------------------------------- Risk profile ------------------------------------------------------------
${Android_EN_RiskProfile_HeaderText}                            xpath=//android.widget.TextView[@text='Update risk profile']
${Android_EN_ContentWith_HeaderText}                            xpath=//android.widget.TextView[@text='Let’s get started on getting your risk profile up to date']
${Android_EN_UpdateAndCompleteTxt}                              xpath=//android.widget.TextView[@text='Update & complete']
${Android_EN_PersonalParticularAndSuitabilityAssessmentText}    xpath=//android.widget.TextView[@text='Update & complete']/following-sibling::android.widget.TextView
${Android_EN_YourCurrentRiskProfileText}                        xpath=//android.widget.TextView[@text='Your current risk profile']
${Android_EN_LastUpdateDate}                                    xpath=//android.widget.TextView[@text='Last update']/following-sibling::android.widget.TextView[1]
${Android_EN_TotalScore}                                        xpath=//android.widget.TextView[@text='Total score']/following-sibling::android.widget.TextView[1]
${Android_EN_RiskLevel}                                         xpath=//android.widget.TextView[@text='Risk level']/following-sibling::android.widget.TextView[1]
${Android_EN_InvestorType}                                      xpath=//android.widget.TextView[@text='Investor type']/following-sibling::android.widget.TextView[1]
${Android_EN_RiskProfileUpdated}                                xpath=//android.widget.TextView[@text='Risk profile updated!']
${Android_EN_NameUpdated}                                       xpath=//android.widget.TextView[@text='Name update']
${Android_EN_Back_Button}                                       xpath=//android.widget.TextView[@text="Update risk profile"]/parent::android.view.ViewGroup/parent::android.view.ViewGroup/parent::android.view.ViewGroup/android.view.ViewGroup[1]/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup
${Android_EN_Update_BackButton}                                 xpath=(//android.widget.TextView[@text='Manage policy(s)']/parent::android.view.ViewGroup)/android.view.ViewGroup/android.view.ViewGroup

# ----------------------------------Update Particulares---------------------------------------------------------
${Android_EN_PersonalDetails_FirstName}                         xpath=//android.widget.TextView[@text='First name']/../..//android.widget.EditText
${Android_EN_PersonalDetails_Flowtails_MiddleName}                        xpath=//android.widget.TextView[contains(@text,'Middle name')]/../..//android.widget.EditText
${Android_EN_PersonalDetails_LastName}                          xpath=//android.widget.TextView[@text='Last name']/../..//android.widget.EditText
${Android_EN_PersonalDetails_DOB}                               xpath=//android.widget.TextView[@text='Date of birth (dd/mm/yyyy)']/../..//android.widget.EditText
${Android_EN_PersonalDetails_Citizenship}                       xpath=//android.widget.TextView[@text='Citizenship']/../..//android.widget.EditText
${Android_EN_PersonalDetails_NoOfDependent}                     xpath=//android.widget.TextView[@text='Number of dependents (Optional)']/../..//android.widget.EditText
${Android_EN_PersonalDetails_MartialStatus}                     xpath=//android.widget.TextView[@text="Marital status (Optional)"]
${Android_EN_Next_Button}                                       xpath=//android.widget.TextView[@text='Next']

${Android_EN_PersonalParticularsTxt}                            xpath=//android.widget.TextView[@text='Personal particulars']
${Android_EN_PleaseProvideTxt}                                  xpath=//android.widget.TextView[contains(@text,'ID card')]
${Android_EN_RiskAddImage}                                      xpath=//android.view.ViewGroup[@resource-id='iBank-add-image']
${Android_EN_Save_Button}                                       xpath=//android.widget.TextView[@text='Save']

${Android_EN_PleaseCheckUpdateParticularsTxt}                   xpath=//android.widget.TextView[@text='Please check and update your particulars']
${Android_EN_EducationalLevel}                                  xpath=//android.widget.TextView[@text='Educational level (Optional)']
${Android_EN_Occupation}                                        xpath=//android.widget.TextView[@text='Occupation']
${Android_EN_Positonal}                                         xpath=//android.widget.TextView[@text='Position (Optional)']
${Android_EN_Bachelor}                                          xpath=//android.widget.TextView[@text='Bachelor degree or equivalent']
${Android_EN_Occupation}                                        xpath=//android.widget.TextView[@text='Government employee']
${Android_EN_Others}                                            xpath=//android.widget.TextView[@text='Others (please specify)']/..//android.widget.EditText

# ---------------------Income and personal asset ------------------------------------
${Android_EN_MonthlyIncome}                                     xpath=//android.widget.TextView[@text='Monthly income (Optional)']
${Android_EN_MonthlyExpenses}                                   xpath=//android.widget.TextView[@text='Monthly expenses in THB (Optional)']/..//android.widget.EditText
${Android_EN_CurrentAsset}                                      xpath=//android.widget.TextView[@text='Source of current assets']
${Android_EN_Estimated_Asset_Value}                             xpath=//android.widget.TextView[@text='Estimated assets value in THB']/preceding-sibling::android.view.ViewGroup//android.widget.EditText
${Android_EN_Objective_Investment}                              xpath=(//android.widget.TextView[@text='Objectives of investment'])[2]

# ----------------------------MArtial Status-----------------------------------------------------
${Android_EN_MartialStatus_Single}                              xpath=//android.widget.TextView[@text='Single']
${Android_EN_MartialStatus_Married}                             xpath=//android.widget.TextView[@text='Married']
${Android_EN_MartialStatus_MarriedWithoutRegistration}          xpath=//android.widget.TextView[@text='Married without registration']
${Android_EN_MartialStatus_Divorced}                            xpath=//android.widget.TextView[@text='Divorced']
${Android_EN_MartialStatus_Windowed}                            xpath=//android.widget.TextView[@text='Widowed']
${Android_EN_Done_Button}                                       xpath=//android.widget.TextView[@text='Done']

# __________________________adddress______________________

${Android_EN_AddressDetails_HeaderText}                         xpath=//android.widget.TextView[@text='Please check and update your particulars']
${Android_EN_ResidentialAddress_HeaderText}                     xpath=//android.widget.TextView[@text='Residential address']
${Android_EN_AddressDetails_AddressLine1}                       xpath=(//android.widget.TextView[@text='Address line 1']/../..//android.widget.EditText)[1]
${Android_EN_AddressDetails_AddressLine2}                       xpath=(//android.widget.TextView[@text='Address line 2 (Optional)']/../..//android.widget.EditText)[2]
${Android_EN_AddressDetails_ZipCode}                            xpath=//android.widget.TextView[@text='Zip code']/..//android.widget.EditText
${Android_EN_MyIDCardAddressSame_chkbox}                        xpath=//android.widget.TextView[contains(@text,'My ID card')]/preceding-sibling::android.view.ViewGroup
${Android_EN_IDCardAddress_HeaderText}                          xpath=//android.widget.TextView[@text='ID card address']

# ----------------Income
${Android_EN_Confimation_Chekbox}                               xpath=(//android.widget.TextView[@text='I hereby certify that I have given the information by myself and the above statements, my score and my type of investor are true and correct. In case of any change in the future, I agree to notify the company immediately. I agree that the company may inspect my information and history from any other person including allowing the company to disclose such information as they see fit.']/../..//android.view.ViewGroup)[3]
# (//android.widget.TextView[contains(@text,'I hereby certify that I have given the information by myself and the above statements, my score and my type of investor are true and correct. In ')]/../..//android.view.ViewGroup)[3]

${Android_EN_TransactionNameTitle}                              xpath=(//android.widget.TextView[@text='Title']/following-sibling::android.widget.TextView)[1]
${Android_EN_TransactionFirstName}                              xpath=(//android.widget.TextView[@text='First name']/following-sibling::android.widget.TextView)[1]
${Android_EN_TransactionTitle}                                  xpath=(//android.widget.TextView[@text='Title']/following-sibling::android.widget.TextView)[1]
${Android_EN_TransactionMiddleName}                             xpath=(//android.widget.TextView[@text='Middle name']/following-sibling::android.widget.TextView)[1]
${Android_EN_TransactionLastName}                               xpath=(//android.widget.TextView[@text='Last name']/following-sibling::android.widget.TextView)[1]
${Android_EN_TransactionMarital}                                xpath=(//android.widget.TextView[@text='Marital status']/following-sibling::android.widget.TextView)[1]

# -----------------------Suitablity Assessment----------------------------------------------
${Android_EN_SUitablityAssement_Header}                         xpath=//android.widget.TextView[@text='Suitability assessment']
${Android_EN_SuitablityAssment_YourAgeGroup}                    xpath=//android.widget.TextView[@text='Your age group:']/following-sibling::android.widget.TextView[1]
${Android_EN_Submit_Button}                                     xpath=//android.widget.TextView[@text='Submit']

# -------------------------------- iOS ---------------------------------------------
${iOS_EN_RiskProfile_HeaderText}                                chain=**/XCUIElementTypeStaticText[`label CONTAINS "Update risk profile"`]
${iOS_EN_ContentWith_HeaderText}                                chain=**/XCUIElementTypeStaticText[`label CONTAINS "Let’s get started on getting your risk profile up to date"`]
${iOS_EN_UpdateAndCompleteTxt}                                  chain=**/XCUIElementTypeOther[`label CONTAINS "Update & complete"`][16]
# ${iOS_EN_PersonalParticularAndSuitabilityAssessmentText}    xpath=//android.widget.TextView[@text='Update & complete']/following-sibling::android.widget.TextView
${iOS_EN_YourCurrentRiskProfileText}                            chain=**/XCUIElementTypeOther[`label CONTAINS "Your current risk profile"`][-1]
${iOS_EN_LastUpdateDate}                                        xpath=//XCUIElementTypeStaticText[@name="Last update"]/XCUIElementTypeStaticText
${iOS_EN_TotalScore}                                            xpath=//android.widget.TextView[@text='Total score']/following-sibling::android.widget.TextView[1]
${iOS_EN_RiskLevel}                                             xpath=//android.widget.TextView[@text='Risk level']/following-sibling::android.widget.TextView[1]
${iOS_EN_InvestorType}                                          xpath=//android.widget.TextView[@text='Investor type']/following-sibling::android.widget.TextView[1]
${iOS_EN_RiskProfileUpdated}                                    chain=**/XCUIElementTypeStaticText[`label == "Risk profile updated!"`]
${iOS_EN_NameUpdated}                                           xpath=//android.widget.TextView[@text='Name update']
${iOS_EN_Back_Button}                                           chain=**/XCUIElementTypeButton[`name == "back-button"`]
${iOS_EN_Update_BackButton}                                     chain=**/XCUIElementTypeButton[`name == "back-button"`]
#xpath=(//XCUIElementTypeOther[@name="Update policies"])[3]/XCUIElementTypeOther[1]/XCUIElementTypeOther
# ----------------------------------Update Particulares---------------------------------------------------------
${iOS_EN_PersonalDetails_FirstName}                             chain=**/XCUIElementTypeOther[`label BEGINSWITH "First name"`][3]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_PersonalDetails_MiddleName}                            chain=**/XCUIElementTypeOther[`label BEGINSWITH "Middle name"`][3]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_PersonalDetails_LastName}                              chain=**/XCUIElementTypeOther[`label BEGINSWITH "Last name"`][3]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_PersonalDetails_DOB}                                   xpath=(//XCUIElementTypeOther[@name="Date of birth (dd/mm/yyyy)"])[3]/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_PersonalDetails_Citizenship}                           chain=**/XCUIElementTypeOther[`label BEGINSWITH "Citizenship"`][3]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_PersonalDetails_NoOfDependent}                         chain=**/XCUIElementTypeOther[`label BEGINSWITH "Number of dependents"`][3]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_PersonalDetails_MartialStatus}                         chain=**/XCUIElementTypeOther[`label BEGINSWITH "Marital status (Optional)"`][2]

# ${iOS_EN_PersonalDetails_FirstName}    chain=**/XCUIElementTypeTextField[`name == "input"`][1]
# ${iOS_EN_PersonalDetails_MiddleName}    chain=**/XCUIElementTypeTextField[`name == "input"`][2]
# ${iOS_EN_PersonalDetails_LastName}    chain=**/XCUIElementTypeTextField[`name == "input"`][3]
# ${iOS_EN_PersonalDetails_DOB}    chain=**/XCUIElementTypeOther[`label == "Date of birth (dd/mm/yyyy)"`][3]/XCUIElementTypeOther/XCUIElementTypeTextField
# ${iOS_EN_PersonalDetails_Citizenship}    chain=**/XCUIElementTypeTextField[`name == "input"`][4]
# ${iOS_EN_PersonalDetails_NoOfDependent}    chain=**/XCUIElementTypeTextField[`name == "input"`][5]
# ${iOS_EN_PersonalDetails_MartialStatus}    chain=**/XCUIElementTypeOther[`label == "Marital status (Optional)"`][2]
${iOS_EN_Next_Button}                                           chain=**/XCUIElementTypeButton[`label == "Next"`][-1]

${iOS_EN_PersonalParticularsTxt}                                chain=**/XCUIElementTypeStaticText[`label == "Personal particulars"`]
${iOS_EN_PleaseProvideTxt}                                      chain=**/XCUIElementTypeStaticText[`label CONTAINS "ID card"`][1]
${iOS_EN_RiskAddImage}                                              chain=**/XCUIElementTypeOther[`name == "iBank-add-image"`]
${iOS_EN_Save_Button}                                           chain=**/XCUIElementTypeButton[`label == "Save"`]

${iOS_EN_PleaseCheckUpdateParticularsTxt}                       chain=**/XCUIElementTypeStaticText[`label CONTAINS "Please check and update your particulars"`]
${iOS_EN_EducationalLevel}                                      chain=**/XCUIElementTypeOther[`label CONTAINS "Educational level (Optional)"`][-1]
${iOS_EN_Occupation}                                            chain=**/XCUIElementTypeOther[`label CONTAINS "Occupation"`][-1]
${iOS_EN_Positonal}                                             chain=**/XCUIElementTypeOther[`label == "Position (Optional)"`][3]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
# ${iOS_EN_Positonal}    xpath=//XCUIElementTypeTextField[@name="input"]
${iOS_EN_Bachelor}                                              xpath=(//XCUIElementTypeOther[@name="Bachelor degree or equivalent"])[2]
#${iOS_EN_Occupation}                                            xpath=(//XCUIElementTypeOther[@name="Government employee"])[2]
${iOS_EN_Others}                                                chain=**/XCUIElementTypeOther[`label == "Others (please specify)"`][3]/XCUIElementTypeOther

# ---------------------Income and personal asset ------------------------------------
${iOS_EN_MonthlyIncome}                                         chain=**/XCUIElementTypeOther[`label CONTAINS "Monthly income (Optional)"`][-1]
${iOS_EN_MonthlyExpenses}                                       chain=**/XCUIElementTypeOther[`label == "Monthly expenses in THB (Optional)"`][3]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
# ${iOS_EN_MonthlyExpenses}    xpath=(//XCUIElementTypeTextField[@name="input"])[1]
${iOS_EN_CurrentAsset}                                          xpath=//XCUIElementTypeStaticText[@name="Source of current assets"]
${iOS_EN_Estimated_Asset_Value}                                 chain=**/XCUIElementTypeOther[`label CONTAINS "Estimated assets value in THB"`][-1]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
# ${iOS_EN_Estimated_Asset_Value}    xpath=(//XCUIElementTypeTextField[@name="input"])[3]
${iOS_EN_Objective_Investment}                                  xpath=(//XCUIElementTypeOther[contains(@name,"Objectives of investment")])[24]

# ----------------------------MArtial Status-----------------------------------------------------
${iOS_EN_MartialStatus_Single}                                  chain=**/XCUIElementTypeOther[`label == "Single"`][2]
${iOS_EN_MartialStatus_Married}                                 chain=**/XCUIElementTypeOther[`label == "Married"`][2]
${iOS_EN_MartialStatus_MarriedWithoutRegistration}              chain=**/XCUIElementTypeOther[`label == "Married without registration"`][2]
${iOS_EN_MartialStatus_Divorced}                                chain=**/XCUIElementTypeOther[`label == "Divorced"`][2]
${iOS_EN_MartialStatus_Windowed}                                chain=**/XCUIElementTypeOther[`label == "Widowed"`][2]
${iOS_EN_Done_Button}                                           chain=**/XCUIElementTypeButton[`label == "Done"`]

# __________________________adddress______________________

${iOS_EN_AddressDetails_HeaderText}                             chain=**/XCUIElementTypeStaticText[`label CONTAINS "Please check and update your particulars"`]
${iOS_EN_ResidentialAddress_HeaderText}                         chain=**/XCUIElementTypeStaticText[`label CONTAINS "Residential address"`][-1]
${iOS_EN_AddressDetails_AddressLine1}                           chain=**/XCUIElementTypeStaticText[`name == "Address line 1"`][1]
#**/XCUIElementTypeOther[`label == "Address line 1 Required"`][2]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_AddressDetails_AddressLine2}                           xpath=(//XCUIElementTypeOther[@name="Address line 2 (Optional)"])[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_AddressDetails_ZipCode}                                xpath=(//XCUIElementTypeStaticText[@name="Zip code"])[1]/parent::XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField

# ${iOS_EN_AddressDetails_AddressLine1}    chain=**/XCUIElementTypeTextField[`name == "input"`][1]
# ${iOS_EN_AddressDetails_AddressLine2}    chain=**/XCUIElementTypeTextField[`name == "input"`][2]
# ${iOS_EN_AddressDetails_ZipCode}    chain=**/XCUIElementTypeTextField[`name == "input"`][3]
${iOS_EN_MyIDCardAddressSame_chkbox}                            chain=**/XCUIElementTypeOther[`label CONTAINS "My ID card address"`][-1]/XCUIElementTypeOther
${iOS_EN_IDCardAddress_HeaderText}                              chain=**/XCUIElementTypeStaticText[`label CONTAINS "ID card"`][1]

# ----------------Income
${iOS_EN_Confimation_Chekbox}                                   xpath=(//XCUIElementTypeOther[contains(@name, "I hereby certify that I have given the information")])[23]/XCUIElementTypeOther
# (//android.widget.TextView[contains(@text,'I hereby certify that I have given the information by myself and the above statements, my score and my type of investor are true and correct. In ')]/../..//android.view.ViewGroup)[3]

# -----------------------Suitablity Assessment----------------------------------------------
${iOS_EN_SUitablityAssement_Header}                             chain=**/XCUIElementTypeStaticText[`label == "Suitability assessment"`]
${iOS_EN_SuitablityAssment_YourAgeGroup}                        chain=**/XCUIElementTypeOther[`label CONTAINS "Your age group"`][22]
${iOS_EN_Submit_Button}                                         chain=**/XCUIElementTypeButton[`label == "Submit"`]
