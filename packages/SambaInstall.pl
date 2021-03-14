system ("systemctl stop smb");
system("yum install samba -y");
system("firewall-cmd --zone=external --add-port=139/tcp --permanent"); # for samba
system ("firewall-cmd --reload"); #reload

$ConfPath = '/etc/samba/smb.conf';
system("rm $ConfPath");
system("touch $ConfPath");

$filename = 'jsp_only';
$filepath = '/home/jsp';
$description = 'Shared'; 
$browseable = 'yes';
$readonly = 'yes';
$Authority = '755';
$UserList = 'jsp';
#$hostallow = '140.117.59.184'; #maybe u don't need this because u have firewall,right?
@UserList = ("jsp");

`echo "\n\[$filename\]" >> $ConfPath`;
`echo "	comment = $description" >> $ConfPath`;
`echo "	path = $filepath" >> $ConfPath`;
`echo "	browseable = $browseable" >> $ConfPath`;
`echo "	writable = $browseable" >> $ConfPath`;
`echo "	create mask = $Authority" >> $ConfPath`;
`echo "	directory mask = $Authority" >> $ConfPath`;
`echo "	valid users = $UserList" >> $ConfPath`;
`echo "	read only = Yes" >> $ConfPath`;

foreach (@UserList)
	{
		system ("echo '123'|pdbedit -a -u $_"); #you need to set passwd for samba by hand 
	}

`echo '
	[global]
	workgroup = SAMBA
	netbios name = SAMBA_NETBIOS
	server string = SAMBA SERVER	 
	security = user' >> $ConfPath
	`;
system("echo -e '\n'| testparm > smbCheck.txt");#for test the install process done or not 
system ("systemctl start smb");
system ("systemctl enable smb");
system ("setsebool -P samba_enable_home_dirs on");
