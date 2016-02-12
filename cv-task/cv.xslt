<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cv="urn:cv"
    xmlns:f="urn:functions"
    exclude-result-prefixes="#all"
    version="3.0" expand-text="yes">
    
    <!--
        This stylesheet, cv.xslt, will convert the input data format to an intermediate tabular format
        with a simple talbe/row/cell structure, for easier processing in the next step.
        The output should be used for any subsequent step, i.e. going from there to xslfo or wordml
        is easy enough to do.
    -->
    
    
    <xsl:output indent="yes"  />
    
    <xsl:import-schema schema-location="cv.xsd" namespace="urn:cv" />
    <xsl:import-schema schema-location="cv-doc.xsd"  />
    
    <xsl:mode on-no-match="shallow-skip" />
    
    <!--
        mixed lookup table of keys we need, in real life makes more 
        sense to have a nested lookup or different lookups for language, titles etc 
    -->
    <xsl:variable name="lookup" select="map {
            'name' : 'Full name',
            'birth-date' : 'Date of birth',
            'address' : 'Address',
            'city' : 'City',
            'nationality' : 'Nationality',
            'nl-NL' : 'Dutch',
            'nl-BE' : 'Vlaams',
            'en-GB' : 'English',
            'de-DE' : 'German',
            'de-GE' : 'German',
            'fr-FR' : 'French',
            'C2' : 'mastery or proficiency',
            'C1' : 'effective operational proficiency',
            'B2' : 'upper intermediate',
            'B1' : 'threshold or intermediate'
        }" />
    
    <xsl:template match="/" as="document-node(element(*, documentType))" >
        <xsl:variable name="doc">
            <document>
                <header>
                    <xsl:value-of select="*/element(cv:person, cv:personType)/*/cv:item[@name = 'name']/@value" />
                </header>
                <xsl:apply-templates />
            </document>
        </xsl:variable>
        <xsl:copy-of select="$doc" type="documentType" />
    </xsl:template>
    
    <xsl:template match="element(*, cv:cvType)">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="element(cv:person, cv:personType)">
        <section title="Head">
            <xsl:apply-templates />
        </section>
    </xsl:template>
    
    <xsl:template match="element(cv:summary, cv:textType)">
        <section title="Summary">
            <row>
                <cell type="header">Summary</cell>
                <cell><xsl:apply-templates /></cell>
            </row>
        </section>
    </xsl:template>
    
    <xsl:template match="element(cv:experience, cv:experienceType)">
        <section title="Experience">
            <row>
                <cell type="header">Experience</cell>
                <cell type="empty"></cell>
            </row>
            <xsl:apply-templates />
        </section>
    </xsl:template>

    <xsl:template match="element(*, cv:jobType)">
        <row>
            <cell>
                <xsl:variable name="cast" select="function($d){
                    (: just a cast from obnoxious gYearDate to xs:date :)
                    let $s := $d ! string(.) ! tokenize(., '-') 
                    return xs:date($s[1] || '-' || $s[2] || '-01')}" />
                <xsl:variable name="ft" select="format-date(?, '[MNn,*-3] [Y0001]', 'en', (), ())" />
                <para>{if(empty(@to)) then 'since ' else ()}{$ft($cast(@from))}{(@to, ' &#x2012;')[2], @to ! $ft($cast(.))}</para>
            </cell>
            <cell>
                <para type="header">{cv:title}</para>
                <para type="text">{cv:description/cv:para}</para>
                <para type="emph">{cv:company/@name}</para>
                <para type="emph">{cv:company/@city}, {cv:company/@country}</para>
                <para type="text tagline">{cv:company/cv:tagline}</para>
            </cell>            
        </row>
    </xsl:template>

    <xsl:template match="element(*, cv:certificationsType)">
        <section>
            <row type="section">
                <cell type="header">Professional Certifications</cell>
                <cell>
                    <xsl:for-each select="*"><para type="text cert">{.}</para></xsl:for-each>
                </cell>            
            </row>
        </section>
    </xsl:template>

    <xsl:template match="element(*, cv:professionalActivitiesType)">
        <section>
            <row type="section">
                <cell type="header">Professional Activities</cell>
                <cell>
                    <xsl:for-each select="*"><para type="text activ">{.}</para></xsl:for-each>
                </cell>            
            </row>
        </section>
    </xsl:template>

    <xsl:template match="element(*, cv:skillsType)">
        <section>
            <row type="section">
                <cell type="header">Technical skills</cell>
                <cell>
                    <xsl:for-each select="*"><para type="text skill">{.}</para></xsl:for-each>
                </cell>            
            </row>
        </section>
    </xsl:template>

    <xsl:template match="element(*, cv:educationsType)">
        <section>
            <row type="section">
                <cell type="header">Education</cell>
                <cell type="empty" />                
            </row>
            <xsl:apply-templates />
        </section>
    </xsl:template>
    
    <xsl:template match="element(*, cv:additionalType)">
        <section>
            <row type="section">
                <cell type="header">Additional Competencies</cell>
                <cell type="empty" />                
            </row>
            <xsl:apply-templates select="../element(*, cv:languagesType)" mode="lang"/>
            <xsl:apply-templates select="cv:competency" />
        </section>
    </xsl:template>
    
    <xsl:template match="cv:competency" >
        <row type="comp">
            <cell><para type="header">{@name}</para></cell>
            <cell><xsl:apply-templates /></cell>
        </row>        
    </xsl:template>
    
    <xsl:template match="element(*, cv:educationType)">
        <row type="edu">
            <cell><para>{@from}{(@to, ' &#x2012; ')[2]}{@to}</para></cell>
            <cell>
                <para type="study">{@study}</para>
                <para type="text">{@school}, {@city}, {@country}</para>
            </cell>
        </row>
    </xsl:template>

    <xsl:template match="(element(cv:summary, cv:textType) | cv:competency)/cv:para">
        <para type="text">{.}</para>
    </xsl:template>
    
    <xsl:template match="element(cv:experience, cv:personType)">
        <section title="Summary">
            <xsl:apply-templates />
        </section>
    </xsl:template>
    
    <xsl:template match="cv:item">
        <row type="{@name}">
            <cell>{$lookup(@name)}</cell>
            <cell>{@value}</cell>
        </row>
    </xsl:template>
    
    <xsl:template match="element(*, cv:languagesType)" mode="lang">
        <row type="lang">
            <cell><para type="header">Native tongue</para></cell>
            <cell><para type="text"><xsl:value-of select="cv:language[@reading = 'native'][1]/$lookup(@lang)" /></para></cell>
        </row>
        <xsl:apply-templates select="cv:language[not(@reading = 'native')]" mode="#current"/>
    </xsl:template>
    
    <xsl:template match="cv:language" mode="lang">
        <row type="lang">
            <cell><para type="header">{$lookup(@lang)}</para></cell>
            <cell>
                <!-- order of attribs is undefined, just being safe -->
                <xsl:apply-templates select="@listening, @reading, @interaction, @production, @writing" mode="#current"/>
            </cell>
        </row>        
    </xsl:template>
    
    <xsl:template match="@*" mode="lang">
        <para type="lang-proficiency">{.}</para>
        <para type="lang-proficiency-explanation">{$lookup(.)}</para>
    </xsl:template>

</xsl:stylesheet>