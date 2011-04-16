package Dice;

=head1 NAME

Classe Dice calcule la similarit� entre deux texte. [Ici classe d�riv�e de la classe Similarite]

L'indice Dice accorde un poids 2 fois plus �lev� aux �l�ments partag�s et est d�finie comme suit :

Forumle :
#				2a
# S(A,B) = -------------
#			2a + b + c	

=head1 VERSION

2010

=head1 SYNOPSIS

use Dice;

$simDice->calcul();

=cut

use strict;
use Carp;
our @ISA = qw(Similarite); # H�ritage de la classe Similarite

#Calcul de similarit� selon l'indice Dice : 2a / 2a + b + c
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
	my $res = 2*$a/((2*$a)+$b+$c);
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