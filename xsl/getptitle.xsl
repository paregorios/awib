<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:spatial="http://geovocab.org/spatial#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 15, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> paregorios</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template name="getptitle">
        <xsl:param name="puri"/>
        <!-- supposedly saxon caches calls to document() with same uris, so hopefully this won't be as 
            irresponsible as it looks -->
        <xsl:if test="$puri != ''">
            <xsl:variable name="prdfuri">
                <xsl:value-of select="$puri"/>
                <xsl:text>/rdf</xsl:text>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="doc-available($prdfuri)">
                    <xsl:message>trying to retrieve "<xsl:value-of select="$prdfuri"/>"</xsl:message>
                    <xsl:for-each select="document($prdfuri)/descendant-or-self::spatial:Feature[1]/rdfs:label[1]">
                        <xsl:value-of select="normalize-space(normalize-unicode(., 'NFKC'))"/>
                        <xsl:message>     GOT: '<xsl:value-of select="normalize-space(normalize-unicode(., 'NFKC'))"/>'</xsl:message>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>ERROR: apparently "<xsl:value-of select="$prdfuri"/>" is not available</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

    </xsl:template>
</xsl:stylesheet>