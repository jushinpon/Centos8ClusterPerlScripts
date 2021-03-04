for (2..9){
    $nodeindex=sprintf("%02d",$_);
    $nodename= "node"."$nodeindex";
    system("ssh $nodename 'yum install -y perl-Statistics-Descriptive'");

}
