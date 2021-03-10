;Installation script for Sendtotb

;--------------------------------

  !include MUI2.nsh
  !include "${NSISDIR}\Contrib\Modern UI\BB.nsh"

  !include x64.nsh
  !include FileFunc.nsh

;--------------------------------
;Configuration

 ;General
  Name "Send to Thunderbird"
  OutFile "InstSendToTb.exe"
  

  RequestExecutionLevel admin

  ;Windows vista.. 10 manifest
  ManifestSupportedOS all
 

  !define MUI_ICON "Sendtotb.ico"
  !define MUI_UNICON "Sendtotb.ico"

  ;Folder selection page
  InstallDir "$PROGRAMFILES\Sendtotb"

  ;--------------------------------
; Interface Settings

  !define MUI_ABORTWARNING
 
;--------------------------------

; Text for finsih page must change if we dont find TB

  var Finish_title
  var Finish_text

;-----------------------------
;Pages
  !define MUI_WELCOMEPAGE_TITLE_3LINES
  !insertmacro MUI_PAGE_WELCOME

  !insertmacro MUI_PAGE_INSTFILES

  !define MUI_FINISHPAGE_TITLE "$Finish_title"
  !define MUI_FINISHPAGE_TEXT "$Finish_text"
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "French"

  ;Language strings for program name
  LangString ProgNameStr ${LANG_ENGLISH}  "Send to Thunderbird"
  LangString ProgNameStr ${LANG_FRENCH} "Envoyer vers Thunderbird"

  ;Language strings for uninstall string
  LangString RemoveStr ${LANG_ENGLISH}  "Send to Thunderbird"
  LangString RemoveStr ${LANG_FRENCH} "Envoyer vers Thunderbird"

  ;Language string for links
  LangString UninstLnkStr ${LANG_ENGLISH} "Send to Thunderbird uninstall.lnk"
  LangString UninstLnkStr ${LANG_FRENCH} "Désinstallation de Envoyer vers Thunderbird"

  ;Language strings for language selection dialog
  LangString LangDialog_Title ${LANG_ENGLISH} "Installer Language|$(^CancelBtn)"
  LangString LangDialog_Title ${LANG_FRENCH} "Langue d'installation|$(^CancelBtn)"

  LangString LangDialog_Text ${LANG_ENGLISH} "Please select the installer language."
  LangString LangDialog_Text ${LANG_FRENCH} "Choisissez la langue du programme d'installation."

  LangString Abort_Title ${LANG_ENGLISH} '"Send To Thunderbird" install aborted'
  LangString Abort_Title ${LANG_FRENCH} 'Installation de "Envoyer vers Thunderbird" abandonnée.'

  LangString Abort_Finish ${LANG_ENGLISH} "Thunderbird not found on your computer, installation aborted.$\r$\n$\r$\nClick Finish to close Setup."
  LangString Abort_Finish ${LANG_FRENCH} "Thunderbird non trouvé sur votre ordinateur, Installation abandonnée.$\r$\n$\r$\nCliquez sur Fermer pour quitter le programme d'installation."

  LangString Abort_Text ${LANG_ENGLISH} "Thunderbird not found on your computer$\nInstallation aborted"
  LangString Abort_Text ${LANG_FRENCH} "Thunderbird non trouvé sur votre ordinateur$\nInstallation abandonnée."

  LangString Success_Title ${LANG_ENGLISH} '"Send To Thunderbird" install completed'
  LangString Success_Title ${LANG_FRENCH} 'Installation de "Envoyer vers Thunderbird" terminée.'

  LangString Success_Text ${LANG_ENGLISH} '"Send To Thunderbird" has been installed on your computer.$\r$\n$\r$\nClick Finish to close Setup.'
  LangString Success_Text ${LANG_FRENCH} '"Envoyer vers Thunderbird" a été installé sur votre ordinateur.$\r$\n$\r$\nCliquez sur Fermer pour quitter le programme d$\'installation.'
  
;--------------------------------

; The stuff to install

Section "Dummy Section" SecDummy
  SetShellVarContext all
  ; Check if thunderbird is properly installed
  ClearErrors
  Var /GLOBAL regval
  ReadRegStr $regval HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\thunderbird.exe" ""
  ${If} ${Errors}
     MessageBox MB_OK "$(Abort_Text)"
     StrCpy "$Finish_title" "$(Abort_title)"
     StrCpy "$Finish_text" "$(Abort_Text)"
     ;quit
  ${else}
     SetOutPath "$INSTDIR"
     StrCpy "$Finish_title" "$(Success_title)"
     StrCpy "$Finish_text" "$(Success_Text)"
     File "Sendtotb.vbs"
     File "Sendtotb.ico"

     ; write out uninstaller
     WriteUninstaller "$INSTDIR\uninst.exe"
     
     ; Now open the installed vbs file to append the proper command line
     FileOpen $4 "$INSTDIR\Sendtotb.vbs" a
     FileSeek $4 0 END
     FileWrite $4 "$\r$\n" ; we write a new line
     FileWrite $4 'WshShell.Run """$regval""" & fargs' ; write Tb command line
     FileWrite $4 "$\r$\n" ; we write an extra line
     FileClose $4 ; and close the file
     
    ;Write uninstall in register
    WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\Sendtotb" "UninstallString" "$INSTDIR\uninst.exe"
    WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\Sendtotb" "DisplayIcon" "$INSTDIR\uninst.exe"
    WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\Sendtotb" "DisplayName" "$(RemoveStr)"
    WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\Sendtotb" "Publisher" "SDTP"
  ${EndIf}
SectionEnd ; end of default section

; Install shortcuts, language dependant

Section "Send to Shortcuts"
  SetShellVarContext current
  CreateShortCut  "$APPDATA\Microsoft\Windows\SendTo\Thunderbird.lnk" "$INSTDIR\Sendtotb.vbs" "" "$INSTDIR\Sendtotb.ico" 0

SectionEnd

;Uninstaller Section

Section Uninstall
  SetShellVarContext all
; ON ferme l'application avant de la désinstaller

; add delete commands to delete whatever files/registry keys/etc you installed here.
Delete "$INSTDIR\Sendtotb.vbs"
Delete "$INSTDIR\Sendtotb.ico"
Delete "$INSTDIR\uninst.exe"

; remove shortcuts, if any.
 SetShellVarContext current
 Delete "$APPDATA\Microsoft\Windows\SendTo\$(ProgNameStr).lnk"


; remove directories used.

  RMDir "$INSTDIR"

  DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Sendtotb"

SectionEnd ; end of uninstall section

Function .onInit
  ; !insertmacro MUI_LANGDLL_DISPLAY
  ${If} ${RunningX64}
    SetRegView 64    ; change registry entries and install dir for 64 bit
    StrCpy "$INSTDIR" "$PROGRAMFILES64\Sendtotb"
  ${EndIf}
FunctionEnd

