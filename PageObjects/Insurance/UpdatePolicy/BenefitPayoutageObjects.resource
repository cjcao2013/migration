*** Variables ***
${iOS_EN_BenefitPayoutTxt}              chain=**/XCUIElementTypeStaticText[`name == "Benefit payout history"`]
${iOS_EN_BenefitPayoutHistoryList}      chain=**/XCUIElementTypeOther[`name == "benefit-payout-flatlist"`]/XCUIElementTypeScrollView/XCUIElementTypeOther
${iOS_EN_SelectYearDropdown}            accessibility_id=period-filter-pressable
${iOS_EN_SelectMaxyear}                 chain=**/XCUIElementTypeOther[`name == "3 years"`][-1]


${Android_EN_BenefitPayoutTxt}              chain=**/XCUIElementTypeStaticText[`name == "Benefit payout history"`]
${Android_EN_BenefitPayoutHistoryList}      xpath=(//android.widget.ScrollView[@resource-id="benefit-payout-flatlist"]//following-sibling::android.view.ViewGroup)[1]/android.view.ViewGroup/android.view.ViewGroup
${Android_EN_SelectYearDropdown}            xpath=//android.widget.TextView[@text="The information displayed is only for the last "]
${Android_EN_SelectMaxyear}                 xpath=//android.widget.TextView[@text="3 years"]