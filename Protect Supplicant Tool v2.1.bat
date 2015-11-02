@echo off

title Protect Supplicant Tool   by xcanwin
echo Explain: Protect supplicant to prevent attack.
set Tip1=(1) Num 1 means to start the protection,
set Tip2=(2) Num 2 means to pause the protection,
set Tip3=(3) Num 3 means to stop the protection,
set Tip4=(4) Num 4 means to close the tool.
set TipN=Please enter the num(1~4):
set TipB=[ Successful start ]:
set TipP=[ Successful pause ]:
set TipS=[ Successful stop ]:
ECHO.

set Xsp=ProtectSupplicant
set N=NoAccess
set A=AllowAccess

set Nsfl3848=%N%FL3848
set Nsfa3848=%N%FA3848
set Nsr3848=%N%R3848

set Nsfl4999=%N%FL4999
set Nsfa4999=%N%FA4999
set Nsr4999=%N%R4999

set Asfl3848=%A%FL3848
set Asfa3848=%A%FA3848
set Asr3848=%A%R3848

set Asfl4999=%A%FL4999
set Asfa4999=%A%FA4999
set Asr4999=%A%R4999
call :First










:First
echo %Tip1%
echo %Tip2%
echo %Tip3%
echo %Tip4%
set  "key="
set /p key= %TipN%
if "%key%"=="" ( call :First )
if not %key%==1 (if not %key%==2 (if not %key%==3 (if not %key%==4 ( call :First ))))
if %key%==1 ( call :Start )
if %key%==2 ( call :Pause )
if %key%==3 ( call :Stop )
if %key%==4 ( exit )
call :First









:Start
netsh ipsec static add policy name=%Xsp%
call :StartX any 3848 %Nsfl3848% %Nsfa3848% block %Nsr3848%
call :StartX any 4999 %Nsfl4999% %Nsfa4999% block %Nsr4999%
call :StartX 172.16.1.180 3848 %Asfl3848% %Asfa3848% permit %Asr3848%
call :StartX 172.16.1.180 4999 %Asfl4999% %Asfa4999% permit %Asr4999%
netsh ipsec static set policy name=%Xsp% assign=y
cls
echo %TipB%%date%_%time%
ECHO.
ECHO.
exit /b 0

:StartX
netsh ipsec static add filter dstaddr=me protocol=UDP srcaddr=%1 dstport=%2 filterlist=%3
netsh ipsec static add filteraction name=%4 action=%5 
netsh ipsec static add rule policy=%Xsp% filterlist=%3 filteraction=%4 name=%6
exit /b 0






:Pause
netsh ipsec static set policy name=%Xsp% assign=n
cls
echo %TipP%%date%_%time%
ECHO.
ECHO.
exit /b 0








:Stop
netsh ipsec static set policy name=%Xsp% assign=n
call :StopX %Nsr3848% %Nsfl3848% %Nsfa3848%
call :StopX %Nsr4999% %Nsfl4999% %Nsfa4999%
call :StopX %Asr3848% %Asfl3848% %Asfa3848%
call :StopX %Asr4999% %Asfl4999% %Asfa4999%
netsh ipsec static del policy name=%Xsp%
cls
echo %TipS%%date%_%time%
ECHO.
ECHO.
exit /b 0

:StopX
netsh ipsec static del rule name=%1 policy=%Xsp%
netsh ipsec static del filterlist name=%2
netsh ipsec static del filteraction name=%3
exit /b 0


