<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    exclude-result-prefixes="xsl">
    
    <!--
        From: http://stackoverflow.com/questions/25366268/xslt-use-one-template-for-attribute-by-value-and-another-for-the-parent-nod
    -->
    
    <xsl:output omit-xml-declaration="yes" />
    
    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="*[@rend='italics']">
        <italics><xsl:apply-templates /></italics>
    </xsl:template>
    
    <xsl:template match="title" priority="2">
        <title><xsl:next-match /></title>
    </xsl:template>
    
</xsl:stylesheet>