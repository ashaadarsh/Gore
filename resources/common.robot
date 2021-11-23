*** Settings ***
Library                   QForce
Library                   String
Library                   QWeb


*** Variables ***
${BROWSER}               chrome
${login_url}             https://val-wlgore.cs172.force.com/Gasket/s/login    
${username}              chandri@guest.wlgore.com.val       # Salesforce instance. NOTE: Should be overwritten in CRT variables
${password}              Lem#12mel#
${home_url}              ${login_url}



*** Keywords ***
Setup Browser
    Open Browser          about:blank                 ${BROWSER}
    SetConfig             LineBreak                   ${EMPTY}               #\ue000
    SetConfig             DefaultTimeout              20s                    #sometimes salesforce is slow


End suite
    Close All Browsers


Login
    [Documentation]      Login to Salesforce instance
    GoTo                 ${login_url}
    TypeText             Email                    ${username}
    TypeText             Password                 ${password}
    ClickText            Sign In


Home
    [Documentation]      Navigate to homepage, login if needed
    GoTo                 ${home_url}
    ${login_status} =    IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If       ${login_status}             Login
    VerifyText           Home


# Example of custom keyword with robot fw syntax
VerifyStage
    [Documentation]      Verifies that stage given in ${text} is at ${selected} state; either selected (true) or not selected (false)
    [Arguments]          ${text}                     ${selected}=true
    VerifyElement        //a[@title\="${text}" and @aria-checked\="${selected}"]


NoData
    VerifyNoText          ${data}                     timeout=3


DeleteData
    [Documentation]       RunBlock to remove all data until it doesn't exist anymore
    ClickText             ${data}
    ClickText             Delete
    VerifyText            Are you sure you want to delete this account?
    ClickText             Delete                      2
    VerifyText            Undo
    VerifyNoText          Undo
    ClickText             Accounts                    partial_match=False


