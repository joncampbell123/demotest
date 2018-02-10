#!/usr/bin/perl
my $skip = '';
my $writecache=0;

if ( -f "pick-one.cache" ) {
    $writecache=0;
    open(X,"<","pick-one.cache") || die;
}
else {
    $writecache=1;
    open(X,"find -type d | sort |") || die;
    open(C,">","pick-one.cache") || die;
}

while (my $path = <X>) {
    chomp $path;
    next unless -d $path;
    next if $path =~ m/\'/;
    next if ($skip ne '' && (substr($path,0,length($skip)) eq $skip));

    # TEMP: we only want 1995 and earlier demos
    next unless ($path =~ m/\/199[0-5]\// || $path =~ m/\/198[0-9]\//);

    # skip Amiga demos, we can't run them
    next if $path =~ m/\/amiga\/demo\//;

    # skip if it already has __PASS__ or __FAIL__
    # 2018/02/09: we now require PASS/FAIL to indicate the commit!
    next if (
        ( -f "$path/__PASS__" && ( -s "$path/__PASS__") > 4) ||
        ( -f "$path/__FAIL__" && ( -s "$path/__FAIL__") > 4)
    );

    # skip unless it has an EXE or COM file
    $x=`cd '$path' && ls *.exe *.EXE *.com *.COM 2>/dev/null | head -n 1`; chomp $x;
    next if $x eq "";

    print "$path\n";
    print C "$path\n" if $writecache > 0;

    $skip = $path;
}
close(C) if $writecache > 0;
close(X);

