import mysql.connector
import pandas as pd

# import pandas as pd

import AES

try:
    from robot.libraries.BuiltIn import BuiltIn
    from robot.api.deco import library, keyword

    ROBOT = False
except Exception:
    ROBOT = False


class DBQuerySelect:

    @keyword("Get Owner User ID from DB")
    def get_DBOwnerUserId(self, dbhostname, dbusername, dbpassword, dbport, dbinstanceAddon, policynumber, dbinstance):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstanceAddon,
        }
        # key = b'f057ecb7c8ed51ac'
        key = b'f057ecb7c8ed51ac'
        print((policynumber))
        encrypt_policynumber = AES.aes_encrypt(key, policynumber)
        print(encrypt_policynumber)
        # Column header (column name)
        column_header = "OwnerUserId"
        value1 = ""
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            # query = f"set @decryptKey:= 'f057ecb7c8ed51ac'; " \
            query = f"SELECT OwnerUserId FROM " + dbinstance + ".customerpolicies where ExternalRemoteId = '" + encrypt_policynumber + "'"
            print(query)
            df = pd.read_sql(query, conn)
            print(df)
            # Retrieve values based on the column header name
            values = df[column_header]
            print(values)
            # Print the retrieved values
            for value in values:
                print("test")
                print(value)
                value1 = value
                break
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        print(value1)

        return value1

    @keyword("Get Premium Payment History Detail from DB")
    def get_DBSelectedPolPremiumPaymentHistoryDet(self, dbhostname, dbusername, dbpassword, dbport, dbinstance,
                                                  PolicyNo, screenshotdir):
        # Database connection parameter
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        key = b'f057ecb7c8ed51ac'
        print((PolicyNo))
        encrypt_policynumber = AES.aes_encrypt(key, PolicyNo)
        print(encrypt_policynumber)
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            query = f"SELECT " \
                    f"pph.TemplateCode AS ReceiptNo, " \
                    f"pph.PremiumDueDate AS DueDate, " \
                    f"pph.TotalPremium AS Amount, " \
                    f"pph.ReceiptDate " \
                    f"FROM customerpolicies cp  " \
                    f"JOIN premiumpaymenthistories pph ON cp.id = pph.customerpolicyid " \
                    f"WHERE cp.market=2 " \
                    f"AND cp.ExternalRemoteId = '" + encrypt_policynumber + "' " \
                                                                            f"AND DATEDIFF(curdate(), pph.ReceiptDate) <= 410 " \
                                                                            f"ORDER BY ReceiptDate ASC; "

            print(query)
            df = pd.read_sql(query, conn)
            # print (type(df))
            print(df)
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/View_payment_history_list.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/View_payment_history_list.csv", mode='a')
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
            # print(value1)
            # return df
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf

    @keyword("Get Onboarding OTP from DB")
    def get_DBOnboardingOTP(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, country, dob, nationalid):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        # Column header (column name)
        column_header = "OTP"
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            query = f"select * from " + dbinstance + ".notifications order by timegenerated desc; "
            df = pd.read_sql(query, conn)
            # Retrieve values based on the column header name
            values = df[column_header]
            # Print the retrieved values
            for value in values:
                print("test")
                print(value)
                value1 = value
                break
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        print(value1)
        return value1

    @keyword("AES Encrypt")
    def getAESEncrypt(self, key, plaintext):
        encrypted_data = AES.aes_encrypt(key, plaintext)
        return encrypted_data

    @keyword("AES Decrypt")
    def getAESDecrypt(self, key, plaintext):
        print(key)
        print(plaintext)
        decrypted_data = AES.aes_decrypt(key, plaintext)
        return decrypted_data

    @keyword("PHP AES Encrypt")
    def getPHPAESEncrypt(self, key, plaintext, iv):
        encrypted_data = AES.PHP_encrypt(plaintext, key, iv)
        return encrypted_data

    @keyword("PHP AES Decrypt")
    def getPHPAESDecrypt(self, key, plaintext, iv):
        print(key)
        print(plaintext)
        print(iv)
        decrypted_data = AES.PHP_decrypt(plaintext, key, iv)
        return decrypted_data

    @keyword("Get Client ID based on Policy Number from DB")
    def get_DBClientId(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, policynumber, screenshotdir):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        key = b'f057ecb7c8ed51ac'
        print((policynumber))
        encrypt_policynumber = AES.aes_encrypt(key, policynumber)
        print(encrypt_policynumber)
        # Column header (column name)
        column_header = "CustomerClientId"
        value1 = ""
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            query = f"select " \
                    f" ps.RemoteId as PremiumStatuses, " \
                    f" pt.RemoteId as PolicyStaus, " \
                    f" a.RemoteId as PolicyNumber, " \
                    f" a.ExternalRemoteId as ExternalPolicyNumber, " \
                    f" b.RemoteId as CustomerClientId, " \
                    f" b.FirstName as FirstName, " \
                    f" b.LastName as LastName, " \
                    f" b.IdentityId as IdentityId, " \
                    f" b.Email as Email, " \
                    f" b.MobileNumber as MobileNumber, " \
                    f" a.RemoteId " \
                    f" from " + dbinstance + ".customerpolicies a " \
                                             f" inner join " + dbinstance + ".customers b on a.OwnerUserId = b.Id " \
                                                                            f" inner join " + dbinstance + ".identitytypes c on b.IdentityTypeId = c.Id " \
                                                                                                           f" join PremiumStatuses ps on ps.Id = a.PremiumStatusId " \
                                                                                                           f" join policystatuses pt on a.PolicyStatusId = pt.Id " \
                                                                                                           f" where a.ExternalRemoteId = '" + encrypt_policynumber + "'; "

            print(query)
            df = pd.read_sql(query, conn)
            print(df)
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/GetCientID.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/GetCientID.csv", mode='a')
            print(df)
            # Retrieve values based on the column header name
            values = df[column_header]
            print(values)
            # Print the retrieved values
            for value in values:
                print("test")
                print(value)
                value1 = value
                break
        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        print(value1)
        return value1

    @keyword("Get OWB Details from DB using CustId")
    def get_OWBDetails(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, customerid, screenshotdir):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            query = f"select * from " + dbinstance + ".requeststatus " \
                                                     f" where CustomerId='" + customerid + "' order by RequestSentOn desc , CaseNo desc; "
            print(query)
            df = pd.read_sql(query, conn)
            print(df)
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/GetDBDetails.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/GetDBDetails.csv", mode='a')
            print(df)

        except mysql.connector.Error as err:
            print(f"Error: {err}")

        finally:
            # Close the database connection
            conn.close()
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf

    @keyword("Get OPUS Details from DB using CustId")
    def get_OPUSDetails(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, customerid, screenshotdir):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            query = f"select * from " + dbinstance + ".requeststatus " \
                                                     f" where CustomerId='" + customerid + "' and SentTo='Opus' order by RequestSentOn desc , CaseNo desc; "
            print(query)
            df = pd.read_sql(query, conn)
            print(df)
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/GetDBDetails.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/GetDBDetails.csv", mode='a')
            print(df)

        except mysql.connector.Error as err:
            print(f"Error: {err}")

        finally:
            # Close the database connection
            conn.close()
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf

    @keyword("Check BO Status")
    def get_BOStatus(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, screenshotdir, policynumber):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            query = f"select SentTime,Status, a.* from " + dbinstance + ".bologs " \
                                                                        f" as a where updatetype = 27 and market = 2 " \
                                                                        f" and SentPayload like '%" + policynumber + "%' order by SentTime desc "
            print(query)
            df = pd.read_sql(query, conn)
            print(df)
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/GetBOStatus.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/GetBOStatus.csv", mode='a')
            print(df)

        except mysql.connector.Error as err:
            print(f"Error: {err}")

        finally:
            # Close the database connection
            conn.close()
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf

    @keyword("Get Selected Policy BenefitPayout History from DB")
    def get_DBSelectedPolBeneDet(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, policynumber,
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
        print((policynumber))
        encrypt_policynumber = AES.aes_encrypt(key, policynumber)
        value1 = ""
        lsdf = []
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            query = f" SELECT " \
                    f"     cp.Id, " \
                    f"    bph.BenefitType AS BenefitType, " \
                    f"    CASE " \
                    f"        WHEN bph.BenefitType IN ('Dividend Option Processing', 'Accu Dividend Allocation') THEN 'Dividend payment' " \
                    f"        WHEN bph.BenefitType IN ('Interim Cash Payment Release', 'ICP Loan Repay at Anniversary', 'ICP Accumulated Pay Out') THEN 'Interim cash payout' " \
                    f"        WHEN bph.BenefitType IN ('Maturity', 'Maturity Installment Release') THEN 'Policy anniversary payment' " \
                    f"        WHEN bph.BenefitType = 'Pension/Annuity Release' THEN 'Annuity' " \
                    f"        WHEN bph.BenefitType = 'Dividend Release' THEN 'Dividend payment' " \
                    f"        WHEN bph.BenefitType IN ('Cash Back/Birthday Release', 'Cash Back/Birthday', 'Cash Back/Birthday /บัญชี ผอป.คุณวัชริน ทองโชติ', 'Cash Back/Birthday Release/', '0ash Back/Birthday') THEN 'Interim cash payout' " \
                    f"        WHEN bph.BenefitType = 'Maturity Process' THEN 'Policy anniversary payment' " \
                    f"        WHEN bph.BenefitType = 'Annuity Payment Processing' THEN 'Annuity' " \
                    f"        ELSE NULL  " \
                    f"        END AS BenefitTypeDisplay, " \
                    f"        cp.PremiumCurrency AS Currency, " \
                    f"         bph.BenefitAmount, " \
                    f"       bph.PayoutMethod, " \
                    f"    CASE  " \
                    f"        WHEN bph.PayoutMethod IN ('DCP', 'MCL', 'IDC') THEN 'Bank transfer' " \
                    f"        WHEN bph.PayoutMethod IN ('PPY', 'IPP') THEN 'Promptpay Transfer' " \
                    f"        WHEN bph.PayoutMethod IN ('DDP', 'CCP', 'MCP', 'CPO') THEN 'Cheque/Draft' " \
                    f"        ELSE NULL  " \
                    f"    END AS PayoutMethodDisplay, " \
                    f"    bph.BankName, " \
                    f"    bph.BankAccountNumber,  " \
                    f"    bph.ChequeNumber, " \
                    f"    bph.PayoutDate, " \
                    f"    bph.PayoutStatus, " \
                    f"    bph.ChequeChannel " \
                    f" FROM customerpolicies cp " \
                    f" JOIN customers ON cp.OwnerUserId = customers.Id " \
                    f" JOIN benefitpayouthistories bph ON  " \
                    f"    cp.ExternalRemoteId = bph.PaymentReferenceNumber " \
                    f"    AND cp.Market = bph.Market " \
                    f"    WHERE cp.market = 2 " \
                    f"    AND cp.ExternalRemoteId = '" + encrypt_policynumber + "' " \
                    f"    AND bph.PayoutMethod IN ('DCP', 'MCL', 'IDC', 'PPY', 'IPP', 'DDP', 'CCP', 'MCP', 'CPO') " \
                    f"    AND bph.PayoutStatus IN ('Fail', 'Success') ;"

            print(query)
            df = pd.read_sql(query, conn)
            # print (type(df))
            print(f"Test")
            print(df)
            print(f"Test")
            screenshot = screenshotdir
            print(query)
            print(f"Test")
            f = open(screenshot + "/Selected_Policy_Benefitpayout.txt", "a")
            f.write(query)
            f.close()

        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        # print(value1)
        # return df
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf
