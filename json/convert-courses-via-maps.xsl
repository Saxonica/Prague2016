<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="3.0"
  xmlns="http://www.w3.org/2005/xpath-functions"
  xpath-default-namespace="http://www.w3.org/2005/xpath-functions"
  expand-text="yes">

  <xsl:param name="input"/>
  
  <xsl:output method="json"/>
  
  <xsl:template name="xsl:initial-template">
    <xsl:variable name="input-as-array" select="json-doc($input)" as="array(*)"/>
    <xsl:variable name="flattened" as="map(*)*">
      <xsl:for-each select="$input-as-array?*?courses?*">
        <xsl:variable name="course" select="?course"/>
        <xsl:for-each select="?students?*">
          <xsl:map>
            <xsl:map-entry key="'course'" select="$course"/>
            <xsl:map-entry key="'last'" select="?last"/>
            <xsl:map-entry key="'first'" select="?first"/>
            <xsl:map-entry key="'email'" select="?email"/>
          </xsl:map>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="groups" as="map(*)*">
      <xsl:for-each-group select="$flattened" group-by="?email">
        <xsl:sort select="?last"/>
        <xsl:sort select="?first"/>
        <xsl:map>
          <xsl:map-entry key="'email'" select="current-grouping-key()"/>
          <xsl:map-entry key="'courses'" select="array{ current-group()?course }"/>
        </xsl:map>
      </xsl:for-each-group>
    </xsl:variable>
    <xsl:sequence select="array{$groups}"/>
  </xsl:template>
 
</xsl:stylesheet>