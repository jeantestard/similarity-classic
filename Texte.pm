package Texte;

=head1 NAME

Classe Texte contenant les information relative à un document (fichier texte codé en UTF-8).
Cette classe permet d'attribuer une categorisation à un document

=head1 VERSION

March 2010

=head1 SYNOPSIS

use Texte;

new() : constructeur
getNomFichier() : Getter du nom de fichier
setNomFichier(nom) : # Setter du nom de document
getCategorie() : Getter de la catégorie du document
setCategorie(cat) : Setter de la catégorie du document
getVoc() : Getter du vocabulaire du document
getContentFromFile(file) : récupére le contenu d'un fichier sous forme d'une table hash (mot, fréquence)
_putVocInHash(texte) : transformer un texte en table hash (mot, fréquence) [privée]
_tokenise(texte) : ségmenteur en vecteur de mots [privée]

=cut

use strict;
use Carp;

# Constructeur 
sub new {
	my $class = shift(@_);
	my $self = {};
	$self->{"NOM_FICHIER"}= undef;
	#$self->{"CONTENU"}= undef;
	$self->{"CATEGORIE"}= undef;
	$self->{"VOC_FREQ"} = {};
	bless($self, $class);
	return($self);
}

# Getter du nom de document
sub getNomFichier {
	my $self = shift(@_);
	return ($$self{"NOM_FICHIER"});
}


# Setter du nom de document
# arg1 : nom de fichier à attribuer
sub setNomFichier {
	my ($self, $nomFic) = @_;
	if (! -f $nomFic) { croak "Fichier $nomFic introuvable";}
	$$self{"NOM_FICHIER"} = $nomFic;
	return 1;
}

# Getter de la catégorie du document
sub getCategorie {
	my $self = shift;
	return $self->{"CATEGORIE"};
}

# Setter de la catégorie du document
# arg1 : catégorie à attribuer
sub setCategorie {
	my ($self, $cat) = @_; 
	$$self{"CATEGORIE"} = $cat;
	return 1;
}


# Getter du vocabulaire du document (hash)
sub getVoc {
	my $self = shift(@_);
	return $self->{"VOC_FREQ"};
}

# Méthode pour récupérer le contenu d'un fichier sous forme d'une table hash (mot, fréquence)
# arg1 : nom de fichier
sub getContentFromFile {
	my ($self, $file) = @_;
	my $contenu;
	open (FILE, "<:utf8", $file) || croak("Problème d'ouverture du fichier $file : $!\n");
	while (<FILE>){	$contenu.= $_;}
	close(FILE);
	$$self{"NOM_FICHIER"} = $file;
	$$self{"VOC_FREQ"} = _putVocInHash($contenu);
	return 1;
}

# Méthode privée pour transformer un texte en table hash (mot, fréquence)
# arg1 : chaine de caractère (texte)
# retour : référence vers une table hash (mot, fréquence)
sub _putVocInHash {
	my $contenu = shift;
	my @tab = _tokenise($contenu);
	my %voc;
	foreach (@tab){
		$voc{$_}++;
	}
	return \%voc;
}


# méthode privée pour ségmenter un texte en mots
# arg1 : chaine de caractère (texte)
# retour : vecteur de mots du texte
sub _tokenise {
	my $contenu = shift;
	my @tab = $contenu =~ m/[\p{L}-]+/gi; # prend les mots  et les mots composés
	return @tab;
}

return 1;

# sub firstWord {
	# my $self = shift;
	# return $$self{"VOC"}->[0];
# }

# sub secondWord {
	# my $self = shift;
	# return $$self{"VOC"}->[1];
# }

	# my (@tmp, @tab);
	# open (FILEIN, "<:utf8", "$fileName") || croak("Erreur d'ouverture de fichier $fileName : $!");
	# while (<FILEIN>){
		# @tmp = $_ =~ m/[\p{L}-]+/gi; # prend les mots  et les mots composés uniquement
		# push(@tmp, @tab);
	# }

	# return(@tab);

# sub setTextContent {
	# my ($self, $contenu) = @_; # affectation pour chaque element)
	# $$self{"CONTENU"} = $contenu;
	# return 1;
# }
