#!/usr/bin/perl
#
# arg[0] = path 1
# arg[1] = path 2
my $path1 = shift @ARGV;
my $path2 = shift @ARGV;

die unless -d $path1;
die unless -d $path2;

$x1 = `realpath -- $path1`;
$x2 = `realpath -- $path2`;
if ($x1 eq $x2) {
    print "Already the same\n";
    exit 1
}

sub getdir($) {
    my $path = shift @_;
    my @x;

    opendir(D,$path) || die;
    @x = readdir(D);
    closedir(D);

    return @x;
}

sub lcsort($$) {
    $a = shift @_;
    $b = shift @_;
    return lc($a) cmp lc($b);
}

sub filter($$) {
    $x = shift @_;
    $path = shift @_;

    return 0 if $x =~ m/^\.*$/;
    return 0 if $x =~ m/^__.*__$/;
    return 0 if $x =~ m/^mapper-.*\.map$/;
    return 0 if $x =~ m/^dosbox.*\.conf$/;
    return 0 if $x =~ m/^file_id\.diz$/i;
    return 0 if $x =~ m/^hdd$/;
    return 0 if $x =~ m/^__.*__\.sh$/;
    return 0 if $x =~ m/^_download_\.zip$/;
    return 0 if $x =~ m/^scene\.org\.txt$/i;
    return 0 if $x =~ m/^scene\.org$/i;
    return 0 if $x =~ m/^qemu\.conf$/i;
    return 0 if $x =~ m/^bochsrc$/;

    # "This file has been at so and so BBS" add-ons to ignore
    return 0 if $x =~ m/^demosite\.com$/i && -s "$path/$x" == 1104;
    return 0 if $x =~ m/^STARPRT2\.EXE$/i && -s "$path/$x" == 6400;

    return 1;
}

my @list1 = sort { lcsort($a,$b) } grep { filter($_,$path1) } getdir($path1);
my @list2 = sort { lcsort($a,$b) } grep { filter($_,$path2) } getdir($path2);

exit 1 if @list1 == 0;
exit 1 if @list2 == 0;

if (@list1 != @list2) {
    print "Not the same amount of files. ".@list1." vs ".@list2."\n";
    for ($j=0;$j < @list1;$j++) {
        print "  List[$j] = ".$list1[$j]." vs ".$list2[$j]."\n";
    }
    exit 1
}

for ($i=0;$i < @list1;$i++) {
    if (lc($list1[$i]) ne lc($list2[$i])) {
        print "Not the same files names. ".$list1[$i]." vs ".$list2[$i]."\n";
        for ($j=0;$j < @list1;$j++) {
            print "  List[$j] = ".$list1[$j]." vs ".$list2[$j]."\n";
        }
        exit 1
    }
}

for ($i=0;$i < @list1;$i++) {
    $fp1 = $path1."/".$list1[$i];
    $fp2 = $path2."/".$list2[$i];

    die unless -e $fp1;
    die unless -e $fp2;

    next unless -f $fp1;
    die unless -f $fp2;

    $sz1 = -s $fp1;
    $sz2 = -s $fp2;

    if ($sz1 != $sz2) {
        print "File size mismatch:\n";
        print "    ".$list1[$i]." ".$sz1."\n";
        print "    ".$list2[$i]." ".$sz2."\n";
        exit 1
    }
}

for ($i=0;$i < @list1;$i++) {
    $fp1 = $path1."/".$list1[$i];
    $fp2 = $path2."/".$list2[$i];

    $x = system("/usr/bin/cmp","-b","--",$fp1,$fp2);
    if ($x != 0) {
        print "File content mismatch for ".$list1[$i]."\n";
        exit 1
    }
}

exit 0

