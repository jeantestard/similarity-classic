package RogersTanimoto;

=head1 NAME

Classe RogersTanimoto calcule la similarit� entre deux texte. [Ici classe d�riv�e de la classe Similarite]

L'indice de Rogers et Tanimoto d�rive de l'indice Sokal et Michener. Il inscrit les r�sultats dans l'intervalle [0,1]
et accorde deux fois plus de poids aux diff�rences qu'aux concordances.

Forumle :
#				a
# S(A,B)= --------------
#			a + 2b + 2c

=head1 VERSION

2010

=head1 SYNOPSIS

use RogersTanimoto;

$simRogersTanimoto->calcul();

=cut

use strict;
use Carp;
our @ISA = qw(Similarite); # H�ritage de la classe Similarite

#Calcul de similarit� selon Rogers et Tanimoto : a / a + 2b + 2c
# argument 1 : objet h�ritant de Similarite
sub calcul {
	my $self= shift;
	my %vec1 = getVector($self->{"TEXTE1"}->{"VOC_FREQ"}, $self->{"VOC"});
	my %vec2 = getVector($self->{"TEXTE2"}->{"VOC_FREQ"}, $self->{"VOC"});
	my $a=0;
	my $b=0;
	my $c=0;
	foreach my $mot1 (keys %{$self->{"VOC"}}){
		if (${$self->{"VOC"}}{$mot1}>1) {
			$a++;
		} elsif ($vec1{$mot1}==1) {
			$b++;
		} elsif ($vec2{$mot1}==1) {
			$c++;
		}
	}
	my $res = $a/($a+(2*$b)+(2*$c));
	$self->putSimilarite($res);
	return 1;
}

# m�thode priv�e pour obtenir une table hash (mot, fr�quence) d'un document � partir du vocabulaire global
# arg1 : hash du document (membre de la classe Texte)
# arg2 : hash du vocabulaire global (partag� par les 2 documents) (membre de la classe Similarite)
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