import mysql.connector

import pandas as pd

import AES


try:
    from robot.libraries.BuiltIn import BuiltIn
    from robot.api.deco import library, keyword

    ROBOT = False
except Exception:
    ROBOT = False

class cancellationdtltempDB:

    @keyword("Get OTP From Cancellation DB")
    def get_DBCancellationOTP(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, owneruserid,bankaccountno):
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
            query = f"select * from " + dbinstance + ".cancellationdtltemp " \
                    f" where bankaccountnumber= '" + bankaccountno + "' "\
                    f" and customerid = '" + owneruserid +"' " \
                    f" order by generatedtime desc"
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

