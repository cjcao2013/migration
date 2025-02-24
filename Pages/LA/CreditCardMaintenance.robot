*** Settings ***
Documentation       MainFrame Demo

Library             Mainframe3270
Library             BuiltIn
Library             Screenshot
# Library    OperatingSystem
# Library    SeleniumLibrary
Library             ../../Qrace/QraceHelper.py
Resource            ../../CustomLibraries/LA/AS400Utility.robot
Library             ../DBQuery/DBQuerySelect.py
Library             ../DBQuery/PersonalDetailsDB.py
Resource            ../../CustomLibraries/common.robot
# *** Variables ***
# ${Policy_No}    50348918


*** Keywords ***
Credit Card Maintenance
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
        Execute Command    MoveCursor(7, 12)
        Take AS400 Screenshot
        Send Enter
        Execute Command    MoveCursor(9, 15)
        Take AS400 Screenshot
        Send Enter
        Write Bare In Position    ${LA_ClientNumber}    17    36
        Take AS400 Screenshot
        Write in position    C    19    36
    #    Send Enter
        ${CreditCardNumber}    Mainframe3270.Read    8    6    23
        ${CreditCardNumber}    Strip String    ${CreditCardNumber}
        ${CreditCardNo}    Set Variable    ${CreditCardNumber}
        ${CreditCardType}    Mainframe3270.Read    8    28    12
        ${CreditCardType}    Strip String    ${CreditCardType}
        ${CreditCardExpDate}    Mainframe3270.Read    8    40    12
        ${CreditCardExpDate}    Strip String    ${CreditCardExpDate}
        @{CreditCard_ExpiryDate}    Split String    ${CreditCardExpDate}    /
        ${CreditCard_ExpiryDateMM}    Get From List    ${CreditCard_ExpiryDate}    0
        ${CreditCard_ExpiryDateYY}    Get From List    ${CreditCard_ExpiryDate}    1
        ${M_Card_ExpiryDateMM}    Strip String    ${CreditCard_ExpiryDateMM}
        ${M_Card_ExpiryDateYY}    Get Substring    ${CreditCard_ExpiryDateYY}    -2
        ${M_Card_ExpiryDateYY}    Strip String    ${M_Card_ExpiryDateYY}
        ${CreditCardStatus}    Mainframe3270.Read    8    51    10
        ${CreditCardStatus}    Strip String    ${CreditCardStatus}
        ${CreditCardCurency}    Mainframe3270.Read    8    69    5
        ${CreditCardCurency}    Strip String    ${CreditCardCurency}
        ${CreditCardBankKey}    Mainframe3270.Read    9    6    10
        ${CreditCardBankKey}    Strip String    ${CreditCardBankKey}
        ${CreditCardBankDesc}    Mainframe3270.Read    9    17    30
        ${CreditCardBankDesc}    Strip String    ${CreditCardBankDesc}
        ${CreditCardBranchDesc}    Mainframe3270.Read    9    48    30
        ${CreditCardBranchDesc}    Strip String    ${CreditCardBranchDesc}
        ${mVP_Card_Number}    Get Substring    ${CreditCardNo}    -4
        ${mVP_Card_Number}    Strip String    ${mVP_Card_Number}

        Set Calc VP Actual Result With Original And Source
        ...    LA_Credit_Card_Number
        ...    ${mVP_Card_Number}
        ...    ${CreditCardNumber}
        ...    LA_Application
    #    Set Calc VP Actual Result With Original And Source    LA_Credit_Card_ExpDate    ${CreditCardExpDate}    ${CreditCardExpDate}    LA_Application
        Set Calc VP Actual Result With Original And Source
        ...    LA_Credit_Card_ExpiryDate_Month
        ...    ${M_Card_ExpiryDateMM.strip()}
        ...    ${CreditCard_ExpiryDateMM.strip()}
        ...    LA_Application
        Set Calc VP Actual Result With Original And Source
        ...    LA_Credit_Card_ExpiryDate_Year
        ...    ${M_Card_ExpiryDateYY.strip()}
        ...    ${CreditCard_ExpiryDateYY.strip()}
        ...    LA_Application
        # Set Calc VP Actual Result With Original And Source    LA_Credit_Card_Status    ${CreditCardStatus}    ${CreditCardStatus}    LA_Application
        # Set Calc VP Actual Result With Original And Source    LA_Credit_Card_Curency    ${CreditCardCurency}    ${CreditCardCurency}    LA_Application
    #    Set Calc VP Actual Result With Original And Source    LA_Credit_Card_Bank_Key    ${CreditCardBankKey}    ${CreditCardBankKey}    LA_Application
    #    Set Calc VP Actual Result With Original And Source    LA_Credit_Card_Bank_Desc    ${CreditCardBankDesc}    ${CreditCardBankDesc}    LA_Application
    #    Set Calc VP Actual Result With Original And Source    LA_Credit_Card_Branch_Desc    ${CreditCardBranchDesc}    ${CreditCardBranchDesc}    LA_Application

        Take AS400 Screenshot
        Execute Command    PA(1)
        Send PF    3
        Execute Command    PA(1)
        Send PF    3
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       LA_Flow   ${reason}   LA Credit Card Maintaince
    END