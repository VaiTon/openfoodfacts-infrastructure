#!/usr/bin/perl -w

my %ip = ();

while (<STDIN>)
{
        if ($_ =~ /(^\S+)\.\d+ /)
                     {
                                                     $ip{$1}++;
                                                                                             }
                                                                                                                                     }
                                                                                                                                     my $total = 0;
                                                                                                                                                                             foreach my $ip (sort { $ip{$a} <=> $ip{$b}} keys %ip)
                                                                                                                                                                                                                     {
                                                                                                                                                                                                                                                                     print "$ip\t$ip{$ip}\n";
                                                                                                                                                                                                                                                                     						$total += $ip{$ip};
                                                                                                                                                                                                                                                                     						                                                }


                                                                                                                                                                                                                                                                     						                                                						    print "total: $total\n";
                                                                                                                                                                                                                                                                     						                                                						    						    								     print "ips: " . (scalar keys %ip) . "\n";

