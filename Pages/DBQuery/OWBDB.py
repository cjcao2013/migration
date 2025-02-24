import mysql.connector

import pandas as pd

import AES

try:
    from robot.libraries.BuiltIn import BuiltIn
    from robot.api.deco import library, keyword

    ROBOT = False
except Exception:
    ROBOT = False

class OWBDB:

    @keyword("Get Freq and RCC Details")
    def get_DBOWBPayload(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, requesttype,caseno):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        key = b'f057ecb7c8ed51ac'
        # print((policynumber))
        # encrypt_policynumber = AES.aes_encrypt(key, policynumber)
        # print(encrypt_policynumber)
        # Column header (column name)
        column_header = "Payload"
        value1 = ""
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            # query = f"set @decryptKey:= 'f057ecb7c8ed51ac'; " \
            query = f"select * from " + dbinstance + ".requeststatus " \
                    f" where requesttype = '" + requesttype + "' " \
                    f" and caseno = '" + caseno + "'"
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