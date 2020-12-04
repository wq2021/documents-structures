declare function local:frequence($texte as xs:string) as element(mot)*{
    
    (: let $mots := distinct-values($texte) :)
    
    let $minuscules := lower-case($texte)
    let $ponc := "?><!.,=+-'"
    let $normalisation := translate($minuscules,$ponc,'')
    let $tokenisation := tokenize($normalisation,' ')
    
    for $mot in distinct-values($tokenisation)
    let $frequence := count($tokenisation[. = $mot])
    let $element := element mot {attribute frequence {$frequence},$mot}
    return $element
    
};

 let $phrase := "Une phrase pour tester la fonction La pour"
 let $resultat := <dictionnaire>{local:frequence($phrase)}</dictionnaire>
 return $resultat