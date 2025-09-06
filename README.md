# IP Finder

A professional Bash utility to calculate **network information** and perform **subnetting**.

## ✨ Features
- Network ID
- Broadcast Address
- First & Last Usable IP
- Host Count
- Subnetting with full subnet table

## 📦 Usage
```bash
./ip_finder.sh
#Install on RedHat/CentOS/Fedora:
sudo yum install ipcalc -y



$ ./ip_finder.sh
Enter IP address with CIDR (e.g., 192.168.1.10/24): 192.168.1.10/24
Enter number of subnets you want: 4
============================================================
                 IP Information Finder
============================================================
 Input IP       : 192.168.1.10/24
 Network ID     : 192.168.1.0/24
 Broadcast ID   : 192.168.1.255
 First Usable   : 192.168.1.1
 Last Usable    : 192.168.1.254
 Total Hosts    : 254
------------------------------------------------------------
 Subnetting
 Requested Subs : 4
 New CIDR       : /26
 Hosts/Subnet   : 62
============================================================
 Listing 4 Subnets
============================================================
Network            Broadcast          First Host         Last Host          Hosts     
---------------------------------------------------------------------------------------------------
192.168.1.0/26     192.168.1.63       192.168.1.1        192.168.1.62       62        
192.168.1.64/26    192.168.1.127      192.168.1.65       192.168.1.126      62        
192.168.1.128/26   192.168.1.191      192.168.1.129      192.168.1.190      62        
192.168.1.192/26   192.168.1.255      192.168.1.193      192.168.1.254      62        
============================================================
 Author : Pankaj A
 GitHub : https://github.com/Battleking-cyber
============================================================
