<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Les points de vente</title>
            </head>
            <body>
                <ul>
                <xsl:apply-templates select="pdv_liste/pdv/ville"/>
                </ul>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="ville">
        <li><xsl:value-of select="lower-case(.)"/></li>
    </xsl:template>
    
    
</xsl:stylesheet>