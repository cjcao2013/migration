*** Variables ***
${EN_PolicyCashValue}                   xpath=//div[@data-id='policyCashValue']/div/span/div/div/div[2]/input    # getvalue
${EN_Loan_LimitofToday}                 xpath=//div[@data-id='loanLimit']/div/span/div/div/div[2]/input    # getvalue
${EN_LoanOutstanding}                   xpath=//div[@data-id='loanOutstanding']/div/span/div/div/div[2]/input    # getvalue
${EN_Total_Loan}                        xpath=//div[@data-id='totalLoanAsOfToday']/div/span/div/div/div[2]/input    # getvalue
${EN_PayableAmount}                     xpath=//input[@id='payableAmount']    # get title
${EN_LoanRequestAmount}                 xpath=//div[@data-id='loanRequestAmount']/div/span/div/div/div[2]/input    # getvalue
${EN_BankNamePolicyLoan}                xpath=(//input[@id='bankCode'])[last()]  # get title
${EN_BankAccountNumberPolicyLoan}       xpath=(//input[@id='bankAccountNo'][last()])   # get title
${EN_CompletionDate}                    xpath=//input[@id='endTime']    # get title
${EN_BankHolderNamePolicyLoan}          xpath=(//input[@id='bankAccountName'])[last()]
${EN_ApprovalStatusPolicyLoan}          xpath=//div[@id='businessDecision']/div/div/div[2]
${EN_Policy_Interest_Rate}              xpath=//div[@data-id='loanInterestRate']/div/span/div/div/div[2]/input
${EN_BO_Status}                         xpath=(//div[text()='Response Detail']/following::div)[3]
${EN_PaymentMethod}                     xpath=//input[@id='paymentMethod']