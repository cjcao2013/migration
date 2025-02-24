*** Variables ***
${iOS_EN_PolicyLoanRepayment_txt}       chain=**/XCUIElementTypeStaticText[`label == "Policy loan repayment"`]
${iOS_EN_Loanoutstanding}                           chain=**/XCUIElementTypeOther[`label BEGINSWITH "Loan outstanding"`]/XCUIElementTypeStaticText[2]
${iOS_EN_Loaninterest}                   chain=**/XCUIElementTypeOther[`label BEGINSWITH "Loan interest"`]/XCUIElementTypeStaticText[2]
${iOS_EN_Interestrate}                   chain=**/XCUIElementTypeOther[`label BEGINSWITH "Interest rate"`]/XCUIElementTypeStaticText[2]
${iOS_EN_Totalasoftoday}                            chain=**/XCUIElementTypeOther[`label BEGINSWITH "Total as of today"`]/XCUIElementTypeStaticText[2]
${iOS_EN_PolicyLoanAmt}                     chain=**/XCUIElementTypeOther[`label BEGINSWITH "Enter amount here"`]
${iOS_EN_Max_LoanLimit_Error}                       chain=**/XCUIElementTypeStaticText[`label == "The inputted amount cannot be greater than the total as of today"`]
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




