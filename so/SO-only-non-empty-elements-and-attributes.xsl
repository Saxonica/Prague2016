<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes" />
    <xsl:strip-space elements="*" />
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" />
        </xsl:copy>
    </xsl:template>
    
    <!-- remove empty elements, or empty elements with empty attribs -->
    <xsl:template match="*[not(.//text())][normalize-space(@*) = '']" />
    
</xsl:stylesheet>