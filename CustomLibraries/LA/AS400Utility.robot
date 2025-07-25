*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem
Library     Collections
# Library    ../../Qrace/QraceHelper.py
Library     String
Library     Mainframe3270
Library     ScreenCapLibrary
Library     LAScreenshot.py
Library     Dialogs
Resource    ../common.robot

*** Keywords ***
Take AS400 Screenshot1
    ${ScreenPathName}    Set Variable    ${EXECDIR}\\${screenshotPath}

Take AS400 Screenshot
    TRY
        # Read top screen name
        ${msg}    Mainframe3270.Read    1    20    45
        ${msg}    Strip String    ${msg}
        ${msg}    Replace String    ${msg}    /    _
    #    ${ScreenPathName}    Set Variable    ${EXECDIR}\\${screenshotDir}
        ${count}    Evaluate    ${count} + 1
        Set Global Variable    ${count}
        ${count}    Evaluate    format(${count}, '05d')
        ${ScreenPathName}    Set Variable    ${screenshotPath}
    #    \\${msg}.png
        Log To Console    ${ScreenPathName}
        la Screenshot    Y:L:CATHLA01.TH.INTRANET:992 - wc3270    ${ScreenPathName}    ${count}_LA_${msg}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Set Report Path
    [Arguments]    ${path}
    TRY
        set test variable    ${path}
        Remove Directory    ${path}/${TEST_NAME}    TRUE
        ScreenCapLibrary.Set Screenshot Directory    ./${path}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END

Capture Message
    [Arguments]    ${row}    ${col}    ${len}
    TRY
        ${msg}    Mainframe3270.Read    ${row}    ${col}    ${len}
        ${msg}    Strip String    ${msg}
        RETURN    ${msg}
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Navigate to Master Menu
    TRY
        Take AS400 Screenshot

        Execute Command    PA(1)
        Send PF    3
        Execute Command    PA(1)
        Send PF    3
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Select Riders
    #    9,9 x    9,30 rider code
    TRY
        @{rider_list}    Create List    ${rider1}
        IF    '${rider2}' != ''    Append To List    ${rider_list}    ${rider2}
        IF    '${rider3}' != ''    Append To List    ${rider_list}    ${rider3}
        IF    '${rider4}' != ''    Append To List    ${rider_list}    ${rider4}
        IF    '${rider5}' != ''    Append To List    ${rider_list}    ${rider5}
        IF    '${rider6}' != ''    Append To List    ${rider_list}    ${rider6}
        IF    '${rider7}' != ''    Append To List    ${rider_list}    ${rider7}
        IF    '${rider8}' != ''    Append To List    ${rider_list}    ${rider8}
        IF    '${rider9}' != ''    Append To List    ${rider_list}    ${rider9}
        IF    '${rider10}' != ''    Append To List    ${rider_list}    ${rider10}
        IF    '${rider11}' != ''    Append To List    ${rider_list}    ${rider11}
        IF    '${rider12}' != ''    Append To List    ${rider_list}    ${rider12}
        IF    '${rider13}' != ''    Append To List    ${rider_list}    ${rider13}
        Log List    ${rider_list}
    #    #Pause Execution
        ${ridercount}    Get Length    ${rider_list}
    #    WHILE    ${ridercount} > 0
        ${iLoop}    Set Variable    9
        WHILE    ${iLoop} < 22
            Log    ${iLoop}
            ${AppRider}    Mainframe3270.Read    ${iLoop}    30    4
            Log    ${AppRider}
            ${AppRider}    Strip String    ${AppRider}
            ${select_rider}    Run Keyword And Return Status    List Should Contain Value    ${rider_list}    ${AppRider}
            IF    ${select_rider} == True
                Write Bare In position    X    ${iLoop}    9
                Remove Values From List    ${rider_list}    ${AppRider}
                ${ridercount}    Get Length    ${rider_list}
                IF    ${ridercount} < 1    BREAK
            END
            ${rider}    Get From List    ${rider_list}    0
            IF    '${iLoop}' == '21'
                # Read 21,79
                ${NewPage}    Mainframe3270.Read    ${iLoop}    79    1
                IF    '${NewPage}' == '+'
                    Take AS400 Screenshot
                    Send PF    8
                    ${iLoop}    Set Variable    7
                ELSE
                    ${errmsg}    Set Variable    Required Rider not found : ${rider}
                    BREAK
                END
            END
            IF    '${AppRider}' == ''
                ${errmsg}    Set Variable    Required Rider not found : ${rider}
                BREAK
            END
            ${iLoop}    Evaluate    ${iLoop}+1
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END


Enter Rider Details
    [Arguments]    ${rider_code}    ${sum_assured}    ${mortality_class}    ${plan}
    TRY
        IF    '${rider_code}' == 'RW1A'
            Take AS400 Screenshot
            Send Enter
            Take AS400 Screenshot
            #    #Pause Execution
            Write Bare In position    ${mortality_class}    14    32
        ELSE
            ${sum_assured_present}    Mainframe3270.Read    8    3    13
            ${sum_assured_present}    Strip String    ${sum_assured_present}
            IF    '${sum_assured_present}' == 'Sum Assured:' and '${rider_code}' != 'RIIA'
                Write Bare In position    ${sum_assured}    8    17
            END
            ${mortality_present}    Mainframe3270.Read    15    4    15
            ${mortality_present}    Strip String    ${mortality_present}
            IF    '${mortality_present}' == 'Mortality Class'
                Write Bare In position    ${mortality_class}    15    32
            ELSE
                Write Bare In position    ${mortality_class}    13    21
            END
            ${plan_is_present}    Capture Message    8    60    7
            IF    '${plan_is_present}' == 'Plan:'
                Write Bare In position    ${plan}    8    68
            ELSE
                ${plan_is_present}    Mainframe3270.Read    14    4    10
                ${plan_is_present}    Strip String    ${plan_is_present}
                IF    '${plan_is_present}' == 'Plan Code' and '${plan}' != ''
                    Write Bare In position    ${plan}    14    32
                END
            END
            IF    '${rider_code}' == 'RT1A'
                Write Bare In Position    ${RT1A_Risk_Cess_Term}    10    29
                Write Bare In Position    ${RT1A_Prem_Cess_Term}    10    29
            END
        END
        Execute Command    PA(1)
        Send PF    5
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END


Add Joint Owner1 Riders
    TRY
        IF    '${joint_owner1_rider1}' != ''
            ${AppRider}    MainFrame3270.Read    8    20    4
            IF    '${AppRider}' == '${joint_owner1_rider1}'
                Write Bare In Position    X    8    9
            ELSE IF    '${AppRider}' == '${joint_owner1_rider2}'
                Write Bare In Position    X    8    9
            END
            IF    '${joint_owner1_rider2}' != 'RW3A' and '${joint_owner1_rider2}' != 'RH3B'
                ${AppRider}    MainFrame3270.Read    9    20    4
                IF    '${AppRider}' == '${joint_owner1_rider1}'
                    Write Bare In Position    X    9    9
                ELSE IF    '${AppRider}' == '${joint_owner1_rider2}'
                    Write Bare In Position    X    9    9
                END
            END
            Take AS400 Screenshot
            Send Enter
            #    Rider 1
            IF    '${joint_owner1_rider1}' == 'RW2A' or '${joint_owner1_rider1}' == 'RW3A' or '${joint_owner1_rider1}' == 'RW4A'
                Take AS400 Screenshot
                Send Enter
            END
            ${mortality}    Mainframe3270.Read    13    3    9
            IF    '${mortality}' == 'Mortality'
                Write Bare In Position    ${joint_owner1_rider1_mortality_class}    13    21
            ELSE
                Write Bare In Position    ${joint_owner1_rider1_mortality_class}    14    32
            END
            Execute Command    PA(1)
            Send PF    5
            Take AS400 Screenshot
            Send Enter
            #    Rider 2
            IF    '${joint_owner1_rider2}' == 'RW3A' or '${joint_owner1_rider2}' == 'RH3B'
                ${loop_counter}    Set Variable    12
                WHILE    ${loop_counter} < 23
                    ${AppRider}    Mainframe3270.Read    ${loop_counter}    23    4
                    IF    '${AppRider}' == '${joint_owner1_rider1}'    BREAK
                    ${loop_counter}    Evaluate    ${loop_counter}+1
                END
                Write Bare In Position    2    ${loop_counter}    3
                Send Enter
                Write Bare In Position    X    9    9
                Take AS400 Screenshot
                Send Enter
                IF    '${joint_owner1_rider2}' != 'RH3B'
                    Write Bare In Position    ${joint_owner1_rider2_SA}    8    17
                END
                ${mortality}    Mainframe3270.Read    15    4    9
                IF    '${mortality}' == 'Mortality'
                    Write Bare In Position    ${joint_owner1_rider1_mortality_class}    15    32
                ELSE
                    Write Bare In Position    ${joint_owner1_rider2_mortality_class}    13    21
                END
                ${plan}    Mainframe3270.Read    14    4    4
                IF    '${plan}' == 'Plan'
                    Write Bare In Position    ${joint_owner2_rider2_PLAN}    14    32
                END
                Execute Command    PA(1)
                Send PF    5
                Take AS400 Screenshot
                Send Enter
            END
        ELSE
            Send Enter
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Add Joint Owner2 Riders
    TRY
        IF    '${joint_owner2_rider1}' != ''
            ${AppRider}    MainFrame3270.Read    8    20    4
            IF    '${AppRider}' == '${joint_owner2_rider1}'
                Write Bare In Position    X    8    9
            ELSE IF    '${AppRider}' == '${joint_owner2_rider2}'
                Write Bare In Position    X    8    9
            END
            IF    '${joint_owner2_rider2}' != 'RW3A' and '${joint_owner2_rider2}' != 'RH3B'
                ${AppRider}    MainFrame3270.Read    9    20    4
                IF    '${AppRider}' == '${joint_owner2_rider1}'
                    Write Bare In Position    X    9    9
                ELSE IF    '${AppRider}' == '${joint_owner2_rider2}'
                    Write Bare In Position    X    9    9
                END
            END
            Take AS400 Screenshot
            Send Enter
            #    Rider 1
            IF    '${joint_owner2_rider1}' == 'RW2A' or '${joint_owner2_rider1}' == 'RW3A' or '${joint_owner2_rider1}' == 'RW4A'
                Take AS400 Screenshot
                Send Enter
            END
            ${mortality}    Mainframe3270.Read    13    3    9
            IF    '${mortality}' == 'Mortality'
                Write Bare In Position    ${joint_owner2_rider1_mortality_class}    13    21
            ELSE
                Write Bare In Position    ${joint_owner2_rider1_mortality_class}    14    32
            END
            Execute Command    PA(1)
            Send PF    5
            Take AS400 Screenshot
            Send Enter
            #    Rider 2
            IF    '${joint_owner2_rider2}' == 'RW3A' or '${joint_owner2_rider2}' == 'RH3B'
                ${loop_counter}    Set Variable    12
                WHILE    ${loop_counter} < 23
                    ${AppClientNo}    Mainframe3270.Read    ${loop_counter}    23    8
                    IF    '${AppClientNo}' == '${JointOwner2_ClientNo}'
                        ${loop_counter}    Evaluate    ${loop_counter}+1
                        BREAK
                    END
                    ${loop_counter}    Evaluate    ${loop_counter}+1
                END
                WHILE    ${loop_counter} < 23
                    ${AppRider}    Mainframe3270.Read    ${loop_counter}    23    4
                    IF    '${AppRider}' == '${joint_owner2_rider1}'    BREAK
                    ${loop_counter}    Evaluate    ${loop_counter}+1
                END
                Write Bare In Position    2    ${loop_counter}    3
                Send Enter
                Write Bare In Position    X    9    9
                Take AS400 Screenshot
                Send Enter
                IF    '${joint_owner2_rider2}' != 'RH3B'
                    Write Bare In Position    ${joint_owner2_rider2_SA}    8    17
                END
                ${mortality}    Mainframe3270.Read    15    4    9
                IF    '${mortality}' == 'Mortality'
                    Write Bare In Position    ${joint_owner2_rider1_mortality_class}    15    32
                ELSE
                    Write Bare In Position    ${joint_owner2_rider2_mortality_class}    13    21
                END
                ${plan}    Mainframe3270.Read    14    4    4
                IF    '${plan}' == 'Plan'
                    Write Bare In Position    ${joint_owner2_rider2_PLAN}    14    32
                END
                Execute Command    PA(1)
                Send PF    5
                Take AS400 Screenshot
                Send Enter
            END
        ELSE
            Send Enter
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Add Joint Owner3 Riders
    TRY
        IF    '${joint_owner3_rider1}' != ''
            ${AppRider}    MainFrame3270.Read    8    20    4
            IF    '${AppRider}' == '${joint_owner3_rider1}'
                Write Bare In Position    X    8    9
            ELSE IF    '${AppRider}' == '${joint_owner3_rider2}'
                Write Bare In Position    X    8    9
            END
            IF    '${joint_owner3_rider2}' != 'RW3A' and '${joint_owner3_rider2}' != 'RH3B'
                ${AppRider}    MainFrame3270.Read    9    20    4
                IF    '${AppRider}' == '${joint_owner3_rider1}'
                    Write Bare In Position    X    9    9
                ELSE IF    '${AppRider}' == '${joint_owner3_rider2}'
                    Write Bare In Position    X    9    9
                END
            END
            Take AS400 Screenshot
            Send Enter
            #    Rider 1
            IF    '${joint_owner3_rider1}' == 'RW2A' or '${joint_owner3_rider1}' == 'RW3A' or '${joint_owner3_rider1}' == 'RW4A'
                Take AS400 Screenshot
                Send Enter
            END
            ${mortality}    Mainframe3270.Read    13    3    9
            IF    '${mortality}' == 'Mortality'
                Write Bare In Position    ${joint_owner3_rider1_mortality_class}    13    21
            ELSE
                Write Bare In Position    ${joint_owner3_rider1_mortality_class}    14    32
            END
            Execute Command    PA(1)
            Send PF    5
            Take AS400 Screenshot
            Send Enter
            #    Rider 2
            IF    '${joint_owner3_rider2}' == 'RW3A' or '${joint_owner3_rider2}' == 'RH3B'
                ${loop_counter}    Set Variable    12
                WHILE    ${loop_counter} < 23
                    ${AppClientNo}    Mainframe3270.Read    ${loop_counter}    23    8
                    IF    '${AppClientNo}' == '${JointOwner3_ClientNo}'
                        ${loop_counter}    Evaluate    ${loop_counter}+1
                        BREAK
                    END
                    IF    '${loop_counter}' == '22'
                        ${NewPage}    Mainframe3270.Read    ${loop_counter}    79    1
                        IF    '${NewPage}' == '+'
                            Send PF    8
                            ${loop_counter}    Set Variable    8
                        END
                    END
                    ${loop_counter}    Evaluate    ${loop_counter}+1
                END
                WHILE    ${loop_counter} < 23
                    ${AppRider}    Mainframe3270.Read    ${loop_counter}    23    4
                    IF    '${AppRider}' == '${joint_owner3_rider1}'    BREAK
                    ${loop_counter}    Evaluate    ${loop_counter}+1
                END
                Write Bare In Position    2    ${loop_counter}    3
                Send Enter
                Write Bare In Position    X    9    9
                Take AS400 Screenshot
                Send Enter
                IF    '${joint_owner3_rider2}' != 'RH3B'
                    Write Bare In Position    ${joint_owner3_rider2_SA}    8    17
                END
                ${mortality}    Mainframe3270.Read    15    4    9
                IF    '${mortality}' == 'Mortality'
                    Write Bare In Position    ${joint_owner3_rider1_mortality_class}    15    32
                ELSE
                    Write Bare In Position    ${joint_owner3_rider2_mortality_class}    13    21
                END
                ${plan}    Mainframe3270.Read    14    4    4
                IF    '${plan}' == 'Plan'
                    Write Bare In Position    ${joint_owner3_rider2_PLAN}    14    32
                END
                Execute Command    PA(1)
                Send PF    5
                Take AS400 Screenshot
                Send Enter
            END
        ELSE
            Send Enter
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END
Add Joint Owner4 Riders
    TRY
        IF    '${joint_owner4_rider1}' != ''
            ${AppRider}    MainFrame3270.Read    8    20    4
            IF    '${AppRider}' == '${joint_owner4_rider1}'
                Write Bare In Position    X    8    9
            ELSE IF    '${AppRider}' == '${joint_owner4_rider2}'
                Write Bare In Position    X    8    9
            END
            IF    '${joint_owner4_rider2}' != 'RW3A' and '${joint_owner4_rider2}' != 'RH3B'
                ${AppRider}    MainFrame3270.Read    9    20    4
                IF    '${AppRider}' == '${joint_owner4_rider1}'
                    Write Bare In Position    X    9    9
                ELSE IF    '${AppRider}' == '${joint_owner4_rider2}'
                    Write Bare In Position    X    9    9
                END
            END
            Take AS400 Screenshot
            Send Enter
            #    Rider 1
            IF    '${joint_owner4_rider1}' == 'RW2A' or '${joint_owner4_rider1}' == 'RW3A' or '${joint_owner4_rider1}' == 'RW4A'
                Take AS400 Screenshot
                Send Enter
            END
            ${mortality}    Mainframe3270.Read    13    3    9
            IF    '${mortality}' == 'Mortality'
                Write Bare In Position    ${joint_owner4_rider1_mortality_class}    13    21
            ELSE
                Write Bare In Position    ${joint_owner4_rider1_mortality_class}    14    32
            END
            Execute Command    PA(1)
            Send PF    5
            Take AS400 Screenshot
            Send Enter
            #    Rider 2
            IF    '${joint_owner4_rider2}' == 'RW3A' or '${joint_owner4_rider2}' == 'RH3B'
                ${loop_counter}    Set Variable    12
                WHILE    ${loop_counter} < 23
                    ${AppClientNo}    Mainframe3270.Read    ${loop_counter}    23    8
                    IF    '${AppClientNo}' == '${JointOwner4_ClientNo}'
                        ${loop_counter}    Evaluate    ${loop_counter}+1
                        BREAK
                    END
                    IF    '${loop_counter}' == '22'
                        ${NewPage}    Mainframe3270.Read    ${loop_counter}    79    1
                        IF    '${NewPage}' == '+'
                            Send PF    8
                            ${loop_counter}    Set Variable    8
                        END
                    END
                    ${loop_counter}    Evaluate    ${loop_counter}+1
                END
                WHILE    ${loop_counter} < 23
                    ${AppRider}    Mainframe3270.Read    ${loop_counter}    23    4
                    IF    '${AppRider}' == '${joint_owner4_rider1}'    BREAK
                    ${loop_counter}    Evaluate    ${loop_counter}+1
                END
                Write Bare In Position    2    ${loop_counter}    3
                Send Enter
                Write Bare In Position    X    9    9
                Take AS400 Screenshot
                Send Enter
                IF    '${joint_owner4_rider2}' != 'RH3B'
                    Write Bare In Position    ${joint_owner4_rider2_SA}    8    17
                END
                ${mortality}    Mainframe3270.Read    15    4    9
                IF    '${mortality}' == 'Mortality'
                    Write Bare In Position    ${joint_owner4_rider1_mortality_class}    15    32
                ELSE
                    Write Bare In Position    ${joint_owner4_rider2_mortality_class}    13    21
                END
                ${plan}    Mainframe3270.Read    14    4    4
                IF    '${plan}' == 'Plan'
                    Write Bare In Position    ${joint_owner4_rider2_PLAN}    14    32
                END
                Execute Command    PA(1)
                Send PF    5
                Take AS400 Screenshot
                Send Enter
            END
        ELSE
            Send Enter
        END
    EXCEPT     AS  ${reason}
        Set Failed Actual Result and VP    Omne_Flow   ${reason}   Capture Change Name Transaction Details for iOS
    END