<?xml version="1.0" encoding="UTF-8"?>
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