*** Variables ***
${Android_EN_Next_Button}                           android=new UiSelector().textContains("Next")
${Android_EN_Withdrawal_Percentage}                 android=new UiSelector().resourceId("spi-input")
${Android_EN_Estimated_Total_Amount}                xpath=//android.widget.TextView[@text="Total estimated withdrawal amount"]/following-sibling::android.view.ViewGroup/android.widget.TextView
${Android_EN_Current_Value}                         xpath=//android.widget.TextView[@text="Current value (PHP)"]/following-sibling::android.widget.TextView
${iOS_EN_Withdrawal_Percentage}                     chain=**/XCUIElementTypeTextField[`name == 'spi-input'`]
${iOS_EN_Estimated_Total_Amount}                    chain=**/XCUIElementTypeOther[`label CONTAINS 'Total estimated withdrawal amount'`][-1]/XCUIElementTypeOther

# Review Your Withdrawal
${Android_EN_Your_Withdrawal_Label}                 android=new UiSelector().textContains("Review your withdrawal")
${Android_EN_Total_Estimated_Withdrawal}            xpath=//android.widget.TextView[@text="Total estimated withdrawal amount"]/following-sibling::android.view.ViewGroup/android.widget.TextView
${iOS_EN_Your_Withdrawal_Label}                     chain=**/XCUIElementTypeStaticText[`label == 'Review your withdrawal'`]
${iOS_EN_Total_Estimated_Withdrawal}                chain=**/XCUIElementTypeOther[`label CONTAINS 'Total estimated withdrawal amount'`][-1]/XCUIElementTypeOther

# Fatca Status
${Android_EN_Fatca_Yes}                             android=new UiSelector().text("Yes")
${Android_EN_Fatca_No}                              android=new UiSelector().text("No")
${Android_EN_terms_checkbox}                        android=new UiSelector().description("fwd-checkbox-terms")
${Android_EN_Thank_you_message}                     android=new UiSelector().textContains("Thanks")
${Android_EN_View_Transactions}                     android=new UiSelector().textContains("View servicing request transactions")

# Transaction
${Android_EN_Partial_Withdrawal}                    android=new UiSelector().text("Partial Withdrawal").instance(0)
${Android_EN_Transaction_Total_Estimated_Amount}    xpath=//android.widget.TextView[@text='Total estimated withdrawal amount']/following-sibling::android.view.ViewGroup//android.widget.TextView
${Android_EN_Transaction_Policy_Status}             xpath=(//android.widget.TextView[@text='Partial Withdrawal']/following-sibling::android.view.ViewGroup/android.widget.TextView)[1]
${Android_EN_Transaction_Policy_No}                 android=new UiSelector().textContains("Policy no")
${Android_EN_Transaction_Bank_No}                   xpath=//android.widget.TextView[@text='Payout method']/following-sibling::android.widget.TextView[1]
${Android_EN_Transaction_Bank_Name}                 xpath=//android.widget.TextView[@text='Payout method']/following-sibling::android.widget.TextView[2]
${Android_EN_Transaction_Fatca_Status}              xpath=//android.widget.TextView[@text='FATCA']/following-sibling::android.widget.TextView[1]
${Android_EN_Transaction_Address}                   xpath=//android.widget.TextView[@text='Address']/following-sibling::android.widget.TextView[1]
${Android_EN_Transaction_US_ID_Passport}            xpath=//android.widget.TextView[@text='U.S. ID/Passport No. or Green card']/following-sibling::android.widget.TextView[1]
${Android_EN_Transaction_US_Tax_ID}                 xpath=//android.widget.TextView[@text='U.S. Tax ID No. /Social Security No.']/following-sibling::android.widget.TextView[1]
${iOS_EN_Transaction_Total_Estimated_Amount}        chain=**/XCUIElementTypeOther[`label CONTAINS 'Total estimated withdrawal amount'`][-1]
# Post Transaction

${Android_EN_PW_addPaymentMethod}                   xpath=//android.widget.TextView[@text='Add payment method']
${iOS_EN_PW_addPaymentMethod}                       chain=**/XCUIElementTypeOther[`label == 'Add payment method'`]
