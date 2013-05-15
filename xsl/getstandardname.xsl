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
    
    <xsl:variable name="lookup">../persons/personlookup.xml</xsl:variable>
    <xsl:template name="getstandardname">
        <xsl:param name="namestring"/>
        <xsl:variable name="cleannamestring" select="normalize-space(normalize-unicode($namestring, 'NFKC'))"/>
        <xsl:choose>
            <xsl:when test="$cleannamestring = '' or $cleannamestring = ' '">
                <xsl:message>WARNING: getstandardname called with empty namestring</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="doc-available($lookup)">
                        <xsl:choose>
                            <xsl:when test="document($lookup)/descendant::name[namestring=$cleannamestring]">
                                <xsl:for-each select="document($lookup)/descendant::name[namestring=$cleannamestring][1]">
                                    <xsl:choose>
                                        <xsl:when test="standardname">
                                            <xsl:value-of select="standardname"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="namestring"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>                                
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:message>WARNING: getstandardname could not find a correspondence in lookup so using raw namestring "<xsl:value-of select="$cleannamestring"/>"</xsl:message>
                                <xsl:value-of select="$cleannamestring"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>ERROR: unable to get lookup document <xsl:value-of select="$lookup"/></xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>