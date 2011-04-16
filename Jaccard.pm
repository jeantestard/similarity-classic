package Jaccard;

=head1 NAME

Classe Jaccard calcule la similarité entre deux texte. [Ici classe dérivée de la classe Similarite]

L'indice Jaccard correspond à la cardinalité de l'intersection de deux ensembles 
rapportée à la cardinalité de l'union de ces deux ensembles.

Forumle :
#				a
# S(A,B) = -------------
#			a + b + c	

=head1 VERSION

2010

=head1 SYNOPSIS

use Jaccard;

$simJaccard->calcul();

=cut

use strict;
use Carp;
our @ISA = qw(Similarite); # Héritage de la classe Similarite

#Calcul de similarité selon l'indice Jaccard : a / a + b + c
# argument 1 : objet héritant de Similarite
sub calcul {
	my $self= shift;
	my %vec1 = getVector($self->{"TEXTE1"}->{"VOC_FREQ"}, $self->{"VOC"});
	my %vec2 = getVector($self->{"TEXTE2"}->{"VOC_FREQ"}, $self->{"VOC"});
	my $a=0;
	foreach my $mot1 (keys %{$self->{"VOC"}}){
		if (${$self->{"VOC"}}{$mot1}>1) {
			$a++;
		}
	}
	my $res = $a/scalar(keys %{$self->{"VOC"}});
	$self->putSimilarite($res);
	return 1;
}

# méthode privée pour obtenir une table hash (mot, fréquence) d'un document à partir du vocabulaire global
# arg1 : hash du document (membre de la classe Texte)
# arg2 : hash du vocabulaire global (partagé par les 2 documents) (membre de la classe Similarite)
# retour : hash du document par rapport au vocabulaire global
sub getVector {
	my $hashFile = shift;
	my $_voc = shift;
	my %vecteur;
	foreach my $mot(keys %$_voc){
		$vecteur{$mot} = 0;
		foreach my $elem(keys %$hashFile) {
			if ($mot eq $elem) {  
				$vecteur{$mot}++;
				last;
			}
		}
	}
	return(%vecteur);
}

return 1;