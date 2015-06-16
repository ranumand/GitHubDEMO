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
                      <xsl:element name="CatalogItem">
                         <xsl:copy-of select="LineNumber"/>
                                  <xsl:element name="PartNumber">
                                      <xsl:element name="GlobalPartNumber">
                                          <xsl:element name="ProdID">
                                              <xsl:element name="IDNumber">
                                                  <xsl:value-of select="PartNumber/GlobalPartNumber/ProdID/IDNumber"/>
                                              </xsl:element>
                                              <xsl:element name="IDExtension">
                                                  <xsl:value-of select="PartNumber/GlobalPartNumber/ProdID/IDExtension"/>
                                              </xsl:element>
                                              <xsl:element name="Agency">
                                                  <xsl:element name="Code">
                                                      <CodeType/>
                                                      <Value/>
                                                      <Normal>SOURCE</Normal>
                                                  </xsl:element>
                                              </xsl:element>
                                              <xsl:element name="ExternalKey">
                                                  <xsl:element name="Attribute">
                                                      <xsl:attribute name="name">PRODUCTID</xsl:attribute>
                                                      <xsl:element name="Value">
                                                          <xsl:value-of select="PartNumber/GlobalPartNumber/ProdID/IDNumber"/>
                                                      </xsl:element>
                                                  </xsl:element>
                                                  <xsl:element name="Attribute">
                                                      <xsl:attribute name="name">PRODUCTIDEXT</xsl:attribute>
                                                      <xsl:element name="Value">
                                                          <xsl:value-of select="PartNumber/GlobalPartNumber/ProdID/IDExtension"/>
                                                      </xsl:element>
                                                  </xsl:element>
                                              </xsl:element>
                                              <xsl:element name="OriginalIDVersion">
                                                  <xsl:value-of select="PartNumber/GlobalPartNumber/ProdID/OriginalIDVersion"/>
                                              </xsl:element>
                                              <xsl:element name="IDVersion">
                                                  <xsl:value-of select="PartNumber/GlobalPartNumber/ProdID/IDVersion"/>
                                              </xsl:element>
                                              <xsl:element name="DBID">
                                                  <xsl:value-of select="PartNumber/GlobalPartNumber/ProdID/DBID"/>
                                              </xsl:element>
                                          </xsl:element>
                                      </xsl:element>
                                  </xsl:element>
                                  <!--xsl:copy-of select="PartNumber"/-->
                           
                                       
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
                          <xsl:if test="RelationshipData">
                              <xsl:copy-of select="RelationshipData"/>
                        </xsl:if>   
                    </xsl:element>                                                                                                              
               
            </xsl:for-each>
        </xsl:element>
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
        
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@* | node()" />
        </xsl:element>
        
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

