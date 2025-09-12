; Script Inno Setup untuk aplikasi Flutter Windows

[Setup]
AppName=Admin
AppVersion=1.0
AppPublisher=Nama Kamu
AppPublisherURL=https://example.com
DefaultDirName={pf}\Admin
DefaultGroupName=Admin
UninstallDisplayIcon={app}\Admin.exe
Compression=lzma
SolidCompression=yes
OutputDir=output
OutputBaseFilename=AdminAppInstaller
WizardStyle=modern

[Files]
; Copy semua file dari hasil build Flutter (Release folder)
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
; Shortcut di Start Menu
Name: "{group}\Admin"; Filename: "{app}\Admin.exe"
; Shortcut di Desktop
Name: "{commondesktop}\Admin"; Filename: "{app}\Admin.exe"

[Run]
; Jalankan aplikasi langsung setelah instalasi selesai
Filename: "{app}\Admin.exe"; Description: "Jalankan Admin"; Flags: nowait postinstall skipifsilent
