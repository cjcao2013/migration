*** Variables ***
${iOS_EN_NewMailingPreference_Text}         xpath=//XCUIElementTypeStaticText[contains(@label,'New mailing preference')]/following-sibling::XCUIElementTypeStaticText
${Android_ENNewMailingPreference_Text}         xpath=//android.widget.TextView[@text="New mailing preference:"]/following-sibling::android.widget.TextView

${iOS_EN_NewMailing_Mobile_Text}           xpath=//XCUIElementTypeStaticText[contains(@label,'Mobile no')]/following-sibling::XCUIElementTypeStaticText
${Android_EN_NewMailing_Mobile_Text}      xpath=//android.widget.TextView[contains(@text,"Mobile no")]/following-sibling::android.widget.TextView

${iOS_EN_NewMailing_Email_Text}          xpath=//XCUIElementTypeStaticText[contains(@label,'Email')]/following-sibling::XCUIElementTypeStaticText
${Android_EN_NewMailing_Email_Text}    xpath=//android.widget.TextView[contains(@text,"Email")]/following-sibling::android.widget.TextView

${iOS_EN_NewMailing_Post_Text}           xpath=//XCUIElementTypeStaticText[contains(@label,'Mailing address')]/following-sibling::XCUIElementTypeStaticText
${Android_EN_NewMailing_Post_Text}       xpath=//android.widget.TextView[contains(@text,"Mailing address")]/following-sibling::android.widget.TextView


${iOS_EN_NewMailingEmailDetails_Text}           xpath=//XCUIElementTypeStaticText[contains(@label,'Email')]/following-sibling::XCUIElementTypeStaticText
${Android_EN_NewMailingEmailDetails_Text}       xpath=

${iOS_EN_PolicyDeatils}                 xpath=//XCUIElementTypeStaticText[contains(@label,'Policy(s) applied')]/following-sibling::XCUIElementTypeOther
${Android_EN_Policy_Details}        xpath=

${iOS_EN_Current_Mailing_Email}         xpath=//XCUIElementTypeStaticText[contains(@label,'Email')][last()]
${Android_EN_Current_Mailing_Email}         xpath=//android.widget.TextView[contains(@text,"Email")][last()]

${iOS_EN_Current_MailingPreference}        xpath=//XCUIElementTypeStaticText[contains(@label,'Current preference:')][last()]
${Android_EN_Current_MailingPreference}         xpath=//android.widget.TextView[contains(@text,"Current preference:")]

${iOS_EN_Current_Mailing_Mobile_number}         xpath=//XCUIElementTypeStaticText[contains(@label,'Mobile no')][last()]
${Android_EN_Current_Mailing_Mobile_number}         xpath=//XCUIElementTypeStaticText[contains(@label,'Mobile no')][last()]

${iOS_EN_Current_Mailing_Address}               xpath=//XCUIElementTypeStaticText[contains(@label,'Mailing address')][last()]/following-sibling::XCUIElementTypeStaticText
${Android_EN_Current_Mailing_Address}           xpath=//android.widget.TextView[contains(@text,"Mailing address:")]/following-sibling::android.widget.TextView

${Android_EN_ChangeMailingPreferenceTransactionStatus}      xpath=(//android.widget.TextView[contains(@text,'Change mailing preference')]/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]
${Android_EN_TransactionNewMailingPreference}               xpath=(//android.widget.TextView[contains(@text,'New mailing preference:')]/following-sibling::android.widget.TextView)[1]
${Android_EN_TransactionPolicyNumber}               xpath=(//android.widget.TextView[contains(@text,'Policy applied')]/following-sibling::android.view.ViewGroup/android.widget.TextView)[2]