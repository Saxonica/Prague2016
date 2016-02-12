<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="#all"
    version="3.0"
    expand-text="yes">
    
    <!--
        Takes input of the format described in cv-doc.xsd (format is straightforward section/row/cell, with sections allowed nesting)
        This XSLT transforms it into HTML 5 output with embedded CSS        
    -->
    
    <!-- skip anything we don't need (similar to XSLT 2.0 copy/delete idioms) -->
    <xsl:mode on-no-match="shallow-skip" />
    
    <!-- in XSLT 3.0 you can use XHTML and html-version, but this is not yet supported by many processors -->
    <xsl:output method="html" encoding="UTF-8" version="5.0" use-character-maps="spaces" />
    
    <xsl:character-map name="spaces">
        <!-- 
            Just using a private use char for outputting nbsp. This is NOT required for proper HTML display,  
            but often customers request it (or truly old browsers), just adding it here as an example
            Note: Saxon has a specific extension attribute for this, but this way is cross-processor.
        -->
        <xsl:output-character character="&#xE000;" string="&amp;nbsp;"/>
    </xsl:character-map>
    
    <!-- override the CSS if you want another styling file to be embedded -->
    <xsl:param name="css" as="xs:anyURI" select="xs:anyURI('cv.css')" />
    
    <xsl:variable name="nbsp" select="'&#xE000;'" />
    
    <!-- currently only used when creating the file in the prev. step -->
    <xsl:import-schema schema-location="cv-doc.xsd"/>
    
    <!-- entry point -->
    <xsl:template match="document">
        <html>
            <head>
                <meta charset="utf-8" /> 
                <title>{header}</title>
                <style type="text/css" xsl:expand-text="no">
                    <xsl:copy-of select="unparsed-text($css)" />
                </style>
            </head>
            <body>
                <table>
                    <thead>
                        <tr>
                            <th><h2>Curriculum Vitae</h2></th>
                            <th><h1>{header}</h1></th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:apply-templates select="section/row"/>
                    </tbody>
                    <tfoot>
                        <td>{$nbsp}</td>
                        <th>Amsterdam, {format-date(current-date(), '[MNn] [D01], [Y0001]')}</th>
                    </tfoot>
                </table>
            </body>
        </html>
    </xsl:template>
    
    <!-- just a safe-guard in case we did something wrong in the prev. step -->
    <xsl:template match="row[count(cell) != 2]">
        <xsl:message terminate="yes">Two, and only two cells are allowed on each row</xsl:message>
    </xsl:template>
    
    <xsl:template match="row">
        <tr class="{@type}">
            <xsl:apply-templates select="cell" />
        </tr>
    </xsl:template>
    
    <xsl:template match="cell[@type = 'header']">
        <th><h3>{.}</h3></th>
    </xsl:template>
    
    <!-- language section -->
    <xsl:template match="row[@type = 'lang'][position() > 1]">
        <xsl:variable name="first" select="count(preceding-sibling::row) = 2" />
        <tr class="{@type, if($first) then 'first' else 'later'}">
            <td>
                <xsl:if test="$first">
                    <p class="header lang-first">Other languages</p>
                </xsl:if>
                <p class="header">{cell[1]/para}</p>
            </td>
            <td>
                <table class="lang">
                    <xsl:if test="$first">
                        <thead>
                            <tr>
                                <td colspan="4">Understanding</td>
                                <td colspan="4">Speaking</td>
                                <td colspan="2">Writing</td>
                            </tr>
                            <tr>
                                <td colspan="2">Listening</td>
                                <td colspan="2">Reading</td>
                                <td colspan="2">Interaction</td>
                                <td colspan="2">Production</td>
                                <td colspan="2">{$nbsp}</td>
                            </tr>
                        </thead>
                    </xsl:if>
                    <tbody>
                        <tr>
                            <xsl:apply-templates select="cell[2]/para" />
                        </tr>
                    </tbody>
                </table>                
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template match="cell">
        <td class="{@type}">
            <xsl:value-of select="text()" />
            <xsl:value-of select="if(@type = 'empty') then $nbsp else ()" />
            <xsl:apply-templates select="para" />
        </td>
    </xsl:template>
    
    <!-- skill section -->
    <xsl:template match="cell[para[@type/contains(., 'skill')]] ">
        <td class="{@type} skill">
            <p>
                <xsl:apply-templates select="para">
                    <!-- sorting to go from single-file list in source to three-file list in target, while maintaining top->down->next order of reading -->
                    <xsl:sort select="(((position() - 1) mod 9) * 3) + (position() idiv 9)" data-type="number" stable="true" />
                </xsl:apply-templates>
            </p>
        </td>
    </xsl:template>
   
    <xsl:template match="para[@type/contains(., 'skill')]">
        <div class="skill">{.}</div>
    </xsl:template>
    
    <xsl:template match="para">
        <p class="{@type}">{.}</p>
    </xsl:template>

    <xsl:template match="row[@type = 'lang'][position() > 1]/cell/para">
        <td class="{@type}">{.}</td>
    </xsl:template>

</xsl:stylesheet>