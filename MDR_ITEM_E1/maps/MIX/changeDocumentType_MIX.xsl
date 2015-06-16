<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:format="com.martquest.util.XSLTFormatter"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"    
    xmlns:java="http://xml.apache.org/xslt/java" 
    xmlns:os="http://www.1sync.org"    
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:alist="java.util.ArrayList" extension-element-prefixes="format alist" exclude-result-prefixes="format alist xalan java xsl">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" xalan:indent-amount="3"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="Message">
        <Message xmlns:os="http://www.1sync.org"  xmlns:timezone="java.util.TimeZone" xmlns:uuid="com.martquest.util.UUIDGen">
             <xsl:apply-templates select="@* | node()" />   
         </Message>
    </xsl:template>
    
    <xsl:template match="/Message/Body[1]/Document[1]">
        <xsl:element name="Document">
            <xsl:attribute name="type">EDIT PRODUCT</xsl:attribute>
            <xsl:attribute name="subtype"><xsl:value-of select="@subtype"/></xsl:attribute>
           <xsl:copy-of select="BusinessDocument"/>
        </xsl:element>
    </xsl:template>
   
    <!--
===================================================================================================================
	General template to copy all nodes
===================================================================================================================
-->
    <xsl:template match="node()">
        
        <xsl:if test="name() != ''">
            <xsl:copy>
                <xsl:apply-templates select="@* | node() | text()"/>
            </xsl:copy>
        </xsl:if>
        
    </xsl:template>
    
    
    <!--
===================================================================================================================
	General template to copy all attributes and text of an element
===================================================================================================================
-->
    <xsl:template match="@* | text()">
        <!-- Copy input attribute to output. -->
        <xsl:copy>
            <xsl:apply-templates select="@* | text()" />
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
