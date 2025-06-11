*** Variables ***
${iOS_EN_TaxDeducationBanner}           chain=**/XCUIElementTypeOther[`label BEGINSWITH 'The tax season has started'`]
${iOS_EN_TaxDeducationPage}       chain=**/XCUIElementTypeOther[`label BEGINSWITH 'Provide your consent on tax deductions'`]
${iOS_EN_TaxDeducationViewOrDownload}    chain=**/XCUIElementTypeOther[`label BEGINSWITH 'View or download your tax certificate'`]
${iOS_EN_HelpUsProvideInfoQuickLink}        accessibility_id=banner-pressable-ChangeProfile
${iOS_EN_HealthBeginsWithYouQuickLink}        chain=**/XCUIElementTypeStaticText[`label BEGINSWITH 'The Journey to Health begins with You'`]
${iOS_EN_HealthBeginsWithYouQuickLink_LetsStart}        chain=**/XCUIElementTypeOther[`label BEGINSWITH 'Let’s start now!'`]

${iOS_EN_GeolocatorLink}        accessibility_id=banner-pressable-HospitalLocator
${iOS_EN_CountineWithoutSharing}            chain=**/XCUIElementTypeButton[`label BEGINSWITH 'Continue without sharing location'`]
${Android_EN_CountineWithoutSharing}        android=new UiSelector().text("Continue without sharing location")

${Android_EN_TaxDeducationBanner}           xpath=//android.widget.TextView[@text="The tax season has started!"]
${Android_EN_TaxDeducationPage}                  xpath=//android.widget.TextView[@text="Provide your consent on tax deductions for insurance premiums"]
${Android_EN_TaxDeducationViewOrDownload}    xpath=//android.widget.TextView[@text="Provide your consent on tax deductions for insurance premiums"]

${Android_EN_HelpUsProvideInfoQuickLink}        id=banner-pressable-ChangeProfile
${Android_EN_HealthBeginsWithYouQuickLink}              xpath=(//android.widget.TextView[@text='The Journey to Health begins with You'])
${Android_EN_HealthBeginsWithYouQuickLink_LetsStart}              xpath=(//android.widget.TextView[@text='The Journey to Health begins with You']/following-sibling::android.view.ViewGroup/android.view.ViewGroup)
${Android_EN_HelpUsProvideInfoQuickLink}        xpath=//android.view.ViewGroup[@resource-id="banner-content-HospitalLocator"]
${Android_EN_Alowthistimeonly}                          id=com.android.permissioncontroller:id/permission_allow_one_time_button
