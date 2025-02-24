*** Variables ***
${EN_dateOfAccident}            xpath=(//input[@id='accidentDate'])[1]    # get attribute=title
${EN_dateOfVisit}               xpath=(//input[@id='treatmentDate'])[1]    # Get Atributr=title
${EN_medicalProvider}           xpath=(//input[@id='medicalProvider'])[1]    # Get Atributr=title
${EN_diagnosis}                 xpath=(//span[text()='Diagnosis']/following::span/div)[1]    # getText
${EN_treatmentcostcurrency}     xpath=(//input[@id='treatmentCostCurrency'])[1]    # get attreibute=title
${EN_treatmentcost}             xpath=(//input[@id='treatmentCostDetail'])[1]    # get attribute=title
${EN_treatmentlist}             xpath=//span[text()='Treatment List']/following::span[1]/div    # get list of elements available    and then its    get text
${EN_viewAllImages}             xpath=//span[text()='View all images']/parent::button    # view total imges need to switch to new window
${EN_stpfailurereason}          xpath=//div[text()='STP FAILURE REASON(S)']    # check if present or not
${EN_dateOfAddmission}          xpath=(//input[@id='dateOfAdmission'])[1]
${EN_dateOfDischarge}           xpath=(//input[@id='dateOfDischarge'])[1]
${EN_claimApprovalStatus}       xpath=//div[@class='ant-select-selection-selected-value']

# payment details
${EN_paymentmethod}             xpath=(//input[@id='paymentMethod'])[1]    # get atrribute=title
${EN_instantpayment}            xpath=(//input[@id='instantPayment'])[1]    # get attributr=title

# case info details
${EN_acknowledgment}            xpath=(//input[@id='acknowledge'])[1]
${EN_claimWithOtherInsurer}     xpath=(//input[@id='claimWithOtherInsurer'])[1]
${EN_CoreSystemclaimNo}         xpath=(//input[@id='coreSystemClaimNo'])[1]    # value not available curently
${EN_OWB_completiondate}            xpath=(//input[@id='endTime'])[1]
${EN_totDocumentCount}          xpath=//div[@class='react-app-pages-document-styles-documentList']/div
