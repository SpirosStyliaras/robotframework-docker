*** Settings ***
Force Tags        faker
Test Timeout      1 minute
Library           FakerLibrary

*** Test Cases ***
Can_Get_Fake_Name
    ${name}=    FakerLibrary.Name
    Should Not Be Empty    ${name}
