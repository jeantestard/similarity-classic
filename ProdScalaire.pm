package ProdScalaire;

=head1 NAME

Classe ProdScalaire mesure la similarit� entre deux texte. [Ici classe d�riv�e de la classe Similarite]
Les 2 textes sont ici repr�sent�s sous forme de vecteurs de mots

Le produit scalaire correspond � la somme des produits des valeurs(tf-idf des mots) 
prises deux par deux dans les vecteurs compar�s.

Forumle :
#					
# PS(A,B) = somme( ALPHA * BETA ) [o� ALPHA et BETA repr�sentent le produit des tf-idf des documents A et B]
#					

=head1 VERSION

2010

=head1 SYNOPSIS

use ProdScalaire;

$simProdScalaire->calcul();

=cut

use strict;
use Carp;
use POSIX qw(log10);
our @ISA = qw(Similarite); # H�ritage de la classe Similarite


#Calcul de similarit� � travers le produit scalaire
# argument 1 : objet h�ritant de Similarite
sub calcul {
	my $self= shift;
	my %idf = idf($self);	
	my %tfidf1 = tf_idf($self->{"TEXTE1"}->{"VOC_FREQ"}, $self->{"VOC"}, \%idf);
	my %tfidf2 = tf_idf($self->{"TEXTE2"}->{"VOC_FREQ"}, $self->{"VOC"}, \%idf);
	my $prodScalaire = produitScalaire(\%tfidf1, \%tfidf2);
	$self->putSimilarite($prodScalaire);
	return 1;
}


sub idf{
	my $obj = shift;
	my %tmp;
	my %idf;
	foreach my $mot(keys %{$obj->{"VOC"}}){
		if (exists $obj->{"TEXTE1"}->{"VOC_FREQ"}{$mot}) {
			$tmp{$mot}++;
		}
		if (exists $obj->{"TEXTE2"}->{"VOC_FREQ"}{$mot}) {
			$tmp{$mot}++;
		}
		$idf{$mot} = log10(2/$tmp{$mot}); # nombre total de document = nombre de documents de la collection + la requ�te
	}
	return(%idf);
}

sub tf_idf {
	my $vocDoc = shift;
	my $vocTotal = shift;
	my $idf = shift;
	my %tfidf;
	foreach my $mot(keys %$vocTotal){
		if (exists $$vocDoc{$mot}) {
			$tfidf{$mot} = $$vocDoc{$mot} * $$idf{$mot};
		} else {
			$tfidf{$mot} = 0;
		}
	}
	return %tfidf;
}

sub produitScalaire {
	my $tab1 = shift; 
	my $tab2 = shift;
	my $result = 0;
	foreach my $mot(keys %$tab1) {
		$result += $$tab1{$mot} * $$tab1{$mot};
	}
	return $result;

}

return 1;