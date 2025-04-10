*** Settings ***
Library     AppiumLibrary
Library     FakerLibrary    locale=en_US
Library     ../../Qrace/QraceHelper.py
Resource    ../../../PageObjects/Insurance/UpdatePolicy/SwitchFundsPageObjects.resource
Resource    ../Common/CommonMethod.resource


*** Keywords ***
Switch funds
    TRY
        Select Policy
        # capture policy details
        ${iOS_EN_FundpolicyName}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS "${Policy_No}"`][-3]/XCUIElementTypeStaticText[-1]
        Wait Until Element Is Visible    ${${platformName}_${lang}_FundpolicyName}    timeout=10s
         # select switch out funds
        @{fundname_data_list}    Split String    ${SwitchFund_SwitchOutFundName}    ,
        ${fundnamecount}    Get Length    ${fundname_data_list}
        Log    ${fundname_data_list}
        FOR    ${counter}    IN RANGE    0    ${fundnamecount}
            Log    ${counter}
            ${fundname}    Get From List    ${fundname_data_list}    ${counter}

            ${iOS_selectfundname}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS'${fundname}'`][-1]
            ${Android_selectfundname}    Set Variable    xpath=//android.widget.TextView[@text='${fundname}']
            ${staus}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_selectfundname}
            ...    timeout=5s
            IF    '${staus}' != 'True'    SwipePage
            Click Element    ${${platformName}_selectfundname}
            Take Screenshot    ${fundname}_FundSelected
        END
        Take Screenshot    OMNE_SwitchFund_SelectedFundPage
        SwipePage
        Click Element    ${${platformName}_${lang}_NextButton}
    #    Check if button is enabled and click    ${${platformName}_${lang}_NextButton}

        # add switch out %
        Wait Until Element Is Visible    ${${platformName}_${lang}_SwitchOutPage}    timeout=10s
        Take Screenshot    Fund_SwitchOut_Page
        @{fundPerc_data_list}    Split String    ${SwitchFund_SwitchOutPerc}    ,
        ${fundPerc_Length}    Get Length    ${fundPerc_data_list}
        Log    ${fundPerc_data_list}

        ${VP_CalculatedTotalEstimatedswitchoutamount}    Set Variable
        FOR    ${Datacount}    IN RANGE    0    ${fundPerc_Length}
            Log    ${Datacount}
            ${fundPerc}    Get From List    ${fundPerc_data_list}    ${Datacount}
            ${FundName}    Get From List    ${fundname_data_list}    ${Datacount}
            ${iOS_selectFundtoAddPerc}    Set Variable
            ...    xpath=//XCUIElementTypeOther[@name='${FundName}']/following-sibling::XCUIElementTypeOther[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeTextField
            ${Android_selectFundtoAddPerc}    Set Variable
            ...    xpath=//android.widget.TextView[@text='${FundName}']/../../android.view.ViewGroup[2]/android.view.ViewGroup[2]/android.widget.EditText
            Wait Until Element Is Visible    ${${platformName}_selectFundtoAddPerc}    timeout=5s
            Clear Text    ${${platformName}_selectFundtoAddPerc}
            IF    '${platformName}' == 'iOS'
                Input Text    ${${platformName}_selectFundtoAddPerc}    ${fundPerc}\n
            ELSE
                Input Text    ${${platformName}_selectFundtoAddPerc}    ${fundPerc}
                Hide Keyboard
            END
            ${iOS_captureSelectedFundestimatedAmount}    Set Variable
            ...    xpath=//XCUIElementTypeOther[@name='${FundName}']/following-sibling::XCUIElementTypeOther[2]/XCUIElementTypeOther[2]
            ${Android_captureSelectedFundestimatedAmount}    Set Variable
            ...    xpath=//android.widget.TextView[@text='${FundName}']/../../android.view.ViewGroup[3]/android.view.ViewGroup[2]/android.widget.TextView
            ${VP_Estimatedswitchoutamount}    Get Text    ${${platformName}_captureSelectedFundestimatedAmount}

            ${VP_Estimatedswitchoutamount}    Remove String    ${VP_Estimatedswitchoutamount}    ,
            ${VP_Estimatedswitchoutamount}    Evaluate    "{:.2f}".format(${VP_Estimatedswitchoutamount})
            ${VP_CalculatedTotalEstimatedswitchoutamount}    Evaluate
            ...    ${VP_CalculatedTotalEstimatedswitchoutamount}+${VP_Estimatedswitchoutamount}
            ${VP_CalculatedTotalEstimatedswitchoutamount}    Evaluate
            ...    "{:.2f}".format(${VP_CalculatedTotalEstimatedswitchoutamount})

            Take Screenshot    OMNE_SwitchFund_SwitchOutPage
            IF    '${Datacount}' != '0'    SwipePage
        END
        ${VP_TotalEstimatedSwitchOutAmount}    Get Text    ${${platformName}_${lang}_TotalEstimatedSwitchOutAmount}
        ${VP_TotalEstimatedSwitchOutAmount}    Remove String    ${VP_TotalEstimatedSwitchOutAmount}    ,
        Set Calc VP With Source And Original Values
        ...    TotalEstimatedSwitchOutAmount
        ...    ${VP_CalculatedTotalEstimatedswitchoutamount}
        ...    ${VP_TotalEstimatedSwitchOutAmount}
        ...    Staic Calculation
        ...    Fund_SwitchOutPage
        ...    ${VP_CalculatedTotalEstimatedswitchoutamount}
        ...    ${VP_TotalEstimatedSwitchOutAmount}
    #    Take Screenshot    OMNE_SwitchFund_SwitchOutPage
        Click Element    ${${platformName}_${lang}_NextButton}
       

        # switch in page
        Scroll Till Transaction Is Visible     ${${platformName}_${lang}_Addnewfunds} 
        Wait Until Element Is Visible    ${${platformName}_${lang}_Addnewfunds}    timeout=60s
        Click Element    ${${platformName}_${lang}_Addnewfunds}

        # add new funds
        
        @{SIdata_list}    Split String    ${SwitchFund_SwitchInFundName}    ,
        ${newfundLength}    Get Length    ${SIdata_list}
        Log    ${SIdata_list}
        FOR    ${counter}    IN RANGE    0    ${newfundLength}
            Log    ${counter}
            ${SIFund}    Get From List    ${SIdata_list}    ${counter}
            ${iOS_selectnewFunds}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${SIFund}'`][-1]
            ${Android_selectnewFunds}    Set Variable    xpath=//android.widget.TextView[@text='${SIFund}']
            Wait Until Element Is Visible    ${${platformName}_selectnewFunds}      timeout=3s
            Click Element    ${${platformName}_selectnewFunds}
            Take Screenshot    New_${SIFund}_Selected
        END
    #    Check if button is enabled and click    ${${platformName}_${lang}_NextButton}
        Click Element    ${${platformName}_${lang}_NextButton}
        ${status}    Run Keyword And Return Status   Wait Until Element Is Visible    ${${platformName}_${lang}_SwitchInPage}    timeout=10s
        IF    '${status}' != 'True'
             Swipe    700    800    700    2500
        END

        Wait Until Element Is Visible    ${${platformName}_${lang}_SwitchInPage}    timeout=10s
        @{SIfundname_List}    Create List
        ${SIfundname}    Get Webelements    ${${platformName}${lang}_switchInFundName}
        ${SIfundnamecount}    Get Length    ${SIfundname}
        Set Global Variable    ${SIfundnamecount}
        Log    ${SIfundnamecount}
        FOR    ${counter}    IN RANGE    0    ${SIfundnamecount}-1
            ${SIfundnamewebelements}    Get From List    ${SIfundname}    ${counter}
            ${SIfund}    Get Text    ${SIfundnamewebelements}
            @{SIFunddata}    Split String    ${SIfund}    View fund
            ${SIfund}    Get From List    ${SIFunddata}    0
            Append To List    ${SIfundname_List}    ${SIfund}
            Log    ${SIfundname_List}
        END
        SwipePage
        # add switch in perc
        ${SIfundname_FinalName_List}    Remove Duplicates    ${SIfundname_List}
        Log    ${SIfundname_FinalName_List}
        ${SIfundFinalcount}    Get Length    ${SIfundname_FinalName_List}
        Log    ${SIfundFinalcount}
        @{data_list}    Split String    ${SwitchFund_SwitchInPerc}    ,
        ${Length}    Get Length    ${data_list}
        Log    ${data_list}
        ${Counterr}    Set Variable    1
        ${VP_TotalEstimatedSwitchInAmount}    Set Variable
        FOR    ${Data_count}    IN RANGE    0    ${Length}
            Log    ${Data_count}
            ${SwitchInfundPerc}    Get From List    ${data_list}    ${Data_count}
            ${SIFund}    Get From List    ${SIdata_list}    ${Data_count}
            ${iOS_clickFundpercField}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${SIFund}'`][-2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeTextField
            ${Android_clickFundpercField}    Set Variable
            ...    xpath=//android.widget.TextView[@text='${SIFund}']/../../android.view.ViewGroup[2]/android.widget.EditText
            Scroll Till Transaction Is Visible     ${${platformName}_clickFundpercField}  
            Wait Until Element Is Visible    ${${platformName}_clickFundpercField}    timeout=10s
            Click Element    ${${platformName}_clickFundpercField}
            Clear Text    ${${platformName}_clickFundpercField}
            Input Text    ${${platformName}_clickFundpercField}    ${SwitchInfundPerc}
            ${iOS_clickSwitchInFundName}    Set Variable    chain=**/XCUIElementTypeOther[`label CONTAINS '${SIFund}'`][-3]
            ${Android_clickSwitchInFundName}    Set Variable    xpath=//android.widget.TextView[@text='${SIFund}']
            Click Element    ${${platformName}_clickSwitchInFundName}

            ${iOS_captureEstimatedSwitchInFundAmount}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${SIFund}'`][-3]/XCUIElementTypeOther[2]/XCUIElementTypeOther[2]
            ${Android_captureEstimatedSwitchInFundAmount}    Set Variable
            ...    xpath=(//android.widget.TextView[@text='${SIFund}']/../../android.view.ViewGroup)/../../android.view.ViewGroup[2]/android.view.ViewGroup[2]/android.widget.TextView
            ${VP_Estimatedswitchinamount}    Get Text    ${${platformName}_captureEstimatedSwitchInFundAmount}
            ${VP_Estimatedswitchinamount}    Remove String    ${VP_Estimatedswitchinamount}    ,
            ${VP_Estimatedswitchinamount}    Evaluate    "{:.2f}".format(${VP_Estimatedswitchinamount})
            ${VP_TotalEstimatedSwitchInAmount}    Evaluate
            ...    ${VP_TotalEstimatedSwitchInAmount}+ ${VP_Estimatedswitchinamount}
            ${VP_TotalEstimatedSwitchInAmount}    Evaluate    "{:.2f}".format(${VP_TotalEstimatedSwitchInAmount})
            SwipePage
        END
        Take Screenshot    OMNE_SwitchFund_SwitchInPage
    #    Capture Fund Error Msg
        Click Element    ${${platformName}_${lang}_NextButton}
        ${Status}       Run Keyword And Return Status     Wait Until Element Is Visible    ${${platformName}_${lang}_Accept}    timeout=10s
        IF    '${Status}' == 'True'
             Click Element    ${${platformName}_${lang}_Accept}
        END
         # -------------------------------------------------------Summary Page-----------------------------------------------------------------------------------------------------------

        @{SOdata_list}    Split String    ${SwitchFund_SwitchOutFundName}    ,
        ${SOdata_Length}    Get Length    ${SOdata_list}
        Set Global Variable    ${SOdata_list}
        Set Global Variable    ${SOdata_Length}
        ${Counterr}    Set Variable    1
        FOR    ${counter}    IN RANGE    0    ${SOdata_Length}
            Log    ${counter}
            ${SOFund}    Get From List    ${SOdata_list}    ${counter}
    #    Take Screenshot    Summary_SwitchOut_Fund
            ${iOS_captureSIFundEstimatedswitchoutamount}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${SOFund}'`][-1]/XCUIElementTypeOther/XCUIElementTypeStaticText[2]
            ${Android_captureSIFundEstimatedswitchoutamount}    Set Variable
            ...    xpath=//android.widget.TextView[@text='${SOFund}']/following-sibling::android.widget.TextView[2]
            Wait Until Page Contains Element    ${${platformName}_captureSIFundEstimatedswitchoutamount}        timeout=10s
            ${VP_SIFundEstimatedswitchoutamount}    Get Text    ${${platformName}_captureSIFundEstimatedswitchoutamount}
            ${VP_SIFundEstimatedswitchoutamount}    Remove String    ${VP_SIFundEstimatedswitchoutamount}    THB
            ${VP_SIFundEstimatedswitchoutamount}    Remove String    ${VP_SIFundEstimatedswitchoutamount}    ,
            ${VP_SIFundEstimatedswitchoutamount}    Remove String    ${VP_SIFundEstimatedswitchoutamount}    ${SPACE}
            ${VP_SIFundEstimatedswitchoutamount}    Evaluate    "{:.2f}".format(${VP_SIFundEstimatedswitchoutamount})

            Set Calc VP Expected Result With Original And Source
            ...    Summary_SwitchOutFundName_${Counterr}
            ...    ${SOFund}
            ...    ${SOFund}
            ...    OMNE_SwitchOutFundSummaryPage
            Set Calc VP Expected Result With Original And Source
            ...    Summary_EstimatedSwitchOutamount_${SOFund}
            ...    ${VP_SIFundEstimatedswitchoutamount.strip()}
            ...    ${VP_SIFundEstimatedswitchoutamount.strip()}
            ...    OMNE_SwitchOutFundSummaryPage
            ${Counterr}    Evaluate    ${Counterr}+1
        END

        @{SIdata_list}    Split String    ${SwitchFund_SwitchInFundName}    ,
        ${SIdata_Length}    Get Length    ${SIdata_list}
        Set Global Variable    ${SIdata_list}
        Set Global Variable    ${SIdata_Length}
        ${Counterr}    Set Variable    1
        FOR    ${counter}    IN RANGE    0    ${SIdata_Length}
            Log    ${counter}
            ${SIFund}    Get From List    ${SIdata_list}    ${counter}
    #    Take Screenshot    Summary_SwitchIN_Fund
            ${iOS_captureestimatedswitchinamount}    Set Variable
            ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${SIFund}'`][-1]/XCUIElementTypeOther/XCUIElementTypeStaticText[3]
            ${Android_captureestimatedswitchinamount}    Set Variable
            ...    xpath=//android.widget.TextView[@text='${SIFund}']/following-sibling::android.widget.TextView[2]
            ${VP_SIFundEstimatedswitchinamount}    Get Text    ${${platformName}_captureestimatedswitchinamount}
            ${VP_SIFundEstimatedswitchinamount}    Remove String    ${VP_SIFundEstimatedswitchinamount}    THB
            ${VP_SIFundEstimatedswitchinamount}    Remove String    ${VP_SIFundEstimatedswitchinamount}    ,
            ${VP_SIFundEstimatedswitchinamount}    Remove String    ${VP_SIFundEstimatedswitchinamount}    ${SPACE}
            ${VP_SIFundEstimatedswitchinamount}    Evaluate    "{:.2f}".format(${VP_SIFundEstimatedswitchinamount})

            Set Calc VP Expected Result With Original And Source
            ...    Summary_SwitchInFundName_${Counterr}
            ...    ${SIFund}
            ...    ${SIFund}
            ...    OMNE_SwitchInFundSummaryPage
            Set Calc VP Expected Result With Original And Source
            ...    Summary_EstimatedSwitchInamount_${SIFund}
            ...    ${VP_SIFundEstimatedswitchinamount.strip()}
            ...    ${VP_SIFundEstimatedswitchinamount.strip()}
            ...    OMNE_SwitchInFundSummaryPage
            ${Counterr}    Evaluate    ${Counterr}+1
        END

        ${VP_Estimatedtotalswitchoutinamount}    Get Text    ${${platformName}_${lang}_Estimatedtotalswitchoutinamount}
        ${VP_Estimatedtotalswitchoutinamount}    Remove String    ${VP_Estimatedtotalswitchoutinamount}    THB
        ${VP_Estimatedtotalswitchoutinamount}    Remove String    ${VP_Estimatedtotalswitchoutinamount}    ,
        ${VP_Estimatedtotalswitchoutinamount}    Evaluate    "{:.2f}".format(${VP_Estimatedtotalswitchoutinamount})

    #    Set Calc VP Expected Result With Original And Source
    #    ...    EstimatedTotalSwitchin/outAmount
    #    ...    ${VP_Estimatedtotalswitchoutinamount.strip()}
    #    ...    ${VP_Estimatedtotalswitchoutinamount}
    #    ...    OMNE_SwitchInFundSummaryPage

        # -------------------------------------------------------------------------------------------------------------------------------------------------------------------

        Wait Until Element Is Visible    ${${platformName}_${lang}_confirm}    timeout=60s
        Click Element    ${${platformName}_${lang}_confirm}
        SwipePage
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_acknowledgeChkBox}
        ...    timeout=5s
        IF    '${status}' != 'True'
            WHILE    '${status}' != 'True'
                SwipePage
                ${status}    Run Keyword And Return Status
                ...    Wait Until Element Is Visible
                ...    ${${platformName}_${lang}_acknowledgeChkBox}
                ...    timeout=5s
                IF    '${status}' != 'True'
                    Click Element    ${${platformName}_${lang}_acknowledgeChkBox}
                END
            END
        ELSE
            Click Element    ${${platformName}_${lang}_acknowledgeChkBox}
        END
        Take Screenshot    SwitchFund_SummaryPage
        Wait Until Element Is Visible    ${${platformName}_${lang}_SubmitButton}    timeout=10s
        # Previous OTP from DB
        Get Details from DB
        ${Previous_OTP}    Set Variable    ${OTPNumber}
        Set Global Variable    ${Previous_OTP}
        Click Element    ${${platformName}_${lang}_SubmitButton}
        IF    '${Fatca_Status}' == 'Yes'    Run Keywords    FATCA Status Change
        Run Keyword
        ...    Insert OTP
        ...    ${Transaction_OTP_Source}
        ...    ${Transaction_OTP_Expiry_Flag}
        ...    ${Transaction_OTP_Resend_Flag}

        # -----------------------------------------------------------Transaction Page---------------------------------------------------------------------------------
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_serviceRequestTransaction}
        ...    timeout=5s
        Set Calc VP With Source And Original Values
        ...    Thanks Page Present
        ...    true
        ...    ${status}
        ...    Static
        ...    Omne Application
        ...    true
        ...    ${status}
        Take Screenshot    OMNE_SwitchFund_Thanks_Page
        Run Keyword    Check Transaction Status
        Wait Until Element Is Visible    ${${platformName}_${lang}_SeeAll}   timeout=20s
        Click Element    ${${platformName}_${lang}_SeeAll}
        Take Screenshot    Transaction_Page
        Wait Until Page Contains Element    ${${platformName}_${lang}_ServiceReuest}    timeout=50s
        Click Element    ${${platformName}_${lang}_ServiceReuest}
        Take Screenshot    Transaction_Page
        Run Keyword    Capture Fund Switch Transaction Details    Pre

        Set Global Variable    ${result}    Switch fund Passed Successfully for policy : ${Policy_No}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END
Capture Fund Switch Transaction Details
    [Arguments]    ${Transaction_Info}

    IF    '${Transaction_Info}'== 'Pre'
        ${iOS_selectCurrentTransaction1}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Fund Switch' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    ELSE IF    '${Transaction_Info}'== 'Post'
        ${MCaseStatus}     Set Variable     Completed
        ${iOS_selectCurrentTransaction1}    Set Variable
        ...    chain=**/XCUIElementTypeOther[`label CONTAINS '${currdate}' and label CONTAINS 'Fund Switch ${MCaseStatus}' and label CONTAINS 'Policy no: ${Policy_No}'`][27]
    END
    Log    ${${platformName}_selectCurrentTransaction1}
    RefreshPage

    Scroll Till Transaction Is Visible    ${${platformName}_selectCurrentTransaction1}
    Wait Until Element Is Visible    ${${platformName}_selectCurrentTransaction1}    timeout=300s
    Take Screenshot    Transaction Page

    ${transactionstatus}    Get Text    ${${platformName}_selectCurrentTransaction1}
    @{Trans_FundSwitchStatus}    Split String    ${transactionstatus}    Fund Switch
    ${FundTransactionStatusdata}    Get From List    ${Trans_FundSwitchStatus}    1
    @{FundTransactionDetail}    Split String    ${FundTransactionStatusdata}    Policy no:
    ${VP_Trans_FundSwitchStatus}    Get From List    ${FundTransactionDetail}    0
    ${VP_Trans_PolicyNumber}    Get From List    ${FundTransactionDetail}    1
    ${VP_Trans_PolicyNumber}    Split String    ${VP_Trans_PolicyNumber}    Switch out
    ${VP_Trans_PolicyNumber}    Get From List    ${VP_Trans_PolicyNumber}    0
    Set Calc VP Expected Result With Original And Source
    ...    Policy No
    ...    ${VP_Trans_PolicyNumber.strip()}
    ...    ${VP_Trans_PolicyNumber.strip()}
    ...    Omne_TransactionPage
    IF    '${VP_Trans_FundSwitchStatus.strip()}' == 'In progress'
        ${VP_Trans_FundSwitchStatus}    Set Variable    In Progress
        ${OPUSTransactionstatus}    Set Variable    In progress
        Set Global Variable    ${OPUSTransactionstatus}
    ELSE IF    '${VP_Trans_FundSwitchStatus.strip()}' == 'Completed'
        ${VP_Trans_FundSwitchStatus}    Set Variable    Approve
        ${OPUSTransactionstatus}    Set Variable    Completed
         Set Global Variable    ${OPUSTransactionstatus}
    END
    IF    '${Transaction_Info}'== 'Pre'
        Set Calc VP Expected Result With Original And Source
        ...    Transaction_Status
        ...    ${VP_Trans_FundSwitchStatus.strip()}
        ...    ${VP_Trans_FundSwitchStatus.strip()}
        ...    OMNE_SwitchFundTransactionPage
    END
    Click Element    ${${platformName}_selectCurrentTransaction1}

    # Capture Fund details from transaction page
    IF    '${platformName}' == 'iOS'
        Scroll Till Transaction Is Visible    ${${platformName}_${lang}_FundTransactionDetails}
        Wait Until Element Is Visible    ${${platformName}_${lang}_FundTransactionDetails}    timeout=20s
        Take Screenshot    FundSwitch_TransactionPage
    ELSE
        Scroll Till Transaction Is Visible    xpath=//android.widget.TextView[@text='Switch out amount']
        Wait Until Element Is Visible    xpath=//android.widget.TextView[@text='Switch out amount']    timeout=20s
        Take Screenshot    FundSwitch_TransactionPage
    END

    IF    '${platformName}' == 'iOS'
        ${VP_FundTransactionDetails}    Get Text    ${${platformName}_${lang}_FundTransactionDetails}
        @{VP_transactiondetailList}    Split String    ${VP_FundTransactionDetails}    Policy no: ${policyno}
        ${VP_FundTransactionDetails}    Get From List    ${VP_transactiondetailList}    1
    END
    ${fundCounterr}    Set Variable    1

    # capture switch out funddetails
    FOR    ${counter}    IN RANGE    0    ${SOdata_Length}
        Log    ${counter}
#    ${indexcounter}    Evaluate    ${counter}+1
        ${FundName}    Get From List    ${SOdata_list}    ${counter}
        IF    '${platformName}' == 'Android'
            ${indexcounter}    Set Variable    1
            Scroll Till Transaction Is Visible
            ...    xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[1]
            ${capturefundname}    Get Text
            ...    xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[1]
            IF    '${capturefundname.strip()}' == '${FundName}'
                ${status}    Set Variable    True
            ELSE
                ${status}    Set Variable    False
            END
            WHILE    '${status}' == 'False'
                ${indexcounter}    Evaluate    ${indexcounter}+1
                ${capturefundname}    Get Text
                ...    xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[1]
                IF    '${capturefundname.strip()}' == '${FundName}'
                    ${status}    Set Variable    True
                ELSE
                    ${status}    Set Variable    False
                END
            END
            Scroll Till Transaction Is Visible
            ...    xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[2]
            ${switchinfundperc}    Get Text
            ...    xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[2]
            Log To Console    SwitchOutFund_${FundName}_Percentage : ${switchinfundperc}
            ${switchinfundvalue}    Get Text
            ...    xpath=//android.widget.TextView[contains(@text,'Switch out amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[3]
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    THB
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ${SPACE}
            Log To Console    SwitchOutFund_${FundName}_Value : ${switchinfundvalue}
        ELSE
            @{transswitchinfunddetails}    Split String    ${VP_FundTransactionDetails}    ${FundName}
            ${transswitchinfunddetails}    Get From List    ${transswitchinfunddetails}    1
            @{sitchinfunddatasplit}    Split String    ${transswitchinfunddetails}
            ${switchinfundperc}    Get From List    ${sitchinfunddatasplit}    0
            Log To Console    SwitchOutFund_${FundName}_Percentage : ${switchinfundperc}
            ${switchinfundvalue}    Get From List    ${sitchinfunddatasplit}    2
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
            Log To Console    SwitchOutFund_${FundName}_Value : ${switchinfundvalue}
        END
        IF    '${Transaction_Info}' == 'Pre'
            Set Calc VP Expected Result With Original And Source
            ...    FundName_${fundCounterr}
            ...    ${FundName}
            ...    ${FundName}
            ...    OMNE_TransactionPage
            #    ${fundcode}    Get FundCode From Dic    ${FundName.strip()}
            #    Set Calc VP Expected Result With Original And Source    LA_Switch_Out_FundName_${fundCounterr}    ${fundcode}    ${fundcode}    OMNE_TransactionPage
#            Set Calc VP Expected Result With Original And Source
#            ...    switchOutAmount_${FundName}
#            ...    ${switchinfundvalue.strip()}
#            ...    ${switchinfundvalue.strip()}
#            ...    OMNE_TransactionPage
            Set Calc VP Actual Result With Original And Source
            ...    Summary_SwitchOutFundName_${fundCounterr}
            ...    ${FundName}
            ...    ${FundName}
            ...    OMNE_TransactionPage
            Set Calc VP Actual Result With Original And Source
            ...    Summary_EstimatedSwitchOutamount_${FundName}
            ...    ${switchinfundvalue}
            ...    ${switchinfundvalue}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    switchOutPercentage_${FundName}
            ...    ${switchinfundperc}
            ...    ${switchinfundperc}
            ...    OMNE_TransactionPage
        ELSE
            Set Calc VP Actual Result With Original And Source
            ...    Post_Transaction_FundName_${fundCounterr}
            ...    ${FundName}
            ...    ${FundName}
            ...    OMNE_TransactionPage
#            Set Calc VP Actual Result With Original And Source
#            ...    Post_Transaction_switchOutAmount_${FundName}
#            ...    ${switchinfundvalue}
#            ...    ${switchinfundvalue}
#            ...    OMNE_TransactionPage
            #    Set Calc VP Actual Result With Original And Source    Post_Transaction_Summary_SwitchOutFundName_${fundCounterr}    ${FundName}    ${FundName}    OMNE_TransactionPage
            #    Set Calc VP Actual Result With Original And Source    Post_Transaction_Summary_EstimatedSwitchOutamount_${FundName}    ${switchinfundvalue}    ${switchinfundvalue}    OMNE_TransactionPage
#            Set Calc VP Actual Result With Original And Source
#            ...    Post_Transaction_switchOutPercentage_${FundName}
#            ...    ${switchinfundperc}
#            ...    ${switchinfundperc}
#            ...    OMNE_TransactionPage
        END
        ${fundCounterr}    Evaluate    ${fundCounterr}+1
    END

    # capture switch in fund details
    ${summaryfundCounterr}    Set Variable    1
    FOR    ${counter}    IN RANGE    0    ${SIdata_Length}
        Log    ${counter}
#    ${indexcounter}    Evaluate    ${counter}+1
        ${FundName}    Get From List    ${SIdata_list}    ${counter}
        IF    '${platformName}' == 'Android'
            ${indexcounter}    Set Variable    1
            ${capturefundname}    Get Text
            ...    xpath=//android.widget.TextView[contains(@text,'Switch in amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[1]
            IF    '${capturefundname.strip()}' == '${FundName}'
                ${status}    Set Variable    True
            ELSE
                ${status}    Set Variable    False
            END
            WHILE    '${status}' == 'False'
                ${indexcounter}    Evaluate    ${indexcounter}+1
                ${capturefundname}    Get Text
                ...    xpath=//android.widget.TextView[contains(@text,'Switch in amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[1]
                IF    '${capturefundname.strip()}' == '${FundName}'
                    ${status}    Set Variable    True
                ELSE
                    ${status}    Set Variable    False
                END
            END
            ${switchinfundperc}    Get Text
            ...    xpath=//android.widget.TextView[contains(@text,'Switch in amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[2]
            Log To Console    SwitchOutFund_${FundName}_Percentage : ${switchinfundperc}
            ${switchinfundvalue}    Get Text
            ...    xpath=//android.widget.TextView[contains(@text,'Switch in amount')]/following-sibling::android.view.ViewGroup[${indexcounter}]//android.widget.TextView[3]
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    THB
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ${SPACE}
            Log To Console    SwitchOutFund_${FundName}_Value : ${switchinfundvalue}
        ELSE
            @{transswitchinfunddetails}    Split String    ${VP_FundTransactionDetails}    ${FundName}
            ${transswitchinfunddetails}    Get From List    ${transswitchinfunddetails}    1
            @{sitchinfunddatasplit}    Split String    ${transswitchinfunddetails}
            ${switchinfundperc}    Get From List    ${sitchinfunddatasplit}    0
            Log To Console    SwitchInFund_${FundName}_Percentage : ${switchinfundperc}
            ${switchinfundvalue}    Get From List    ${sitchinfunddatasplit}    2
            ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
            Log To Console    SwitchInFund_${FundName}_Value : ${switchinfundvalue}
        END
        IF    '${Transaction_Info}'== 'Pre'
            Set Calc VP Expected Result With Original And Source
            ...    FundName_${fundCounterr}
            ...    ${FundName}
            ...    ${FundName}
            ...    OMNE_TransactionPage
            #    ${fundcode}    Get FundCode From Dic    ${FundName.strip()}
            #    Set Calc VP Expected Result With Original And Source    LA_Switch_In_FundName_${fundCounterr}    ${fundcode}    ${fundcode}    OMNE_TransactionPage
#            Set Calc VP Expected Result With Original And Source
#            ...    switchInAmount_${FundName}
#            ...    ${switchinfundvalue.strip()}
#            ...    ${switchinfundvalue.strip()}
#            ...    OMNE_TransactionPage
            Set Calc VP Actual Result With Original And Source
            ...    Summary_SwitchInFundName_${summaryfundCounterr}
            ...    ${FundName}
            ...    ${FundName}
            ...    OMNE_TransactionPage
            Set Calc VP Actual Result With Original And Source
            ...    Summary_EstimatedSwitchInamount_${FundName}
            ...    ${switchinfundvalue}
            ...    ${switchinfundvalue}
            ...    OMNE_TransactionPage
            Set Calc VP Expected Result With Original And Source
            ...    switchInPercentage_${FundName}
            ...    ${switchinfundperc}
            ...    ${switchinfundperc}
            ...    OMNE_TransactionPage
        ELSE
            Set Calc VP Actual Result With Original And Source
            ...    Post_Transaction_FundName_${fundCounterr}
            ...    ${FundName}
            ...    ${FundName}
            ...    OMNE_TransactionPage
#            Set Calc VP Actual Result With Original And Source
#            ...    Post_Transaction_switchInAmount_${FundName}
#            ...    ${switchinfundvalue}
#            ...    ${switchinfundvalue}
#            ...    OMNE_TransactionPage
            Set Calc VP Actual Result With Original And Source
            ...    Post_Transaction_switchInPercentage_${FundName}
            ...    ${switchinfundperc}
            ...    ${switchinfundperc}
            ...    OMNE_TransactionPage
            #    Set Calc VP Actual Result With Original And Source    Post_Transaction_Summary_SwitchOutFundName_${fundCounterr}    ${FundName}    ${FundName}    OMNE_TransactionPage
            #    Set Calc VP Actual Result With Original And Source    Post_Transaction_Summary_EstimatedSwitchOutamount_${FundName}    ${switchinfundvalue}    ${switchinfundvalue}    OMNE_TransactionPage
        END
        ${fundCounterr}    Evaluate    ${fundCounterr}+1
        ${summaryfundCounterr}    Evaluate    ${summaryfundCounterr}+1
    END
    SwipePage

    Take Screenshot    FundSwitch_TransactionPage
    # capture fatca status
#    END

#    IF    '${platformName}' == 'Android'
#    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_FundTransactionDetails}
#    Wait Until Element Is Visible    ${${platformName}_${lang}_FundTransactionDetails}    timeout=20s
#    Take Screenshot    FundSwitch_TransactionPage
#    ${VP_FundTransactionDetails}    Get Text    ${${platformName}_${lang}_FundTransactionDetails}
##
#    END
#
#    IF    '${Transaction_Info}'== 'Post'
#    Scroll Till Transaction Is Visible    ${${platformName}_${lang}_selectCurrentTransaction1}
#    Take Screenshot    FundSwitch_TransactionPage
#    ${VP_FundTransactionDetails}    Get Text    ${${platformName}_${lang}_selectCurrentTransaction1}
#    @{VP_transactiondetailList}    Split String    ${VP_FundTransactionDetails}    Policy no: ${policyno}
#    ${VP_FundTransactionDetails}    Get From List    ${VP_transactiondetailList}    1
#    ${fundCounterr}    Set Variable    1
#
#    #capture switch out funddetails
#    @{SOdata_list}    Split String    ${SwitchFund_SwitchOutFundName}    ,
#    ${SOdata_Length}=    Get Length    ${SOdata_list}
#    Set Global Variable    ${SOdata_Length}
#    Set Global Variable    ${SOdata_list}
#
#    FOR    ${counter}    IN RANGE    0    ${SOdata_Length}
#    Log    ${counter}
#    ${FundName}    Get From List    ${SOdata_list}    ${counter}
#    IF    '${platformName}' == 'Android'
#    ${switchinfundperc}    Get Text    ${${platformName}_${lang}_Trans_OutPerc}
#    Log To Console    SwitchOutFund_${FundName}_Percentage : ${switchinfundperc}
#    ${switchinfundvalue}    Get Text    ${${platformName}_${lang}_Trans_OutFundValue}
#    ${switchinfundvalue}    Remove String    ${switchinfundvalue}    THB
#    ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
#    ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ${SPACE}
#    Log To Console    SwitchOutFund_${FundName}_Value : ${switchinfundvalue}
#    ELSE
#    @{transswitchinfunddetails}    Split String    ${VP_FundTransactionDetails}    ${FundName}
#    ${transswitchinfunddetails}    Get From List    ${transswitchinfunddetails}    1
#    @{sitchinfunddatasplit}    Split String    ${transswitchinfunddetails}
#    ${switchinfundperc}    Get From List    ${sitchinfunddatasplit}    0
#    Log To Console    SwitchOutFund_${FundName}_Percentage : ${switchinfundperc}
#    ${switchinfundvalue}    Get From List    ${sitchinfunddatasplit}    2
#    ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
#    Log To Console    SwitchOutFund_${FundName}_Value : ${switchinfundvalue}
#    END
#    Set Calc VP Actual Result With Original And Source    Post_Transaction_FundName_${fundCounterr}    ${FundName}    ${FundName}    OMNE_TransactionPage
#    Set Calc VP Actual Result With Original And Source    Post_Transaction_switchOutAmount_${FundName}    ${switchinfundvalue}    ${switchinfundvalue}    OMNE_TransactionPage
##    Set Calc VP Actual Result With Original And Source    Post_Transaction_Summary_SwitchOutFundName_${fundCounterr}    ${FundName}    ${FundName}    OMNE_TransactionPage
##    Set Calc VP Actual Result With Original And Source    Post_Transaction_Summary_EstimatedSwitchOutamount_${FundName}    ${switchinfundvalue}    ${switchinfundvalue}    OMNE_TransactionPage
#    Set Calc VP Actual Result With Original And Source    Post_Transaction_switchOutPercentage_${FundName}    ${switchinfundperc}    ${switchinfundperc}    OMNE_TransactionPage
#
#    ${fundCounterr}    Evaluate    ${fundCounterr}+1
#    END
#
#    #capture switch in fund details
#    @{SIdata_list}    Split String    ${SwitchFund_SwitchInFundName}    ,
#    ${SIdata_Length}=    Get Length    ${SIdata_list}
#    Set Global Variable    ${SIdata_list}
#    ${summaryfundCounterr}    Set Variable    1
#    FOR    ${counter}    IN RANGE    0    ${SIdata_Length}
#    Log    ${counter}
#    ${FundName}    Get From List    ${SIdata_list}    ${counter}
#    IF    '${platformName}' == 'Android'
#    ${switchinfundperc}    Get Text    ${${platformName}_${lang}_Trans_INPerc}
#    Log To Console    SwitchOutFund_${FundName}_Percentage : ${switchinfundperc}
#    ${switchinfundvalue}    Get Text    ${${platformName}_${lang}_Trans_INFundValue}
#    ${switchinfundvalue}    Remove String    ${switchinfundvalue}    THB
#    ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
#    ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ${SPACE}
#    Log To Console    SwitchOutFund_${FundName}_Value : ${switchinfundvalue}
#    ELSE
#    @{transswitchinfunddetails}    Split String    ${VP_FundTransactionDetails}    ${FundName}
#    ${transswitchinfunddetails}    Get From List    ${transswitchinfunddetails}    1
#    @{sitchinfunddatasplit}    Split String    ${transswitchinfunddetails}
#    ${switchinfundperc}    Get From List    ${sitchinfunddatasplit}    0
#    Log To Console    SwitchInFund_${FundName}_Percentage : ${switchinfundperc}
#    ${switchinfundvalue}    Get From List    ${sitchinfunddatasplit}    2
#    ${switchinfundvalue}    Remove String    ${switchinfundvalue}    ,
#    Log To Console    SwitchInFund_${FundName}_Value : ${switchinfundvalue}
#    END
#    Set Calc VP Actual Result With Original And Source    Post_Transaction_FundName_${fundCounterr}    ${FundName}    ${FundName}    OMNE_TransactionPage
#    Set Calc VP Actual Result With Original And Source    Post_Transaction_switchInAmount_${FundName}    ${switchinfundvalue}    ${switchinfundvalue}    OMNE_TransactionPage
#    Set Calc VP Actual Result With Original And Source    Post_Transaction_switchInPercentage_${FundName}    ${switchinfundperc}    ${switchinfundperc}    OMNE_TransactionPage
#    ${fundCounterr}    Evaluate    ${fundCounterr}+1
#    ${summaryfundCounterr}    Evaluate    ${summaryfundCounterr}+1
#    END
#    SwipePage
#
#    Take Screenshot    FundSwitch_TransactionPage
#    END

Capture Fund Error Msg
    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${lang}_Error_MSg_wholenumber}
    ...    timeout=2s
    IF    '${status}' == 'True'
        ${VP_wholenumber}    Get Text    ${${lang}_Error_MSg_wholenumber}
        Set Global Variable    ${errormsg}    ${VP_wholenumber}
        Set Calc VP With Source And Original Values
        ...    Decimal value error
        ...    Please enter a whole number.
        ...    ${VP_wholenumber}
        ...    Static
        ...    OMNE_SwitchFundPage
        ...    Please enter a whole number.
        ...    ${VP_wholenumber}
    END

    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${lang}_Error_MSg_Maxamount}
    ...    timeout=2s
    IF    '${status}' == 'True'
        ${VP_Maxamount}    Get Text    ${${lang}_Error_MSg_Maxamount}
        Set Global Variable    ${errormsg}    ${VP_Maxamount}
        Set Calc VP With Source And Original Values
        ...    Value error
        ...    Your maximum value entered should not be more than 100%.
        ...    ${VP_Maxamount}
        ...    Static
        ...    OMNE_SwitchFundPage
        ...    Your maximum value entered should not be more than 100%.
        ...    ${VP_Maxamount}
    END

    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${EN_Error_MSgtotalswitchinperc}
    ...    timeout=2s
    IF    '${status}' == 'True'
        ${VP_totalswitchinperc}    Get Text    ${EN_Error_MSgtotalswitchinperc}
        Set Global Variable    ${errormsg}    ${VP_totalswitchinperc}
        Set Calc VP With Source And Original Values
        ...    Total Switch In Percentage error
        ...    Your total switch in percentage should sum up to 100%.
        ...    ${VP_totalswitchinperc}
        ...    Static
        ...    OMNE_SwitchFundPage
        ...    Your total switch in percentage should sum up to 100%.
        ...    ${VP_totalswitchinperc}
    END

    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${lang}_Error_MSgminvalueerror}
    ...    timeout=2s
    IF    '${status}' == 'True'
        ${VP_minimumvalueerror}    Get Text    ${${lang}_Error_MSgminvalueerror}
        Set Global Variable    ${errormsg}    ${VP_minimumvalueerror}
        Set Calc VP With Source And Original Values
        ...    SwitchIn min value error
        ...    Your minimum value entered should not be less than 5%.
        ...    ${VP_minimumvalueerror}
        ...    Static
        ...    OMNE_SwitchFundPage
        ...    Your minimum value entered should not be less than 5%.
        ...    ${VP_minimumvalueerror}
    END

    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${lang}_Error_Msg_BalanceAmount}
    ...    timeout=2s
    IF    '${status}' == 'True'
        ${VP_Error_Msg_BalanceAmount}    Get Text    ${${lang}_Error_Msg_BalanceAmount}
        Set Global Variable    ${errormsg}    ${VP_Error_Msg_BalanceAmount}
        Set Calc VP With Source And Original Values
        ...    SwitchIn min value error
        ...    Please enter a smaller value or enter a value of 100%.
        ...    ${VP_Error_Msg_BalanceAmount}
        ...    Static
        ...    OMNE_SwitchFundPage
        ...    Please enter a smaller value or enter a value of 100%.
        ...    ${VP_Error_Msg_BalanceAmount}
    END

    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${lang}_Error_MSg_remainingBalance}
    ...    timeout=2s
    IF    '${status}' == 'True'
        ${VP_Error_MSg_remainingBalance}    Get Text    ${${lang}_Error_MSg_remainingBalance}
        Set Global Variable    ${errormsg}    ${VP_Error_MSg_remainingBalance}
        Set Calc VP With Source And Original Values
        ...    Remaining balance Amount error
        ...    The remaining balance amount in your fund will be less than THB 1,000.00.
        ...    ${VP_Error_MSg_remainingBalance}
        ...    Static
        ...    OMNE_SwitchFundPage
        ...    The remaining balance amount in your fund will be less than THB 1,000.00.
        ...    ${VP_Error_MSg_remainingBalance}
    END

    ${status}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    ${${lang}_Error_Msg_minSwitchOutAmount}
    ...    timeout=2s
    IF    '${status}' == 'True'
        ${VP_Error_Msg_minSwitchOutAmount}    Get Text    ${${lang}_Error_Msg_minSwitchOutAmount}
        Set Global Variable    ${errormsg}    ${VP_Error_Msg_minSwitchOutAmount}
        Set Calc VP With Source And Original Values
        ...    Fund Switch Minimum Amount error
        ...    The minimum amount for fund switching is THB 5,000.00.
        ...    ${VP_Error_Msg_minSwitchOutAmount}
        ...    Static
        ...    OMNE_SwitchFundPage
        ...    The minimum amount for fund switching is THB 1,000.00.
        ...    ${VP_Error_Msg_minSwitchOutAmount}
    END
