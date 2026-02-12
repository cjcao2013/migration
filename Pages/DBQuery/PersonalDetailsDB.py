import mysql.connector

import pandas as pd

import AES


try:
    from robot.libraries.BuiltIn import BuiltIn
    from robot.api.deco import library, keyword

    ROBOT = False
except Exception:
    ROBOT = False

class PersonalDetailsDB:

    @keyword("Get Personal Details with OTP")
    def get_DBPersonalDetails(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, owneruserid,policyid):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        # Column header (column name)
        # column_header = "UnitHolding"
        value1 = ""
        lsdf = []
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            # query = f"select * from fwd_insurance_uat_addon.servicingdtltemp where owneruserid = '" + owneruserid + "'  and ListPoliciesApply = '" + policyid + "'  order by timegenerated desc"
            # f" where owneruserid = '" + owneruserid +"' " \
            # f" and ListPoliciesApply = '" + policyid +"' " \
            query = f"select * from " + dbinstance + ".servicingdtltemp " \
                    f" order by timegenerated desc"
            print(query)
            df = pd.read_sql(query, conn)
            # print (type(df))
            print (df)
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

    @keyword("Get Servicing Agent Details")
    def get_DBServicingAgentDetail(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, policynumber,
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
                query = f"select policyagents.Id, policyagents.FirstName, policyagents.LastName, policyagents.EmailAddress, policyagents.MobileNumber" \
                        f" from CustomerPolicies" \
                        f" join policyagents on CustomerPolicies.AgentUserId = policyagents.Id" \
                        f" and CustomerPolicies.ExternalRemoteId = '" + encrypt_policynumber + "'; "
                print(query)
                df = pd.read_sql(query, conn)
                # print (type(df))
                print(df)
                screenshot = screenshotdir
                print(query)

                f = open(screenshot + "/Policy_ServicingAgentDetails.txt", "a")
                f.write(query)
                f.close()

                df = pd.read_sql(query, conn)
                df.to_csv(screenshot + "/Policy_ServicingAgentDetails.csv", mode='a')
            except mysql.connector.Error as err:
                print(f"Error: {err}")
            finally:
                # Close the database connection
                conn.close()
            lsdf = [df.columns.values.tolist()] + df.values.tolist()
            return lsdf

    @keyword("Get Servicing Agent Address Details")
    def get_DBServicingAgentAddressDetail(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, policynumber,
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
                    query = f"select policyagents.AddressLine1, policyagents.AddressLine2, policyagents.AddressLine3, policyagents.AddressLine4, policyagents.AddressLine5, policyagents.ZipCode" \
                            f" from CustomerPolicies" \
                            f" join policyagents on CustomerPolicies.AgentUserId = policyagents.Id" \
                            f" and CustomerPolicies.ExternalRemoteId = '" + encrypt_policynumber + "'; "
                    print(query)
                    df = pd.read_sql(query, conn)
                    # print (type(df))
                    print(df)
                    screenshot = screenshotdir
                    print(query)

                    f = open(screenshot + "/Policy_ServicingAgentAddressDetails.txt", "a")
                    f.write(query)
                    f.close()

                    df = pd.read_sql(query, conn)
                    df.to_csv(screenshot + "/Policy_ServicingAgentAddressDetails.csv", mode='a')
                except mysql.connector.Error as err:
                    print(f"Error: {err}")
                finally:
                    # Close the database connection
                    conn.close()
                lsdf = [df.columns.values.tolist()] + df.values.tolist()
                return lsdf

    @keyword("Get Contact Details")
    def get_DBCotactDetails(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, policynumber,
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
        # Column header (column name)
        # column_header = "UnitHolding"
        value1 = ""
        lsdf = []
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            # query = f"select * from fwd_insurance_uat_addon.servicingdtltemp where owneruserid = '" + owneruserid + "'  and ListPoliciesApply = '" + policyid + "'  order by timegenerated desc"
            # f" where owneruserid = '" + owneruserid +"' " \
            # f" and ListPoliciesApply = '" + policyid +"' " \
            query = f" select a.ExternalRemoteId,b.Email,b.MobileNumber,b.AddressLine1,b.AddressLine2,b.AddressLine3,b.AddressLine4,b.AddressLine5,b.PostalCode" \
                    f" from customerpolicies a inner join customers b on a.OwnerUserId=b.Id" \
                    f" where a.ExternalRemoteId ='" + encrypt_policynumber + "'; "
            print(query)
            df = pd.read_sql(query, conn)
            # print (type(df))
            print(df)
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/Policy_ContactDetails.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/Policy_ContactDetails.csv", mode='a')

        except mysql.connector.Error as err:
            print(f"Error: {err}")
        finally:
            # Close the database connection
            conn.close()
        # print(value1)
        # return df
        lsdf = [df.columns.values.tolist()] + df.values.tolist()
        return lsdf
