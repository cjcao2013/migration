*** Settings ***
Library     AppiumLibrary
Library     RPA.Windows
Resource    ../../../CustomLibraries/common.robot
Resource    ../../../PageObjects/Insurance/ViewPolicyInvestment/ViewInvestmentPageObjects.resource
Library     ../../DBQuery/InvestmentDB.py
Library     ../../DBQuery/DBQuerySelect.py
Library     DateTime
Library     String
Resource    ../../Insurance/Common/CommonMethod.resource


*** Variables ***
${Policy_No_Decrypt}                        ${EMPTY}
${Selected_policyStatus}                    ${EMPTY}
${Selected_ProductName}                     ${EMPTY}
${SelectedPolicyCurrentValue}               ${EMPTY}
${SelectedPolicyCurrentValueformat}         ${EMPTY}
${SelectedPolicyGainorLossValue}            ${EMPTY}
${SelectedPolicyType}                       ${EMPTY}
${SelectedPolicyGainorLossPercentage}       ${EMPTY}
&{Fund_dic}                                 &{EMPTY}
${screenshotPath}                            ${EMPTY}


*** Keywords ***
Investment(s)
    TRY
          &{Fund_dic}    Create Dictionary
               #navigate to my policy page
          ${Android_EN_InsurnacePage}       Set Variable    android=new UiSelector().text("Insurance")
          ${iOS_EN_InsurnacePage}           Set Variable    chain=**/XCUIElementTypeButton[`label == '${Flow_Flag}'`]
          Wait Until Element Is Visible      ${${platformName}_${lang}_InsurnacePage}            timeout=30s
          Take Screenshot     FWD_Insurance_Page
          Click Element       ${${platformName}_${lang}_InsurnacePage}
          Set or enter PIN
          #      Select Insurance Flow
          ${Android_EN_Insurance_Module}    Set Variable      xpath=//android.widget.TextView[@text="My policy(s)"]//following-sibling::android.view.ViewGroup[@content-desc="See all"]
          ${iOS_EN_Insurance_Module}        Set Variable     chain=**/XCUIElementTypeOther[`label == "My policy(s) See all"`]/XCUIElementTypeOther[-1]
          Wait Until Element Is Visible    ${${platformName}_${lang}_Insurance_Module}
          Click Element    ${${platformName}_${lang}_Insurance_Module}

          #capture policy list
          Wait Until Page Contains Element    ${${platformName}_${lang}_Investment_Policy_List}         timeout=30s
          Log     Data policy name: ${Policy_Name}
          @{Policy_Name_List}         Create List
          ${Policy_Names_txt}      Get Webelements      ${${platformName}_${lang}_Investment_Policy_List}
          ${Pcount}     Get Length     ${Policy_Names_txt}
          Set Global Variable    ${Pcount}
          ${Pcount}      Evaluate    ${Pcount} + 1
          Log    ${Pcount}
          Take Screenshot     My policy Page
          FOR    ${counter}    IN RANGE    1    ${Pcount}
            Log    ${counter}
            ${Android_EN_PolicyDetails}    Set Variable    xpath=(//android.widget.TextView[@text="Current investment"])[${counter}]/ancestor::android.view.ViewGroup[2]/android.view.ViewGroup[1]
            ${iOS_EN_PolicyDetails}    Set variable    xpath=(//XCUIElementTypeStaticText[@name="My policy(s)"]/following::XCUIElementTypeScrollView/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther)[${counter}]

            Scroll Till Transaction Is Visible       ${${platformName}_${lang}_PolicyDetails}
            Sleep   1s
            Wait Until Element Is Visible        ${${platformName}_${lang}_PolicyDetails}      timeout=10s
            IF    '${platformName}' == 'Android'
                ${PolicyName}   Get Text    xpath=(//android.widget.TextView[@text="Current investment"])[${counter}]/ancestor::android.view.ViewGroup[2]/android.view.ViewGroup[1]/android.widget.TextView[1]
                ${PolicyName}       Strip String        ${PolicyName}
                ${policydata}    Set Variable    ${PolicyName}
                Set Global Variable    ${policydata}
                ${PolicyNumber}   Get Text    xpath=(//android.widget.TextView[@text="Current investment"])[${counter}]/ancestor::android.view.ViewGroup[2]/android.view.ViewGroup[1]/android.widget.TextView[2]
                @{PolicyDetailsSplit}   Split String    ${PolicyNumber}     |
                ${PolicyNumber}     Get From List    ${PolicyDetailsSplit}    0
                ${PolicyNumber}     Strip String    ${PolicyNumber}

            ELSE
                ${PolicyDetail}    Get Text          ${${platformName}_${lang}_PolicyDetails}
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
            END
            Set Calc VP Expected Result With Original And Source    Policy${counter}_ProductName      ${PolicyName}    ${PolicyName}    OMNE_InvestmentsPage

            IF    '${PolicyNumber}' == '${Policy_No}'
                ${SelectedPolicyNumber}     Set Variable        ${PolicyNumber}
                ${Android_EN_SelectedMoreDetails}    Set Variable    xpath=//android.widget.TextView[@text="Current investment"][${counter}]
                ${iOS_EN_SelectedMoreDetails}       Set Variable    chain=**/XCUIElementTypeButton[`label == "Current investment"`][${counter}]
                ${SelectedPolicy_Moredetail_Element}        Set Variable        ${${platformName}_${lang}_SelectedMoreDetails}
                Set Global Variable    ${SelectedPolicy_Moredetail_Element}
                Set Global Variable     ${SelectedPolicyNumber}
                ${SelectedPolicyName}   Set Variable    ${PolicyName}
                Set Global Variable    ${SelectedPolicyName}
            END
          END
          Take Screenshot     My policy Page

          Sleep    2s
          Scroll Till Transaction Is Visible    ${SelectedPolicy_Moredetail_Element}
          Click Element     ${SelectedPolicy_Moredetail_Element}
          ${Android_EN_policyName}  Set Variable    xpath=//android.widget.TextView[@resource-id="header-product-name"]
          ${iOS_EN_policyName}    Set Variable
          ...    accessibility_id=header-product-name
          ${Android_EN_policyrisklevel}     Set Variable    xpath=(//android.widget.TextView[@resource-id="header-product-name"]/following-sibling::android.view.ViewGroup/android.view.ViewGroup/android.widget.TextView)[1]
          ${iOS_EN_policyrisklevel}    Set Variable
          ...    xpath=((//XCUIElementTypeOther[contains(@label, '${Policy_No}')])[last()-2]/XCUIElementTypeOther/XCUIElementTypeOther)[1]
          ${Android_EN_policytype}      Set Variable    xpath=(//android.widget.TextView[@resource-id="header-product-name"]/following-sibling::android.view.ViewGroup/android.view.ViewGroup/android.widget.TextView)[3]
          ${iOS_EN_policytype}    Set Variable
          ...    xpath=((//XCUIElementTypeOther[contains(@label, '${Policy_No}')])[last()-2]/XCUIElementTypeOther/XCUIElementTypeOther)[3]
          ${Android_EN_PolicyStatus}    Set Variable    xpath=//android.widget.TextView[@text="Active" or @text="Inactive"]
          ${iOS_EN_PolicyStatus}    Set Variable
          ...     chain=**/XCUIElementTypeStaticText[`label == "Active" OR label == "Inactive"`]
          Wait Until Element Is Visible    ${${platformName}_${lang}_gainorloassvalue_txt}    timeout=20s
          Take Screenshot    FWD_investmentDetailsPage
          ${VP_InvestmentpolicyName}    Get Text    ${${platformName}_${lang}_policyName}
          ${VP_Investmentpolicytype}    Get Text    ${${platformName}_${lang}_policytype}
          ${status}    Run Keyword And Return Status    Wait Until Page Contains    Risk Level    timeout=10s
          IF    '${status}' == 'True'
                ${VP_risklevel}    Get Text    ${${platformName}_${lang}_policyrisklevel}
                @{risklevel}    Split String    ${VP_risklevel}    -
                ${policyrisklevel}    Get From List    ${risklevel}    1
                ${m_policyrisklevel}    Convert To Lower Case    ${policyrisklevel}
                Set Calc VP Expected Result With Original And Source
                ...    SelectedPolicyRisklevel
                ...    ${m_policyrisklevel.strip()}
                ...    ${policyrisklevel}
                ...    OMNE_InvestmentsPage
          END
    #    attribute=value
            ${VP_gainorloassvalueandperc}    Get Text    ${${platformName}_${lang}_gainorloassvalue_txt}
    #    attribute=value
            ${VP_policycurrentValue}    Get Text    ${${platformName}_${lang}_totalcurrentvalue}
    #    attribute=value
            ${VP_policycurrentValuemsg}    Remove String    ${VP_policycurrentValue}    ,
            ${VP_policyStatus}    Get Text    ${${platformName}_${lang}_PolicyStatus}
    #    attribute=name

            @{totalalueandpercentage}    Split String    ${VP_gainorloassvalueandperc}
            ${totalgainorlossvalue}    Get From List    ${totalalueandpercentage}    3
            ${totalgainorlossvaluemsg}    Remove String    ${totalgainorlossvalue}    ,
            ${totalgainorlosspercentage}    Get From List    ${totalalueandpercentage}    5
            ${totalprofitorloass}    Get From List    ${totalalueandpercentage}    4
            ${totalgainorlosspercentage}    Catenate    ${totalprofitorloass}    ${totalgainorlosspercentage}
            ${totalgainorlosspercentage}    Remove String    ${totalgainorlosspercentage}    ${SPACE}
            ${VP_InvestmentpolicyName}    Strip String    ${VP_InvestmentpolicyName}
            #    uncomment later
            Set Calc VP Expected Result With Original And Source
            ...    SelectedPolicyProductName
            ...    ${VP_InvestmentpolicyName}
            ...    ${VP_InvestmentpolicyName}
            ...    OMNE_InvestmentsPage
            Set Calc VP Expected Result With Original And Source
            ...    SelectedPolicyType
            ...    ${VP_Investmentpolicytype}
            ...    ${VP_Investmentpolicytype}
            ...    OMNE_InvestmentsPage

            Set Calc VP Expected Result With Original And Source
            ...    SelectedPolicyCurrentValue
            ...    ${VP_policycurrentValuemsg.strip()}
            ...    ${VP_policycurrentValuemsg.strip()}
            ...    OMNE_InvestmentsPage
            Set Calc VP Expected Result With Original And Source
            ...    SelectedPolicyGainorLossPercentage
            ...    ${totalgainorlosspercentage}
            ...    ${totalgainorlosspercentage}
            ...    OMNE_InvestmentsPage
            Set Calc VP Expected Result With Original And Source
            ...    SelectedPolicyGainorLossValue
            ...    ${totalgainorlossvaluemsg}
            ...    ${totalgainorlossvalue}
            ...    OMNE_InvestmentsPage
            Set Calc VP Expected Result With Original And Source
            ...    SelectedPolicyStatus
            ...    ${VP_policyStatus}
            ...    ${VP_policyStatus}
            ...    OMNE_InvestmentsPage

            # capture values for all funddetails
            @{totalfundelements}    Get Webelements    ${${platformName}_${lang}_listoffunds}
            Log    ${totalfundelements}
            ${totfundCount}    Get Length    ${totalfundelements}

            Log    ${totfundCount}

            Set Global Variable    ${totfundCount}
            # take screenshot of whole page
            ${totalpercdisplaystatus}    Run Keyword And Return Status
            ...    Element Should Be Visible
            ...    ${${platformName}_${lang}_totalperc}
            WHILE    '${totalpercdisplaystatus}' != 'True'
                ${hight}    Get Window Height
                ${width}    Get Window Width
                ${hight}    Evaluate    ${hight}/2
                ${width}    Evaluate    ${width}/2
                Swipe    ${width}    ${hight}    ${width}    50
                Take Screenshot    InvestmentFund_details
                ${totalpercdisplaystatus}    Run Keyword And Return Status
                ...    Element Should Be Visible
                ...    ${${platformName}_${lang}_totalperc}
                Log    ${totalpercdisplaystatus}
            END
            FOR    ${counter}    IN RANGE    0    ${totfundCount}
                ${webelement}    Get From List    ${totalfundelements}    ${counter}
                ${funddata}    Get Element Attribute    ${webelement}    attribute=name

                IF    '${platformName}' == 'Android'
                    ${objectcounter}    Evaluate    ${counter}+1
                    ${funddata1}    Get Text       xpath=(//android.widget.TextView[@text="Current value (THB)"])[${objectcounter}]/preceding-sibling::android.widget.TextView[2]
                    ${funddata1}    Strip String    ${funddata1}
                    Log    ${funddata1}
                    ${fundnameMerge}    Set Variable    ${funddata1}
                    ${Fund_dic}    Set To Dictionary    ${Fund_dic}    ${fundnameMerge}=${counter}
                    ${fundgainorloassvalues}    Get Text
                    ...    xpath=(//android.widget.TextView[@text='${fundnameMerge}']/..//android.widget.TextView)[1]
                    ${fundgainorloassvalues}    Split String    ${fundgainorloassvalues}
                    Log    ${fundgainorloassvalues}
                    ${fundgainorloassvalue}    Get From List    ${fundgainorloassvalues}    3
                    ${fundgainorloassvaluemsg}    Remove String    ${fundgainorloassvalue}    ,
                    ${gainorloss}    Get From List    ${fundgainorloassvalues}    4
                    ${fundpolicygainorlossperc}    Get From List    ${fundgainorloassvalues}    5
                    ${fundperc}    Get Text
                    ...    xpath=//android.widget.TextView[@text='${fundnameMerge}']/following-sibling::android.widget.TextView[1]
                    ${fundperc}    Remove String    ${fundperc}    %
                    ${fundperc}    Strip String    ${fundperc}
                    ${fundperc}    Convert To Number    ${fundperc}    2
                    ${fundcurrentvalue}    Get Text
                    ...    xpath=//android.widget.TextView[@text='${fundnameMerge}']/..//android.widget.TextView[@text='Current value (THB)']/following-sibling::android.widget.TextView[1]
                    ${fundcurrentvalue}    Strip String    ${fundcurrentvalue}
                    ${fundcurrentvaluemsg}    Remove String    ${fundcurrentvalue}    ,
                    ${fundunitholding}    Get Text
                    ...    xpath=//android.widget.TextView[@text='${fundnameMerge}']/..//android.widget.TextView[@text='Unit holding']/following-sibling::android.widget.TextView[1]
                    ${fundunitholding}    Strip String    ${fundunitholding}
                    ${fundunitholdingmsg}    Remove String    ${fundunitholding}    ,
                    ${fundunitprice}    Get Text
                    ...    xpath=//android.widget.TextView[@text='${fundnameMerge}']/..//android.widget.TextView[@text='Unit price (THB)']/following-sibling::android.widget.TextView[1]
                    ${fundunitprice}    Strip String    ${fundunitprice}
                    ${fundunitpricemsg}    Convert To Number    ${fundunitprice}        2
                    ${fundate}    Get Text
                    ...    xpath=//android.widget.TextView[@text='${fundnameMerge}']/..//android.widget.TextView[@text='Date']/following-sibling::android.widget.TextView[1]
                    ${fundate}    Strip String    ${fundate}
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_Name
                    ...    ${fundnameMerge}
                    ...    ${fundnameMerge}
                    ...    OMNE_InvestmentsPage
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_GainorLossValue
                    ...    ${fundgainorloassvaluemsg}
                    ...    ${fundgainorloassvalue}
                    ...    OMNE_InvestmentsPage
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_GainorLossPercentage
                    ...    ${gainorloss}${fundpolicygainorlossperc}
                    ...    ${gainorloss}${fundpolicygainorlossperc}
                    ...    OMNE_InvestmentsPage
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_Percentage
                    ...    ${fundperc}%
                    ...    ${fundperc}%
                    ...    OMNE_InvestmentsPage
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_CurrentValue
                    ...    ${fundcurrentvaluemsg}
                    ...    ${fundcurrentvalue}
                    ...    OMNE_InvestmentsPage
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_UnitHolding
                    ...    ${fundunitholdingmsg}
                    ...    ${fundunitholding}
                    ...    OMNE_InvestmentsPage
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_UnitPrice
                    ...    ${fundunitpricemsg}
                    ...    ${fundunitprice}
                    ...    OMNE_InvestmentsPage
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_Date
                    ...    ${fundate}
                    ...    ${fundate}
                    ...    OMNE_InvestmentsPage
                ELSE
                    @{fundsvalue}    Split String    ${funddata}    %
                    ${fundvalue}    Get From List     ${fundsvalue}    1
                    ${fundvalue}    Strip String    ${fundvalue}
                    ${fundvalue}    Split String    ${fundvalue}    ${SPACE}
                    ${funddata1}    Get From List     ${fundvalue}    0
                    ${funddata1}    Replace String       ${funddata1}    -A     ${Space}
                    ${funddata1}    Strip String    ${funddata1}
                    Log    ${funddata1}
                    ${fundnameMerge}    Set Variable    ${funddata1}
                    ${Fund_dic}    Set To Dictionary    ${Fund_dic}    ${fundnameMerge}=${counter}
                    @{fundsvalue}    Split String    ${funddata}    %
                    # currentvalue of gainorlossvalue and percentage
                    ${gainorlossvalueandper}    Get From List    ${fundsvalue}    0
                    ${gainorlossvalueandper}    Split String    ${gainorlossvalueandper}
                    ${gainorlossvalue}    Get From List    ${gainorlossvalueandper}    3    # 0
                    ${gainorlossvaluemsg}    Remove String    ${gainorlossvalue}    ,
                    ${gainorloss}    Get From List    ${gainorlossvalueandper}    4    # 1
                    ${gainorlossperc}    Get From List    ${gainorlossvalueandper}    5
                    ${gainorlossperc}    Catenate    ${gainorloss}    ${gainorlossperc}
                    ${gainorlossperc}    Remove String    ${gainorlossperc}    ${SPACE}
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_GainorLossPercentage
                    ...    ${gainorlossperc}%
                    ...    ${gainorlossperc}%
                    ...    OMNE_InvestmentsPage
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_GainorLossValue
                    ...    ${gainorlossvaluemsg}
                    ...    ${gainorlossvalue}
                    ...    OMNE_InvestmentsPage
                    # fundname and fund perc
                    ${fundnameandperc}    Get From List    ${fundsvalue}    1
                    ${fundnameandpercvalue}    Split String    ${fundnameandperc}
                    ${fundnameandpercvaluelength}    Get Length    ${fundnameandpercvalue}
                    Log    ${fundnameandpercvaluelength}
                    ${fundnameandpercvaluelength}    Evaluate    ${fundnameandpercvaluelength}-1
                    IF    '${fundnameandpercvaluelength}' == '1'
                        ${fundnameMerge}    Get From List    ${fundnameandpercvalue}    0
                        ${fundnameMerge}    Strip String    ${fundnameMerge}
                    ELSE
                        ${fundnameMerge}    Set Variable
                        FOR    ${namecounter}    IN RANGE    0    ${fundnameandpercvaluelength}
                            Log    ${namecounter}
                            ${fundname}    Get From List    ${fundnameandpercvalue}    ${namecounter}
                            ${fundnameMerge}    Catenate    ${fundnameMerge}    ${fundname}
                            Log    ${fundnameMerge}
                            ${fundnameMerge}    Strip String    ${fundnameMerge}
                        END
                    END
                    ${fundperc}    Get From List    ${fundnameandpercvalue}    ${fundnameandpercvaluelength}
                    ${fundperc}    Evaluate    "%.2f" % ${fundperc}
                    ${fundperc}    Replace String    ${fundperc}    .00    .0
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_Percentage
                    ...    ${fundperc}%
                    ...    ${fundperc}%
                    ...    OMNE_InvestmentsPage
                    ${Fund_dic}    Set To Dictionary    ${Fund_dic}    ${fundnameMerge}=${counter}
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_Name
                    ...    ${fundnameMerge}
                    ...    ${fundnameMerge}
                    ...    OMNE_InvestmentsPage

                    # fundpremiumvalue
                    ${fundpremiums}    Get From List    ${fundsvalue}    2
                    @{fundallpremiums}    Split String    ${fundpremiums}
                    ${fundcurrentvalue}    Get From List    ${fundallpremiums}    3
                    ${fundcurrentvaluemsg}    Remove String    ${fundcurrentvalue}    ,
                    ${fundunitholding}    Get From List    ${fundallpremiums}    6
                    ${fundunitholdingmsg}    Remove String    ${fundunitholding}    ,
                    ${fundunitprice}    Get From List    ${fundallpremiums}    10
                    ${fundunitpricemsg}    Convert To Number    ${fundunitprice}    2
                    @{fundatevalue}    Split String    ${fundpremiums}    Date
                    ${fundate}    Get From List    ${fundatevalue}    1
                    ${fundate}    Strip String    ${fundate}
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_CurrentValue
                    ...    ${fundcurrentvaluemsg}
                    ...    ${fundcurrentvaluemsg}
                    ...    OMNE_InvestmentsPage
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_UnitHolding
                    ...    ${fundunitholdingmsg}
                    ...    ${fundunitholding}
                    ...    OMNE_InvestmentsPage
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_UnitPrice
                    ...    ${fundunitpricemsg}
                    ...    ${fundunitprice}
                    ...    OMNE_InvestmentsPage
                    Set Calc VP Expected Result With Original And Source
                    ...    Fund${counter}_Date
                    ...    ${fundate}
                    ...    ${fundate}
                    ...    OMNE_InvestmentsPage
                END
                IF    '${Core_System}' != ''
                    Set Calc VP Expected Result With Original And Source
                    ...    ${Core_System}_Fund${counter}_FundName
                    ...    ${funddata1}
                    ...    ${fundnameMerge}
                    ...    OMNE_InvestmentsPage
                    Set Calc VP Expected Result With Original And Source
                    ...    ${Core_System}_Fund${counter}_Percentage
                    ...    ${fundperc}%
                    ...    ${fundperc}%
                    ...    OMNE_InvestmentsPage
                    Set Calc VP Expected Result With Original And Source
                    ...    ${Core_System}_Fund${counter}_UnitHolding
                    ...    ${fundunitholdingmsg}
                    ...    ${fundunitholding}
                    ...    OMNE_InvestmentsPage
                END
            END
            Set Global Variable    ${result}    View Policy Investment Inquiry Successfully for policy ${Policy_No}
            Set Global Variable    ${Fund_dic}
            Get Investment DB VPs
            Set Global Variable    ${result}    ${result} | View Policy Investment DB Query is successful
    #    END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   FWD Insurance Flow of ${Insurance_Flow}
    END

Get Investment DB VPs
    TRY
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
    #    Get Risk Details
        ${policyrisklevel}    Run Keyword    Get Risk Level
        ...    ${dbhostname}
        ...    ${dbusername}
        ...    ${dbpassword}
        ...    ${dbport}
        ...    ${dbinstance}
        ...    ${OwnerUserId}
        ...    ${screenshotPath}
        Log    ${policyrisklevel}
        ${Investmentdf}    Run Keyword
        ...    Get Investment Details from DB
        ...    ${dbhostname}
        ...    ${dbusername}
        ...    ${dbpassword}
        ...    ${dbport}
        ...    ${dbinstance}
        ...    ${OwnerUserId}
        ...    ${screenshotPath}
        Log    ${Investmentdf}
        ${leng}    Get Length    ${Investmentdf}
        Log    ${leng}
    #    Get Index for Column Header
        ${list0}    Get From List    ${Investmentdf}    0
        Log    ${list0}
        ${index1}    Get Index From List    ${list0}    ProductName
        Log    ${index1}
        ${index2}    Get Index From List    ${list0}    ExternalRemoteId
        Log    ${index2}
        ${index3}    Get Index From List    ${list0}    Totalfundprice
        Log    ${index3}
        ${index4}    Get Index From List    ${list0}    TotalGainLoss
        Log    ${index4}
        ${index5}    Get Index From List    ${list0}    PolicyStatus
        Log    ${index5}
        ${index6}    Get Index From List    ${list0}    Id
        Log    ${index6}
        ${index7}    Get Index From List    ${list0}    ProductCategory
        Log    ${index7}
        ${index8}    Get Index From List    ${list0}    TotalWeightedCost
        Log    ${index8}
        FOR    ${counter}    IN RANGE    1    ${leng}
            Log    ${counter}
            ${list}    Get From List    ${Investmentdf}    ${counter}
    #    ${type_list}    Evaluate    type(${list})
    #    Log    ${type_list}
            ${ActualSource}    Set Variable    View Investment DB Query
            ${policystatus}    Set Variable    ${list}[${index5}]
            Log    ${policystatus}
            ${ProductName}    Set Variable    ${list}[${index1}]
            ${ProductName}    Strip String    ${ProductName}
            Log    ${ProductName}
            ${ExternalRemoteId}    Set Variable    ${list}[${index2}]
            Log    ${ExternalRemoteId}
            ${policynumber}    AES Decrypt    ${key}    ${ExternalRemoteId}
            Log    ${policynumber}
            ${gainorloassvalue}    Set Variable    ${list}[${index4}]
            Log    ${gainorloassvalue}
            ${gainorloassvalue}    Evaluate    abs(${gainorloassvalue})
            Log    ${gainorloassvalue}
    #    ${gainorloassvalue}=    Evaluate    "%.2f" % ${gainorloassvalue}
    #    ${gainorloassvalue}    Convert To Number    ${gainorloassvalue}
    #    ${gainorloassvalue}=    Format String    {:,}    ${gainorloassvalue}
            ${gainorloassvalue}    Evaluate    "%.2f" % ${gainorloassvalue}
            Log    ${gainorloassvalue}
            ${Currentvalue}    Set Variable    ${list}[${index3}]
            Log    ${Currentvalue}
            ${TotalFundPrice}    Set Variable    ${Currentvalue}
            ${TotalWeightedCost}    Set Variable    ${list}[${index8}]
            Log    ${TotalWeightedCost}
            ${policygainorlossperc}    Evaluate    ((${TotalFundPrice}-${TotalWeightedCost})/${TotalWeightedCost})*100
            ${policygainorlossperc}    Convert To Number    ${policygainorlossperc}    2
            Log    ${policygainorlossperc}
            ${SelectedPolicyType}    Set Variable    ${list}[${index7}]
            Log    ${SelectedPolicyType}
            IF    '${Policy_No}' == '${policynumber}'
                ${Policy_No_Decrypt}    Set Variable    ${list}[${index6}]
                ${Selected_policyStatus}    Set Variable    ${policystatus}
                ${Selected_ProductName}    Set Variable    ${ProductName}
                ${SelectedPolicyCurrentValue}    Set Variable    ${Currentvalue}
                ${SelectedPolicyGainorLossValue}    Set Variable    ${gainorloassvalue}
                ${SelectedPolicyType}    Set Variable    ${SelectedPolicyType}
                ${SelectedPolicyGainorLossPercentage}    Set Variable    ${policygainorlossperc}
            END

            ${gainorlossperc1}    Convert To String    ${policygainorlossperc}
            ${gainorlossperc11}    Get Substring    ${gainorlossperc1}    0    1
            ${result}    Check Type    ${gainorlossperc11}
            IF    '${result}' == 'INTEGER'
                ${policygainorlossperc}    Set Variable    +${policygainorlossperc}
            END
    #    ${Currentvalue}    Convert To Number    ${Currentvalue}
    #    ${Currentvalue}=    Format String    {:,}    ${Currentvalue}
    #    ${Currentvalue}=    Evaluate    "%.2f" % ${Currentvalue}
            ${Currentvalue}    Evaluate    "%.2f" % ${Currentvalue}
            Log    ${Currentvalue}
            ${policystatusCase}    Convert To Upper Case    ${policystatus}
    #        ${newcounter}    Evaluate    ${counter}-1
    #        Set Calc VP Actual Result With Original And Source
    #        ...    Policy${newcounter}_Status
    #        ...    ${policystatusCase}
    #        ...    ${policystatus}
    #        ...    ${ActualSource}
            Set Calc VP Actual Result With Original And Source
            ...    Policy${counter}_ProductName
            ...    ${productname}
            ...    ${productname}
            ...    ${ActualSource}
    #        Set Calc VP Actual Result With Original And Source
    #        ...    Policy${newcounter}_Number
    #        ...    ${policynumber}
    #        ...    ${policynumber}
    #        ...    ${ActualSource}
    #        Set Calc VP Actual Result With Original And Source
    #        ...    Policy${newcounter}_GainOrLossPercentage
    #        ...    ${policygainorlossperc}%
    #        ...    ${policygainorlossperc}%
    #        ...    ${ActualSource}
    #        Set Calc VP Actual Result With Original And Source
    #        ...    Policy${newcounter}_GainOrLossValue
    #        ...    ${gainorloassvalue}
    #        ...    ${gainorloassvalue}
    #        ...    ${ActualSource}
    #        Set Calc VP Actual Result With Original And Source
    #        ...    Policy${newcounter}_CurrentValue
    #        ...    ${Currentvalue}
    #        ...    ${Currentvalue}
    #        ...    ${ActualSource}
        END

        IF    '${Policy_No_Decrypt}' != '${EMPTY}'
            ${ActualSource}    Set Variable    View Investment Fund DB Query
            IF    '${policyrisklevel}' != ''
                ${m_policyrisklevel}    Convert To Lower Case    ${policyrisklevel}
                Set Calc VP Actual Result With Original And Source
                ...    SelectedPolicyRisklevel
                ...    ${m_policyrisklevel.strip()}
                ...    ${policyrisklevel}
                ...    View Investment Risk DB Query
            END
            Set Calc VP Actual Result With Original And Source
            ...    SelectedPolicyStatus
            ...    ${Selected_policyStatus}
            ...    ${Selected_policyStatus}
            ...    ${ActualSource}
    #    uncomment later
            Set Calc VP Actual Result With Original And Source
            ...    SelectedPolicyProductName
            ...    ${Selected_ProductName}
            ...    ${Selected_ProductName}
            ...    ${ActualSource}
    #    ${SelectedPolicyCurrentValueformat}    Convert To Number    ${SelectedPolicyCurrentValue}
    #    ${SelectedPolicyCurrentValueformat}=    Format String    {:,}    ${SelectedPolicyCurrentValueformat}
    #    ${SelectedPolicyCurrentValueformat}=    Evaluate    "%.2f" % ${SelectedPolicyCurrentValueformat}
            ${SelectedPolicyCurrentValueformat}    Evaluate    "%.2f" % ${SelectedPolicyCurrentValue}
            Log    ${SelectedPolicyCurrentValueformat}
            Set Calc VP Actual Result With Original And Source
            ...    SelectedPolicyCurrentValue
            ...    THB ${SelectedPolicyCurrentValueformat.strip()}
            ...    THB ${SelectedPolicyCurrentValueformat.strip()}
            ...    ${ActualSource}
            Set Calc VP Actual Result With Original And Source
            ...    SelectedPolicyGainorLossValue
            ...    ${SelectedPolicyGainorLossValue}
            ...    ${SelectedPolicyGainorLossValue}
            ...    ${ActualSource}
            Set Calc VP Actual Result With Original And Source
            ...    SelectedPolicyType
            ...    ${SelectedPolicyType}
            ...    ${SelectedPolicyType}
            ...    ${ActualSource}
            ${gainorlossperc1}    Convert To String    ${SelectedPolicyGainorLossPercentage}
            ${gainorlossperc11}    Get Substring    ${gainorlossperc1}    0    1
            ${result}    Check Type    ${gainorlossperc11}
            IF    '${result}' == 'INTEGER'
                ${SelectedPolicyGainorLossPercentage}    Set Variable    +${SelectedPolicyGainorLossPercentage}
            END
            Set Calc VP Actual Result With Original And Source
            ...    SelectedPolicyGainorLossPercentage
            ...    ${SelectedPolicyGainorLossPercentage}%
            ...    ${SelectedPolicyGainorLossPercentage}%
            ...    ${ActualSource}

            ${InvestmentFunddf}    Run Keyword
            ...    Get Policy Fund Details from DB
            ...    ${dbhostname}
            ...    ${dbusername}
            ...    ${dbpassword}
            ...    ${dbport}
            ...    ${dbinstance}
            ...    ${Policy_No_Decrypt}
            ...    ${screenshotPath}
            Log    ${InvestmentFunddf}
            ${leng}    Get Length    ${InvestmentFunddf}
            Log    ${leng}
            ${list0}    Get From List    ${InvestmentFunddf}    0
            Log    ${list0}
            ${index1}    Get Index From List    ${list0}    GainLoss
            Log    ${index1}
            ${index2}    Get Index From List    ${list0}    AMCFundcode
            Log    ${index2}
            ${index3}    Get Index From List    ${list0}    CurrentValue
            Log    ${index3}
            ${index4}    Get Index From List    ${list0}    UnitHolding
            Log    ${index4}
            ${index5}    Get Index From List    ${list0}    ValuationPrice
            Log    ${index5}
            ${index6}    Get Index From List    ${list0}    ValuationDate
            Log    ${index6}
            ${index7}    Get Index From List    ${list0}    Currency
            Log    ${index7}
            ${index8}    Get Index From List    ${list0}    WeightedCost
            Log    ${index8}
            FOR    ${counter}    IN RANGE    1    ${leng}
                Log    ${counter}
                ${list}    Get From List    ${InvestmentFunddf}    ${counter}
                #    ${type_list}    Evaluate    type(${list})
                #    Log    ${type_list}
                ${gainorlossvalue}    Set Variable    ${list}[${index1}]
                Log    ${gainorlossvalue}
                ${gainorlossvalue}    Evaluate    abs(${gainorlossvalue})
                Log    ${gainorlossvalue}
    #    ${gainorlossvalue}    Convert To Number    ${gainorlossvalue}
    #    ${gainorlossvalue}=    Format String    {:,}    ${gainorlossvalue}
    #    ${gainorlossvalue}=    Evaluate    "%.2f" % ${gainorlossvalue}
                ${gainorlossvalue}    Evaluate    "%.2f" % ${gainorlossvalue}
                Log    ${gainorlossvalue}
                ${fundnameMerge}    Set Variable    ${list}[${index2}]
                Log    ${fundnameMerge}
                ${fundcurrentvalue}    Set Variable    ${list}[${index3}]
                Log    ${fundcurrentvalue}
                ${fundperc}    Evaluate    (${fundcurrentvalue}/${SelectedPolicyCurrentValue})*100
                ${fundperc}    Convert To Number    ${fundperc}    2
                Log    ${fundperc}
    #    ${fundcurrentvalue}    Convert To Number    ${fundcurrentvalue}
    #    ${fundcurrentvalue}=    Format String    {:,}    ${fundcurrentvalue}
    #    ${fundcurrentvalue}=    Evaluate    "%.2f" % ${fundcurrentvalue}
                ${fundcurrentvalue}    Evaluate    "%.2f" % ${fundcurrentvalue}
                Log    ${fundcurrentvalue}

    #    ${policynumber}    AES Decrypt    ${key}    ${ExternalRemoteId}
    #    Log    ${policynumber}
    #    IF    '${Policy_No}' == '${policynumber}'
    #    ${Policy_No_Decrypt}    Set Variable    ${ExternalRemoteId}
    #    END
                ${fundunitholding}    Set Variable    ${list}[${index4}]
                Log    ${fundunitholding}
                ${fundunitholding}    Evaluate    "%.4f" % ${fundunitholding}
    #    ${fundunitholding}    Convert To Number    ${fundunitholding}
    #    ${fundunitholding}=    Format String    {:,}    ${fundunitholding}
    #    ${fundunitholding}=    Evaluate    "%.2f" % ${fundunitholding}
    #    ${fundunitholding}=    Evaluate    "%.2f" % ${fundunitholding}
                Log    ${fundunitholding}
                ${fundunitprice}    Set Variable    ${list}[${index5}]
                ${fundunitpricemsg}    Convert To Number    ${fundunitprice}    2
                Log    ${fundunitprice}
                ${WeightedCost}    Set Variable    ${list}[${index8}]
                Log    ${WeightedCost}
                ${ValuationPrice}    Set Variable    ${fundunitprice}
                ${gainorlossperc}    Evaluate    ((${ValuationPrice}-${WeightedCost})/${WeightedCost})*100
                ${gainorlossperc}    Convert To Number    ${gainorlossperc}    2
                Log    ${gainorlossperc}
                ${gainorlossperc1}    Convert To String    ${gainorlossperc}
                ${gainorlossperc11}    Get Substring    ${gainorlossperc1}    0    1
                ${result}    Check Type    ${gainorlossperc11}
                IF    '${result}' == 'INTEGER'
                    ${gainorlossperc}    Set Variable    +${gainorlossperc}
                END
                ${fundate}    Set Variable    ${list}[${index6}]
                Log    ${fundate}
                ${fundate}    Convert Date    ${fundate}    result_format=%d %b %Y
                Log    ${fundate}
    #    ${Fund_dic}=    Set To Dictionary    ${Fund_dic}    Fund${counter}_Name=${counter}
                Log    ${Fund_dic}
                ${newcounter}    Get From Dictionary    ${Fund_dic}    ${fundnameMerge}

                Set Calc VP Actual Result With Original And Source
                ...    Fund${newcounter}_GainorLossPercentage
                ...    ${gainorlossperc}%
                ...    ${gainorlossperc}%
                ...    ${ActualSource}
                Set Calc VP Actual Result With Original And Source
                ...    Fund${newcounter}_GainorLossValue
                ...    ${gainorlossvalue}
                ...    ${gainorlossvalue}
                ...    ${ActualSource}
                Set Calc VP Actual Result With Original And Source
                ...    Fund${newcounter}_Percentage
                ...    ${fundperc}%
                ...    ${fundperc}%
                ...    ${ActualSource}
                Set Calc VP Actual Result With Original And Source
                ...    Fund${newcounter}_Name
                ...    ${fundnameMerge}
                ...    ${fundnameMerge}
                ...    ${ActualSource}
                Set Calc VP Actual Result With Original And Source
                ...    Fund${newcounter}_CurrentValue
                ...    ${fundcurrentvalue}
                ...    ${fundcurrentvalue}
                ...    ${ActualSource}
                Set Calc VP Actual Result With Original And Source
                ...    Fund${newcounter}_UnitHolding
                ...    ${fundunitholding}
                ...    ${fundunitholding}
                ...    ${ActualSource}
                Set Calc VP Actual Result With Original And Source
                ...    Fund${newcounter}_UnitPrice
                ...    ${fundunitpricemsg}
                ...    ${fundunitprice}
                ...    ${ActualSource}
                Set Calc VP Actual Result With Original And Source
                ...    Fund${newcounter}_Date
                ...    ${fundate}
                ...    ${fundate}
                ...    ${ActualSource}
            END
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP       Omne_Flow   ${reason}   Get Investment DB VPs
    END
Check Type
    [Documentation]    Checks if the ${object } is INTEGER, NUMBER or STRING
    [Arguments]    ${object}
    IF    not "${object}"    RETURN    NONE
    ${result}    ${value}    Run Keyword And Ignore Error    Convert To Number    ${object}
    ${isnumber}    Run Keyword And Return Status    Should Be Equal As Strings    ${object}    ${value}
    ${result}    ${value}    Run Keyword And Ignore Error    Convert To Integer    ${object}
    ${isinteger}    Run Keyword And Return Status    Should Be Equal As Strings    ${object}    ${value}
    IF    ${isnumber}    RETURN    NUMBER
    IF    ${isinteger}    RETURN    INTEGER
    RETURN    STRING
