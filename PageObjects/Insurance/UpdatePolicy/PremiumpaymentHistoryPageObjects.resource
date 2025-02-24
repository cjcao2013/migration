*** Variables ***
${iOS_EN_PaymentHistoryTitleText}        accessibility_id=Premium payment history
${iOS_EN_PaymentReceiptNumber}          chain=**/XCUIElementTypeOther[`name BEGINSWITH "Receipt number:"`][-1]/XCUIElementTypeStaticText[-1]
${iOS_EN_PaymentDueDate}          chain=**/XCUIElementTypeOther[`name BEGINSWITH "Due date:"`][-1]/XCUIElementTypeStaticText[-1]
${iOS_EN_PaymentAmount}          chain=**/XCUIElementTypeOther[`name BEGINSWITH "Amount:"`][-1]/XCUIElementTypeStaticText[-1]
${iOS_EN_PaymentHistoryList}        chain=**/XCUIElementTypeOther[`name == "premium-payments-flatlist"`]/XCUIElementTypeScrollView/XCUIElementTypeOther/XCUIElementTypeOther
