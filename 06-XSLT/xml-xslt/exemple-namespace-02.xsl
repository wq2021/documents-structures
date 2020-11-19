<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:my="uri:namespace"
    exclude-result-prefixes="xs my"
    version="2.0">
    
    <xsl:template match="my:racine">
        <html>
            <xsl:apply-templates/>
        </html>
    </xsl:template>
    
    <xsl:template match="titre">
        <h1>
            <xsl:value-of select="."/>
        </h1>
    </xsl:template>
    
</xsl:stylesheet>