<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- see SO question: http://stackoverflow.com/questions/25012755/converting-an-xml-document-to-csv-with-both-its-attributes-and-data-through-xslt -->
    
    <xsl:strip-space elements="*"/>
    <xsl:output method='text'/>
    
    <xsl:template match="/">        
        <xsl:apply-templates select="catalog/book"/>
    </xsl:template>
    
    <xsl:template match="book">
        <xsl:value-of select="@id"/>
        <xsl:text>,</xsl:text>
        <xsl:apply-templates select="*" />
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
    
    <!-- with a comma in the field, quote it -->
    <xsl:template match="*[contains(text(), ',')]">
        <xsl:text>"</xsl:text>
        <!-- use normalize-space, otherwise fields will span multiple lines -->
        <xsl:value-of select="normalize-space(.)" />
        <xsl:text>"</xsl:text>
        
        <!-- no comma after the last field -->
        <xsl:if test="following-sibling::*">,</xsl:if>
    </xsl:template>

    <!-- without a comma -->
    <xsl:template match="*">
        <xsl:value-of select="normalize-space(.)" />
        <xsl:if test="following-sibling::*">,</xsl:if>
    </xsl:template>
</xsl:stylesheet>