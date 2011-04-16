#! usr/bin/perl -w


use strict;
use Data::Dumper;
use Carp;
# ----------------------------------------------
my $Usage="Usage : perl evaluation.pl fileModel.txt rep\n";
die "$Usage" unless defined $ARGV[0];
die "$Usage" unless defined $ARGV[1];

#----------------
my $path = $ARGV[1];
chomp $path;
die "$ARGV[1] n'est pas un dossier valide" if (! -d $ARGV[1]);
opendir(DIR, $path) or die "Problème d'ouverture de $path: $!\n";
my @files = grep(!/^\.\.?$/, readdir(DIR));  # éliminer les fichier systèmes "." et ".."
closedir(DIR);
# print Dumper @files;
# exit;
#----------------

#my $fileModel = $ARGV[0];
#print $fileModel;


#---------- Obtention du vocabulaire du fichier de comparaison
my %vocFileModel = getWordsFromFile($ARGV[0]);
# print Dumper \%vocFileModel;
# exit;

#---------- 
my %similarite;
foreach my $file (@files) {
	$path = $ARGV[1]."/".$file;
	my %tabFile = getWordsFromFile($path);
	my $sim = 0;
	foreach my $wordFile (keys %tabFile){
		foreach my $wordFileModel (keys %vocFileModel) {
			if ($wordFile eq $wordFileModel) {
				$sim++;
			}
		}
	}
	$similarite{$file} = $sim;
}

print Dumper \%similarite;

#=================== SUBROUTINES

sub getWordsFromFile {
	my $fileIn = shift;
	my (@tmp, %hash);
	open (FILEIN, "<:utf8", "$fileIn") || croak("Erreur d'ouverture de fichier $fileIn : $!");
	while (<FILEIN>){
			chomp $_;
			@tmp = $_ =~ m/[\p{L}-]+/gi; 
		   	foreach my $mot(@tmp){
				$hash{lc($mot)}++; 
			}
		}
	close(FILEIN);
	return(%hash)
}