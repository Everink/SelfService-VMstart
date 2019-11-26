using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."


$VM = Get-AzVM -Name "pfsense"
$StartRtn = $VM | Start-AzVM -NoWait -ErrorAction Continue


$HTML = New-Object -TypeName "System.Text.StringBuilder"
[void]$HTML.AppendLine( @"
<!DOCTYPE html>
<html>
<head>
   <title>Start VM status</title>
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

Result from starting the VM is: <br/>
<table>
<tr><td><b>IsSuccessStatusCode</b></td><td>$($StartRtn.IsSuccessStatusCode)</td></tr>
<tr><td><b>StatusCode</b></td><td>$($StartRtn.StatusCode)</td></tr>
<tr><td><b>ReasonPhrase</b></td><td>$($StartRtn.ReasonPhrase)</td></tr>
</table>
<br/>
<br/>

</body>
</html>
"@)


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value (@{
    StatusCode = "Ok"
    ContentType = "text/html"
    Body = $HTML.ToString()
})
