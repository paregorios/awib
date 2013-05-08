<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0">
    
    <xsl:import href="stringvars.xsl"/>
    
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 8, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> paregorios</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:param name="sourcedir">../meta/</xsl:param>
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:variable name="collquery">
        <xsl:value-of select="$sourcedir"/>
        <xsl:text>?select=*.xml</xsl:text>
    </xsl:variable>
    
    <xsl:template name="getbids">
        <xsl:message>trying "<xsl:value-of select="$collquery"/>"</xsl:message>
        <xsl:for-each select="collection($collquery)">
            <xsl:message>INFO: finding BAtlas ids in <xsl:value-of select="document-uri(.)"/></xsl:message>
            <xsl:apply-templates select="./descendant-or-self::image-info/info[@type='isaw']/descendant::uri"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="uri[. != '' and contains(., '-')]">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:value-of select="$n"/>
    </xsl:template>
    <xsl:template match="*"/>
    
    
</xsl:stylesheet>