<?xml version="1.0" encoding="UTF-8"?>
<xsl:package xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:f="http://localhost/fn"
    name="http://london2016/package-1"
    package-version="0.0.1"
    exclude-result-prefixes="xs f"
    version="3.0">
    
    <xsl:function name="f:compute-score" visibility="public" as="xs:integer">
        <xsl:param name="x" as="xs:integer"/>
        <xsl:param name="y" as="xs:integer"/>
        <xsl:sequence select="$x + $y"/>
    </xsl:function> 
    
    
</xsl:package>