import mysql.connector

import pandas as pd

import AES

try:
    from robot.libraries.BuiltIn import BuiltIn
    from robot.api.deco import library, keyword

    ROBOT = False

except Exception:
    ROBOT = False


class ViewPolicyDB:

    @keyword("Get Selected Policy Bene Detail from DB")
    def get_DBSelectedPolBeneDet(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, custpolid,
                                 screenshotdir):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        key = b'f057ecb7c8ed51ac'
        # print((policyid))
        # encrypt_policynumber = AES.aes_encrypt(key, policyid)
        # print(encrypt_policynumber)
        # Column header (column name)
        # column_header = "UnitHolding"
        value1 = ""
        lsdf = []
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            query = f" select beneficiaries.Id,customers.FirstName,customers.LastName ,beneficiaries.Ratio,relationships.Name " \
                    f" from beneficiaries " \
                    f" join customers on beneficiaries.BeneficiaryCustomerId = customers.Id " \
                    f" join relationships on beneficiaries.RelationshipId = relationships.Id " \
                    f" and beneficiaries.CustomerPolicyId='" + custpolid + "';"
            print(query)
            df = pd.read_sql(query, conn)
            # print (type(df))
            print(df)
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/Selected_Policy_Beneficiary_details.txt", "a")
            f.write(query)
            f.close()


            # df.to_csv(screenshot + "/Selected_Policy_Beneficiary_details.csv", mode='a')
            # BuiltIn.log(df)
            # Retrieve values based on the column header name
            # values = df[column_header]
            # # Print the retrieved values
            # for value in values:
            #     print(value)
            #     value1 = value
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        # print(value1)
        # return df
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf

    @keyword("Get Selected Policy Rider Detail from DB")
    def get_DBSelectedPolRiderDet(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, custpolid,
                                  screenshotdir):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        key = b'f057ecb7c8ed51ac'
        # print((policyid))
        # encrypt_policynumber = AES.aes_encrypt(key, policyid)
        # print(encrypt_policynumber)
        # Column header (column name)
        # column_header = "UnitHolding"
        value1 = ""
        lsdf = []
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            query = f" SELECT customerPolicies.Id, coverageplans.Description ProductName, " \
                    f" customers.FirstName, customers.LastName, " \
                    f" coverages.SumAssured sumAssured, customerPolicies.CommencementDate commencementDate, " \
                    f" coverages.RiskCessationDate expiryDate, customerPolicies.Premium premiuminstallmentPremium, " \
                    f" customerPolicies.PremiumCurrency premiumCurrency, ridergroups.RiderSeq, " \
                    f" policyStatuses.Enum AS CoverageStatus, MAX(coverages.transactionno) transactionno " \
                    f" FROM customerPolicies JOIN " \
                    f" Coverages ON customerPolicies.Id = Coverages.CustomerPolicyId " \
                    f" JOIN Customers ON Coverages.InsuredCustomerId = Customers.Id " \
                    f" JOIN policyStatuses ON Coverages.PolicyStatusId = policyStatuses.Id " \
                    f" JOIN CoveragePlans ON Coverages.CoveragePlanId = CoveragePlans.Id " \
                    f" JOIN RiderGroups ON Coverages.RiderSeqId = ridergroups.Id	 " \
                    f" join (select customerpolicyid,lifeseq, coverageseq,rg.riderseq,max(transactionno) transactionno from  coverages cov join ridergroups rg on rg.id=cov.riderseqid " \
                    f" where customerpolicyid = '" + custpolid + "'   " \
                    f" group by customerpolicyid,lifeseq, coverageseq,rg.riderseq) maxcov " \
                    f" on  maxcov.lifeseq=Coverages.lifeseq " \
                    f" and maxcov.coverageseq=Coverages.coverageseq " \
                    f" and maxcov.riderseq=ridergroups.riderseq " \
                    f" and maxcov.transactionno=Coverages.transactionno " \
                    f" and maxcov.customerpolicyid=Coverages.customerpolicyid " \
                    f" WHERE    CustomerPolicies.Id = '" + custpolid + "' " \
                    f" GROUP BY Coverages.CoveragePlanId , ridergroups.RiderSeq , Coverages.lifeseq , Coverages.coverageseq " \
                    f" ORDER BY RiderSeq asc; "
            print("*****************first**********************")
            print(query)
            df = pd.read_sql(query, conn)
            # print (type(df))
            print("******************second*********************")
            print(df)
            print("*********************thrid******************")
            screenshot = screenshotdir
            # f = open(screenshot + "/Selected_Policy_Rider_Detail.txt", "a")
            f = open(screenshot + "/Selected_Policy_Frequency1.txt", 'a', encoding='utf-8')
            f.write(query)
            f.close()
            # print("*********************fourth******************")
            # f.write(query)
            # print("*******************five********************")
            # f.close()
            print("*******************Six*******************")
            df.to_csv(screenshot + "/Selected_Policy_Rider_Detail.csv", mode='a')
            print("********************five*******************")
            # BuiltIn.log(df)
            # Retrieve values based on the column header name
            # values = df[column_header]
            # # Print the retrieved values
            # for value in values:
            #     print(value)
            #     value1 = value
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        # print(value1)
        # return df
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf

    @keyword("Get Selected Policy Address Detail from DB")
    def get_DBSelectedPolAddDet(self, dbhostname, dbusername, dbpassword, dbport, dbinstance,  custpolid, screenshotdir):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        key = b'f057ecb7c8ed51ac'
        # print(policyid)
        # encrypt_policynumber = AES.PHP_encrypt(key, policyid, iv)
        # print(encrypt_policynumber)
        # Column header (column name)
        # column_header = "UnitHolding"
        value1 = ""
        lsdf = []
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            query = f" select a.id despatchCustId, " \
                f" a.addressline1, a.addressline2, a.addressline3, " \
                f" a.addressline4, a.addressline5, a.postalcode " \
                f" from customerpolicies b " \
                f" left join customers a on a.remoteid = b.despatchnumber where a.market = 2 " \
                f" and b.Id in ('" + custpolid + "'); "
            print(query)
            df = pd.read_sql(query, conn)
            # print (type(df))
            print(df)
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/Selected_Policy_Address_Detail.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/Selected_Policy_Address_Detail.csv", mode='a')
            # BuiltIn.log(df)
            # Retrieve values based on the column header name
            # values = df[column_header]
            # # Print the retrieved values
            # for value in values:
            #     print(value)
            #     value1 = value
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        # print(value1)
        # return df
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf

    @keyword("Get Selected Policy Detail from DB")
    def get_DBSelectedPolDet(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, policyid, custpolid,
                             screenshotdir):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        key = b'f057ecb7c8ed51ac'
        # print((policyid))
        # encrypt_policynumber = AES.aes_encrypt(key, policyid)
        # print(encrypt_policynumber)
        # Column header (column name)
        # column_header = "UnitHolding"
        value1 = ""
        lsdf = []
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            print(conn)
            # Create a pandas DataFrame from the SQL query
            query = f" SELECT customerPolicies.Id, coverageplans.Description ProductName, " \
                    f" customers.FirstName, customers.LastName, customerPolicies.policyissuedate, " \
                    f" coverages.SumAssured sumAssured, customerPolicies.CommencementDate commencementDate, " \
                    f" coverages.RiskCessationDate expiryDate, customerPolicies.NextPremiumDate NextPremiumDate, " \
                    f" customerPolicies.Premium premiuminstallmentPremium, customerPolicies.PremiumCurrency premiumCurrency, " \
                    f" ridergroups.RiderSeq, policyStatuses.Enum AS CoverageStatus, MAX(coverages.transactionno) transactionno " \
                    f" FROM customerPolicies JOIN Coverages ON customerPolicies.Id = Coverages.CustomerPolicyId " \
                    f" JOIN Customers ON Coverages.InsuredCustomerId = Customers.Id " \
                    f" JOIN policyStatuses ON Coverages.PolicyStatusId = policyStatuses.Id " \
                    f" JOIN CoveragePlans ON Coverages.CoveragePlanId = CoveragePlans.Id " \
                    f" JOIN RiderGroups ON Coverages.RiderSeqId = ridergroups.Id " \
                    f" join (select customerpolicyid,lifeseq, coverageseq,rg.riderseq,max(transactionno) transactionno from  coverages cov join ridergroups rg on rg.id=cov.riderseqid " \
                    f" where customerpolicyid = '" + custpolid + "' " \
                    f" group by customerpolicyid,lifeseq, coverageseq,rg.riderseq) maxcov " \
                    f" on  maxcov.lifeseq=Coverages.lifeseq " \
                    f" and maxcov.coverageseq=Coverages.coverageseq " \
                    f" and maxcov.riderseq=ridergroups.riderseq " \
                    f" and maxcov.transactionno=Coverages.transactionno " \
                    f" and maxcov.customerpolicyid=Coverages.customerpolicyid " \
                    f" WHERE     CustomerPolicies.Id = '" + custpolid + "' " \
                    f" and CustomerPolicies.Market=2 " \
                    f" and CustomerPolicies.ExternalRemoteId = '" + policyid + "' " \
                    f" and  not CoveragePlans.covproductcode  in (select distinct Plancode from coveragetopupriderdetails where IsEmbeddedRider = 1 and market=2) " \
                    f" GROUP BY Coverages.CoveragePlanId , ridergroups.RiderSeq , Coverages.lifeseq , Coverages.coverageseq; "
            # print (type(df))
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/Selected_Policy_Detail.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/Selected_Policy_Detail.csv", mode='a')
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        # print(value1)
        # return df
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf

    @keyword("Get Frequency from DB")
    def get_DBFrequency(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, policyid, owneruserid,
                        screenshotdir):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        key = b'f057ecb7c8ed51ac'
        # print((policyid))
        # encrypt_policynumber = AES.aes_encrypt(key, policyid)
        # print(encrypt_policynumber)
        # Column header (column name)
        # column_header = "UnitHolding"
        value1 = ""
        lsdf = []
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            query = f"SELECT pf.Enum, c.* from " + dbinstance + ".customerpolicies c " \
            f" join " + dbinstance + ".paymentfrequencies pf on pf.id = c.PaymentFrequencyId " \
            f" where  c.owneruserid = '" + owneruserid + "' " \
            f" and c.ExternalRemoteId = '" + policyid + "' ;"
            print(query)
            df = pd.read_sql(query, conn)
            # print (type(df))
            print(df)
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/Selected_Policy_Frequency.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/Selected_Policy_Frequency.csv", mode='a')
            # BuiltIn.log(df)
            # Retrieve values based on the column header name
            # values = df[column_header]
            # # Print the retrieved values
            # for value in values:
            #     print(value)
            #     value1 = value
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        # print(value1)
        # return df
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf

    @keyword("Get Payment Method from DB")
    def get_DBPaymentMethod(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, policyid, owneruserid,
                            screenshotdir):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        key = b'f057ecb7c8ed51ac'
        # print((policyid))
        # encrypt_policynumber = AES.aes_encrypt(key, policyid)
        # print(encrypt_policynumber)
        # Column header (column name)
        # column_header = "UnitHolding"
        value1 = ""
        lsdf = []
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            query = f"SELECT c.ExternalRemoteId,c.id,c.PaymentMethodId, c.OwnerUserId, " \
                    f" p.Name,p.Enum,b.CreditCardNumber,b.BankAccountName,b.BankAccountNumber " \
                    f" FROM " + dbinstance + ".customerpolicies c  " \
                    f" join " + dbinstance + ".paymentmethods p on p.id = c.PaymentMethodId " \
                    f" Left join " + dbinstance + ".customerbankaccounts b on b.OwnerCustomerId = c.OwnerUserId and c.MandateFileRef = b.MandateFileRef " \
                    f" where OwnerUserId IN ('" + owneruserid + "') " \
                    f" and ExternalRemoteId = '" + policyid + "'; "
            print(query)
            df = pd.read_sql(query, conn)
            # print (type(df))
            print(df)
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/Selected_Policy_PaymentMethod.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/Selected_Policy_PaymentMethod.csv", mode='a')
            # BuiltIn.log(df)
            # Retrieve values based on the column header name
            # values = df[column_header]
            # # Print the retrieved values
            # for value in values:
            #     print(value)
            #     value1 = value
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        # print(value1)
        # return df
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf

    @keyword("Get Policy List from DB")
    def get_DBPolicyList(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, owneruserid, screenshotdir):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        key = b'f057ecb7c8ed51ac'
        # print((policyid))
        # encrypt_policynumber = AES.aes_encrypt(key, policyid)
        # print(encrypt_policynumber)
        # Column header (column name)
        # column_header = "UnitHolding"
        value1 = ""
        lsdf = []
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            query = f"SELECT customerPolicies.Id, policyStatuses.Enum AS PolicyStatus, " \
                    f" ProductGroupTypes.ProductGroupName AS ProductCategory, CoveragePlans.description AS ProductName, " \
                    f" customerPolicies.ExternalRemoteId AS PolicyNumber, pf.id  AS PaymentFrequencyId, " \
                    f" customerPolicies.sourcesystem, MAX(Coverages.transactionno) AS transactionno " \
                    f" FROM customerPolicies " \
                    f" join " + dbinstance + ".paymentfrequencies pf on pf.id = customerPolicies.PaymentFrequencyId " \
                    f" JOIN policyStatuses ON customerPolicies.PolicyStatusId = policyStatuses.Id " \
                    f" JOIN Coverages ON customerPolicies.Id = Coverages.CustomerPolicyId " \
                    f" JOIN CoveragePlans ON Coverages.CoveragePlanId = CoveragePlans.Id " \
                    f" LEFT JOIN ProductGroupTypes  on Coverages.InternalPlanCode = ProductGroupTypes.PlanCode " \
                    f" JOIN PolicyPlans ON customerPolicies.PolicyPlanId = PolicyPlans.Id " \
                    f" JOIN ridergroups ON ridergroups.id = Coverages.RiderSeqId  " \
                    f" join( select customerpolicyid,lifeseq, coverageseq,rg.riderseq,max(transactionno) transactionno " \
                    f" from  coverages cov join customerpolicies cp on cp.Id=cov.CustomerPolicyId join ridergroups rg on rg.id=cov.riderseqid " \
                    f" where  ( rg.riderseq = '00' AND cov.coverageseq = '1' AND cov.lifeseq = '1') AND cp.OwnerUserId in ('" + owneruserid + "') " \
                    f" group by customerpolicyid,lifeseq, coverageseq,rg.riderseq) maxcov  " \
                    f" on  maxcov.lifeseq=Coverages.lifeseq " \
                    f" and maxcov.coverageseq=Coverages.coverageseq " \
                    f" and maxcov.riderseq=ridergroups.riderseq " \
                    f" and maxcov.transactionno=Coverages.transactionno " \
                    f" and maxcov.customerpolicyid=Coverages.customerpolicyid " \
                    f" WHERE CustomerPolicies.OwnerUserId in ('" + owneruserid + "') " \
                    f" AND ( ridergroups.riderseq = '00' AND Coverages.coverageseq = '1' AND Coverages.lifeseq = '1') " \
                    f" AND policyStatuses.Enum <> ('Hidden') " \
                    f" GROUP BY customerPolicies.RemoteId " \
                    f" ORDER BY FIELD(policyStatuses.Enum,'Active','Lapsed','Inactive') , CommencementDate DESC; "
            print(query)
            df = pd.read_sql(query, conn)
            # print (type(df))
            print(df)
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/View_policy_list.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/View_policy_list.csv", mode='a')
            # BuiltIn.log(df)
            # Retrieve values based on the column header name
            # values = df[column_header]
            # # Print the retrieved values
            # for value in values:
            #     print(value)
            #     value1 = value
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        # print(value1)
        # return df
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf

    @keyword("Get Selected Policy Payment History Detail from DB")
    def get_DBSelectedPolPaymentHistDet(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, custpolid,
                                        screenshotdir):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        key = b'f057ecb7c8ed51ac'
        value1 = ""
        lsdf = []
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            query = f" SELECT " \
                    f" cp.Id, " \
                    f" cp.ExternalRemoteId, " \
                    f" TransactionDate as ReceiptDate, " \
                    f" TransactionDesc, " \
                    f" BankType as BankTypeCode, " \
                    f" pbc.Name as BankType, " \
                    f" cp.PremiumCurrency, " \
                    f" pmd.Enum as PaymentMethod, " \
                    f" PremiumPaidAmt from customerpolicies cp " \
                    f" join policypaymenthistories pph on cp.id=pph.CustomerPolicyId " \
                    f" join paymentbankcodes pbc on pph.banktype  = pbc.remoteid " \
                    f" join paymentmethods pmd on cp.PaymentMethodId=pmd.Id " \
                    f" where cp.market=1  " \
                    f" and cp.Id = '" + custpolid + "' order by	ReceiptDate	desc "
            print(query)
            df = pd.read_sql(query, conn)
            # print (type(df))
            print(df)
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/selected_Policy_payment_History_Detail.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/selected_Policy_payment_History_Detail.csv", mode='a')
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf

    @keyword("Get Selected Policy Indicative dividend Detail from DB")
    def get_Indicative_dividend(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, screenshotdir, policyIssueDate):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        key = b'f057ecb7c8ed51ac'
        value1 = ""
        lsdf = []
        print(policyIssueDate)
        pid_str = policyIssueDate.strftime("%Y-%m-%d")
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            query = f" select * from " + dbinstance + ".indexfundvaluations " \
                    f" where IsDeleted = 0 and '" + pid_str + "' between PolicyIssuedStartDate and PolicyIssuedEndDate " \
                    f" order by PolicyIssuedStartDate desc; "
            print(query)
            df = pd.read_sql(query, conn)
            # print (type(df))
            print(df)
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/Selected_Policy_Indicative_dividend_Detail.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/Selected_Policy_Indicative_dividend_Detail.csv", mode='a')
            # BuiltIn.log(df)
            # Retrieve values based on the column header name
            # values = df[column_header]
            # # Print the retrieved values
            # for value in values:
            #     print(value)
            #     value1 = value
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        # print(value1)
        # return df
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf