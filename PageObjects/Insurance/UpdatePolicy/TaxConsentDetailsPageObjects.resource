*** Variables ***
${iOS_EN_TaxConsent_HeaderText}                 chain=**/XCUIElementTypeStaticText[`label CONTAINS "Exercise tax deduction for insurance premiums"`]
${iOS_EN_TaxConsent_SubHeaderText}              chain=**/XCUIElementTypeStaticText[`label == "Please select your wish to use the tax benefits rights for your insurance policy(s)"`]
${iOS_EN_TaxConsent_YesOption}                  chain=**/XCUIElementTypeOther[`label BEGINSWITH "I give consent to FWD"`]
${iOS_EN_TaxConsent_NoOption}                   chain=**/XCUIElementTypeOther[`label BEGINSWITH "I do not give consent to FWD"`]
${iOS_EN_TaxConsent_SubmitButton}               chain=**/XCUIElementTypeButton[`label == "Submit"`]
${iOS_EN_TaxConsent_QuestionSymbol}             chain=**/XCUIElementTypeOther[`label == "Tax consent"`]/XCUIElementTypeOther
${iOS_EN_TaxConsent_Note}                       chain=**/XCUIElementTypeStaticText[`label == "Note"`]
${iOS_EN_TaxConsent_NextButton}                 chain=**/XCUIElementTypeButton[`name == "taxConsent-submit-button"`]
${iOS_EN_TaxConsent_Transaction}                chain=**/XCUIElementTypeOther[`label CONTAINS "Option selected"`][27]
${iOS_EN_TaxConsent_proceedBtn}                 chain=**/XCUIElementTypeOther[`name == "Proceed"`]

${Android_EN_TaxConsent_HeaderText}             xpath=//android.widget.TextView[@text='Tax consent']
${Android_EN_TaxConsent_SubHeaderText}          xpath=//android.widget.TextView[@text='Please select your wish to use the tax benefits rights for your insurance policy(s)']
${Android_EN_TaxConsent_YesOption}              xpath=(//android.widget.TextView[@text='Yes']/preceding-sibling::android.view.ViewGroup)[2]
${Android_EN_TaxConsent_NoOption}               xpath=(//android.widget.TextView[@text='No']/preceding-sibling::android.view.ViewGroup[1])
${Android_EN_TCPolicy_Names_List}               xpath=//android.widget.TextView[contains(@text,'Yes')]/following::android.widget.TextView
${Android_EN_TaxConsent_QuestionSymbol}         xpath=//android.widget.TextView[@text='Tax consent']/following-sibling::android.view.ViewGroup
${Android_EN_TaxConsent_Note}                   xpath=//android.widget.TextView[@text='Note']
# ${Android_EN_Note}    xpath=//android.widget.TextView[@text='Note']
${Android_EN_TC_SubmitButton}                   xpath=//android.widget.Button
${Android_EN_TaxConsent_SubmitButton}           xpath=//android.widget.TextView[@text='Submit']
${Android_EN_verifyOtp}                         xpath=//android.widget.TextView[@text='Verify']
${Android_EN_TransactionTCTab}                  android=new UiSelector().textContains("View transactions")
${Android_EN_ServiceReuest}                     android=new UiSelector().textContains("Service request(s)")

# ------------------------ Transaction --------------------------------------------
${Android_EN_TransactionStatusTaxConsent}       xpath=(//android.widget.TextView[contains(@text,'Tax consent')]/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]
${Android_EN_TaxConsent_Options}                xpath=//android.widget.TextView[@text='Option selected']/following-sibling::android.widget.TextView
${Android_EN_TSTaxConsent_Policyname}           xpath=(//android.widget.TextView[@text='Policy applied']/following-sibling::android.widget.TextView)[1]
${Android_EN_TSTaxConsent_PolicyNumber}         xpath=(//android.widget.TextView[@text='Policy applied']/following-sibling::android.widget.TextView)[2]
${Android_EN_TSTaxConsent_Completiondate}       xpath=//android.widget.TextView[@text='Completion date']/following-sibling::android.widget.TextView
