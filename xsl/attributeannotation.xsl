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