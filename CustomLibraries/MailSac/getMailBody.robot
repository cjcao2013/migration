*** Settings ***
Library  RequestsLibrary
Library  OperatingSystem
Library    Collections
Library    String
Library    DateTime
Resource    ../common.robot

*** Variables ***
${url}

*** Keywords ***
Get OTP from Message ID
    TRY
        ${url}      Set Variable      ${base_url}api/dirty/${mailId}/${messageId}
        &{header}=    Create Dictionary       Mailsac-Key=${mailSacKey}
        ${response}=     GET         url=${url}     headers=${header}       verify=${False}
    #    ${messageId}=       Get From Dictionary     ${response.json()}[0]      _id
        Log To Console    ${response.status_code}
        Log    ${response.text}
        ${response_body}        Set Variable        ${response.text}
    #   ${ResBody}   Evaluate       json.dumps(${response.text})
    #    ${response_body}   Convert To String    ${Res_body}
        Create File     ${screenshotPath}\\getMailBody_response.html     ${response_body}
        TRY
             ${OTPArr}      Split String    ${response_body}            10px">
             ${OTP}      Set Variable      ${OTPArr}[1]
             ${OTP}      Fetch From Left    ${OTP}    </h2>
        EXCEPT
            ${OTPArr}      Split String    ${response_body}            </h4> <p
            ${OTP}      Set Variable      ${OTPArr}[1]
            ${OTP}      Fetch From Right    ${OTP}    >
        END
        ${OTPNumber}      Strip String    ${OTP}

        Log    "."${OTPNumber}"."
        Set Global Variable    ${OTPNumber}
    #    **************** Username *******************
        ${Reg_Username}      Set Variable      ${OTPArr}[0]
        ${Reg_Username}      Fetch From Right    ${Reg_Username}    >
        ${Reg_Username}      Strip String    ${Reg_Username}
        Log    "."${Reg_Username}"."
        Set Global Variable    ${Reg_Username}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END

Get COI Information from mail
    [Arguments]     ${emailId}
    TRY
        ${url}      Set Variable      ${base_url}api/dirty/${emailId}/${messageId}
        &{header}=    Create Dictionary       Mailsac-Key=${mailSacKey}
        ${response}=     GET         url=${url}     headers=${header}       verify=${False}
    #    ${messageId}=       Get From Dictionary     ${response.json()}[0]      _id
        Log To Console    ${response.status_code}
        Log    ${response.text}
        ${response_body}        Set Variable        ${response.text}
    #   ${ResBody}   Evaluate       json.dumps(${response.text})
    #    ${response_body}   Convert To String    ${Res_body}
        Create File     ${screenshotPath}\\getCOIMailBody_response.html     ${response_body}

     # COI Header Policy Number
        ${COIArr}      Split String    ${response_body}            Here’s the Insurance Certificate for your
        ${Header}       Set Variable    ${COIArr}[1]
        ${HeaderArr}      Split String    ${Header}                 </h4>
        ${Header2}       Set Variable       ${HeaderArr}[0]
        ${COI_PolicyNo_Header}      Remove String    ${Header2}           ${SPACE}
        Log    "."${COI_PolicyNo_Header}"."
        Set Global Variable    ${COI_PolicyNo_Header}


     # COI Message Name
        ${COIArr}      Split String    ${response_body}            This is to certify that<strong>
        ${MessageName}       Set Variable    ${COIArr}[1]
        ${MessageNameArr}      Split String    ${MessageName}                 </strong>
        ${MessageName2}       Set Variable       ${MessageNameArr}[0]
        ${COI_Message_Name}      Remove String    ${MessageName2}           ${SPACE}
        Log    "."${COI_Message_Name}"."
        @{COI_Message_Name}     Split String    ${COI_Message_Name}     .
        ${COI_Message_Name}     Get From List    ${COI_Message_Name}    1
        Set Global Variable    ${COI_Message_Name}

      # Policy Number
        ${COIArr}      Split String    ${response_body}            Policy Number:
        ${Policy1}      Set Variable      ${COIArr}[1]
        ${PolicyArr1}      Split String    ${Policy1}            <strong>
        ${Policy2}      Set Variable        ${PolicyArr1}[1]
        ${PolicyArr2}       Split String    ${Policy2}            </strong>
        ${Policy}      Set Variable    ${PolicyArr2}[0]
        ${COI_Policy_Number}      Strip String    ${Policy}
        Log    "."${COI_Policy_Number}"."
        Set Global Variable    ${COI_Policy_Number}

     # Policy Owner Name
        ${COIArr}      Split String    ${response_body}            Policy Owner Name :
        ${PolicyOwnerName1}      Set Variable      ${COIArr}[1]
        ${PolicyOwnerNameArr1}      Split String    ${PolicyOwnerName1}            <strong>
        ${PolicyOwnerName2}      Set Variable        ${PolicyOwnerNameArr1}[1]
        ${PolicyOwnerNameArr2}       Split String    ${PolicyOwnerName2}            </strong>
        ${PolicyOwnerName}      Set Variable    ${PolicyOwnerNameArr2}[0]
        ${COI_Policy_Owner_Name}      Strip String    ${PolicyOwnerName}
        Log    "."${COI_Policy_Owner_Name}"."
        Set Global Variable    ${COI_Policy_Owner_Name}

      # Insured Name
        ${COIArr}      Split String    ${response_body}            Insured Name :
        ${InsuredName1}      Set Variable      ${COIArr}[1]
        ${InsuredNameArr1}      Split String    ${InsuredName1}            <strong>
        ${InsuredName2}      Set Variable        ${InsuredNameArr1}[1]
        ${InsuredNameArr2}       Split String    ${InsuredName2}            </strong>
        ${InsuredName}      Set Variable    ${InsuredNameArr2}[0]
        ${COI_Insured_Name}      Strip String    ${InsuredName}
        Log    "."${COI_Insured_Name}"."
        Set Global Variable    ${COI_Insured_Name}

      # Plan Name
        ${COIArr}      Split String    ${response_body}            Plan Name :
        ${PlanName1}      Set Variable      ${COIArr}[1]
        ${PlanNameArr1}      Split String    ${PlanName1}            <strong>
        ${PlanName2}      Set Variable        ${PlanNameArr1}[1]
        ${PlanNameArr2}       Split String    ${PlanName2}            </strong>
        ${PlanName}      Set Variable    ${PlanNameArr2}[0]
        ${COI_PlanName}      Strip String    ${PlanName}
        Log    "."${COI_PlanName}"."
        Set Global Variable    ${COI_PlanName}

      # Sum Assured
        ${COIArr}      Split String    ${response_body}            Sum Assured :
        ${SumAssured1}      Set Variable      ${COIArr}[1]
        ${SumAssuredArr1}      Split String    ${SumAssured1}            <strong>
        ${SumAssured2}      Set Variable        ${SumAssuredArr1}[1]
        ${SumAssuredArr2}       Split String    ${SumAssured2}            </strong>
        ${SumAssured3}      Set Variable    ${SumAssuredArr2}[0]
        ${SumAssuredArr3}       Split String    ${SumAssured3}            &
        ${Currency}         Set Variable        ${SumAssuredArr3}[0]
        ${SumAssured4}         Set Variable        ${SumAssuredArr3}[1]
        ${COI_Currency}      Strip String    ${Currency}
        ${SumAssuredArr4}       Split String    ${SumAssured4}            ;
        ${SumAssured}         Set Variable        ${SumAssuredArr4}[1]
        ${COI_Sum_Assured}      Strip String    ${COI_Currency}${SumAssured}
        Log    "."${COI_Sum_Assured}"."
        ${COI_Sum_Assured}      Remove String    ${COI_Sum_Assured}     ,
        Set Global Variable    ${COI_Sum_Assured}

      # Policy Eﬀective Date
        ${COIArr}      Split String    ${response_body}            Policy Eﬀective Date :
        ${PolicyEﬀectiveDate1}      Set Variable      ${COIArr}[1]
        ${PolicyEﬀectiveDateArr1}      Split String    ${PolicyEﬀectiveDate1}            <strong>
        ${PolicyEﬀectiveDate2}      Set Variable        ${PolicyEﬀectiveDateArr1}[1]
        ${PolicyEﬀectiveDateArr2}       Split String    ${PolicyEﬀectiveDate2}            </strong>
        ${PolicyEﬀectiveDate}      Set Variable    ${PolicyEﬀectiveDateArr2}[0]
        ${COI_Policy_Eﬀective_Date}      Strip String    ${PolicyEﬀectiveDate}
        Log    "."${COI_Policy_Eﬀective_Date}"."
        Set Global Variable    ${COI_Policy_Eﬀective_Date}

      # Status
        ${COIArr}      Split String    ${response_body}            Status :
        ${Status1}      Set Variable      ${COIArr}[1]
        ${StatusArr1}      Split String    ${Status1}            <strong>
        ${Status2}      Set Variable        ${StatusArr1}[1]
        ${StatusArr2}       Split String    ${Status2}            </strong>
        ${Status}      Set Variable    ${StatusArr2}[0]
        ${COI_Status}      Strip String    ${Status}
        Log    "."${COI_Status}"."
        Set Global Variable    ${COI_Status}

     # COI Todays Date
        ${COIArr}      Split String    ${response_body}            This certiﬁcation is being issued on <strong>
        ${TodayDate}       Set Variable    ${COIArr}[1]
        ${TodayDateArr}      Split String    ${TodayDate}                 </strong>
        ${COI_Today_Date}       Set Variable       ${TodayDateArr}[0]
        Log    "."${COI_Today_Date}"."
        Set Global Variable    ${COI_Today_Date}

     # COI Request Name
        ${COIArr}      Split String    ${response_body}            upon request of <strong>
        ${RequestName}       Set Variable    ${COIArr}[1]
        ${RequestNameArr}      Split String    ${RequestName}                 </strong>
        ${COI_Request_Name}       Set Variable       ${RequestNameArr}[0]
        Log    "."${COI_Request_Name}"."
        @{COI_Request_Name}     Split String    ${COI_Request_Name}     .
        ${COI_Request_Name}     Get From List    ${COI_Request_Name}    1
        ${COI_Request_Name}     Strip String    ${COI_Request_Name}
        Set Global Variable    ${COI_Request_Name}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END

Get Transaction Confirmation Email
    [Documentation]         read the email from mailsac for confirmation after email and mobile change
        ${url}      Set Variable      ${base_url}api/dirty/${oldUsername}/${messageId}
        &{header}=    Create Dictionary       Mailsac-Key=${mailSacKey}
        ${response}=     GET         url=${url}     headers=${header}       verify=${False}

        Log To Console    ${response.status_code}
        Log    ${response.text}
        ${response_body}        Set Variable        ${response.text}

        Create File     ${screenshotPath}\\Confirmation_Email_Body_response.html     ${response_body}

        # Capture the Header
        ${Confirmation_Email_Header}      Split String    ${response_body}            h2>
        ${Email_Header}      Set Variable      ${Confirmation_Email_Header}[1]
        ${Email_Header}      Fetch From Left    ${Email_Header}    </h>

        ${Static_Header}        Set Variable            We’ve completed your request.
        Set Calc VP With Source And Original Values    Confimation_Email_header    ${Static_Header}    ${Email_Header}    Static    Mailsac_API    ${Static_Header}    ${Email_Header}

        # Capture the  Email Messgae
        ${Confirmation_Email_Message}      Split String    ${response_body}            16px;">
        ${Email_Message}      Set Variable      ${Confirmation_Email_Message}[1]
        ${Email_Message}      Fetch From Left    ${Email_Message}    </span>



        Set Calc VP With Source And Original Values    Confimation_Email_header    ${Static_Message}    ${Email_Message}    Static    Mailsac_API    ${Static_Message}    ${Email_Message}


