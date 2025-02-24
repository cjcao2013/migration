*** Settings ***
Library     AppiumLibrary
Library     SeleniumLibrary
Library     ../../DBQuery/DBQuerySelect.py
Library     QraceHelper
Library     DateTime
Library     ../../DBQuery/ViewPolicyDB.py
Resource    ../../../CustomLibraries/common.robot
Resource    ../../../PageObjects/Insurance/ViewPolicyInvestment/ViewPolicyDetailsPageObjects.resource
Resource    ../Common/CommonMethod.resource
Resource    ViewInvestmentPage.resource
Resource    ../../../Pages/Insurance/UpdatePolicy/PersonalDetailsPage.resource
Resource    ../../../PageObjects/Insurance/UpdatePolicy/UpdatePoliciesmoduleSelectPageObject.resource

*** Variables ***
${key}      b'f057ecb7c8ed51ac'


*** Keywords ***
My policy(s)
    TRY
          #navigate to my policy page
          ${Android_EN_InsurnacePage}       Set Variable    android=new UiSelector().text("Insurance")
          ${iOS_EN_InsurnacePage}           Set Variable    chain=**/XCUIElementTypeButton[`label == '${Flow_Flag}'`]
          Wait Until Element Is Visible      ${${platformName}_${lang}_InsurnacePage}            timeout=30s
          Take Screenshot     FWD_Insurance_Page
          Click Element       ${${platformName}_${lang}_InsurnacePage}
          Set or enter PIN
          #      Select Insurance Flow
          ${Android_EN_Insurance_Module}    Set Variable     android=new UiSelector().textContains("${Insurance_Flow}")
          ${iOS_EN_Insurance_Module}        Set Variable     chain=**/XCUIElementTypeOther[`label == "${Insurance_Flow} See all"`]/XCUIElementTypeOther[-1]
          Wait Until Element Is Visible    ${${platformName}_${lang}_Insurance_Module}
          Click Element    ${${platformName}_${lang}_Insurance_Module}

          #capture policy list
          Wait Until Element Is Visible    ${${platformName}_${lang}_Policy_List}         timeout=30s
          Log     Data policy name: ${Policy_Name}
          @{Policy_Name_List}         Create List
          ${Policy_Names_txt}      Get Webelements      ${${platformName}_${lang}_Policy_List}
          ${Pcount}     Get Length     ${Policy_Names_txt}
          ${Pcount}      Evaluate    ${Pcount} + 1
          Set Global Variable    ${Pcount}
          Log    ${Pcount}
          Take Screenshot     My policy Page
          FOR    ${counter}    IN RANGE    1    ${Pcount}
             Log    ${counter}
             Scroll Till Transaction Is Visible      xpath=(//XCUIElementTypeStaticText[@name="My policy(s)"]/following::XCUIElementTypeScrollView/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther)[${counter}]
             Wait Until Element Is Visible   xpath=(//XCUIElementTypeStaticText[@name="My policy(s)"]/following::XCUIElementTypeScrollView/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther)[${counter}]      timeout=10s
             ${PolicyDetail}    Get Text     xpath=(//XCUIElementTypeStaticText[@name="My policy(s)"]/following::XCUIElementTypeScrollView/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther)[${counter}]
             Log    ${PolicyDetail}
             @{PolicyDetailsSplit}   Split String    ${PolicyDetail}     |
             ${PolicyDetailfirstSplitData}     Get From List    ${PolicyDetailsSplit}    0
             @{PolicyDetailfirstSplit}   Split String    ${PolicyDetailfirstSplitData}
             ${PolicyNumber}     Get From List   ${PolicyDetailfirstSplit}       -1
             ${PolicyNumber}     Strip String    ${PolicyNumber}
             ${PolicyName}   Remove String    ${PolicyDetailfirstSplitData}      ${PolicyNumber}
             ${PolicyName}       Strip String        ${PolicyName}
             ${policyStatusDetail}    Get From List   ${PolicyDetailsSplit}    1
             @{Policystatusdetail}   Split String    ${policyStatusDetail}       Covered for:
             ${policy_status}        Get From List    ${Policystatusdetail}    0
             @{policy_statusdata}        Split String    ${policy_status}
             ${policy_status}    Get From List    ${policy_statusdata}    -1
             ${policy_status}        Strip String    ${policy_status}
             ${policydata}    Set Variable    ${PolicyName}
             Set Global Variable    ${policydata}
             Set Calc VP Expected Result With Original And Source    PolicyName${counter}      ${PolicyName}    ${PolicyName}    OMNE_View Policy
             IF    '${PolicyNumber}' == '${Policy_No}'
                ${SelectedPolicyNumber}     Set Variable        ${PolicyNumber}
                ${SelectedPolicy_Moredetail_Element}        Set Variable    chain=**/XCUIElementTypeButton[`label == "More details"`][${counter}]
                Set Global Variable    ${SelectedPolicy_Moredetail_Element}
                Set Global Variable     ${SelectedPolicyNumber}
                ${SelectedPolicyName}   Set Variable    ${PolicyName}
                Set Global Variable    ${SelectedPolicyName}
                Take Screenshot     My policy Page
                RefreshPage
                Scroll Till Transaction Is Visible    ${SelectedPolicy_Moredetail_Element}
                Click Element     ${SelectedPolicy_Moredetail_Element}
                ${sOutput}  Run Keyword And Ignore Error    Capture Policy Details
                IF    ${sOutput} != ('PASS', None)
                    ${failure_reason}    Fetch Reason    ${sOutput}
                    RETURN       ${failure_reason}
                ELSE
                    Set Global Variable    ${result}    View Policy Passed Successfully for ${Policy_No}
                END
                #view specific tab in viewpolicy module
                ${sOutput}  Run Keyword And Ignore Error    Get View Policy DB VPs
                IF    ${sOutput} != ('PASS', None)
                    ${failure_reason}    Fetch Reason    ${sOutput}
                    RETURN       ${failure_reason}
                ELSE
                    Set Global Variable    ${result}    ${result} | View Policy DB Query is successful
                END
                Click Element    ${${platformName}_${lang}_PolicyBackArrow}
             END
          END
          #address change via view policy
          IF    '${ChangeAddress_Flag}' == 'Yes'
             FOR    ${counter}    IN RANGE    1    ${Pcount}
                  Log    ${counter}
                  Scroll Till Transaction Is Visible      xpath=(//XCUIElementTypeStaticText[@name="My policy(s)"]/following::XCUIElementTypeScrollView/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther)[${counter}]
                  Wait Until Element Is Visible   xpath=(//XCUIElementTypeStaticText[@name="My policy(s)"]/following::XCUIElementTypeScrollView/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther)[${counter}]      timeout=10s
                   ${PolicyDetail}    Get Text     xpath=(//XCUIElementTypeStaticText[@name="My policy(s)"]/following::XCUIElementTypeScrollView/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther)[${counter}]
    #            chain=**/XCUIElementTypeOther[`name='fwd-mypolicies-flatlist'`]/XCUIElementTypeScrollView/XCUIElementTypeOther/XCUIElementTypeOther[${counter}]/XCUIElementTypeOther/XCUIElementTypeOther[1]
                    Log    ${PolicyDetail}
                    @{PolicyDetailsSplit}   Split String    ${PolicyDetail}     |
                    ${PolicyDetailfirstSplitData}     Get From List    ${PolicyDetailsSplit}    0
                    @{PolicyDetailfirstSplit}   Split String    ${PolicyDetailfirstSplitData}
                    ${PolicyNumber}     Get From List   ${PolicyDetailfirstSplit}       -1
                    ${PolicyNumber}     Strip String    ${PolicyNumber}
                    ${PolicyName}   Remove String    ${PolicyDetailfirstSplitData}      ${PolicyNumber}
                    ${PolicyName}       Strip String        ${PolicyName}
                    ${policyStatusDetail}    Get From List   ${PolicyDetailsSplit}    1
                    @{Policystatusdetail}   Split String    ${policyStatusDetail}       Covered for:
                    ${policy_status}        Get From List    ${Policystatusdetail}    0
                    @{policy_statusdata}        Split String    ${policy_status}
                    ${policy_status}    Get From List    ${policy_statusdata}    -1
                    ${policy_status}        Strip String    ${policy_status}
                    ${policydata}    Set Variable    ${PolicyName}
                    Set Global Variable    ${policydata}
                    IF    '${PolicyNumber}' == '${Policy_No}'
                        ${SelectedPolicyNumber}     Set Variable        ${PolicyNumber}
                        ${SelectedPolicy_Moredetail_Element}        Set Variable    chain=**/XCUIElementTypeButton[`label == "More details"`][${counter}]
                        Set Global Variable    ${SelectedPolicy_Moredetail_Element}
                        Set Global Variable     ${SelectedPolicyNumber}
                        ${SelectedPolicyName}   Set Variable    ${PolicyName}
                        Set Global Variable    ${SelectedPolicyName}
                         Take Screenshot     My policy Page
                         RefreshPage

                         Scroll Till Transaction Is Visible    ${SelectedPolicy_Moredetail_Element}
                         Click Element     ${SelectedPolicy_Moredetail_Element}
                            Wait Until Element Is Visible       ${${platformName}_${lang}_Overview}       timeout=30s
                            Click Element                       ${${platformName}_${lang}_Overview}
                            Scroll Till Transaction Is Visible    ${${platformName}_${lang}_Details}
                            Take Screenshot    Overview page
                            Click Element    ${${platformName}_${lang}_Details}

                            Click Element    ${${platformName}_${lang}_Details_EditAddress_Button}
                            ${sOutput}  Run Keyword And Ignore Error    Address Change
                            IF    ${sOutput} != ('PASS', None)
                                   ${failure_reason}    Fetch Reason    ${sOutput}
                                   RETURN       ${failure_reason}
                            END
                           #Exit for loop
                    END
                   END
                 END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END

Capture Policy Details
    TRY
       Overview
       Document(s)
       Beneficiarys
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Policy Details
    END


Overview
    # _________________________________Header____________________________________________________________
    # YourCoverd
    TRY
        Wait Until Element Is Visible       ${${platformName}_${lang}_YouAreCoveredFor_txt}     timeout=30s
        ${VP_OverView_YourCovervalue}    Get Text    ${${platformName}_${lang}_YouAreCoveredFor_txt}
        ${M_VP_OverView_YourCovervalue}    Remove String    ${VP_OverView_YourCovervalue}    THB
        Log To Console    ToatalCoverValue=${VP_OverView_YourCovervalue}
        ${VP_OverView_YourCovervaluemsg}    Remove String    ${VP_OverView_YourCovervalue}    ,
        ${VP_OverView_YourCovervaluemsg}    Replace String    ${VP_OverView_YourCovervaluemsg}    .00    .0
        ${mVP_OverView_YourCovervaluemsg}    Remove String    ${VP_OverView_YourCovervaluemsg}    ${SPACE}

        Set Calc VP Expected Result With Original And Source
        ...    ${policydata}_Total_Covered_Value
        ...    ${mVP_OverView_YourCovervaluemsg.strip()}
        ...    ${VP_OverView_YourCovervalue}
        ...    OMNE_ViewPolicy_Page
        IF    '${CoreSystem_Flag}' == 'Yes'
            ${mVP_OverView_YourCovervaluemsg}    Remove String    ${VP_OverView_YourCovervaluemsg}    THB
            Set Calc VP Expected Result With Original And Source
            ...    ${Core_System}_SumAssured
            ...    ${mVP_OverView_YourCovervaluemsg.strip()}
            ...    ${VP_OverView_YourCovervaluemsg}
            ...    OMNE_ViewPolicy_Page
        END
        # Insured for
        ${VP_OverView_InsuredForValue}    Get Text    ${${platformName}_${lang}_InsuredFor_txt}
        Set Calc VP Expected Result With Original And Source
        ...    ${policydata}_Insured_For_value
        ...    ${VP_OverView_InsuredForValue}
        ...    ${VP_OverView_InsuredForValue}
        ...    OMNE_ViewPolicy_Page

        # policyname,number and status
        ${VP_OverView_PolicyStatus}    Get Text    ${${platformName}_${lang}_policystatus_txt}
        Set Calc VP Expected Result With Original And Source
        ...    ${policydata}_Status
        ...    ${VP_OverView_PolicyStatus}
        ...    ${VP_OverView_PolicyStatus}
        ...    OMNE_ViewPolicy_Page
        ${VP_OverView_PolicyNumber}    Get Text    ${${platformName}_${lang}_plyNo}
        Set Calc VP Expected Result With Original And Source
        ...    ${policydata}_PolicyNumber
        ...    ${VP_OverView_PolicyNumber}
        ...    ${VP_OverView_PolicyNumber}
        ...    OMNE_ViewPolicy_Page
        ${VP_Overview_PolicyName}    Get Text    ${${platformName}_${lang}_policyName_txt}
        Set Calc VP Expected Result With Original And Source
        ...    ${policydata}_OverviewPage_PolicyName
        ...    ${VP_Overview_PolicyName.strip()}
        ...    ${VP_Overview_PolicyName}
        ...    OMNE_ViewPolicy_Page

        # -__________________________Premium amoun____________________________________________________
        Take Screenshot    View_Policy_Overview_Page
        # PremiumAmoun
        IF    '${platformName}' == 'Android'
            ${VP_Overview_PremiumAmount}    Get Text    ${${platformName}_${lang}_PremiumAmt}
            ${VP_Overview_PremiumAmount}    Remove String    ${VP_Overview_PremiumAmount}    THB
            ${VP_Overview_PremiumAmount}    Strip String    ${VP_Overview_PremiumAmount}
            ${mVP_Overview_PremiumAmount}    Remove String    ${VP_Overview_PremiumAmount}    ,
            ${mVP_Overview_PremiumAmount}    Strip String    ${mVP_Overview_PremiumAmount}
            ${mVP_Overview_PremiumAmount}    Replace String    ${mVP_Overview_PremiumAmount}    .00    .0

            ${VP_Overview_Frequency}    Get Text    ${${platformName}_${lang}_frequency_txt}
            ${VP_Overview_Frequency}    Strip String    ${VP_Overview_Frequency}
            ${VP_Overview_Frequencymsg}    Convert To Lower Case    ${VP_Overview_Frequency}

            ${VP_OverView_Method}    Get Text    ${${platformName}_${lang}_method_txt}
            ${VP_OverView_Method}    Strip String    ${VP_OverView_Method}
            ${mVP_OverView_Method}    Convert To Title Case    ${VP_OverView_Method}
            ${mVP_OverView_Method}    Remove String    ${mVP_OverView_Method}    ${SPACE}
        ELSE
            ${VP_Overview_PremiumAmount}    Get Text    ${${platformName}_${lang}_PremiumAmt}
            @{Overview_FrequencyList}    Split String    ${VP_Overview_PremiumAmount}    FREQUENCY
            ${Overview_PremiumAmount}    Get From List    ${Overview_FrequencyList}    0
            ${Overview_FrequencyList}    Get From List    ${Overview_FrequencyList}    1
            @{Overview_FrequencyList}    Split String    ${Overview_FrequencyList}    METHOD

            # PremiumAmount

            @{Overview_PremiumAmount}    Split String    ${Overview_PremiumAmount}    amount
            ${VP_Overview_PremiumAmount}    Get From List    ${Overview_PremiumAmount}    1
            ${amount}    Split String    ${VP_Overview_PremiumAmount}
            ${leng}    Get Length    ${amount}
            IF    '${leng}' > '1'
                ${mVP_Overview_PremiumAmount}    Remove String    ${VP_Overview_PremiumAmount}    THB
                ${mVP_Overview_PremiumAmount}    Remove String    ${mVP_Overview_PremiumAmount}    ,
                ${mVP_Overview_PremiumAmount}    Replace String    ${mVP_Overview_PremiumAmount}    .00    .0
                ${mVP_Overview_PremiumAmount}    Evaluate    "%.1f" % ${mVP_Overview_PremiumAmount}
            ELSE
                ${mVP_Overview_PremiumAmount}    Strip String    ${VP_Overview_PremiumAmount}
            END

            # Frequency
            ${VP_Overview_Frequency}    Get From List    ${Overview_FrequencyList}    0
            Log To Console    Frequency=${VP_Overview_Frequency}
            ${VP_Overview_Frequency}    Convert To Lower Case    ${VP_Overview_Frequency}
            ${VP_Overview_Frequencymsg}    Convert To Lower Case    ${VP_Overview_Frequency}

            # Method
            ${VP_OverView_Method}    Get From List    ${Overview_FrequencyList}    1
            Log To Console    Method=${VP_OverView_Method}
            @{mVP_OverView_Method}    Split String    ${VP_OverView_Method}    ••••
            ${mVP_OverView_Method}    Get From List    ${mVP_OverView_Method}    0
            IF    '${mVP_OverView_Method.strip()}' == 'Credit card'
                ${mVP_OverView_Method}    Set Variable    CreditCard
            END
        END
        # NextPremiumDate
        ${VP_OverView_NextPremiumDate}    Get Text    ${${platformName}_${lang}_NextPremiumDate_txt}
        Set Calc VP Expected Result With Original And Source
        ...    ${policydata}_Next_Payment_Date
        ...    ${VP_OverView_NextPremiumDate.strip()}
        ...    ${VP_OverView_NextPremiumDate.strip()}
        ...    OMNE_ViewPolicy_Page
        # PolicyStartedDate
        ${VP_OverView_PolicyStartedDate}    Get Text    ${${platformName}_${lang}_StartedOnDate_txt}

        # PolicyEndsDate
        ${VP_OverView_PolicyEndDate}    Get Text    ${${platformName}_${lang}_EndsOnDate_txt}

        Set Calc VP Expected Result With Original And Source
        ...    ${policydata}_PremiumAmount
        ...    ${mVP_Overview_PremiumAmount.strip()}
        ...    ${VP_Overview_PremiumAmount.strip()}
        ...    OMNE_ViewPolicy_Page
        Set Calc VP Expected Result With Original And Source
        ...    ${policydata}_Frequency
        ...    ${VP_Overview_Frequencymsg.strip()}
        ...    ${VP_Overview_Frequency.strip()}
        ...    OMNE_ViewPolicy_Page
        Set Calc VP Expected Result With Original And Source
        ...    ${policydata}_Method
        ...    ${mVP_OverView_Method.strip()}
        ...    ${VP_OverView_Method}
        ...    OMNE_ViewPolicy_Page
        Set Calc VP Expected Result With Original And Source
        ...    ${policydata}_Policy_Started_Date
        ...    ${VP_OverView_PolicyStartedDate.strip()}
        ...    ${VP_OverView_PolicyStartedDate.strip()}
        ...    OMNE_ViewPolicy_Page
        Set Calc VP Expected Result With Original And Source
        ...    ${policydata}_Policy_Ends_Date
        ...    ${VP_OverView_PolicyEndDate.strip()}
        ...    ${VP_OverView_PolicyEndDate.strip()}
        ...    OMNE_ViewPolicy_Page

        # ______________________________________Riders_________________________________________

        SwipePage
        ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${${platformName}_${lang}_Rider}
        IF    '${status}' == "True"
            &{coordinateDict}    Get Element Rect    ${${platformName}_${lang}_Rider}
            Click Element    ${${platformName}_${lang}_Rider}
            SwipePage

            ${DeleteriderTotalCount}    Get Webelements    ${${platformName}_${lang}_RiderList}
            ${Ridercount}    Get Length    ${DeleteriderTotalCount}
            ${ridercounter}    Set Variable    1
            IF    '${platformName}' == 'iOS'
                FOR    ${element}    IN    @{DeleteriderTotalCount}
                    #    Changes for coverage in staging
                    ${totalRiderData}    Get Text    ${element}
                    @{Riders_policy_namedata}    Split String    ${totalRiderData}    THB

                    # riderpolicyname
                    ${Riders_policy_name}    Get From List    ${Riders_policy_namedata}    0
                    ${Riders_policy_name}    Strip String    ${Riders_policy_name}

                    # rider current value
                    ${Riders_policy_currentvalue}    Get From List    ${Riders_policy_namedata}    1
                    @{Riders_policy_currentvalue}    Split String    ${Riders_policy_currentvalue}    Insured for
                    ${Riders_PremiumAmount}    Get From List    ${Riders_policy_currentvalue}    0
                    ${Riders_PremiumAmount}    Strip String    ${Riders_PremiumAmount}
                    ${Riders_PremiumAmount}    Remove String    ${Riders_PremiumAmount}    ,
                    ${Riders_PremiumAmount}    Strip String    ${Riders_PremiumAmount}
                    ${Riders_PremiumAmount}    Replace String    ${Riders_PremiumAmount}    .00    .0
                    ${Riders_PremiumAmount}    Set Variable    THB ${Riders_PremiumAmount.strip()}
                    ${Riders_PremiumAmount}    Strip String    ${Riders_PremiumAmount}

                    # rider insured name
                    ${Riders_InsuredFordata}    Get From List    ${Riders_policy_currentvalue}    1
                    @{Riders_InsuredFordata}    Split String    ${Riders_InsuredFordata}    Started on
                    ${Riders_InsuredFor}    Get From List    ${Riders_InsuredFordata}    0
                    ${Riders_InsuredFor}    Strip String    ${Riders_InsuredFor}

                    # rider start date
                    ${StartedOnDate_List}    Get From List    ${Riders_InsuredFordata}    1
                    @{StartedOnDate_List}    Split String    ${StartedOnDate_List}    Ends on
                    ${Riders_StartedOnDate}    Get From List    ${StartedOnDate_List}    0
                    ${Riders_StartedOnDate}    Strip String    ${Riders_StartedOnDate}

                    # rider ends on and policy status
                    ${Payperiod_List}    Get From List    ${StartedOnDate_List}    1
                    @{Payperiod_Listdata}    Split String    ${Payperiod_List}
                    ${Riders_policy_status}    Get From List    ${Payperiod_Listdata}    -1
                    ${Riders_policy_status}    Strip String    ${Riders_policy_status}
                    ${Riders_EndsOnDate}    Remove String    ${Payperiod_List}    ${Riders_policy_status}
                    ${Riders_EndsOnDate}    Strip String    ${Riders_EndsOnDate}

                    Set Calc VP Actual Result With Original And Source
                    ...    ViewPolicy_Riders${ridercounter}_PolicyName
                    ...    ${Riders_policy_name}
                    ...    ${Riders_policy_name}
                    ...    OMNE_View_Policy_Rider
                    Set Calc VP Actual Result With Original And Source
                    ...    ViewPolicy_Riders${ridercounter}_PremiumAmount
                    ...    ${Riders_PremiumAmount}
                    ...    ${Riders_PremiumAmount}
                    ...    OMNE_View_Policy_Rider
                    Set Calc VP Actual Result With Original And Source
                    ...    ViewPolicy_Riders${ridercounter}_InsuredFor
                    ...    ${Riders_InsuredFor}
                    ...    ${Riders_InsuredFor}
                    ...    OMNE_View_Policy_Rider
                    Set Calc VP Actual Result With Original And Source
                    ...    ViewPolicy_Riders${ridercounter}_EndsOnDate
                    ...    ${Riders_EndsOnDate}
                    ...    ${Riders_EndsOnDate}
                    ...    OMNE_View_Policy_Rider
                    Set Calc VP Actual Result With Original And Source
                    ...    ViewPolicy_Riders${ridercounter}_StartedOnDate
                    ...    ${Riders_StartedOnDate}
                    ...    ${Riders_StartedOnDate}
                    ...    OMNE_View_Policy_Rider
    #    Set Calc VP Actual Result With Original And Source    ViewPolicy_Riders${ridercounter}_PolicyStatus    ${Riders_policy_status}    ${Riders_policy_status}    OMNE_View_Policy_Rider

                    Take Screenshot    View_Policy_Riders
                    ${ridercounter}    Evaluate    ${ridercounter}+1
                    Horizontal Swipe
                END
            ELSE
                @{riderNameArrayList}    Create List
                ${ridercounter}    Set Variable    1
                FOR    ${temp}    IN RANGE    1    5
                    ${totRider_Countelement}    Get Webelements    ${${platformName}_${lang}_RiderList}
                    ${rider_count}    Get Length    ${totRider_Countelement}

                    FOR    ${temp}    IN RANGE    1    ${rider_count}
                        # ridername
                        ${Riders_policy_name}    Get Text
                        ...    xpath=(//android.view.ViewGroup[@content-desc="Rider(s)"]/following::android.widget.TextView[@text="Insured for"]/preceding-sibling::android.widget.TextView[2])[${temp}]
                        ${Riders_policy_name}    Strip String    ${Riders_policy_name}
                        ${status}    Run Keyword And Return Status
                        ...    List Should Contain Value
                        ...    ${riderNameArrayList}
                        ...    ${Riders_policy_name}
                        IF    '${status}' == 'False'
                            Append To List    ${riderNameArrayList}    ${Riders_policy_name}
                            # rider premium amount
                            ${Riders_PremiumAmount}    Get Text
                            ...    xpath=(//android.view.ViewGroup[@content-desc="Rider(s)"]/following::android.widget.TextView[@text="Insured for"]/preceding-sibling::android.widget.TextView[1])[${temp}]
                            ${Riders_PremiumAmount}    Strip String    ${Riders_PremiumAmount}
                            ${Riders_PremiumAmount}    Remove String    ${Riders_PremiumAmount}    ,
                            ${Riders_PremiumAmount}    Strip String    ${Riders_PremiumAmount}
                            ${Riders_PremiumAmount}    Replace String    ${Riders_PremiumAmount}    .00    .0

                            # insuredname
                            ${Riders_InsuredFor}    Get Text
                            ...    xpath=(//android.view.ViewGroup[@content-desc="Rider(s)"]/following::android.widget.TextView[@text="Insured for"]/following-sibling::android.widget.TextView[1])[${temp}]
                            ${Riders_InsuredFor}    Strip String    ${Riders_InsuredFor}

                            # startdate
                            ${Riders_StartedOnDate}    Get Text
                            ...    xpath=(//android.widget.TextView[@text="Started on"]/following-sibling::android.widget.TextView)[${temp}]
                            ${Riders_StartedOnDate}    Strip String    ${Riders_StartedOnDate}

                            # enddate
                            ${Riders_EndsOnDate}    Get Text
                            ...    xpath=(//android.widget.TextView[@text="Ends on"]/following-sibling::android.widget.TextView)[${temp}]
                            ${Riders_EndsOnDate}    Strip String    ${Riders_EndsOnDate}

                            # rider policy status
                            ${Riders_policy_status}    Get Text
                            ...    xpath=(//android.view.ViewGroup[@content-desc="Rider(s)"]/following::android.widget.TextView[@text="Insured for"]/parent::android.view.ViewGroup/following-sibling::android.view.ViewGroup//android.widget.TextView)[${temp}]
                            ${Riders_policy_status}    Strip String    ${Riders_policy_status}

                            Set Calc VP Actual Result With Original And Source
                            ...    ViewPolicy_Riders${ridercounter}_PolicyName
                            ...    ${Riders_policy_name}
                            ...    ${Riders_policy_name}
                            ...    OMNE_View_Policy_Rider
                            Set Calc VP Actual Result With Original And Source
                            ...    ViewPolicy_Riders${ridercounter}_PremiumAmount
                            ...    ${Riders_PremiumAmount}
                            ...    ${Riders_PremiumAmount}
                            ...    OMNE_View_Policy_Rider
                            Set Calc VP Actual Result With Original And Source
                            ...    ViewPolicy_Riders${ridercounter}_InsuredFor
                            ...    ${Riders_InsuredFor}
                            ...    ${Riders_InsuredFor}
                            ...    OMNE_View_Policy_Rider
                            Set Calc VP Actual Result With Original And Source
                            ...    ViewPolicy_Riders${ridercounter}_EndsOnDate
                            ...    ${Riders_EndsOnDate}
                            ...    ${Riders_EndsOnDate}
                            ...    OMNE_View_Policy_Rider
                            Set Calc VP Actual Result With Original And Source
                            ...    ViewPolicy_Riders${ridercounter}_StartedOnDate
                            ...    ${Riders_StartedOnDate}
                            ...    ${Riders_StartedOnDate}
                            ...    OMNE_View_Policy_Rider
    #    Set Calc VP Actual Result With Original And Source    ViewPolicy_Riders${ridercounter}_PolicyStatus    ${Riders_policy_status}    ${Riders_policy_status}    OMNE_View_Policy_Rider
                            Take Screenshot    View_Policy_Riders
                            ${ridercounter}    Evaluate    ${ridercounter}+1
                            Horizontal Swipe Rider    &{coordinateDict}
                        END
                    END
                END
            END
        END

        # __________________________________Details________________________________________
        SwipePage
        Take Screenshot    View_Policy_Page
        IF    '${Transaction_Page_GUI}' == 'Yes'
            ${Status}    Run Keyword And Return Status
            ...    Wait Until Page Contains Element
            ...    ${${platformName}_${lang}_Details}
            Set Calc VP With Source And Original Values
            ...    View_Policy_Details_Section
            ...    true
            ...    ${Status}
            ...    Static
            ...    OMNE_ViewPolicy_Page
            ...    true
            ...    ${Status}
        END
        Click Element    ${${platformName}_${lang}_Details}
        Take Screenshot    View_Policy_Page

        # MailingAddres
        ${VP_Details_MailingAddress}    Get Text    ${${platformName}_${lang}_Details_MailingAddress_txt}
        ${mVP_Details_MailingAddress}    Remove String    ${VP_Details_MailingAddress}    ,
        ${mVP_Details_MailingAddress}    Remove String    ${mVP_Details_MailingAddress}    ${SPACE}
        ${mVP_Details_MailingAddress}    Remove String    ${mVP_Details_MailingAddress}    ${\n}
        Set Calc VP Expected Result With Original And Source
        ...    ${policydata}_MailingAddress
        ...    ${mVP_Details_MailingAddress.strip()}
        ...    ${VP_Details_MailingAddress}
        ...    OMNE_ViewPolicy_Page

        # DetailsAgentName
        ${VP_Details_Contact_YourAgentName}    Get Text    ${${platformName}_${lang}_Details_CallYourAgent_txt}

        # callyourAgent
        IF    '${Transaction_Page_GUI}' == 'Yes'
            ${Status}    Run Keyword And Return Status
            ...    Wait Until Page Contains Element
            ...    ${${platformName}_${lang}_Details_CallYourAgent_txt}
            Set Calc VP With Source And Original Values
            ...    ${policydata}_Call_Your_Agent
            ...    true
            ...    ${Status}
            ...    Static
            ...    OMNE_ViewPolicy_Page
            ...    true
            ...    ${Status}
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Overview Tab
    END

Beneficiarys
    TRY
         ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    ${${platformName}_${lang}_Beneficiary}
        ...    timeout=5s
        IF    '${status}' == 'True'
            Click Element    ${${platformName}_${lang}_Beneficiary}
    #    Wait Until Element Is Visible    ${${platformName}_${lang}_editbeneficiaryBtn}    timeout=30s
            Take Screenshot    View_Policy_BeneficiaryPage
            ${Status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_addBeneficiaryBtn}
            ...    timeout=5s
        END
        Set Calc VP With Source And Original Values
        ...    Beneficiary_Found
        ...    ${Status}
        ...    ${Status}
        ...    Static
        ...    OMNE_ViewPolicy_BeneficiaryPage
        ...    ${Status}
        ...    ${Status}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Beneficiarys Tab
    END
    

Document(s)
    TRY
         Click Element    ${${platformName}_${lang}_Document}
        IF    '${testtype}'!='NEGATIVE' and '${Transaction_Page_GUI}' == 'Yes'
            ${Status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_TaxDocument}
            ...    timeout=60s
            Set Calc VP With Source And Original Values
            ...    ${policydata}_TaxDocument_ByDefaultPresent
            ...    true
            ...    ${Status}
            ...    Static
            ...    Omne_viewPolicy_DocumentPage
            ...    true
            ...    ${Status}
        END
        Take Screenshot    View_Policy_DocumentPage
    EXCEPT     AS  ${reason}
            Set Failed Actual Result and VP    Omne_Flow   ${reason}   Document(s) Tab
    END

GUI VP
    TRY
        IF    '${Transaction_Page_GUI}' == 'Yes'

            ${Status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_Overview}
            ...    timeout=120s
            Set Calc VP With Source And Original Values
            ...    ${policydata}_View_Policy_Overview_TabVisible
            ...    true
            ...    ${Status}
            ...    Static
            ...    OMNE_ViewPolicy_Page
            ...    true
            ...    ${Status}

            ${Status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_Document}
            ...    timeout=120s
            Set Calc VP With Source And Original Values
            ...    ${policydata}_View_Policy_Document_TabVisible
            ...    true
            ...    ${Status}
            ...    Static
            ...    OMNE_ViewPolicy_Page
            ...    true
            ...    ${Status}

            ${Status}    Run Keyword And Return Status
            ...    Wait Until Element Is Visible
            ...    ${${platformName}_${lang}_Beneficiary}
            ...    timeout=120s
            Set Calc VP With Source And Original Values
            ...    ${policydata}_View_Policy_Beneficiary_TabVisible
            ...    true
            ...    ${Status}
            ...    Static
            ...    OMNE_ViewPolicy_Page
            ...    true
            ...    ${Status}
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   GUI VP
    END

Get View Policy DB VPs
    TRY
        ${ActualSource}    Set Variable    View Policy DB Query
        ${OwnerUserId}    Run Keyword
        ...    Get Owner User ID from DB
        ...    ${dbhostname}
        ...    ${dbusername}
        ...    ${dbpassword}
        ...    ${dbport}
        ...    ${dbinstanceAddon}
        ...    ${Policy_No}
        ...    ${dbinstance}
        Log    ${OwnerUserId}
    #    ${OwnerUserId}    Set Variable    203fc5b2-bf46-536c-a467-4aa00f2cb4d3
        ${PolDetailsdf}    Run Keyword
        ...    Get Policy List from DB
        ...    ${dbhostname}
        ...    ${dbusername}
        ...    ${dbpassword}
        ...    ${dbport}
        ...    ${dbinstance}
        ...    ${OwnerUserId}
        ...    ${screenshotPath}
        Log    ${PolDetailsdf}
        ${leng}    Get Length    ${PolDetailsdf}
        Log    ${leng}
        ${list0}    Get From List    ${PolDetailsdf}    0
        Log    ${list0}
        ${index1}    Get Index From List    ${list0}    ProductName
        Log    ${index1}
        ${index2}    Get Index From List    ${list0}    PolicyNumber
        Log    ${index2}
        ${index3}    Get Index From List    ${list0}    Id
        Log    ${index3}
        ${index4}    Get Index From List    ${list0}    ProductCategory
        Log    ${index4}
        FOR    ${counter}    IN RANGE    1    ${leng}
            Log    ${counter}
            ${list}    Get From List    ${PolDetailsdf}    ${counter}
            #    ${type_list}    Evaluate    type(${list})
            #    Log    ${type_list}
            #    ${ActualSource}    Set Variable    View Policy DB Query
            ${ProductName}    Set Variable    ${list}[${index1}]
            ${ProductName}    Strip String    ${ProductName}
            Log    ${ProductName}
            ${ProductCategory}    Set Variable    ${list}[${index4}]
            ${ProductCategory}    Strip String    ${ProductCategory}
            Log    ${ProductCategory}
            ${ProductNameFinal}    Set Variable    ${ProductCategory} ${ProductName}
            ${ProductNameFinal}    Convert To Uppercase    ${ProductNameFinal}
            ${ExternalRemoteId}    Set Variable    ${list}[${index2}]
            ${ExternalRemoteId}    Strip String    ${ExternalRemoteId}
            Log    ${ExternalRemoteId}
            ${policynumber}    AES Decrypt    ${key}    ${ExternalRemoteId}
            Log    ${policynumber}
            Log    ${Policy_No}
            IF    '${Policy_No.strip()}' == '${policynumber.strip()}'
                ${Policy_No_Decrypt}    Set Variable    ${ExternalRemoteId}
                ${PolicyId}    Set Variable    ${list}[${index3}]
                ${policydata}    Set Variable    ${ProductName}
                ${policyNumberDB}    Set Variable    ${policynumber}
            END
            ${newcounter}    Evaluate    ${counter}-1
            ${ProductNameFinal}    Remove String    ${ProductNameFinal}    ,
            Set Calc VP Actual Result With Original And Source
            ...    PolicyName${counter}
            ...    ${ProductName.strip()}
            ...    ${ProductName}
            ...    ${ActualSource}
        END
        #    ${policynumberDecrypt}    AES Encrypt    ${key}    ${Policy_No}
        IF    '${Policy_No_Decrypt}' != '${EMPTY}'
            ${PolDtldf}    Run Keyword
            ...    Get Selected Policy Detail from DB
            ...    ${dbhostname}
            ...    ${dbusername}
            ...    ${dbpassword}
            ...    ${dbport}
            ...    ${dbinstance}
            ...    ${Policy_No_Decrypt}
            ...    ${PolicyId}
            ...    ${screenshotPath}
            Log    ${PolDtldf}
            ${leng}    Get Length    ${PolDtldf}
            Log    ${leng}
            ${list0}    Get From List    ${PolDtldf}    0
            Log    ${list0}
            ${index1}    Get Index From List    ${list0}    premiumCurrency
            Log    ${index1}
            ${index2}    Get Index From List    ${list0}    sumAssured
            Log    ${index2}
            ${index3}    Get Index From List    ${list0}    expiryDate
            Log    ${index3}
            ${index4}    Get Index From List    ${list0}    commencementDate
            Log    ${index4}
            ${index5}    Get Index From List    ${list0}    NextPremiumDate
            Log    ${index5}
            ${index6}    Get Index From List    ${list0}    FirstName
            Log    ${index6}
            ${index7}    Get Index From List    ${list0}    LastName
            Log    ${index7}
            ${index8}    Get Index From List    ${list0}    CoverageStatus
            Log    ${index8}
            ${index9}    Get Index From List    ${list0}    ProductName
            Log    ${index9}
            ${index10}    Get Index From List    ${list0}    premiuminstallmentPremium
            Log    ${index10}
            ${counter}    Set Variable    1
            #    Log    ${counter}
            ${list}    Get From List    ${PolDtldf}    ${counter}
            #    ${type_list}    Evaluate    type(${list})
            #    Log    ${type_list}
            #    ${ActualSource}    Set Variable    View Investment DB Query
            ${premiumCcy}    Set Variable    ${list}[${index1}]
            Log    ${premiumCcy}
            IF    '${premiumCcy}' == 'None'
                ${premiumCcy}    Set Variable    ${EMPTY}
            END
            ${SA}    Set Variable    ${list}[${index2}]
            Log    ${SA}
            IF    '${SA}' == 'None'
                ${SA}    Set Variable    ${EMPTY}
            END
            ${expiryDate}    Set Variable    ${list}[${index3}]
            Log    ${expiryDate}
            IF    '${expiryDate}' == 'None'
                ${expiryDate}    Set Variable    ${EMPTY}
            END
            ${startDate}    Set Variable    ${list}[${index4}]
            Log    ${startDate}
            IF    '${startDate}' == 'None'
                ${startDate}    Set Variable    ${EMPTY}
            END
            ${NextPremDate}    Set Variable    ${list}[${index5}]
            Log    ${NextPremDate}
            IF    '${NextPremDate}' == 'None'
                ${NextPremDate}    Set Variable    ${EMPTY}
            END
            ${fname}    Set Variable    ${list}[${index6}]
            Log    ${fname}
            IF    '${fname}' == 'None'
                ${fname}    Set Variable    ${EMPTY}
            END
            ${lname}    Set Variable    ${list}[${index7}]
            Log    ${lname}
            IF    '${lname}' == 'None'
                ${lname}    Set Variable    ${EMPTY}
            END
            ${fname}    AES Decrypt    ${key}    ${fname}
            ${lname}    AES Decrypt    ${key}    ${lname}
            ${coverageStatus}    Set Variable    ${list}[${index8}]
            Log    ${coverageStatus}
            IF    '${coverageStatus}' == 'None'
                ${coverageStatus}    Set Variable    ${EMPTY}
            END
            ${productName}    Set Variable    ${list}[${index9}]
            Log    ${productName}
            IF    '${productName}' == 'None'
                ${productName}    Set Variable    ${EMPTY}
            END
            ${premiumInstallment}    Set Variable    ${list}[${index10}]
            Log    ${premiumInstallment}
            IF    '${premiumInstallment}' == 'None'
                ${premiumInstallment}    Set Variable    ${EMPTY}
            END
            ${premiumInstallmentmsg}    Set Variable    ${premiumInstallment}
            IF    '${premiumInstallment}' == '0.0'
                ${premiumInstallmentmsg}    Set Variable    -
            END
            ${productName}    Strip String    ${productName}
    #    ${mproductName}    Remove String    ${productName}    (Top-Up)
            ${OverView_InsuredForValue}    Set Variable    ${fname} ${lname}
            ${OverView_YourCovervalue}    Set Variable    ${premiumCcy} ${SA}
            ${mOverView_YourCovervalue}    Remove String    ${OverView_YourCovervalue}    ${SPACE}
            ${NextPremDatemsg}    Convert Date    ${NextPremDate}    result_format=%d %b %Y
            Log    ${NextPremDatemsg}
            ${startDatemsg}    Convert Date    ${startDate}    result_format=%d %b %Y
            Log    ${startDatemsg}
            ${expiryDatemsg}    Convert Date    ${expiryDate}    result_format=%d %b %Y
            Log    ${expiryDatemsg}
            Set Calc VP Actual Result With Original And Source
            ...    ${policydata}_Total_Covered_Value
            ...    ${mOverView_YourCovervalue.strip()}
            ...    ${OverView_YourCovervalue}
            ...    ${ActualSource}
            Set Calc VP Actual Result With Original And Source
            ...    ${policydata}_Insured_For_value
            ...    ${OverView_InsuredForValue}
            ...    ${OverView_InsuredForValue}
            ...    ${ActualSource}
            Set Calc VP Actual Result With Original And Source
            ...    ${policydata}_Status
            ...    ${coverageStatus}
            ...    ${coverageStatus}
            ...    ${ActualSource}
            Set Calc VP Actual Result With Original And Source
            ...    ${policydata}_PolicyNumber
            ...    ${policyNumberDB}
            ...    ${policyNumberDB}
            ...    ${ActualSource}
            Set Calc VP Actual Result With Original And Source
            ...    ${policydata}_OverviewPage_PolicyName
            ...    ${productName.strip()}
            ...    ${productName}
            ...    ${ActualSource}
            Set Calc VP Actual Result With Original And Source
            ...    ${policydata}_PremiumAmount
            ...    ${premiumInstallmentmsg}
            ...    ${premiumInstallment}
            ...    ${ActualSource}
            Set Calc VP Actual Result With Original And Source
            ...    ${policydata}_Next_Payment_Date
            ...    ${NextPremDatemsg}
            ...    ${NextPremDate}
            ...    ${ActualSource}
            Set Calc VP Actual Result With Original And Source
            ...    ${policydata}_Policy_Started_Date
            ...    ${startDatemsg}
            ...    ${startDate}
            ...    ${ActualSource}
            Set Calc VP Actual Result With Original And Source
            ...    ${policydata}_Policy_Ends_Date
            ...    ${expiryDatemsg}
            ...    ${expiryDate}
            ...    ${ActualSource}

            #    Set Calc VP Actual Result With Original And Source    ${policydata}_Method    ${VP_OverView_Method}    ${VP_OverView_Method}    ${ActualSource}
            ${PolAdddf}    Run Keyword
            ...    Get Selected Policy Address Detail from DB
            ...    ${dbhostname}
            ...    ${dbusername}
            ...    ${dbpassword}
            ...    ${dbport}
            ...    ${dbinstance}
            ...    ${PolicyId}
            ...    ${screenshotPath}
            Log    ${PolAdddf}
            ${leng}    Get Length    ${PolAdddf}
            Log    ${leng}
            ${list0}    Get From List    ${PolAdddf}    0
            Log    ${list0}
            ${index1}    Get Index From List    ${list0}    addressline1
            Log    ${index1}
            ${index2}    Get Index From List    ${list0}    addressline2
            Log    ${index2}
            ${index3}    Get Index From List    ${list0}    addressline3
            Log    ${index3}
            ${index4}    Get Index From List    ${list0}    addressline4
            Log    ${index4}
            ${index5}    Get Index From List    ${list0}    addressline5
            Log    ${index5}
            ${index6}    Get Index From List    ${list0}    postalcode
            Log    ${index6}
            ${counter}    Set Variable    1
            #    Log    ${counter}
            ${list}    Get From List    ${PolAdddf}    ${counter}
            #    ${type_list}    Evaluate    type(${list})
            #    Log    ${type_list}
            #    ${ActualSource}    Set Variable    View Investment DB Query
            ${addressline1}    Set Variable    ${list}[${index1}]
            Log    ${addressline1}
            IF    '${addressline1}' == 'None'
                ${addressline1}    Set Variable    ${EMPTY}
            END
            ${decaddressline1}    AES Decrypt    ${key}    ${addressline1}
            ${addressline2}    Set Variable    ${list}[${index2}]
            Log    ${addressline2}
            IF    '${addressline2}' == 'None'
                ${addressline2}    Set Variable    ${EMPTY}
            END
            ${decaddressline2}    AES Decrypt    ${key}    ${addressline2}
            ${addressline3}    Set Variable    ${list}[${index3}]
            Log    ${addressline3}
            IF    '${addressline3}' == 'None'
                ${addressline3}    Set Variable    ${EMPTY}
            END
            ${decaddressline3}    AES Decrypt    ${key}    ${addressline3}
            ${addressline4}    Set Variable    ${list}[${index4}]
            Log    ${addressline4}
            IF    '${addressline4}' == 'None'
                ${addressline4}    Set Variable    ${EMPTY}
            END
            ${decaddressline4}    AES Decrypt    ${key}    ${addressline4}
            ${addressline5}    Set Variable    ${list}[${index5}]
            Log    ${addressline5}
            IF    '${addressline5}' == 'None'
                ${addressline5}    Set Variable    ${EMPTY}
            END
            ${decaddressline5}    AES Decrypt    ${key}    ${addressline5}
            ${postalcode}    Set Variable    ${list}[${index6}]
            Log    ${postalcode}
            IF    '${postalcode}' == 'None'
                ${postalcode}    Set Variable    ${EMPTY}
            END
            ${decpostalcode}    AES Decrypt    ${key}    ${postalcode}
            ${Details_MailingAddress}    Set Variable
            ...    ${decaddressline1},${decaddressline2},${decaddressline3} ,${decaddressline4},${decaddressline5},${decpostalcode},Thailand
            ${mDetails_MailingAddress}    Remove String    ${Details_MailingAddress}    ,
            ${mDetails_MailingAddress}    Remove String    ${mDetails_MailingAddress}    ${SPACE}
            ${mDetails_MailingAddress}    Remove String    ${mDetails_MailingAddress}    ${\n}
            Set Calc VP Actual Result With Original And Source
            ...    ${policydata}_MailingAddress
            ...    ${mDetails_MailingAddress.strip()}
            ...    ${Details_MailingAddress}
            ...    ${ActualSource}
            #    Set Calc VP Actual Result With Original And Source    ${policydata}_Method    ${VP_OverView_Method}    ${VP_OverView_Method}    ${ActualSource}

            ${PolRiderdf}    Run Keyword
            ...    Get Selected Policy Rider Detail from DB
            ...    ${dbhostname}
            ...    ${dbusername}
            ...    ${dbpassword}
            ...    ${dbport}
            ...    ${dbinstance}
            ...    ${PolicyId}
            ...    ${screenshotPath}
            Log    ${PolRiderdf}
            ${leng}    Get Length    ${PolRiderdf}
            Log    ${leng}
            ${list0}    Get From List    ${PolRiderdf}    0
            Log    ${list0}
            ${index1}    Get Index From List    ${list0}    ProductName
            Log    ${index1}
            ${index2}    Get Index From List    ${list0}    CoverageStatus
            Log    ${index2}
            ${index3}    Get Index From List    ${list0}    premiumCurrency
            Log    ${index3}
            ${index4}    Get Index From List    ${list0}    sumAssured
            Log    ${index4}
            ${index5}    Get Index From List    ${list0}    FirstName
            Log    ${index5}
            ${index6}    Get Index From List    ${list0}    expiryDate
            Log    ${index6}
            ${index7}    Get Index From List    ${list0}    commencementDate
            Log    ${index7}
            ${index8}    Get Index From List    ${list0}    premiuminstallmentPremium
            Log    ${index8}
            ${index9}    Get Index From List    ${list0}    LastName
            Log    ${index9}
            ${counter}    Set Variable    1
            FOR    ${counter}    IN RANGE    1    ${leng}
                #    Log    ${counter}
                ${list}    Get From List    ${PolRiderdf}    ${counter}
                #    ${type_list}    Evaluate    type(${list})
                #    Log    ${type_list}
                #    ${ActualSource}    Set Variable    View Investment DB Query
                ${ProductNameRider}    Set Variable    ${list}[${index1}]
                Log    ${ProductNameRider}
                IF    '${ProductNameRider}' == 'None'
                    ${ProductNameRider}    Set Variable    ${EMPTY}
                END
                ${CoverageStatusRider}    Set Variable    ${list}[${index2}]
                Log    ${CoverageStatusRider}
                IF    '${CoverageStatusRider}' == 'None'
                    ${CoverageStatusRider}    Set Variable    ${EMPTY}
                END
                ${premiumCurrencyRider}    Set Variable    ${list}[${index3}]
                Log    ${premiumCurrencyRider}
                IF    '${premiumCurrencyRider}' == 'None'
                    ${premiumCurrencyRider}    Set Variable    ${EMPTY}
                END
                ${SumAssuredRider}    Set Variable    ${list}[${index4}]
                Log    ${SumAssuredRider}
                IF    '${SumAssuredRider}' == 'None'
                    ${SumAssuredRider}    Set Variable    ${EMPTY}
                END
                ${fNameRider}    Set Variable    ${list}[${index5}]
                Log    ${fNameRider}
                IF    '${fNameRider}' == 'None'
                    ${fNameRider}    Set Variable    ${EMPTY}
                END
                ${fNameRider}    AES Decrypt    ${key}    ${fNameRider}

                ${lNameRider}    Set Variable    ${list}[${index9}]
                Log    ${lNameRider}
                IF    '${lNameRider}' == 'None'
                    ${lNameRider}    Set Variable    ${EMPTY}
                END
                ${lNameRider}    AES Decrypt    ${key}    ${lNameRider}
                ${insuredNameRider}    Set Variable    ${fname} ${lname}
                ${expiryDateRider}    Set Variable    ${list}[${index6}]
                Log    ${expiryDateRider}
                IF    '${expiryDateRider}' == 'None'
                    ${expiryDateRider}    Set Variable    ${EMPTY}
                END
                ${commencementDateRider}    Set Variable    ${list}[${index7}]
                Log    ${commencementDateRider}
                IF    '${commencementDateRider}' == 'None'
                    ${commencementDateRider}    Set Variable    ${EMPTY}
                END
                ${premInstallmentRider}    Set Variable    ${list}[${index8}]
                Log    ${premInstallmentRider}
                IF    '${premInstallmentRider}' == 'None'
                    ${premInstallmentRider}    Set Variable    ${EMPTY}
                END
                ${premInstallmentRidermsg}    Set Variable    ${premInstallmentRider}
                IF    '${premInstallmentRider}' == '0.0'
                    ${premInstallmentRidermsg}    Set Variable    -
                END
                ${SARider}    Set Variable    ${premiumCurrencyRider} ${SumAssuredRider}
                #    ${decaddressline1}    AES Decrypt    ${key}    ${addressline1}
                ${ProductNameRider}    Strip String    ${ProductNameRider}

                ${commencementDateRidermsg}    Convert Date    ${commencementDateRider}    result_format=%d %b %Y
                Log    ${commencementDateRidermsg}
                ${expiryDateRidermsg}    Convert Date    ${expiryDateRider}    result_format=%d %b %Y
                Log    ${expiryDateRidermsg}
                Set Calc VP Expected Result With Original And Source
                ...    ViewPolicy_Riders${counter}_PolicyName
                ...    ${ProductNameRider}
                ...    ${ProductNameRider}
                ...    ${ActualSource}
                Set Calc VP Expected Result With Original And Source
                ...    ViewPolicy_Riders${counter}_PremiumAmount
                ...    ${SARider}
                ...    ${SARider}
                ...    ${ActualSource}
                Set Calc VP Expected Result With Original And Source
                ...    ViewPolicy_Riders${counter}_StartedOnDate
                ...    ${commencementDateRidermsg}
                ...    ${commencementDateRider}
                ...    ${ActualSource}
                Set Calc VP Expected Result With Original And Source
                ...    ViewPolicy_Riders${counter}_EndsOnDate
                ...    ${expiryDateRidermsg}
                ...    ${expiryDateRider}
                ...    ${ActualSource}
                Set Calc VP Expected Result With Original And Source
                ...    ViewPolicy_Riders${counter}_InsuredFor
                ...    ${insuredNameRider}
                ...    ${insuredNameRider}
                ...    ${ActualSource}
            END
            #    ${Details_MailingAddress}    Set Variable    ${addressline1},${addressline2},${addressline3},${addressline4},${addressline5},${postalcode},Thailand
            #    Set Calc VP Actual Result With Original And Source    ${policydata}_MailingAddress    ${Details_MailingAddress}    ${Details_MailingAddress}    ${ActualSource}
            ${PolPaymentdf}    Run Keyword
            ...    Get Payment Method from DB
            ...    ${dbhostname}
            ...    ${dbusername}
            ...    ${dbpassword}
            ...    ${dbport}
            ...    ${dbinstance}
            ...    ${Policy_No_Decrypt}
            ...    ${OwnerUserId}
            ...    ${screenshotPath}
            Log    ${PolPaymentdf}
            ${leng}    Get Length    ${PolPaymentdf}
            Log    ${leng}
            ${list0}    Get From List    ${PolPaymentdf}    0
            Log    ${list0}
            ${index1}    Get Index From List    ${list0}    Enum
            Log    ${index1}
            ${counter}    Set Variable    1
            #    Log    ${counter}
            ${list}    Get From List    ${PolPaymentdf}    ${counter}
            #    ${type_list}    Evaluate    type(${list})
            #    Log    ${type_list}
            #    ${ActualSource}    Set Variable    View Investment DB Query
            ${paymentmethod}    Set Variable    ${list}[${index1}]
            Log    ${paymentmethod}
            IF    '${paymentmethod}' == 'None'
                ${paymentmethod}    Set Variable    ${EMPTY}
            END
            Set Calc VP Actual Result With Original And Source
            ...    ${policydata}_Method
            ...    ${paymentmethod}
            ...    ${paymentmethod}
            ...    ${ActualSource}
            ${PolFreqdf}    Run Keyword
            ...    Get Frequency from DB
            ...    ${dbhostname}
            ...    ${dbusername}
            ...    ${dbpassword}
            ...    ${dbport}
            ...    ${dbinstance}
            ...    ${Policy_No_Decrypt}
            ...    ${OwnerUserId}
            ...    ${screenshotPath}
            Log    ${PolPaymentdf}
            ${leng}    Get Length    ${PolFreqdf}
            Log    ${leng}
            ${list0}    Get From List    ${PolFreqdf}    0
            Log    ${list0}
            ${index1}    Get Index From List    ${list0}    Enum
            Log    ${index1}
            ${counter}    Set Variable    1
            #    Log    ${counter}
            ${list}    Get From List    ${PolFreqdf}    ${counter}
            #    ${type_list}    Evaluate    type(${list})
            #    Log    ${type_list}
            #    ${ActualSource}    Set Variable    View Investment DB Query
            ${paymentfrequency}    Set Variable    ${list}[${index1}]
            Log    ${paymentfrequency}
            IF    '${paymentfrequency}' == 'None'
                ${paymentfrequency}    Set Variable    ${EMPTY}
            END
            ${paymentfrequencymsg}    Convert To Lower Case    ${paymentfrequency}
            Set Calc VP Actual Result With Original And Source
            ...    ${policydata}_Frequency
            ...    ${paymentfrequencymsg}
            ...    ${paymentfrequency}
            ...    ${ActualSource}

            ${PolFreqdf}    Run Keyword
            ...    Get Selected Policy Bene Detail from DB
            ...    ${dbhostname}
            ...    ${dbusername}
            ...    ${dbpassword}
            ...    ${dbport}
            ...    ${dbinstance}
            ...    ${PolicyId}
            ...    ${screenshotPath}
            Log    ${PolPaymentdf}
            ${leng}    Get Length    ${PolFreqdf}
            Log    ${leng}
            IF    '${leng}' == '1'
                Set Calc VP Actual Result With Original And Source
                ...    Beneficiary_Found
                ...    false
                ...    false
                ...    ${ActualSource}
            ELSE
                Set Calc VP Actual Result With Original And Source    Beneficiary_Found    true    true    ${ActualSource}
            END
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Get View Policy DB VPs
    END