*** Variables ***
${iOS_EN_ErrorMsgForFundNoEligiblePolicy}           chain=**/XCUIElementTypeStaticText[`label == 'No eligible policy'`][-1]
${iOS_EN_FundpolicyName}                            xpath=(//XCUIElementTypeOther[contains(@name,'Current value')])[last()-4]/parent::XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther[2]/XCUIElementTypeStaticText[2]
${iOS_EN_Fundpolicyreisklevel}                      xpath=(//XCUIElementTypeOther[contains(@name,'Current value')])[last()-4]/parent::XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]
${iOS_EN_Fundpolicynumber}                          xpath=(//XCUIElementTypeOther[contains(@name,'Current value')])[last()-4]/parent::XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[1]
${iOS_EN_Fundpolicytype}                            xpath=(//XCUIElementTypeOther[contains(@name,'Current value')])[last()-4]/parent::XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]
${iOS_EN_FundSelectedPolicyStatus}                  xpath=(//XCUIElementTypeOther[contains(@name,'Current value')])[last()-4]/parent::XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther[3]
${iOS_EN_SwitchOutPage}                             accessibility_id=Switch OUT
${iOS_EN_SwitchInPage}                              accessibility_id=Switch IN
${iOS_EN_TotalEstimatedSwitchOutAmount}             xpath=//XCUIElementTypeStaticText[contains(@name,'Estimated total')]/following-sibling::XCUIElementTypeStaticText
${iOS_EN_SwitchText}                                chain=**/XCUIElementTypeStaticText[`label BEGINSWITH "Switch"`][-1]
${iOS_EN_Addnewfunds}                               chain=**/XCUIElementTypeOther[`label == 'Add new funds'`][-1]
${iOS_EN_switchInFundName}                          xpath=(//XCUIElementTypeOther[contains(@name,'Switch in the remaining')])[last()]/following-sibling::XCUIElementTypeOther
${iOS_EN_Accept}                                    chain=**/XCUIElementTypeButton[`label == 'Accept'`]
${iOS_EN_confirm}                                   chain=**/XCUIElementTypeOther[`label CONTAINS 'I confirm'`][-1]
${EN_Trans_FundSwitch}                              xpath=//android.widget.TextView[@text='Fund Switch']
${EN_Trans_viewtransaction}                         accessibility_id=undefined-fwd-text-content
${EN_TrasSwitchinamount}                            xpath=//android.widget.TextView[@text='Switch in amount']/following::android.widget.TextView[contains(@text,'THB')]
${EN_TrasSwitchoutamount}                           xpath=//android.widget.TextView[@text='Switch in amount']/preceding::android.widget.TextView[contains(@text,'THB')]
${iOS_EN_Estimatedtotalswitchoutinamount}           chain=**/XCUIElementTypeOther[`label CONTAINS 'Estimated total switch out/in amount'`][-1]/XCUIElementTypeOther
${EN_Trans_FundSwitchGroup_txt}                     xpath=//android.widget.TextView[@text='Fund Switch']/parent::android.view.ViewGroup
${EN_Trans_FundSwitchStatus}                        xpath=//android.widget.TextView[@text='Fund Switch']/following-sibling::android.view.ViewGroup/android.widget.TextView
${EN_Trans_PolicyNo}                                xpath=//android.widget.TextView[@text='Fund Switch']/following-sibling::android.widget.TextView
${EN_Date}                                          xpath=(//android.widget.TextView[@text='Date']/following-sibling::android.widget.TextView)[1]
${iOS_EN_FundTransactionDetails}                    chain=**/XCUIElementTypeOther[`label CONTAINS 'Switch out amount'`][-1]

# ------- Android Objects -------
${Android_EN_Accept}                                xpath=//android.widget.TextView[@text='Accept']
${Android_EN_ErrorMsgForFundNoEligiblePolicy}       xpath=//android.widget.TextView[@text='No eligible policy']
${Android_EN_FundpolicyName}                        xpath=(//android.view.ViewGroup/android.widget.TextView)[2]
${Android_EN_Fundpolicyreisklevel}                  xpath=(//android.view.ViewGroup/android.widget.TextView)[1]
${Android_EN_Fundpolicynumber}                      xpath=(//android.view.ViewGroup/android.widget.TextView)[3]
${Android_EN_Fundpolicytype}                        xpath=(//android.view.ViewGroup/android.widget.TextView)[4]
${Android_EN_FundSelectedPolicyStatus}              xpath=(//android.view.ViewGroup/android.widget.TextView)[5]
${Android_EN_SwitchOutPage}                         xpath=//android.widget.TextView[@text='Switch OUT']
${Android_EN_SwitchInPage}                          xpath=//android.widget.TextView[@text='Switch IN']
${Android_EN_TotalEstimatedSwitchOutAmount}         xpath=//android.widget.TextView[contains(@text,'Estimated total')]/following-sibling::android.widget.TextView
${Android_EN_Addnewfunds}                           xpath=//android.widget.TextView[@text='Add new funds']
${Android_EN_switchInFundName}                      xpath=//android.widget.TextView[@text='% to switch in']
${Android_EN_Estimatedtotalswitchoutinamount}       xpath=//android.widget.TextView[@text='Estimated total switch out/in amount']/following-sibling::android.widget.TextView
${Android_EN_FundTransactionDetails}                xpath=//android.widget.TextView[@text='FATCA']/following-sibling::android.widget.TextView[1]
${Android_EN_SwitchText}                            xpath=//android.widget.TextView[contains(@text,'Switch')][1]
${EN_policyNumber}                                  xpath=(//android.widget.TextView[@text='Fund Switch']/following-sibling::android.view.ViewGroup[1]/../android.widget.TextView[2])[1]
${EN_TransStatus}                                   xpath=//android.widget.TextView[@text='Fund Switch']/following-sibling::android.view.ViewGroup//android.widget.TextView
${EN_CompletionDate}                                xpath=//android.widget.TextView[@text='Completion date']
${EN_Trans_OutPerc}                                 xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[1]//android.widget.TextView[2]
${EN_Trans_OutFundValue}                            xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[1]//android.widget.TextView[3]
${EN_Trans_INPerc}                                  xpath=//android.widget.TextView[contains(@text,'Switch in amount')]/following-sibling::android.view.ViewGroup[1]//android.widget.TextView[2]
${EN_Trans_INFundValue}                             xpath=//android.widget.TextView[contains(@text,'Switch in amount')]/following-sibling::android.view.ViewGroup[1]//android.widget.TextView[3]
${Android_EN_confirm}                               xpath=//android.widget.TextView[contains(@text,'I confirm')]

# ${Android_EN_FundpolicyName}    xpath=//android.widget.TextView[@text='Current value']/../../android.view.ViewGroup[1]/../../android.view.ViewGroup/../../android.view.ViewGroup//android.widget.TextView[2]
${Android_EN_fundSwitchacknowledgeChkBox}           android=new UiSelector().resourceId("FundSwitch-terms-checkbox")