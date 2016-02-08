<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:jlib="http://saxonica.com/ns/jsonlib"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:array="http://www.w3.org/2005/xpath-functions/array" version="3.0">

  <xsl:param name="input"/>

  <xsl:output method="json"/>

  <xsl:template name="xsl:initial-template">
    <xsl:variable name="input-as-array" select="json-doc($input)" as="array(*)"/>
    <xsl:sequence
      select="
      json-doc($input) 
      => jlib:update-array( 
           function($in){ $in('tags')?* = 'ice' },
           function($in){ $in => jlib:update-map( 'price', function($val) { $val * 1.1 })})"
    />
  </xsl:template>

  <xsl:function name="jlib:update-array" as="array(*)">
    <xsl:param name="in" as="array(*)"/>
    <xsl:param name="select" as="function(item()*) as xs:boolean"/>
    <xsl:param name="change" as="function(item()*) as item()*"/>
    <xsl:choose>
      <xsl:when test="array:size($in) = 0">
        <xsl:sequence select="[]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="first" as="array(*)">
          <xsl:sequence select="array{if ($select($in(1))) then $change($in(1)) else $in(1)}"/>
        </xsl:variable>
        <xsl:sequence select="array:join(($first, jlib:update-array(array:tail($in), $select, $change)))"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>

  <xsl:function name="jlib:update-map" as="map(*)">
    <xsl:param name="in" as="map(*)"/>
    <xsl:param name="key" as="xs:string"/>
    <xsl:param name="change" as="function(item()*) as item()*"/>
    <xsl:map>
      <xsl:for-each select="map:keys($in)">
        <xsl:map-entry key="." select="if (.=$key) then $change($in(.)) else $in(.)"/>
      </xsl:for-each>
    </xsl:map>
  </xsl:function>

</xsl:stylesheet>
