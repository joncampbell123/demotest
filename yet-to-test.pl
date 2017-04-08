#!/usr/bin/perl
my $skip = '';
open(X,"find -type d |") || die;
while (my $path = <X>) {
    chomp $path;
    next unless -d $path;
    next if $path =~ m/\'/;
    next if ($skip ne '' && (substr($path,0,length($skip)) eq $skip));

    # skip if it already has __PASS__ or __FAIL__
    next if ( -f "$path/__PASS__" || -f "$path/__FAIL__" );

    # skip unless it has an EXE or COM file
    $x=`cd '$path' && ls *.EXE *.COM 2>/dev/null | head -n 1`; chomp $x;
    next if $x eq "";

    print "$path\n";

    $skip = $path;
}
close(X);

