*** Variables ***
${iOS_EN_yourpayoutMethodText}              chain=**/XCUIElementTypeStaticText[`label == 'Your refund method'`]
${Android_EN_yourpayoutMethodText}          xpath=//android.widget.TextView[@text='Your refund method']

${iOS_EN_PaymentMethod_Option}              chain=**/XCUIElementTypeOther[`label == "Add payment method"`]
${Android_EN_PaymentMethod_Option}          xpath=//android.widget.TextView[@text='Add payment method']

${iOS_EN_CaptureRiderData}                  chain=**/XCUIElementTypeOther[`label CONTAINS 'Insured'`][-1]
${iOS_EN_DeleteRiderTransactionDetails}     chain=**/XCUIElementTypeOther[`label CONTAINS "Rider to delete"`][-1]

${Android_EN_BankName_VP}                   xpath=(//android.widget.TextView[@text='Refund method']/following-sibling::android.widget.TextView)[2]
${Android_EN_Bank_AccountNo_VP}             xpath=(//android.widget.TextView[@text='Refund method']/following-sibling::android.widget.TextView)[1]
${Android_EN_Fatca_status_VP}               xpath=//android.widget.TextView[@text='FATCA']/following-sibling::android.widget.TextView[1]
${Android_EN_RdierToDelete}                 xpath=//android.widget.TextView[@text='Rider to delete']/following-sibling::android.widget.TextView
${Android_EN_CompletionDate_VP}             xpath=//android.widget.TextView[contains(@text,'date')]/following-sibling::android.widget.TextView[1]

${iOS_EN_SurrenderCancel}                   chain=**/XCUIElementTypeStaticText[`name == "How to surrender / cancel your policy"`][1]