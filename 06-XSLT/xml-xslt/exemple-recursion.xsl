<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- ne pas lancer ! cela montre la récursion -->
    <xsl:template match="racine">
        <html>
            <xsl:apply-templates select="titre"/>
        </html>
    </xsl:template>
    
    <xsl:template match="titre">
        <h1>
            <xsl:value-of select="."/>
        </h1>
        <xsl:apply-templates select="parent::racine"/>
    </xsl:template>
    
    
</xsl:stylesheet>