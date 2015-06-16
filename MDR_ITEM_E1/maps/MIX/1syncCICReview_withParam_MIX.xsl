<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version="1.0" xmlns:os="http://www.1sync.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.preprod.1sync.org/schemas/item/1.0/CatalogueRequestProxy.xsd" 
xmlns:uuid="com.tibco.mdm.infrastructure.uuid.UUIDGen" xmlns:date="java.util.Date" xmlns:cldr="java.util.Calendar" xmlns:iso="com.tibco.mdm.util.ISOTime"
 extension-element-prefixes="uuid date cldr iso" exclude-result-prefixes="uuid date cldr iso"> 
	
	<xsl:param name="Xsl_Param_REVIEW_FROM"/>
	<xsl:param name="Xsl_Param_CICCode"/>
	<xsl:param name="Xsl_Param_CICDescription"/>
	<xsl:param name="Xsl_Param_CICCorrectiveInfo"/>
	<xsl:param name="Xsl_Param_CICActionNeeded"/>
	<xsl:param name="Xsl_Param_Environment_Name"/>
	<xsl:variable name="gen" select="uuid:getInstance()"/>
	<xsl:variable name="stdCICReviewMessage">Item Returned for Review</xsl:variable>
	<xsl:variable name="cic-uniqueId" select="uuid:newBase36Number($gen)"/>
	<xsl:variable name="state1" select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/PackageData/Transaction/Command/SubOperation"/>
	<xsl:variable name="CICmessageid" select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/PackageData/@messageID"/>
	<xsl:output method="xml" indent="yes"/>
	<xsl:variable name="CICCode" select="/Message/Body[1]/Document[1]/BusinessDocument[1]/CatalogAction[1]/CatalogActionHeader[1]/Extension[@name='CICCode']/Value/text()"/>
	<xsl:variable name="CICActionNeeded" select="/Message/Body[1]/Document[1]/BusinessDocument[1]/CatalogAction[1]/CatalogActionHeader[1]/Extension[@name='ActionNeeded']/Value/text()"/>
	<xsl:variable name="CICDescription" select="/Message/Body[1]/Document[1]/BusinessDocument[1]/CatalogAction[1]/CatalogActionHeader[1]/Extension[@name='Description']/Value/text()"/>
	<xsl:variable name="CICAdditionalDescription" select="/Message/Body[1]/Document[1]/BusinessDocument[1]/CatalogAction[1]/CatalogActionHeader[1]/Extension[@name='AdditionalDescription']/Value/text()"/>
	<xsl:variable name="CICCorrectiveInfo" select="/Message/Body[1]/Document[1]/BusinessDocument[1]/CatalogAction[1]/CatalogActionHeader[1]/Extension[@name='CorrectiveInfo']/Value/text()"/>
	<xsl:variable name="batchuserid" select="/Message/Header/MessageHeader[@role = 'Retailer']/Credential/Extension[@name='BatchUserId']/Value/text()"/>
    <xsl:variable name="dateTime" select="normalize-space(/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/Date/DateValue/Value)"/>
	<xsl:variable name="languageCode">en</xsl:variable>
	<xsl:template match="/">	
	<os:envelope xmlns:os="http://www.1sync.org" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.1sync.org
http://www.preprod.1sync.org/schemas/item/1.0/CatalogueItemConfirmationProxy.xsd">
	
	<!-- eb:MessageHeader -->
			<xsl:call-template name="MessageHeader"/>
			<!-- CatalogRequest -->
			<xsl:call-template name="CatalogRequest"/>
		</os:envelope>
	</xsl:template>
	
	
	<xsl:template name="MessageHeader">
	 
			<header>
				<xsl:attribute name="version"><!--xsl:value-of select="/Message/Header/MessageHeader/@version"/-->1.0</xsl:attribute>
				<sender>
					<xsl:value-of select="/Message/Header/MessageHeader[@role='Retailer']/Credential[@domain='GLN']/Identity/text()"/>
				</sender>
				 <!--<representedParty>
				       <xsl:value-of select="/Message/Header/MessageHeader[@role='Buyer']/Credential[@domain='GLN']/Identity/text()"/>
				 </representedParty>--> 
				<receiver>
					<xsl:value-of select="/Message/Header/MessageHeader[@role='Channel']/Credential[@domain='GLN']/Identity/text()"/>
				</receiver>
				<messageId>
					<!-- xsl:value-of select="$cic-uniqueId"/-->
					<xsl:value-of select="concat('MDM-',$Xsl_Param_Environment_Name,'-',$CICmessageid)"/>
					
				</messageId>
				<creationDateTime><xsl:call-template name="getDateTime">
						<xsl:with-param name="dateTime" select="$dateTime"/>
					</xsl:call-template></creationDateTime>
				
	    	</header>
    	</xsl:template>
	<xsl:template name="CatalogRequest">
			<catalogueItemConfirmation version="1.0">
		
				<header>					
					<userGLN>
					<xsl:value-of select="/Message/Header/MessageHeader[@role='Retailer']/Credential[@domain='GLN']/Identity/text()"/>
					</userGLN> 
					<userId><xsl:value-of select="$batchuserid"/></userId> 		
				</header>
				<!-- document template -->
				 <xsl:for-each select="//PackageData/Transaction">
				 	<xsl:variable name="CICtxnid" select="@id"/>
				 	<xsl:for-each select="Command">
					<xsl:call-template name="getDocument">
					        <xsl:with-param name="CICtxnid" select="$CICtxnid"/>
							<xsl:with-param name="CICcmdid" select="@id"/>
							<xsl:with-param name="refId" select="@referenceID"/>
				   </xsl:call-template>		 
			 	</xsl:for-each>
			 	</xsl:for-each>
			 	
			</catalogueItemConfirmation>
			
	 
	</xsl:template>
		<xsl:template name="getDocument">
		<xsl:param name="CICtxnid"/>
		<xsl:param name="CICcmdid"/>
		<xsl:param name="refId"/>
			<document>
					 <documentId><xsl:value-of select="$CICcmdid"/></documentId> 
					  <dataRecipientGLN>	
						  <xsl:value-of select="/Message/Header/MessageHeader[@role='Retailer']/Credential[@domain='GLN']/Identity/text()"/>
					 </dataRecipientGLN> 
					 <!--informationProviderGLN>
								<xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionDetails/CatalogItem[@key=$refId]/ItemData/Attribute[@name='INFORMATION_PROVIDER']/Value"/>
					</informationProviderGLN-->
					 <informationProviderGLN>
								<xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionDetails/CatalogItem[MasterCatalog/RevisionID/BaseName='ITEM_MASTER']/ItemData/Attribute[@name='INFORMATION_PROVIDER']/Value"/>
					</informationProviderGLN>
					  <targetMarket>US</targetMarket> 
					  <!--xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionDetails/CatalogItem[@key='$refId']/ItemData/Attribute[@name='TARGET_MARKET_ID']/Value"/-->
					
					  <gtin><xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionDetails/CatalogItem[@key=$refId]/ItemData/Attribute[@name='GTIN']/Value"/></gtin> 
					  
					  <confirmationState>REVIEW</confirmationState> 
					  <!-- <confirmationState><xsl:value-of select="REVIEW"/></confirmationState> -->
					  <!-- dont call the status detail template if CIC code is empty. -->
						  <xsl:if test="($CICCode != '') or ($Xsl_Param_CICCode != '')">
							<xsl:call-template name="getStatusDetail">
							 <xsl:with-param name="CICtxnid" select="$CICtxnid"/>
							 </xsl:call-template>
						 </xsl:if>
				</document>
			</xsl:template>
	<xsl:template name="getStatusDetail">
	<xsl:param name="CICtxnid"/>
		 <xsl:for-each select="//PackageData/Transaction[@id=$CICtxnid]">
				<xsl:variable name="CICtxnid" select="@id"/>
				<xsl:variable name="refId" select="@referenceID"/>
				<xsl:for-each select="Command">
						<xsl:call-template name="getStatusDetail1">
							<!-- xsl:with-param name="state" select="$state"/-->
							<xsl:with-param name="CICcmdid" select="@id"/>
							<xsl:with-param name="refId" select="@referenceID"/>
						</xsl:call-template>
				</xsl:for-each>
			</xsl:for-each>
	</xsl:template>
	<xsl:template name="getStatusDetail1">
	<xsl:param name="CICcmdid"/>
		<xsl:param name="refId"/>
				<statusDetail>	
				<!--gtin>
			     	<xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionDetails/CatalogItem[@key=$refId]/ItemData/Attribute[@name='GTIN']/Value"/>
				</gtin-->	
				 <gtin><xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionDetails/CatalogItem[MasterCatalog/RevisionID/BaseName='ITEM_MASTER']/ItemData/Attribute[@name='GTIN']/Value"/></gtin> 
				 <xsl:if test="$Xsl_Param_REVIEW_FROM != ''">
					<xsl:if test="$Xsl_Param_REVIEW_FROM = 'CM_REVIEW'">				 
					<confirmationStatus>
						 <status lang="{$languageCode}" code="{$CICCode}" ><!-- xsl:value-of select="languageCode"/-->						
							 <xsl:value-of select="$CICDescription"/>
						  </status> 
						<xsl:if test="$CICAdditionalDescription != ''">
	  						<additionalInfo lang="{$languageCode}">  						 
  								 <xsl:value-of select="$CICAdditionalDescription"/>
							</additionalInfo> 
						</xsl:if>
  						<xsl:if test="$CICActionNeeded != ''">
							<correctiveInfo>
							  <action><xsl:value-of select="$CICActionNeeded"/></action> 
								  <xsl:if test="$CICCorrectiveInfo != ''">
								     <description lang="{$languageCode}">
									    <xsl:value-of select="$CICCorrectiveInfo"/>
								     </description> 
								   </xsl:if>
 						</correctiveInfo>
 						</xsl:if>
					</confirmationStatus>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$Xsl_Param_REVIEW_FROM != ''">
				<xsl:if test="$Xsl_Param_REVIEW_FROM = 'INVALIDVENDOR'">					
					  <confirmationStatus>
						 <status lang="{$languageCode}" code="{$Xsl_Param_CICCode}" ><!-- xsl:value-of select="languageCode"/-->					
							 <xsl:value-of select="$Xsl_Param_CICDescription"/>
						  </status> 						
  						<xsl:if test="$Xsl_Param_CICActionNeeded != ''">
							<correctiveInfo>
							  <action><xsl:value-of select="$Xsl_Param_CICActionNeeded"/></action> 
								  <xsl:if test="$Xsl_Param_CICCorrectiveInfo != ''">
								     <description lang="{$languageCode}">
									    <xsl:value-of select="$Xsl_Param_CICCorrectiveInfo"/>
								     </description> 
								   </xsl:if>
 						</correctiveInfo>
 						</xsl:if>
					</confirmationStatus>
				</xsl:if>
				</xsl:if>
				<xsl:if test="$Xsl_Param_REVIEW_FROM != ''">
				<xsl:if test="$Xsl_Param_REVIEW_FROM = 'DUPVAL'">					
					  <confirmationStatus>
						 <status lang="{$languageCode}" code="{$Xsl_Param_CICCode}" >
							 <xsl:value-of select="$Xsl_Param_CICDescription"/>
						  </status> 						
  						<xsl:if test="$Xsl_Param_CICActionNeeded != ''">
							<correctiveInfo>
							  <action><xsl:value-of select="$Xsl_Param_CICActionNeeded"/></action> 
								  <xsl:if test="$Xsl_Param_CICCorrectiveInfo != ''">
								     <description lang="{$languageCode}">
									    <xsl:value-of select="$Xsl_Param_CICCorrectiveInfo"/>
								     </description> 
								   </xsl:if>
 						</correctiveInfo>
 						</xsl:if>
					</confirmationStatus>
				</xsl:if>
				</xsl:if>
				<xsl:if test="$Xsl_Param_REVIEW_FROM != ''">
				<xsl:if test="$Xsl_Param_REVIEW_FROM = 'GRISSOM1_DM'">					
					  <confirmationStatus>
						 <status lang="{$languageCode}" code="{$Xsl_Param_CICCode}" ><!-- xsl:value-of select="languageCode"/-->						
							 <xsl:value-of select="$stdCICReviewMessage"/>
						  </status> 
						<xsl:if test="$Xsl_Param_CICDescription != ''">
	  						<additionalInfo lang="{$languageCode}">  						 
  								 <xsl:value-of select="$Xsl_Param_CICDescription"/>
							</additionalInfo> 
						</xsl:if>						  
  						<xsl:if test="$Xsl_Param_CICActionNeeded != ''">
							<correctiveInfo>
							  <action><xsl:value-of select="$Xsl_Param_CICActionNeeded"/></action> 
								  <xsl:if test="$Xsl_Param_CICCorrectiveInfo != ''">
								     <description lang="{$languageCode}">
									    <xsl:value-of select="$Xsl_Param_CICCorrectiveInfo"/>
								     </description> 
								   </xsl:if>
 						</correctiveInfo>
 						</xsl:if>
					</confirmationStatus>
				</xsl:if>
				</xsl:if>
				</statusDetail>
 	</xsl:template>
	<xsl:template name="getDateTime">
		<xsl:param name="dateTime"/>
		<xsl:variable name="date" select="normalize-space(substring-before($dateTime,' '))"/>
		<xsl:variable name="time" select="normalize-space(substring-after($dateTime,' '))"/>
		<xsl:value-of select="substring(concat($date, 'T', $time),1,19)"/>
	 
	</xsl:template>
</xsl:stylesheet>

