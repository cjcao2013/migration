*** Variables ***
# ${iOS_EN_InvestmentpolicyName}    xpath=(//XCUIElementTypeOther[contains(@label, '40763685')])[last()-2]//XCUIElementTypeStaticText[2]
# ${iOS_EN_Investmentpolicytype}    xpath=((//XCUIElementTypeOther[contains(@label, '40763685')])[last()-2]//XCUIElementTypeStaticText)[last()]
# ${risklevel}    xpath=((//XCUIElementTypeOther[contains(@label, '40763685')])[last()-2]//XCUIElementTypeStaticText)[last()-2]
${iOS_EN_Investment_Txt}                chain=**/XCUIElementTypeOther[`label == "Investment(s)"`][2]
${iOS_EN_totalperc}                     chain=**/XCUIElementTypeStaticText[`label == 'Total'`]
${iOS_EN_gainorloassvalue_txt}          chain=**/XCUIElementTypeOther[`label CONTAINS 'Current value'`]/XCUIElementTypeStaticText[1]
${iOS_EN_totalcurrentvalue}             chain=**/XCUIElementTypeOther[`label CONTAINS "THB"`]/XCUIElementTypeStaticText[2]
${iOS_EN_listoffunds}                   xpath=//XCUIElementTypeOther[@name="investment-header-view"]/following-sibling::XCUIElementTypeOther[contains(@name,"THB")]
#//XCUIElementTypeOther[@name="investment-header-view"]/following::XCUIElementTypeOther
${iOS_EN_listofpolicies}                chain=**/XCUIElementTypeButton[`label == "Current investment"`]
#chain=**/XCUIElementTypeOther[`label CONTAINS 'Your unit linked policy'`][-1]/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther
${iOS_EN_NoInvestment}                  xpath=(//XCUIElementTypeOther[@name="No Investment(s) yet!"])[2]
${iOS_EN_Investment_Policy_List}        chain=**/XCUIElementTypeButton[`label == "Current investment"`]

${Android_EN_InvestmentTxt}             xpath=//android.widget.TextView[@text='Investment(s)']
${Android_EN_NoInvestment}              xpath=//android.widget.TextView[contains(@text,'No Investment')]
${Android_EN_listofpolicies}            xpath=//android.widget.ScrollView/android.view.ViewGroup/android.view.ViewGroup/android.view.ViewGroup/android.widget.ImageView
${Android_EN_policyName}                xpath=(//android.view.ViewGroup/android.widget.TextView)[2]
${Android_EN_policyrisklevel}           xpath=//android.widget.TextView[contains(@text,'RISK')]
${Android_EN_policynumber}              xpath=(//android.view.ViewGroup/android.widget.TextView)[4]
${Android_EN_policytype}                xpath=(//android.view.ViewGroup/android.widget.TextView)[5]
${Android_EN_PolicyStatus}              xpath=(//android.view.ViewGroup/android.widget.TextView)[6]
${Android_EN_gainorloassvalue_txt}      xpath=(//android.widget.TextView[@text='Current value'])[1]/following-sibling::android.widget.TextView[1]
${Android_EN_listoffunds}               xpath=(//android.widget.TextView[@text='Current value (THB)']/preceding-sibling::android.widget.TextView[1])
${Android_EN_totalperc}                 xpath=//android.widget.TextView[@text='Total']
${Android_EN_totalcurrentvalue}         xpath=(//android.widget.TextView[@text='Current value'])[1]/following-sibling::android.widget.TextView[2]
${Android_EN_Investment_Policy_List}    xpath=(//android.widget.TextView[@text="Current investment"])