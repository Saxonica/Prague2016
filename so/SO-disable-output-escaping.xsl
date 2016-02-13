<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- see SO question: http://stackoverflow.com/questions/24986276/adding-a-br-tag-to-xml-then-displaying-via-xsl -->
    
    <xsl:output method="html" />
    
    <xsl:template match="/">
        <html>
            <body>
                <xsl:apply-templates select="scoreboard" />
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="scoreboard">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <thead>
                <tr>
                    <xsl:apply-templates select="header/item" />
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates select="rows/row" />
                
            </tbody>
        </table>
    </xsl:template>
    
    <xsl:template match="header/item">
        <th align="left">
            <xsl:value-of select="." />
        </th>
    </xsl:template>
    
    <xsl:template match="rows/row">
        <tr>
            <xsl:apply-templates select="item" />
        </tr>        
    </xsl:template>
    
    <xsl:template match="item">
        <td align="left">
            <xsl:value-of select="." disable-output-escaping="yes" />
        </td>        
    </xsl:template>
        
</xsl:stylesheet>