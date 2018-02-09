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

open(S,"find -type d | sort |") || die;
while ($line = <S>) {
    chomp $line;

    my $pass_dosbox_x = undef;
    my $pass_dosbox_svn = undef;

    $pass_dosbox_x = "PASS" if ( -f "$line/__PASS__" );
    $pass_dosbox_x = "FAIL" if ( -f "$line/__FAIL__" );

    my $notes_dosbox_x = undef;
    if ( -f "$line/__NOTES__" ) {
        open(X,"<","$line/__NOTES__") || die;
        read(X,$notes_dosbox_x,65536);
        close(X);
    }

    next unless defined($pass_dosbox_x);

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

    print H "</tr>\n";
}
close(S);

print H "</tbody>\n";
print H "</table>\n";

print H "</body>\n";
print H "</html>\n";

close(H);

