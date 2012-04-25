#!/usr/bin/perl

require "ec2ops.pl";

my $account = shift @ARGV || "eucalyptus";
my $user = shift @ARGV || "admin";

# need to add randomness, for now, until account/user group/keypair
# conflicts are resolved

$rando = int(rand(10)) . int(rand(10)) . int(rand(10));
if ($account ne "eucalyptus") {
    $account .= "$rando";
}
if ($user ne "admin") {
    $user .= "$rando";
}
$newgroup = "ec2opsgroup$rando";
$newkeyp = "ec2opskey$rando";

parse_input();
print "SUCCESS: parsed input\n";

setlibsleep(2);
print "SUCCESS: set sleep time for each lib call\n";

setremote($masters{"CLC"});
print "SUCCESS: set remote host: $masters{CLC}\n";

get_credentials();
print "SUCCESS: got credentials\n";

source_credentials();
print "SUCCESS: sourced credentials\n";

transfer_credentials($masters{"CLC"}, $masters{"NC00"});
print "SUCCESS: transferred credentials from $masters{CLC} to $masters{NC00}\n";

setremote($masters{"NC00"});
print "SUCCESS: set remote host: $masters{NC00}\n";

source_credentials();
print "SUCCESS: sourced credentials\n";

use_euca2ools();
print "SUCCESS: will be using euca2ools from now on\n";

discover_emis();
print "SUCCESS: discovered loaded image: current=$current_artifacts{instancestoreemi}, all=$static_artifacts{instancestoreemis}\n";

discover_zones();
print "SUCCESS: discovered available zone: current=$current_artifacts{availabilityzone}, all=$static_artifacts{availabilityzones}\n";

run_ec2_describes();
print "SUCCESS: ran all ec2 describes\n";

#run_walrus_upload();
#print "SUCCESS: uploaded test object to walrus\n";

doexit(0, "EXITING SUCCESS\n");
