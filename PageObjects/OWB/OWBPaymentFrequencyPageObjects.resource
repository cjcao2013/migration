*** Variables ***
${EN_currentFrequency}              xpath=//div[@id='currentPaymentMode']/div/div/div
${EN_New_Payment_Frequency}         xpath=//div[@id='nextPaymentMode']//div//div//div[1]
${EN_NewModalPremium}               xpath=(//span[text()='New Modal Premium']//ancestor::div)[last()]//following-sibling::div//div[1]
${EN_CurrentModalPremium}           xpath=(//span[text()='Current Modal Premium']//ancestor::div)[last()]//following-sibling::div//div[1]
${EN_frequencyfactaStatus}          xpath=(//div[@id='fATCAStatus']//div/div/div)[1]
${EN_frequencyPolicyNo}             xpath=(//input[@id='policyNo'])[2]    # Get title attribute
${EN_frequencyProductName}          xpath=//input[@id='productName']    # Get title attribute
${EN_viewAllImages}                 xpath=//span[text()='View all images']/parent::button    # view total imges need to switch to new window
${EN_totDocumentCount}              xpath=//div[@class='react-app-pages-document-styles-documentList']/div
${EN_frequencyApprovalStatus}       xpath=//div[@id='businessDecision']/div/div/div[2]
