*** Settings ***
Library    Browser
Library    Collections
Library    String

Resource    ../Variables/variables.robot
Resource    ../Variables/VariableLoginFarmer.robot

*** Keywords ***
Fill Farmer Login Form
    [Arguments]    ${farmer_id}    ${password}
    Click    ${TAB_FARMER}
    Run Keyword If    '${farmer_id}' != 'None' and '${farmer_id}' != ''
    ...    Fill Text    ${TXT_USERNAME}    ${farmer_id}
    Run Keyword If    '${password}' != 'None' and '${password}' != ''
    ...    Fill Text    ${TXT_PASSWORD}    ${password}

Submit Login
    Click    ${BTN_LOGIN}

Get Actual Login Message
    ${old_timeout}=    Set Browser Timeout    2s

    ${dialog_status}    ${dialog_value}=    Run Keyword And Ignore Error
    ...    Get Text    ${DIALOG_DESCRIPTION}
    ${dialog_text}=    Set Variable If    '${dialog_status}' == 'PASS'    ${dialog_value}    ${EMPTY}

    ${form_status}    ${form_value}=    Run Keyword And Ignore Error
    ...    Get Form Error Messages
    ${form_text}=    Set Variable If    '${form_status}' == 'PASS'    ${form_value}    ${EMPTY}

    Set Browser Timeout    ${old_timeout}

    ${actual}=    Catenate    SEPARATOR=${SPACE}    ${dialog_text}    ${form_text}
    ${actual}=    Strip String    ${actual}

    ${actual}=    Set Variable If    '${actual}' == ''    เข้าสู่ระบบสำเร็จ    ${actual}

    RETURN    ${actual}

Get Form Error Messages
    ${elements}=    Get Elements    ${FORM_MESSAGE}
    ${texts}=       Create List
    FOR    ${el}    IN    @{elements}
        ${is_visible}=    Get Element States    ${el}    contains    visible
        IF    ${is_visible}
            ${txt}=    Get Text    ${el}
            IF    $txt != ''
                Append To List    ${texts}    ${txt}
            END
        END
    END
    ${joined}=    Catenate    SEPARATOR=${SPACE}    @{texts}
    RETURN    ${joined}

Verify Login Message
    [Arguments]    ${actual}    ${expected}
    Should Contain    ${actual}    ${expected}

Logout After Login
    Run Keyword And Ignore Error    Click    ${BTN_USER_MENU}
    Sleep    1s
    Run Keyword And Ignore Error    Click    ${BTN_LOGOUT}
    Sleep    1s

Close Error Dialog If Present
    Run Keyword And Ignore Error    Click    ${DIALOG_CLOSE_BTN}

Capture Screenshot
    [Arguments]    ${testcase_id}    ${feature_name}
    Take Screenshot
    ...    filename=${SCREENSHOT_BASE_DIR}/${feature_name}/${testcase_id}
    ...    fileType=png