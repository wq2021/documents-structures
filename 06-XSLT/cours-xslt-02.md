# XSLT suite

## Les boucles

### for-each

L'instruction `for-each` permets d'itérer à travers une séquence. Pratique par exemple lorsque l'on souhaite modifier un élément et recopier les attributs. Il est possible de trier les éléments en ajoutant `xsl:sort`.

Soit le fragment 

```
<alphabet id="01" n="4">
    <lettre>z</lettre>
    <lettre>f</lettre>
    <lettre>a</lettre>
    <lettre>y</lettre>
</alphabet>
```

où l'on applique

```
    <xsl:template match="/alphabet">

        <alphabet_tri>
            <xsl:for-each select="@*">
                <xsl:attribute name="{name(current())}" select="current()"/>
            </xsl:for-each>

            <xsl:for-each select="*">
                <xsl:sort select="current()" order="descending"/>
                <lettre>
                    <xsl:value-of select="current()"/>
                </lettre>
            </xsl:for-each>
        </alphabet_tri>

    </xsl:template>
```

```
<alphabet_tri id="01" n="4">
   <lettre>z</lettre>
   <lettre>y</lettre>
   <lettre>f</lettre>
   <lettre>a</lettre>
</alphabet_tri>
```

Dans cet exemple, on recopie les attributs présents sur `alphabet` sans les nommer explicitement. Dans la seconde boucle, on trie par ordre alphabétique décroissant les éléments `<lettre>`.

On accède à l'élément itéré avec l'instruction `current()`.

### for-each-group

La version 2.0 a apporté la possibilité de grouper les éléments au moment de l'itération avec `<xsl:for-each-group>`.

Pour une explication claire et bien détaillée avec des exemples, je vous invite à lire cet article [Grouping With XSLT 2.0](https://www.xml.com/pub/a/2003/11/05/tr.html).

## Les espaces de nom

La plupart des documents XML utilisent des espaces de nom. Il est important de toujours préciser celui-ci lors de l'écriture de sa feuille XSLT.

Il existe deux solutions pour se faire 

1. préciser dans la racine de la feuille XSLT un attribut `@xpath-default-namespace="URI"`. Ainsi, le processeur utilisera cette espace de nom pour toutes les requêtes XPath
2. préciser dans la racine de la feuille XSLT l'espace de nom explicitement avec un ou plusieurs attributs `@xmlns:prefixe="URI"`. Dans ce cas, les éléments pourront être sélectionnés en indiquant sur vos XPath le préfixe.

```
<racine xmlns="ns-uri">
    <titre>Bonjour</titre>
    <para>Du contenu.</para>
</racine>
```

```
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xmlns:t="ns-uri"
    version="2.0">

    <xsl:template match="t:racine">
        <result><xsl:apply-templates/></result>
    </xsl:template>
</xsl:stylesheet>
```

```
<result xmlns:t="ns-uri">    
    Bonjour
    Du contenu.
</result>
```

Ici, on précise que notre espace de nom est `xmlns:t="ns-uri"`. Le choix du préfixe est libre. Ensuite, ce préfixe est utilisé sur les requêtes XPath. Pour supprimer l'espace de nom en sortie, ajouter le préfixe dans l'attribut `@exclude-result-prefixes`.

## Les variables

Les variables se déclarent avec l'instruction `<xsl:variable name="">`. Dans l'attribut `@name`, on précise le nom de la variable. On peut indiquer son contenu de deux façons :

1. `<xsl:variable name="x" select="1"/>`
2. `<xsl:variable name="x">1</xsl:variable>`

Sa valeur peut-être un Xpath, un noeud ...

Attention, on ne modifie pas les variables une fois déclarées ! Elles sont *immuables*.

On appelle la valeur de la variable avec le `$nom-variable`.

Par exemple :

```
<xsl:variable name="x" select="1"/>
<xsl:value-of select="$x"/>
```

## Mécanismes d'import


Pour simplifier la complexité d'une feuille XSLT, ou bien pour réutiliser du code existant, il est possible d'utiliser le mécanisme d'import.

Il existe deux façons d'importer/inclure une feuille dans un autre.

### `<xsl:import>`

Cette instruction permet d'importer les templates (ou fonctions) d'une seconde feuille à l'intérieur d'une première. Elle est toujours **déclarée en haut** de la feuille XSL avec la syntaxe suivante `<xsl:import href="path/vers/xsl"/>`. L'attribut `@href` indique le chemin vers l'autre feuille.

Le fonctionnement est le suivant, si un template existe dans la feuille importée alors il sera exécuté sauf si celui-ci existe dans la feuille principale. En effet, il existe un système de priorisation dans l'exécution. Donc, on aura une exécution de la feuille 1 en priorité puis de la seconde.

Soit le document

```
<document>
    <titre>Premier titre</titre>
    <p>Du texte libre avec <e>une emphase</e> 
        sur du contenu.</p>
</document>
```

la feuille à importer `exemple-import-inline.xsl`

```
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="e">
        <b><xsl:value-of select="."/></b>
    </xsl:template>
    
</xsl:stylesheet>
```

et la feuille principale `exemple-import.xsl`

```
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="exemple-import-inline.xsl"/>
    
    <xsl:template match="document">
        <html>
            <xsl:apply-templates/>
        </html>
    </xsl:template>
    
    <xsl:template match="titre">
        <h1><xsl:value-of select="."/></h1>
    </xsl:template>
    
    <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
</xsl:stylesheet>
```

On obtient en sortie

```
<html>
   <h1>Premier titre</h1>
   <p>Du texte libre avec <b>une emphase</b> 
      sur du contenu.
   </p>
</html
```

Le template contenu dans `exemple-import-inline.xsl` a bien été importé. Pour voir les effets de priorité, vous pouvez ajouter un template dans `exemple-import.xsl` qui *match* l'élément `b` et voir le résultat obtenu.

### `<xsl:include>`

À la différence de `<xsl:import>`, `<xsl:include>` va littéralement inclure son contenu, c'est-à-dire tout ce qui est écrit dans l'élément racine `<xsl:stylesheet>`. Cela revient à *scotcher* deux feuilles ensemble.

Une des conséquences est qu'un template *matchant* un élément ne peut apparaître dans les deux feuilles. Ainsi, si une feuille définit un `<xsl:template match="e">` et l'autre feuille également, il y aura une erreur indiquant que la compilation est ambiguë.

Sa déclaration est `<xsl:include href="chemin/vers/xsl"/>`.

## Écrire un document

### Format de sortie

Il est possible de contrôler la sortie d'une transformation avec l'instruction `<xsl:output>`. L'ensemble des paramètres disponible est sur la documentation de [Saxon](https://www.saxonica.com/html/documentation/xsl-elements/output.html).

Grâce à celle-ci, on peut indiquer le type de documents que l'on souhaite en sortie comme du xml, du html, xhtml, etc. Il est aussi possible de choisir si le document doit être indenté ou non.

```
<xsl:output method="xml" indent="yes"/>
```

Produit un document xml indenté.

### Écriture

Jusqu'à présent, le document généré n'existait que dans la sortie standard d'Oxygen XML Editor. Il est possible de créer un document avec l'instruction `<xsl:result-document>`. L'ensemble des paramètres est disponible sur la documentation de [Saxon](https://www.saxonica.com/html/documentation/xsl-elements/result-document.html).

Pour écrire un document, il suffit d'encadrer son contenu avec `<xsl:result-document>`, le type de document généré est à indiquer dans l'attribut `@method` et le nom du document dans `@href`.

```
<xsl:template match="/">
    <xsl:result-document href="output.html" method="html">
        <html>
            <body>
                <h1><xsl:value-of select="./titre/string()"/></h1>                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:result-document>
</xsl:template>
```

Dans cet exemple, on va écrire un document HTML `output.html` en précisant que l'on souhaite un HTML en sortie.

## L'import d'autres feuilles

## Les fonctions

On peut définir ses propres fonctions en XSLT. Elles doivent toujours appartenir à un espace de nom, il faut donc penser à déclarer l'espace de nom à la racine de la feuille.

Sur une fonction, on peut préciser le type de données en entrée et en sortie. Ces valeurs sont celles définies par le datatype de XML Schema. C'est optionnel, cependant c'est une bonne pratique de le faire, car cela donne des informations supplémentaires lors de l'exécution de la fonction. Les messages d'erreurs seront alors plus clairs.

```
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
    xmlns:f="ma-fonction-uri">
    
    <xsl:function name="f:add" as="xs:integer">
        <xsl:param name="x" as="xs:integer" required="yes"/>
        <xsl:param name="y" as="xs:integer" required="yes"/>
        <xsl:value-of select="$x + $y"/>
    </xsl:function>
    
    <xsl:template match="/">
        <xsl:value-of select="f:add(1, 2)"/>        
    </xsl:template>
    
</xsl:stylesheet>
```

On déclare la fonction avec l'élément `<xsl:function>` auquel on ajoute deux attributs : `@name` pour le nom voulu (ne pas oublier l'espace de nom) et `@as` pour le type de données en retour de la fonction. Dans cet exemple, la fonction a pour nom `f:add` et pour retour de données `xs:integer`.

Sur cette fonction, on peut ajouter ou non des arguments avec l'élément `<xsl:param>`. Cet élément prend lui aussi un `@name` et un `@as`. On peut préciser si cet argument est optionnel avec `@required`.

On appelle la fonction simplement avec son nom donc `f:add(x, y)`.
