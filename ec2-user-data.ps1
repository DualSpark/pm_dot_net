<powershell>
write-output "Running User Data Script"
write-host "(host) Running User Data Script"

cmd.exe /c net user /add packer FooBar@123
cmd.exe /c net localgroup administrators packer /add

Set-ExecutionPolicy -ExecutionPolicy bypass -Force

# RDP
#cmd.exe /c netsh advfirewall firewall add rule name="Open Port 3389" dir=in action=allow protocol=TCP localport=3389
#cmd.exe /c reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

# WinRM
write-output "Setting up WinRM"
write-host "(host) setting up WinRM"

cmd.exe /c winrm quickconfig -q
cmd.exe /c winrm quickconfig '-transport:http'
cmd.exe /c winrm set "winrm/config" '@{MaxTimeoutms="1800000"}'
cmd.exe /c winrm set "winrm/config/winrs" '@{MaxMemoryPerShellMB="1024"}'
cmd.exe /c winrm set "winrm/config/service" '@{AllowUnencrypted="true"}'
cmd.exe /c winrm set "winrm/config/client" '@{AllowUnencrypted="true"}'
cmd.exe /c winrm set "winrm/config/service/auth" '@{Basic="true"}'
cmd.exe /c winrm set "winrm/config/client/auth" '@{Basic="true"}'
cmd.exe /c winrm set "winrm/config/service/auth" '@{CredSSP="true"}'
cmd.exe /c winrm set "winrm/config/listener?Address=*+Transport=HTTP" '@{Port="5985"}'
cmd.exe /c netsh advfirewall firewall set rule group="remote administration" new enable=yes
cmd.exe /c netsh firewall add portopening TCP 5985 "Port 5985"
cmd.exe /c net stop winrm
cmd.exe /c sc config winrm start= auto
cmd.exe /c net start winrm
cmd.exe /c wmic useraccount where "name='packer'" set PasswordExpires=FALSE

$EC2SettingsFile="C:\Program Files\Amazon\Ec2ConfigService\Settings\Config.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToModify = $xmlElement.Plugins

foreach ($element in $xmlElementToModify.Plugin)
{
    if ($element.name -eq "Ec2SetPassword")
    {
        $element.State="Enabled"
    }
    elseif ($element.name -eq "Ec2HandleUserData")
    {
        $element.State="Enabled"
    }
}
$xml.Save($EC2SettingsFile)

</powershell>