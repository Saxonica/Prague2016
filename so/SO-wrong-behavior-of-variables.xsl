<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:snap="snap:snap">
    
    <!-- reference: http://stackoverflow.com/questions/24900353/in-xslt-is-it-normal-that-a-variable-set-to-something-like-name-is-computed -->
    <xsl:template match="snap">
        <xsl:for-each select="page/body/client/data_field/*">
            Direct name = <xsl:value-of select="name(.)"/> [correct, getting 'dog']
            <xsl:for-each select="*">
                <xsl:variable name="tab_name" select="name(..)"/>
                Parent name = <xsl:value-of select="$tab_name"/> [correct, getting 'dog']
                <xsl:message>Message has no side-effects... <xsl:value-of select="$tab_name"/></xsl:message>
                <xsl:for-each select="/snap/page/body/client/group">
                    Inside other for-each tab_name = <xsl:value-of select="$tab_name"/> [incorrect, getting 'client']
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>