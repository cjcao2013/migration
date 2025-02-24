*** Settings ***
Library     SeleniumLibrary
Library     QraceHelper
Resource    ../../PageObjects/OPUS/OPUSInquiryPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    ../../Qrace/QraceHelper.py
Resource    ../../PageObjects/OPUS/OPUSSwitchFundsPageObject.resource
Resource    ../../PageObjects/OPUS/OPUSAssignTaskPageObject.resource
Resource    OPUSInquiryPage.resource


*** Keywords ***
OPUS Switch funds
    TRY
        IF    '${OPUSTransactionstatus}' != 'In progress'
                Wait Until Page Contains Element     ${EN_OPUS_DecisionStatus}          timeout=40s
                ${Approved_Status}      Get Text    ${EN_OPUS_DecisionStatus}
                Set Global Variable    ${Approved_Status}
                ${Final_Approve_Status}     Set Variable     ${Approved_Status}
                Set Global Variable    ${Final_Approve_Status}
        ELSE
                Change Decision Status if Non STP
                ${Approved_Status}    Get Element Attribute    ${EN_OPUS_DecisionStatus}       attribute=title
                Set Global Variable    ${Approved_Status}
                ${Final_Approve_Status}         Set Variable                 ${Approved_Status}
                Set Global Variable    ${Final_Approve_Status}
                Set Global Variable    ${Approved_Status}

        END

        ${VP_Completion_Date}      Get Value     ${EN_OPUS_RequestDate}
        Scroll Element Into View    ${EN_OPUS_DecisionStatus}

        ${OPUS_VP_switchfundPolicyNo}    Get Element Attribute    ${EN_OPUS_PolicyNumber}    attribute=value
        Set Calc VP Actual Result With Original And Source
        ...    Policy No
        ...    ${OPUS_VP_switchfundPolicyNo.strip()}
        ...    ${OPUS_VP_switchfundPolicyNo.strip()}
        ...    OPUS Application

        ${SwitchOutFundName}    Get Element Attribute        ${EN_SwitchOutFundName}    attribute=title
        @{words_list1}     Split String    ${SwitchOutFundName}
        ${Switch_Out_FundName}     Get From List    ${words_list1}    -1

        Set Calc VP Expected Result With Original And Source
                ...    Post_Transaction_FundName_1
                ...    ${Switch_Out_FundName}
                ...    ${Switch_Out_FundName}
                ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
                ...    FundName_1
                ...    ${Switch_Out_FundName}
                ...    ${Switch_Out_FundName}
                ...    OPUS Application

        ${SwitchInFundName}    Get Element Attribute    ${EN_SwitchInFundName}    attribute=title
        @{words_list2}     Split String    ${SwitchInFundName}
        ${Switch_In_FundName}     Get From List    ${words_list2}    -1

        Set Calc VP Expected Result With Original And Source
                ...    Post_Transaction_FundName_2
                ...    ${Switch_In_FundName}
                ...    ${Switch_In_FundName}
                ...    OPUS Application
        Set Calc VP Actual Result With Original And Source
                ...    FundName_2
                ...    ${Switch_In_FundName}
                ...    ${Switch_In_FundName}
                ...    OPUS Application

        ${switchout_percent_Text}    Get Element Attribute    ${EN_VP_switchOutPercent}    attribute=value
        ${switchout_percent}    Set Variable    ${switchout_percent_Text}%
        Log To Console    ${switchout_percent}
            IF    '${switchout_percent}' != '0%'
                Set Calc VP Actual Result With Original And Source
                ...    switchOutPercentage_${Switch_Out_FundName}
                ...    ${switchout_percent}
                ...    ${switchout_percent}
                ...    OPUS Application
                Set Calc VP Expected Result With Original And Source
                ...    Post_Transaction_switchOutPercentage_${Switch_Out_FundName}
                ...    ${switchout_percent}
                ...    ${switchout_percent}
                ...    OPUS Application
            END

        ${switchin_Percent_Text}    Get Element Attribute    ${EN_VP_switchInPercent}    attribute=value
        ${switchin_Percent}    Set Variable    ${switchin_Percent_Text}%
        Log To Console    ${switchin_Percent}
            IF    '${switchin_Percent}' != '0%'
                Set Calc VP Actual Result With Original And Source
                ...    switchInPercentage_${Switch_In_FundName}
                ...    ${switchin_Percent}
                ...    ${switchin_Percent}
                ...    OPUS Application
                Set Calc VP Expected Result With Original And Source
                ...    Post_Transaction_switchInPercentage_${Switch_In_FundName}
                ...    ${switchin_Percent}
                ...    ${switchin_Percent}
                ...    OPUS Application
            END

            Set Calc VP With Source And Original Values
                ...    ApprovalStatus
                ...    ${CaseStatus}
                ...    ${Approved_Status}
                ...    Static
                ...    OPUS
                ...    ${CaseStatus}
                ...    ${Approved_Status}

            Set Calc VP Expected Result With Original And Source
                ...    Transaction_Status_After_OPUS
                ...    ${Approved_Status}
                ...    ${Approved_Status}
                ...    OPUS Application

            IF    '${OPUSTransactionstatus}' == 'In progress'

                Click Element    xpath=//button[@data-trigger='submit']
                Take OPUS Screenshot    OPUS Inquiry
                Sleep    10s
            END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       OPUS_Flow   ${reason}   OPUS  ${Insurance_Flow}
    END