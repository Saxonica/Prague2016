<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" 
    version="2.0">
    
    <xsl:strip-space elements="*" />
    
    <xsl:output indent="yes" />
    
    <xsl:variable name="patterns" as="xs:string*">
        <xsl:sequence select="(
            'foo/bar',
            'foo/test',
            'foo/bar/zed')" />
    </xsl:variable>

    <xsl:template match="node()[true() = (
        for $p in $patterns 
        return ends-with(
            string-join(current()/ancestor-or-self::*/name(), 
            '/'), $p)
        )]" priority="10">
        <xsl:copy>
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()" />
    
</xsl:stylesheet>