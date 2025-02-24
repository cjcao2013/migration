*** Variables ***
${iOS_EN_Email_Mobile_Txt}                              chain=**/XCUIElementTypeOther[`label == "Email and/or mobile"`]
# update email or mobile
${iOS_EN_Update_Personal_Details_Txt}                   chain=**/XCUIElementTypeStaticText[`label == 'Update personal details'`]
${iOS_EN_updatemobilefield}                             chain=**/XCUIElementTypeTextField[`name == "mobile-field-input"`]
${iOS_EN_updateemailfield}                              chain=**/XCUIElementTypeTextField[`name == "email-field-input"`]
${iOS_EN_btnSave}                                       chain=**/XCUIElementTypeButton[`label == 'Save'`]
${iOS_EN_btnSave}                                       chain=**/XCUIElementTypeButton[`label == 'Save'`]
${iOS_EN_countryCode}                                   chain=**/XCUIElementTypeOther[`name == "select-country-pressable"`]
${iOS_EN_countryCodeHK}                                 xpath=//XCUIElementTypeOther[@name="select-country-HKG"]



${Android_EN_Update_Personal_Details_Txt}               xpath=//android.widget.TextView[@text='Update personal details']