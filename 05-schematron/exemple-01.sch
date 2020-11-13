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