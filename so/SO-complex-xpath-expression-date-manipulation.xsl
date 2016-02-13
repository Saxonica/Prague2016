<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cs="http://cs"
    xmlns:ext="urn:schemas-microsoft-com:xslt"
    exclude-result-prefixes="ext cs"
    version="1.0">
    
    <xsl:output indent="yes" omit-xml-declaration="yes" />
    
    <!--
        Related to SO question
        http://stackoverflow.com/questions/25363794/xslt-variable-xpath-expressions-filter-array
    -->
    
    <xsl:variable name="menuDate" select="'2014-08-14T03:44'" />
    <xsl:variable name="menus" >
        <cs:Properties>
            <cs:CommercePropertyItem>
                <cs:Key>StartDate</cs:Key>
                <cs:Value>2014-03-04T12:38</cs:Value>
            </cs:CommercePropertyItem>
            <cs:CommercePropertyItem>
                <cs:Key>EndDate</cs:Key>
                <cs:Value>2014-12-04T12:38</cs:Value>
            </cs:CommercePropertyItem>
        </cs:Properties>
    </xsl:variable>
    
    <xsl:template match="/" >
        <xsl:variable name="actualMenus">
            <xsl:for-each select="ext:node-set($menus)">
                <xsl:variable name ="startDate" select="current()/cs:Properties/cs:CommercePropertyItem[cs:Key='StartDate']/cs:Value"/>
                <xsl:variable name ="endDate" select="current()/cs:Properties/cs:CommercePropertyItem[cs:Key='EndDate']/cs:Value"/>
                <xsl:variable name="today" select="translate(substring-before($menuDate, 'T'), '-', '')"/>
                <xsl:variable name="start" select="translate(substring-before($startDate, 'T'), '-', '')"/>
                <xsl:variable name="end" select="translate(substring-before($endDate, 'T'), '-', '')"/>
                
                <!-- $start &lt;= $today and $today &lt;= $end -->
                <xsl:if test="$start &lt;= $today and $today &lt;= $end">
                    <child>
                        <xsl:value-of select="current()"/>
                    </child>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$actualMenus" />
        <xsl:text>&#xa;</xsl:text>
        <xsl:value-of select="ext:node-set($menus)
            [translate(substring-before(cs:Properties/cs:CommercePropertyItem[cs:Key='StartDate']/cs:Value, 'T'), '-', '') 
                &lt;= translate(substring-before($menuDate, 'T'), '-', '') 
            and 
            translate(substring-before($menuDate, 'T'), '-', '') 
                &lt;= translate(substring-before(cs:Properties/cs:CommercePropertyItem[cs:Key='EndDate']/cs:Value, 'T'), '-', '')]" />
    </xsl:template>
    
</xsl:stylesheet>