package Similarite;

=head1 NAME

Classe similarite pour calculer la similarité d'un texte par rapport à un autre. [Ici classe virtuelle]
Les mesures de similarités ci-dessous repertoriées sont dérivées de cette classe.
cosinus
jaccard
Dice
Sokal Snesth
Sohal micheners
Rogers Stanimoto

=head1 VERSION

 2010

=head1 SYNOPSIS

use similarite;

new(texte1, texte2) : constructeur avec 2 objets de la classe Texte
getTexte2() : accesseur de l'objet Texte2
getSimilarite() : Accesseur du champ : SIMILARITE
putSimilarite() : Putter du champ : SIMILARITE [méthode protégée]
getTotalLexicon() : Construit un hash du vocabulaire partagé [méthode privée]

=cut

use strict;
use Carp;
#use Data::Dumper;
use POSIX qw(log10);
# our @ISA = qw(Exporter);
# our @EXPORT = qw(&new &getVector); # énumérer les noms de fonctions à exporter


# constructeur
sub new {
	my ($class, $texte1, $texte2) = @_;
	my $self = {};
	$self->{"TEXTE1"}= $texte1;		
	$self->{"TEXTE2"}= $texte2;	
	$self->{"SIMILARITE"}= undef; # voir si on peut affecter directement la valeur	
	#$self->{"IDF"}= undef;	# pour contenir l'IDF 
	$self->{"VOC"}= getTotalLexicon($self->{"TEXTE1"}->{"VOC_FREQ"}, $self->{"TEXTE2"}->{"VOC_FREQ"});
	bless($self, $class);
	return($self);
}

# Getter de l'objet : TEXTE2
sub getTexte2 { # texte comportant une catégorie
	my $self = shift @_;  
	return $self->{"TEXTE2"};
}

# Getter du champ : SIMILARITE
sub getSimilarite {
	my $self = shift;
	return $self->{"SIMILARITE"};
}

# Putter du champ : SIMILARITE
sub putSimilarite {
	my ($self, $s) = @_;
	$self->{"SIMILARITE"} = $s;
	return 1;
}

# méthode de calcul de similarité 
# ici inutilisée au profit de la méthode héritée
sub calcul {
	my $this = shift; # récupération de l'objet (toujours passé en premier argument)
	if ($this->{"TEXTE1"} eq $this->{"TEXTE2"}) {
		return 0;
	}
	return 1;

}

# Construit une table hash contenant les mots du vocabulaire global (partagé)
# arg1 : table hash 1 (mot, fréquence)
# arg2 : table hash 2 (mot, fréquence)
# retour : hash du vocabulaire partagé (mot, fréquence)
sub getTotalLexicon {
	my $_hash1 = shift;
	my $_hash2 = shift;
	my %vocGlobal;
	foreach (keys(%$_hash1)) {
		$vocGlobal{$_}++;
	}
	foreach (keys(%$_hash2)) {
		$vocGlobal{$_}++;
	}
	return \%vocGlobal;
}


return 1;

# sub calculIDF {
	# my $_self = shift;
	# my $_voc = shift;
	# my %idf;
	# foreach my $mot(keys %$_voc){
		# foreach my $elem (keys %$hash){ # pour chaque mot de la table de hashage anonyme correspondant aux aux info de chaque document
			# if ( $mot eq $elem) {
				# $$ref_voc{$mot}++; # DF (document frequency)
				# last;
			# }
		# }
		# $idf{$mot} = log10(2/$$ref_voc{$mot}); # nombre total de document = nombre de documents de la collection + la requête
	# }
	# return(%idf);
# }



# sub calcul{
	# my $ref_hash1 = shift;
	# my $ref_hash2 = shift;
	# my %tfidf;
	# foreach my $mot(keys %$ref_voc){
		# $tfidf{$mot} = 0;  # initialisation de toutes les valeurs pour éviter des tests inutiles
		# foreach my $elem(keys %$$ref_docData) { # pour chaque élément du document testé (tableau anonyme)
			# if ($mot eq $elem) {  # si le mot est utilisé dans le document testé
				# $tfidf{$mot} = $$$ref_docData{$elem} * $$ref_idf{$mot}; # tfidf = fréquence du mot dans le document * idf
				# last;
			# }
		# }
	# }
	# return(\%tfidf);
# }

# à supprimer --------------
# sub setTexte1 {
	# my ($self, $texte1) = @_;  
	# $self->{"TEXTE1"} = $texte1;
	# return 1;
# }

# à supprimer --------------
# sub setTexte2 {
	# my ($self, $texte2) = @_;
	# $self->{"TEXTE2"} = $texte2;
	# return 1;
# }

#	my %voc = getTotalLexicon($self->{"TEXTE1"}->{"VOC_FREQ"}, $self->{"TEXTE2"}->{"VOC_FREQ"});
	
#	my %vector = 
#	print Dumper %voc;
	# %idf = calculIDF(\%voc, $self->{"TEXTE1"}->{"VOC_FREQ"}, $self->{"TEXTE2"}->{"VOC_FREQ"});
	# my %idf = idf(\$self, \%voc);
	#my %tfidf = tfidf();
