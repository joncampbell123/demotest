#!/usr/bin/perl
my $line;

open(H,">compat-chart.html") || die;

print H "<html>\n";
print H "<head>\n";
print H "<title>Demoscene compat testing chart</title>\n";
print H "</head>\n";
print H "<body>\n";

print H "DOSBox demoscene compat testing chart<br>\n";
print H "Ref: <a href=\"ftp://ftp.scene.org\">ftp://ftp.scene.org</a><br>\n";

print H "<table>\n";
print H "<thead>\n";
print H "<tr>\n";
print H "<td>DOSBox-X</td>";
print H "<td>DOSBox-SVN</td>";
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

    $pass_dosbox_x = "PASS" if ( -f "$line/__PASS__" );
    $pass_dosbox_x = "FAIL" if ( -f "$line/__FAIL__" );

    my $notes_dosbox_x = undef;
    if ( -f "$line/__NOTES__" ) {
        open(X,"<","$line/__NOTES__") || die;
        read(X,$notes_dosbox_x,65536);
        close(X);
    }

    my $pass_dosbox_svn = undef;

    $pass_dosbox_svn = "PASS" if ( -f "$line/__PASS_SVN__" );
    $pass_dosbox_svn = "FAIL" if ( -f "$line/__FAIL_SVN__" );

    next unless defined($pass_dosbox_x) || defined($pass_dosbox_svn);

    $count++;
    if ($count >= 24) {
        $count = 0;

        print H "</tbody>\n";

        print H "<thead>\n";
        print H "<tr>\n";
        print H "<td>DOSBox-X</td>";
        print H "<td>DOSBox-SVN</td>";
        print H "<td>Demo</td>";
        print H "</tr>\n";
        print H "</thead>\n";

        print H "<tbody>\n";
    }

    print H "<tr>\n";

    if (defined($pass_dosbox_x)) {
        my $style = "";

        $style = "background-color: #7FFF7F;" if $pass_dosbox_x eq "PASS";
        $style = "background-color: #FF7F7F;" if $pass_dosbox_x eq "FAIL";

        print H "<td style=\"$style\">$pass_dosbox_x</td>";
    }
    else {
        print H "<td>---</td>";
    }

    if (defined($pass_dosbox_svn)) {
        my $style = "";

        $style = "background-color: #7FFF7F;" if $pass_dosbox_svn eq "PASS";
        $style = "background-color: #FF7F7F;" if $pass_dosbox_svn eq "FAIL";

        print H "<td style=\"$style\">$pass_dosbox_svn</td>";
    }
    else {
        print H "<td>---</td>";
    }

    if ($disp_line =~ s/^ftp\.scene\.org\///) {
        print H "<td><a href=\"http://files.scene.org/get/$disp_line\">$disp_line</a></td>";
    }
    else {
        print H "<td>$disp_line</td>";
    }

    print H "</tr>\n";
}
close(S);

print H "</tbody>\n";
print H "</table>\n";

print H "</body>\n";
print H "</html>\n";

close(H);

