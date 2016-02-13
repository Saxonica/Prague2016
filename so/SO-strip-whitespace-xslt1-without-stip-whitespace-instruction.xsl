<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ext="urn:schemas-microsoft-com:xslt"
    version="1.0">
    
    
    <!--
        Strip-space with xsl:strip-space.
        See: http://stackoverflow.com/questions/20272138/document-does-not-have-a-root-element-in-custom-xslt-map-during-runtime-but-not
    -->
    
    <xsl:template match="/">
        <xsl:variable name="stripped">
            <xsl:apply-templates select="/" mode="strip-whitespace" />
        </xsl:variable>
        <xsl:value-of select="format-number(sum(/dsQueryResponse/Rows/Row/@Ammount_x0020__x002f__x0020_Valo.), &quot;#,##0.;-#,##0.&quot;)" />
        <!-- micro-pipeline of input document, now without redundant whitespace -->
        <xsl:copy-of select="ext:node-set($stripped)/*" />
    </xsl:template>
    
    <xsl:template match="*">
        <!-- start your regular processing here in the default mode -->
        <xsl:apply-templates />
    </xsl:template>
    
    <!-- copy idiom, copies any input nodes unchanged -->
    <xsl:template match="node() | attribute::node()" mode="strip-whitespace">
        <xsl:copy>
            <xsl:apply-templates select="node() | attribute::node()" mode="strip-whitespace" />
        </xsl:copy>
    </xsl:template>
    
    <!-- normalize space on text-nodes. Chagne this appropriately 
        if you only want to remove trailing/leading whitespace -->
    <xsl:template match="text()" mode="strip-whitespace">
        <xsl:value-of select="normalize-space(.)" />
    </xsl:template>
    
</xsl:stylesheet>