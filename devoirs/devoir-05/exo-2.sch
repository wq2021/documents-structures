<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <!-- question 1 -->
    <sch:pattern>
        <sch:rule context="/TEI">
            <sch:assert test="teiHeader and text">Le document contient bien un teiHeader et un text.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- question 2 -->
    
    <sch:pattern>
        <sch:rule abstract="true" id="element-paragraphe">
            <sch:assert test="count(./p)=1">Un élément contient toujours un enfant paragraphe.</sch:assert>
        </sch:rule>
        
        <sch:rule context="projectDesc">
            <sch:extends rule="element-paragraphe"/>
        </sch:rule>
    </sch:pattern>
    
    <!-- question 3 -->
    <sch:pattern abstract="true" id="div-head-scenes">
        
        <sch:rule context="$element">
            <sch:assert test="count(./head)=1"> L'élément <sch:name/> doit avoir un head.</sch:assert>
            <sch:assert test= "$type-div='act'" > Le type de cet élément est l'acte.</sch:assert>
            <sch:assert test= "count($sous-element) > 1" > Le nombre des sous-éléments sont plus que 1.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern is-a="div-head-scenes">
        <sch:param name="element" value="div"/>
        <sch:param name="type-div" value="@type"/>
        <sch:param name="sous-element" value="./div[@type='scene']"/>
    </sch:pattern>
    
    
</sch:schema>