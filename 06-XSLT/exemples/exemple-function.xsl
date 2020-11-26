<?xml version="1.0" encoding="UTF-8"?>
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