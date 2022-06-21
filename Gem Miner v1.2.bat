:: Game made by Fisterkoo
:: Game development started Friday 10. June 2022, 14:02:21s / 2:02:21s PM
:: Update 1.2
:: =====================================   L   O   A   D   I   N   G   ============================================

@echo off
setlocal enabledelayedexpansion
mode 100,30
title Gem Miner
color 0F
echo Checking Local Saving Setting...
if exist "C:\GemMinerChecker" (
    set savedirectory=C:\GemMiner
) else (
    set savedirectory=!cd!
)
if exist "C:\GemMinerChecker" (
    md "C:\GemMiner"
    if exist "!cd!\settings" (
        md "!savedirectory!\settings"
        copy /Y /V "!cd!\settings" "!savedirectory!\settings"
        rd /S /Q "!cd!\settings"
        )
    if exist "!cd!\accounts" (
        md "!savedirectory!\accounts"
        copy /Y /V "!cd!\accounts" "!savedirectory!\accounts"
        rd /S /Q "!cd!\accounts"
        )
    if exist "!cd!\mods" (
        md "!savedirectory!\mods"
        copy /Y /V "!cd!\mods" "!savedirectory!\mods"
        rd /S /Q "!cd!\mods"
        )
) else (
    if exist "C:\GemMiner\settings" (
        md "!cd!\settings"
        copy /Y /V "C:\GemMiner\settings" "!savedirectory!\settings"
        rd /S /Q "C:\GemMiner\settings"
        )
    if exist "C:\GemMiner\accounts" (
        md "!cd!\accounts"
        copy /Y /V "C:\GemMiner\accounts" "!savedirectory!\accounts"
        rd /S /Q "C:\GemMiner\accounts"
        )
    if exist "C:\GemMiner\mods" (
        md "!cd!\mods"
        copy /Y /V "C:\GemMiner\mods" "!savedirectory!\mods"
        rd /S /Q "C:\GemMiner\mods"
        )
    if exist "C:\GemMiner" (rd /S /Q "C:\GemMiner")
)
if not exist "!savedirectory!\settings" (md "!savedirectory!\settings")
if not exist "!savedirectory!\accounts" (md "!savedirectory!\accounts")
if not exist "!savedirectory!\mods" (md "!savedirectory!\mods")
goto :loading

:loading
mode 60,20
cls
echo Loading...
set /a autosavesafety=0
set /a Income=0
set /a IncomeCalculation=0
set spacelooker=
if exist "Gem Miner v1.0.bat" (
	call :UpdateNotificationModule
    goto :account
)
if exist "Gem Miner v1.1.bat" (
	call :UpdateNotificationModule
    goto :account
)
if exist "!savedirectory!\settings\LDMode.bat" (
	call "!savedirectory!\settings\LDMode.bat"
	) else (
		(
		echo color 0F
		echo set ColorTheme=Dark
		)>"!savedirectory!\settings\LDMode.bat"
		cls
		goto :warningscreen
)
goto :warningscreen

:warningscreen
if exist "!savedirectory!\settings\autologin.bat" (
	call "!savedirectory!\settings\autologin.bat"
	goto :gamecheck
)
if exist "!savedirectory!\settings\xyz.bat" (
	goto :account
	)
cls
echo.
echo.
echo                       ^^! WARNING ^^!
echo              Pressing any wrong keybind in
echo              game will result in loud "BEEP"
echo                sound effect. Please avoid
echo                 clicking wrong keybinds...
echo.
echo                Please, set command line
echo                 text size to 16 by right
echo                clicking the top bar of
echo                command line app, click
echo                properties, then select
echo               font and then choose text
echo                size to 16. Thank you^^!
echo.
echo.
echo       You can turn off this message in the settings^^!
echo.
pause
goto :account

:: ================================================================================================================
1.1
:: =====================================   A   C   C   O   U   N   T   ============================================

:account
mode 50,10
cls
echo Gem Miner
echo.
echo [1] Login
echo [2] Register
echo [3] Continue as a Guest (Cannot Save Game)
echo [4] Exit
set /p accountmenu=">>"
if !accountmenu! EQU 1 (
goto :login
) else if !accountmenu! EQU 2 (
goto :register
) else if !accountmenu! EQU 3 (
goto :guest
) else if !accountmenu! EQU 4 (
goto :quit
) else goto :account

:: ================================================================================================================

:: =========================================   L   O   G   I   N   ================================================

:login
cls
set /p loguse="Enter Existing Accounts Username>> "
if not exist "!savedirectory!\accounts\!loguse!.bat" (
	cls
	echo This account does not exist...
	pause
	goto :account
)
goto :loginpassword

:loginpassword
cls
echo Username: !loguse!
call "!savedirectory!\accounts\!loguse!.bat"
set /p logpas="Enter Valid Account Password>> "
if not !logpas! EQU !AccountPassword! (
	cls
	echo Wrong Password...
	pause
	goto :account
)
goto :gamecheck

:guest
cls
echo Logging in as a Guest...
(
echo set AccountUsername=Guest
echo set AccountPassword=12345678
)>"!savedirectory!\accounts\Guest.bat"
cls
call "!savedirectory!\accounts\Guest.bat"
set loguse=Guest
set reguse=Guest
ping localhost -n 2 >nul
goto :gamecheck

:: ================================================================================================================

:: =================================   R   E   G   I   S   T   E   R   ============================================

:register
set /a lookernumber=0
cls
set /p reguse="Enter Valid Username>> "
if "!reguse!" EQU "" (
cls
echo You cannot register an account with no name!
pause
goto :account
) else if !reguse! EQU Guest (
cls
echo You cannot register a Guest Account!
pause
goto :account
) else if !reguse! EQU guest (
cls
echo You cannot register a Guest Account!
pause
goto :account
) else if exist "!savedirectory!\accounts\!reguse!.bat" (
cls
echo You cannot register name, with an already existing account!
pause
goto :register
)
goto :lookforspaces

:lookforspaces
set spacelooker=!reguse:~%lookernumber%,1!
if "!spacelooker!" equ " " (
	call :NoSpacesAllowed
	goto :register
)
if "!spacelooker!" equ "" (
	goto :registerpassword
)
set /a lookernumber=!lookernumber! + 1
goto :lookforspaces

:registerpassword
set /a lookernumber=0
set /a lookernumber2=0
cls
echo Username=!reguse!
set /p regpas="Enter Valid Password>> "
goto :passwordloop

:passwordloop
cls
set passwordchecker=!regpas:~%lookernumber%,1!
if "!passwordchecker!" equ "" (
	goto :passwordcheckermodule
)
set /a lookernumber2=!lookernumber2! + 1
set /a lookernumber=!lookernumber! + 1
goto :passwordloop

:passwordcheckermodule
if !lookernumber2! lss 4 (
	call :LimitedCharacters
	goto :registerpassword
) else if !lookernumber2! gtr 10 (
	call :LimitedCharacters
	goto :registerpassword
) else goto :registeraccount

:registeraccount
cls
echo Username=!reguse!
echo Password=!regpas!
set /p registersave="Do you want to create this account?[y/n]>> "
if !registersave! EQU y (
goto :registeraccountsave
) else if !registersave! EQU n (
goto :account
) else goto :registeraccount

:registeraccountsave
cls
echo Creating account...
(
echo set AccountUsername=!reguse!
echo set AccountPassword=!regpas!
)>"!savedirectory!\accounts\!reguse!.bat"
cls
echo Creating account...
ping localhost -n 2 >nul
cls
echo Account Created!
pause
goto :account

:: ================================================================================================================

:: ===========================   G   A   M   E      L   O   A   D   I   N   G   ===================================

:gamecheck
cls
if not exist "!savedirectory!\accounts\!loguse!save.bat" (
	cls
	goto :newgame
) else (
cls
call "!savedirectory!\accounts\!loguse!save.bat"
if exist "Gem Miner v1.0.bat" (
	call :gameupdating
)
if exist "Gem Miner v1.1.bat" (
	call :gameupdating
)
goto :gamemenu
)

:newgame
(
echo set /a Gems=10
echo set /a BasicGemMiner=0
echo set /a IronGemMiner=0
echo set /a SilverGemMiner=0
echo set /a GoldGemMiner=0
echo set /a DiamondGemMiner=0
echo set /a EmeraldGemMiner=0
echo set /a DarkMatterGemMiner=0
echo set /a BasicGemMinerProfit=1
echo set /a IronGemMinerProfit=5
echo set /a SilverGemMinerProfit=10
echo set /a GoldGemMinerProfit=50
echo set /a DiamondGemMinerProfit=100
echo set /a EmeraldGemMinerProfit=500
echo set /a DarkMatterGemMinerProfit=1000
echo set /a BasicGemMinerPrice=10
echo set /a IronGemMinerPrice=100
echo set /a SilverGemMinerPrice=5000
echo set /a GoldGemMinerPrice=10000
echo set /a DiamondGemMinerPrice=50000
echo set /a EmeraldGemMinerPrice=100000
echo set /a DarkMatterGemMinerPrice=500000
echo set /a BasicGemMinerPriceAdder=15
echo set /a IronGemMinerPriceAdder=150
echo set /a SilverGemMinerPriceAdder=7500
echo set /a GoldGemMinerPriceAdder=15000
echo set /a DiamondGemMinerPriceAdder=75000
echo set /a EmeraldGemMinerPriceAdder=150000
echo set /a DarkMatterGemMinerPriceAdder=750000
echo set /a Basic=0
echo set /a Iron=0
echo set /a Siver=0
echo set /a Gold=0
echo set /a Diamond=0
echo set /a Emerald=0
echo set /a DarkMatter=0
echo set /a Miners=0
echo set /a Rebirth=0
echo set /a RebirthBoost=1
echo set /a Trophy=0
echo set /a PlaySeconds=0
echo set /a PlayMinutes=0
echo set /a PlayHours=0
echo set /a PlayDays=0
echo set /a PlayYears=0
echo set Achievement_Basic1=Dont Own
echo set Achievement_Basic10=Dont Own
echo set Achievement_Basic100=Dont Own
echo set Achievement_Basic1000=Dont Own
echo set Achievement_Basic10000=Dont Own
echo set Achievement_Basic100000=Dont Own
echo set Achievement_Basic1000000=Dont Own
echo set Achievement_Iron100=Dont Own
echo set Achievement_Iron1000=Dont Own
echo set Achievement_Iron10000=Dont Own
echo set Achievement_Iron100000=Dont Own
echo set Achievement_Silver100=Dont Own
echo set Achievement_Silver1000=Dont Own
echo set Achievement_Silver10000=Dont Own
echo set Achievement_Silver100000=Dont Own
echo set Achievement_Gold100=Dont Own
echo set Achievement_Gold1000=Dont Own
echo set Achievement_Gold10000=Dont Own
echo set Achievement_Diamond100=Dont Own
echo set Achievement_Diamond1000=Dont Own
echo set Achievement_Diamond10000=Dont Own
echo set Achievement_Emerald10=Dont Own
echo set Achievement_Emerald100=Dont Own
echo set Achievement_Emerald1000=Dont Own
echo set Achievement_DarkMatter1=Dont Own
echo set Achievement_DarkMatter10=Dont Own
echo set Achievement_DarkMatter100=Dont Own
echo set Achievement_TheBeggining=Dont Own
echo set Achievement_FirstUpdateWow=Dont Own
echo set Achievement_Gems1000=Dont Own
echo set Achievement_Gems10000=Dont Own
echo set Achievement_Gems100000=Dont Own
echo set Achievement_Gems1000000=Dont Own
echo set Achievement_Gems10000000=Dont Own
echo set Achievement_Gems100000000=Dont Own
echo set Achievement_Gems1000000000=Dont Own
echo set Achievement_Time1Min=Dont Own
echo set Achievement_Time1Hour=Dont Own
echo set Achievement_Time1Day=Dont Own
echo set Achievement_Time1Year=Dont Own
echo set Achievement_Rebirth1=Dont Own
echo set Achievement_Rebirth10=Dont Own
echo set Achievement_Rebirth100=Dont Own
echo set Achievement_Rebirth1000=Dont Own
echo set Join_Date=!DATE!=!TIME!
echo set savefileversion=v1.2
)>"!savedirectory!\accounts\!loguse!save.bat"
call "!savedirectory!\accounts\!loguse!save.bat"
if exist "Gem Miner v1.0.bat" (del "Gem Miner v1.0.bat")
if exist "Gem Miner v1.1.bat" (del "Gem Miner v1.1.bat")
goto :gamemenu

:: ================================================================================================================

:: ===========================   G   A   M   E      U   P   D   A   T   I   N   G   ===============================

:gameupdating
cls
echo Updating your save file to latest version (1.2)...
if "!Achievement_Basic1!" equ "" (set Achievement_Basic1=Dont Own)
if "!Achievement_Basic10!" equ "" (set Achievement_Basic10=Dont Own)
if "!Achievement_Basic100!" equ "" (set Achievement_Basic100=Dont Own)
if "!Achievement_Basic1000!" equ "" (set Achievement_Basic1000=Dont Own)
if "!Achievement_Basic10000!" equ "" (set Achievement_Basic10000=Dont Own)
if "!Achievement_Basic100000!" equ "" (set Achievement_Basic100000=Dont Own)
if "!Achievement_Basic1000000!" equ "" (set Achievement_Basic1000000=Dont Own)
if "!Achievement_Iron100!" equ "" (set Achievement_Iron100=Dont Own)
if "!Achievement_Iron1000!" equ "" (set Achievement_Iron1000=Dont Own)
if "!Achievement_Iron10000!" equ "" (set Achievement_Iron10000=Dont Own)
if "!Achievement_Iron100000!" equ "" (set Achievement_Iron100000=Dont Own)
if "!Achievement_Silver100!" equ "" (set Achievement_Silver100=Dont Own)
if "!Achievement_Silver1000!" equ "" (set Achievement_Silver1000=Dont Own)
if "!Achievement_Silver10000!" equ "" (set Achievement_Silver10000=Dont Own)
if "!Achievement_Silver100000!" equ "" (set Achievement_Silver100000=Dont Own)
if "!Achievement_Gold100!" equ "" (set Achievement_Gold100=Dont Own)
if "!Achievement_Gold1000!" equ "" (set Achievement_Gold1000=Dont Own)
if "!Achievement_Gold10000!" equ "" (set Achievement_Gold10000=Dont Own)
if "!Achievement_Diamond100!" equ "" (set Achievement_Diamond100=Dont Own)
if "!Achievement_Diamond1000!" equ "" (set Achievement_Diamond1000=Dont Own)
if "!Achievement_Diamond10000!" equ "" (set Achievement_Diamond10000=Dont Own)
if "!Achievement_Emerald10!" equ "" (set Achievement_Emerald10=Dont Own)
if "!Achievement_Emerald100!" equ "" (set Achievement_Emerald100=Dont Own)
if "!Achievement_Emerald1000!" equ "" (set Achievement_Emerald1000=Dont Own)
if "!Achievement_DarkMatter1!" equ "" (set Achievement_DarkMatter1=Dont Own)
if "!Achievement_DarkMatter10!" equ "" (set Achievement_DarkMatter10=Dont Own)
if "!Achievement_DarkMatter100!" equ "" (set Achievement_DarkMatter100=Dont Own)
if "!Achievement_TheBeggining!" equ "" (set Achievement_TheBeggining=Dont Own)
if "!Achievement_FirstUpdateWow!" equ "" (set Achievement_FirstUpdateWow=Dont Own)
if "!Achievement_Gems1000!" equ "" (set Achievement_Gems1000=Dont Own)
if "!Achievement_Gems10000!" equ "" (set Achievement_Gems10000=Dont Own)
if "!Achievement_Gems100000!" equ "" (set Achievement_Gems100000=Dont Own)
if "!Achievement_Gems1000000!" equ "" (set Achievement_Gems1000000=Dont Own)
if "!Achievement_Gems10000000!" equ "" (set Achievement_Gems10000000=Dont Own)
if "!Achievement_Gems100000000!" equ "" (set Achievement_Gems100000000=Dont Own)
if "!Achievement_Gems1000000000!" equ "" (set Achievement_Gems1000000000=Dont Own)
if "!Achievement_Time1Min!" equ "" (set Achievement_Time1Min=Dont Own)
if "!Achievement_Time1Hour!" equ "" (set Achievement_Time1Hour=Dont Own)
if "!Achievement_Time1Day!" equ "" (set Achievement_Time1Day=Dont Own)
if "!Achievement_Time1Year!" equ "" (set Achievement_Time1Year=Dont Own)
if "!Achievement_Rebirth1!" equ "" (set Achievement_Rebirth1=Dont Own)
if "!Achievement_Rebirth10!" equ "" (set Achievement_Rebirth10=Dont Own)
if "!Achievement_Rebirth100!" equ "" (set Achievement_Rebirth100=Dont Own)
if "!Achievement_Rebirth1000!" equ "" (set Achievement_Rebirth1000=Dont Own)
if "!Join_Date!" equ "" (set Join_Date=!DATE!=!TIME!)
set savefileversion=v1.2
call :SaveModule
if exist "Gem Miner v1.0.bat" (del "Gem Miner v1.0.bat")
if exist "Gem Miner v1.1.bat" (del "Gem Miner v1.1.bat")
timeout 1 /nobreak >nul
echo Updated!
pause
goto :gamemenu

:: ================================================================================================================

:: ==========================================   G   A   M   E   ===================================================

:gamemenu
if !autosavesafety! GEQ 5 (
	call :AutosaveModule
    set /a autosavesafety=0
)
call :MaxGemsModule
call :PlaytimeModule
call :AchievementsModule
call :CheckForMaxMiners
if !Trophy! GTR 0 (set TrophyBoost=2) else (set TrophyBoost=1)
if !BasicGemMiner! EQU 0 (set BasGemMin=Inactive) else (set BasGemMin=!BasicGemMiner! Active)
if !IronGemMiner! EQU 0 (set IroGemMin=Inactive) else (set IroGemMin=!IronGemMiner! Active)
if !SilverGemMiner! EQU 0 (set SilGemMin=Inactive) else (set SilGemMin=!SilverGemMiner! Active)
if !GoldGemMiner! EQU 0 (set GolGemMin=Inactive) else (set GolGemMin=!GoldGemMiner! Active)
if !DiamondGemMiner! EQU 0 (set DiaGemMin=Inactive) else (set DiaGemMin=!DiamondGemMiner! Active)
if !EmeraldGemMiner! EQU 0 (set EmeGemMin=Inactive) else (set EmeGemMin=!EmeraldGemMiner! Active)
if !DarkMatterGemMiner! EQU 0 (set DarGemMin=Inactive) else (set DarGemMin=!DarkMatterGemMiner! Active)
cls
mode 50,30
echo Your logged in as !loguse!^^!
echo.
echo                . . . Mining . . .
echo.
echo Your Balance: !Gems! Gems^^!
echo.
echo Basic Gem Miner       = !BasGemMin!
echo Iron Gem Miner        = !IroGemMin!
echo Silver Gem Miner      = !SilGemMin!
echo Gold Gem Miner        = !GolGemMin!
echo Diamond Gem Miner     = !DiaGemMin!
echo Emerald Gem Miner     = !EmeGemMin!
echo Dark Matter Gem Miner = !DarGemMin!
echo.
echo Total Income = !Income!/s
echo.
echo Press [S] to Enter the Shop...
echo Press [R] to Enter the Rebirth Menu...
echo Press [W] to Enter the Settings Menu...
echo Press [E] to Show Stats...
echo Press [T] to Show Achievements...
echo Press [U] to Show Updates Note...
echo Press [A] to Save...
echo Press [Q] to Save and Quit...
echo.
echo.
echo.
echo.
echo Made By Fisterkoo                     v1.2 Release
CHOICE /C:SRWETUAQX /N /T 1 /D X >nul
if !errorlevel! EQU 1 (
goto :shop
) else if !errorlevel! EQU 2 (
goto :rebirth
) else if !errorlevel! EQU 3 (
goto :settings
) else if !errorlevel! EQU 4 (
goto :stats
) else if !errorlevel! EQU 5 (
goto :achievements
) else if !errorlevel! EQU 6 (
goto :updatesnote
) else if !errorlevel! EQU 7 (
goto :save
) else if !errorlevel! EQU 8 (
goto :quit
) else if !errorlevel! EQU 9 (
set /a Basic=!BasicGemMinerProfit! * !BasicGemMiner!
set /a Iron=!IronGemMinerProfit! * !IronGemMiner!
set /a Silver=!SilverGemMinerProfit! * !SilverGemMiner!
set /a Gold=!GoldGemMinerProfit! * !GoldGemMiner!
set /a Diamond=!DiamondGemMinerProfit! * !DiamondGemMiner!
set /a Emerald=!EmeraldGemMinerProfit! * !EmeraldGemMiner!
set /a DarkMatter=!DarkMatterGemMinerProfit! * !DarkMatterGemMiner!
set /a Miners=!Basic! + !Iron! + !Silver! + !Gold! + !Diamond! + !Emerald! + !DarkMatter!
set /a IncomeCalculation=!Miners! * !RebirthBoost!
set /a IncomeCalculation2=!IncomeCalculation! * !TrophyBoost!
set /a Income=!IncomeCalculation2!
set /a Gems=!Gems! + !IncomeCalculation2!
set /a PlaySeconds=!PlaySeconds! + 1
set /a autosavesafety=!autosavesafety! + 1
goto :gamemenu
)

:: ================================================================================================================

:: ==========================================   S   H   O   P   ===================================================

:shop
mode 65,30
call :AutosaveModule
call :CheckForMaxMiners
call :MaxGemsModule
cls
echo You have !Gems! Gems^^!
if !BasicGemMiner! GEQ 1000000 (set BasicMax=MAX) else (set BasicMax=!BasicGemMiner!)
if !IronGemMiner! GEQ 100000 (set IronMax=MAX) else (set IronMax=!IronGemMiner!)
if !SilverGemMiner! GEQ 100000 (set SilverMax=MAX) else (set SilverMax=!SilverGemMiner!)
if !GoldGemMiner! GEQ 10000 (set GoldMax=MAX) else (set GoldMax=!GoldGemMiner!)
if !DiamondGemMiner! GEQ 10000 (set DiamondMax=MAX) else (set DiamondMax=!DiamondGemMiner!)
if !EmeraldGemMiner! GEQ 1000 (set EmeraldMax=MAX) else (set EmeraldMax=!EmeraldGemMiner!)
if !DarkMatterGemMiner! GEQ 100 (set DarkMatterMax=MAX) else (set DarkMatterMax=!DarkMatterGemMiner!)
echo.
echo [1] Buy Basic Gem Miner - Price: !BasicGemMinerPrice!
echo You have !BasicMax! Basic Gem Miners. Earns: 1 Gem/s Each!
echo.
echo [2] Buy Iron Gem Miner - Price: !IronGemMinerPrice!
echo You have !IronMax! Basic Gem Miners. Earns: 5 Gems/s Each!
echo.
echo [3] Buy Silver Gem Miner - Price: !SilverGemMinerPrice!
echo You have !SilverMax! Basic Gem Miners. Earns: 10 Gems/s Each!
echo.
echo [4] Buy Gold Gem Miner - Price: !GoldGemMinerPrice!
echo You have !GoldMax! Basic Gem Miners. Earns: 50 Gems/s Each!
echo.
echo [5] Buy Diamond Gem Miner - Price: !DiamondGemMinerPrice!
echo You have !DiamondMax! Basic Gem Miners. Earns: 100 Gems/s Each!
echo.
echo [6] Buy Emerald Gem Miner - Price: !EmeraldGemMinerPrice!
echo You have !EmeraldMax! Basic Gem Miners. Earns: 500 Gems/s Each!
echo.
echo [7] Buy Dark Matter Gem Miner - Price: !DarkMatterGemMinerPrice!
echo You have !DarkMatterMax! Basic Gem Miners. Earns: 1000 Gems/s Each!
echo.
echo [8] Buy Trophy - Price: 1000000000
echo You have !Trophy! Trophies. Earns: Temporary 2x Gems For All!
echo.
echo.
echo.
echo [0] Leave the Shop...
set /p shopmenu=">> "
if !shopmenu! EQU 1 (goto :BasicBuy)
if !shopmenu! EQU 2 (goto :IronBuy)
if !shopmenu! EQU 3 (goto :SilverBuy)
if !shopmenu! EQU 4 (goto :GoldBuy)
if !shopmenu! EQU 5 (goto :DiamondBuy)
if !shopmenu! EQU 6 (goto :EmeraldBuy)
if !shopmenu! EQU 7 (goto :DarkMatterBuy)
if !shopmenu! EQU 8 (goto :TrophyBuy)
if !shopmenu! EQU 0 (goto :gamemenu)
goto :shop

:: ================================================================================================================

:: =====================================   R   E   B   I   R   T   H   ============================================

:rebirth
mode 50,30
call :AutosaveModule
call :CheckForMaxMiners
if !Trophy! LEQ 0 (
	cls
	echo You need atleast 1 Trophy to Enter...
	pause
	goto :gamemenu
) else (
	goto :rebirthmenu
)

:rebirthmenu
set /a NextRebirthBoost=!RebirthBoost! + 1
cls
echo.
echo      .   .   .   R E B I R T H   .   .   .
echo.
echo Rebirthing will remove ALL your items
echo INCLUDING Trophies, but will give you
echo PERMANENT BOOST!
echo.
echo What you lose: Gem Miners
echo                Gems
echo                Trophies
echo.
echo What you get: PERMANENTLY HIGHER Rebirth Boost!
echo.
echo Your:
echo Current Rebirth Gems Booster: !RebirthBoost!x
echo Rebirth Gems Booster after This Rebirth: !NextRebirthBoost!x
echo.
echo.
set /p rebirthoption="Do you want to rebirth? [y/n]>> "
if !rebirthoption! EQU y (goto :RebirthModule)
if !rebirthoption! EQU n (goto :gamemenu)

:RebirthModule
cls
echo Rebirthing...
(
echo set /a Gems=10
echo set /a BasicGemMiner=0
echo set /a IronGemMiner=0
echo set /a SilverGemMiner=0
echo set /a GoldGemMiner=0
echo set /a DiamondGemMiner=0
echo set /a EmeraldGemMiner=0
echo set /a DarkMatterGemMiner=0
echo set /a BasicGemMinerProfit=1
echo set /a IronGemMinerProfit=5
echo set /a SilverGemMinerProfit=10
echo set /a GoldGemMinerProfit=50
echo set /a DiamondGemMinerProfit=100
echo set /a EmeraldGemMinerProfit=500
echo set /a DarkMatterGemMinerProfit=1000
echo set /a BasicGemMinerPrice=10
echo set /a IronGemMinerPrice=100
echo set /a SilverGemMinerPrice=5000
echo set /a GoldGemMinerPrice=10000
echo set /a DiamondGemMinerPrice=50000
echo set /a EmeraldGemMinerPrice=100000
echo set /a DarkMatterGemMinerPrice=500000
echo set /a BasicGemMinerPriceAdder=15
echo set /a IronGemMinerPriceAdder=150
echo set /a SilverGemMinerPriceAdder=7500
echo set /a GoldGemMinerPriceAdder=15000
echo set /a DiamondGemMinerPriceAdder=75000
echo set /a EmeraldGemMinerPriceAdder=150000
echo set /a DarkMatterGemMinerPriceAdder=750000
echo set /a Basic=0
echo set /a Iron=0
echo set /a Siver=0
echo set /a Gold=0
echo set /a Diamond=0
echo set /a Emerald=0
echo set /a DarkMatter=0
echo set /a Miners=0
echo set /a Rebirth=!Rebirth! + 1
echo set /a RebirthBoost=!RebirthBoost! + 1
echo set /a Trophy=0
echo set /a PlaySeconds=!PlaySeconds!
echo set /a PlayMinutes=!PlayMinutes!
echo set /a PlayHours=!PlayHours!
echo set /a PlayDays=!PlayDays!
echo set /a PlayYears=!PlayYears!
echo set Achievement_Basic1=!Achievement_Basic1!
echo set Achievement_Basic10=!Achievement_Basic10!
echo set Achievement_Basic100=!Achievement_Basic100!
echo set Achievement_Basic1000=!Achievement_Basic1000!
echo set Achievement_Basic10000=!Achievement_Basic10000!
echo set Achievement_Basic100000=!Achievement_Basic100000!
echo set Achievement_Basic1000000=!Achievement_Basic1000000!
echo set Achievement_Iron100=!Achievement_Iron100!
echo set Achievement_Iron1000=!Achievement_Iron1000!
echo set Achievement_Iron10000=!Achievement_Iron10000!
echo set Achievement_Iron100000=!Achievement_Iron100000!
echo set Achievement_Silver100=!Achievement_Silver100!
echo set Achievement_Silver1000=!Achievement_Silver1000!
echo set Achievement_Silver10000=!Achievement_Silver10000!
echo set Achievement_Silver100000=!Achievement_Silver100000!
echo set Achievement_Gold100=!Achievement_Gold100!
echo set Achievement_Gold1000=!Achievement_Gold1000!
echo set Achievement_Gold10000=!Achievement_Gold10000!
echo set Achievement_Diamond100=!Achievement_Diamond100!
echo set Achievement_Diamond1000=!Achievement_Diamond1000!
echo set Achievement_Diamond10000=!Achievement_Diamond10000!
echo set Achievement_Emerald10=!Achievement_Emerald10!
echo set Achievement_Emerald100=!Achievement_Emerald100!
echo set Achievement_Emerald1000=!Achievement_Emerald1000!
echo set Achievement_DarkMatter1=!Achievement_DarkMatter1!
echo set Achievement_DarkMatter10=!Achievement_DarkMatter10!
echo set Achievement_DarkMatter100=!Achievement_DarkMatter100!
echo set Achievement_TheBeggining=!Achievement_TheBeggining!
echo set Achievement_FirstUpdateWow=!Achievement_FirstUpdateWow!
echo set Achievement_Gems1000=!Achievement_Gems1000!
echo set Achievement_Gems10000=!Achievement_Gems10000!
echo set Achievement_Gems100000=!Achievement_Gems100000!
echo set Achievement_Gems1000000=!Achievement_Gems1000000!
echo set Achievement_Gems10000000=!Achievement_Gems10000000!
echo set Achievement_Gems100000000=!Achievement_Gems100000000!
echo set Achievement_Gems1000000000=!Achievement_Gems1000000000!
echo set Achievement_Time1Min=!Achievement_Time1Min!
echo set Achievement_Time1Hour=!Achievement_Time1Hour!
echo set Achievement_Time1Day=!Achievement_Time1Day!
echo set Achievement_Time1Year=!Achievement_Time1Year!
echo set Achievement_Rebirth1=!Achievement_Rebirth1!
echo set Achievement_Rebirth10=!Achievement_Rebirth10!
echo set Achievement_Rebirth100=!Achievement_Rebirth100!
echo set Achievement_Rebirth1000=!Achievement_Rebirth1000!
echo set Join_Date=!Join_Date!
echo set savefileversion=v1.2
)>"!savedirectory!\accounts\!loguse!save.bat"
call "!savedirectory!\accounts\!loguse!save.bat"
cls
echo Successfully Rebirthed^^!
echo You now have !RebirthBoost!x Gems Boost!
pause
goto :gamemenu

:: ================================================================================================================

:: ============================================   B   A   S   I   C   =============================================

:BasicBuy
cls
if !BasicGemMiner! GEQ 1000000 (
call :YouHaveMaxMiners
)
if !Gems! GEQ !BasicGemMinerPrice! (
goto :BasicBuyAmmount
) else goto :NotEnoughMoney

:BasicBuyAmmount
cls
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
set /a temporarygemminerpriceadder=0
echo How much Basic Miners would you like to purchase?
echo.
echo [1] Availible
echo [10] Availible
echo [100] Availible
echo [MAX] Availible
set /p BasicPurchaseAmmount=">> "
if !BasicPurchaseAmmount! EQU 1 (goto :BasicPurchase1)
if !BasicPurchaseAmmount! EQU 10 (goto :BasicPurchase10)
if !BasicPurchaseAmmount! EQU 100 (goto :BasicPurchase100)
if !BasicPurchaseAmmount! EQU MAX (goto :BasicPurchaseMAX)
goto :BasicBuyAmmount





:BasicPurchase1
cls
set /a Gems=!Gems! - !BasicGemMinerPrice!
set /a BasicGemMinerPrice=!BasicGemMinerPrice! + !BasicGemMinerPriceAdder!
set /a BasicGemMiner=!BasicGemMiner! + 1
echo Purchased!
pause
goto :shop





:BasicPurchase10
cls
echo Setting up Temporary Settings...
echo Purchasing 10
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!BasicGemMinerPrice!
set /a temporarygemminerpriceadder=!BasicGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :BasicCalculating10v1

:BasicCalculating10v1
if !temporarygemminer! EQU 10 (
    goto :BasicCalculating10v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :BasicCalculating10v2
goto :BasicCalculating10v1

:BasicCalculating10v2
if !temporarygemminer! LEQ 9 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :BasicPurchasing10
)

:BasicPurchasing10
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a BasicGemMiner=!BasicGemMiner! + !temporarygemminer!
set /a BasicGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:BasicPurchase100
cls
echo Setting up Temporary Settings...
echo Purchasing 100
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!BasicGemMinerPrice!
set /a temporarygemminerpriceadder=!BasicGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :BasicCalculating100v1

:BasicCalculating100v1
if !temporarygemminer! EQU 100 (
    goto :BasicCalculating100v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :BasicCalculating100v2
goto :BasicCalculating100v1

:BasicCalculating100v2
if !temporarygemminer! LEQ 99 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :BasicPurchasing100
)

:BasicPurchasing100
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a BasicGemMiner=!BasicGemMiner! + !temporarygemminer!
set /a BasicGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:BasicPurchaseMAX
cls
echo Setting up Temporary Settings...
echo Purchasing MAX
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!BasicGemMinerPrice!
set /a temporarygemminerpriceadder=!BasicGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :BasicCalculatingMAXv1

:BasicCalculatingMAXv1
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :BasicPurchasingMAX
goto :BasicCalculatingMAXv1

:BasicPurchasingMAX
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a BasicGemMiner=!BasicGemMiner! + !temporarygemminer!
set /a BasicGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop

:: ================================================================================================================

:: ==============================================   I   R   O   N  ================================================

:IronBuy
cls
if !IronGemMiner! GEQ 100000 (
call :YouHaveMaxMiners
)
if !Gems! GEQ !IronGemMinerPrice! (
goto :IronBuyAmmount
) else goto :NotEnoughMoney

:IronBuyAmmount
cls
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
set /a temporarygemminerpriceadder=0
echo How much Iron Miners would you like to purchase?
echo.
echo [1] Availible
echo [10] Availible
echo [100] Availible
echo [MAX] Availible
set /p IronPurchaseAmmount=">> "
if !IronPurchaseAmmount! EQU 1 (goto :IronPurchase1)
if !IronPurchaseAmmount! EQU 10 (goto :IronPurchase10)
if !IronPurchaseAmmount! EQU 100 (goto :IronPurchase100)
if !IronPurchaseAmmount! EQU MAX (goto :IronPurchaseMAX)
goto :IronBuyAmmount





:IronPurchase1
cls
set /a Gems=!Gems! - !IronGemMinerPrice!
set /a IronGemMinerPrice=!IronGemMinerPrice! + !IronGemMinerPriceAdder!
set /a IronGemMiner=!IronGemMiner! + 1
echo Purchased!
pause
goto :shop





:IronPurchase10
cls
echo Setting up Temporary Settings...
echo Purchasing 10
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!IronGemMinerPrice!
set /a temporarygemminerpriceadder=!IronGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :IronCalculating10v1

:IronCalculating10v1
if !temporarygemminer! EQU 10 (
    goto :IronCalculating10v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :IronCalculating10v2
goto :IronCalculating10v1

:IronCalculating10v2
if !temporarygemminer! LEQ 9 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :IronPurchasing10
)

:IronPurchasing10
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a IronGemMiner=!IronGemMiner! + !temporarygemminer!
set /a IronGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:IronPurchase100
cls
echo Setting up Temporary Settings...
echo Purchasing 100
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!IronGemMinerPrice!
set /a temporarygemminerpriceadder=!IronGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :IronCalculating100v1

:IronCalculating100v1
if !temporarygemminer! EQU 100 (
    goto :IronCalculating100v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :IronCalculating100v2
goto :IronCalculating100v1

:IronCalculating100v2
if !temporarygemminer! LEQ 99 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :IronPurchasing100
)

:IronPurchasing100
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a IronGemMiner=!IronGemMiner! + !temporarygemminer!
set /a IronGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:IronPurchaseMAX
cls
echo Setting up Temporary Settings...
echo Purchasing MAX
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!IronGemMinerPrice!
set /a temporarygemminerpriceadder=!IronGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :IronCalculatingMAXv1

:IronCalculatingMAXv1
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :IronPurchasingMAX
goto :IronCalculatingMAXv1

:IronPurchasingMAX
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a IronGemMiner=!IronGemMiner! + !temporarygemminer!
set /a IronGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop

:: ================================================================================================================

:: ========================================   S   I   L   V   E   R  ==============================================

:SilverBuy
cls
if !SilverGemMiner! GEQ 100000 (
call :YouHaveMaxMiners
)
if !Gems! GEQ !SilverGemMinerPrice! (
goto :SilverBuyAmmount
) else goto :NotEnoughMoney

:SilverBuyAmmount
cls
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
set /a temporarygemminerpriceadder=0
echo How much Silver Miners would you like to purchase?
echo.
echo [1] Availible
echo [10] Availible
echo [100] Availible
echo [MAX] Availible
set /p SilverPurchaseAmmount=">> "
if !SilverPurchaseAmmount! EQU 1 (goto :SilverPurchase1)
if !SilverPurchaseAmmount! EQU 10 (goto :SilverPurchase10)
if !SilverPurchaseAmmount! EQU 100 (goto :SilverPurchase100)
if !SilverPurchaseAmmount! EQU MAX (goto :SilverPurchaseMAX)
goto :SilverBuyAmmount





:SilverPurchase1
cls
set /a Gems=!Gems! - !SilverGemMinerPrice!
set /a SilverGemMinerPrice=!SilverGemMinerPrice! + !SilverGemMinerPriceAdder!
set /a SilverGemMiner=!SilverGemMiner! + 1
echo Purchased!
pause
goto :shop





:SilverPurchase10
cls
echo Setting up Temporary Settings...
echo Purchasing 10
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!SilverGemMinerPrice!
set /a temporarygemminerpriceadder=!SilverGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :SilverCalculating10v1

:SilverCalculating10v1
if !temporarygemminer! EQU 10 (
    goto :SilverCalculating10v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :SilverCalculating10v2
goto :SilverCalculating10v1

:SilverCalculating10v2
if !temporarygemminer! LEQ 9 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :SilverPurchasing10
)

:SilverPurchasing10
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a SilverGemMiner=!SilverGemMiner! + !temporarygemminer!
set /a SilverGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:SilverPurchase100
cls
echo Setting up Temporary Settings...
echo Purchasing 100
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!SilverGemMinerPrice!
set /a temporarygemminerpriceadder=!SilverGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :SilverCalculating100v1

:SilverCalculating100v1
if !temporarygemminer! EQU 100 (
    goto :SilverCalculating100v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :SilverCalculating100v2
goto :SilverCalculating100v1

:SilverCalculating100v2
if !temporarygemminer! LEQ 99 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :SilverPurchasing100
)

:SilverPurchasing100
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a SilverGemMiner=!SilverGemMiner! + !temporarygemminer!
set /a SilverGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:SilverPurchaseMAX
cls
echo Setting up Temporary Settings...
echo Purchasing MAX
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!SilverGemMinerPrice!
set /a temporarygemminerpriceadder=!SilverGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :SilverCalculatingMAXv1

:SilverCalculatingMAXv1
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :SilverPurchasingMAX
goto :SilverCalculatingMAXv1

:SilverPurchasingMAX
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a SilverGemMiner=!SilverGemMiner! + !temporarygemminer!
set /a SilverGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop

:: ================================================================================================================

:: ============================================   G   O   L   D   =================================================

:GoldBuy
cls
if !GoldGemMiner! GEQ 10000 (
call :YouHaveMaxMiners
)
if !Gems! GEQ !GoldGemMinerPrice! (
goto :GoldBuyAmmount
) else goto :NotEnoughMoney

:GoldBuyAmmount
cls
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
set /a temporarygemminerpriceadder=0
echo How much Gold Miners would you like to purchase?
echo.
echo [1] Availible
echo [10] Availible
echo [100] Availible
echo [MAX] Availible
set /p GoldPurchaseAmmount=">> "
if !GoldPurchaseAmmount! EQU 1 (goto :GoldPurchase1)
if !GoldPurchaseAmmount! EQU 10 (goto :GoldPurchase10)
if !GoldPurchaseAmmount! EQU 100 (goto :GoldPurchase100)
if !GoldPurchaseAmmount! EQU MAX (goto :GoldPurchaseMAX)
goto :GoldBuyAmmount





:GoldPurchase1
cls
set /a Gems=!Gems! - !GoldGemMinerPrice!
set /a GoldGemMinerPrice=!GoldGemMinerPrice! + !GoldGemMinerPriceAdder!
set /a GoldGemMiner=!GoldGemMiner! + 1
echo Purchased!
pause
goto :shop





:GoldPurchase10
cls
echo Setting up Temporary Settings...
echo Purchasing 10
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!GoldGemMinerPrice!
set /a temporarygemminerpriceadder=!GoldGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :GoldCalculating10v1

:GoldCalculating10v1
if !temporarygemminer! EQU 10 (
    goto :GoldCalculating10v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :GoldCalculating10v2
goto :GoldCalculating10v1

:GoldCalculating10v2
if !temporarygemminer! LEQ 9 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :GoldPurchasing10
)

:GoldPurchasing10
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a GoldGemMiner=!GoldGemMiner! + !temporarygemminer!
set /a GoldGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:GoldPurchase100
cls
echo Setting up Temporary Settings...
echo Purchasing 100
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!GoldGemMinerPrice!
set /a temporarygemminerpriceadder=!GoldGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :GoldCalculating100v1

:GoldCalculating100v1
if !temporarygemminer! EQU 100 (
    goto :GoldCalculating100v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :GoldCalculating100v2
goto :GoldCalculating100v1

:GoldCalculating100v2
if !temporarygemminer! LEQ 99 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :GoldPurchasing100
)

:GoldPurchasing100
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a GoldGemMiner=!GoldGemMiner! + !temporarygemminer!
set /a GoldGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:GoldPurchaseMAX
cls
echo Setting up Temporary Settings...
echo Purchasing MAX
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!GoldGemMinerPrice!
set /a temporarygemminerpriceadder=!GoldGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :GoldCalculatingMAXv1

:GoldCalculatingMAXv1
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :GoldPurchasingMAX
goto :GoldCalculatingMAXv1

:GoldPurchasingMAX
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a GoldGemMiner=!GoldGemMiner! + !temporarygemminer!
set /a GoldGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop

:: ================================================================================================================

:: ======================================   D   I   A   M   O   N   D   ===========================================

:DiamondBuy
cls
if !DiamondGemMiner! GEQ 10000 (
call :YouHaveMaxMiners
)
if !Gems! GEQ !DiamondGemMinerPrice! (
goto :DiamondBuyAmmount
) else goto :NotEnoughMoney

:DiamondBuyAmmount
cls
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
set /a temporarygemminerpriceadder=0
echo How much Diamond Miners would you like to purchase?
echo.
echo [1] Availible
echo [10] Availible
echo [100] Availible
echo [MAX] Availible
set /p DiamondPurchaseAmmount=">> "
if !DiamondPurchaseAmmount! EQU 1 (goto :DiamondPurchase1)
if !DiamondPurchaseAmmount! EQU 10 (goto :DiamondPurchase10)
if !DiamondPurchaseAmmount! EQU 100 (goto :DiamondPurchase100)
if !DiamondPurchaseAmmount! EQU MAX (goto :DiamondPurchaseMAX)
goto :DiamondBuyAmmount

:DiamondPurchase1
cls
set /a Gems=!Gems! - !DiamondGemMinerPrice!
set /a DiamondGemMinerPrice=!DiamondGemMinerPrice! + !DiamondGemMinerPriceAdder!
set /a DiamondGemMiner=!DiamondGemMiner! + 1
echo Purchased!
pause
goto :shop





:DiamondPurchase10
cls
echo Setting up Temporary Settings...
echo Purchasing 10
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!DiamondGemMinerPrice!
set /a temporarygemminerpriceadder=!DiamondGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :DiamondCalculating10v1

:DiamondCalculating10v1
if !temporarygemminer! EQU 10 (
    goto :DiamondCalculating10v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :DiamondCalculating10v2
goto :DiamondCalculating10v1

:DiamondCalculating10v2
if !temporarygemminer! LEQ 9 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :DiamondPurchasing10
)

:DiamondPurchasing10
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a DiamondGemMiner=!DiamondGemMiner! + !temporarygemminer!
set /a DiamondGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:DiamondPurchase100
cls
echo Setting up Temporary Settings...
echo Purchasing 100
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!DiamondGemMinerPrice!
set /a temporarygemminerpriceadder=!DiamondGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :DiamondCalculating100v1

:DiamondCalculating100v1
if !temporarygemminer! EQU 100 (
    goto :DiamondCalculating100v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :DiamondCalculating100v2
goto :DiamondCalculating100v1

:DiamondCalculating100v2
if !temporarygemminer! LEQ 99 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :DiamondPurchasing100
)

:DiamondPurchasing100
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a DiamondGemMiner=!DiamondGemMiner! + !temporarygemminer!
set /a DiamondGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:DiamondPurchaseMAX
cls
echo Setting up Temporary Settings...
echo Purchasing MAX
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!DiamondGemMinerPrice!
set /a temporarygemminerpriceadder=!DiamondGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :DiamondCalculatingMAXv1

:DiamondCalculatingMAXv1
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :DiamondPurchasingMAX
goto :DiamondCalculatingMAXv1

:DiamondPurchasingMAX
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a DiamondGemMiner=!DiamondGemMiner! + !temporarygemminer!
set /a DiamondGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop

:: ================================================================================================================

:: ======================================   E   M   E   R   A   L   D   ===========================================

:EmeraldBuy
cls
if !EmeraldGemMiner! GEQ 1000 (
call :YouHaveMaxMiners
)
if !Gems! GEQ !EmeraldGemMinerPrice! (
goto :EmeraldBuyAmmount
) else goto :NotEnoughMoney

:EmeraldBuyAmmount
cls
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
set /a temporarygemminerpriceadder=0
echo How much Emerald Miners would you like to purchase?
echo.
echo [1] Availible
echo [10] Availible
echo [100] Availible
echo [MAX] Availible
set /p EmeraldPurchaseAmmount=">> "
if !EmeraldPurchaseAmmount! EQU 1 (goto :EmeraldPurchase1)
if !EmeraldPurchaseAmmount! EQU 10 (goto :EmeraldPurchase10)
if !EmeraldPurchaseAmmount! EQU 100 (goto :EmeraldPurchase100)
if !EmeraldPurchaseAmmount! EQU MAX (goto :EmeraldPurchaseMAX)
goto :EmeraldBuyAmmount






:EmeraldPurchase1
cls
set /a Gems=!Gems! - !EmeraldGemMinerPrice!
set /a EmeraldGemMinerPrice=!EmeraldGemMinerPrice! + !EmeraldGemMinerPriceAdder!
set /a EmeraldGemMiner=!EmeraldGemMiner! + 1
echo Purchased!
pause
goto :shop





:EmeraldPurchase10
cls
echo Setting up Temporary Settings...
echo Purchasing 10
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!EmeraldGemMinerPrice!
set /a temporarygemminerpriceadder=!EmeraldGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :EmeraldCalculating10v1

:EmeraldCalculating10v1
if !temporarygemminer! EQU 10 (
    goto :EmeraldCalculating10v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :EmeraldCalculating10v2
goto :EmeraldCalculating10v1

:EmeraldCalculating10v2
if !temporarygemminer! LEQ 9 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :EmeraldPurchasing10
)

:EmeraldPurchasing10
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a EmeraldGemMiner=!EmeraldGemMiner! + !temporarygemminer!
set /a EmeraldGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:EmeraldPurchase100
cls
echo Setting up Temporary Settings...
echo Purchasing 100
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!EmeraldGemMinerPrice!
set /a temporarygemminerpriceadder=!EmeraldGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :EmeraldCalculating100v1

:EmeraldCalculating100v1
if !temporarygemminer! EQU 100 (
    goto :EmeraldCalculating100v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :EmeraldCalculating100v2
goto :EmeraldCalculating100v1

:EmeraldCalculating100v2
if !temporarygemminer! LEQ 99 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :EmeraldPurchasing100
)

:EmeraldPurchasing100
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a EmeraldGemMiner=!EmeraldGemMiner! + !temporarygemminer!
set /a EmeraldGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:EmeraldPurchaseMAX
cls
echo Setting up Temporary Settings...
echo Purchasing MAX
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!EmeraldGemMinerPrice!
set /a temporarygemminerpriceadder=!EmeraldGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :EmeraldCalculatingMAXv1

:EmeraldCalculatingMAXv1
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :EmeraldPurchasingMAX
goto :EmeraldCalculatingMAXv1

:EmeraldPurchasingMAX
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a EmeraldGemMiner=!EmeraldGemMiner! + !temporarygemminer!
set /a EmeraldGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop

:: ================================================================================================================

:: ==============================   D   A   R   K      M   A   T   T   E   R   ====================================

:DarkMatterBuy
cls
if !DarkMatterGemMiner! GEQ 100 (
call :YouHaveMaxMiners
)
if !Gems! GEQ !DarkMatterGemMinerPrice! (
goto :DarkMatterBuyAmmount
) else goto :NotEnoughMoney

:DarkMatterBuyAmmount
cls
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
set /a temporarygemminerpriceadder=0
echo How much DarkMatter Miners would you like to purchase?
echo.
echo [1] Availible
echo [10] Availible
echo [100] Availible
echo [MAX] Availible
set /p DarkMatterPurchaseAmmount=">> "
if !DarkMatterPurchaseAmmount! EQU 1 (goto :DarkMatterPurchase1)
if !DarkMatterPurchaseAmmount! EQU 10 (goto :DarkMatterPurchase10)
if !DarkMatterPurchaseAmmount! EQU 100 (goto :DarkMatterPurchase100)
if !DarkMatterPurchaseAmmount! EQU MAX (goto :DarkMatterPurchaseMAX)
goto :DarkMatterBuyAmmount





:DarkMatterPurchase1
cls
set /a Gems=!Gems! - !DarkMatterGemMinerPrice!
set /a DarkMatterGemMinerPrice=!DarkMatterGemMinerPrice! + !DarkMatterGemMinerPriceAdder!
set /a DarkMatterGemMiner=!DarkMatterGemMiner! + 1
echo Purchased!
pause
goto :shop





:DarkMatterPurchase10
cls
echo Setting up Temporary Settings...
echo Purchasing 10
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!DarkMatterGemMinerPrice!
set /a temporarygemminerpriceadder=!DarkMatterGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :DarkMatterCalculating10v1

:DarkMatterCalculating10v1
if !temporarygemminer! EQU 10 (
    goto :DarkMatterCalculating10v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :DarkMatterCalculating10v2
goto :DarkMatterCalculating10v1

:DarkMatterCalculating10v2
if !temporarygemminer! LEQ 9 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :DarkMatterPurchasing10
)

:DarkMatterPurchasing10
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a DarkMatterGemMiner=!DarkMatterGemMiner! + !temporarygemminer!
set /a DarkMatterGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:DarkMatterPurchase100
cls
echo Setting up Temporary Settings...
echo Purchasing 100
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!DarkMatterGemMinerPrice!
set /a temporarygemminerpriceadder=!DarkMatterGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :DarkMatterCalculating100v1

:DarkMatterCalculating100v1
if !temporarygemminer! EQU 100 (
    goto :DarkMatterCalculating100v2
)
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :DarkMatterCalculating100v2
goto :DarkMatterCalculating100v1

:DarkMatterCalculating100v2
if !temporarygemminer! LEQ 99 (
    cls
    echo Not enough Money...
    pause
    goto :shop
) else (
    goto :DarkMatterPurchasing100
)

:DarkMatterPurchasing100
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a DarkMatterGemMiner=!DarkMatterGemMiner! + !temporarygemminer!
set /a DarkMatterGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop





:DarkMatterPurchaseMAX
cls
echo Setting up Temporary Settings...
echo Purchasing MAX
set /a temporarygems=!Gems!
set /a temporarygemminer=0
set /a temporarygemminerprice=!DarkMatterGemMinerPrice!
set /a temporarygemminerpriceadder=!DarkMatterGemMinerPriceAdder!
timeout 1 /nobreak >nul
goto :DarkMatterCalculatingMAXv1

:DarkMatterCalculatingMAXv1
cls
echo Calculating...
if !temporarygems! geq !temporarygemminerprice! (
    set /a temporarygems=!temporarygems! - !temporarygemminerprice!
    set /a temporarygemminerprice=!temporarygemminerprice! + !temporarygemminerpriceadder!
    set /a temporarygemminer=!temporarygemminer! + 1
) else goto :DarkMatterPurchasingMAX
goto :DarkMatterCalculatingMAXv1

:DarkMatterPurchasingMAX
cls
echo Purchasing...
set /a Gems=!temporarygems!
set /a DarkMatterGemMiner=!DarkMatterGemMiner! + !temporarygemminer!
set /a DarkMatterGemMinerPrice=!temporarygemminerprice!
set /a temporarygems=0
set /a temporarygemminer=0
set /a temporarygemminerprice=0
cls
echo Purchased!
pause
goto :shop

:: ================================================================================================================

:: ========================================   T   R   O   P   H   Y   =============================================

:TrophyBuy
cls
if !Gems! GEQ 1000000000 (
goto :TrophyAmmount
) else goto :NotEnoughMoney

:TrophyAmmount
cls
echo How much Trophies would you like to purchase?
echo.
echo [1] Availible
echo [10] Availible
echo [100] Availible
echo [MAX] Availible
set /p TrophyPurchaseAmmount=">> "
if !TrophyPurchaseAmmount! EQU 1 (goto :TrophyBuy_1)
goto :TrophyBuyAmmount

:TrophyBuy_1
cls
set /a Gems=!Gems! - 1000000000
set /a Trophy=!Trophy! + 1
echo Purchased!
pause
goto :shop

:: ================================================================================================================

:: ========================================   S   T   A   T   S   =================================================



:stats
mode 50,30
call :savefileversioncheck
call :AutosaveModule
call :CheckForMaxMiners
call :GuestError
cls
echo.
echo        .   .   .   S T A T S   .   .   .
echo.
echo Playtime:!PlayYears!Y:!PlayDays!D:!PlayHours!H:!PlayMinutes!M:!PlaySeconds!S
echo You started Playing: !Join_Date!
echo.
echo.
echo Stuff Obtained:
echo Basic Mines Obtained. . . . !BasicGemMiner!
echo Iron Mines Obtained . . . . !IronGemMiner!
echo Silver Mines Obtained:. . . !SilverGemMiner!
echo Gold Mines Obtained . . . . !GoldGemMiner!
echo Diamond Mines Obtained. . . !DiamondGemMiner!
echo Emerald Mines Obtained. . . !EmeraldGemMiner!
echo Dark Matter Mines Obtained. !DarkMatterGemMiner!
echo Trophies Obtained . . . . . !Trophy!
echo.
echo.
echo You rebirthed !Rebirth! Times^^!
echo.
echo.
echo Boosts:
echo !RebirthBoost!x Rebirth Boost!
echo !TrophyBoost!x Trophies Boost!
echo.
echo.
echo Your Current Savefile Version: !savefileversion!
echo.
echo.
pause
goto :gamemenu

:: ================================================================================================================

:: ==============================   A   C   H   I   E   V   E   M   E   N   T   S   ===============================

:achievements
call :AutosaveModule
call :CheckForMaxMiners
call :GuestError
cls
mode 80,43
:achievementspage1
cls
echo.
echo                .   .   .   A C H I E V E M E N T S   .   .   .
echo.
echo                       =-=    Achievements Page 1    =-=
echo.
echo                Getting Started^^! =-= Buy 1 Basic Gem Miners = !Achievement_Basic1!
echo.
echo             Getting More of em^^! =-= Buy 10 Basic Gem Miners = !Achievement_Basic10!
echo.
echo                         Too ez^^! =-= Buy 100 Basic Gem Miners = !Achievement_Basic100!
echo.
echo                    Already 1K^^!? =-= Buy 1000 Basic Gem Miners = !Achievement_Basic1000!
echo.
echo                       Nolifer?^^! =-= Buy 10000 Basic Gem Miners = !Achievement_Basic10000!
echo.
echo                Hahahaha.. No..^^! =-= Buy 100000 Basic Gem Miners = !Achievement_Basic100000!
echo.
echo       Its spelled: L E G E N D^^! =-= Buy 1000000 Basic Gem Miners = !Achievement_Basic1000000!
echo.
echo                      100 Irons^^! =-= Buy 100 Iron Gem Miners = !Achievement_Iron100!
echo.
echo               Too cheap for me^^! =-= Buy 1000 Iron Gem Miners = !Achievement_Iron1000!
echo.
echo                    Iron Golem?^^! =-= Buy 10000 Iron Gem Miners = !Achievement_Iron10000!
echo.
echo                    RICHIE RICH^^! =-= Buy 100000 Iron Gem Miners = !Achievement_Iron100000!
echo.
echo                  SILVER SURFER^^! =-= Buy 100 Silver Gem Miners = !Achievement_Silver100!
echo.
echo                  Ay ay Captain^^! =-= Buy 1000 Silver Gem Miners = !Achievement_Silver1000!
echo.
echo                            Rare =-= Buy 10000 Silver Gem Miners = !Achievement_Silver10000!
echo.
echo          I  G O T  S I L V E R^^! =-= Buy 100000 Silver Gem Miners = !Achievement_Silver100000!
echo.
echo                    Bling BLing^^! =-= Buy 100 Gold Gem Miners = !Achievement_Gold100!
echo.
echo                   Golden Boots^^! =-= Buy 1000 Gold Gem Miners = !Achievement_Gold1000!
echo.
echo          Im rich, and your not^^! =-= Buy 10000 Gold Gem Miners = !Achievement_Gold10000!
echo.
CHOICE /C:ADB /N /M "Press A/D to move through pages^!                    Press B to return to Game^!"
if !errorlevel! equ 1 (
	goto :achievementspage1
) else if !errorlevel! equ 2 (
	goto :achievementspage2
) else if !errorlevel! equ 3 (
	goto :gamemenu
)

:achievementspage2
cls
echo.
echo                .   .   .   A C H I E V E M E N T S   .   .   .
echo.
echo                       =-=    Achievements Page 2    =-=
echo.
echo                          D I A^^! =-= Buy 100 Diamond Gem Miners = !Achievement_Diamond100!
echo.
echo                     Reall Rich^^! =-= Buy 1000 Diamond Gem Miners = !Achievement_Diamond1000!
echo.
echo                         H O W^^!? =-= Buy 10000 Diamond Gem Miners = !Achievement_Diamond10000!
echo.
echo                We got emeralds^^! =-= Buy 10 Emerald Gem Miners = !Achievement_Emerald10!
echo.
echo                L I F E L E S S^^! =-= Buy 100 Emerald Gem Miners = !Achievement_Emerald100!
echo.
echo                 villagers love^^! =-= Buy 1000 Emerald Gem Miners = !Achievement_Emerald1000!
echo.
echo              DARK MATTER POWAH^^! =-= Buy 1 DarkMatter Gem Miners = !Achievement_DarkMatter1!
echo.
echo           more dark mattress... =-= Buy 10 DarkMatter Gem Miners = !Achievement_DarkMatter10!
echo.
echo                MYTHICAL LEGEND^^! =-= Buy 100 DarkMatter Gem Miners = !Achievement_DarkMatter100!
echo.
echo                    First Code?^^! =-= Use YouTube Code = !Achievement_TheBeggining!
echo.
echo               U P D A T E  1.1^^! =-= Use YouTube Code = !Achievement_FirstUpdateWow!
echo.
echo               So many gems :O ^^! =-= Obtain 1000 Gems = !Achievement_Gems1000!
echo.
echo              RESPECT ME AIGHT^^!? =-= Obtain 10000 Gems = !Achievement_Gems10000!
echo.
echo               Brawl Stars Gems^^! =-= Obtain 100000 Gems = !Achievement_Gems100000!
echo.
echo          POV: Your really rich^^! =-= Obtain 1000000 Gems = !Achievement_Gems1000000!
echo.
echo             MOM GET THE CAMERA^^! =-= Obtain 10000000 Gems = !Achievement_Gems10000000!
echo.
echo   Pewdiepie could only dream... =-= Obtain 100000000 Gems = !Achievement_Gems100000000!
echo.
echo           Richer then your mom^^! =-= Obtain 1000000000 Gems = !Achievement_Gems1000000000!
echo.
CHOICE /C:ADB /N /M "Press A/D to move through pages^!                    Press B to return to Game^!"
if !errorlevel! equ 1 (
	goto :achievementspage1
) else if !errorlevel! equ 2 (
	goto :achievementspage3
) else if !errorlevel! equ 3 (
	goto :gamemenu
)

:achievementspage3
cls
echo.
echo                .   .   .   A C H I E V E M E N T S   .   .   .
echo.
echo                       =-=    Achievements Page 3    =-=
echo.
echo                          1 MIN^^! =-= Play for 1 Minute = !Achievement_Time1Min!
echo.
echo                  Time Machine?^^! =-= Play for 1 Hour = !Achievement_Time1Hour!
echo.
echo              Yeah ive got time^^! =-= Play for 1 Day = !Achievement_Time1Day!
echo.
echo           Touch some grass kid^^! =-= Play for 1 Year = !Achievement_Time1Year!
echo.
echo                 All over again^^! =-= Rebirth 1 Time = !Achievement_Rebirth1!
echo.
echo               Already 10 TIMES^^! =-= Rebirth 10 Times = !Achievement_Rebirth10!
echo.
echo           I LOVE DA REBIRTHING^^! =-= Rebirth 100 Times = !Achievement_Rebirth100!
echo.
echo     1000x Gems Boost goes BRRR^^! =-= Rebirth 1000 Times = !Achievement_Rebirth1000!
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
CHOICE /C:ADB /N /M "Press A/D to move through pages^!                    Press B to return to Game^!"
if !errorlevel! equ 1 (
	goto :achievementspage2
) else if !errorlevel! equ 2 (
	goto :achievementspage3
) else if !errorlevel! equ 3 (
	goto :gamemenu
)

:: ================================================================================================================

:: ==============================   U   P   D   A   T   E   S      N   O   T   E   ================================

:updatesnote
call :AutosaveModule
call :GuestError
call :CheckForMaxMiners
cls
mode 85,30
:updatesnotepage1
cls
echo.
echo                .   .   .   U P D A T E S   N O T E   .   .   .
echo.
echo                       =-=           Page 1          =-=
echo.
echo  Update Gem Miner v1.0
echo   - Release
echo.
echo  Update Gem Miner v1.1 (Technical Update I.)
echo   - Deleted Legit/Cheated Display
echo   - Added Achievements + Achievements Menu
echo   - New YouTube Code (See my YouTube Channels Description)
echo   - Deleted Networth due to Bug (Batch numbers are limited to 32-bits of precision.)
echo   - Credits Updated
echo   - Simplered the Code (Using More Functions)
echo   - 10x, 100x, MAX Payment Options added!
echo   - Username/Password Rules = 4-10 Characters, No spaces allowed
echo   - Bug Fixes
echo.
echo  Update Gem Miner v1.2 (Technical Update II.)
echo   - Local Storage at C:\GemMiner option added to settings
echo   - Downloadable Mods (Download Mods at my Github Page: github.com/Fisterkoo)
echo   - Added Join Date in Stats menu
echo.
echo  Update Gem Miner v1.3 (Sneak Peek) (Sacrifice Update)
echo   - ? Stars ?
echo   - ? Sacrifice Miner ?
echo   - ? A LOT MORE ?
echo.
CHOICE /C:ADB /N /M "Press A/D to move through pages^!                         Press B to return to Game^!"
if !errorlevel! equ 1 (
	goto :updatesnotepage1
) else if !errorlevel! equ 2 (
	goto :updatesnotepage1
) else if !errorlevel! equ 3 (
	goto :gamemenu
)
pause

:: ================================================================================================================

:: =====================================   S   E   T   T   I   N   G   S   ========================================

:settings
mode 50,20
cls
call :GuestError
call :AutosaveModule
call :CheckForMaxMiners
call "!savedirectory!\settings\LDMode.bat"
if !ColorTheme! EQU Dark (set ColorThemeMode=Light) else (set ColorThemeMode=Dark)
if exist "!savedirectory!\settings\xyz.bat" (set WarningScreen=Enable) else (set WarningScreen=Disable)
if exist "!savedirectory!\settings\autologin.bat" (set AutologinONOFF=Disable) else (set AutologinONOFF=Enable)
if exist "C:\GemMiner" (set LocalSavingONOFF=Disable) else (set LocalSavingONOFF=Enable)
if exist "!savedirectory!\settings\autosave.bat" (set AutosaveONOFF=Disable Autosave - Less Lag - No Input Delay) else (set AutosaveONOFF=Enable Autosave - More Lag - Input Delay)
echo.
echo     .   .   .   S E T T I N G S   .   .   .
echo.
echo [1] Enable !ColorThemeMode! Mode
echo [2] !WarningScreen! Warning Screen
echo [3] YouTube Codes
echo [4] !AutologinONOFF! Autologin
echo [5] Credits
echo [6] Delete All Data!
echo [7] !AutosaveONOFF!
echo [8] !LocalSavingONOFF! Local Saving
echo.
echo.
echo [9] Console Menu
echo [0] Return to The Game
set /p settingsmenu=">> "
if !settingsmenu! EQU 1 (goto :LightDarkMode)
if !settingsmenu! EQU 2 (goto :DisableWarning)
if !settingsmenu! EQU 3 (goto :YoutubeCodes)
if !settingsmenu! EQU 4 (goto :SetupAutologin)
if !settingsmenu! EQU 5 (goto :Credits)
if !settingsmenu! EQU 6 (goto :DeleteAllData)
if !settingsmenu! EQU 7 (goto :AutosaveSetup)
if !settingsmenu! EQU 8 (goto :LocalSaveSetup)
if !settingsmenu! EQU 9 (goto :ConsoleMenu)
if !settingsmenu! EQU 0 (goto :gamemenu)
goto :settings

:LightDarkMode
cls
call "!savedirectory!\settings\LDMode.bat"
if !ColorTheme! EQU Dark (
	(
	echo color F0
	echo set ColorTheme=Light
	)>"!savedirectory!\settings\LDMode.bat"
	call "!savedirectory!\settings\LDMode.bat"
	goto :settings
)
if !ColorTheme! EQU Light (
	(
	echo color 0F
	echo set ColorTheme=Dark
	)>"!savedirectory!\settings\LDMode.bat"
	call "!savedirectory!\settings\LDMode.bat"
	goto :settings
)

:DisableWarning
cls
if exist "!savedirectory!\settings\xyz.bat" (
	del /Q "!savedirectory!\settings\xyz.bat"
	goto :settings
) else (
	(
	echo.
	)>"!savedirectory!\settings\xyz.bat"
	goto :settings
)

:YoutubeCodes
cls
echo.
echo  .   .   .   Y O U T U B E  C O D E S   .   .   .
echo.
set /p YouTubeCodes="Enter Valid YouTube Code>> "
if !YouTubeCodes! EQU TH3B3GG1N1NG (
	if exist "!savedirectory!\settings\!loguse!code1.bat" (
		cls
		echo You have already redeemed the Code!
		pause
		goto :settings
	) else (
		set /a Gems=!Gems! + 1000
		(
		echo.
		)>"!savedirectory!\settings\!loguse!code1.bat"
		cls
		echo You just redeemed 1000 Gems!
		pause
		goto :settings
	)

) else if !YouTubeCodes! EQU FIRSTUPDATEW000W (
	if exist "!savedirectory!\settings\!loguse!code2.bat" (
		cls
		echo You have already redeemed the Code!
		pause
		goto :settings
	) else (
		set /a Gems=!Gems! + 1500
		(
		echo.
		)>"!savedirectory!\settings\!loguse!code2.bat"
		cls
		echo You just redeemed 1500 Gems!
		pause
		goto :settings
	)

) else (
	cls
	echo Invalid Code!
	pause
	goto :settings
)

:ConsoleMenu
mode 120,30
cls
echo Welcome, to the Console Menu!
echo Type "back" to Return to Settings Menu...
echo Type "mods" to Enter Mods Menu...
echo Type "admin" to Enter Admin Console...
echo.
set /p admincommand="[Console]>> "
if !!admincommand! EQU back (goto :settings)
if !!admincommand! EQU Back (goto :settings)
if !!admincommand! EQU mods (goto :modsconsole)
if !!admincommand! EQU Mods (goto :modsconsole)
if !!admincommand! EQU admin (goto :AdminConsole)
if !!admincommand! EQU Admin (goto :AdminConsole)
goto :ConsoleMenu

:modsconsole
cls
echo If you have any mods installed,
echo open the text file of the mod
echo and read the instructions...
echo.
echo Type "back" to Return to Console Menu
set /p command="Enter Command>> "
if !command! equ back (goto :ConsoleMenu)
if "!command!" equ "/gems set" (
    if exist "!savedirectory!\mods\GemsMod.txt" (
    cls
    echo Enter Any Number of Gems you would like to have
    set /p gemsmod="Limit: 2 Billion / 2000000000>> "
    if !gemsmod! gtr 2000000000 (
        call :InvalidCommandError
    )
    if !gemsmod! lss 1 (
        call :InvalidCommandError
    )
    set /a Gems=!gemsmod!
    cls
    echo Successfull!
    pause
    goto :modsconsole
    ) else (
        call :InvalidCommandError
        )
) else (
    call :InvalidCommandError
)

:AdminConsole
cls
echo Type "back" to return to Console Menu...
set /p pass="Enter valid Password>> "
if !console! equ back (goto :ConsoleMenu)
if not !pass! equ 1938290 (
    cls
    echo Wrong Password...
    pause
    goto :AdminConsole
)
:AdminConsoleLoop
cls
echo Type "back" to return to Console Menu...
set /p console="[Console]>> "
if !console! equ back (goto :ConsoleMenu)
!console!
pause
goto :AdminConsoleLoop

:SetupAutologin
cls
if exist "!savedirectory!\settings\autologin.bat" (
	del /Q "!savedirectory!\settings\autologin.bat"
	goto :settings
) else (
	(
	echo set loguse=!loguse!
	echo set logpas=!logpas!
	)>"!savedirectory!\settings\autologin.bat"
	goto :settings
)

:DeleteAllData
cls
echo Are you REALLY Sure you want to delete ALL DATA?
set /p DeleteAll="(Lost data cannot be recovered)[y/n]>> "
if !DeleteAll! EQU y (
	cls
	set /p DeleteVerify="Enter your Accounts Password>> "
	if !DeleteVerify! EQU !logpas! (
		goto :ProceedDeletion
	) else (
		cls
		echo Wrong Password!
		pause
		goto :settings
	)
)
if !DeleteAll! EQU n (goto :settings)
goto :DeleteAllData

:ProceedDeletion
cls
echo Deleting All Data...
if exist "!savedirectory!\settings\*.*" (del /Q "!savedirectory!\settings\*.*")
if exist "!savedirectory!\accounts\*.*" (del /Q "!savedirectory!\accounts\*.*")
if exist "!savedirectory!\accounts" (del /Q "!savedirectory!\accounts")
if exist "!savedirectory!\settings" (del /Q "!savedirectory!\settings")
cls
echo Success...
pause
goto :loading

:Credits
mode 75,15
cls
echo Game made by Fisterkoo
echo Game development started Friday 10. June 2022, 14:02:21s / 2:02:21s PM
echo Current Update: 1.2
echo.
echo Testers: JUNIXMAN
echo.
echo.
echo.
echo Social Networks:YouTube: @Fisterkoo Batch Scripting
echo                 Twitter: @fisterkoo
echo                 Instagram: @benjii.menn
echo                 TikTok: @fiztythegamer
echo                 Github: @Fisterkoo
echo.
pause
goto :gamemenu

:AutosaveSetup
cls
if exist "!savedirectory!\settings\autosave.bat" (
	del /Q "!savedirectory!\settings\autosave.bat"
	goto :settings
) else (
	(
	echo.
	)>"!savedirectory!\settings\autosave.bat"
	goto :settings
)

:LocalSaveSetup
if exist "C:\GemMinerChecker" (
    rd /S /Q "C:\GemMinerChecker"
) else (
    md "C:\GemMinerChecker"
)
cls
echo Game Restart Required...
echo Press any key to restart the game...
pause >nul
exit

:: ================================================================================================================

:: ==========================================   E   R   R   O   R   S   ===========================================

:NotEnoughMoney
cls
echo You do not have enough Money...
pause
goto :shop

:YouHaveMaxMiners
cls
echo You have Max Miners!
pause
goto :shop

:GuestError
cls
if !loguse! EQU Guest (
	echo You cannot change Settings in guest account...
	pause
	goto :gamemenu
)
goto :eof

:NoSpacesAllowed
cls
echo No Spaces Allowed!
pause
goto :eof

:LimitedCharacters
cls
echo Use password from 4-10 characters Only!
pause
goto :eof

:InvalidCommandError
cls
echo Invalid Command...
pause
goto :modsconsole

:: ================================================================================================================

:: ======================================   M   O   D   U   L   E   S   ===========================================

:AutosaveModule
if exist "!savedirectory!\settings\autosave.bat" (
	call :SaveModule
)
goto :eof

:PlaytimeModule
if !PlaySeconds! GEQ 60 (
	set /a PlaySeconds=0
	set /a PlayMinutes=!PlayMinutes! + 1
)
if !PlayMinutes! GEQ 60 (
	set /a PlayMinutes=0
	set /a PlayHours=!PlayMinutes! + 1
)
if !PlayHours! GEQ 24 (
	set /a PlayHours=0
	set /a PlayDays=!PlayMinutes! + 1
)
if !PlayDays! GEQ 365 (
	set /a PlayDays=0
	set /a PlayYears=!PlayMinutes! + 1
)
goto :eof

:UpdateNotificationModule
cls
call :savefileversioncheck
echo.
echo.
echo.
echo.
echo.
echo.
echo            Update Gem Miner 1.2 was Downloaded...
echo.
echo             Your current savefile version: !savefileversion!
echo.
echo               Please log into your account to
echo               finish updating your save file
echo                 to newest version... (1.2)
echo.
echo.
echo.
echo.
echo.
echo.
pause
goto :eof

:savefileversioncheck
if "!savefileversion!" equ "" (set savefileversion=1.0/1.1)
goto :eof

:SaveModule
(
echo set /a Gems=!Gems!
echo set /a BasicGemMiner=!BasicGemMiner!
echo set /a IronGemMiner=!IronGemMiner!
echo set /a SilverGemMiner=!SilverGemMiner!
echo set /a GoldGemMiner=!GoldGemMiner!
echo set /a DiamondGemMiner=!DiamondGemMiner!
echo set /a EmeraldGemMiner=!EmeraldGemMiner!
echo set /a DarkMatterGemMiner=!DarkMatterGemMiner!
echo set /a BasicGemMinerProfit=1
echo set /a IronGemMinerProfit=5
echo set /a SilverGemMinerProfit=10
echo set /a GoldGemMinerProfit=50
echo set /a DiamondGemMinerProfit=100
echo set /a EmeraldGemMinerProfit=500
echo set /a DarkMatterGemMinerProfit=1000
echo set /a BasicGemMinerPrice=!BasicGemMinerPrice!
echo set /a IronGemMinerPrice=!IronGemMinerPrice!
echo set /a SilverGemMinerPrice=!SilverGemMinerPrice!
echo set /a GoldGemMinerPrice=!GoldGemMinerPrice!
echo set /a DiamondGemMinerPrice=!DiamondGemMinerPrice!
echo set /a EmeraldGemMinerPrice=!EmeraldGemMinerPrice!
echo set /a DarkMatterGemMinerPrice=!DarkMatterGemMinerPrice!
echo set /a BasicGemMinerPriceAdder=15
echo set /a IronGemMinerPriceAdder=150
echo set /a SilverGemMinerPriceAdder=7500
echo set /a GoldGemMinerPriceAdder=15000
echo set /a DiamondGemMinerPriceAdder=75000
echo set /a EmeraldGemMinerPriceAdder=150000
echo set /a DarkMatterGemMinerPriceAdder=750000
echo set /a Basic=0
echo set /a Iron=0
echo set /a Siver=0
echo set /a Gold=0
echo set /a Diamond=0
echo set /a Emerald=0
echo set /a DarkMatter=0
echo set /a Miners=0
echo set /a Rebirth=!Rebirth!
echo set /a RebirthBoost=!RebirthBoost!
echo set /a Trophy=!Trophy!
echo set /a PlaySeconds=!PlaySeconds!
echo set /a PlayMinutes=!PlayMinutes!
echo set /a PlayHours=!PlayHours!
echo set /a PlayDays=!PlayDays!
echo set /a PlayYears=!PlayYears!
echo set Achievement_Basic1=!Achievement_Basic1!
echo set Achievement_Basic10=!Achievement_Basic10!
echo set Achievement_Basic100=!Achievement_Basic100!
echo set Achievement_Basic1000=!Achievement_Basic1000!
echo set Achievement_Basic10000=!Achievement_Basic10000!
echo set Achievement_Basic100000=!Achievement_Basic100000!
echo set Achievement_Basic1000000=!Achievement_Basic1000000!
echo set Achievement_Iron100=!Achievement_Iron100!
echo set Achievement_Iron1000=!Achievement_Iron1000!
echo set Achievement_Iron10000=!Achievement_Iron10000!
echo set Achievement_Iron100000=!Achievement_Iron100000!
echo set Achievement_Silver100=!Achievement_Silver100!
echo set Achievement_Silver1000=!Achievement_Silver1000!
echo set Achievement_Silver10000=!Achievement_Silver10000!
echo set Achievement_Silver100000=!Achievement_Silver100000!
echo set Achievement_Gold100=!Achievement_Gold100!
echo set Achievement_Gold1000=!Achievement_Gold1000!
echo set Achievement_Gold10000=!Achievement_Gold10000!
echo set Achievement_Diamond100=!Achievement_Diamond100!
echo set Achievement_Diamond1000=!Achievement_Diamond1000!
echo set Achievement_Diamond10000=!Achievement_Diamond10000!
echo set Achievement_Emerald10=!Achievement_Emerald10!
echo set Achievement_Emerald100=!Achievement_Emerald100!
echo set Achievement_Emerald1000=!Achievement_Emerald1000!
echo set Achievement_DarkMatter1=!Achievement_DarkMatter1!
echo set Achievement_DarkMatter10=!Achievement_DarkMatter10!
echo set Achievement_DarkMatter100=!Achievement_DarkMatter100!
echo set Achievement_TheBeggining=!Achievement_TheBeggining!
echo set Achievement_FirstUpdateWow=!Achievement_FirstUpdateWow!
echo set Achievement_Gems1000=!Achievement_Gems1000!
echo set Achievement_Gems10000=!Achievement_Gems10000!
echo set Achievement_Gems100000=!Achievement_Gems100000!
echo set Achievement_Gems1000000=!Achievement_Gems1000000!
echo set Achievement_Gems10000000=!Achievement_Gems10000000!
echo set Achievement_Gems100000000=!Achievement_Gems100000000!
echo set Achievement_Gems1000000000=!Achievement_Gems1000000000!
echo set Achievement_Time1Min=!Achievement_Time1Min!
echo set Achievement_Time1Hour=!Achievement_Time1Hour!
echo set Achievement_Time1Day=!Achievement_Time1Day!
echo set Achievement_Time1Year=!Achievement_Time1Year!
echo set Achievement_Rebirth1=!Achievement_Rebirth1!
echo set Achievement_Rebirth10=!Achievement_Rebirth10!
echo set Achievement_Rebirth100=!Achievement_Rebirth100!
echo set Achievement_Rebirth1000=!Achievement_Rebirth1000!
echo set Join_Date=!Join_Date!
echo set savefileversion=v1.2
)>"!savedirectory!\accounts\!loguse!save.bat"
goto :eof

:AchievementsModule
if !BasicGemMiner! geq 1 (set Achievement_Basic1=Own)
if !BasicGemMiner! geq 10 (set Achievement_Basic10=Own)
if !BasicGemMiner! geq 100 (set Achievement_Basic100=Own)
if !BasicGemMiner! geq 1000 (set Achievement_Basic1000=Own)
if !BasicGemMiner! geq 10000 (set Achievement_Basic10000=Own)
if !BasicGemMiner! geq 100000 (set Achievement_Basic100000=Own)
if !BasicGemMiner! geq 1000000 (set Achievement_Basic1000000=Own)
if !IronGemMiner! geq 100 (set Achievement_Iron100=Own)
if !IronGemMiner! geq 1000 (set Achievement_Iron1000=Own)
if !IronGemMiner! geq 10000 (set Achievement_Iron10000=Own)
if !IronGemMiner! geq 100000 (set Achievement_Iron100000=Own)
if !SilverGemMiner! geq 100 (set Achievement_Silver100=Own)
if !SilverGemMiner! geq 1000 (set Achievement_Silver1000=Own)
if !SilverGemMiner! geq 10000 (set Achievement_Silver10000=Own)
if !SilverGemMiner! geq 100000 (set Achievement_Silver100000=Own)
if !GoldGemMiner! geq 100 (set Achievement_Gold100=Own)
if !GoldGemMiner! geq 1000 (set Achievement_Gold1000=Own)
if !GoldGemMiner! geq 10000 (set Achievement_Gold10000=Own)
if !DiamondGemMiner! geq 100 (set Achievement_Diamond100=Own)
if !DiamondGemMiner! geq 1000 (set Achievement_Diamond1000=Own)
if !DiamondGemMiner! geq 10000 (set Achievement_Diamond10000=Own)
if !EmeraldGemMiner! geq 10 (set Achievement_Emerald10=Own)
if !EmeraldGemMiner! geq 100 (set Achievement_Emerald100=Own)
if !EmeraldGemMiner! geq 1000 (set Achievement_Emerald1000=Own)
if !DarkMatterGemMiner! geq 1 (set Achievement_DarkMatter1=Own)
if !DarkMatterGemMiner! geq 10 (set Achievement_DarkMatter10=Own)
if !DarkMatterGemMiner! geq 100 (set Achievement_DarkMatter100=Own)
if exist "!savedirectory!\settings\!loguse!code1.bat" (set Achievement_TheBeggining=Own)
if exist "!savedirectory!\settings\!loguse!code2.bat" (set Achievement_FirstUpdateWow=Own)
if !Gems! geq 1000 (set Achievement_Gems1000=Own)
if !Gems! geq 10000 (set Achievement_Gems10000=Own)
if !Gems! geq 100000 (set Achievement_Gems100000=Own)
if !Gems! geq 1000000 (set Achievement_Gems1000000=Own)
if !Gems! geq 10000000 (set Achievement_Gems10000000=Own)
if !Gems! geq 100000000 (set Achievement_Gems100000000=Own)
if !Gems! geq 1000000000 (set Achievement_Gems1000000000=Own)
if !Gems! geq 1000000000 (set Achievement_Gems1000000000=Own)
if !PlayMinutes! geq 1 (set Achievement_Time1Min=Own)
if !PlayHours! geq 1 (set Achievement_Time1Hour=Own)
if !PlayDays! geq 1 (set Achievement_Time1Day=Own)
if !PlayYears! geq 1 (set Achievement_Time1Year=Own)
if !Rebirth! geq 1 (set Achievement_Rebirth1=Own)
if !Rebirth! geq 10 (set Achievement_Rebirth10=Own)
if !Rebirth! geq 100 (set Achievement_Rebirth100=Own)
if !Rebirth! geq 1000 (set Achievement_Rebirth1000=Own)
goto :eof

:CheckForMaxMiners
if !BasicGemMiner! GTR 1000000 (
set BasicGemMiner=1000000
)
if !IronGemMiner! GTR 100000 (
set IronGemMiner=100000
)
if !SilverGemMiner! GTR 100000 (
set SilverGemMiner=100000
)
if !GoldGemMiner! GTR 10000 (
set GoldGemMiner=10000
)
if !DiamondGemMiner! GTR 10000 (
set DiamondGemMiner=10000
)
if !EmeraldGemMiner! GTR 1000 (
set EmeraldGemMiner=1000
)
if !DarkMatterGemMiner! GTR 100 (
set DarkMatterGemMiner=100
)
goto :eof

:MaxGemsModule
if !Gems! gtr 2000000000 (set Gems=2000000000)
goto :eof

:: ================================================================================================================

:: ===========================   S   A   V   E      P   R   O   G   R   E   S   S   ===============================

:save
cls
call :GuestError
call :CheckForMaxMiners
call :SaveModule
echo Saved!
pause
goto :gamemenu

:: ================================================================================================================

:: ==================================================   Q   U   I   T   ===========================================

:quit
cls
echo Quitting..
call :SaveModule
if exist "!savedirectory!\accounts\Guestsave.bat" (del /Q "!savedirectory!\accounts\Guestsave.bat")
ping localhost -n 2 >nul
echo Quitting...
exit

:: ================================================================================================================