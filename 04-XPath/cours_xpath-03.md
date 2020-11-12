# Xpath - 3

## Les séquences - suite

---
### Instruction `for`

Cette instruction permet d'itérer à travers des séquences. On peut appliquer y une fonction à chaque *item*. En retour, une autre séquence est obtenue avec le résultat de l'application de la fonction.

La syntaxe est la suivante : `for $variable in sequence return expression`.
Attention, une variable se déclare et s'utilise avec le signe `$`.

Exemples :

```xml
for $i in (1 to 10) return $i           (1, 2, 3, ..., 10)
for $i in (1 to 10) return $i * 2       (2, 4, 6, ..., 20)

for $z in //livre
  return $z/titre/string()  (titre1, titre2, ...)

for $prix in (55, 10), $quantite in (4, 2)
  return $prix * $quantite     (220, 110, 40, 20)

for $n in child::name
  return concat($n/fname, ' ', $n/surname)
```

On peut nommer la variable comme on le souhaite.

On peut enchâsser des boucles comme sur le dernière exemple. Attention, dans la seconde expression on ne déclare pas le mot-clé `for`. Il s'agit de la représentation de

```
for $prix in (55, 10)
    for $quantite in (4, 2)
        return $prix * $quantite
```
---
### Instruction `if () then else`

Il est possible d'utiliser une structure de contrôle avec l'instruction `if () then else`. La première condition est évaluée : si son évaluation renvoie vrai alors on exécute les instructions du `if`. Sinon, si elle renvoie faux, on exécute les instructions du `else`.

La syntaxe est la suivante `if (test) then expression1 else expression2`. Ne pas oublier le `then`. Il faut obligatoirement mettre parentheser le test.

Exemples :

```xml
for $prix in (33, 10, 2, 43, 42, 100)
  return if ($prix < 25) then "Cheap!" else "Expensive!"

for $f in /pdv_liste/pdv/fermeture
return
  if ($f/@*) then "Le pdv a déjà fermé"
  else "Aucune fermeture"

/pdv_liste/pdv/fermeture/(if (@*) then "Le pdv a déjà fermé" else "Aucune fermeture")
```

Il est impossible d'avoir seulement un `if () then`. Si l'on veut quand même utiliser cette construction, il est nécessaire de renvoyer une valeur. Pour cela, on peut renvoyer une séquence vide `()`.

```xml
for $f in /pdv_liste/pdv/fermeture
return
if ($f/not(@*)) then "Le pdv a déjà fermé"
else ()
```
---
### Expressions ensemblistes

#### `union`

Il est possible de combiner **des noeuds** grâce à l'opérateur `union`. Cela permettre d'obtenir une séquence contenant les deux séquences à unir.

```xml
/pdv_liste/pdv[1]/adresse union /pdv_liste/pdv[2]/adresse

(<adresse>ROUTE NATIONALE</adresse>,
<adresse>16 Avenue de Marboz</adresse>)
```

L'opérateur `union` a été ajouté à partir de la version XPath 2. Néanmoins, dans la version 1, il est possible de venir au même résultat avec le pipe `|`.

---
#### `intersect`

L'intersection de deux séquences de **noeuds** est obtenu avec l'opérateur `intersect`.

Cet opérateur est pratique pour trouver les éléments communs à deux séquences. Ainsi, il ne fonctionne que sur des séquences.

```xml
/pdv_liste/pdv[services/service/text() = "Automate CB"]
intersect
/pdv_liste/pdv[fermeture[@*]]
```

Retourne les noeuds `pdv` qui ont à la fois un service d'automate carte bancaire et qui ont déjà été fermé.

---
#### `except`

`except` permet de trouver la différence entre deux séquences de **noeuds**.

```xml
/pdv_liste/pdv
except
/pdv_liste/pdv[fermeture[@*]]
```
Retourne la liste des points de vente qui n'ont pas connu de fermeture.

---
### Expressions quantifiés

#### `some`

Pour vérifier qu'**au moins** un *item* de la séquence vérifie la condition énoncée.

La syntaxe est `some $variable in sequence satisfies expression`.

Si l'expression est vérifiée, alors cette expression renvoi *true* sinon *false*.

```xml
some $i in /pdv_liste/pdv/services/service satisfies contains($i, "Automate CB")

true
```

Cette expression retourne *true* si au moins un des pointes de vente contient la chaîne de caractères "Automate CB" dans l'un de ses services.

---
#### `every`

Pour vérifier qu'une **séquence entière** valide une condition, on peut utiliser l'opérateur `every`.

La syntaxe est `every $variable in sequence satisfies expression`.

Si l'expression est vérifié pour chaque *item* de la séquence, alors *true* est renvoyé sinon *false*.

```xml
every $i in /pdv_liste/pdv satisfies ./child::*

true
```

Cette expression retourne *true*, si tous les points de vente ont un enfant.

---
### Exercices

À partir du fichier `pdv.xml`.

#### `for return`

1. Renvoyer le nom de chaque élément dans le document.
2. Multiplier le prix du "gazole" par 2,5. (On considère que `@valeur` est le prix)
3. Renvoyer une séquence contenant la concaténation de l'adresse et de la ville pour chaque point de vente, séparée par un espace. (Ex : "ROUTE NATIONALE SAINT-DENIS-LèS-BOURG")

#### `if () then else`

1. Créer une séquence de 1 à 100 et renvoyer tous les multiples de 3.
2. Renvoyer les id des points de vente ne contenant que le service `Vente de gaz domestique` sinon, renvoyer l'adresse.
3. Renvoyer l'adresse en majuscule si elle contient le mot "Avenue" sinon ne rien renvoyer.

#### `union`

1. Renvoyer l'union de tous les services.
2. Écrire une requête qui sélectionne les points de vente qui vendent du `SP95` et du `SP98`. Mais pas forcément en même temps.

#### `intersect`

1. Écrire une requête qui sélectionne les points de vente qui ont été en rupture et qui ne sont pas ouverts les dimanches.

#### `except`

1. Écrire une requête qui renvoie tous les points de vente qui ne sont pas sur la route nationale.

#### `some`

1. Existe-t-il un point de vente n'ayant pas d'automate à carte bancaire ? Écrire la requête.

#### `every`

1. Est-ce-que chaque point de vente est ouvert 7 jours sur 7 ? Écrire la requête

