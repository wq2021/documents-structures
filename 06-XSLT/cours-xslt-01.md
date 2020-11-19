# XSLT

## Introduction

XSLT est un langage pour transformer les documents XML, soit dans le même format ou bien vers d'autres formats comme le HTML, PDF et texte.

Sa version actuelle est 3.0, sa spécification est disponible sur le site du [W3C](https://www.w3.org/TR/xslt-30/).

XSLT est lui-même un langage écrit en XML. Grâce à l'application d'un processeur XSLT, on va pouvoir générer d'autres documents dans des formalismes similaires ou différents.

Généralement, XSLT est utilisé pour transformer un document XML en HTML pour une visualisation sur le web. Ainsi, par défaut, les navigateurs peuvent faire office de processeur, mais ils ne tiennent compte que de la version 1 (voir le fichier `xml-xslt/exemple-navigateur.xsl`).

XSLT est un langage de règles. C'est-à-dire que l'on définit des règles (pattern) qui vont sélectionner dans votre document XML des noeuds sur lesquels on va interagir.

## Structure

Pour lier une feuille XSL à un document XML, il faut ajouter la ligne suivante sous l'entête du document XML.

```xml
<?xml-stylesheet type="text/xsl" href="chemin/vers/xsl/feuille.xsl"?>
```

### Racine

Un document XSL se compose d'une racine `<xsl:stylesheet>` qui est comprise dans l'espace de nom `xmlns:xsl="http://www.w3.org/1999/XSL/Transform"`. Il est possible d'ajouter un attribut `version="3.0"` pour spécifier la version à utiliser.

Ci-dessous, le document XSL créé par défaut avec Oxygen.

```xml
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    ...
    
</xsl:stylesheet>
```

`xmlns:xs="http://www.w3.org/2001/XMLSchema"` permet d'utiliser les datatypes définit par XML Schema. `exclude-result-prefixes="xs"` est une instruction pour ne pas inclure le préfixe de l'espace de nom du document dans la sortie. On peut supprimer tous les préfixes avec `exclude-result-prefixes="#all"` (attention aux effets de bord!).

### Template

Pour définir les règles à appliquer, il faut passer par un élément `<xsl:template match="xpath">`. La valeur de l'attribut `@match` est un XPath permettant de sélectionner les noeuds où seront appliqués nos actions.

```
<racine>
    <titre>Bonjour !</titre>
</racine>
```

```
<xsl:template match="racine">
    <html>
        <xsl:apply-templates />
    </html>
</xsl:template>
```

Dans cet exemple, je vais dire "sélectionne le noeud racine" ensuite écrit l'élément `<html>` puis continuer d'appliquer les autres règles avec `<xsl:apply-templates />`. Ainsi, on va obtenir le document suivant.

```
<html>
   Bonjour !
</html
```

#### Règles par défaut

Pourquoi l'élément `<para>` et son contenu ont-ils été supprimé ? Il existe ce que l'on appelle des *règles par défaut*.

Celles-ci permettent de traverser entièrement un document XML avec une feuille XSLT. Il s'agit de règles récursives, si elles n'existaient pas alors il faudrait indiquer la structure de votre document en entier !

Essayez en appliquant la feuille `xml-xslt/regles-par-defaut` sur un document XML. Vous verrez qu'aucune règle n'est spécifiée explicitement pourtant, un résultat est obtenu.

Pour en savoir plus (avec de meilleures explications) : [Why does XSLT output all text by default?](https://stackoverflow.com/questions/3360017/why-does-xslt-output-all-text-by-default/3378562#3378562).

#### Appel des templates

Dans l'exemple, nous avons vu l'instruction `<xsl:apply-templates />`, celle-ci permet d'indiquer au processeur d'appliquer d'autres règles. Si l'on ne précise pas d'attribut `@select` sur `<xsl:apply-templates />`, alors le processeur va continuer son chemin tout seul en appliquant les prochaines règles sur les enfants du noeud courant. Cependant, on peut lui préciser par où se déplacer avec l'attribut `@select`, `<xsl:apply-templates select="xpath/>`.

Soit le document XML

```
<racine>
    <titre>Bonjour !</titre>
    <para>Monde</para>
</racine>
```

sur lequel on applique la transformation 

```
<xsl:template match="racine">
    <html>
        <xsl:apply-templates select="titre"/>
    </html>
</xsl:template>
    
<xsl:template match="titre">
    <h1>
        <xsl:value-of select="."/>
    </h1>
    <xsl:apply-templates/>
</xsl:template>
    
<xsl:template match="para">
    <p><xsl:value-of select="."/></p>
</xsl:template>
```

Le résultat obtenue est

``` 
<html>
   <h1>Bonjour !</h1>Bonjour !
</html
```

Comme nous avons indiqué au processeur de sélectionner le `titre` avec `<xsl:apply-templates select="titre"/>`, notre `<xsl:template match="para"` a été ignoré.

Ainsi, **une règle déclarée n'est pas forcément matchée**. De plus, les templates ne s'appliquent pas forcément dans l'ordre d'écriture de la feuille XSL. Pour cela, voir le document `xml-xslt/exemple-01-inverse.xsl`.

Lorsque l'on applique un template et que celui-ci est *matché* alors, nous sommes dans son contexte, c'est à dire que ce noeud (le résultat de l'expression XPath) est accessible avec `.`.

### Sélectionner des valeurs

Pour sélectionner la valeur d'un noeud, il existe l'élément `<xsl:value-of select="XPath"/>`. La valeur de l'attribut `@select` est un XPath qui retournera la valeur évaluée.

```
<xsl:value-of select="./@id"/>
<xsl:value-of select="./text()"/>
<xsl:value-of select="./enfant[@id = '01']/@id + 2"/>
```

---
## Exercice

À partir de `xml-xslt/PDV-allege.xml`

1. Écrire une feuille XSL pour obtenir la structure HTML suivante

```
<html>
    <head>
        <title>Les points de vente</title>
    </head>
    <body/>
</html>
```

2. Ajouter dans le corps du HTML créé, la liste des villes en minuscule.

```
<body>
    <ul>
        <li>saint-denis-lès-bourgs</li>
        <li>bourg-en-bresse</li>
        ...
    </ul>
</body>
```

---
## Transformation d'identité

Bien souvent, on souhaite modifier qu'une seule partie du document. C'est à dire qu'une grande partie sera recopiée à l'identique.

Pour se faire, on peut utiliser ue transformation d'identité.

```
<xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
</xsl:template>
```

Ce template sélectionne n'importe quel noeud ou attribut, le recopie (`<xsl:copy>`) et s'applique à nouveau lui-même (par récursion) à tous les noeuds et attributs.

Avec XSLT version 3, on peut éviter d'écrire ce template en utilisant l'instruction `<xsl:mode on-no-match="deep-copy"`. La valeur de l'attribut `@on-no-match` peut prendre plusieurs valeurs :

* `deep-copy` : une copie du noeud et ses enfants 
* `shallow copy` : une copie simple, seulement le noeud courant
* `text-only-copy` : copie du texte
* `deep-skip` : on ignore le noeud et ses enfants
* `shallow-skip` : on ignore le noeud courant
* `fail` : une erreur

Exemple

```xml
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:mode on-no-match="deep-copy"/>
    
</xsl:stylesheet>
```

Ne pas oublier de changer la valeur de la version dans la racine !

## Supprimer un noeud

Pour supprimer un noeud (et ses enfants), il suffit de créer un template auto-fermé.

```
<xsl:template match="para"/>
```

Grâce à ce template, on va supprimer le noeud `para` ainsi que ses enfants.

## Créer un élément

Il faut se placer dans le contexte que l'on souhaite. Ensuite, on peut écrire directement des balises. Dans le fragment suivant, on écrit en dur la déclaration de l'élément`<html>`.

```
<xsl:template match="racine">
    <html>
        <xsl:apply-templates/>
    </html>
</xsl:template>
```

On peut aussi passer par une instruction XSL mais il est recommandé de ne pas l'utiliser, car cela alourdit la lecture.

```
<xsl:template match="racine">
    <xsl:element name="html">
        <xsl:apply-templates/>
    </xsl:element>
</xsl:template>
```

## Créer un attribut

La déclaration d'un attribut se fait comme pour les éléments, c'est à dire que l'on peut écrire directement dans l'élément les noms des attributs.

```
<xsl:template match="racine">
    <html lang="fre">
        <xsl:apply-templates/>
    </html>
</xsl:template>
```

Ou bien, en passant par une instruction XSL.

```
<xsl:template match="racine">
    <html lang="fre">
        <xsl:attribute name="lang">fre</xsl:attribute>
        <xsl:apply-templates/>
    </html>
</xsl:template>
```

On peut vouloir donner le résultat d'une expression XPath en valeur d'attribut, pour se faire on doit uiliser des `{}` pour dire au processeur d'évaluer la requête.

```
<xsl:template match="racine">
    <html lang="{upper-case('fre')}">
        <xsl:apply-templates/>
    </html>
</xsl:template>
```

Ici, l'expression `upper-case('fre')` sera évaluée par le processeur à cause des `{}`.

---
## Exercice

Reprendre `xml-xslt/PDV-allege.xml`.

Pour vous aider, il existe l'instruction `<xsl:message>Message pour debug</xsl:message>` qui vous permet d'afficher un message lors de l'exécutation de votre feuille. Pratique pour savoir ce qui se passe.

1. Reproduire le document mais en supprimant les service**s** (avec une transformation!)(Les services ne seront supprimés que de la sortie standard, pas du document original ...).
2. Reproduire le document mais cette fois en ajoutant un attribut `@taille` sur l'élément `ville` qui aura pour valeur la longueur de la chaine textuelle (`<ville taille="21">SAINT-DENIS-LèS-BOURG</ville>`)
3. Remplacer l'élément `<adresse>` par `<ADRESSE>`.
4. Modifier la valeur de l'attribut `@valeur` sur les prix en la multipliant par 0,001 et en lui ajoutant le signe `€` (`valeur="1.255€"`).

---
## Les conditions

### if

Il est possible d'utiliser une condition avec `<xsl:if test="">`. Cependant, il n'y a pas la contrepartie comme dans les autres langages avec le `else`.

```
<xsl:template match="racine">
    <xsl:if test="child::*">
        <xsl:text>Il y a des enfants</xsl:text>
    </xsl:if>
    
    <xsl:if test="not(child::*)">
        <xsl:text>Il n'y a pas d'enfants</xsl:text>
    </xsl:if>
</xsl:template>
```

Pour émuler le `else`, il faut passer par la négation de la condition.

### choose

La version 2.0 de XSLT a ajouté la condition de type `if elif else` avec l'instruction `<xsl:choose>`. Dans cet élément, il est possible de définir plusieurs choix avec `<xsl:when test="">` et un `else` avec `<xsl:otherwise>`. Le `<xsl:otherwise>` est optionnel.

```
<xsl:template match="racine">
    <xsl:choose>
        <xsl:when test="child::* and count(child::*) = 2">
            <xsl:text>Il y a exactement deux enfants</xsl:text>
        </xsl:when>
        <xsl:when test="child::*">
            <xsl:text>Il y a des enfants</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>Il n'y a pas d'enfants</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
```

On définit un test qui vérifie : 

- s'il y a exactement deux enfants
- s'il y a des enfants
- sinon, le reste

## Les espaces de nom

Une des erreurs courantes lorsque l'on travaille sur un document avec un espace de nom est justement de ne pas l'indiquer puis de se demander pourquoi rien ne passe.

Soit le document suivant

```
<racine xmlns="uri:namespace">
    <titre>Bonjour !</titre>
</racine>
```

et la feuille

```
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="racine">
        <html>
            <xsl:apply-templates/>
        </html>
    </xsl:template>

</xsl:stylesheet>
```

le résultat obtenue est

```
<?xml version="1.0" encoding="UTF-8"?>
Bonjour !
```

L'élément `<html>` n'apparaît pas dans notre sortie. Oxygen nous signale un warning (fenêtre en bas à droite).
> The source document is in namespace uri:namespace, but all the template rules match elements in no namespace (Use --suppressXsltNamespaceCheck:on to avoid this warning)

Notre document XML est contenu dans un espace de nom mais aucun de nos templates ne le contient. Il faut donc le préciser.

Modifions notre feuille XSL. Un espace de nom est ajouté à la racine `<xsl:stylesheet>` avec un préfixe `xmlns:my="uri:namespace"`. Cet espace de nom est le même que celui de notre document XML. L'ajout de cet espace de nom, nous permet de l'utiliser sur notre XPAth comme sur le premier `template`.

```
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:my="uri:namespace"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="my:racine">
        <html>
            <xsl:apply-templates/>
        </html>
    </xsl:template>
    
    <xsl:template match="titre">
        <h1>
            <xsl:value-of select="."/>
        </h1>
    </xsl:template>
    
</xsl:stylesheet>
```

En sortie : 

```
<html xmlns:my="uri:namespace">
   Bonjour !
</html
```

Le premier template de sélection de la racine a bien fonctionné car on a précise l'espace de nom. Néanmoins, le second template n'a lui rien donné car aucun espace de nom n'était utilisé.

Vous pouvez remarquer que XSLT ajoute l'espace de nom de notre document XML d'origine sur la sortie, il est possible de supprimer ce comportement avec l'attribut `exclude-result-prefixes="xs my"` sur la racine de la feuille XSL. Par défaut, Oxygen exclut le préfixe `xs`.

Rien ne vous empêche de déclarer un nouvel espace de nom dans votre document en sortie.

## Exercice

Transformer le document XML `xml-xslt/xml-pour-tei.xl` pour obtenir le même résultat que le document XML `xml-xslt/tei-sortie.xml` à l'aide d'une feuille XSL.