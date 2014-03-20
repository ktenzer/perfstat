#!/usr/local/ActivePerl-5.8/bin/perl -w

use lib "/perfstat/build/1.52/server/lib";
use User;
use GroupPolicy;
use Storable qw(store retrieve);


$userObject1 = User->new(	name		=> "perfstat",
									password 	=> "password",
									creator		=> "perfstat",
									role		=>	"admin",
									navBarWidth 	=> 180, #in pixels
									showAllHosts 	=> 1); #in pixels
store($userObject1, "perfstat.ser") || die("can't store userObject in perfstat.ser\n");
$userObject2 = retrieve("perfstat.ser");
print("Name: " . $userObject2->getName() . "\n");
print("Password: " . $userObject2->getPassword() . "\n");
print("Creator: " . $userObject2->getCreator() . "\n");
print("Role: " . $userObject2->getRole() . "\n");
print("navBarWidth: " . $userObject2->getNavBarWidth() . "\n");
print("showAllHosts: " . $userObject2->getShowAllHosts() . "\n");

$groupPolicy1 = GroupPolicy->new(	hostLimit		=> 50,
												timeoutInterval		=> 80, #in minutes
												statusRefreshInterval		=>	5); #in minutes
store($groupPolicy1, "groupPolicy.ser") || die("can't store groupPolicyObject in groupPolicy.ser\n");
$groupPolicy2 = retrieve("groupPolicy.ser");
print("hostLimit: " . $groupPolicy2->getHostLimit() . "\n");
print("timeoutInterval: " . $groupPolicy2->getTimeoutInterval() . "\n");
print("statusRefreshInterval: " . $groupPolicy2->getStatusRefreshInterval() . "\n");


my $admin2User = {};
$admin2User->{"perfstat"}->{"perfstat"} = 0;
store($admin2User, "admin2User.ser") || die("can't store $admin2User in admin2User.ser\n");

my $admin2Host = {};
store($admin2Host, "admin2Host.ser") || die("can't store $admin2User in admin2Host.ser\n");

my $user2Report = {};
store($user2Report, "user2Report.ser") || die("can't store $user2Report in user2Report.ser\n");

my $user2HostGroup = {};
store($user2HostGroup, "user2HostGroup.ser") || die("can't store $user2HostGroup in user2HostGroup.ser\n");

my $host2HostGroup = {};
store($host2HostGroup, "host2HostGroup.ser") || die("can't store $host2HostGroup in host2HostGroup.ser\n");
