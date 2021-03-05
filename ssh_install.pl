use Parallel::ForkManager;
$forkNo = 30;
my $pm = Parallel::ForkManager->new("$forkNo");

for (1..10){
    $pm->start and next;
    $nodeindex=sprintf("%02d",$_);
    $nodename= "node"."$nodeindex";
    system("ssh $nodename 'dnf install perl-Statistics-Descriptive -y'");
    $pm->finish;
}
$pm->wait_all_children;
