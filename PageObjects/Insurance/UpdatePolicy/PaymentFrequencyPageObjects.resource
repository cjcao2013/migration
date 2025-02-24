*** Variables ***
${iOS_EN_CurrentPaymentFrequency}       chain=**/XCUIElementTypeOther[`label CONTAINS 'Current payment frequency'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther[1]
${iOS_EN_CurrentPaymentPremium}          chain=**/XCUIElementTypeOther[`label CONTAINS 'Current payment frequency'`][-1]/XCUIElementTypeOther/XCUIElementTypeOther[2]
${iOS_EN_CurrentPaymentMethod}           chain=**/XCUIElementTypeOther[`label CONTAINS 'Current payment method'`][-1]/XCUIElementTypeStaticText[2]
${iOS_EN_FrequencyTransactionDetail}      chain=**/XCUIElementTypeOther[`label CONTAINS 'Policy applied'`][-1]
${iOS_EN_PayerPolicy}           chain=**/XCUIElementTypeStaticText[`label CONTAINS 'Since you are a payor you are allowed to view the payment frequency.  For any specific policy related updates.'`][-1]

${Android_EN_CurrentPaymentFrequency}   xpath=//android.widget.TextView[@text='Current payment frequency']//following::android.widget.TextView[1]
${Android_EN_CurrentPaymentPremium}     xpath=//android.widget.TextView[@text='Current payment frequency']//following::android.widget.TextView[2]
${Android_EN_CurrentPaymentMethod}      xpath=//android.widget.TextView[@text='Current payment method']//following::android.widget.TextView[1]
${Android_EN_FrequencyTransactionDetail}      xpath=//android.widget.TextView[@text='Policy applied']/following-sibling::android.widget.TextView
${Android_EN_Payment_Frequency}         xpath=//android.widget.TextView[@text='Payment frequency']/following-sibling::android.widget.TextView
${Android_EN_New_Premium_Amount}     xpath=//android.widget.TextView[@text='New Premium Amount']/following-sibling::android.widget.TextView
${Android_EN_Fatca_Status}          xpath=//android.widget.TextView[@text='FATCA']/following-sibling::android.widget.TextView[1]

