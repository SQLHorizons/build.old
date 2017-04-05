# Build
SQL Server setup functions and scripts

```powershell
$Account = Get-ADUser -Filter "Name -like `"SA-$($Server.Replace('-',''))-SQLServer`""
```
