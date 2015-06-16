<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:format="com.martquest.util.XSLTFormatter" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ns0="http://www.1sync.org" xmlns:os="http://www.1sync.org" xmlns:java="http://xml.apache.org/xslt/java" xmlns:uuid="com.martquest.util.UUIDGen" xmlns:timezone="java.util.TimeZone" xmlns:alist="java.util.ArrayList" extension-element-prefixes="format alist" exclude-result-prefixes="java alist">
	<xsl:output method="xml" indent="yes"/>
	<xsl:variable name="classes">228</xsl:variable>
	<xsl:template match="Header">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template name="copyAttributes">
		<xsl:for-each select="@*">
			<xsl:attribute name="{name()}">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="InsertMasterCatalog">
		<MasterCatalog>
			<RevisionID>
				<BaseName>ITEM_MASTER</BaseName>
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
		<xsl:for-each select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification//document/hierarchyInformation/operation">
			<xsl:choose>
				<xsl:when test=". = 'NEW'">
					<xsl:value-of select="'ProdDataNotif'"/>
				</xsl:when>
				<xsl:when test=". = 'INITIALLOAD'">
					<xsl:value-of select="'ProdDataNotif'"/>
				</xsl:when>
				<xsl:when test=". = 'MODIFY'">
					<xsl:value-of select="'ProdDataNotif'"/>
				</xsl:when>
				<xsl:when test=". = 'CHANGE'">
					<xsl:value-of select="'ProdDataNotif'"/>
				</xsl:when>
				<xsl:when test=". = 'CORRECTION'">
					<xsl:value-of select="'ProdDataNotif'"/>
				</xsl:when>
				<xsl:when test=". = 'DELETE'">
					<xsl:value-of select="'ProdDataNotif'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'INVALID'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="subType">		
		<xsl:variable name="optype" select="not(contains($classes, /Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/item/flex/attrGroup[@name='vendorProprietary']/attr[@name='kroFamilyTreeClass']))"/>

		<xsl:for-each select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification//document/hierarchyInformation/operation">
			<xsl:choose>				
				<xsl:when test=". = 'DELETE' and $optype">
					<xsl:value-of select="'ProdPubNotifCancelGLENN'"/>
				</xsl:when>						
				<xsl:when test=". = 'DELETE'">
					<xsl:value-of select="'ProdPubNotifCancel'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'INVALID'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<xsl:template match="Message">
		<Message>
			<xsl:call-template name="copyAttributes"/>
			<xsl:apply-templates select="Header"/>
			<Body>
				<xsl:for-each select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document">
					<!--BOC Mapping values from BW Document-->
					<!--<xsl:variable name="pv_item" select="kgr_derived/hierarchy/pv_item"/>
					<xsl:variable name="sv_item" select="kgr_derived/hierarchy/sv_item-->
					<xsl:variable name="root_gtin" select="hierarchyInformation/publishedGTIN"/>					

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
										<xsl:attribute name="name">
											<xsl:value-of select="'FormBlurb'"/>
										</xsl:attribute>
										<xsl:for-each select="hierarchyInformation/operation">
											<xsl:choose>
												<xsl:when test=". = 'ADD'">
													<Value>
														<xsl:value-of select="'The following Product Add operation has been processed'"/>
													</Value>
												</xsl:when>
												<xsl:when test=". = 'INITIALLOAD'">
													<Value>
														<xsl:value-of select="'The following Product Add operation has been processed'"/>
													</Value>
												</xsl:when>
												<xsl:when test=". = 'CORRECTION'">
													<Value>
														<xsl:value-of select="'The following Product correction operation has been processed'"/>
													</Value>
												</xsl:when>
												<xsl:when test=". = 'CHANGE'">
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
										</xsl:for-each>
									</Extension>
									<Extension>
										<xsl:attribute name="name">
											<xsl:value-of select="'FormTitle'"/>
										</xsl:attribute>
										<xsl:for-each select="hierarchyInformation/operation">
											<xsl:choose>
												<xsl:when test=". = 'ADD'">
													<Value>
														<xsl:value-of select="'Product Add Notification'"/>
													</Value>
												</xsl:when>
												<xsl:when test=". = 'INITIALLOAD'">
													<Value>
														<xsl:value-of select="'Product Add Notification'"/>
													</Value>
												</xsl:when>
												<xsl:when test=". = 'CORRECTION'">
													<Value>
														<xsl:value-of select="'Product Correction Notification'"/>
													</Value>
												</xsl:when>
												<xsl:when test=". = 'CHANGE'">
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
										</xsl:for-each>
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
									<xsl:call-template name="InsertCatalogActionHeaderAck"/>
								</CatalogActionHeader>
								<CatalogActionDetails>

									<xsl:for-each select="item">
										<xsl:variable name="keyid" select="gtin"/>
										<CatalogItem>
											<xsl:attribute name="key">
												<xsl:value-of select="gtin"/>
											</xsl:attribute>
											<LineNumber>
												<xsl:number/>
											</LineNumber>
											<PartNumber>
												<GlobalPartNumber>
													<ProdID>
														<IDNumber>
															<xsl:value-of select="gtin"/>
														</IDNumber>
														<IDExtension/>
														<Agency>
															<Code>
																<CodeType>Agency</CodeType>
																<Normal>SOURCE</Normal>
															</Code>
														</Agency>
														<ExternalKey>
															<Attribute name="PRODUCTID">
																<Value>
																	<xsl:value-of select="gtin"/>
																</Value>
															</Attribute>
															<Attribute name="PRODUCTIDEXT">
																<Value/>
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
													<BaseName>ITEM_MASTER</BaseName>
													<Version/>
													<DBID/>
												</RevisionID>
											</MasterCatalog>
											<ItemData>
												<Attribute name="PRODUCTID">
													<Value>
														<xsl:value-of select="gtin"/>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTIDEXT">
													<Value/>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CENTSOFFAMOUNT</xsl:attribute>
													<Value>
														<xsl:value-of select="attr[@name='kroCentsOffAmount']"/>
													</Value>
												</Attribute>
												<!-- ITEM_MASTER attributes -->												

											</ItemData>
											<ActionLog></ActionLog>
											<RelationshipData>
												<xsl:if test="../link/parentItem[childItem=$keyid]">
													<Relationship>
														<RelationType>ContainedBy</RelationType>
														<xsl:for-each select="../link/parentItem/childItem">
															<xsl:choose>
																<xsl:when test=".=$keyid">
																	<RelatedItems>
																		<RelatedItem>
																			<xsl:attribute name="referenceKey">
																				<xsl:value-of select="../@gtin"/>
																			</xsl:attribute>
																		</RelatedItem>
																	</RelatedItems>
																</xsl:when>
															</xsl:choose>
														</xsl:for-each>
													</Relationship>
												</xsl:if>
												<xsl:for-each select="../link/parentItem">
													<xsl:choose>
														<xsl:when test="$keyid=@gtin">
															<Relationship>
																<RelationType>Contains</RelationType>
																<RelatedItems>
																	<xsl:attribute name="count">																		
																		<xsl:value-of select="count(childItem)"/>
																	</xsl:attribute>
																	<xsl:for-each select="childItem">
																		<RelatedItem>
																			<xsl:attribute name="referenceKey">
																				<xsl:value-of select="."/>
																			</xsl:attribute>
																			<Attribute name="Child_QTY">
																				<Value>
																					<xsl:value-of select="@quantity"/>
																				</Value>
																			</Attribute>
																			<Attribute name="Child_Quantity_UOM_ID">
																				<Value>CT</Value>
																			</Attribute>
																			<Attribute name="Type_CD">
																				<Value/>
																			</Attribute>
																		</RelatedItem>
																	</xsl:for-each>
																</RelatedItems>
															</Relationship>
														</xsl:when>
													</xsl:choose>
												</xsl:for-each>
											</RelationshipData>
										</CatalogItem>
										<!-- END Catalog: ITEM_MASTER -->

									</xsl:for-each>

								</CatalogActionDetails>
							</CatalogAction>
						</BusinessDocument>
						<OriginalDocument>
							<xsl:copy-of select="//os:envelope"/>
						</OriginalDocument>
					</Document>
				</xsl:for-each>
			</Body>
		</Message>
	</xsl:template>
</xsl:stylesheet>
