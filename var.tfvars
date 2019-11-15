    #Resource Group
rg_name = "AzureWorkshopNEW"



    ### Spoke ###
vnet_spoke_name       = "Mateusz_spoke_vnet"
address_space_spoke   = ["10.110.0.0/16"]
dns_servers_spoke     = ["8.8.8.8"]
subnet1_spoke_name    = "subnet001"
spoke_subnet1_preffix = "10.110.1.0/24"
subnet2_spoke_name    = "subnet002"
spoke_subnet2_preffix = "10.110.2.0/24"


### HUB ###

vnet_hub_name       = "Mateusz_hub_vnet"
address_space_hub   = ["10.120.0.0/16"]
dns_servers_hub     = ["8.8.8.8"]
subnet1_hub_name    = "subnet010"
hub_subnet1_preffix = "10.120.1.0/24"
subnet2_hub_name    = "subnet011"
hub_subnet2_preffix = "10.120.2.0/24"



### NSG ###
/*
vnet_spoke_nsg_name = "spoke_NSG_RDP_allow"
vnet_hub_nsg_name   = "hub_NSG_RDP_allow"

###### GWVPN #####
gwPIP_name           = "workshop_student_GW_PIP"
gwName               = "workshop_student_GWVPN"

##### Local network GW ###
localGW_name         = "LocalGW_VPN"
localGW_address      = "62.62.62.62"
localGW_space        = ["192.168.1.0/24"]
vpnConnection_name   = "VPNConnection_LAB"
vnetName             = "???ET_HUB"
*/

### VM ###
username = "developer"
password = "W@rsztaty20192019"
vm1_name = "labVM1"
vm2_name = "labVM2"
vm3_name = "labVM3"
vm4_name = "labVM4"
