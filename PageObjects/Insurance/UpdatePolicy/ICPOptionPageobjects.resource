*** Variables ***
${iOS_EN_AddPaymentMethod_Button}           chain=**/XCUIElementTypeOther[`label == 'Add payment method'`]
${iOS_EN_UploadDocument_Button}             xpath=(//android.view.ViewGroup[@resource-id='add-more-photo-button']//following-sibling::android.view.ViewGroup)[2]

${iOS_EN_BankName_DropDown}                 chain=**/XCUIElementTypeOther[`label CONTAINS 'Bank name'`][-1]
${iOS_EN_Done_Button}                       chain=**/XCUIElementTypeButton[`label == 'Done'`]
${iOS_EN_Bank_Account_No}                   chain=**/XCUIElementTypeOther[`label CONTAINS 'Bank account no'`][-1]

${iOS_EN_Save_Button}                       chain=**/XCUIElementTypeButton[`label == 'Save'`]
${iOS_EN_Submit_Button}                     chain=**/XCUIElementTypeButton[`label == 'Submit'`]
${iOS_EN_Error_Message_BankAccount}         chain=**/XCUIElementTypeStaticText[`label CONTAINS 'Please ensure bank account'`]
${iOS_EN_Error_Message_NoEligiblePolicy}    xpath=//android.widget.TextView[@text ='No eligible policy']
${iOS_EN_Change_Button}                     chain=**/XCUIElementTypeOther[`label == 'Change'`]
${iOS_EN_Checkbox_Promatpay}                accessibility_id=PromptPay-CheckBox
# VP
${iOS_EN_BankTansfer_Option}                chain=**/XCUIElementTypeOther[`label == 'Bank transfer'`][-1]
${iOS_EN_PromptPay_Option}                  chain=**/XCUIElementTypeOther[`label == 'PromptPay'`][-1]
${iOS_EN_Deposit_to_company_Option}         chain=**/XCUIElementTypeOther[`label == 'Deposit to company'`][-1]
${iOS_EN_Premium_settlement_Option}         chain=**/XCUIElementTypeOther[`label == 'Premium settlement'`][-1]
${iOS_EN_VP_Policy_No}                      xpath=(//XCUIElementTypeOther[contains(@name,'Current payout option')])[last()]/preceding-sibling::XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther
${iOS_EN_VP_Product_Name}                   xpath=(//XCUIElementTypeOther[contains(@name,'Current payout option')])[last()]/preceding-sibling::XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeStaticText
${iOS_EN_CashPayout_Sucessfully_Message}    xpath=(//android.widget.TextView[@text ='Just confirming we’ve successfully submitted your service request.'])
${iOS_EN_CurrentPayoutOption}               chain=**/XCUIElementTypeStaticText[`label CONTAINS 'Current ICP option:'`][-1]
${iOS_EN_CashpayoutOption_PolicyName}       chain=**/XCUIElementTypeOther[`label ENDSWITH "Active" or label ENDSWITH "Inactive" `][1]/**XCUIElementTypeStaticText[2]
# Transaction
${iOS_EN_ICPBackButton_Arrow}               chain=**/XCUIElementTypeButton[`name == "back-button"`]
#**/XCUIElementTypeOther[`label BEGINSWITH "Update policies"`][3]/XCUIElementTypeOther[1]/XCUIElementTypeOther
${iOS_EN_TransactionTab}                    chain=**/XCUIElementTypeOther[`label CONTAINS 'View transactions'`][-1]
${iOS_EN_ServiceReuest}                     chain=**/XCUIElementTypeOther[`label CONTAINS 'Service request'`][-1]
${iOS_EN_Transactions_ICP}                  xpath=(//android.widget.TextView[@text='Change ICP'])[1]
${iOS_EN_New_tPayout_Option}                xpath=(//android.widget.TextView[@text='New payout option']/following-sibling::android.widget.TextView)[1]
${iOS_EN_Curent_Payout_Option}              xpath=(//android.widget.TextView[@text='Current payout option']/following-sibling::android.widget.TextView)[1]
${iOS_EN_Transaction_ComplettionDate}       xpath=(//android.widget.TextView[@text='Completion date']/following-sibling::android.widget.TextView)[1]
${iOS_EN_Transaction_Bank_Name}             chain=**/XCUIElementTypeOther[`label CONTAINS 'Bank details'`][-1]
${iOS_EN_Transactiondetails}                chain=**/XCUIElementTypeOther[`label CONTAINS 'Policy applied'`][-1]
${iOS_EN_ICPAddImage}                       chain=**/XCUIElementTypeOther[`name == "add-more-photo-button"`]
