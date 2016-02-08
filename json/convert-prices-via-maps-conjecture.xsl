<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:jlib="http://saxonica.com/ns/jsonlib"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array" version="3.0">

  <xsl:param name="input"/>

  <xsl:output method="json"/>
  
  <xsl:import href="maps-and-arrays.xsl"/>
  
  <xsl:mode on-no-match="deep-copy"/>

  <xsl:template name="xsl:initial-template">
    <xsl:apply-templates select="json-doc($input)"/>
  </xsl:template>
  
  <xsl:template match=".[. instance of map(*)][.('tags') = 'ice']">
    <xsl:map>
      <xsl:sequence select="map:for-each(., function($k, $v){ map{$k : if ($k = 'price') then $v*1.1 else $v }})"/>
    </xsl:map>
  </xsl:template>
  
  <xsl:template match=".[. instance of array(*)]" mode="#all">
    <xsl:choose>
      <xsl:when test="array:size(.) = 0">
        <xsl:sequence select="[]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="head" as="item()*">
          <xsl:apply-templates select="array:head(.)" mode="#current"/>
        </xsl:variable>
        <xsl:variable name="tail" as="array(*)">
          <xsl:apply-templates select="array:tail(.)" mode="#current"/>
        </xsl:variable>
        <xsl:sequence select="array:join((array{$head}, $tail))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match=".[. instance of array(*)]">
    <xsl:sequence select="array:for-each(., jslib:apply-templates#1)"/>
  </xsl:template>
  
  <xsl:function name="jslib:apply-templates">
    <xsl:param name="input"/>
    <xsl:apply-templates select="$input"/>
  </xsl:function>
  </xsl:function>

<xsl:template match=".[. instance of map(*)]">
  <xsl:choose>
    <xsl:when test="map:size(.) eq 0">
      <xsl:map/>
    </xsl:when>
    <xsl:when test="map:size(.) eq 1">
      <xsl:variable name="key" select="map:keys(.)"/>
      <xsl:map-entry key="$key" select=".($key)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:map>
        <xsl:variable name="entries" as="map(*)*" select="map:for-each(., function($k : $v) { map:entry($k, $v) })"/>
        <xsl:apply-templates select="$entries"/>
      </xsl:map>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
  <xsl:function name="jlib:is-map-entry" as="xs:boolean">
    <xsl:param name="map" as="item()"/>
    <xsl:param name="key" as="xs:anyAtomicType"/>
    <xsl:sequence select=". instance of map(*) and map:size(*) eq 1 and map:contains($key)"/>
  </xsl:function>

</xsl:stylesheet>
