import mysql.connector

import pandas as pd

import AES


try:
    from robot.libraries.BuiltIn import BuiltIn
    from robot.api.deco import library, keyword

    ROBOT = False
except Exception:
    ROBOT = False


class InvestmentDB:

    @keyword("Get Policy Fund Details from DB")
    def get_DBInvesmentPolicyFund(self, dbhostname, dbusername, dbpassword, dbport, dbinstance, policyid,
                                  screenshotdir):
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
            query = f"SELECT  pfuh.CustomerPolicyId, " \
                    f" pfhunit.UnitHolding, " \
                    f" cp.externalRemoteid ExternalPolicyNumber, " \
                    f" pfuh.Id as FundId, " \
                    f" pfn.AMCFundcode, " \
                    f" fc.RemoteId as Currency, " \
                    f" pfuh.ValuationDate, " \
                    f" pfuh.ValuationPrice, " \
                    f" cast((pfuh.ValuationPrice*pfhunit.UnitHolding) as decimal(18,2)) as CurrentValue, " \
                    f" pfhsum.Totalfundprice, " \
                    f" WeightedCost, " \
                    f" cast((pfhunit.UnitHolding * pfuh.ValuationPrice) - (pfhunit.UnitHolding * WeightedCost)as decimal(18,2)) as GainLoss, " \
                    f" fstg.FactSheetURL, " \
                    f" fstg.FundRiskLevel, " \
                    f" fstg.ForeignExchangeRateRisk, " \
                    f" fstg.Channel,  " \
                    f" case when pfuh1.fundcode is null then 'T' else 'F' end as isFundEnabled, " \
                    f"  CASE WHEN fstg.ExpiryDate IS NULL THEN 1 ELSE 0 END AS IsAllowedSwitchIn " \
                    f" FROM customerpolicies cp " \
                    f" JOIN policyfundunitholdings pfuh ON cp.Id = pfuh.CustomerPolicyId " \
                    f" JOIN (select CustomerPolicyId,cast(sum(ValuationPrice*UnitHolding) as decimal(18,2)) Totalfundprice from policyfundunitholdings " \
                    f"  where CustomerPolicyId in ('" + policyid + "') and UnitHolding >0  " \
                    f" group by CustomerPolicyId)pfhsum on pfhsum.CustomerPolicyId = pfuh.CustomerPolicyId " \
                    f" JOIN (select CustomerPolicyId,FundCode,sum(UnitHolding) UnitHolding from policyfundunitholdings where CustomerPolicyId in ('" + policyid + "') and UnitHolding >0 " \
                    f" group by CustomerPolicyId,FundCode)pfhunit on pfhunit.CustomerPolicyId = pfuh.CustomerPolicyId and pfhunit.FundCode = pfuh.FundCode " \
                    f" JOIN fundcurrencies fc on pfuh.TotalValueCurrencyId = fc.id " \
                    f" JOIN policyfundnames pfn on pfn.RemoteId=pfuh.FundCode   " \
                    f" JOIN fundweightedcosts fwc on pfuh.CustomerPolicyId=fwc.CustomerPolicyId  and pfuh.FundCode=fwc.FundCode " \
                    f" JOIN (select AMCFundCode,RemoteId ,channel, FundRiskLevel,ForeignExchangeRateRisk,fd.SourceName as FactSheetURL, ExpiryDate " \
                    f"     from policyfundnames pfa join fundassetclasses fac on pfa.AssetClassListID=fac.AssetClassID " \
                    f"      join  funddocuments fd on fd.FundId=pfa.FundID " \
                    f"     where DocumentType='Fact Sheet' and pfa.market=2 and pfa.Active=1 and pfa.Disable=0 and fd.Active=1 and fd.Disable=0 and fac.Active=1 and fac.Disable=0) fstg on fstg.RemoteId=pfuh.FundCode " \
                    f" LEFT JOIN (select distinct FundCode,cp.PolicyCompany from policyfundunitholdings pfuh join customerpolicies cp on cp.Id=pfuh.CustomerPolicyId  " \
                    f" where CustomerPolicyId in ('" + policyid + "') and UnitHolding >0) pfuh1  " \
                    f" ON  pfn.RemoteId=pfuh1.fundcode " \
                    f" WHERE cp.Id in ('" + policyid + "') " \
                    f" AND cp.Market = 2     " \
                    f" AND pfuh.UnitHolding >0 " \
                    f" GROUP BY pfuh.CustomerPolicyId,pfn.AMCFundcode;"
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/PolicyFundDetail.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/PolicyFundDetail.csv", mode='a')
            # print (type(df))
            print(df)
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


    @keyword("Get Investment Details from DB")
    def get_DBInvesment(self, dbhostname,dbusername,dbpassword,dbport,dbinstance,owneruserid,screenshotdir):
        # Database connection parameters
        db_config = {
            "host": dbhostname,
            "port": dbport,
            "user": dbusername,
            "password": dbpassword,
            "database": dbinstance,
        }
        # Column header (column name)
        column_header = "PolicyStatus"
        value1 = ""
        lsdf = []
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            query = f"SELECT " \
                f" customerPolicies.Id," \
                f" customerPolicies.ExternalRemoteId," \
                f" policyStatuses.Enum AS PolicyStatus," \
                f" customerPolicies.RemoteId," \
                f" CoveragePlans.description AS ProductName," \
                f" ProductGroupTypes.ProductGroupName AS ProductCategory," \
                f" pfuh.ValuationDate," \
                f" pfuh.ValuationPrice," \
                f" pfuh.UnitHolding," \
                f" Totalfundprice," \
                f" TotalWeightedCost," \
                f" (Totalfundprice-TotalWeightedCost) as TotalGainLoss," \
                f" MAX(Coverages.transactionno) AS transactionno" \
                f" FROM customerPolicies" \
                f" JOIN policyStatuses ON customerPolicies.PolicyStatusId = policyStatuses.Id" \
                f" JOIN Coverages ON customerPolicies.Id = Coverages.CustomerPolicyId" \
                f" JOIN CoveragePlans ON Coverages.CoveragePlanId = CoveragePlans.Id" \
                f" JOIN ridergroups ON ridergroups.id = Coverages.RiderSeqId" \
                f" JOIN policyfundunitholdings pfuh ON pfuh.customerpolicyid = customerPolicies.Id" \
                f" JOIN (select CustomerPolicyId,cast(sum(ValuationPrice*UnitHolding)as decimal(18,2)) Totalfundprice from" \
                f" policyfundunitholdings pfuh join customerpolicies cp on pfuh.customerpolicyid=cp.Id" \
                f" where cp.OwnerUserId  in  ('" + owneruserid +"') and pfuh.UnitHolding >0" \
                f" group by 1) pfhsum on pfhsum.CustomerPolicyId = customerPolicies.Id" \
                f" JOIN" \
                f" (select fwc.CustomerPolicyId,cast(Sum(pfuh.UnitHolding*WeightedCost) as decimal(18,2)) TotalWeightedCost from" \
                f" fundweightedcosts fwc join policyfundunitholdings pfuh on fwc.customerpolicyid=pfuh.customerpolicyid and fwc.FundCode =pfuh.FundCode" \
                f" join customerpolicies cp on pfuh.customerpolicyid=cp.Id and fwc.customerpolicyid=cp.Id" \
                f" where cp.OwnerUserId  in ('" + owneruserid +"') and pfuh.UnitHolding >0" \
                f" group by 1) fwc on pfuh.CustomerPolicyId=fwc.CustomerPolicyId" \
                f" LEFT JOIN ProductGroupTypes ON Coverages.InternalPlancode = ProductGroupTypes.PlanCode " \
                f" join(" \
                f" select customerpolicyid,lifeseq, coverageseq,rg.riderseq,max(transactionno) transactionno from  coverages cov join customerpolicies cp on cp.Id=cov.CustomerPolicyId join ridergroups rg on rg.id=cov.riderseqid" \
                f" where   cp.OwnerUserId in ('" + owneruserid +"')  " \
                f" group by customerpolicyid,lifeseq, coverageseq,rg.riderseq) maxcov" \
                f" on  maxcov.lifeseq=Coverages.lifeseq" \
                f" and maxcov.coverageseq=Coverages.coverageseq" \
                f" and maxcov.riderseq=ridergroups.riderseq" \
                f" and maxcov.transactionno=Coverages.transactionno" \
                f" and maxcov.customerpolicyid=Coverages.customerpolicyid" \
                f" AND (ridergroups.riderseq = '00'  AND Coverages.coverageseq = '1'   AND Coverages.lifeseq = '1') " \
                f" WHERE CustomerPolicies.OwnerUserId in ('" + owneruserid +"') " \
                f" AND  CustomerPolicies.Market = 2  " \
                f" AND CustomerPolicies.PremiumCurrency in ('USD','THB')" \
                f" AND CustomerPolicies.Type = 'GbfTOsOWf35koyjcp123IA=='  " \
                f" AND  pfuh.UnitHolding >0 " \
                f" GROUP BY customerPolicies.RemoteId" \
                f" ORDER BY  CommencementDate DESC"
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/investmentDetails.txt", "w")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/investmentDetails.csv", mode='w')
            print(df)
            # print (type(df))
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

    @keyword("Get Risk Level")
    def get_DBRiskLevel(self, dbhostname,dbusername,dbpassword,dbport,dbinstance,owneruserid, screenshotdir):
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
        column_header = "InvestorType"
        value1 = ""
        try:
            # Create a MySQL database connection
            conn = mysql.connector.connect(**db_config)
            # Create a pandas DataFrame from the SQL query
            # query = f"set @decryptKey:= 'f057ecb7c8ed51ac'; " \
            query =  f"SELECT  distinct  c.Id, crl.Score, rit.RiskLevel, InvestorType, InvestorTypeLocal, " \
                    f"  DATE_ADD(crl.Submissiondate, INTERVAL 365 DAY)  as RiskProfileExpiryDate " \
                    f"  from customers c " \
                        f"  join customerpolicies cp on c.Id=cp.owneruserId " \
                        f"  join (select * from (select row_number() over(partition by Entityid order by Submissiondate desc ) as rownum, Entityid,Score ,Submissiondate from customerrisklevels)a where rownum=1) crl on crl.entityid=c.IdentityId" \
                        f"  join riskinvestortypemap rit on c.market=rit.market " \
                        f"  and crl.Score between rit.MinScore and rit.MaxScore " \
                        f"  and c.Id in ('" + owneruserid +"')  " \
                        f"  and c.Market = 2    " \
                        f"  and cp.PremiumCurrency in ('USD','THB') " \
                        f"  and cp.Type = 'GbfTOsOWf35koyjcp123IA==' ; "
            screenshot = screenshotdir
            print(query)

            f = open(screenshot + "/investmentRisk.txt", "a")
            f.write(query)
            f.close()

            df = pd.read_sql(query, conn)
            df.to_csv(screenshot + "/investmentRisk.csv", mode='a')
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
        print (value1)
        return value1

