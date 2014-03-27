
!define icon "icon.ico"
;--------------------------------

; The name of the installer
Name "FairytaleFactoryFantastica Installer"


 Icon "${icon}"

; The file to write
OutFile "FairytaleFactoryFantasticaInstaller.exe"

; The default installation directory
InstallDir $PROGRAMFILES\FairytaleFactoryFantastica

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\FairytaleFactoryFantastica" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "FairytaleFactoryFantastica (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  

  
  ; Put file there
  File /r /x .nsi *

  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\FairytaleFactoryFantastica "Install_Dir" "$INSTDIR"
  WriteRegStr HKCR "FairytaleFactoryFantastica\DefaultIcon" "" "$INSTDIR\${icon}"
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FairytaleFactoryFantastica" "DisplayName" "FairytaleFactoryFantastica"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FairytaleFactoryFantastica" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FairytaleFactoryFantastica" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FairytaleFactoryFantastica" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Shortcuts"
  CreateDirectory "$SMPROGRAMS\FairytaleFactoryFantastica"
  CreateShortCut "$SMPROGRAMS\FairytaleFactoryFantastica\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\${icon}"
  CreateShortCut "$SMPROGRAMS\FairytaleFactoryFantastica\FairytaleFactoryFantastica.lnk" "$INSTDIR\FairytaleFactoryFantastica.exe" "" "$INSTDIR\${icon}"
  CreateShortCut "$DESKTOP\FairytaleFactoryFantastica.lnk" "$INSTDIR\FairytaleFactoryFantastica.exe" "" "$INSTDIR\${icon}"
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FairytaleFactoryFantastica"
  DeleteRegKey HKLM "SOFTWARE\FairytaleFactoryFantastica"
  DeleteRegKey HKCR "FairytaleFactoryFantastica\DefaultIcon"

  ; Remove files and uninstaller
  RMDir /r "$INSTDIR"
  
  ; Remove shortcuts, if any
  RMDir /r  "$SMPROGRAMS\FairytaleFactoryFantastica\"
  Delete "$DESKTOP\FairytaleFactoryFantastica.lnk"

SectionEnd
