<?xml version="1.0" encoding="UTF-8"?>
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