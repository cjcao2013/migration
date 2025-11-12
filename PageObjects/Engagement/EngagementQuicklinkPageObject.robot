*** Variables ***
${Android_EN_Quicklink_mypolicy}        xpath=//android.view.ViewGroup[@content-desc="My policy(s)"]
${Android_EN_Quicklink_mangepolicy}     xpath=(//android.widget.TextView[contains(@text,"Manage")][1])[2]
${Android_EN_Quicklink_submitClaim}     xpath=//android.widget.TextView[contains(@text,"claim")]


#Engagement_Buy_Insurance
${iOS_EN_Basic_Information}        chain=**/XCUIElementTypeStaticText[`name == "ดูเบี้ยประกันของคุณ"`]
${iOS_EN_Enter_Age}                 xpath=(//XCUIElementTypeStaticText[@name="อายุ"]//parent::XCUIElementTypeOther//following-sibling::XCUIElementTypeTextField)[1]
#${iOS_EN_ScrollToEndImage}		    chain=**/XCUIElementTypeImage[`name == "Image"`]
${iOS_EN_Buy_Online_Button}        chain=**/XCUIElementTypeStaticText[`name == "ซื้อออนไลน์"`]
${iOS_EN_LetUsKnowYouText}         chain=**/XCUIElementTypeStaticText[`name == "ให้เรารู้จักคุณมากขึ้น"`]

${iOS_EN_LeadFormTitle}            chain=**/XCUIElementTypeStaticText[`name == "What kind of insurance coverage would you like to learn more about?"`]

${iOS_EN_selectInsuranceCoverage}		chain=**/XCUIElementTypeOther[`name == "Health"`]
${iOS_EN_InsuranceCoverageCheckbox}		chain=**/XCUIElementTypeOther[`value == "checkbox"`]
${iOS_EN_MoreButon}						chain=**/XCUIElementTypeStaticText[`name == "more"`]
${iOS_EN_InsuranceCoverageSubmitButton}		chain=**/XCUIElementTypeButton[`name == "insurance-leads-submit-btn"`]
${iOS_EN_Continue_with_Omne}			chain=**/XCUIElementTypeButton[`name == "Continue with Omne"`]