' vbs script sendto with Thunderbird
Set args = Wscript.Arguments

if args.Count = 0 then wscript.Quit

'First parameter
jargs=args.Item(0)

'Filenames for subject separated by commas
sargs = Mid(jargs, InStrRev(jargs, "\") + 1)

'Filenames for body with CR
bargs = sargs

'Enumerate other parameters
For i = 1 To args.Count-1 
  jargs=jargs & "," & args.Item(i)
  name=Mid(args.Item(i), InStrRev(args.Item(i), "\") + 1)
  sargs=sargs & "; " & name
  bargs=bargs & "<br>" & name
Next

' Get language id
dim lng
lng=GetLocale And &HFF&

'Now, compose message 
Select Case lng  
  Case 12     'French  
    begsubject="Envoi d'un fichier: "
    begsubjects="Envoi des fichiers: "
    begbody="Bonjour<br><br>Veuillez trouver ci-joint le fichier: <br><br>"
    begbodys="Bonjour<br><br>Veuillez trouver ci-joint les fichiers: <br><br>"        
  Case Else  
    begsubject="Send a file: "
    begsubjects="Send files: "
    begbody="Hello<br><br>Please find attached the file: <br><br>"
    begbodys="Hello<br><br>Please find attached the files: <br><br>"          
End Select  

if args.Count > 1 then 
  begbody= begbodys
  begsubject= begsubjects
end if

Set WshShell = WScript.CreateObject("WScript.Shell")
username="<br><br>" & wshShell.ExpandEnvironmentStrings( "%USERNAME%" )

fargs="-compose attachment='""" & jargs & """',subject='""" & begsubject  & sargs &"""',body='""" & begbody & bargs & username & """'"

' Command line commented for use with nsis installer 
' nsis installer will add proper path at run time
' Uncomment and remplace Thunderbird.exe with proper path to use manually

' WshShell.Run """Thunderbird.exe""" & fargs