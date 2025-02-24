*** Variables ***
# Email Mobile OWB Objects
${EN_VP_old_Email_id}           xpath=(//input[@id='email'])[1]
${EN_VP_New_Email_id}           xpath=(//input[@id='email'])[2]
${EN_VP_old_MobileNo}           xpath=(//input[@id='mobile'])[2]
${EN_VP_New_MobileNo}           xpath=(//input[@id='mobile'])[3]

# Change Address
${EN_currentAdd}                xpath=//div[text()='CURRENT ADDRESS']
${EN_Curr_Add}                  xpath=//input[@id='currentAddress']
${EN_OWB_Country}               xpath=//input[@id='countryCode']
${EN_Address_Line1_OWB}         xpath=//input[@id='addressLine1']
${EN_Address_Line2_OWB}         xpath=//input[@id='addressLine2']
${EN_City_OWB}                  xpath=//input[@id='addressLine4']
${EN_ZipCode_OWB}               xpath=//input[@id='zipCode']
${EN_State_OWB}                 xpath=//input[@id='addressLine5']
${EN_District_OWB}              xpath=//input[@id='addressLine3']
${EN_Comp_Date}                 xpath=//input[@id='endTime']
${EN_Policy_no_txt}             id=policyNo
${EN_Policy_Name_txt}           id=productName

# Change Name
${EN_VP_old_Title}              xpath=(//input[@id='newSalutation'])[1]
${EN_VP_old_FirstName}          xpath=(//input[@id='firstName'])[1]
${EN_VP_old_MiddleName}         xpath=(//input[@id='middleName'])[1]
${EN_VP_old_LastName}           xpath=(//input[@id='surname'])[1]
${EN_VP_old_MaritalStatus}      xpath=(//input[@id='maritalStatus'])[1]
${EN_VP_new_Title}              xpath=(//input[@id='newSalutation'])[2]
${EN_VP_new_FirstName}          xpath=(//input[@id='firstName'])[2]
${EN_VP_new_MiddleName}         xpath=(//input[@id='middleName'])[2]
${EN_VP_new_LastName}           xpath=(//input[@id='surname'])[2]
${EN_VP_new_MaritalStatus}      xpath=(//input[@id='maritalStatus'])[2]
${EN_Policy_no_txt}             id=policyNo
${EN_Policy_Name_txt}           id=productName
