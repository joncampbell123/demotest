#!/usr/bin/perl
#
# arg[0] = path 1
# arg[1] = path 2
my $path1 = shift @ARGV;
my $path2 = shift @ARGV;

die unless -d $path1;
die unless -d $path2;

sub getdir($) {
    my $path = shift @_;
    my @x;

    opendir(D,$path) || die;
    @x = readdir(D);
    closedir(D);

    return @x;
}

sub filter($) {
    $x = shift @_;

    return 0 if $x =~ m/^\.*$/;
    return 0 if $x =~ m/^__.*__$/;
    return 0 if $x =~ m/^mapper-.*\.map$/;
    return 0 if $x =~ m/^dosbox.*\.conf$/;
    return 0 if $x =~ m/^file_id\.diz$/i;

    return 1;
}

my @list1 = sort grep { filter($_) } getdir($path1);
my @list2 = sort grep { filter($_) } getdir($path2);

if (@list1 != @list2) {
    print "Not the same amount of files. ".@list1." vs ".@list2."\n";
    exit 1
}

for ($i=0;$i < @list1;$i++) {
    if (lc($list1[$i]) ne lc($list2[$i])) {
        print "Not the same files names. ".$list1[$i]." vs ".$list2[$i]."\n";
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

