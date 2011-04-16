#! usr/bin/perl -w
# ____________________________________________________________________________
# Ce programme calcul le rappel et la précision entre deux fichier (manuel et automatique) 

use strict;
use Data::Dumper;
# ----------------------------------------------
my $Usage="Usage : perl evaluation.pl catego-manuelle.txt catego-auto.txt\n";
die "$Usage" unless defined $ARGV[0];
die "$Usage" unless defined $ARGV[1];
my $cat_man_file = $ARGV[0];
my $cat_auto_file = $ARGV[1];
my (@tmp, %manu, %auto);
# ----------------------------------------------
# Précision : $nb_correct / $nb_auto
# Rappel : $nb_correct / $nb_attendus
my $nb_corrects; # nombre de docs corresctement catégorisés
my $nb_auto; # nombre de docs catégorisés automatiquement (pour la catégorie qu'on veut évaluer)
my $nb_attendus; # nombre de docs attendus (correspondant à la catégorisation manuelle)
# ----------------------------------------------
# ouverture du fichier de données
open (MANU, "<:utf8", "$cat_man_file") || die "Erreur d'ouverture de fichier de lecture $cat_man_file : $!";
open (AUTO, "<:utf8", "$cat_auto_file") || die "Erreur d'ouverture de fichier de lecture $cat_auto_file : $!";
# ----------------------------------------------
while (<MANU>) {
	chomp $_;
	if ($_ =~ m/^([^\t]+)\t([^\t]+)$/) {
		$manu{$1} = $2;
	}
}

while (<AUTO>) {
	chomp $_;
	if ($_ =~ m/^([^\t]+)\t([^\t]+)$/) {
		$auto{$1} = $2;
	}
}

print Dumper \%manu;
print Dumper \%auto;

foreach my $elem(keys %manu) {
	if ($manu{$elem}==1 && $auto{$elem} == 1) {
		$nb_corrects++;
	}
	if ($auto{$elem} == 1) {
		$nb_auto++;
	}
	if ( $manu{$elem}==1) {
		$nb_attendus++;
	}
}
my $precision = sprintf("%.2f",($nb_corrects/$nb_auto) * 100); 
my $rappel = sprintf("%.2f",($nb_corrects / $nb_attendus) * 100);
print "\nRappel : $rappel %\n";
print "\nPrécision : $precision %\n";