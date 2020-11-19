En repartant du fichier `juicers.html`

1. Créer une séquence contenant les `juicer` de type centrifugeuse
	(//juicer[@type='centrifugal'])
	On entoure notre xpath dans une séquence avec les parenthèses pour expliciter qu'il s'agit d'une séquence.

2. Sélectionner la dernière machine (= dernier `juicer`) à partir de cette séquence
	(//juicer[@type='centrifugal'])[last()]
	Ici on renvoie bien le dernier élément de la séquence (= la dernière machine).
	Une requête similaire aurait été `//juicer[@type='centrifugal'][last()]`

3. Supprimer la deuxième machine de cette séquence
	`remove((//juicer[@type='centrifugal']), 2)`

4. Créer une séquence du nom des machines, la séquence doit contenir des chaînes de caractères
	`(//juicer/name/string())`
	Cette séquence sera composée que de valeurs atomiques de type string.
	Précédemment la séquence contenait des nœuds `<juicer>`, c'est à dire que l'on pouvait à nouveau utiliser une expression xpath sur un item de cette séquence comme :
	(ex : `(//juicer[@type='centrifugal'])[2]/name/string())`)

5. Afficher la position de la machine ayant pour nom `Juiceman Jr.` à partir de cette séquence
	`index-of((//juicer/name/string()), 'Juiceman Jr.')`
	`index-of()` nous renvoie la position de l'item donc la valeur est indiquée

6. Créer une séquence avec les noeuds contenant le nom des machines
	`(//name)`
	Notre séquence contient plusieurs nœuds qui sont les nœuds `<name`. Vous pouvez vérifier avec `(//name)[1]/string()`

7. Afficher la position du noeud contenant une balise `name` ayant pour valeur `Juiceman Jr.` à partir de cette séquence
	index-of((//name)[./string()], 'Juiceman Jr.')
	On applique sur chaque item de notre séquence la fonction `string()` puis on applique ce résultat à notre fonction `index-of`.

8. Créer une séquence d'entier allant de 5 à 25
	(5 to 25)
	Note : ne fonctionne que pour des entiers

10 Afficher tous les multiples de 5 de cette séquence
	(5 to 25)[. mod 5 = 0]
	Sur notre séquence, on test si chaque nœud de contexte représenté par le point '.' a bien un reste de la division égal à 0 lorsqu'il est divisé par 5.
