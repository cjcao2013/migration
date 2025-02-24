*** Variables ***
${obj_enq_ProposalsandContracts}    xpath=//span[text()='Proposals and Contracts']
${obj_enq_contractEnquiry}          xpath=(//span[text()='Contract Enquiries'])[1]
${obj_enq_ContractDetails}          xpath=(//span[text()='Contract Details'])[1]
${obj_enq_contractNumber}           id=CHDRSEL
${obj_OK_btn}                       xpath://span[text()='OK']
${obj_BUPlan_Dropdown}              id=SELECT_2
${obj_ViewPolicySumAssured}         id=SUMINS

${obj_address_street1}              id:DESPADDR01
${obj_address_street2}              id:DESPADDR02
${obj_address_subdistrict}          id:DESPADDR05
${obj_address_district}             id:DESPADDR03
${obj_address_city}                 id:DESPADDR04
${obj_address_country}              id:DESPPCODE
${obj_planComponent}                id=PLANCOMP
${obj_Extra_Details}                xpath://a[text()="Extra Details"]
${obj_Despatch_addr}                xpath://a[text()="Despatch Addr"]
${obj_TaxConsentValue}              xpath://span[@id='ZTAXFLG']
