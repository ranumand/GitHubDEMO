<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:format="com.martquest.util.XSLTFormatter" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:os="http://www.1sync.org" xmlns:ns0="http://www.1sync.org" xmlns:java="http://xml.apache.org/xslt/java" xmlns:uuid="com.martquest.util.UUIDGen" xmlns:timezone="java.util.TimeZone" xmlns:alist="java.util.ArrayList" extension-element-prefixes="format alist" exclude-result-prefixes="java alist">
	<xsl:output method="xml" indent="yes"/>	
	<xsl:template match="Header">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template name="copyAttributes">
		<xsl:for-each select="@*">
			<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="InsertMasterCatalog">
		<MasterCatalog>
			<RevisionID>
				<BaseName>HierarchyOrchestration</BaseName>
				<Version/>
				<DBID/>
			</RevisionID>
		</MasterCatalog>
	</xsl:template>
	<xsl:template name="InsertCatalogActionHeaderAck">
		<CatalogActionHeaderAck>
			<AcknowledgmentCode>
				<Code>
					<Value/>
				</Code>
			</AcknowledgmentCode>
			<Owner>
				<PartyID>
					<PartyName/>
					<DBID/>
				</PartyID>
			</Owner>
			<Workitem>
				<DBID/>
			</Workitem>
			<Instructions>
				<Description>
					<Long/>
				</Description>
			</Instructions>
		</CatalogActionHeaderAck>
	</xsl:template>
	<xsl:variable name="type">
		<xsl:choose>
			<xsl:when test="/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/hierarchyInformation/operation/text() = 'NEW'">
				<xsl:value-of select="'ProdDataNotif'"/>
			</xsl:when>
			<xsl:when test="/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/hierarchyInformation/operation/text() = 'INITIALLOAD'">
				<xsl:value-of select="'ProdDataNotif'"/>
			</xsl:when>
			<xsl:when test="/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification//document/hierarchyInformation/operation/text() = 'MODIFY'">
				<xsl:value-of select="'ProdDataNotif'"/>
			</xsl:when>
			<xsl:when test="/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/hierarchyInformation/operation/text() = 'CHANGE'">
				<xsl:value-of select="'ProdDataNotif'"/>
			</xsl:when>
			<xsl:when test="/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/hierarchyInformation/operation/text() = 'CORRECTION'">
				<xsl:value-of select="'ProdDataNotif'"/>
			</xsl:when>
			<xsl:when test="/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification//document/hierarchyInformation/operation/text() = 'DELETE'">
				<xsl:value-of select="'ProdDataNotif'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'INVALID'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="subType">
		<xsl:choose>
			<xsl:when test="(/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification//document/hierarchyInformation/operation/text() = 'NEW') and (/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/ns0:kgr_derived/hierarchy/VIPPublishedGTIN/ns0:derived_attr[@name='class_route']/text()= 'MIX-U')">
				<xsl:value-of select="'ProdDataNotifAdd_MIX-U'"/>
			</xsl:when>
			<xsl:when test="(/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification//document/hierarchyInformation/operation/text() = 'CHANGE') and (/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/ns0:kgr_derived/hierarchy/VIPPublishedGTIN/ns0:derived_attr[@name='class_route']/text()= 'MIX-U')">
				<xsl:value-of select="'ProdDataNotifChange_MIX-U'"/>
			</xsl:when>
			<xsl:when test="(/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification//document/hierarchyInformation/operation/text() = 'MODIFY') and (/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/ns0:kgr_derived/hierarchy/VIPPublishedGTIN/ns0:derived_attr[@name='class_route']/text()= 'MIX-U')">
				<xsl:value-of select="'ProdDataNotifChange_MIX-U'"/>
			</xsl:when> 

			<xsl:when test="(/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification//document/hierarchyInformation/operation/text() = 'CORRECTION') and (/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/ns0:kgr_derived/hierarchy/VIPPublishedGTIN/ns0:derived_attr[@name='class_route']/text()= 'MIX-U')">
				<xsl:value-of select="'ProdDataNotifCorrect_Mix-U'"/>
			</xsl:when> 

			<xsl:when test="(/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification//document/hierarchyInformation/operation/text() = 'INITIALLOAD') and (/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/ns0:kgr_derived/hierarchy/VIPPublishedGTIN/ns0:derived_attr[@name='class_route']/text()= 'MIX-U')">
				<xsl:value-of select="'ProdDataNotifAdd_MIX-U'"/>
			</xsl:when>
			<xsl:when test="(/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification//document/hierarchyInformation/operation/text() = 'DELETE') and (/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/ns0:kgr_derived/hierarchy/VIPPublishedGTIN/ns0:derived_attr[@name='class_route']/text()= 'MIX-U')">
				<xsl:value-of select="'ProdPubNotifCancel_MIX-U'"/>
			</xsl:when>			
			<xsl:otherwise>
				<xsl:value-of select="'INVALID'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="Message">
		<Message>
			<xsl:call-template name="copyAttributes"/>
			<xsl:apply-templates select="Header"/>
			<Body>
				<itemSubmissionDate>
					<xsl:call-template name="getDateTime1">
						<xsl:with-param name="dateTime" select="/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/item[gtin=../hierarchyInformation[1]/publishedGTIN/text()]/flex/attr[@name='itemSubmissionDate']/text()"/>
					</xsl:call-template>
				</itemSubmissionDate>
				<creationDateTime>
					<xsl:call-template name="getDateTime1">
						<xsl:with-param name="dateTime" select="/Message/Body/Document/OriginalDocument/ns0:envelope/header/creationDateTime/text()"/>
					</xsl:call-template>
				</creationDateTime>
				<xsl:for-each select="/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document">
					<Document subtype="{$subType}" type="{$type}">
						<BusinessDocument>
							<CatalogAction>
								<CatalogActionHeader>
									<ThisDocID>
										<DocID>
											<IDNumber>
												<xsl:value-of select="documentId"/>
											</IDNumber>
											<Agency>
												<Code>
													<CodeType>Agency</CodeType>
													<Normal>Seller</Normal>
												</Code>
											</Agency>
										</DocID>
									</ThisDocID>
									<ActionCode>
										<Code>
											<CodeType>
												<xsl:value-of select="'1SyncCatalogItemNotification'"/>
											</CodeType>
											<Value>
												<xsl:value-of select="$subType"/>
											</Value>
										</Code>
									</ActionCode>
									<Date>
										<Code>
											<CodeType>DateTime</CodeType>
											<Normal>TimeStamp</Normal>
										</Code>
										<DateValue>
											<Value>
												<xsl:value-of select="'2008-10-06'"/>
											</Value>
										</DateValue>
										<TimeValue>
											<Value>
												<xsl:value-of select="'19:30:23'"/>
											</Value>
										</TimeValue>
									</Date>
									<xsl:call-template name="InsertMasterCatalog"/>
									<Reference>
										<ReferenceCode>
											<Code>
												<CodeType>
													<xsl:value-of select="'ReferenceCode'"/>
												</CodeType>
												<Normal>
													<xsl:value-of select="'Transaction'"/>
												</Normal>
											</Code>
										</ReferenceCode>
										<DocID>
											<IDNumber>
												<xsl:value-of select="documentId"/>
											</IDNumber>
											<Agency>
												<Code>
													<CodeType>
														<xsl:value-of select="'Agency'"/>
													</CodeType>
													<Normal>
														<xsl:value-of select="'Supplier'"/>
													</Normal>
												</Code>
											</Agency>
										</DocID>
									</Reference>
									<URL>
										<Code>
											<CodeType>
												<xsl:value-of select="'URL'"/>
											</CodeType>
											<Normal>
												<xsl:value-of select="'ApplicationProductPublication'"/>
											</Normal>
										</Code>
									</URL>
									<Extension>
										<xsl:attribute name="name"><xsl:value-of select="'FormBlurb'"/></xsl:attribute>
										<xsl:choose>
											<xsl:when test="hierarchyInformation/operation = 'ADD'">
												<Value>
													<xsl:value-of select="'The following Product Add operation has been processed'"/>
												</Value>
											</xsl:when>
											<xsl:when test="hierarchyInformation/operation = 'INITIALLOAD'">
												<Value>
													<xsl:value-of select="'The following Product Add operation has been processed'"/>
												</Value>
											</xsl:when>
											<xsl:when test="hierarchyInformation/operation = 'CORRECTION'">
												<Value>
													<xsl:value-of select="'The following Product correction operation has been processed'"/>
												</Value>
											</xsl:when>
											<xsl:when test="hierarchyInformation/operation = 'CHANGE'">
												<Value>
													<xsl:value-of select="'The following Product change operation has been processed'"/>
												</Value>
											</xsl:when>
											<xsl:otherwise>
												<Value>
													<xsl:value-of select="'Unknown'"/>
												</Value>
											</xsl:otherwise>
										</xsl:choose>
									</Extension>
									<Extension>
										<xsl:attribute name="name"><xsl:value-of select="'FormTitle'"/></xsl:attribute>
										<xsl:choose>
											<xsl:when test="hierarchyInformation/operation = 'ADD'">
												<Value>
													<xsl:value-of select="'Product Add Notification'"/>
												</Value>
											</xsl:when>
											<xsl:when test="hierarchyInformation/operation = 'INITIALLOAD'">
												<Value>
													<xsl:value-of select="'Product Add Notification'"/>
												</Value>
											</xsl:when>
											<xsl:when test="hierarchyInformation/operation = 'CORRECTION'">
												<Value>
													<xsl:value-of select="'Product Correction Notification'"/>
												</Value>
											</xsl:when>
											<xsl:when test="hierarchyInformation/operation = 'CHANGE'">
												<Value>
													<xsl:value-of select="'Product Change Notification'"/>
												</Value>
											</xsl:when>
											<xsl:otherwise>
												<Value>
													<xsl:value-of select="'Unknown'"/>
												</Value>
											</xsl:otherwise>
										</xsl:choose>
									</Extension>
									<Extension>
										<xsl:attribute name="name">Cascade</xsl:attribute>
									</Extension>
									<Extension>
										<xsl:attribute name="name">CICCode</xsl:attribute>
									</Extension>
									<Extension>
										<xsl:attribute name="name">Description</xsl:attribute>
									</Extension>
									<Extension>
										<xsl:attribute name="name">AdditionalDescription</xsl:attribute>
									</Extension>
									<Extension>
										<xsl:attribute name="name">ActionNeeded</xsl:attribute>
									</Extension>
									<Extension>
										<xsl:attribute name="name">CorrectiveInfo</xsl:attribute>
									</Extension>
									<Extension name="WorkflowRoute"/>
									<Extension name="SendForCorrection">
										<Value>Unknown</Value>
									</Extension>
									<Extension name="HierarchyOrchestrationIds">
									<Value>
									  <xsl:for-each select="/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/item/gtin">
										<xsl:value-of select="concat(.,',')"/>
									  </xsl:for-each>
									</Value>
									</Extension>
									<xsl:call-template name="InsertCatalogActionHeaderAck"/>
								</CatalogActionHeader>
								<CatalogActionDetails>
									<!-- CATALOG: Link_MVL-->
									<!--xsl:for-each select="link/parentItem"-->
									<!--xsl:for-each select="childItem"-->
									<CatalogItem>
										<xsl:attribute name="key"><!--<xsl:value-of select= "publishedGTIN"/>--><xsl:value-of select="hierarchyInformation/publishedGTIN"/></xsl:attribute>
										<LineNumber>
											<xsl:number/>
										</LineNumber>
										<PartNumber>
											<GlobalPartNumber>
												<ProdID>
													<IDNumber>
														<xsl:value-of select="hierarchyInformation/publishedGTIN"/>
													</IDNumber>
													<IDExtension>
														<xsl:value-of select="concat(hierarchyInformation/informationProviderGLN,'-',hierarchyInformation/targetMarket)"/>
													</IDExtension>
													<Agency>
														<Code>
															<CodeType>Agency</CodeType>
															<Normal>SOURCE</Normal>
														</Code>
													</Agency>
													<ExternalKey>
														<Attribute name="PRODUCTID">
															<Value>
																<xsl:value-of select="hierarchyInformation/publishedGTIN"/>
															</Value>
														</Attribute>
														<Attribute name="PRODUCTIDEXT">
															<Value>
																<xsl:value-of select="concat(hierarchyInformation/informationProviderGLN,'-',hierarchyInformation/targetMarket)"/>
															</Value>
														</Attribute>
													</ExternalKey>
													<OriginalIDVersion>1</OriginalIDVersion>
													<IDVersion>1</IDVersion>
													<DBID/>
												</ProdID>
											</GlobalPartNumber>
										</PartNumber>
										<PartDescription>
											<Description>
												<Short/>
											</Description>
										</PartDescription>
										<MasterCatalog>
											<RevisionID>
												<BaseName>HierarchyOrchestration</BaseName>
												<Version/>
												<DBID/>
											</RevisionID>
										</MasterCatalog>
										<ItemData>
											<Attribute name="PRODUCTID">
												<Value>
													<xsl:value-of select="hierarchyInformation/publishedGTIN"/>
												</Value>
											</Attribute>
											<Attribute name="PRODUCTIDEXT">
												<Value>
													<xsl:value-of select="concat(hierarchyInformation/informationProviderGLN,'-',hierarchyInformation/targetMarket)"/>
												</Value>
											</Attribute>
											<Attribute name="INFORMATIONPROVIDERGLN">
												<Value>
													<xsl:value-of select="hierarchyInformation/informationProviderGLN"/>
												</Value>
											</Attribute>
											<Attribute name="TARGETMARKET">
												<Value>
													<xsl:value-of select="hierarchyInformation/targetMarket"/>
												</Value>
											</Attribute>
											<Attribute name="OPERATION">
												<Value>
													<xsl:value-of select="hierarchyInformation/operation"/>
												</Value>
											</Attribute>
											<Attribute name="DOCUMENTID">
												<Value>
													<xsl:value-of select="documentId"/>
												</Value>
											</Attribute>
											<Attribute name="SENDER">
												<Value>
													<xsl:value-of select="/Message/Body/Document/OriginalDocument/ns0:envelope/header/sender/text()"/>
												</Value>
											</Attribute>
											<Attribute name="RECEIVER">
												<Value>
													<xsl:value-of select="/Message/Body/Document/OriginalDocument/ns0:envelope/header/receiver/text()"/>
												</Value>
											</Attribute>
											<Attribute name="MESSAGEID">
												<Value>
													<xsl:value-of select="/Message/Body/Document/OriginalDocument/ns0:envelope/header/messageId/text()"/>
												</Value>
											</Attribute>
											<Attribute name="ITEMSOURCE">
												<Value>
													<xsl:value-of select="/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/item[gtin=../hierarchyInformation[1]/publishedGTIN/text()]/flex/attr[@name='itemSource']/text()"/>
												</Value>
											</Attribute>
											<Attribute name="ITEMSUBMISSIONDATE">
												<Value>
													<xsl:call-template name="getDateTime1">
														<xsl:with-param name="dateTime" select="/Message/Body/Document/OriginalDocument/ns0:envelope/catalogueItemNotification/document/item[gtin=../hierarchyInformation[1]/publishedGTIN/text()]/flex/attr[@name='itemSubmissionDate']/text()"/>
													</xsl:call-template>
												</Value>
											</Attribute>
											<Attribute name="CREATIONDATETIME">
												<Value>
													<xsl:call-template name="getDateTime1">
														<xsl:with-param name="dateTime" select="/Message/Body/Document/OriginalDocument/ns0:envelope/header/creationDateTime/text()"/>
													</xsl:call-template>
												</Value>
											</Attribute>
											<Attribute name="ITEM_HIERARCHY_STATUS_CD">
												<Value>CIN</Value>
											</Attribute>
											<Attribute name="DOCUMENTSTATUS">
												<Value>
													<xsl:value-of select="hierarchyInformation/documentStatus"/>
												</Value>
											</Attribute>
										</ItemData>
									</CatalogItem>
								</CatalogActionDetails>
							</CatalogAction>
						</BusinessDocument>
						<OriginalDocument>
							<xsl:copy-of select="//ns0:envelope"/>
						</OriginalDocument>
					</Document>
				</xsl:for-each>
			</Body>
		</Message>
	</xsl:template>
	<xsl:template name="Booleanize">
		<xsl:param name="value"/>
		<xsl:choose>
			<!--	    <xsl:when test="not($value)"></xsl:when>	-->
			<!--	    <xsl:when test="$value = ''"></xsl:when>	-->
			<xsl:when test="$value = 'TRUE'">TRUE</xsl:when>
			<xsl:when test="$value = 'true'">TRUE</xsl:when>
			<xsl:when test="$value = 'True'">TRUE</xsl:when>
			<xsl:when test="$value = 'YES'">TRUE</xsl:when>
			<xsl:when test="$value = 'Yes'">TRUE</xsl:when>
			<xsl:when test="$value = 'yes'">TRUE</xsl:when>
			<xsl:otherwise>FALSE</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- booleanize test begins -->
	<xsl:template name="BooleanizeTest">
		<xsl:param name="value"/>
		<xsl:choose>
			<!--	    <xsl:when test="not($value)"></xsl:when>	-->
			<!--	    <xsl:when test="$value = ''"></xsl:when>	-->
			<xsl:when test="$value = 'TRUE'">TRUE</xsl:when>
			<xsl:when test="$value = 'true'">TRUE</xsl:when>
			<xsl:when test="$value = 'True'">TRUE</xsl:when>
			<xsl:when test="$value = 'YES'">TRUE</xsl:when>
			<xsl:when test="$value = 'Yes'">TRUE</xsl:when>
			<xsl:when test="$value = 'yes'">TRUE</xsl:when>
			<xsl:when test="$value = 'FALSE'">FALSE</xsl:when>
			<xsl:when test="$value = 'false'">FALSE</xsl:when>
			<xsl:when test="$value = 'False'">FALSE</xsl:when>
			<xsl:when test="$value = 'NO'">FALSE</xsl:when>
			<xsl:when test="$value = 'No'">FALSE</xsl:when>
			<xsl:when test="$value = 'no'">FALSE</xsl:when>
			<xsl:when test="$value = '30002654'">TRUE</xsl:when>
			<xsl:when test="$value = '30002960'">FALSE</xsl:when>
			<xsl:when test="$value = 'NOT_APPLICABLE'">FALSE</xsl:when>
			<xsl:when test="$value = 'UNSPECIFIED'">FALSE</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<!-- booleanize test ends -->
	<xsl:template name="BooleanizeTest_ForNewValidVales">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="$value = 'TRUE'">TRUE</xsl:when>
			<xsl:when test="$value = 'true'">TRUE</xsl:when>
			<xsl:when test="$value = 'True'">TRUE</xsl:when>
			<xsl:when test="$value = 'YES'">TRUE</xsl:when>
			<xsl:when test="$value = 'Yes'">TRUE</xsl:when>
			<xsl:when test="$value = 'yes'">TRUE</xsl:when>
			<xsl:when test="$value = 'FALSE'">FALSE</xsl:when>
			<xsl:when test="$value = 'false'">FALSE</xsl:when>
			<xsl:when test="$value = 'False'">FALSE</xsl:when>
			<xsl:when test="$value = 'NO'">FALSE</xsl:when>
			<xsl:when test="$value = 'No'">FALSE</xsl:when>
			<xsl:when test="$value = 'no'">FALSE</xsl:when>
			<xsl:when test="$value = 'NOT_APPLICABLE'">FALSE</xsl:when>
			<xsl:when test="$value = 'UNSPECIFIED'">FALSE</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="CR343_MAPPING">
		<xsl:param name="value"/>
		<xsl:choose>
			<!--	    <xsl:when test="not($value)"></xsl:when>	-->
			<!--	    <xsl:when test="$value = ''"></xsl:when>	-->
			<xsl:when test="$value = '30002654'">TRUE</xsl:when>
			<xsl:when test="$value = '30002960'">FALSE</xsl:when>
			<xsl:when test="$value = 'TRUE'">TRUE</xsl:when>
			<xsl:when test="$value = 'true'">TRUE</xsl:when>
			<xsl:when test="$value = 'True'">TRUE</xsl:when>
			<xsl:when test="$value = 'YES'">TRUE</xsl:when>
			<xsl:when test="$value = 'Yes'">TRUE</xsl:when>
			<xsl:when test="$value = 'yes'">TRUE</xsl:when>
			<xsl:when test="$value = 'FALSE'">FALSE</xsl:when>
			<xsl:when test="$value = 'false'">FALSE</xsl:when>
			<xsl:when test="$value = 'False'">FALSE</xsl:when>
			<xsl:when test="$value = 'NO'">FALSE</xsl:when>
			<xsl:when test="$value = 'No'">FALSE</xsl:when>
			<xsl:when test="$value = 'no'">FALSE</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="EQUIVALENTUOMQUANTITY_UOM_MAPPING">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="$value = '1N'">CT</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ISMEDICATED_MAPPING">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="$value = '30002654'">TRUE</xsl:when>
			<xsl:when test="$value = '30002960'">FALSE</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="PITTEDSTONED_MAPPING">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="$value = '30002654'">TRUE</xsl:when>
			<xsl:when test="$value = '30002960'">FALSE</xsl:when>
			<xsl:when test="$value = 'TRUE'">TRUE</xsl:when>
			<xsl:when test="$value = 'FALSE'">FALSE</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="CONTINUOUS_MAPPING">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="$value = 'TRUE'">TRUE</xsl:when>
			<xsl:when test="$value = 'true'">TRUE</xsl:when>
			<xsl:when test="$value = 'True'">TRUE</xsl:when>
			<xsl:when test="$value = 'YES'">TRUE</xsl:when>
			<xsl:when test="$value = 'Yes'">TRUE</xsl:when>
			<xsl:when test="$value = 'yes'">TRUE</xsl:when>
			<xsl:when test="$value = 'FALSE'">FALSE</xsl:when>
			<xsl:when test="$value = 'false'">FALSE</xsl:when>
			<xsl:when test="$value = 'False'">FALSE</xsl:when>
			<xsl:when test="$value = 'NO'">FALSE</xsl:when>
			<xsl:when test="$value = 'No'">FALSE</xsl:when>
			<xsl:when test="$value = 'no'">FALSE</xsl:when>
			<xsl:when test="$value = '30004905'">30004905</xsl:when>
			<xsl:when test="$value = '30004906'">30004906</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="TEMPERATURE_TYPE_TRANSLATE">
		<xsl:value-of select="local-name()"/>
		<!--
            <xsl:choose>
                <xsl:when test="local-name() = 'deliveryToDCTemperatureMinimum'">DCMINIMUM</xsl:when>
                <xsl:when test="local-name() = 'deliveryToDCTemperatureMaximum'">DCMAXIMUM</xsl:when>
                <xsl:when test="local-name() = 'storageHandlingTempMax'">STORAGEMAXIMUM</xsl:when>
                <xsl:when test="local-name() = 'storageHandlingTempMin'">STORAGEMINIMUM</xsl:when>
                <xsl:when test="local-name() = 'storageHandlingTempMin'">STORAGEMINIMUM</xsl:when>

                <xsl:otherwise><xsl:value-of select="local-name()" /></xsl:otherwise>
            </xsl:choose>
        -->
	</xsl:template>
	<xsl:template name="getDateTime1">
		<xsl:param name="dateTime"/>
		<xsl:variable name="date" select="normalize-space(substring-before($dateTime,'T'))"/>
		<xsl:variable name="time" select="normalize-space(substring-after($dateTime,'T'))"/>
		<xsl:choose>
			<xsl:when test="string-length($time) != 0">
				<xsl:variable name="time1" select="concat($time,'.0')"/>
				<xsl:value-of select="concat($date,' ',$time1)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($date,' ',$time)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ProductAerosol">
		<xsl:param name="value"/>
		<xsl:choose>
			<!--	    <xsl:when test="not($value)"></xsl:when>	-->
			<!--	    <xsl:when test="$value = ''"></xsl:when>	-->
			<xsl:when test="$value = 'TRUE'">TRUE</xsl:when>
			<xsl:when test="$value = 'true'">TRUE</xsl:when>
			<xsl:when test="$value = 'True'">TRUE</xsl:when>
			<xsl:when test="$value = 'YES'">TRUE</xsl:when>
			<xsl:when test="$value = 'Yes'">TRUE</xsl:when>
			<xsl:when test="$value = 'yes'">TRUE</xsl:when>
			<xsl:when test="$value = 'FALSE'">FALSE</xsl:when>
			<xsl:when test="$value = 'false'">FALSE</xsl:when>
			<xsl:when test="$value = 'False'">FALSE</xsl:when>
			<xsl:when test="$value = 'NO'">FALSE</xsl:when>
			<xsl:when test="$value = 'No'">FALSE</xsl:when>
			<xsl:when test="$value = 'no'">FALSE</xsl:when>
			<xsl:when test="$value = 'NOT_APPLICABLE'">FALSE</xsl:when>
			<xsl:when test="$value = 'UNSPECIFIED'">FALSE</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
