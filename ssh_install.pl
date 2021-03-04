for (1..2){
    $nodeindex=sprintf("%02d",$_);
    $nodename= "node"."$nodeindex";
    system("ssh $nodename 'shutdown -h now'");

}
