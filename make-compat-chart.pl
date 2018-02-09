#!/usr/bin/perl
my $line;

open(H,">compat-chart.html") || die;

print H "<html>\n";
print H "<head>\n";
print H "<title>Demoscene compat testing chart</title>\n";
print H "<style>\n";
print H ".passfail_PASS { background-color: #7FFF7F; text-align: center; vertical-align: top; }\n";
print H ".passfail_FAIL { background-color: #FF7F7F; text-align: center; vertical-align: top; }\n";
print H ".passfail_NA { background-color: #DFDFDF; text-align: center; vertical-align: top; }\n";
print H ".testing_header { background-color: #BFBFBF; }\n";
print H "pre { padding: 0px; margin: 0px; }\n";
print H "</style>\n";
print H "</head>\n";
print H "<body>\n";

print H "DOSBox demoscene compat testing chart<br>\n";
print H "Ref: <a href=\"ftp://ftp.scene.org\">ftp://ftp.scene.org</a><br>\n";

print H "<br>\n";

print H "DOSBox-X refers to the <a target=\"_blank\" href=\"http://dosbox-x.com/\">DOSBox-X project</a><br>\n";
print H "DOSBox-SVN refers to the <a target=\"_blank\" href=\"https://www.dosbox.com/\">DOSBox project</a><br>\n";
print H "<br>\n";

print H "<table cellpadding=0 cellspacing=0>\n";
print H "<thead class=\"testing_header\">\n";
print H "<tr>\n";
print H "<td style=\"min-width: 6em; text-align: center;\">DOSBox-X</td>";
print H "<td style=\"min-width: 6em; text-align: center;\">DOSBox-SVN</td>";
print H "<td>Demo</td>";
print H "</tr>\n";
print H "</thead>\n";

print H "<tbody>\n";

$count = 0;
open(S,"find -type d | sort |") || die;
while ($line = <S>) {
    chomp $line;

    $line =~ s/^\.\///;
    $disp_line = $line;
    next unless $disp_line =~ s/^unpacked\///;

    my $pass_dosbox_x = undef;
    my $pass_dosbox_x_rev = undef;
    my $pass_dosbox_x_rev_file = undef;

    if ( -f "$line/__PASS__" ) {
        $pass_dosbox_x = "PASS";
        $pass_dosbox_x_rev_file = "$line/__PASS__";
    }
    if ( -f "$line/__FAIL__" ) {
        $pass_dosbox_x = "FAIL";
        $pass_dosbox_x_rev_file = "$line/__FAIL__";
    }
    if (defined($pass_dosbox_x_rev_file) && -f $pass_dosbox_x_rev_file ) {
        open(R,"<",$pass_dosbox_x_rev_file) || die;
        # 20180208-004727-cf142387b7108d61666c99f9b8bd7bee5f054284-develop
        # yyyymmdd-hhmmss-commit-----------------------------------branch
        $pass_dosbox_x_rev = <R>;
        chomp $pass_dosbox_x_rev;
        close(R);
    }

    my $notes_dosbox_x = undef;
    if ( -f "$line/__NOTES__" ) {
        my $nline="",$pline,$res="",$ncount=0;

        open(X,"<","$line/__NOTES__") || die;
        while ($nline = <X>) {
            $pline = $nline;
            chomp $nline;
            $nline =~ s/^[ \t]+//;
            $nline =~ s/[ \t]+$//;
            next if $nline eq "";
            $res .= "\n" if $ncount > 0;
            $res .= "$nline";
            $ncount++;
        }
        close(X);
        $notes_dosbox_x = $res;
    }

    my $pass_dosbox_svn = undef;
    my $pass_dosbox_svn_rev = undef;
    my $pass_dosbox_svn_rev_file = undef;

    if ( -f "$line/__PASS_SVN__" ) {
        $pass_dosbox_svn = "PASS";
        $pass_dosbox_svn_rev_file = "$line/__PASS_SVN__";
    }
    if ( -f "$line/__FAIL_SVN__" ) {
        $pass_dosbox_svn = "FAIL";
        $pass_dosbox_svn_rev_file = "$line/__FAIL_SVN__";
    }
    if (defined($pass_dosbox_svn_rev_file) && -f $pass_dosbox_svn_rev_file ) {
        open(R,"<",$pass_dosbox_svn_rev_file) || die;
        $pass_dosbox_svn_rev = <R>;
        chomp $pass_dosbox_svn_rev;
        close(R);
    }

    my $notes_dosbox_svn = undef;
    if ( -f "$line/__NOTES_SVN__" ) {
        my $nline="",$pline,$res="",$ncount=0;

        open(X,"<","$line/__NOTES_SVN__") || die;
        while ($nline = <X>) {
            $pline = $nline;
            chomp $nline;
            $nline =~ s/^[ \t]+//;
            $nline =~ s/[ \t]+$//;
            next if $nline eq "";
            $res .= "\n" if $ncount > 0;
            $res .= "$nline";
            $ncount++;
        }
        close(X);
        $notes_dosbox_svn = $res;
    }

    next unless defined($pass_dosbox_x) || defined($pass_dosbox_svn);

    $count++;
    if ($count >= 24) {
        $count = 0;

        print H "</tbody>\n";

        print H "<thead class=\"testing_header\">\n";
        print H "<tr>\n";
        print H "<td style=\"min-width: 6em; text-align: center;\">DOSBox-X</td>";
        print H "<td style=\"min-width: 6em; text-align: center;\">DOSBox-SVN</td>";
        print H "<td>Demo</td>";
        print H "</tr>\n";
        print H "</thead>\n";

        print H "<tbody>\n";
    }

    print H "<tr>";

    if (defined($pass_dosbox_x)) {
        print H "<td class=\"passfail_$pass_dosbox_x\">$pass_dosbox_x</td>";
    }
    else {
        print H "<td class=\"passfail_NA\">---</td>";
    }

    if (defined($pass_dosbox_svn)) {
        print H "<td class=\"passfail_$pass_dosbox_svn\">$pass_dosbox_svn</td>";
    }
    else {
        print H "<td class=\"passfail_NA\">---</td>";
    }

    my $more = "<br>";

    if (defined($notes_dosbox_x) && $notes_dosbox_x ne "") {
        $more .= "<br>";
        $more .= "DOSBox-X NOTES: <pre>$notes_dosbox_x</pre>";
    }

    if (defined($notes_dosbox_svn) && $notes_dosbox_svn ne "") {
        $more .= "<br>";
        $more .= "DOSBox-SVN NOTES: <pre>$notes_dosbox_svn</pre>";
    }

    if ($disp_line =~ s/^ftp\.scene\.org\///) {
        $disp_line =~ s/^pub\///;
        print H "<td><a href=\"http://files.scene.org/get/$disp_line\">$disp_line</a>$more</td>";
    }
    else {
        print H "<td>$disp_line$more</td>";
    }

    print H "</tr>\n";
}
close(S);

print H "</tbody>\n";
print H "</table>\n";

print H "</body>\n";
print H "</html>\n";

close(H);

