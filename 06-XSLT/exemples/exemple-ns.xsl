<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:t="ns-uri"
    version="2.0">

    <xsl:template match="t:racine">
        <xsl:variable name="x" select="t:titre"/>
        <result><xsl:apply-templates/>
        <xsl:value-of select="$x/data()"/></result>
    </xsl:template>
</xsl:stylesheet>
