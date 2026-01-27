*** Variables ***
${iOS_EN_PolicyLoanRepayment_txt}       chain=**/XCUIElementTypeStaticText[`label == "Policy loan repayment"`]
${iOS_EN_Loanoutstanding}                           chain=**/XCUIElementTypeOther[`label BEGINSWITH "Loan outstanding"`]/XCUIElementTypeStaticText[2]
${iOS_EN_Loaninterest}                   chain=**/XCUIElementTypeOther[`label BEGINSWITH "Loan interest"`]/XCUIElementTypeStaticText[2]
${iOS_EN_Interestrate}                   chain=**/XCUIElementTypeOther[`label BEGINSWITH "Interest rate"`]/XCUIElementTypeStaticText[2]
${iOS_EN_Totalasoftoday}                            chain=**/XCUIElementTypeOther[`label BEGINSWITH "Total as of today"`]/XCUIElementTypeStaticText[2]
${iOS_EN_PolicyLoanAmt}                     chain=**/XCUIElementTypeOther[`label BEGINSWITH "Enter amount here"`]
${iOS_EN_Max_LoanLimit_Error}                       chain=**/XCUIElementTypeStaticText[`label == "The inputted amount cannot be greater than the total as of today"`]
${iOS_EN_Min_LoanLimit_Error}                       chain=**/XCUIElementTypeStaticText[`label == "Please ensure that the minimum amount is equal or greater than THB 500.00"`]
${iOS_EN_Totalasoftoday_txt}                    accessibility_id=request-amount-option-item-default
${iOS_EN_PayNow}                     chain=**/XCUIElementTypeButton[`label == "Pay now"`]
${iOS_EN_QRcode_txt}                   chain=**/XCUIElementTypeStaticText[`label == "QR code for bank transfer"`]
${iOS_EN_PaymentDetails_txt}            chain=**/XCUIElementTypeStaticText[`label == "Payment details"`]
${iOS_EN_PolicyNumber_txt}        xpath=//XCUIElementTypeStaticText[@name="Policy number"]/following-sibling::XCUIElementTypeStaticText
${iOS_EN_PaymentAmount_txt}        xpath=//XCUIElementTypeStaticText[@name="Premium amount"]/following-sibling::XCUIElementTypeStaticText
${iOS_EN_PremiumAmount_txt}        xpath=//XCUIElementTypeStaticText[@name="Premium amount"]/following-sibling::XCUIElementTypeStaticText
${iOS_EN_DownloadQRCode}        chain=**/XCUIElementTypeButton[`label == "Download QR code"`]
${iOS_EN_BackToDashboard}        chain=**/XCUIElementTypeOther[`label == "Back to dashboard"`]
${iOS_EN_QRCodeSaved_txt}        chain=**/XCUIElementTypeOther[`label == "QR code is saved to your device album"`][5]
${iOS_EN_Notice_Text}           xpath=//XCUIElementTypeOther[@name="Notice"]/following-sibling::XCUIElementTypeOther/XCUIElementTypeStaticText
${iOS_EN_loan_temsandconditonchekbox}         accessibility_id=CheckBox
${iOS_EN_TimeingPoup}                   chain=**/XCUIElementTypeStaticText[`name BEGINSWITH "Interest amount is updated daily between 10:00 PM and 8:00 AM."`]
${iOS_EN_IUnderstandbutton}             chain=**/XCUIElementTypeButton[`name == "I understand"`]
${iOS_EN_AmountClearText}                     chain=**/XCUIElementTypeOther[`label BEGINSWITH "Enter amount here"`]

${Android_EN_TimeingPoup}           xpath=//android.widget.TextView[@text="Loan interest disclaimer"]/following-sibling::android.widget.TextView
${Android_EN_IUnderstandbutton}         xpath=//android.widget.Button[@content-desc="I understand"]
${Android_EN_loan_temsandconditonchekbox}                      xpath=//android.view.ViewGroup[@resource-id="LoanRepayment-terms-checkbox"]/android.view.ViewGroup
${Android_EN_Notice_Text}                   xpath=(//android.widget.TextView[@text="Notice"]//parent::android.view.ViewGroup)/parent::android.view.ViewGroup/android.view.ViewGroup[2]/android.widget.TextView
${Android_EN_PolicyLoanRepayment_txt}           android=new UiSelector().text("Policy loan repayment")
${Android_EN_Loanoutstanding}                   xpath=//android.widget.TextView[@text="Loan outstanding"]//following-sibling::android.widget.TextView
${Android_EN_Loaninterest}                      xpath=//android.widget.TextView[@text="Loan interest"]//following-sibling::android.widget.TextView
${Android_EN_Interestrate}                      xpath=//android.widget.TextView[@text="Interest rate"]//following-sibling::android.widget.TextView
${Android_EN_Totalasoftoday}                    xpath=//android.widget.TextView[@text="Total as of today"]//following-sibling::android.widget.TextView
${Android_EN_PolicyLoanAmt}                         xpath=//android.widget.EditText[@resource-id='loan-repayment-specifiy-amount-input']
${Android_EN_AmountClearText}                       xpath=//android.widget.EditText[@resource-id='loan-repayment-specifiy-amount-input']
${Android_EN_Max_LoanLimit_Error}                   xpath=//android.widget.TextView[@text="The inputted amount cannot be greater than the total as of today"]
${Android_EN_Totalasoftoday_txt}                    xpath=(//android.widget.TextView[contains(@text,'Total as of today')])[last()]
${Android_EN_PayNow}                                xpath=//android.widget.Button[@content-desc="Pay now"]
${Android_EN_QRcode_txt}                            xpath=//android.widget.TextView[@text="QR code for bank transfer"]
${Android_EN_PaymentDetails_txt}                 android=new UiSelector().text("Payment details")
${Android_EN_PolicyNumber_txt}        xpath=//android.widget.TextView[@text="Policy number"]//following-sibling::android.widget.TextView
${Android_EN_PaymentAmount_txt}        xpath=//android.widget.TextView[@text="Payment amount"]//following-sibling::android.widget.TextView
${Android_EN_PremiumAmount_txt}        xpath=//android.widget.TextView[@text="Premium amount"]//following-sibling::android.widget.TextView
${Android_EN_DownloadQRCode}            xpath=//android.widget.TextView[@text="Download QR code"]
${Android_EN_BackToDashboard}       xpath=//android.widget.TextView[@text="Back to dashboard"]
${Android_EN_QRCodeSaved_txt}       xpath=//android.widget.TextView[@text="QR code is saved to your device albu"]