<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    New User Creation
#>

function CheckIfComplete {

    CODE HERE TO CHECK FOR COMPLETENESS

    }

function CreateUser {

    $Params = @{
        Name = "$(($TextBox1.Text + ' ' + $TextBox2.Text).Trim())"
        GivenName = "$(($TextBox1.Text).Trim())"
        SurName = "$(($TextBox2.Text).Trim())"
        SamAccountName = "$(($TextBox1.Text + '.' + $TextBox2.Text).Trim())"
        DisplayName = ($TextBox1.Text + ' ' + $TextBox2.Text).Trim()
        AccountPassword = (ConvertTo-SecureString "Haven123" -AsPlainText -Force)
        UserPrincipalName = ($TextBox1.Text + '.' + $TextBox2.Text).Trim() + '@' + $env:USERDNSDOMAIN
        ChangePasswordAtLogon = $true
        Enabled = $true
        }

    write-host "Username-----$($Params['Name'])"
    write-host "First Name-----$($Params['GivenName'])"
    write-host "Last Name-----$($Params['SurName'])"
    write-host "SamAccountName-----$($Params['SamAccountName'])"
    write-host "Display Name-----$($Params['DisplayName'])"
    write-host "UPN-----$($Params['UserPrincipalName'])"
    New-ADUser @Params
    } 


Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Path = ".\Documents\computerinfo.csv"
$LocationList = import-csv $Path | select -ExpandProperty Computername
$JobRoles = import-csv $Path | select -ExpandProperty Manufacturer


$HavenNewUserCreation            = New-Object system.Windows.Forms.Form
$HavenNewUserCreation.ClientSize  = '812,671'
$HavenNewUserCreation.text       = "Haven New User Creation"
$HavenNewUserCreation.TopMost    = $false
$HavenNewUserCreation.AutoSize = $true



$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 193
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(22,72)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'

$FirstName                       = New-Object system.Windows.Forms.Label
$FirstName.text                  = "First Name"
$FirstName.AutoSize              = $true
$FirstName.width                 = 25
$FirstName.height                = 10
$FirstName.location              = New-Object System.Drawing.Point(27,36)
$FirstName.Font                  = 'Microsoft Sans Serif,10'

$TextBox2                        = New-Object system.Windows.Forms.TextBox
$TextBox2.multiline              = $false
$TextBox2.width                  = 204
$TextBox2.height                 = 20
$TextBox2.location               = New-Object System.Drawing.Point(294,72)
$TextBox2.Font                   = 'Microsoft Sans Serif,10'

$Requester                       = New-Object system.Windows.Forms.TextBox
$Requester.multiline             = $false
$Requester.text                  = "Requester"
$Requester.width                 = 423
$Requester.height                = 20
$Requester.location              = New-Object System.Drawing.Point(27,250)
$Requester.Font                  = 'Microsoft Sans Serif,10'

$LastName                        = New-Object system.Windows.Forms.Label
$LastName.text                   = "Last Name"
$LastName.AutoSize               = $true
$LastName.width                  = 25
$LastName.height                 = 10
$LastName.location               = New-Object System.Drawing.Point(305,36)
$LastName.Font                   = 'Microsoft Sans Serif,10'

$userlocation                    = New-Object system.Windows.Forms.ComboBox
$userlocation.text               = "UserLocation"
$userlocation.width              = 420
$userlocation.height             = 179
$userlocation.location           = New-Object System.Drawing.Point(27,150)
$userlocation.Font               = 'Microsoft Sans Serif,10'
$userlocation.Items.AddRange($LocationList)

$UserJobRole                     = New-Object system.Windows.Forms.ComboBox
$UserJobRole.text                = "UserJobRole"
$UserJobRole.width               = 423
$UserJobRole.height              = 20
$UserJobRole.location            = New-Object System.Drawing.Point(27,200)
$UserJobRole.Font                = 'Microsoft Sans Serif,10'
$userJobRole.Items.AddRange($JobRoles)

$UserWarning1                    = New-Object system.Windows.Forms.Label
$UserWarning1.text               = "New users are to ONLY come from Haven HR Directors or the CEO.  "
$UserWarning1.BackColor          = "#000000"
$UserWarning1.AutoSize           = $true
$UserWarning1.width              = 25
$UserWarning1.height             = 10
$UserWarning1.location           = New-Object System.Drawing.Point(22,386)
$UserWarning1.Font               = 'Microsoft Sans Serif,15'
$UserWarning1.ForeColor          = "#F8E71C"

$UserWarning2                    = New-Object system.Windows.Forms.Label
$UserWarning2.text               = "If not, inform requestor to reach out to their location-specific Haven HR Directors"
$UserWarning2.BackColor          = "#000000"
$UserWarning2.AutoSize           = $true
$UserWarning2.width              = 25
$UserWarning2.height             = 10
$UserWarning2.location           = New-Object System.Drawing.Point(22,421)
$UserWarning2.Font               = 'Microsoft Sans Serif,15'
$UserWarning2.ForeColor          = "#F8E71C"

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Submit"
$Button1.width                   = 146
$Button1.height                  = 43
$Button1.location                = New-Object System.Drawing.Point(584,599)
$Button1.Font                    = 'Microsoft Sans Serif,10'

$Button2                         = New-Object system.Windows.Forms.Button
$Button2.text                    = "Cancel"
$Button2.width                   = 146
$Button2.height                  = 43
$Button2.location                = New-Object System.Drawing.Point(432,599)
$Button2.Font                    = 'Microsoft Sans Serif,10'

$Selections = @($TextBox1,$FirstName,$TextBox2,$LastName,$userlocation,$UserJobRole,$Button1,$Button2,$UserWarning1,$UserWarning2,$Requester)

$HavenNewUserCreation.controls.AddRange($Selections)

$UserJobRole.Add_ControlAdded({  })
$Button1.Add_Click({ CreateUser })
$Button2.Add_Click({ $HavenNewUserCreation.Close() })

$HavenNewUserCreation.ShowDialog()
