*** Variables ***
${iOS_EN_BenefitPayoutTxt}              chain=**/XCUIElementTypeStaticText[`name == "Benefit payout history"`]
${iOS_EN_BenefitPayoutHistoryList}      chain=**/XCUIElementTypeOther[`name == "benefit-payout-flatlist"`]/XCUIElementTypeScrollView/XCUIElementTypeOther
${iOS_EN_SelectYearDropdown}            accessibility_id=period-filter-pressable
${iOS_EN_SelectMaxyear}                 chain=**/XCUIElementTypeOther[`name == "3 years"`][-1]


