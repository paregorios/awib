<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 8, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> paregorios</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template name="emitgeouri">
        <xsl:param name="context" select="ancestor-or-self::info[@type='isaw']/geography/photographed-place"/>
        <xsl:for-each select="$context">
            <xsl:variable name="trimmeduri" select="normalize-space(uri)"/>
            <xsl:variable name="cleanuri">
                <xsl:choose>
                    <xsl:when test="starts-with($trimmeduri, 'http://http://')">
                        <xsl:text>http://</xsl:text>
                        <xsl:value-of select="substring-after($trimmeduri, 'http://http://')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$trimmeduri"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="starts-with($cleanuri, 'http://pleiades.stoa.org/')">
                    <!-- <xsl:message>got pleiades uri = <xsl:value-of select="$cleanuri"/></xsl:message> -->
                    <xsl:choose>
                        <xsl:when test="ends-with($cleanuri, '#this')">
                            <xsl:value-of select="$cleanuri"/>
                        </xsl:when>
                        <xsl:when test="ends-with($cleanuri, '/')">
                            <xsl:value-of select="substring($cleanuri, 1, string-length($cleanuri)-1)"/>
                            <xsl:text>#this</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$cleanuri"/>
                            <xsl:text>#this</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="starts-with($cleanuri, 'http://')">
                    <xsl:value-of select="$cleanuri"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- assume it's an old-style batlas ID and try to look up the corresponding pleiades id -->
                    <xsl:variable name="lookup" select="document('../pleiades/batlasids-with-pids.xml')"/>
                    <xsl:variable name="result">
                        <xsl:text>http://pleiades.stoa.org/places/</xsl:text>
                        <xsl:value-of select="$lookup/descendant-or-self::row[baid=$cleanuri][1]/pid"/>
                        <xsl:text>#this</xsl:text>
                    </xsl:variable>
                    <xsl:value-of select="$result"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>
</xsl:stylesheet>