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
    
    <xsl:template match="/Message/Body[1]/Document[1]/BusinessDocument[1]/CatalogAction[1]/CatalogActionDetails[1]">
        <xsl:element name="CatalogActionDetails">
            <xsl:for-each select="CatalogItem">
                <xsl:variable name="currentKey" select="@key"></xsl:variable>
                <xsl:if test="count(preceding-sibling::CatalogItem[@key=$currentKey])=0">
                    <xsl:element name="CatalogItem">
                        <xsl:attribute name="key"><xsl:value-of select="@key"/></xsl:attribute>
                        <xsl:if test="LineNumber">
                            <xsl:copy-of select="LineNumber"/>
                        </xsl:if>
                        <xsl:if test="PartNumber">
                            <xsl:copy-of select="PartNumber"/>
                        </xsl:if>                                              
                        <xsl:if test="CatalogActionDetailsAck">
                            <xsl:copy-of select="CatalogActionDetailsAck"/>
                        </xsl:if>
                        <xsl:if test="ActionCode">
                            <xsl:copy-of select="ActionCode"/>
                        </xsl:if>
                        <xsl:if test="SubLineItemInfo">
                            <xsl:copy-of select="SubLineItemInfo"/>
                        </xsl:if>
                        <xsl:if test="UnitPrice">
                            <xsl:copy-of select="UnitPrice"/>
                        </xsl:if>
                        <xsl:if test="Classifications">
                            <xsl:copy-of select="Classifications"/>
                        </xsl:if>
                        <xsl:if test="PartDescription">
                            <xsl:copy-of select="PartDescription"/>
                        </xsl:if>
                        <xsl:if test="MasterCatalog">
                            <xsl:copy-of select="MasterCatalog"/>
                        </xsl:if>
                        <xsl:if test="Manufacturer">
                            <xsl:copy-of select="Manufacturer"/>
                        </xsl:if>
                        <xsl:if test="Supplier">
                            <xsl:copy-of select="Supplier"/>
                        </xsl:if>
                        <xsl:if test="Contact">
                            <xsl:copy-of select="Contact"/>
                        </xsl:if>
                        <xsl:if test="Reference">
                            <xsl:copy-of select="Reference"/>
                        </xsl:if>
                        <xsl:if test="Instructions">
                            <xsl:copy-of select="Instructions"/>
                        </xsl:if>
                        <xsl:if test="URL">
                            <xsl:copy-of select="URL"/>
                        </xsl:if>
                        <xsl:if test="Attachment">
                            <xsl:copy-of select="Attachment"/>
                        </xsl:if>
                        <xsl:if test="Extension">
                            <xsl:copy-of select="Extension"/>
                        </xsl:if>
                        <xsl:if test="ItemData">
                            <xsl:copy-of select="ItemData"/>
                        </xsl:if>
                        <xsl:if test="ActionLog">
                            <xsl:copy-of select="ActionLog"/>
                        </xsl:if>
                        <xsl:if test="ItemState">
                            <xsl:copy-of select="ItemState"/>
                        </xsl:if>
                        <xsl:if test="count(RelationshipData) > 0">                            
                            <xsl:element name="RelationshipData">
                                <xsl:for-each select="RelationshipData/Relationship">
                                     <xsl:element name="Relationship">
                                         <xsl:copy-of select="RelationType"/>
                                         <xsl:for-each select="RelatedItems">
                                            <xsl:element name="RelatedItems">
                                                <xsl:choose>
                                                    <xsl:when test="@count = 0">
                                                        <xsl:attribute name="count">0</xsl:attribute>
                                                    </xsl:when>
                                                    <xsl:when test="@count = 1">
                                                        <xsl:attribute name="count">1</xsl:attribute>
                                                        <xsl:copy-of select="RelatedItem"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:attribute name="count"><xsl:value-of select="count(RelatedItem[not(following::RelatedItem/@referenceKey = @referenceKey)] )"/></xsl:attribute>
                                                        <xsl:for-each select="RelatedItem">
                                                            <xsl:variable name="referenceKey"><xsl:value-of select="@referenceKey"/></xsl:variable>
                                                            <xsl:if test="count(preceding-sibling::RelatedItem[@referenceKey = $referenceKey])=0">
                                                                <xsl:element name="RelatedItem">
                                                                    <xsl:attribute name="referenceKey"><xsl:value-of select="@referenceKey"/></xsl:attribute>
                                                                    <xsl:copy-of select="Attribute"/>
                                                                </xsl:element>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </xsl:otherwise>
                                                </xsl:choose>                                                    
                                            </xsl:element>
                                         </xsl:for-each>
                                     </xsl:element>
                                 </xsl:for-each>
                             </xsl:element>                         
                        </xsl:if>                       
                    </xsl:element>                    
                </xsl:if>
            </xsl:for-each>
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
        
        <!--xsl:element name="{name()}">
            <xsl:apply-templates select="@* | node()" />
        </xsl:element-->
        
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
