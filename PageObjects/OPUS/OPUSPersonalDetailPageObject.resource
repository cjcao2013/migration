*** Variables ***
${EN_NewMobileNumber}           xpath=(//input[@id='phoneNo'])[2]
${EN_NewEmailAddress}           xpath=(//input[@id='email'])[3]
${EN_OPUS_Country}              xpath=//div[@id='countryCode']/div/div/div[1]
${EN_Address_Line1_OPUS}         xpath=//input[@id='addressLine1']
${EN_Address_Line2_OPUS}         xpath=//input[@id='addressLine2']
${EN_District_OPUS}             xpath=//div[@id='addressLine4']/div/div/div[1]
${EN_City_OPUS}                 xpath=//div[@id='addressLine5']/div/div/div[1]
${EN_ZipCode_OPUS}              xpath=//input[@id='zipCode']
${EN_State_OPUS}                 xpath=//div[@id='addressLine3']/div/div/div[1]

${EN_Policy_no_txt}             id=policyNo
${EN_Policy_Name_txt}           id=productName
${EN_Compeletion_Date}                 xpath=(//span[@id='requestDate'])/div/input

${EN_VP_old_Title}              xpath=(//input[@id='newSalutation'])[1]
${EN_VP_old_FirstName}          xpath=(//input[@id='firstName'])[1]
${EN_VP_old_MiddleName}         xpath=(//input[@id='middleName'])[1]
${EN_VP_old_LastName}           xpath=(//input[@id='surname'])[1]
${EN_VP_old_MaritalStatus}      xpath=(//input[@id='maritalStatus'])[1]
${EN_VP_new_Title}              xpath=(//div[@id='title'])
${EN_VP_new_FirstName}          xpath=(//input[@id='firstName'])
${EN_VP_new_MiddleName}         xpath=(//input[@id='middleName'])
${EN_VP_new_LastName}           xpath=(//input[@id='surname'])
${EN_VP_new_MaritalStatus}      xpath=(//div[@id='maritalStatus'])[2]

${EN_TransactionStatus}         xpath=(//div[@id='decision'])/div/div

