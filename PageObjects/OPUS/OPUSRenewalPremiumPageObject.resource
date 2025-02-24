*** Variables ***
${EN_OPUS_Payment_Reference_Number}        xpath=//input[@id='paymentRefNo']
${EN_OPUS_Payment_Method}                  xpath=//input[@id='paymentMethod']
#${EN_VP_Payment_Date}                   xpath=//label[@for="paymentDate"]//parent::div//following-sibling::div
${EN_OPUS_Payment_Amount}                  xpath=//input[@id='paymentAmount']
${EN_OPUS_RequestDate}                        xpath=//span[@id='requestDate']/div/input
${EN_OPUS_PaymentStatus}                   xpath=//input[@id='paymentStatus']
${EN_OPUS_Record}                             xpath=//div[contains(@class,'tableRowData tableRowData')]
${EN_OPUS_TransactionStatus}         xpath=(//div[@id='decision'])/div/div
