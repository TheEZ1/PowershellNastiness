function exportto-azure {

param(
    [Parameter(mandatory=$true)]
    [string]$VM,
    [Parameter(mandatory=$true)]
    $ExternalIP, 
    [Parameter(mandatory=$true)]
    $CompanyInit,
    [Parameter(mandatory=$true)]
    $Credential = (get-credential),
    [Parameter(mandatory=$true)]
    $VIServer,
    $Destination = "C:\Temp"
    )



Connect-VIServer -Server $VIServer -Credential $Credential

Export-VApp -VM $VM -Destination $Destination



function set-storageaccount {

$TerraformRoot = "C:\Users\Harold\Documents\Terraform\Azure\"
$TemplateRoot = "C:\Users\Harold\Documents\Terraform\Azure\Templates"
$TemplateFileList = Get-childitem -Path $TemplateRoot

$CompanyInit = $CompanyInit.ToLower()

$Container = @"

    resource "azurerm_storage_container" "$CompanyInit" {
	name = "$CompanyInit"
	storage_account_name = data.azurerm_storage_account.root_storage_account.name
	container_access_type = "blob"
}
"@

$NetworkRule = @"
    resource "azurerm_storage_account" "root_storage_account" {
	name = "clientoffboard"
	resource_group_name = data.azurerm_resource_group.client_storage_data.name
	location = data.azurerm_resource_group.client_storage_data.location
	account_tier = "Standard"
	account_replication_type = "LRS"
	access_tier = "Hot"

network_rules {
	default_action = "Deny"
	ip_rules = ["$ExternalIP"]
}
}
"@

$CompanyFolder = Test-Path $TerraformRoot\$CompanyInit
$ProviderFile = "$TerraformRoot\Providers.tf"
$ProviderFileTest = Test-Path "$TerraformRoot\$CompanyInit\Providers.tf"
$ProviderFileExists = $false

If (!$CompanyFolder) {
    write-host "Creating folder at $TerraformRoot"
    New-Item -Path $TerraformRoot -ItemType directory -Name $CompanyInit -Force
}

If (!$ProviderFileTest) {
    Copy-Item "$TerraformRoot\Providers.tf" -Destination "$TerraformRoot\$CompanyInit\Providers.tf" -Force
    Foreach ($File in $TemplateFileList) {
        Copy-Item $File.fullname -Destination "$TerraformRoot\$CompanyInit\$($File.name)" -Force
    }
    } else {
    $ProviderFileExists = $true
    }    



Out-File -FilePath $TerraformRoot\$Companyinit\Container.tf -Force
Set-Content -Value $Container -Path "$TerraformRoot\$Companyinit\Container.tf" 

Out-File -FilePath $TerraformRoot\$CompanyInit\NetworkRule.tf -Force
Set-Content -Value $NetworkRule -Path "$TerraformRoot\$Companyinit\NetworkRule.tf"
set-location $TerraformRoot\$CompanyInit

If ($ProviderFileExists) {
terraform plan
} else {
terraform init
terraform plan
}
}
set-storageaccount
}

exportto-azure -VM haproxy-1 -ExternalIP 8.8.8.8 -CompanyInit HHt -VIServer 192.168.1.138 -Credential (get-credential)