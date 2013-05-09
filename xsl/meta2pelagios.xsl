<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:foo="my.foo.org"
    exclude-result-prefixes="xs math xd"
    version="2.0">

<!-- 
    Filename: meta2pelagios.xsl
    Title: AWIB Converter XSLT: Metadata to Pelagios Annotations
    By: Tom Elliott
    Created on: May 7, 2013
    Source URL: https://github.com/paregorios/awib/blob/master/xsl/meta2pelagios.xsl
    Copyright: 2013 New York University
    License: This work is licensed under a Creative Commons Attribution 3.0 United States License: 
        http://creativecommons.org/licenses/by/3.0/us/
    Description: This XSLT crawls through a directory full of XML metadata files for the Ancient
        World Image Bank. It opens each such file and writes corresponding RDF annotations to the
        text output. These annotations are intended primarily for use with the Pelagios Project
        network (http://pelagios-project.blogspot.com/) and use information in the metadata to
        describe relationships between the AWIB images and historical/archaeological places from
        the ancient world as cataloged by the Pleiades Project (http://pleiades.stoa.org). The 
        format of the AWIB metadata files is idiosyncratic and undocumented, but conforms to a 
        schema (https://github.com/paregorios/awib/blob/master/meta/meta-schema.rnc).
        The annotations emitted conform to the Open Annotation Data Model, Community Draft, 
        8 February 2013 (http://www.openannotation.org/spec/core/20130208/index.html) and to 
        Pelagios guidance for "Publishing as RDF" as current on 7 May 2013 (see:
        https://github.com/pelagios/pelagios-cookbook/wiki/How-Can-I-Join%3F#3-publishing-as-rdf).
        Where the OA Data Model and the Pelagios guidance are in conflict, this script defers
        to the OA Data Model (which is more recent than the last revision of the Pelagios
        guidance). All the annotations are output in a single, large file using the Turtle
        syntax and UTF-8 character encodings.    
    -->
    
    <xsl:import href="stringvars.xsl"/>
    <xsl:import href="getimageid.xsl"/>
    <xsl:import href="emitgeouri.xsl"/>
    
    <xsl:param name="sourcedir">../meta/</xsl:param>
    <xsl:param name="awibbaseuri">http://isaw.nyu.edu/awib/images/</xsl:param>
    <xsl:param name="agenturi">https://github.com/paregorios/awib/blob/master/xsl/meta2pelagios.xsl</xsl:param>
    <xsl:param name="agentname">meta2pelagios</xsl:param>
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:variable name="collquery">
        <xsl:value-of select="$sourcedir"/>
        <xsl:text>?select=*.xml</xsl:text>
    </xsl:variable>
    
    <xsl:template name="makep">
        <xsl:call-template name="prefixes"/>
        <xsl:value-of select="$n"/>
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="$agenturi"/>
        <xsl:text>&gt; a prov:SoftwareAgent</xsl:text>
        <xsl:value-of select="$snt"/>
        <xsl:text>foaf:name "</xsl:text>
        <xsl:value-of select="$agentname"/>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="$pn"/>
        <xsl:text>&lt;urn:awib:types:flickrpage&gt; a dcterms:MediaTypeOrExtent</xsl:text>
        <xsl:value-of select="$snt"/>
        <xsl:text>rdf:value "text/html"</xsl:text>
        <xsl:value-of select="$snt"/>
        <xsl:text>rdfs:label "HTML"</xsl:text>
        <xsl:value-of select="$pn"/>
        <xsl:value-of select="$n"/>
        <xsl:message>trying "<xsl:value-of select="$collquery"/>"</xsl:message>
        <xsl:for-each select="collection($collquery)">
            <!-- <xsl:message>INFO: generating Pelagios RDF from <xsl:value-of select="document-uri(.)"/></xsl:message> -->
            <xsl:apply-templates select="./descendant-or-self::image-info"/>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template match="image-info[status='ready' and license-release-verified='yes' and isaw-publish-cleared='yes' and starts-with(info[@type='isaw']/flickr-url, 'http://') and string-length(info[@type='isaw']/geography/photographed-place/uri)&gt;0]">
        <xsl:apply-templates select="info[@type='isaw']"/>
        <xsl:value-of select="$n"/>        
        <xsl:value-of select="$n"/>        
    </xsl:template>
    
    <xsl:template match="info[@type='isaw']">
        <xsl:variable name="imageid">
            <xsl:call-template name="getimageid"/>
        </xsl:variable>
        
        <xsl:variable name="latest">
            <xsl:for-each select="ancestor-or-self::image-info/change-history/change">
                <xsl:sort select="date" order="descending" />
                <xsl:if test="position() = 1">
                    <xsl:value-of select="date"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="oaid">
            <xsl:value-of select="$awibbaseuri"/>
            <xsl:value-of select="$imageid"/>
            <xsl:text>/anno/</xsl:text>
            <xsl:value-of select="$latest"/>
        </xsl:variable>
        
        <xsl:variable name="photouri">
            <xsl:variable name="url" select="//info[@type='isaw']/flickr-url"/>
            <xsl:choose>
                <xsl:when test="contains($url, '/in/set')">
                    <xsl:value-of select="substring-before($url, '/in/set')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$url"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="geouri">
            <xsl:call-template name="emitgeouri">
                <xsl:with-param name="context" select="geography/photographed-place"/>
            </xsl:call-template>
        </xsl:variable>
        
        <!-- write the annotation -->
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="$oaid"/>
        <xsl:text>&gt; a oac:Annotation</xsl:text>
        
        <xsl:value-of select="$snt"/>
        <xsl:text>oac:hasBody </xsl:text>
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="$geouri"/>
        <xsl:text>&gt;</xsl:text>
        
        <xsl:value-of select="$snt"/>
        <xsl:text>oac:hasTarget </xsl:text>
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="$photouri"/>
        <xsl:text>&gt;</xsl:text>
        
        <xsl:value-of select="$snt"/>
        <xsl:text>oac:serializedBy </xsl:text>
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="$agenturi"/>
        <xsl:text>&gt;</xsl:text>
        
        <xsl:value-of select="$snt"/>
        <xsl:text>oac:serializedAt </xsl:text>
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="current-dateTime()"/>
        <xsl:text>&gt;</xsl:text>
        
        <xsl:value-of select="$pn"/>
        
        <!-- indicate the types -->
        <xsl:value-of select="$n"/>
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="$photouri"/>
        <xsl:text>&gt; a dctypes:Image</xsl:text>
        <xsl:value-of select="$snt"/>
        <xsl:text>dcterms:format &lt;urn:awib:types:flickrpage&gt;</xsl:text>
        <xsl:value-of select="$pn"/>
        <xsl:value-of select="$n"/>
        
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
    
    <xsl:template match="license[.!='']">
        <xsl:value-of select="$snt"/>
        <xsl:text>dcterms:license </xsl:text>
        <xsl:choose>
            <xsl:when test=".='cc-by'">
                <xsl:text>&lt;http://creativecommons.org/licenses/by/3.0/us/&gt;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="date-photographed">
        <xsl:choose>
            <xsl:when test=".!=''">
                <xsl:value-of select="$snt"/>
                <xsl:text>dcterms:date "</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>"</xsl:text>
            </xsl:when>
            <xsl:when test=".='' and ../date-scanned!=''">
                <xsl:value-of select="$snt"/>
                <xsl:text>dcterms:date "</xsl:text>
                <xsl:value-of select="../date-scanned"/>
                <xsl:text>"</xsl:text>            
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="description">
        <xsl:value-of select="$snt"/>
        <xsl:text>dcterms:description "</xsl:text>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="geography">
        <xsl:apply-templates select="photographed-place"/>
    </xsl:template>
    
    <xsl:template match="photographed-place[starts-with(uri, 'http://pleiades.stoa.org')]">
        <xsl:value-of select="$snt"/>
        <xsl:text>foaf:depicts &lt;</xsl:text>
        <xsl:value-of select="uri"/>
        <xsl:if test="not(ends-with(uri, '#this'))">#this</xsl:if>
        <xsl:text>&gt;</xsl:text>
    </xsl:template>
    
    <xsl:template match="typology[count(keyword)!=0]">
        <xsl:value-of select="$snt"/>
        <xsl:text>dcterms:subject </xsl:text>
        <xsl:for-each select="keyword">
            <xsl:if test="preceding-sibling::keyword">
                <xsl:value-of select="$cntt"/>
            </xsl:if>
            <xsl:text>&lt;http://www.flickr.com/photos/tags/</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>&gt;</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="*"/>
    
    <xsl:template name="contributors">
        <xsl:value-of select="$snt"/>
        <xsl:text>dcterms:contributor </xsl:text>
        <xsl:for-each select="//change-history/change[agent != 'script' and normalize-space(normalize-unicode(agent, 'NFKC')) != '' and normalize-space(normalize-unicode(agent, 'NFKC')) != ' ']">
            <xsl:variable name="thisagent" select="normalize-space(normalize-unicode(agent, 'NFKC'))"/>
            <xsl:if test="not(preceding-sibling::change[normalize-space(normalize-unicode(agent, 'NFKC')) = $thisagent])">
                <xsl:if test="preceding-sibling::change[1][agent != 'script' and normalize-space(normalize-unicode(agent, 'NFKC')) != $thisagent]">
                    <xsl:value-of select="$cntt"/>
                </xsl:if>
                <xsl:text>&lt;urn:awib:person:</xsl:text>
                <xsl:value-of select="foo:checksum($thisagent)"/>
                <xsl:text>&gt;</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="photographers">
        <xsl:if test="./descendant-or-self::info[@type='isaw']/photographer[*[1]!='']">
            <xsl:value-of select="$snt"/>
            <xsl:text>dcterms:creator </xsl:text>
            <xsl:for-each select="//info[@type='isaw']/photographer">
                <xsl:if test="preceding-sibling::photographer">
                    <xsl:value-of select="$cntt"/>
                </xsl:if>
                <xsl:variable name="thisphotographer">
                    <xsl:choose>
                        <xsl:when test="name">
                            <xsl:value-of select="normalize-space(normalize-unicode(name, 'NFKC'))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(normalize-unicode(given-name, 'NFKC'))"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="normalize-space(normalize-unicode(family-name, 'NFKC'))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:text>&lt;urn:awib:person:</xsl:text>
                <xsl:value-of select="foo:checksum($thisphotographer)"/>
                <xsl:text>&gt;</xsl:text>
            </xsl:for-each>
        </xsl:if>

    </xsl:template>
    
    <xsl:template name="people">
        <xsl:for-each select="//info[@type='isaw']/photographer">
            <xsl:variable name="thisphotographer">
                <xsl:choose>
                    <xsl:when test="name">
                        <xsl:value-of select="normalize-space(normalize-unicode(name, 'NFKC'))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(normalize-unicode(given-name, 'NFKC'))"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(normalize-unicode(family-name, 'NFKC'))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>            
            <xsl:value-of select="$n"/>
            <xsl:text>&lt;urn:awib:person:</xsl:text>
            <xsl:value-of select="foo:checksum($thisphotographer)"/>
            <xsl:text>&gt; a foaf:Person</xsl:text>
            <xsl:value-of select="$snt"/>
            <xsl:text>foaf:name "</xsl:text>
            <xsl:choose>
                <xsl:when test="name">
                    <xsl:value-of select="normalize-space(normalize-unicode(name, 'NFKC'))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(normalize-unicode(given-name, 'NFKC'))"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="normalize-space(normalize-unicode(family-name, 'NFKC'))"/>
                </xsl:otherwise>
            </xsl:choose>            
            <xsl:text>" </xsl:text>
            <xsl:value-of select="$p"/>
        </xsl:for-each>
        <xsl:for-each select="//change-history/change[agent != 'script']">
            <xsl:variable name="thisagent" select="normalize-space(normalize-unicode(agent, 'NFKC'))"/>
            <xsl:if test="not(preceding-sibling::change[normalize-space(normalize-unicode(agent, 'NFKC')) = $thisagent])">
                <xsl:value-of select="$n"/>
                <xsl:text>&lt;urn:awib:person:</xsl:text>
                <xsl:value-of select="foo:checksum($thisagent)"/>
                <xsl:text>&gt; a foaf:Person</xsl:text>
                <xsl:value-of select="$snt"/>
                <xsl:text>foaf:name "</xsl:text>
                <xsl:value-of select="$thisagent"/>
                <xsl:text>" </xsl:text>
                <xsl:value-of select="$p"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="prefixes">
        <xsl:text>@prefix dcterms: &lt;http://purl.org/dc/terms/&gt;.</xsl:text>
        <xsl:value-of select="$n"/>
        <xsl:text>@prefix foaf: &lt;http://xmlns.com/foaf/0.1/&gt;.</xsl:text>
        <xsl:value-of select="$n"/>
        <xsl:text>@prefix oac: &lt;http://www.openannotation.org/ns/&gt;.</xsl:text>
        <xsl:value-of select="$n"/>
        <xsl:text>@prefix prov: &lt;http://www.w3.org/ns/prov#&gt;.</xsl:text> 
        <xsl:value-of select="$n"/>
        <xsl:text>@prefix rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;.</xsl:text>
        <xsl:value-of select="$n"/>
        <xsl:text>@prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;.</xsl:text>
        <xsl:value-of select="$n"/>
    </xsl:template>
    
    <xd:doc scope="following functions">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> July 19, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> Lars Huttar</xd:p>
            <xd:p>http://stackoverflow.com/questions/6753343/using-xsl-to-make-a-hash-of-xml-file</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:function name="foo:checksum" as="xs:int">
        <xsl:param name="str" as="xs:string"/>
        <xsl:variable name="codepoints" select="string-to-codepoints($str)"/>
        <xsl:value-of select="foo:fletcher16($codepoints, count($codepoints), 1, 0, 0)"/>
    </xsl:function>
    
    <xsl:function name="foo:fletcher16">
        <xsl:param name="str" as="xs:integer*"/>
        <xsl:param name="len" as="xs:integer" />
        <xsl:param name="index" as="xs:integer" />
        <xsl:param name="sum1" as="xs:integer" />
        <xsl:param name="sum2" as="xs:integer"/>
        <xsl:choose>
            <xsl:when test="$index ge $len">
                <xsl:sequence select="$sum2 * 256 + $sum1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="newSum1" as="xs:integer"
                    select="($sum1 + $str[$index]) mod 255"/>
                <xsl:sequence select="foo:fletcher16($str, $len, $index + 1, $newSum1,
                    ($sum2 + $newSum1) mod 255)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>