#!/usr/bin/env perl
use strict;
use warnings;
use YAML::Tiny;
use File::Slurp qw/read_file write_file/;

my $ser = YAML::Tiny->read("servers.yml")->[0];
my $html;

for my $s (@{ $ser->{"servers"} }) {
	$html .= "<tr><td>$s->{name}";

	if (exists $s->{"note"}) {
		$html .= note($s->{"note"});
	}

	$html .= "</td><td>";

	if (exists $s->{"extra_addrs"}) {
		my $first = 1;
		for my $a (@{ $s->{"extra_addrs"} }) {
			if (!$first) {
				$html .= ", ";
			} else {
				$first = 0;
			}

			$html .= $a->{"addr"};

			if (exists $a->{"note"}) {
				$html .= note($a->{"note"});
			}
		}
	} else {
		$html .= "n/a";
	}

	$html .= "</td><td>$s->{admin_nick}</td><td>$s->{location}</td></tr>";
}

my $doc = read_file("servers_template.html");
$doc =~ s/<!-- \{\{\{ SERVERS \}\}\} -->/$html/;
write_file("htdocs/servers.html", $doc);

sub note {
	my $n = shift;
	return " <em>($n)</em>";
}
