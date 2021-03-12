use Parallel::ForkManager;
$forkNo = 30;
my $pm = Parallel::ForkManager->new("$forkNo");

for (1..41){
    #$pm->start and next;
    $nodeindex=sprintf("%02d",$_);
    $nodename= "node"."$nodeindex";
    #system("ssh $nodename 'dnf install perl-Statistics-Descriptive -y'");
    print "nodename:$nodename\n";
    system("munge -n \| ssh $nodename unmunge");
    if($!){sleep(3);}
    #$pm->finish;
}
#$pm->wait_all_children;
