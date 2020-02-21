#Requires -version 5.1 -RunAsAdministrator
'Requires version 5.1'

 

 

### This function must have the MSOnline module installed
function get-EOuseraliases {

 

#################################################
#Requirement check, must have WMF 5.1 and MSOnline
#module installed
#
#################################################

 

    $MSOlTest = get-installedmodule -Name MSOnline -MinimumVersion 1.1.183.57 -ErrorAction SilentlyContinue
    $EOTest = get-installedmodule -Name ExchangeOnlineShell -MinimumVersion 2.0.3.3 -ErrorAction SilentlyContinue

 


    If ($MSOlTest) {
        Write-host -ForegroundColor Green "MSOnline module detected, beginning user capture..."
        } else {
        write-host -ForegroundColor Yellow "Module not detected, attempting install now..."
        Install-module -Name MSOnline -MinimumVersion 1.1.183.57 -ErrorAction SilentlyContinue -ErrorVariable FailedInstall
        If ($FailedInstall) {
            Write-host -ForegroundColor Red "MSOnline installation failed.  Please install the module manually and try again" 
            break
            }
        }
    

 

    If ($EOTest) {
        Write-host -ForegroundColor Green "ExchangeOnline module detected, beginning user capture..."
        } else {
        write-host -ForegroundColor Yellow "Module not detected, attempting install now..."
        Install-module -Name ExchangeOnlineShell -MinimumVersion 2.0.3.3 -ErrorAction SilentlyContinue -ErrorVariable EOFailedInstall
        If ($EOFailedInstall) {
            Write-host -ForegroundColor Red "ExchangeOnlineShell installation failed.  Please install the module manually and try again" 
            break
            }
        }
    
    #############################################################
    #Collects the Credential and connects the msolservice to 
    #pull the list of mailboxes.
    #
    #############################################################
    Import-Module MSOnline
    Import-Module ExchangeOnlineShell

 


    Write-Host "Please enter the username and password for the MSOL account" -ForegroundColor Green
    $CredGood = $false
    Do {
        Try {
            $Credential = (get-credential)

 

            Connect-MsolService -Credential $Credential -ErrorAction Stop
            Connect-EOShell -Credential $Credential -ErrorAction Stop
            $CredGood = $True
                } catch {
                        $CredGood = $false
                        Write-host -ForegroundColor Red "The login failed.  Please rerun the username and password"
                        
            }
        }
                While ($CredGood = $false)

 


    

 

    $Users = Get-Mailbox

 

    $UserList = Foreach ($User in $Users) {
        [PSCustomObject]@{
            PrimaryAddress = $User.PrimarySmtpAddress
            EmailAddresses = $User.emailaddresses
            WindowsEmail = $User.WindowsEmailAddress
            Aliases = $User.Alias
            UPN = $User.UserPrincipalName
            }

 

}
$UserList
}

 


function get-OnPremUserAlias {
    
    $Users = get-aduser -filter * -Properties *

 

    $UserList = Foreach ($User in $Users) {
        [PSCustomObject]@{
            UPN = $User.UserPrincipalName
            SamName = $User.SamAccountName
            ADEmail = $User.EmailAddress
            Enabled = $User.Enabled
            LastLogon = $User.LastLogonDate
            }
        }
        $UserList
    }

 


$MsolList = get-EOuseraliases
$OnPremList = get-OnPremUserAlias

 

$Samelist = @()
$Slackers = @()

 

    Foreach ($Mailbox in $MsolList) {
    If ($OnPremList.SamName -contains $Mailbox.Aliases) {
        write-host $Mailbox.Aliases
        $Samelist += $Mailbox
        } else {
            $Slackers += $Mailbox
       }
      } 
