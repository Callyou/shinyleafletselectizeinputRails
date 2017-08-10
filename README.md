# shinyleafletselectizeinputRails
A shiny to explore french railways SNCF open data with Leaflet lib linked to selectizeinput

For now in french only, but the comments in the code are in english
-----------------------------------------------------------------------------------------------------------------------
# Comment pouvoir utiliser cette application

## Onglet "Résultats Origine Destination"
Choississez si vous désiré partir d'une gare TGV ou TER, sinon décocher les 2 checkbox pour avoir toutes les gares disponibles. Puis choissisez votre gare de "DEPART".
Ensuite les destinations possibles correspondantes s'afficheront dans le dropmenu "ARRIVEE"
Vouos verrez plusieurs fois le même nom de gare si vous tapez dans le dropmenu qui est aussi une sorte de searchbar avec aide, car faute de temps à consacrer en ce moment, je n'ai pas réellement bien nettoyé et préparer les données, j'ai préféré passé sur le développement directement pour vous montrer une interface. Voir l'explication supplémentaire dans le paragraphe suivant.

## Onglet "Carte"
Comme cela prends du temps de préparer les données correctements, j'ai seulement effectué une préparation des données rapides pour pouvoir afficher quelques données.
Ce qui explique le fait que seulement certaines gares s'affichent, car je n'ai pas eu l'envie (faute de temps que je préfère passer sur mon mémoire en ce moment) de nettoyer et formater les données par exemple dans Gares.xlsx "Roissy-Aéroport-Charles-de-Gaulle" alors que dans TGV tarifs.xlsx "AEROPORT CDG 2 TGV ROISSY" ou de corriger la non uniformité ou format d'écriture des données comme les espace ou majuscule minuscule.
Cette carte utilise la lib Leaflet utilisant OpenStreetmap.

Ce que fait la carte :
- Chaque point est une gare qui possède des coordonnées valides, le point central en noir c'est juste la valeur par défaut mis à toutes les autres gares.
- Les points de la carte sont liés au dropmenu "DEPART" et à la datatable de l'onglet "Résultats Origine Destination", quand on clique sur la point sur la carte, le dropmenu se met à jour ainsi que la datatble contenant les prix, et inversément.
- Le point/gare selectionné s'affiche en rouge.

# Fichiers utilisés :
TGV tarifs.xlsx pour les tarifs et les origine-destination possibles
Gares.xlsx pour les coordonnées géographiques

## Idées à développer
Mieux préparer les données pour pouvoir effectuer plus de fonctions comme :
- afficher le chemin du trajet d'après carte de la SNCF sur la carte selon départ-arrivée
- afficher en pop-up sur la carte le délai et le tarif du trajet sélectionné
- pouvoir en extraire des fichiers csv des données utilisées
- produire une IHM plus Bootstrap "moderne"
- utiliser les open data de la sncf si celles-ci sont intéressantes, mais cela demadne le temps des les explorer, comprendre, et les préparer...
