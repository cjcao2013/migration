*** Variables ***
# *********************** Sign Up    ***************************************
${Android_EN_Sign_in_here}                          xpath=//android.widget.TextView[contains(@text,"Sign in here")]
${Android_EN_Mobile_Number}                         xpath=(//android.view.ViewGroup//android.widget.EditText)[1]
${Android_EN_Enter_Name}                            xpath=(//android.widget.TextView[contains(@text,'Name')]/../..//android.widget.EditText)[2]
${Android_EN_Acknowledgement_chkbox}                xpath=//android.widget.CheckBox[@class='android.widget.CheckBox']

${Android_EN_SignUp_CreateAnAccountText}            android=new UiSelector().textContains("Create an account")
${Android_EN_SignUp_LetsGetStartedText}             android=new UiSelector().textContains("Let’s get started!")
# ${Android_EN_SignUp_AlreadyHaveAnAccountText}    android=new UiSelector().textContains("Already have an account?")
${Android_EN_SignUp_AlreadyHaveAnAccountText}       xpath=//android.widget.TextView[contains(@text,'Already have an account?')]

${Android_EN_SignUpGenderOption}                    xpath=//android.widget.TextView[contains(@text,'Select')]
${Android_EN_SignUpGenderList}                      xpath=//android.widget.ScrollView/android.view.ViewGroup/android.view.ViewGroup
${Android_EN_SignUp_ReferralCode}                   xpath=//android.widget.TextView[contains(@text,'Referral code')]
${Android_EN_SignUp_AllSet_Privacy_Txt}             xpath=//android.widget.TextView[contains(@text,'We care about your privacy')]
${Android_EN_AllSet_Btn}                            xpath=//android.widget.TextView[@text='All set!']
${Android_EN_HomePageLoad}                          android=new UiSelector().textContains("Hey")
${Android_EN_insuranceButton}                       android=new UiSelector().textContains("Insurance")
${Android_EN_Where_did_you_buy_this_plan_Txt}       xpath=//android.widget.TextView[contains(@text,'Where did you buy this plan?')]
${Android_EN_CountryCode_dropdown}                  xpath=(//android.widget.TextView[contains(@text,'Mobile number')]/../..//android.view.ViewGroup)[8]
${Android_EN_adervertisepopupclose}                 android=new UiSelector().textContains("Close")
${Android_EN_PopoUpFrame}                           xpath=//android.widget.FrameLayout[@resource-id='android:id/content']
${Android_EN_AllowBtn}                              xpath=//android.widget.Button[@text='Allow']
${Android_EN_Allow}                                 xpath=//android.widget.Button[@text='Allow']
${Android_EN_CloseBtn}                              xpath=//android.widget.TextView[@text='Close']
#com.android.permissioncontroller:id/permission_allow_button
# ***************** All the Language options ***************************
${Android_EN_Language}                              xpath=//android.widget.TextView[@text='EN']
${Android_EN_Lang_Vietanam}                         xpath=//android.widget.TextView[@text='VN | Vietnamese']
${Android_EN_Lang_Chinese_MainChina}                xpath=//android.widget.TextView[@text='CN | Chinese (Mainland China)']
${Android_EN_Lang_Chinese_Hong Kong}                xpath=//android.widget.TextView[@text='HK | Chinese (Hong Kong)']
${Android_EN_Lang_English}                          xpath=//android.widget.TextView[@text='EN | English']
${Android_EN_Lang_Japanese}                         xpath=//android.widget.TextView[@text='JA | Japanese']
${Android_EN_Lang_Thai}                             xpath=//android.widget.TextView[@text='TH | Thai']
${Android_EN_Lang_Khmer}                            xpath=//android.widget.TextView[@text='KM | Khmer']
${Android_EN_Lang_Indonesian}                       xpath=//android.widget.TextView[@text='ID | Indonesian']
# ****************************************************************************
${Android_ENLogin_Mobile_Number}                    xpath=//android.widget.EditText[@index='1']

# *********************** Sign here    ***************************************
${Android_EN_email_option}                          android=new UiSelector().textContains("Email")
${Android_EN_mobile_option}                         android=new UiSelector().textContains("Mobile number")

${Android_EN_Enter_email}                           xpath=(//android.widget.TextView[contains(@text,'Email')]/../..//android.widget.EditText)[1]
${Android_EN_Enter_MobileNo}                        xpath=(//android.widget.TextView[contains(@text,'Mobile number')]/../..//android.widget.EditText)[1]
${Android_EN_MobileISDCode}                         xpath=(((//android.widget.TextView[contains(@text,'Mobile number')])[2])/../..//android.widget.TextView)[5]
${Android_EN_NextButton}                            android=new UiSelector().textContains("Next")
${Android_EN_Otp_Entry}                             xpath=//android.widget.EditText[@index='2']
${Android_EN_Verify_Button}                         xpath=//android.widget.TextView[@text='Verify']
${Android_EN_Verify}                                xpath=//android.widget.TextView[@text='Verify']
${Android_EN_Home_page}                             xpath=//android.widget.TextView[@text='Focus']

${Android_EN_DD_dropdown}                           xpath=//android.view.ViewGroup[@content-desc="DD"]/android.view.ViewGroup
# android=new UiSelector().textContains("DD").instance(1)
${Android_EN_MMM_dropdown}                          android=new UiSelector().textContains("MMM")
${Android_EN_YYYY_dropdown}                         android=new UiSelector().textContains("YYYY")
${Android_EN_Country}                               xpath=//android.widget.TextView[@text='Country']
${Android_EN_Document_Type}                         xpath=//android.widget.TextView[@text='Document type']
# ${Android_EN_Document_Number}    xpath=//android.widget.TextView[@text='Document number']
${Android_EN_Document_Number}                       xpath=//android.widget.TextView[@text='Document number']//preceding::android.widget.EditText[1]
${Android_EN_InvaildNumberError}                    xpath=//android.widget.TextView[@text="Invalid document number"]
${Android_EN_IncorrectDataValidationMsg}            android=new UiSelector().textContains("We are unable to find your information")


${Android_EN_Verify_btn}                            android=new UiSelector().textContains("Verify")
${Android_EN_Document_ID}                           xpath=//android.widget.TextView[@text='Customer ID']/..//android.widget.EditText
${Android_EN_Customer_ID}                           xpath=//android.widget.TextView[@text='Customer ID']/..//android.widget.EditText

${Android_EN_AddBdy}                                xpath=//android.widget.TextView[@text='Add your birthday']

${Android_EN_SignIn_WelomebackText}                 xpath=//android.widget.TextView[@text='Welcome back!']
${Android_EN_SignIn_DontHaveText}                   android=new UiSelector().textContains("Don't have an ")
${Android_EN_Sign_IN_Text}                          android=new UiSelector().textContains("Sign In")

# ************************************ Error Message ******************************************
${Android_EN_Error_MSg_Invalid_emailMObile}         xpath=//android.widget.TextView[@text='Mobile number/Email not found']
${Android_EN_Error_MSg_Invalid_Email}               xpath=//android.widget.TextView[@text='Please enter a valid email']
${Android_EN_Error_MSg_Invalid_Mobile}               xpath=//android.widget.TextView[@text='Please enter a valid mobile number']
${Android_EN_Error_MSg_Invalid_Name}                xpath=//android.widget.TextView[@text='Name must have 5 or more characters']
${Android_EN_Error_Invalid_Document_No}             xpath=//android.widget.TextView[@text='Invalid document number']
# ${Android_EN_Whoops_Invalid_Information_Txt}    xpath=//android.widget.TextView[contains(@text,'Whoops! we are unable to find your information')]
${Android_EN_Error_Account_Already_Exist}           xpath=//android.widget.TextView[@text='Seems like you have an account with us. Please sign in to continue.']
${Android_EN_Whoops_Invalid_Information_Txt}        android=new UiSelector().textContains("Whoops!")
${Android_EN_Invalid_Info}                          android=new UiSelector().textContains("We are unable to find your information")

${Android_EN_Eror_Msg_Wrong_Otp}                    xpath=//android.widget.TextView[@text='OTP is invalid']
${Android_EN_Code_Expire}                           xpath=//android.widget.TextView[@text='Code expired']
${Android_EN_OTP_Expire}                            xpath=//android.widget.TextView[@text='Tap to resend.']

${Android_EN_InspireBtn}                            xpath=(//android.widget.TextView[@text='Inspire Me'])[2]
${Android_EN_Profile_Icon_btn}                      xpath=(//android.view.ViewGroup[@resource-id='profile-icon-btn'])[1]
#${Android_EN_Profile_Mail                           (//android.widget.ScrollView/android.view.ViewGroup/android.view.ViewGroup/android.widget.TextView)[2]
${Android_EN_Logout_btn}                            xpath=//android.widget.TextView[@text='Log out']
#xpath=(//android.widget.TextView[@text='My Account']/../android.view.ViewGroup)[2]
${Android_EN_Confirm_btn}                           xpath=//android.widget.TextView[@text='Confirm']
${Android_EN_SettingIcon}                           xpath=(//android.widget.Button[@resource-id='back-button']//following-sibling::android.widget.Button)[1]

${Android_EN_InputOtp1}                             xpath=(//android.widget.EditText[@class='android.widget.EditText'])[1]
${Android_EN_InputOtp2}                             xpath=(//android.widget.EditText[@class='android.widget.EditText'])[2]
${Android_EN_InputOtp3}                             xpath=(//android.widget.EditText[@class='android.widget.EditText'])[3]
${Android_EN_InputOtp4}                             xpath=(//android.widget.EditText[@class='android.widget.EditText'])[4]
${Android_EN_InputOtp5}                             xpath=(//android.widget.EditText[@class='android.widget.EditText'])[5]
${Android_EN_InputOtp6}                             xpath=(//android.widget.EditText[@class='android.widget.EditText'])[6]

${Android_EN_Profile_Name}                          xpath=((//android.widget.ScrollView/android.view.ViewGroup/android.view.ViewGroup)[1]/android.widget.TextView)[1]
${Android_EN_Profile_Mail}                          android=new UiSelector().textContains(".com")
#xpath=((//android.widget.ScrollView/android.view.ViewGroup/android.view.ViewGroup)[1]/android.widget.TextView)[2]
${Android_EN_Profile_Gender}                          xpath=//android.widget.TextView[@text='Gender']/preceding-sibling::android.widget.TextView
${Android_EN_Profile_DOB}                          xpath=//android.widget.TextView[@text='DOB']/preceding-sibling::android.widget.TextView

${Android_EN_BackButton_Arrow}                  xpath=(//android.widget.Button[@resource-id ='back-button'])

${iOS_EN_Allow}                                 accessibility_id=Allow
${iOS_EN_Sign_in_here}                          chain=**/XCUIElementTypeStaticText[`label == "Already have an account? Sign in here"`]
${iOS_EN_SignIn_WelomebackText}                 chain=**/XCUIElementTypeStaticText[`label CONTAINS 'Welcome back'`]
${iOS_EN_SignIn_DontHaveText}                   chain=**/XCUIElementTypeStaticText[`label CONTAINS 'have an account yet?'`]
${iOS_EN_email_option}                          chain=**/XCUIElementTypeOther[`label == 'Email'`]
${iOS_EN_Enter_email}                           chain=**/XCUIElementTypeTextField
${iOS_EN_Enter_Name}                            chain=**/XCUIElementTypeOther[`label == "Name"`][2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_Error_MSg_Invalid_emailMObile}         chain=**/XCUIElementTypeStaticText[`label CONTAINS 'Mobile number/Email not found'`]
${iOS_EN_Error_MSg_Invalid_Email}               chain=**/XCUIElementTypeStaticText[`label CONTAINS 'Please enter a valid email'`]
${iOS_EN_Error_MSg_Invalid_Name}                chain=**/XCUIElementTypeStaticText[`label CONTAINS "Name must have"`]
${iOS_EN_Error_MSg_Invalid_Mobile}              chain=**/XCUIElementTypeStaticText[`label CONTAINS 'Please enter a valid mobile number'`]
${iOS_EN_Error_Invalid_Document_No}             chain=**/XCUIElementTypeStaticText[`label CONTAINS 'Invalid document number'`]
${iOS_EN_Enter_MobileNo}                        chain=**/XCUIElementTypeOther[`label CONTAINS "Mobile number"`][-1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeTextField
${iOS_EN_Language}                              xpath=(((//XCUIElementTypeStaticText)[1]/ancestor::XCUIElementTypeOther)[last()-4]/XCUIElementTypeOther/XCUIElementTypeOther[2])[1]
${iOS_EN_DD_dropdown}                           chain=**/XCUIElementTypeOther[`label == 'DD'`]
${iOS_EN_Sign_IN_Text}                          chain=**/XCUIElementTypeStaticText[`label == "Sign In"`]
${iOS_EN_mobile_option}                         chain=**/XCUIElementTypeOther[`label == 'Mobile number'`]
${iOS_EN_MobileISDCode}                         chain=**/XCUIElementTypeOther[`label BEGINSWITH "+"`][-1]
${iOS_EN_SignUp_CreateAnAccountText}            chain=**/XCUIElementTypeOther[`label BEGINSWITH "Create an account"`][-1]
${iOS_EN_Country}                               chain=**/XCUIElementTypeOther[`label == "Country"`][2]
${iOS_EN_Document_Type}                         chain=**/XCUIElementTypeOther[`label == "Document type"`][-1]
${iOS_EN_Document_Number}                       chain=**/XCUIElementTypeOther[`name == "Document number"`][2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_InvaildNumberError}                        chain=**/XCUIElementTypeStaticText[`label == "Invalid document number"`]
${iOS_EN_IncorrectDataValidationMsg}            chain=**/XCUIElementTypeStaticText[`label CONTAINS "We are unable to find your information"`][-1]
${iOS_EN_MMM_dropdown}                chain=**/XCUIElementTypeOther[`label == 'MMM'`]
${iOS_EN_YYYY_dropdown}                 chain=**/XCUIElementTypeOther[`label == 'YYYY'`]
${iOS_EN_AllSet_Btn}                   chain=**/XCUIElementTypeButton[`label CONTAINS 'All set'`]
${iOS_EN_HomeButton}                   chain=**/XCUIElementTypeButton[`label == 'Home'`]
${iOS_EN_adervertisepopupclose}         chain=**/XCUIElementTypeButton[`label == 'Close'`]
${iOS_EN_Verify_btn}                     chain=**/XCUIElementTypeButton[`label == 'Verify'`]
${iOS_EN_Customer_ID}               chain=**/XCUIElementTypeOther[`label == "Customer ID"`][-1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${iOS_EN_insuranceButton}           chain=**/XCUIElementTypeButton[`label == 'Insurance'`]
${iOS_EN_Profile_Icon_btn}          accessibility_id=profile-icon-btn
${iOS_EN_SettingIcon}               chain=**/XCUIElementTypeOther[`label == "Profile"`][3]/XCUIElementTypeOther[3]/XCUIElementTypeOther/XCUIElementTypeButton[1]
${iOS_EN_Profile_Mail}              accessibility_id=user.contact_info
${iOS_EN_AccountBackButton_Arrow}            accessibility_id=back-button
${iOS_EN_Logout_btn}            accessibility_id=log_out.icon
${iOS_EN_Confirm_btn}           accessibility_id=Confirm

${iOS_EN_would_you_like}                    accessibility_id=What would you like to do on Omne?
${Android_EN_would_you_like}                android=new UiSelector().text("What would you like to do on Omne?")
${iOS_EN_MangeYourInsurance}                chain=**/XCUIElementTypeOther[`label == "Manage Your Insurance"`][2]
${Android_EN_MangeYourInsurance}            android=new UiSelector().text("Manage Your Insurance")
${iOS_EN_Option_Get_Filter}                 chain=**/XCUIElementTypeOther[`label == "Get Fitter"`][2]
${Android_EN_Option_Get_Filter}             android=new UiSelector().text("Get Fitter")
${iOS_EN_Option_Sleep_Better}               chain=**/XCUIElementTypeOther[`label == "Sleep Better"`][2]
${Android_EN_Option_Sleep_Better}           android=new UiSelector().text("Sleep Better")
${iOS_EN_Ok_button_popupPage}               chain=**/XCUIElementTypeButton[`label == "OK"`]
${Android_EN_Ok_button_popupPage}           android=new UiSelector().description("OK")