*** Settings ***
Library           SeleniumLibrary
Library           DataDriver

*** Variables ***
${EXCEL_FILE}       C:/Users/223741/Downloads/QKFolder/ExcelData/Test_Case.xlsx
${TEST_CASE_SHEET}          TestCases
${TEST_DATA_SHEET}          TestData
${URL}          https://example.com/login
${BROWSER}        Chrome

*** Test Cases ***
Read Test Cases And Execute
    [Documentation]    Read test cases and test data from an Excel file, execute them dynamically, and update the results.

    Open Excel    ${EXCEL_FILE}

    # Get number of rows in Test Cases sheet
    ${row_count}=    Get Row Count    ${TEST_CASE_SHEET}

    # Loop through all rows in the Test Cases sheet
    FOR    ${row}    IN RANGE    2    ${row_count + 1}
        ${test_case_id}=    Read Cell Data    ${TEST_CASE_SHEET}    ${row}    1
        ${test_data_id}=    Read Cell Data    ${TEST_CASE_SHEET}    ${row}    2
        ${expected_result}= Read Cell Data    ${TEST_CASE_SHEET}    ${row}    3

        # Fetch test data based on Test Data ID
        ${username}=    Get Test Data From Sheet    ${test_data_id}    Username
        ${password}=    Get Test Data From Sheet    ${test_data_id}    Password

        # Execute the test case
        ${status}=      Run Keyword And Return Status    Execute Test    ${username}    ${password}    ${expected_result}
        ${result}=      Run Keyword If    ${status}    Set Variable    PASS    ELSE    FAIL

        # Update the status in the Excel sheet
        Write To Cell    ${TEST_CASE_SHEET}    ${row}    4    ${result}
    END

    Save Excel
    Close Excel

*** Keywords ***
Get Test Data From Sheet
    [Arguments]    ${test_data_id}    ${column_name}
    ${row_count}=    Get Row Count    ${TEST_DATA_SHEET}
    FOR    ${row}    IN RANGE    2    ${row_count + 1}
        ${current_id}=    Read Cell Data    ${TEST_DATA_SHEET}    ${row}    1
        Run Keyword If    '${current_id}' == '${test_data_id}'    Return From Keyword    Read Cell Data    ${TEST_DATA_SHEET}    ${row}    @{column_name}
    END
    Fail    Test Data ID ${test_data_id} not found in ${TEST_DATA_SHEET}

Execute Test
    [Arguments]    ${username}    ${password}    ${expected_result}
    Open Browser       ${URL}    ${BROWSER}
    Input Text         id=username    ${username}
    Input Text         id=password    ${password}
    Click Button       id=loginButton

    ${is_welcome}=     Run Keyword And Return Status    Wait Until Element Is Visible    id=welcomeMessage    timeout=10
    ${actual_result}=  Run Keyword If    ${is_welcome}    Get Text    id=welcomeMessage    ELSE    Get Text    id=errorMessage

    Should Be Equal    ${actual_result}    ${expected_result}
    Close Browser