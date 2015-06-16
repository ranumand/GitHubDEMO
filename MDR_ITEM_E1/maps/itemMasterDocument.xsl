<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:format="com.martquest.util.XSLTFormatter"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"    
    xmlns:java="http://xml.apache.org/xslt/java" 
    xmlns:os="http://www.1sync.org"    
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:alist="java.util.ArrayList" extension-element-prefixes="format alist" exclude-result-prefixes="format alist xalan java xsl">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" xalan:indent-amount="3"/>


	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>	

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="Message">
		<Message xmlns:os="http://www.1sync.org"  xmlns:timezone="java.util.TimeZone" xmlns:uuid="com.martquest.util.UUIDGen">
			<xsl:apply-templates select="@* | node()" />   
		</Message>
	</xsl:template>

	<xsl:template match="/Message/Body[1]/Document[1]/BusinessDocument[1]/CatalogAction[1]/CatalogActionDetails[1]">
		<xsl:variable name="catalogItems" select="CatalogItem[(MasterCatalog/RevisionID/BaseName='ITEM_MASTER') and not(string(PartNumber/GlobalPartNumber/ProdID/DBID) ='' or PartNumber/GlobalPartNumber/ProdID/DBID = '-1')]"/>
		<xsl:element name="CatalogActionDetails">
			<xsl:for-each select="$catalogItems">
				<xsl:element name="CatalogItem">
					<xsl:attribute name="key">
						<xsl:value-of select="@key"/>
					</xsl:attribute>
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
				</xsl:element>                          
			</xsl:for-each>                
		</xsl:element>
	</xsl:template> 

	<xsl:template match="/Message/Body[1]/Document[1]/OriginalDocument">
		<xsl:element name="OriginalDocument">
			<xsl:variable name="catalogItems" select="../BusinessDocument[1]/CatalogAction[1]/CatalogActionDetails[1]/CatalogItem[(
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
                (translate(MasterCatalog/RevisionID/BaseName,$smallcase,$uppercase) = 'ITEM_IMAGE'))                 
                and not(string(PartNumber/GlobalPartNumber/ProdID/DBID) ='' or PartNumber/GlobalPartNumber/ProdID/DBID = '-1')]"/>
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
