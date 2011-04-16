package Cosinus;

=head1 NAME

Classe Cosinus mesure la similarité entre deux texte. [Ici classe dérivée de la classe Similarite]
Les 2 textes sont ici représentés sous forme de vecteurs de mots

Le cosinus calcule le produit scalaire des 2 vecteurs, puis la norme de chacun des deux.
Le premier résultat est rapporté au second.

Forumle :
#					  A * B
# Cosinus(A,B) = -------------
#					|A| * |B|	

=head1 VERSION

2010

=head1 SYNOPSIS

use Cosinus;

$simCosinus->calcul();

=cut

use strict;
use Carp;
use Data::Dumper;
use POSIX qw(log10);
our @ISA = qw(Similarite); # Héritage de la classe Similarite


#Calcul de similarité selon l'indice Dice : 2a / 2a + b + c
# argument 1 : objet héritant de Similarite
sub calcul {
	my $self= shift;
	my %idf = idf($self);
	my %tfidf1 = tf_idf($self->{"TEXTE1"}->{"VOC_FREQ"}, $self->{"VOC"}, \%idf);
	my %tfidf2 = tf_idf($self->{"TEXTE2"}->{"VOC_FREQ"}, $self->{"VOC"}, \%idf);
	my $prodScalaire = produitScalaire(\%tfidf1, \%tfidf2);
	my $norme1 = norme (\%tfidf1);
	my $norme2 = norme (\%tfidf2);
	my $cosinus = cosinus($prodScalaire, $norme1, $norme2);
	$self->putSimilarite($cosinus);
	return 1;
}

# Calcul de l'IDF (nombre de docs(ici 2) /nombre de docs contenant le mot mesuré)
# arg1 : référence sur un objet Similarite
# retour : hash contenant l'idf du vocabulaire partagé 
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
		$idf{$mot} = log10(2/$tmp{$mot}); # nombre total de document = nombre de documents de la collection + la requête
	}
	return(%idf);
}

# Calcul du TF-IDF d'un document
# arg1 : référence sur le hash du document
# arg2 : référence sur le hash du vocabulaire général
# arg3 : référence sur le hash de l'idf
# retour : hash contenant le tf-idf de chaque mot du document (fréquence du mot dans le document * son idf)
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

# Calcul du produit scalaire entre 2 vecteurs de documents
# arg1 : vecteur tf_idf du document1
# arg2 : vecteur tf_idf du document2
# retour : résultat : total des additions (mot du doc1 * mot du doc2)
sub produitScalaire {
	my $tab1 = shift; 
	my $tab2 = shift;
	my $result = 0;
	foreach my $mot(keys %$tab1) {
		$result += $$tab1{$mot} * $$tab1{$mot};
	}
	return $result;

}

# Calcul de la norme d'un document
# arg1 : vecteur tf_idf du document
# retour : norme [racine carrée des sommes des tf-idf des mots élevés au carré]
sub norme {
	my $hash = shift;
	my $somme;
	foreach my $elem(values %$hash){
		$somme += $elem * $elem;
	}
	return(sqrt($somme));
}


# Calcul le cosinus entre deux documents
# arg1 : produit scalaire d'un document
# arg2 : norme de ce document 
# arg3 : norme de ce document 
# retour : cosinus : produit scalaire / norme du document1 * norme du document2
sub cosinus {
	my $ps = shift;
	my $n1 = shift;
	my $n2 = shift;
	if ($n1 != 0 and $n1 != 0) { # pour éviter l'éventuelle division par 0
		return($ps / ($n1 * $n2));
	} 
	return(0);
}

return 1;