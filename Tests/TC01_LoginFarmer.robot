*** Settings ***
Library     ExcelLibrary
Library     String
Resource    ../Resources/Keywords/CommonKeyword.robot
Resource    ../Resources/Keywords/KeywordLoginFarmer.robot

Suite Setup      Run Keywords
...            Start Application
...    AND    Open Application Browser    ${LOGIN_URL}
...    AND    Open Excel Document    ${EXCEL_PATH}    doc_id=FarmerLogin

Suite Teardown    Run Keywords
...    Close All Excel Documents
...    AND    Close Application Browser
...    AND    Stop Application

Test Template    Farmer Login Template

*** Variables ***
${FEATURE_NAME}    LoginFarmer
${SHEET_NAME}      Login Farmer

*** Test Cases ***
TC01_001    2
TC01_002    3
TC01_003    4
TC01_004    5
TC01_005    6
TC01_006    7
TC01_007    8
TC01_008    9
TC01_009    10
TC01_010    11
TC01_011    12
TC01_012    13
TC01_013    14
TC01_014    15
TC01_015    16
TC01_016    17

*** Keywords ***
Farmer Login Template
    [Arguments]    ${row}

    ${run_status}=    Read Excel Cell    ${row}    1    sheet_name=${SHEET_NAME}
    ${run_status}=    Convert To String    ${run_status}
    ${run_status}=    Strip String    ${run_status}

    ${is_skip}=    Evaluate    '${run_status}'.lower() == 'no'
    Run Keyword If    ${is_skip}    Pass Execution    ข้ามการทดสอบ

    ${testcase_id}=    Read Excel Cell    ${row}    2    sheet_name=${SHEET_NAME}
    ${testcase_id}=    Convert To String    ${testcase_id}

    Go To    ${LOGIN_URL}

    ${farmer_id}=    Read Excel Cell    ${row}    4    sheet_name=${SHEET_NAME}
    ${password}=     Read Excel Cell    ${row}    5    sheet_name=${SHEET_NAME}
    ${expected}=     Read Excel Cell    ${row}    6    sheet_name=${SHEET_NAME}

    ${farmer_id}=    Convert To String    ${farmer_id}
    ${password}=     Convert To String    ${password}
    ${expected}=     Convert To String    ${expected}
    ${expected}=     Strip String    ${expected}

    Fill Farmer Login Form    ${farmer_id}    ${password}
    Submit Login

    ${actual}=    Get Actual Login Message

    Write Excel Cell    ${row}    7    ${actual}    sheet_name=${SHEET_NAME}

    Capture Screenshot    ${testcase_id}    ${FEATURE_NAME}

    ${status}    ${error_message}=    Run Keyword And Ignore Error
    ...    Verify Login Message    ${actual}    ${expected}
    ${is_passed}=    Set Variable    ${status == 'PASS'}

    Run Keyword If    ${is_passed}
    ...    Write Excel Cell    ${row}    8    Pass    sheet_name=${SHEET_NAME}
    ...    ELSE
    ...    Write Excel Cell    ${row}    8    Fail: ${error_message}    sheet_name=${SHEET_NAME}

    Save Excel Document    ${EXCEL_PATH}

    Close Error Dialog If Present

    Run Keyword If    ${is_passed}
    ...    Run Keywords
    ...    Run Keyword And Ignore Error    Logout After Login
    ...    AND    Go To    ${LOGIN_URL}

    Run Keyword And Continue On Failure
    ...    Should Be True    ${is_passed}    TC${testcase_id} failed: actual="${actual}" expected="${expected}"