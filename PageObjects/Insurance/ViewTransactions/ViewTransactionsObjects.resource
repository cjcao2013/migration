*** Variables ***
${Android_EN_TransactionTab}                            android=new UiSelector().textContains("View transactions")
${Android_EN_ServiceReuest}                             android=new UiSelector().textContains("Service request(s)")
${Android_EN_Transactions_first_PersonalDetail}         xpath=(//android.widget.TextView[@text='Change of personal details'])[1]
${Android_EN_Transactions_first_Address}                xpath=(//android.widget.TextView[@text='Change of address'])[1]
# android=new UiSelector().textContains("Change of personal details").instance(0)
${Swipe}                                                android=new UiSelector().textContains("Change of beneficiary").instance(0)
${Completed}                                            xpath=(//android.widget.TextView[@text='Completed'])[1]
${InProgress}                                           xpath=(//android.widget.TextView[@text='In progress'])[1]

${Android_EN_Updated_Email}                             xpath=//android.widget.TextView[@text='Email']
${Android_EN_TransactionEmail}                          xpath=(//android.widget.TextView[@text='Email']/following-sibling::android.widget.TextView)[1]
${Android_EN_TransactionMobile}                         xpath=(//android.widget.TextView[@text='Mobile number']/following-sibling::android.widget.TextView)[1]
${Android_EN_TransactionAddress}                        xpath=//android.widget.TextView[@text='New address']/following-sibling::android.widget.TextView

${Android_EN_TransactionNameTitle}                      xpath=(//android.widget.TextView[@text='Title']/following-sibling::android.widget.TextView)[1]
${Android_EN_TransactionFirstName}                      xpath=(//android.widget.TextView[@text='First name']/following-sibling::android.widget.TextView)[1]
${Android_EN_TransactionMiddleName}                     xpath=(//android.widget.TextView[@text='Middle name']/following-sibling::android.widget.TextView)[1]
${Android_EN_TransactionLastName}                       xpath=(//android.widget.TextView[@text='Last name']/following-sibling::android.widget.TextView)[1]
${Android_EN_TransactionMarital}                        xpath=(//android.widget.TextView[@text='Marital status']/following-sibling::android.widget.TextView)[1]
${Android_EN_TransactionStatusA}                        xpath=(//android.widget.TextView[@text='Change of personal details']/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]

${Android_EN_Trans_FundSwitch}                          xpath=//android.widget.TextView[@text='Fund Switch']
${Android_EN_TransFundStatus}                           xpath=//android.widget.TextView[@text='Fund Switch']/following-sibling::android.view.ViewGroup/android.widget.TextView
${Android_EN_Trans_Deleterider}                         xpath=//android.widget.TextView[contains(@text,'Delete rider')]
${Android_EN_Trans_PolicyDeleteriderStatus}             xpath=//android.widget.TextView[contains(@text,'Delete rider')]/following-sibling::android.view.ViewGroup/android.widget.TextView
${Android_EN_Updated_Email}                             xpath=//android.widget.TextView[@text='Email']
${Android_EN_Trans_FundSwitchStatus}                    xpath=//android.widget.TextView[@text='Fund Switch']/following-sibling::android.view.ViewGroup/android.widget.TextView
${Android_EN_Transactions_first_PaymentFrequency}       xpath=(//android.widget.TextView[@text='Change of payment frequency'])[1]
${Android_EN_Trans_Freelookcancellation_txt}            xpath=//android.widget.TextView[@text='Freelook cancellation']
${Android_EN_Trans_PolicyFreelookstatus}                xpath=//android.widget.TextView[@text='Freelook cancellation']/following-sibling::android.view.ViewGroup/android.widget.TextView
${Android_EN_PaymentFrequency}                          xpath=(//android.widget.TextView[contains(@text,'payment frequency')]/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]
${Android_EN_Trans_PolicyStatus}                        xpath=//android.widget.TextView[@text='Surrender policy']/following-sibling::android.view.ViewGroup/android.widget.TextView
