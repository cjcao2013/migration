*** Variables ***
${iOS_EN_SelectPaymentMethod_txt}      chain=**/XCUIElementTypeStaticText[`label == "Select payment method"`]
${iOS_EN_PremiumAmount}                chain=**/XCUIElementTypeStaticText[`label CONTAINS "Premium amount"`]
${iOS_EN_QRcode}                   chain=**/XCUIElementTypeOther[`label == "QR code for bank transfer"`][-1]
${iOS_EN_CreditCard}                chain=**/XCUIElementTypeOther[`label == "Credit card"`][-1]

${iOS_EN_lang}              chain=**/XCUIElementTypeStaticText[`name == "ไทย"`]
${iOS_EN_Englang}           chain=**/XCUIElementTypeStaticText[`name == "English"`]
${iOS_EN_RP_CreditCardNumber}        xpath=(//XCUIElementTypeOther[@name="CARD NUMBER"]/following::XCUIElementTypeTextField)[1]
${iOS_EN_RP_ExpiryDate}        chain=**/XCUIElementTypeTextField[`value == "MM / YY"`]
${iOS_EN_RP_CVV}               xpath=(//XCUIElementTypeOther[@name="CVV/CVV2"]/following::XCUIElementTypeTextField)[1]
${iOS_EN_RP_CardHolderName}    xpath=(//XCUIElementTypeOther[@name="CARDHOLDER NAME"]/following::XCUIElementTypeTextField)[1]
${iOS_EN_RP_EmailAddress}      xpath=(//XCUIElementTypeOther[@name="EMAIL ADDRESS"]/following::XCUIElementTypeTextField)[1]
${iOS_EN_Cancel_Btn}        chain=**/XCUIElementTypeButton[`name == "CANCEL"`]
${iOS_EN_ContinuePayment}   chain=**/XCUIElementTypeButton[`name == "CONTINUE PAYMENT"`]
${iOS_EN_SecureValidation}      chain=**/XCUIElementTypeStaticText[`name == "Secure Cardholder Verification"`]
${iOS_EN_OTPField}          chain=**/XCUIElementTypeOther[`name == "main"`]/XCUIElementTypeSecureTextField
${iOS_EN_RequestNewOTP}     chain=**/XCUIElementTypeButton[`name == "Request New OTP"`]
${iOS_EN_SucessfulTransaction}      chain=**/XCUIElementTypeStaticText[`name == "การทำธุรกรรมที่ประสบความสำเร็จ"`]
${iOS_EN_BackToStore}       chain=**/XCUIElementTypeButton[`name == "กลับไปยังร้านค้า"`]


${Android_EN_QRcode}                   xpath=//android.widget.TextView[@text="QR code for bank transfer"]
${Android_EN_CreditCard}            android=new UiSelector().textContains("Credit card")
${Android_EN_lang}                  xpath=(//android.widget.TextView[@text="ไทย"])[1]
${Android_EN_Englang}               xpath=//android.widget.TextView[@resource-id="react-select-2-option-0"]
${Android_EN_RP_CreditCardNumber}       xpath=//android.view.View[contains(@text,'CARD NUMBER')]/parent::android.view.View/following-sibling::android.view.View/android.widget.EditText
${Android_EN_RP_ExpiryDate}             xpath=//android.view.View[contains(@text,'EXPIRY DATE')]/parent::android.view.View/following-sibling::android.view.View/android.widget.EditText
${Android_EN_RP_CVV}                    xpath=//android.view.View[contains(@text,'CVV/CVV2')]/parent::android.view.View/following-sibling::android.view.View/android.widget.EditText
${Android_EN_RP_CardHolderName}         xpath=//android.view.View[contains(@text,'CARDHOLDER NAME')]/parent::android.view.View/following-sibling::android.view.View/android.widget.EditText
${Android_EN_RP_EmailAddress}           xpath=//android.view.View[contains(@text,'EMAIL ADDRESS')]/parent::android.view.View/following-sibling::android.view.View/android.widget.EditText
${Android_EN_Cancel_Btn}                xpath=//android.widget.Button[@text="CANCEL"]
${Android_EN_ContinuePayment}           xpath=//android.widget.Button[@text="CONTINUE PAYMENT"]
${Android_EN_SecureValidation}          xpath=//android.widget.TextView[contains(@text,'Secure Cardholder Verification')]
${Android_EN_OTPField}                  xpath=//android.widget.TextView[contains(@text,'Default OTP 123456')]/following-sibling::android.widget.EditText
${Android_EN_RequestNewOTP}              xpath=//android.widget.Button[contains(@text,'Request New OTP')]
${Android_EN_SucessfulTransaction}
${Android_EN_BackToStore}

${Android_EN_RenewalTransactionStatus}      xpath=