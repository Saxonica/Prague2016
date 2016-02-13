<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
    
    <xsl:output indent="yes" />
    
    <xsl:variable name="uiRules" select="document('UIDLRules.xml')" />
    
    <xsl:variable name="excl" select="$uiRules/*/*/*/exclude/members/member/data(@name)" />
    
    <xsl:variable name="sorted">
        <xsl:variable name="unsorted" as="element()*">
            <xsl:apply-templates />
        </xsl:variable>
        <xsl:for-each select="$unsorted">
            <xsl:sort select="@sequence" order="descending" />
            <xsl:copy-of select="." />
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:variable name="test">
            <table>
                <tr>
                    <td width="100%"><p>x</p>
                    </td>
                    <td width="20%"><p>x</p></td>
                </tr>
            </table>
        </xsl:variable>
        <xsl:variable name="numb" as="xs:integer*">
            <xsl:for-each select="$test//tr/td[@width]">
                <xsl:value-of select="number(translate(@width,'%',''))"/>
            </xsl:for-each>
        </xsl:variable>
        <p>
            <xsl:value-of select="sum($numb)"/>
        </p>
        <xsl:copy-of select="$sorted" />
    </xsl:template>
    
    <xsl:template match="text()" />
    
    <xsl:template match="member[not(@name = $excl)]">
        <xsl:copy>
            <xsl:apply-templates select="@name" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@name">
        <xsl:copy />
        <xsl:copy-of select="$uiRules/*/*/*/members/member[@name = current()]/@sequence" />
    </xsl:template>

</xsl:stylesheet>