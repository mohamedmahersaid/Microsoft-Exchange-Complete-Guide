
# Configure all Exchange virtual directories in one go

$Server = "EX01"
$External = "https://mail.domain.com"
$Internal = "https://mail.domain.local"

Set-OwaVirtualDirectory -Identity "$Server\owa (Default Web Site)" -ExternalUrl "$External/owa" -InternalUrl "$Internal/owa"
Set-EcpVirtualDirectory -Identity "$Server\ecp (Default Web Site)" -ExternalUrl "$External/ecp" -InternalUrl "$Internal/ecp"
Set-WebServicesVirtualDirectory -Identity "$Server\EWS (Default Web Site)" -ExternalUrl "$External/ews/exchange.asmx" -InternalUrl "$Internal/ews/exchange.asmx"
Set-ActiveSyncVirtualDirectory -Identity "$Server\Microsoft-Server-ActiveSync (Default Web Site)" -ExternalUrl "$External/Microsoft-Server-ActiveSync" -InternalUrl "$Internal/Microsoft-Server-ActiveSync"
Set-OabVirtualDirectory -Identity "$Server\OAB (Default Web Site)" -ExternalUrl "$External/OAB" -InternalUrl "$Internal/OAB"
Set-OutlookAnywhere -Identity "$Server\Rpc (Default Web Site)" -ExternalHostname "mail.domain.com" -InternalHostname "mail.domain.local" -ExternalClientsRequireSsl $true -InternalClientsRequireSsl $true -DefaultAuthenticationMethod NTLM
