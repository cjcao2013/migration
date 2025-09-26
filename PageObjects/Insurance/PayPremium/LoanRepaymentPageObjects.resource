*** Variables ***
${iOS_EN_PolicyLoanRepayment_txt}       chain=**/XCUIElementTypeStaticText[`label == "Policy loan repayment"`]
${iOS_EN_Loanoutstanding}                           chain=**/XCUIElementTypeOther[`label BEGINSWITH "Loan outstanding"`]/XCUIElementTypeStaticText[2]
${iOS_EN_Loaninterest}                   chain=**/XCUIElementTypeOther[`label BEGINSWITH "Loan interest"`]/XCUIElementTypeStaticText[2]
${iOS_EN_Interestrate}                   chain=**/XCUIElementTypeOther[`label BEGINSWITH "Interest rate"`]/XCUIElementTypeStaticText[2]
${iOS_EN_Totalasoftoday}                            chain=**/XCUIElementTypeOther[`label BEGINSWITH "Total as of today"`]/XCUIElementTypeStaticText[2]
${iOS_EN_PolicyLoanAmt}                     chain=**/XCUIElementTypeOther[`label BEGINSWITH "Enter amount here"`]
${iOS_EN_Max_LoanLimit_Error}                       chain=**/XCUIElementTypeStaticText[`label == "The inputted amount cannot be greater than the total as of today"`]
${iOS_EN_Min_LoanLimit_Error}                       chain=**/XCUIElementTypeStaticText[`label == "Please ensure that the minimum amount is equal or greater than THB 500.00"`]
${iOS_EN_Totalasoftoday_txt}                     chain=**/XCUIElementTypeOther[`label == "Total as of today"`]
${iOS_EN_PayNow}                     chain=**/XCUIElementTypeButton[`label == "Pay now"`]
${iOS_EN_QRcode_txt}                   chain=**/XCUIElementTypeStaticText[`label == "QR code for bank transfer"`]
${iOS_EN_PaymentDetails_txt}            chain=**/XCUIElementTypeStaticText[`label == "Payment details"`]
${iOS_EN_PolicyNumber_txt}        xpath=(//XCUIElementTypeOther[contains(@name,"Policy number")])[22]
${iOS_EN_PaymentAmount_txt}        xpath=(//XCUIElementTypeOther[contains(@name,"Payment amount")])[22]
${iOS_EN_PremiumAmount_txt}        xpath=(//XCUIElementTypeOther[contains(@name,"Premium amount")])[22]
${iOS_EN_DownloadQRCode}        chain=**/XCUIElementTypeButton[`label == "Download QR code"`]
${iOS_EN_BackToDashboard}        chain=**/XCUIElementTypeOther[`label == "Back to dashboard"`]
${iOS_EN_QRCodeSaved_txt}        chain=**/XCUIElementTypeOther[`label == "QR code is saved to your device album"`][5]


${Android_EN_PolicyLoanRepayment_txt}           android=new UiSelector().text("Policy loan repayment")
${Android_EN_Loanoutstanding}                   xpath=//android.widget.TextView[@text="Loan outstanding"]//following-sibling::android.widget.TextView
${Android_EN_Loaninterest}                      xpath=//android.widget.TextView[@text="Loan interest"]//following-sibling::android.widget.TextView
${Android_EN_Interestrate}                      xpath=//android.widget.TextView[@text="Interest rate"]//following-sibling::android.widget.TextView
${Android_EN_Totalasoftoday}                    xpath=//android.widget.TextView[@text="Total as of today"]//following-sibling::android.widget.TextView
${Android_EN_PolicyLoanAmt}                         xpath=//android.widget.EditText[@text="Enter amount here"]
${Android_EN_Max_LoanLimit_Error}                   xpath=//android.widget.TextView[@text="The inputted amount cannot be greater than the total as of today"]
${Android_EN_Totalasoftoday_txt}                    xpath=(//android.widget.TextView[@text="Total as of today"][last()])[2]
${Android_EN_PayNow}                                xpath=//android.widget.Button[@content-desc="Pay now"]
${Android_EN_QRcode_txt}                            xpath=//android.widget.TextView[@text="QR code for bank transfer"]
${Android_EN_PaymentDetails_txt}                 android=new UiSelector().text("Payment details")
${Android_EN_PolicyNumber_txt}        xpath=//android.widget.TextView[@text="Policy number"]//following-sibling::android.widget.TextView
${Android_EN_PaymentAmount_txt}        xpath=//android.widget.TextView[@text="Payment amount"]//following-sibling::android.widget.TextView
${Android_EN_PremiumAmount_txt}        xpath=//android.widget.TextView[@text="Premium amount"]//following-sibling::android.widget.TextView
${Android_EN_DownloadQRCode}            xpath=//android.widget.TextView[@text="Download QR code"]
${Android_EN_BackToDashboard}       xpath=//android.widget.TextView[@text="Back to dashboard"]
${Android_EN_QRCodeSaved_txt}       xpath=//android.widget.TextView[@text="QR code is saved to your device albu"]