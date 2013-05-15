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
    
    <xsl:template name="attributeannotation">
        <xsl:param name="loc" select="."/>
        <xsl:choose>
            <xsl:when test="$loc/ancestor-or-self::image-info/change-history/change[agent!='script']">
                <!-- get all the unique named individuals in the metadata change history and emit the corresponding
                    person uris so that the annotation is attributed to them -->
                <xsl:for-each-group select="$loc/ancestor-or-self::image-info/change-history/change[agent != 'script']" group-by="agent">
                    <xsl:sort select="current-grouping-key()"/>
                    <xsl:variable name="personuri">
                        <xsl:call-template name="getpersonuri">
                            <xsl:with-param name="namestring" select="current-grouping-key()"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:if test="$personuri != ''">
                        <xsl:value-of select="$snt"/>
                        <xsl:text>oac:annotatedBy &lt;</xsl:text>
                        <xsl:value-of select="$personuri"/>
                        <xsl:text>&gt;</xsl:text>
                    </xsl:if>
                </xsl:for-each-group>
                <!-- find the last date a change was made according to the change history and emit that as the
                    annotated when -->
                <xsl:variable name="changes">            
                    <xsl:for-each select="$loc/ancestor-or-self::image-info/change-history/change[agent != 'script']">
                        <xsl:sort select="xs:date(date)"/>
                        <xsl:value-of select="date"/>
                        <xsl:text> </xsl:text>                                          
                    </xsl:for-each>
                </xsl:variable>
                <xsl:value-of select="$snt"/>
                <xsl:text>oac:annotatedAt "</xsl:text>
                <xsl:value-of select="format-dateTime( xs:dateTime(concat(tokenize(normalize-space($changes), ' ')[last()], 'T00:00:00.1-05:00')), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01].[f001][Z]')"/>
                <xsl:text>"</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>
                    <xsl:text>WARNING: no attributed changes in metadata for image </xsl:text>
                    <xsl:call-template name="getimageid"/>
                    <xsl:text>. No attribution added to annotation.</xsl:text>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>