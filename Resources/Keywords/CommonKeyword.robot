*** Settings ***
Library    Browser
Library    Process
Library    OperatingSystem

Resource    ../Variables/variables.robot

*** Keywords ***
Open Application Browser
    [Arguments]    ${url}
    New Browser    browser=${BROWSER}    headless=${HEADLESS}
    New Context    viewport={"width": 1920, "height": 1000}
    New Page       about:blank
    Wait Until Keyword Succeeds    10x    5s    Go To Page    ${url}

Go To Page
    [Arguments]    ${url}
    Go To    ${url}
    Wait For Elements State    css=body    visible    timeout=10s

Close Application Browser
    Run Keyword And Ignore Error    Close Browser
    Run Keyword And Ignore Error    Close Browser    ALL

Start Application
    Run Keyword And Ignore Error    Run    taskkill /F /IM java.exe /T
    Run Keyword And Ignore Error    Run    taskkill /F /IM node.exe /T
    Sleep    3s

    ${backend}=    Start Process
    ...    cmd    /c    mvnw.cmd spring-boot:run
    ...    cwd=${BACKEND_PATH}
    ...    stdout=${BACKEND_PATH}/backend.log
    ...    stderr=${BACKEND_PATH}/backend_err.log
    Set Suite Variable    ${BACKEND_PROCESS}    ${backend}

    ${frontend}=    Start Process
    ...    npm    run    dev
    ...    cwd=${FRONTEND_PATH}
    ...    shell=True
    ...    stdout=${FRONTEND_PATH}/frontend.log
    ...    stderr=${FRONTEND_PATH}/frontend_err.log
    Set Suite Variable    ${FRONTEND_PROCESS}    ${frontend}

    Wait Until Backend Is Ready
    Wait Until Frontend Is Ready

Wait Until Backend Is Ready
    FOR    ${i}    IN RANGE    30
        ${result}=      Run    netstat -ano | findstr :8080
        ${is_ready}=    Evaluate    len($result.strip()) > 0
        IF    $is_ready
            Log    Backend is ready!
            RETURN
        END
        Sleep    2s
    END
    Fatal Error    Backend failed to start within 60s

Wait Until Frontend Is Ready
    FOR    ${i}    IN RANGE    20
        ${result}=      Run    netstat -ano | findstr :5173
        ${is_ready}=    Evaluate    len($result.strip()) > 0
        IF    $is_ready
            Log    Frontend is ready!
            Sleep    5s
            RETURN
        END
        Sleep    2s
    END
    Fatal Error    Frontend failed to start within 40s

Stop Application
    Run Keyword And Ignore Error    Close Browser
    Run Keyword And Ignore Error    Close Browser    ALL
    Terminate Process    ${BACKEND_PROCESS}    kill=True
    Terminate Process    ${FRONTEND_PROCESS}    kill=True
    Sleep    1s
    Run Keyword And Ignore Error    Run    taskkill /F /IM java.exe /T
    Run Keyword And Ignore Error    Run    taskkill /F /IM node.exe /T