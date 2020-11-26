<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="services"/>
     
     <xsl:template match="ville">
         <xsl:copy>
             <xsl:attribute name="taille"><xsl:value-of select="string-length(.)"/></xsl:attribute>
             <xsl:apply-templates/>
         </xsl:copy>
     </xsl:template>
    
    <xsl:template match="adresse">
        <ADRESSE>
            <xsl:apply-templates/>
        </ADRESSE>
    </xsl:template>
    
    <xsl:template match="prix/@valeur">
        <xsl:attribute name="valeur"><xsl:value-of select="concat(round(. * 0.001, 3), '€')"/></xsl:attribute>
    </xsl:template>
     
</xsl:stylesheet>