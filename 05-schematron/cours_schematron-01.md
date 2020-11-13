# Schematron

> a feather duster to reach the parts other schema languages cannot reach.
> 
> Rick Jelliffe

## Introduction

Schématron a été inventé par Rick Jelliffe, il est défini par une norme ISO depuis 2006. Le site officiel avec la documentation, se trouve à l'adresse [http://schematron.com/](http://schematron.com/).

Il s'agit d'un langage de validation basé sur des règles pour supposer l’existence ou non de certains patrons. Il fait donc partie des schémas XML comme `RelaxNG` ou bien `XML Schema`.

Ses principaux atouts sont

* une syntaxe XML
* expression en langage naturel des contraintes souhaitées ou des observations
* les requêtes utilisent XPath
* on peut générer des rapports ou bien intégrer les erreurs dans Oxygen
* la structure est non rigide, c'est à dire qu'on a la possibilité d’interroger le document dans n’importe quel ordre
* peut être utilisé conjointement avec `RelaxNG` ou bien `XML Schema`

## Syntaxe

L'extension du document est `.sch`.

Il existe 6 éléments principaux qui permettent de former un schématron.

Tout d'abord la racine `<schema xmlns="http://purl.oclc.org/dsdl/schematron">`, l'élément se nomme `schema` et existe dans l'espace de nom `"http://purl.oclc.org/dsdl/schematron"`.

Il peut y avoir un élément `<title>`optionnel, pour indiquer un titre à notre schéma.

Pour préciser l'espace de nom du document XML que l'on souhaite valider, il faut utiliser la balise `<ns prefix="" uri=""/>`. On pourra y préciser le préfixe voulu ainsi que l'espace de nom associé.

Un schématron va permettre de valider un patron ou *pattern*. Cet élément a pour syntaxe `<pattern id="">`, l'id est choisi par l'auteur du document.

Le patron contient lui-même un élément `<rule context="">` où l'on indique le contexte, c'est à dire sur quel noeud on va exprimer une condition.

À l'intérieur d'une règle on peut retrouver plusieurs contraintes ou observations. L'attribut `@test` des élément `<assert>`et `<report>` contient des expressions XPath. En valeur textuelle de ces éléments, il est possible d'exprimer ce que l'on souhaite, c'est à dire traduire son XPath dans sa langue.

* La contrainte est indiqué par `<assert test="">son expression en langage naturel</assert>`.
* L'observation se fait avec l'élément `<report test=""  role="warn">expression de l'observation</report>`.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:pattern>
        <sch:rule context="pdv">
            <sch:assert test="@id">Un élément <sch:name/> doit contenir un attribut @id.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="prix">
            <sch:report test="not(contains(@prix, '€'))" role="warn">
                Le prix devait peut-être indiqué une monnaie.</sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>
```

Vous pouvez voir cet exemple en ajoutant au document XML `PDV-pour-sch.xml`, le schematron `05-schematron/exemple-01.sch`.

---
## Exercice

Reprendre le document `PDV.xml` et exprimer les contraintes et observations suivantes

1. contrainte : un élément `fermeture` ne peut contenir de texte
2. contrainte : vérifier que l'ouverture a toujours un début et une fin
3. observation : les points de vente sont ouverts tous les jours, devraient prendre des vacances
4. observation : les noms des villes devraient être tous en majuscule pour la consistance

---
## Schematron avancé

### Définition de variables

Il est possible de déclarer des variables pour éviter de répeter des requêtes XPath.

On utilise l'élément `let` sur lequel on ajoute deux attributs : `@name` pour nommer la variable et `@value` pour indiquer sa valeur.

```xml
<let name="pdv" value="/pdv_liste/pdv"

<assert test="$pdv/count(prix) >= 1 ">Il faut avoir au moins un prix</assert>
```
---
### Règles abstraites

Les règles abstraites sont employées pour éviter de répéter une règle. On va pouvoir employer la même règle sur plusieurs contexte en ne la définissant qu'une seule fois.

Il s'agit à nouveau d'un élément `<rule` qui va cette fois contenir deux nouveaux attributs. L'attribut `@abstract="true"` et un attribut `@id`.

Ensuite, on pourra appeler cette règle en l'appelant avec son id dans la balise `<extends rule="id_de_la_règle"/>`

```xml
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    <sch:pattern>
        <sch:rule abstract="true" id="contient-id">
            <sch:assert test="self::*[@id]">L'élément <sch:name/> doit avoir un attribut @id.</sch:assert>
        </sch:rule>
        
        <sch:rule context="pdv">
            <sch:extends rule="contient-id"/>
            <sch:assert test="./services">L'élément "pdv" doit contenir des services.</sch:assert>
        </sch:rule>
        
        <sch:rule context="prix">
            <sch:extends rule="contient-id"/>
        </sch:rule>
    </sch:pattern>
</sch:schema>
```

Dans cet exemple, on définit une règle abstraite `contient-id` qui vérifie que l'élément courant (`self`) contient bien un attribut `@id`. Cette règle est ensuite appelée dans deux contextes différents : une fois sur l'élément `<pdv>` et une autre fois sur `<prix>`.

Le fichier exemple est `05-schematron/exemple-02.sch` à appliquer sur le document `05-schematron/PDV-pour-sch.xml`.

---
#### Blocs abstraits

Les blocs abstraits reprennent le concept des règles abstraites, sauf que cette fois on généralise le `pattern` entier, et non une règle.

La déclaration se fait avec un élément `<pattern>` contenant les attributs `@abstract="true"` et un attribut `@id`.

Le contenu de cet élément définit toujours les règles à appliquer, néanmoins au lieu de spécifier "en dur" un chemin ou une requête, nous allons pouvoir utiliser une variable. Ainsi, la valeur de l'attribut `@context` et celle de l'attribut `@test` seront des variables.

L'appel de bloc se fait en déclarant un nouveau `<pattern>` portant un attribut `@is-a` qui aura pour valeur l'attribut `@id` du bloc abstrait. Les variables sont appelées dans ce bloc avec un élément `<pattern>` qui a un attribut `@name` correspondant à une des variables déclarées et un attribut `@value` qui va contenir sa valeur.

```xml
<?xml-model href="exemple-03.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<livres>
    <livre id="01" isbn="001">
        <title>Un titre</title>
        <p>Un paragraphe</p>
    </livre>
    <livre id="01" isbn="001">
        <p>Un paragraphe</p>
    </livre>
    <livre isbn="001">
        <title>Un titre</title>
    </livre>
</livres>
```
sur lequel on applique

```xml
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
    
    <sch:pattern abstract="true" id="structure-minimale">
        <sch:rule context="$element">
            <sch:assert test="self::*[child::title and child::p]">L'élément <sch:name/> doit avoir deux enfants : title et p.</sch:assert>
            <sch:assert test="count($attrib) > 1">L'élément <sch:name/> doit contenir au moins deux attributs.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern is-a="structure-minimale" id="livre">
        <sch:param name="element" value="livre"/>
        <sch:param name="attrib" value="@*"/>
    </sch:pattern>
    
</sch:schema>
```

Notre noeud de contexte est représenté par la variable `$element`. Nos règles vont donc s'appliquer sur celui-ci. Ensuite, on déclare deux règles. Une pour tester que cet élément a bien deux enfants `<title>` et `<p>` et une autre pour vérifier qu'il y a bien deux attributs au moins.

Voir les documents `05-schematron/livres-sch.xml` et `05-schematron/exemple-03.sch`.

---
## Exercice

Sur le fichier `ROM.xml`.

1. Assurer vous que le document contient bien un `teiHeader` et un `text`
2. Définir une règle abstraite qui vérifie qu'un élément contient toujours un enfant paragraphe. Appliquer sur les éléments `sp` et `projectDesc`.
3. Créer un bloc abstrait pour vérifier que chaque `div` qui sont des actes contiennent un élément head et plusieurs scènes.