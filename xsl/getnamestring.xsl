<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 15, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> paregorios</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template name="getnamestring">
        <xsl:param name="loc" select="."/>
        <xsl:choose>
            <xsl:when test="name">
                <xsl:value-of select="normalize-space(normalize-unicode($loc/name, 'NFKC'))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(normalize-unicode($loc/given-name, 'NFKC'))"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="normalize-space(normalize-unicode($loc/family-name, 'NFKC'))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>