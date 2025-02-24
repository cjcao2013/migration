*** Settings ***
Library     SeleniumLibrary
Library     QraceHelper
Resource    ../../PageObjects/OWB/OWBInquiryPageObject.resource
Resource    ../../CustomLibraries/Common.robot
Resource    ../../Qrace/QraceHelper.py
Resource    ../../PageObjects/OWB/OWBSwitchFundsPageObjects.resource
Resource    OWBAssignTaskPage.resource


*** Keywords ***
OWB Switch funds
    Wait Until Element Is Visible    ${${lang}_totalFundCount}
    Take OWB Screenshot    Switch Fund Page
    ${VP_totalFundlist}    Get Webelements    ${EN_StotalFundCount}
    Log To Console    ${VP_totalFundlist}
    ${VP_fundcount}    Get Length    ${VP_totalFundlist}
    @{SwitchinoutData_list}    Create List
    @{OWBSOdata_list}    Split String    ${SwitchFund_SwitchOutFundName}    ,
    ${SOLength}    Get Length    ${OWBSOdata_list}
    Log    ${SOLength}

    FOR    ${counter}    IN RANGE    0    ${SOLength}
        ${SOFundName}    Get From List    ${OWBSOdata_list}    ${counter}
        Append To List    ${SwitchinoutData_list}    ${SOFundName}
    END

    @{OWBSIdata_list}    Split String    ${SwitchFund_SwitchInFundName}    ,
    ${SILength}    Get Length    ${OWBSIdata_list}
    Log    ${SILength}
    FOR    ${counter}    IN RANGE    0    ${SILength}
        ${SIFundName}    Get From List    ${OWBSIdata_list}    ${counter}
        Append To List    ${SwitchinoutData_list}    ${SIFundName}
    END
    Log    ${SwitchinoutData_list}
    ${Counterr}    Set Variable    1
    FOR    ${Datacount}    IN RANGE    0    ${VP_fundcount}
        ${fund__Name}    Get From List    ${SwitchinoutData_list}    ${Datacount}
        Wait Until Element Is Visible    xpath=(//div[contains(text(),'${fund__Name}')]/following::td)[3]
        ${VP_switchOutAmountt}    Get Text    xpath=(//div[contains(text(),'${fund__Name}')]/following::td)[4]
        ${VP_switchOutAmount}    Split String    ${VP_switchOutAmountt}
        ${VP_switchOutAmount}    Get From List    ${VP_switchOutAmount}    0
        ${VP_switchOutAmount}    Remove String    ${VP_switchOutAmount}    ,
        ${VP_switchOutAmount}    Evaluate    "{:.2f}".format(${VP_switchOutAmount})
        ${VP_switchOutPerc}    Get Text    xpath=(//div[contains(text(),'${fund__Name}')]/following::td)[5]
        ${VP_switchInAmountt}    Get Text    xpath=(//div[contains(text(),'${fund__Name}')]/following::td)[6]
        ${VP_switchInAmount}    Split String    ${VP_switchInAmountt}
        ${VP_switchInAmount}    Get From List    ${VP_switchInAmount}    0
        ${VP_switchInAmount}    Remove String    ${VP_switchInAmount}    ,
        ${VP_switchInAmount}    Remove String    ${VP_switchInAmount}    %
        ${VP_switchInAmount}    Evaluate    "{:.2f}".format(${VP_switchInAmount})
        ${VP_switchInPerc}    Get Text    xpath=(//div[contains(text(),'${fund__Name}')]/following::td)[7]
        ${VP_valuationDate}    Get Text    xpath=(//div[contains(text(),'${fund__Name}')]/following::td)[8]
        Set Calc VP Expected Result With Original And Source
        ...    Post_Transaction_FundName_${Counterr}
        ...    ${fund__Name}
        ...    ${fund__Name}
        ...    OWB Application
        Set Calc VP Actual Result With Original And Source
        ...    FundName_${Counterr}
        ...    ${fund__Name}
        ...    ${fund__Name}
        ...    OWB Application
        IF    '${VP_switchOutAmount}' != '0.00'
            Set Calc VP Actual Result With Original And Source
            ...    switchOutAmount_${fund__Name}
            ...    ${VP_switchOutAmount}
            ...    ${VP_switchOutAmount}
            ...    OWB Application
            Set Calc VP Expected Result With Original And Source
            ...    Post_Transaction_switchOutAmount_${fund__Name}
            ...    ${VP_switchOutAmount}
            ...    ${VP_switchOutAmount}
            ...    OWB Application
        END

        IF    '${VP_switchOutPerc}' != '0%'
            Set Calc VP Actual Result With Original And Source
            ...    switchOutPercentage_${fund__Name}
            ...    ${VP_switchOutPerc}
            ...    ${VP_switchOutPerc}
            ...    OWB Application
            Set Calc VP Expected Result With Original And Source
            ...    Post_Transaction_switchOutPercentage_${fund__Name}
            ...    ${VP_switchOutPerc}
            ...    ${VP_switchOutPerc}
            ...    OWB Application
        END

        IF    '${VP_switchInAmount}' != '0.00'
            Set Calc VP Actual Result With Original And Source
            ...    switchInAmount_${fund__Name}
            ...    ${VP_switchInAmount}
            ...    ${VP_switchInAmount}
            ...    OWB Application
            Set Calc VP Expected Result With Original And Source
            ...    Post_Transaction_switchInAmount_${fund__Name}
            ...    ${VP_switchInAmount}
            ...    ${VP_switchInAmount}
            ...    OWB Application
        END

        IF    '${VP_switchInPerc}' != '0%'
            Set Calc VP Actual Result With Original And Source
            ...    switchInPercentage_${fund__Name}
            ...    ${VP_switchInPerc}
            ...    ${VP_switchInPerc}
            ...    OWB Application
            Set Calc VP Expected Result With Original And Source
            ...    Post_Transaction_switchInPercentage_${fund__Name}
            ...    ${VP_switchInPerc}
            ...    ${VP_switchInPerc}
            ...    OWB Application
        END

#    Set Calc VP Actual Result With Original And Source    valuationDate_${fund__Name}    ${VP_valuationDate}    ${VP_valuationDate}    OWB Application
        ${Counterr}    Evaluate    ${Counterr}+1
    END

    ${VP_EstimatedTotalSwitchinoutAmount}    Get Element Attribute
    ...    ${EN_VP_EstimatedTotalSwitchinoutAmount}
    ...    attribute=title
    ${VP_EstimatedTotalSwitchinoutAmount}    Remove String    ${VP_EstimatedTotalSwitchinoutAmount}    ,
    ${VP_EstimatedTotalSwitchinoutAmount}    Evaluate    "{:.2f}".format(${VP_EstimatedTotalSwitchinoutAmount})
    Set Calc VP Actual Result With Original And Source
    ...    EstimatedTotalSwitchin/outAmount
    ...    ${VP_EstimatedTotalSwitchinoutAmount.strip()}
    ...    ${VP_EstimatedTotalSwitchinoutAmount}
    ...    OWB Application
    # capture policy no and facta status
#    ${VP_switchfundfactaStatus}    Get Text    ${EN_switchfundfactaStatus}
    ${VP_switchfundPolicyNo}    Get Element Attribute    ${EN_switchfundPolicyNo}    attribute=title
    Set Calc VP Actual Result With Original And Source
    ...    Policy No
    ...    ${VP_switchfundPolicyNo.strip()}
    ...    ${VP_switchfundPolicyNo.strip()}
    ...    OWB Application
#    Set Calc VP Actual Result With Original And Source    Facta_Status    ${VP_switchfundfactaStatus}    ${VP_switchfundfactaStatus}    OWB Application
#    Set Calc VP Expected Result With Original And Source    Post_Transaction_Facta_Status    ${VP_switchfundfactaStatus}    ${VP_switchfundfactaStatus}    OWB Application
    # approval status capture
    Scroll Element Into View    ${${lang}_switchfundApprovalStatus}
    Take OWB Screenshot    Switch Fund Page
    ${Approved_Status}    Get Text    ${${lang}_switchfundApprovalStatus}
    Set Global Variable    ${Approved_Status}
#    Set Calc VP Expected Result With Original And Source    Transaction_Status_After_OWB    ${Approved_Status.strip()}    ${Approved_Status}    OWB_Application
#    Set Calc VP Expected Result With Original And Source    OWB TransactionStatus    ${Approved_Status.strip()}    ${Approved_Status}    OWB_Application
