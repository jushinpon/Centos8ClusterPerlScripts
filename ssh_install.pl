# ssh nodeXXX
#nohup ifdown enp1s0 down && ifup enp1s0 up &

use Parallel::ForkManager;
$forkNo = 30;
my $pm = Parallel::ForkManager->new("$forkNo");
$reboot_check = "yes";

# status check
#for (1..3){
#    $nodeindex=sprintf("%02d",$_);
#    $nodename= "node"."$nodeindex";
#    $cmd = "ssh $nodename ";
#    print "Check $nodename status\n ";
#    system("$cmd 'ibv_devinfo'");    
#}
#die;

for (1..3){
    $pm->start and next;
    $nodeindex=sprintf("%02d",$_);
    $nodename= "node"."$nodeindex";
    $cmd = "ssh $nodename ";
    
    ##infiniband driver, reboot is needed.
    #system("$cmd 'yum install -y libibverbs libibverbs-utils infiniband-diags perftest'");
    system("$cmd 'dnf install -y iftop'");
    #system("$cmd 'poweroff'");
    
    ##perl module
    #system("$cmd 'dnf install perl-Statistics-Descriptive -y'");
    #print "Check $nodename status\n ";
    #system("$cmd 'ibv_devinfo'");    
    $pm->finish;
}
$pm->wait_all_children;

die;
### check the node status after reboot
if($reboot_check eq "yes"){
	print "Sleep awhile (30 sec.) for checking reboot status\n";
	sleep(30); 
	for (1..3){
		$nodeindex=sprintf("%02d",$_);
		$nodename= "node"."$nodeindex";
		system("ping -c 3 $nodename");
		if($?){print "reboot for $nodename hasn't done!!\n\n"}	
	}
}
