<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xml" indent="yes"/>

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

</xsl:stylesheet>
