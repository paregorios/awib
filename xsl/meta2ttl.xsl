<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs math xd"
    version="3.0">

    <xsl:import href="stringvars.xsl"/>

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 7, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> Tom Elliott</xd:p>
            <xd:p>Convert AWIB XML descriptive metadata into RDF</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="image-info[status='ready' and license-release-verified='yes' and isaw-publish-cleared='yes' and starts-with(info[@type='isaw']/flickr-url, 'http://')]">
        <xsl:apply-templates select="info[@type='isaw']"/>       
    </xsl:template>
    
    <xsl:template match="info[@type='isaw']">
        <xsl:text>&lt;</xsl:text><xsl:value-of select="flickr-url"/><xsl:text>&gt; a foaf:Image</xsl:text>
        <xsl:apply-templates select="title"/>
        <xsl:apply-templates select="photographer"/>
    </xsl:template>
    
    <xsl:template match="title">
        <xsl:value-of select="$snt"/>
        <xsl:text>dcterms:title "</xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="photographer">
        <xsl:value-of select="$snt"/>
        <xsl:text>dcterms:creator [ a foaf:Person; foaf:Name "</xsl:text>
        <xsl:value-of select="normalize-space(given-name)"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="normalize-space(family-name)"/>
        <xsl:text>" ]</xsl:text>
    </xsl:template>
    
    <xsl:template match="*"/>
    
</xsl:stylesheet>