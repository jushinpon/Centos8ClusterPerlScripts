=beg
This Perl script uses the Expect module to scp all required Perl scripts from server to each node after you assign the private IP
for all nodes. We put all scripts in the directory "ForNode".-- developed by Prof. Shin-Pon Ju at NSYSU (11/28/2019)

./Server/Server_setting.dat should be copied to each node for the following setting. (scp..) 
Nodes_IP.dat: from 00initial_interfacesSetting.pl
=cut
#!/usr/bin/perl
use strict;
use warnings;
use Expect;
use Cwd; #Find Current Path
use Parallel::ForkManager;
use MCE::Shared;
#****$jobtype = "nohup" or "copy"
my $jobtype = "nohup";# nohup perl for node scripts, otherwise copy files only

# "ssh nodeXX 'ls /root/*.pl'` to check whether scp works, currently 9 files
tie my @scpFailnodes, 'MCE::Shared';
tie my %scpstatus, 'MCE::Shared';# good, or failed
my $current_path = getcwd();# get the current path dir

#print "****current_path: $current_path $current_path1\n";
#sleep(100);
$current_path =~ s/\/Server//;# get the path for node scripts (ForNode)

my $expectT = 30;# time peroid for expect

$ENV{TERM} = "vt100";
my $pass = "123"; ##For all roots of nodes

open my $ss,"< ./Nodes_IP.dat" or die "No Nodes_IP.dat to read"; 
my @temp_array=<$ss>;
my @avaIP=grep (($_!~m{^\s*$|^#}),@temp_array); # remove blank lines and comment lines
close $ss; 
for (@avaIP){
	$_  =~ s/^\s+|\s+$//;
	chomp;
	print "IP: $_\n";
}

my $forkNo = @avaIP;
print "forkNo: $forkNo\n";
#my $forkNo = 30;
my $pm = Parallel::ForkManager->new("$forkNo");

for (@avaIP){	
   sleep(3);
	$pm->start and next;
	$_ =~/192.168.0.(\d{1,3})/;#192.168.0.X
	my $temp= $1 - 1;
    my $nodeindex=sprintf("%02d",$temp);
    my $nodename= "node"."$nodeindex";
    chomp $nodename;
    unlink "/home/$nodename.txt";
    
    print "**nodename**:$nodename\n";
    system("ssh $nodename \'rm -rf /root/*.pl\'");
 if ($?){print "BAD: ssh $nodename \'rm -f /root/*.pl\' failed\n";};    
    system("ssh $nodename \'rm -rf /root/*.txt\'");
 if ($?){print "BAD: ssh $nodename \'rm -rf /root/*.txt\' failed\n";};    
    sleep(1);
    system("scp  $current_path/ForNode/* root\@$nodename:/root");
 if ($?){print "BAD: scp  $current_path/ForNode/* root\@$nodename:/root failed\n";};    
    sleep(1);	
    system("scp  $current_path/Server/Server_setting.dat root\@$nodename:/root");
 if ($?){print "BAD: scp  /Server/Server_setting.dat root\@$nodename:/root failed\n";};    
my @ls = `ssh $nodename 'ls /root/{*.pl,Server_setting.dat}'`;
#for (@ls) {chomp;print "ls: $_ \n";}
my $lsno = @ls;
chomp $lsno;
