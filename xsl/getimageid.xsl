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
    
    <xsl:template name="getimageid">
        <xsl:variable name="mfilepath" select="ancestor-or-self::image-info/image-files/image[@type='master']/@href"/>
        <xsl:variable name="mfilename" select="tokenize($mfilepath, '/')[last()]"/>
        <xsl:value-of select="tokenize($mfilename, '-')[2]"/>
    </xsl:template>
</xsl:stylesheet>