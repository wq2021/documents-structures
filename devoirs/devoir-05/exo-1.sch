<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:pattern>
        <sch:rule context="fermeture">
            <sch:assert test="not[text()]">L'élément <sch:name/> ne peut contenir de texte.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="ouverture">
            <sch:assert test="@debut and @fin">vérifier que l'ouverture a toujours un début et une fin.</sch:assert>
        </sch:rule>
    </sch:pattern>  
    
    <sch:pattern>
        <sch:rule context="pdv">
            <sch:report test="ouverture/@saufjour=''" role="warn">
                les points de vente sont ouverts tous les jours, devraient prendre des vacances</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="ville">
            <sch:report test="text()=upper-case(text())" role="warn">
                les noms des villes devraient être tous en majuscule pour la consistance</sch:report>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>