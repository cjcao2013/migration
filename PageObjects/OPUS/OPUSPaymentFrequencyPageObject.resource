*** Variables ***
${EN_currentPaymentFrequency}              xpath=//div[@id='billingFrequency']/div/div/div[1]
${EN_NewPaymentFrequency}         xpath=//input[@id='nextPremiumAmount']
${EN_NewModalPremiumAmt}               xpath=//span[text()='Premium Amount']/following::input
#${EN_CurrentModalPremium}           xpath=(//span[text()='Current Modal Premium']//ancestor::div)[last()]//following-sibling::div//div[1]
#${EN_frequencyfactaStatus}          xpath=(//div[@id='fATCAStatus']//div/div/div)[1]
${EN_paymentfrequencyPolicyNo}             xpath=(//input[@id='policyNo'])    # Get title attribute
#${EN_frequencyProductName}          xpath=//input[@id='productName']    # Get title attribute
#${EN_viewAllImages}                 xpath=//span[text()='View all images']/parent::button    # view total imges need to switch to new window
#${EN_totDocumentCount}              xpath=//div[@class='react-app-pages-document-styles-documentList']/div
${EN_frequencyStatus}       xpath=//div[@id='decision']/div/div/div[1]
