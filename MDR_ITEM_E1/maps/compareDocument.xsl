<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:format="com.martquest.util.XSLTFormatter"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"    
    xmlns:java="http://xml.apache.org/xslt/java" 
    xmlns:os="http://www.1sync.org"    
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:exsl="http://exslt.org/common"
    xmlns:alist="java.util.ArrayList" extension-element-prefixes="format alist" exclude-result-prefixes="format alist xalan java xsl">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" xalan:indent-amount="3"/>

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>	

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="Message">

		<xsl:variable name="currentEventPKs" select="translate(Body[1]/Document[1]/OriginalDocument,' ','')"/>

		<xsl:variable name="catalogItems" 
            select="Body[1]/Document[1]/BusinessDocument[1]/CatalogAction[1]/CatalogActionDetails[1]/CatalogItem[
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'CORPORATE_AVERAGE_LIST_COST') or             
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'WEIGHT_MVL') or 
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'TEMPERATURE_MVL') or 
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'RETAILPRICEONTRADEITEM_MVL') or 
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'MEASURES_MVL') or 
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'ORDERSIZINGFACTOR_MVL') or
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'GPC_BRICK_MVL') or 
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'FLASHPOINTTEMPERATURE_MVL') or 
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'AUTHORIZED_REGION_MVL') or 
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'FOOD_AND_BEV_PREP_MVL') or 
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'FOOD_AND_BEV_NUTRIFACTS_MVL') or 
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'FOOD_AND_BEV_INGREDIENT_MVL') or 
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'FOOD_AND_BEV_DIET_MVL') or 
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'FOOD_AND_BEV_ALLERGEN_MVL') or             
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'PROMOTIONAL_TRADE_ITEM_MVL') or 
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'ORGANIC_CLAIM') or 
			(translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'CATALOGUEPRICE_MVL') or 
			(translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'MANUFACTURER_MVL') or 
			(translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'PEG_MEASUREMENT_MVL') or 
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'ITEMDESCRIPTION_MVL') or 
			(translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'HANDLINGINSTRUCTIONCODE_MVL') or
			(translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'GTINNAME_MVL') or
			(translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'FUNCTIONALNAME_MVL') or
            (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'ITEM_IMAGE')            
            ]"/>
		<xsl:variable name="previousEventPKs">
			<xsl:for-each select="$catalogItems">
				<xsl:choose>
					<xsl:when test="position()=1">
						<xsl:value-of select="PartNumber/GlobalPartNumber/ProdID/DBID"/>
					</xsl:when>                                     
					<xsl:otherwise>
						<xsl:text>,</xsl:text>
						<xsl:value-of select="PartNumber/GlobalPartNumber/ProdID/DBID"/>
					</xsl:otherwise>
				</xsl:choose>                
			</xsl:for-each>
		</xsl:variable>            

		<xsl:variable name="recordsTobeDeleted">       
			<xsl:choose>
				<xsl:when test="function-available('java:com.kroger.mdm.util.XSLTUtil.getDeletedRecordKeyString')">                    
					<xsl:value-of select="java:com.kroger.mdm.util.XSLTUtil.getDeletedRecordKeyString($currentEventPKs, $previousEventPKs)"/>                                                                            
				</xsl:when>
			</xsl:choose>     
		</xsl:variable>

		<Message xmlns:os="http://www.1sync.org"  xmlns:timezone="java.util.TimeZone" xmlns:uuid="com.martquest.util.UUIDGen">
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="Header"/>
			<xsl:element name="Body">
				<xsl:element name="Document">
					<xsl:attribute name="subtype">
						<xsl:value-of select="Body[1]/Document[1]/@subtype"/>
					</xsl:attribute>
					<xsl:attribute name="type">
						<xsl:value-of select="Body[1]/Document[1]/@type"/>
					</xsl:attribute>
					<xsl:copy-of select="Body[1]/Document[1]/BusinessDocument"/>
					<xsl:element name="OriginalDocument">
						<xsl:value-of select="$recordsTobeDeleted"/>
					</xsl:element>
				</xsl:element>               
			</xsl:element>
			<xsl:apply-templates select="@*" />            
		</Message>        
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
