#!/usr/bin/perl
my $line;

open(H,">compat-chart.html") || die;

print H "<html>\n";
print H "<head>\n";
print H "<title>Demoscene compat testing chart</title>\n";
print H "</head>\n";
print H "<body>\n";

open(S,"find -type d | sort |") || die;
while ($line = <S>) {
    chomp $line;
}
close(S);

print H "</body>\n";
print H "</html>\n";

close(H);

