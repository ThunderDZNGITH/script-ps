# Récupération du nom de la machine
$ComputerName = (Get-ComputerInfo).CsName

# Configuration de la carte réseau pour le DNS de l'AD
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "192.168.*.*"

# Connexion à l'AD avec compte admin
Add-Computer -DomainName "*.local" -OUPath "OU=*,DC=*,DC=local" -Credential (New-Object System.Management.Automation.PSCredential("*\Administrateur", (ConvertTo-SecureString "*" -AsPlainText -Force)))

# --- AUTO LOG-ON ---

$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

# Création du registre DefaultPassword (Si une erreur ressort, ne pas en prendre compte, c'est que le registre existe déjà
New-ItemProperty -Path $RegistryPath -Name "DefaultPassword"

# Paramétrage de l'auto log-on avec compte du nom de la machine
Set-ItemProperty -Path $RegistryPath -Name "AutoAdminLogon" -Value "1"
Set-ItemProperty -Path $RegistryPath -Name "DefaultUserName" -Value $ComputerName
Set-ItemProperty -Path $RegistryPath -Name "DefaultPassword" -Value "*"
Set-ItemProperty -Path $RegistryPath -Name "DefaultDomainName" -Value "*"

# Redémarrage de la machine
Restart-Computer
