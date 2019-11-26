using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."



$VM = Get-AzVM -Status -Name "pfsense"

$HTML = New-Object -TypeName "System.Text.StringBuilder"
[void]$HTML.AppendLine( @"
<!DOCTYPE html>
<html>
<head>
   <title>roeleverink.nl VM starter</title>
</head>
<style>
table, th, td {
   border: 1px solid black;
   border-collapse: collapse;
 }
</style>
<body>

<h1>roeleverink.nl <br />
SelfService VPN starter</h1>

<b>Current state of the VPN machine:</b><br/>
<table>
<tr>
<th>VMname</th><th>Current Powerstate</th>
</tr>
<tr>
<td>$($VM.Name)</td><td>$($VM.PowerState)</td>
</tr>
</table>
<br/>
<br/>
<H2>Press the button to start the VPN server, if not running</H2>
<p>After pressing the button, it can take up to 10 minutes for the server to start</p>

<form action="https://selfservicevm.azurewebsites.net/api/vmstarter"
      method="post">
      <input type="submit" name="Start" value="Start VPN server" />
   </form>
   <br />
   <p>To download the VPN client, click the link below:</p>
   <a href="https://********.blob.core.windows.net/download/openvpn-pfsense-UDP4-1194-install-2.4.6-I602.exe"
      target="_blank" rel="Download VPN client">Download</a>

</body>
</html>
"@)






# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value (@{
    StatusCode = "Ok"
    ContentType = "text/html"
    Body = $HTML.ToString()
})
