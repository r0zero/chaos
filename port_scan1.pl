#!/usr/bin/perl
#use warning;
use Cwd;

$| = 1; #flush the cache
$date=`date +%Y-%m-%d-%H-%M`;
$day=`date +%Y-%m-%d`;
chomp($date);
chomp($day);
#my $port = "21,22,23,25,53,80,111,389,443,465,873,993,995,1000,1521,1723,3306,3389,5989,8000,8001,8009,8010,8080,8081,8088,8443,9900,10621";
my $port = "21,22,23,25,80,81,82,83,84,85,86,87,123,443,873,1521,1357,1723,3306,3389,6379,8000,8001,8009,8010,8080,8081,8088,8443,9900,10050,10051,10621,11211,18001,27017,32453";
my @port = ("21","22","23","25","53","80","81","82","83","84","85","86","87","111","123","389","443","465","873","993","995","1000","1357","1521","1723","3306","3389","5989","8000","8001","8009","8010","8080","8088","8443","9900","10621","10050","10051","10621","18001","27017","32453");

&nmapscan;
&nmaplog;
&package;

#step 1 scan
sub nmapscan () {
        system("nmap -sV -P0 -n -p $port -iL $ipfile -oN $out_scanlog");
}


#step 2 handle log
sub nmaplog () {
        my ($ip,$port);
        open (NMAPLOG,">tmp.log") or die "$!";
        open (NMAP,"<port_scan.log") or die "$!";
        while(<NMAP>){
                if(/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/){
                        $ip=$1;
		}
                elsif(/^(\d+)\/(tcp|udp)\s+open/){
                        $port=$1;
                        print NMAPLOG "$ip:$port\n";
                }
        }
        close(NMAP);
        close(NMAPLOG);
}

#step 3 package
sub package{
        my $port;
        my @portz=("21","22","80","81","85","87","123","3389","873","1723","1521","3306","27017","32453");
        foreach $port (@portz){
                open(F,"<log/allinone.txt");
                open(FF,"> log/${port}.txt");
                while(<F>){
                        if(/^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}):$port/i){
                                print FF "$1\n";
                        }
                }
                close(F);
                close(FF);
        }
}

