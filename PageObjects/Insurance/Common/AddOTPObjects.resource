*** Variables ***
${Android_EN_InputOtp1}             xpath=(//android.widget.EditText[@class='android.widget.EditText'])[1]
${Android_EN_InputOtp2}             xpath=(//android.widget.EditText[@class='android.widget.EditText'])[2]
${Android_EN_InputOtp3}             xpath=(//android.widget.EditText[@class='android.widget.EditText'])[3]
${Android_EN_InputOtp4}             xpath=(//android.widget.EditText[@class='android.widget.EditText'])[4]
${Android_EN_InputOtp5}             xpath=(//android.widget.EditText[@class='android.widget.EditText'])[5]
${Android_EN_InputOtp6}             xpath=(//android.widget.EditText[@class='android.widget.EditText'])[6]
${Android_EN_OTP_TapResend}            xpath=//android.widget.TextView[@text='Tap to resend.']
${Android_EN_Code_Expired}            xpath=//android.widget.TextView[@text='Code expired']
${Android_EN_OTP_email}             xpath=(//android.widget.TextView[contains(@text,'We sent you a code')]/following-sibling::android.widget.TextView)[1]
${Android_EN_Eror_Msg_Wrong_Otp}    xpath=//android.widget.TextView[@text='OTP is invalid']
${Android_EN_OTP_Expire}            xpath=//android.widget.TextView[@text='Tap to resend.']
${Android_EN_Verify_btn}            xpath=(//android.widget.TextView[@text='Verify'])
${Android_EN_OTP_email}             xpath=(//android.widget.TextView[contains(@text,'We sent you a code')]/following-sibling::android.widget.TextView)[1]
${Android_EN_OTP_Mobile}             xpath=(//android.widget.TextView[contains(@text,'Let’s verify your phone first')]/following-sibling::android.widget.TextView)[1]

#--IOS objects---#
${iOS_EN_InputOtp1}                 chain=**/XCUIElementTypeTextField[`label == "otpInput-0"`]
${iOS_EN_InputOtp2}                 chain=**/XCUIElementTypeTextField[`label == "otpInput-1"`]
${iOS_EN_InputOtp3}                 chain=**/XCUIElementTypeTextField[`label == "otpInput-2"`]
${iOS_EN_InputOtp4}                 chain=**/XCUIElementTypeTextField[`label == "otpInput-3"`]
${iOS_EN_InputOtp5}                 chain=**/XCUIElementTypeTextField[`label == "otpInput-4"`]
${iOS_EN_InputOtp6}                 chain=**/XCUIElementTypeTextField[`label == "otpInput-5"`]
${iOS_EN_InputOtp7}                 chain=**/XCUIElementTypeTextField[7]
${iOS_EN_OTP_email}                 chain=**/XCUIElementTypeOther[`label CONTAINS 'We sent you a code'`][-1]/XCUIElementTypeStaticText[2]
#${EN_OTP_Expire}                            xpath=//android.widget.TextView[@text='Tap to resend.']

#${iOS_EN_DB_OTP_Input1}     xpath=(//XCUIElementTypeButton[contains(@name,"Didn't")]/preceding::XCUIElementTypeOther)[last()-5]/XCUIElementTypeTextField
#${iOS_EN_DB_OTP_Input2}     xpath=(//XCUIElementTypeButton[contains(@name,"Didn't")]/preceding::XCUIElementTypeOther)[last()-4]/XCUIElementTypeTextField
#${iOS_EN_DB_OTP_Input3}     xpath=(//XCUIElementTypeButton[contains(@name,"Didn't")]/preceding::XCUIElementTypeOther)[last()-3]/XCUIElementTypeTextField
#${iOS_EN_DB_OTP_Input4}     xpath=(//XCUIElementTypeButton[contains(@name,"Didn't")]/preceding::XCUIElementTypeOther)[last()-2]/XCUIElementTypeTextField
#${iOS_EN_DB_OTP_Input5}     xpath=(//XCUIElementTypeButton[contains(@name,"Didn't")]/preceding::XCUIElementTypeOther)[last()-1]/XCUIElementTypeTextField
#${iOS_EN_DB_OTP_Input6}     xpath=(//XCUIElementTypeButton[contains(@name,"Didn't")]/preceding::XCUIElementTypeOther)[last()]/XCUIElementTypeTextField

${iOS_EN_DB_OTP_Input1}     xpath=(//XCUIElementTypeTextField)[1]
${iOS_EN_DB_OTP_Input2}     xpath=(//XCUIElementTypeTextField)[2]
${iOS_EN_DB_OTP_Input3}     xpath=(//XCUIElementTypeTextField)[3]
${iOS_EN_DB_OTP_Input4}     xpath=(//XCUIElementTypeTextField)[4]
${iOS_EN_DB_OTP_Input5}     xpath=(//XCUIElementTypeTextField)[5]
${iOS_EN_DB_OTP_Input6}     xpath=(//XCUIElementTypeTextField)[6]

${iOS_EN_Code_Expired}            chain=**/XCUIElementTypeStaticText[`label CONTAINS 'Code expired'`]
${iOS_EN_InputOTPField}         chain=**/XCUIElementTypeOther[`label == "000000"`][-1]
${Android_EN_InputOTPField}      xpath=//android.widget.EditText[@text='000000']