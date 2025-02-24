*** Settings ***
Documentation       MainFrame Demo

Library             Mainframe3270
Library             BuiltIn
Library             Screenshot
# Library    OperatingSystem
# Library    SeleniumLibrary
Library             ../../Qrace/QraceHelper.py
Library             String
Library             ../DBQuery/DBQuerySelect.py
Resource            ../../CustomLibraries/LA/AS400Utility.robot
Resource            ../../CustomLibraries/common.robot

*** Variables ***
# ${CoreSystem_SubFlow}    claim


*** Keywords ***
Contract Enquiry
    TRY
        ${ClientIddec}    Get Client ID based on Policy Number from DB
        ...    ${dbhostname}
        ...    ${dbusername}
        ...    ${dbpassword}
        ...    ${dbport}
        ...    ${dbinstance}
        ...    ${Policy_No}
        ...    ${screenshotPath}
        Log    ${ClientIddec}

        ${LA_ClientNumber}    AES Decrypt    ${key}    ${ClientIddec}
        Log    ${LA_ClientNumber}
        Set Global Variable    ${LA_ClientNumber}

        ${CoreSystem_SubFlow}    Convert To Lower Case    ${CoreSystem_SubFlow}
        Execute Command    MoveCursor(12, 12)
        Take AS400 Screenshot
        Send Enter
        Send Enter
        Write Bare In Position    ${Policy_No}    12    44
        Take AS400 Screenshot
        Send Enter

        IF    '${CoreSystem_SubFlow}' == 'view investment'
    #    ${totfundCount}    Evaluate    ${totfundCount}-1
    #    ${newcounter}    Set Variable    ${totfundCount}
            Write Bare In Position    X    21    79
            Take AS400 Screenshot
            Send Enter
            Write Bare In Position    X    23    21
            Take AS400 Screenshot
            Send Enter
            ${fundcounter}    Set Variable    7
            ${FundCcycounter}    Set Variable    8
            ${FundPercentAllocationcounter}    Set Variable    9
            FOR    ${counter}    IN RANGE    0    ${totfundCount}
                Log    view investment
                Take AS400 Screenshot
                ${fundcounter}    Convert To Integer    ${fundcounter}
                ${FundCcycounter}    Convert To Integer    ${FundCcycounter}
                ${FundPercentAllocationcounter}    Convert To Integer    ${FundPercentAllocationcounter}

                ${FundName1}    Mainframe3270.Read    ${fundcounter}    3    7
                ${FundName1}    Strip String    ${FundName1}
                ${FundDesc1}    Mainframe3270.Read    ${fundcounter}    11    12
                ${FundDesc1}    Strip String    ${FundDesc1}
                ${FundCcy1}    Mainframe3270.Read    ${FundCcycounter}    11    5
                ${FundCcy1}    Strip String    ${FundCcy1}
                ${FundUnitBal1}    Mainframe3270.Read    ${fundcounter}    25    15
                ${FundUnitBal1}    Strip String    ${FundUnitBal1}
                ${FundPriceDate1}    Mainframe3270.Read    ${FundCcycounter}    25    15
                ${FundPriceDate1}    Strip String    ${FundPriceDate1}
                ${FundWeightedNAV1}    Mainframe3270.Read    ${fundcounter}    43    18
                ${FundWeightedNAV1}    Strip String    ${FundWeightedNAV1}
                ${FundLatestNAV1}    Mainframe3270.Read    ${FundCcycounter}    43    18
                ${FundLatestNAV1}    Strip String    ${FundLatestNAV1}
                ${FundPercentAllocation1}    Mainframe3270.Read    ${FundPercentAllocationcounter}    43    18
                ${FundPercentAllocation1}    Strip String    ${FundPercentAllocation1}
                ${FundTotalCost1}    Mainframe3270.Read    ${fundcounter}    63    17
                ${FundTotalCost1}    Strip String    ${FundTotalCost1}
                ${FundLatestBal1}    Mainframe3270.Read    ${FundCcycounter}    63    17
                ${FundLatestBal1}    Strip String    ${FundLatestBal1}
                ${FundGainLoss1}    Mainframe3270.Read    ${FundPercentAllocationcounter}    63    17
                ${FundGainLoss1}    Strip String    ${FundGainLoss1}
    #    ${mFundPercentAllocation1}    Evaluate    "{:.1f}".format(${FundPercentAllocation1})
                ${FundPercentAllocation1}    Convert To Number    ${FundPercentAllocation1}    2
                ${mFundUnitBal1}    Evaluate    "{:.4f}".format(${FundUnitBal1})
                ${newcounter}    Get From Dictionary    ${Fund_dic}    ${FundDesc1}
                IF    '${FundLatestBal1}' == ''
                    Set Calc VP With Source And Original Values
                    ...    LA_Fund${newcounter}_CurrentValue_Present
                    ...    false
                    ...    false
                    ...    Static
                    ...    LA_Application
                    ...    false
                    ...    false
                ELSE
                    Set Calc VP With Source And Original Values
                    ...    LA_Fund${newcounter}_CurrentValue_Present
                    ...    true
                    ...    true
                    ...    Static
                    ...    LA_Application
                    ...    true
                    ...    true
                END
                IF    '${FundGainLoss1}' == ''
                    Set Calc VP With Source And Original Values
                    ...    LA_Fund${newcounter}_GainorLossValue_Present
                    ...    false
                    ...    false
                    ...    Static
                    ...    LA_Application
                    ...    false
                    ...    false
                ELSE
                    Set Calc VP With Source And Original Values
                    ...    LA_Fund${newcounter}_GainorLossValue_Present
                    ...    true
                    ...    true
                    ...    Static
                    ...    LA_Application
                    ...    true
                    ...    true
                END
                Set Calc VP Actual Result With Original And Source
                ...    LA_Fund${newcounter}_FundName
                ...    ${FundDesc1}
                ...    ${FundDesc1}
                ...    LA_Application
                Set Calc VP Actual Result With Original And Source
                ...    LA_Fund${newcounter}_Percentage
                ...    ${FundPercentAllocation1}%
                ...    ${FundPercentAllocation1}%
                ...    LA_Application
                Set Calc VP Actual Result With Original And Source
                ...    LA_Fund${newcounter}_UnitHolding
                ...    ${mFundUnitBal1}
                ...    ${FundUnitBal1}
                ...    LA_Application
    #    Set Calc VP Actual Result With Original And Source    LA_Fund${counter}_CurrentValue    ${FundLatestBal1}    ${FundLatestBal1}    LA_Application
    #    Set Calc VP Actual Result With Original And Source    LA_Fund${counter}_GainorLossValue    ${FundGainLoss1}    ${FundGainLoss1}    LA_Application
    #    ${newcounter}    Evaluate    ${newcounter} - 1
                ${fundcounter}    Evaluate    ${fundcounter} + 3
                ${FundCcycounter}    Evaluate    ${FundCcycounter} + 3
                ${FundPercentAllocationcounter}    Evaluate    ${FundPercentAllocationcounter} + 3
            END
        ELSE IF    '${CoreSystem_SubFlow}' == 'view policy'
            Log    view policy
            Write Bare In Position    X    20    39
            Take AS400 Screenshot
            Send Enter
            Write Bare In Position    1    11    2
            Take AS400 Screenshot
            Send Enter
            Take AS400 Screenshot
            ${SumAssured}    Mainframe3270.Read    10    28    20
            ${SumAssured}    Strip String    ${SumAssured}
                Set Calc VP Actual Result With Original And Source
                ...    LA_SumAssured
                ...    ${SumAssured}
                ...    ${SumAssured}
                ...    LA_Application
        ELSE IF    '${CoreSystem_SubFlow}' == 'claim'
            Write in position    X    20    20
            Take AS400 Screenshot
            #    Send Enter
            ${Flag}    Set Variable    True
            ${iLoop}    Set Variable    10
            WHILE    ${Flag}
                ${NewPage}    Mainframe3270.Read    21    79    1
                #    ${NewPage}    Read    21    79    1
                IF    '${NewPage}' == '+'
                    Send PF    8
                    ${iLoop}    Set Variable    9
                    Take AS400 Screenshot
                ELSE
                    #    ${errmsg}    Set Variable    Required Desc not found
                    FOR    ${counter}    IN RANGE    9    24
                        Log    ${counter}
                        ${ComponantDetails}    Mainframe3270.Read    ${counter}    21    10
                        ${ComponantDetails}    Strip String    ${ComponantDetails}
                        IF    '${ComponantDetails}' == ''
                            Convert To Integer    ${counter}
                            ${counter}    Evaluate    ${counter} - 1
                            Write in position    1    ${counter}    2
                            #    Take AS400 Screenshot
                            ${ClaimReasonCode}    Mainframe3270.Read    11    10    5
                            ${ClaimReasonCode}    Strip String    ${ClaimReasonCode}
                            ${ClaimReason}    Mainframe3270.Read    11    15    25
                            ${ClaimReason}    Strip String    ${ClaimReason}
                            ${ClaimStatusCode}    Mainframe3270.Read    10    57    5
                            ${ClaimStatusCode}    Strip String    ${ClaimStatusCode}
                            ${ClaimStatus}    Mainframe3270.Read    10    62    14
                            ${ClaimStatus}    Strip String    ${ClaimStatus}
                            ${ClaimNumber}    Mainframe3270.Read    8    16    12
                            ${ClaimNumber}    Strip String    ${ClaimNumber}
                            #    Set Global Variable    Clain_Number
                            Set Calc VP Expected Result And Source    Claim_Reason_Code    ${ClaimReasonCode}    AS400
                            Set Calc VP Expected Result And Source    Claim_Reason    ${ClaimReason}    AS400
                            Set Calc VP Expected Result And Source    Claim_Status_Code    ${ClaimStatusCode}    AS400
                            Set Calc VP Expected Result And Source    Claim_Status    ${ClaimStatus}    AS400
                            Set Calc VP Expected Result And Source    Clain_Number    ${ClaimNumber}    AS400
                            BREAK
                        END
                    END
                    BREAK
                END
            END
           ELSE IF    '${CoreSystem_SubFlow}' == 'address'
                Write Bare In Position    X    21    79
                Take AS400 Screenshot
                Send Enter
        #    ${StreetLA}    Mainframe3270.Read    8    15    31
        #    ${StreetLA}    Strip String    ${StreetLA}
                ${Line1LA}    Mainframe3270.Read    14    33    31
                ${Line1LA}    Strip String    ${Line1LA}
                ${Line2LA}    Mainframe3270.Read    15    33    31
                ${Line2LA}    Strip String    ${Line2LA}
        #    ${Line3LA}    Mainframe3270.Read    11    15    31
        #    ${Line3LA}    Strip String    ${Line3LA}
                ${PostalCodeLA}    Mainframe3270.Read    18    33    10
                ${PostalCodeLA}    Strip String    ${PostalCodeLA}
        #    ${CountryCodeLA}    Mainframe3270.Read    13    15    3
        #    ${CountryCodeLA}    Strip String    ${CountryCodeLA}
        #    ${ProvinceCodeLA}    Mainframe3270.Read    13    37    3
        #    ${ProvinceCodeLA}    Strip String    ${ProvinceCodeLA}
        #    ${ProvinceTextLA}    Mainframe3270.Read    13    44    15
        #    ${ProvinceTextLA}    Strip String    ${ProvinceTextLA}
                 Take AS400 Screenshot
                Set Calc VP Actual Result With Original And Source
                ...    LA_AddressZipCode
                ...    ${PostalCodeLA}
                ...    ${PostalCodeLA}
                ...    LA_Application
                Set Calc VP Actual Result With Original And Source
                ...    LA_AddressLine1
                ...    ${Line1LA}
                ...    ${Line1LA}
                ...    LA_Application
                Set Calc VP Actual Result With Original And Source
                ...    LA_AddressLine2
                ...    ${Line2LA}
                ...    ${Line1LA}
                ...    LA_Application
        #    Set Calc VP With Source And Original Values    LA_Salutation    ${PersonalDetails_Address_ZipCode}    ${PostalCodeLA}    Static    LA_Flow    ${PersonalDetails_Address_ZipCode}    ${PostalCodeLA}
        END
        Take AS400 Screenshot
        #    Set Calc VP Expected Result And Source    TaxConsent    expectedResult    AS400
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       LA_Flow   ${reason}   LA Contract Enquiry
    END