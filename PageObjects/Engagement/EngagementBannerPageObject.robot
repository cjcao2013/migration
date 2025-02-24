*** Variables ***
${iOS_EN_TaxDeducationBanner}           chain=**/XCUIElementTypeOther[`label BEGINSWITH 'The tax season has started'`]
${iOS_EN_TaxDeducationPage}       chain=**/XCUIElementTypeOther[`label BEGINSWITH 'Provide your consent on tax deductions'`]
${iOS_EN_TaxDeducationViewOrDownload}    chain=**/XCUIElementTypeOther[`label BEGINSWITH 'View or download your tax certificate'`]
${iOS_EN_HelpUsProvideInfoQuickLink}        accessibility_id=banner-pressable-ChangeProfile
${iOS_EN_HealthBeginsWithYouQuickLink}        chain=**/XCUIElementTypeStaticText[`label BEGINSWITH 'The Journey to Health begins with You'`]
${iOS_EN_HealthBeginsWithYouQuickLink_LetsStart}        chain=**/XCUIElementTypeOther[`label BEGINSWITH 'Let’s start now!'`]
${iOS_EN_GeolocatorLink}        accessibility_id=banner-pressable-HospitalLocator
${iOS_EN_CountineWithoutSharing}            chain=**/XCUIElementTypeButton[`label BEGINSWITH 'Continue without sharing location'`]