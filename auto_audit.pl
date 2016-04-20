#!/usr/bin/perl -w
use DBI;
use strict;
use LWP::UserAgent;
use HTTP::Cookies;
use HTTP::Response;

my $url = 'https://www.baidu.com/login.php';
my $cookie = 'cookie.txt';
my $cap_file = 'auth.csv';
my ($sec,$min,$hour,$mday,$mon,$year) = (localtime);
my $day = sprintf("%d", $mday);
my $mon = sprintf("%d", $mon + 1),
my $y = $year + 1900;

my %login = (
    'login' => '',
	'password' => '',
	'locale' => 'zh_CN.UTF-8',
     );

my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 0 });
$ua->timeout('30');
$ua->env_proxy;
$ua->agent("Mozilla/5.0 (Windows NT 5.1; rv:6.0.1) Gecko/20100101 Firefox/6.0.1");
$ua->cookie_jar(HTTP::Cookies->new(file =>$cookie,ignore_discard =>1,autosave =>1));

#login
my $respone = $ua->post($url,\%login);
if ($respone->is_redirect) {
	 $respone .= "sucefully"."\n";
         #print $respone;
}        else    {
	 die $respone->status_line;
}

my $main = $ua->post("https://www.baidu.com/audit/data_provider.php?ds_y=2013&ds_m=$mon&ds_d=$day&identity=0&server=0&server_cond=&query_type=tui&format=csv_all",\%login);
if ($main->is_success) {
        open (FF,"+>>$cap_file") or die "$!";
        print FF $main->content;
        if (-e $cap_file) {
             $main .= "Sucefully";
}	else	{
	 die $respone->as_string;
   }
}

open CSV,"<auth.csv" or die "$!";
open save,">linux.log" or die "$!";
while (<CSV>) {
     #chomp();
     my @list = split /,/,$_;
     print save for(@list[3])."\t";
     print save for(@list[5])."\t\t\t";
     print save for(@list[6])."\n";
#    #print for(@list[8])."\n";
}
system("sed \-i \-e \"1d\" linux.log");
#system("echo \"注:文件内容分别为：登录时间、登录ip、登录ip,建议附件方式查看,谢谢。\n\" >>linux_auth.log");
system("cat linux.log | sort -n | uniq | awk -F\'\/t\/t\' \'{print \$1\,\$2\,\$3,\$4}\' | sort -n >>linux_auth.log");
#clean all
close(CSV);
close(save);
