<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version="1.0" xmlns:os="http://www.1sync.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.preprod.1sync.org/schemas/item/1.0/ResponseProxy.xsd" 
xmlns:uuid="com.tibco.mdm.infrastructure.uuid.UUIDGen" xmlns:date="java.util.Date" xmlns:cldr="java.util.Calendar" xmlns:iso="com.tibco.mdm.util.ISOTime"
 extension-element-prefixes="uuid date cldr iso" exclude-result-prefixes="uuid date cldr iso"> 
	
	<xsl:param name="Xsl_Param_Environment_Name"/>
	 <!-- Date/Time -->
    <xsl:variable name="isoTimeZone">EST</xsl:variable>
    <xsl:variable name="isotime" select="iso:new($isoTimeZone)"/>
    <!-- Date/Time -->
    <xsl:variable name="CINRDateTime" select="$isotime"/>
    <xsl:variable name="CINRDate" select="normalize-space(substring-before($CINRDateTime,' '))"/>
    <xsl:variable name="CINRTime" select="normalize-space(substring-after($CINRDateTime,' '))"/>
	
	
	 <xsl:variable name="gen" select="uuid:getInstance()"/>
	<xsl:variable name="cic-uniqueId" select="uuid:newBase36Number($gen)"/>
<xsl:variable name="dateTime" select="normalize-space(/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/Date/DateValue/Value)"/>

<xsl:template match="/">
		<os:envelope xmlns:os="http://www.1sync.org" xmlns:sh="http://www.gs1.org/sh" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.1sync.org http://www.preprod.1sync.org/schemas/item/1.0/ResponseProxy.xsd">

			<!-- eb:MessageHeader -->
			<xsl:call-template name="MessageHeader"/>
			<!-- CatalogRequest -->
			<xsl:call-template name="catalogueItemNotificationResponse"/>
		</os:envelope>
	</xsl:template>


<xsl:template name="MessageHeader">
	 
			<header version="1.0">
				<!--xsl:attribute name="version"><xsl:value-of select="/Message/Header/MessageHeader/@version"/></xsl:attribute-->
				<sender>
					<xsl:value-of select="/Message/Header/MessageHeader[@role='Retailer']/Credential[@domain='GLN']/Identity/text()"/>
				</sender>
				 <!--representedParty>
				       <xsl:value-of select="/Message/Header/MessageHeader[@role='Buyer']/Credential[@domain='GLN']/Identity/text()"/>
				 </representedParty--> 
				<receiver>
					<xsl:value-of select="/Message/Header/MessageHeader[@role='Channel']/Credential[@domain='GLN']/Identity/text()"/>
				</receiver>
				<messageId>
					<xsl:value-of select="concat('MDM-',$Xsl_Param_Environment_Name,'-',$cic-uniqueId)"/>
				</messageId>
				<creationDateTime>
					<xsl:call-template name="getDateTime">
						<xsl:with-param name="dateTime" select="$CINRDateTime"/>
					</xsl:call-template>
				</creationDateTime>
	    	</header>
    	</xsl:template>
<xsl:template name="catalogueItemNotificationResponse">
<catalogueItemNotificationResponse version="1.0">
		<header>
		<xsl:variable name="messageID" select="//Message/Body/Document/OriginalDocument/os:envelope/header/messageId"/>
			<xsl:variable name="OriginatingMessageID1" select="normalize-space(substring-before($messageID,'_KR_'))"/>				
			<originatingMessageId><xsl:value-of select="$OriginatingMessageID1"/></originatingMessageId>
		</header>
		<xsl:for-each select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document">
					<documentAcknowledgement>
						<originatingDocumentId>
							<xsl:value-of select="documentId"/>
						</originatingDocumentId>
					</documentAcknowledgement>
				</xsl:for-each>
		</catalogueItemNotificationResponse>
		
	</xsl:template>
	<xsl:template name="getDateTime">
		<xsl:param name="dateTime"/>
		<xsl:variable name="date" select="normalize-space(substring-before($dateTime,' '))"/>
		<xsl:variable name="time" select="normalize-space(substring-after($dateTime,' '))"/>
		<xsl:value-of select="substring(concat($date, 'T', $time),1,19)"/>	 
	</xsl:template>
</xsl:stylesheet>
