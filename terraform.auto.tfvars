location = "eastus2"
data_storagetype = "StandardSSD_LRS"
vm_sku_2cpu = "Standard_D2s_v5"
vm_sku_2cpuv4 = "Standard_D2s_v4"
vm_sku_4cpu = "Standard_D4s_v5"
vm_sku_4cpuv4 = "Standard_D4s_v4"

main_vnet_name = "Epic-Internal-VNET"
main_vnet_rg = "Epic-Internal"

epic_mgmt_subnet       = ["10.195.112.16/28"]
azurefirewall_subnet   = ["10.195.112.64/26"]
wss_subnet             = ["10.195.113.0/24"]
hsw_subnet             = ["10.195.114.0/24"]
cogito_subnet          = ["10.195.116.0/24"]
hyperspace_subnet      = ["10.195.117.0/24"]
dmz_subnet             = ["10.195.120.0/24"]
	
domain_name = "lcmchealth.org"
domain_OU = "OU=Azure,OU=EPIC Servers,OU=EPIC Infrastructure,DC=lcmchealth,DC=org"

dmzfirewall_name = "FW-LCMC-Epic"
trafficmanager_name = "lcmchealth-mychart"

automation_acctname = "Epic-Automation"
logws_name = "Epic-LogAnalyticsWS"

vm_count = {
	"bca" = 0
	"bcaw" = 0
	"ce" = 0
	"cerp" = 0
	"citrixcc" = 2	
	"citrixsf" = 2
	"dss" = 0
	"eclink" = 0
	"eps" = 1
	"fax" = 0
	"hsw" = 2
	"icbg" = 2
	"icfg" = 2
	"ivr" = 0
	"kpr" = 1
	"myc" = 2
	"sp" = 1
	"wbs" = 2
	"ww" = 0
	"sql" = 1
}

bca_ip_address = ["10.195.113.30","10.195.113.31"]
bca_epicappname = "BCA"

bcaw_ip_address = ["10.195.113.32"]
bcaw_epicappname = "BCAW"

ce_ip_address = ["10.195.113.7","10.195.113.8"]
ce_epicappname = "CE"

cerp_ip_address = ["10.195.113.9","10.195.113.10"]
cerp_epicappname = "CERP"

citrixcc_ip_address = ["10.195.112.20","10.195.112.21"]
citrixcc_epicappname = "CC"

citrixsf_ip_address = ["10.195.112.27","10.195.112.28"]
citrixsf_epicappname = "SF"

dss_ip_address = ["10.195.113.11","10.195.113.12"]
dss_epicappname = "DSS"

eclink_ip_address = ["10.195.113.13","10.195.113.14"]
eclink_epicappname = "ECL"

eps_ip_address = ["10.195.113.15","10.195.113.16"]
eps_epicappname = "EPS"

fax_ip_address = ["10.195.113.17","10.195.113.18"]
fax_epicappname = "FAX"

hsw_ip_address = ["10.195.114.4","10.195.114.5","10.195.114.6","10.195.114.7"]
hsw_epicappname = "HSW"

icbg_ip_address = ["10.195.113.19","10.195.113.20"]
icbg_epicappname = "ICBG"

icfg_ip_address = ["10.195.113.21","10.195.113.22"]
icfg_epicappname = "ICFG"

ivr_ip_address = ["10.195.113.23"]
ivr_epicappname = "IVR"

kpr_ip_address  = ["10.195.112.23"]
kpr_epicappname = "KPR"

myc_ip_address  = ["10.195.113.24", "10.195.113.25"]
myc_epicappname = "MYC"

sp_ip_address  = ["10.195.112.24"]
sp_epicappname = "SP"

wbs_ip_address = ["10.195.113.26","10.195.113.27"]
wbs_epicappname = "WBS"
wbs_storagename = "lcmcwbsstorage"

ww_ip_address = ["10.195.113.28","10.195.113.29"]
ww_epicappname = "WW"

sql_ip_address  = ["10.195.112.25"]
sql_epicappname = "SQL"
sql_datapath    = "F:\\Data"
sql_logpath     = "G:\\Log"
sql_temppath    = "H:\\tempDB"

shutdown = "true"
timezone = "Central Standard Time"


