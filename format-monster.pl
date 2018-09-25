#!/usr/bin/perl -wl

# This script takes a text copy from dndbeyond.com/monsters on STDIN
# and formats it for homebrewery

use strict;
use Data::Dumper;

my $raw = join "", <>;
my @sections = split /\n\n/, $raw;
my @lines;


# Section 1: Name:
@lines = split /\n/, shift @sections;
print "____";
print "> ## $lines[0]";
print "> *$lines[1]*";

# Section 2: AC etc
@lines = split /\n/, shift @sections;
print "> ___";
for my $line (@lines) {
    $line =~ s/^(Armor Class|Hit Points|Speed)/**$1**/;
    print "> - $line";
}

# Section 3: Ability scores
@lines = split /\n/, shift @sections;
my @scores = grep /^\d/, @lines;

print "> ___";
print "> |STR|DEX|CON|INT|WIS|CHA|";
print "> |:---:|:---:|:---:|:---:|:---:|:---:|";
print "> |", join("|", @scores), "|";

# Section 4: Skills etc
print "> ___";
@lines = split /\n/, shift @sections;
for my $line (@lines) {
    $line =~ s/^(\S+ (Resistances|Immunities|Vulnerabilities))/**$1**/;
    $line =~ s/^([^*]\S+)/**$1**/;
    print "> - $line";
}
print "> ___";

# Section 5+: Actions, Bonus Actions, Reactions, Other
for my $section (@sections) {
    @lines = split /\n/, $section;
    for my $line (@lines) {
        if ($line =~ /\./) {
            $line =~ s/^([^.]+.)/***$1***/;
            $line =~ s/((Melee|Ranged) (Weapon|Spell) Attack:)/*$1*/;
            $line =~ s/(Hit:)/*$1*/;
            print "> $line";
        }

        elsif ($line =~ /./) {
          print "> ### $line";
        }
    }
    print ">";
}
