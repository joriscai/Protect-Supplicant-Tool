@echo off
title Protect Supplicant Tool   by xcanwin

set Xps=ProtectSupplicant
set TipN=Please enter the num(1~4):
set TipB=[ Successful start ]
set TipP=[ Successful pause ]
set TipS=[ Successful stop ]
call :Main
exit /b 0


:Main
    echo Explain: Protect supplicant to prevent attack.
    ECHO.
    echo (1) Num 1 means to start the protection,
    echo (2) Num 2 means to pause the protection,
    echo (3) Num 3 means to stop the protection,
    echo (4) Num 4 means to close the tool.

    set "key="
    set /p key= %TipN%
    if "%key%"=="" ( call :First )
    if not %key%==1 (if not %key%==2 (if not %key%==3 (if not %key%==4 ( call :First ))))
    if %key%==1 ( call :Start )
    if %key%==2 ( call :Pause )
    if %key%==3 ( call :Stop )
    if %key%==4 ( exit )
    ECHO.
    ECHO.
    pause
exit /b 0



:Start
    call :Stop
    netsh ipsec static add policy name=%Xps%

    netsh ipsec static add filter dstaddr=me protocol=UDP srcaddr=any dstport=3848 filterlist=%Xps%LN
    netsh ipsec static add filter dstaddr=me protocol=UDP srcaddr=any dstport=4999 filterlist=%Xps%LN
    netsh ipsec static add filteraction name=%Xps%AN action=block
    netsh ipsec static add rule name=%Xps%RN filterlist=%Xps%LN filteraction=%Xps%AN policy=%Xps%

    netsh ipsec static add filter dstaddr=me protocol=UDP srcaddr=1.1.1.8 dstport=3848 filterlist=%Xps%LY
    ::Add this command, because of Chris to upgrade OpenSupplicant.
    netsh ipsec static add filter dstaddr=me protocol=UDP srcaddr=172.16.1.180 dstport=3848 filterlist=%Xps%LY
    netsh ipsec static add filter dstaddr=me protocol=UDP srcaddr=172.16.1.180 dstport=4999 filterlist=%Xps%LY
    netsh ipsec static add filteraction name=%Xps%AY action=permit
    netsh ipsec static add rule name=%Xps%RY filterlist=%Xps%LY filteraction=%Xps%AY policy=%Xps%

    netsh ipsec static set policy name=%Xps% assign=y
    cls
    echo %TipB%
exit /b 0



:Stop
    call :Pause
    call :StopX %Xps%RN %Xps%LN %Xps%AN
    call :StopX %Xps%RY %Xps%LY %Xps%AY
    netsh ipsec static del policy name=%Xps%
    cls
    echo %TipS%
exit /b 0

:StopX
    netsh ipsec static del rule name=%1 policy=%Xps%
    netsh ipsec static del filterlist name=%2
    netsh ipsec static del filteraction name=%3
exit /b 0



:Pause
    netsh ipsec static set policy name=%Xps% assign=n
    cls
    echo %TipP%
exit /b 0

