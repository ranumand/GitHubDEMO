<?xml version="1.0" encoding="UTF-8"?>
<!-- 
<?xml-stylesheet type="text/xsl" href="MapDisplay.xsl"?>
-->
<xsl:stylesheet version="1.0" xmlns:format="com.martquest.util.XSLTFormatter" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ns0="http://www.1sync.org" xmlns:os="http://www.1sync.org" xmlns:java="http://xml.apache.org/xslt/java" xmlns:uuid="com.martquest.util.UUIDGen" xmlns:timezone="java.util.TimeZone" xmlns:alist="java.util.ArrayList" extension-element-prefixes="format alist" exclude-result-prefixes="java alist">
	<xsl:output method="xml" indent="yes"/>
	<xsl:variable name="classes">XXX</xsl:variable>
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
				<BaseName>LINK_MVL</BaseName>
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
	<xsl:variable name="type">EDIT PRODUCT</xsl:variable>
	<xsl:variable name="subType">		
		<xsl:variable name="optype" select="not(contains($classes, /Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/item/flex/attrGroup[@name='vendorProprietary']/attr[@name='kroFamilyTreeClass']))"/>

		<xsl:for-each select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification//document/hierarchyInformation/operation">
			<xsl:choose>
				<xsl:when test=". = 'NEW' and $optype">
					<xsl:value-of select="'ProdDataNotifAddGLENN'"/>
				</xsl:when>
				<xsl:when test=". = 'CHANGE' and $optype">
					<xsl:value-of select="'ProdDataNotifChangeGLENN'"/>
				</xsl:when>
				<xsl:when test=". = 'MODIFY' and $optype">
					<xsl:value-of select="'ProdDataNotifChangeGLENN'"/>
				</xsl:when>
				<xsl:when test=". = 'CORRECTION' and $optype">
					<xsl:value-of select="'ProdDataNotifCorrectGLENN'"/>
				</xsl:when>
				<xsl:when test=". = 'INITIALLOAD' and $optype">
					<xsl:value-of select="'ProdDataNotifAddGLENN'"/>
				</xsl:when>
				<xsl:when test=". = 'DELETE' and $optype">
					<xsl:value-of select="'ProdPubNotifCancelGLENN'"/>
				</xsl:when>
				<xsl:when test=". = 'NEW'">
					<xsl:value-of select="'ProdDataNotifAdd'"/>
				</xsl:when>
				<xsl:when test=". = 'CHANGE'">
					<xsl:value-of select="'ProdDataNotifChange'"/>
				</xsl:when>
				<xsl:when test=". = 'MODIFY'">
					<xsl:value-of select="'ProdDataNotifChange'"/>
				</xsl:when>
				<xsl:when test=". = 'CORRECTION' and (/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/item/cancelDate != '') ">
					<xsl:value-of select="'ProdDataNotifDisc'"/>
				</xsl:when>
				<xsl:when test=". = 'CORRECTION' and (/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/item/discontinueDate != '') ">
					<xsl:value-of select="'ProdDataNotifDisc'"/>
				</xsl:when>
				<xsl:when test=". = 'CORRECTION'">
					<xsl:value-of select="'ProdDataNotifCorrect'"/>
				</xsl:when>
				<xsl:when test=". = 'INITIALLOAD'">
					<xsl:value-of select="'ProdDataNotifAdd'"/>
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
					<xsl:variable name="root_gtin" select="hierarchyInformation/publishedGTIN"/>
					<xsl:variable name="pv_item" select="ns0:kgr_derived/hierarchy/pv_item"/>
					<xsl:variable name="sv_item" select="ns0:kgr_derived/hierarchy/sv_item"/>
					<xsl:variable name="isscannablebarcode" select="ns0:kgr_derived/global_attributes/ns0:derived_attr[@name='ISSCANNABLEBARCODE']"/>
					<xsl:variable name="itemsourceorigin" select="ns0:kgr_derived/hierarchy/VIPPublishedGTIN/ns0:derived_attr[@name='ITEMSOURCE']"/>
					<xsl:variable name="shipper_flg" select="ns0:kgr_derived/hierarchy/VIPPublishedGTIN/ns0:derived_attr[@name='SHIPPER_FLG']"/>
					<xsl:variable name="familytreeclasscode" select="ns0:kgr_derived/global_attributes/ns0:derived_attr[@name='FAMILY_TREE_CLASS_CD']"/>
					<xsl:variable name="familytreerecapdept" select="ns0:kgr_derived/global_attributes/ns0:derived_attr[@name='FAMILYTREERECAPDEPARTMENT']"/>
					<xsl:variable name="familytreesubclasscd" select="ns0:kgr_derived/global_attributes/ns0:derived_attr[@name='FAMILY_TREE_SUB_CLASS_CD']"/>
					<xsl:variable name="familytreeprimarydept" select="ns0:kgr_derived/global_attributes/ns0:derived_attr[@name='FAMILYTREEPRIMARYDEPARTMENT']"/>
					<xsl:variable name="familytreedeptcd" select="ns0:kgr_derived/global_attributes/ns0:derived_attr[@name='FAMILY_TREE_DPT_CD']"/>
					<xsl:variable name="noOfCases" select="count(item[isBaseUnit='false']) - 1"/>
					<xsl:variable name="noOfBaseUnits" select="count(item[isBaseUnit='true'])"/>
					<!-- EOC Mapping values from BW Document-->

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
										<itemSubmissionDate>
											<xsl:call-template name="getDateTime1">
												<xsl:with-param name="dateTime" select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/item[gtin=../hierarchyInformation[1]/publishedGTIN/text()]/flex/attr[@name='itemSubmissionDate']/text()"/>
											</xsl:call-template>
										</itemSubmissionDate>
										<creationDateTime>
											<xsl:call-template name="getDateTime1">
												<xsl:with-param name="dateTime" select="/Message/Body/Document/OriginalDocument/os:envelope/header/creationDateTime/text()"/>
											</xsl:call-template>
										</creationDateTime>
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
									<xsl:for-each select="link/parentItem">	
										<xsl:for-each select="childItem">

											<xsl:variable name="keyid" select="gtin"/>
											<xsl:variable name="isBaseUnit" select="isBaseUnit"/>
											<xsl:variable name="vendorProprietary" select="flex/attrGroup[@name='vendorProprietary']"/>
											<xsl:variable name="piHierarchyAttributes" select="flex/attrGroup[@name='piHierarchyAttributes']"/>
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('LINK_MVL-',../../../hierarchyInformation/publishedGTIN,'-',concat(../@gtin,'-',text()))"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="../../../hierarchyInformation/publishedGTIN"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="concat(../@gtin,'-',text())"/>
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
																		<xsl:value-of select="../../../hierarchyInformation/publishedGTIN"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="concat(../@gtin,'-',text())"/>
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
														<BaseName>LINK_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>														
															<xsl:value-of select="../../../hierarchyInformation/publishedGTIN"/>

														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>														
															<xsl:value-of select="concat(../@gtin,'-',text())"/>
														</Value>
													</Attribute>
													<Attribute name="PARENTITEM_GTIN">
														<Value>
															<xsl:value-of select= "../@gtin"/>
														</Value>
													</Attribute>
													<Attribute name="CHILDITEM_GTIN">
														<Value>
															<xsl:value-of select= "text()"/>
														</Value>
													</Attribute>
													<Attribute name="CHILDITEM_QUANTITY">
														<Value>
															<xsl:value-of select= "@quantity"/>
														</Value>
													</Attribute>
												</ItemData>
											</CatalogItem>

										</xsl:for-each>
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

	<xsl:key name="functional" match="functionalName" use="concat(generate-id(..), '|', @lang)" />  
	<xsl:key name="handlingInstructionCode" match="handlingInstructionCode" use="concat(generate-id(..), '|', @lang)" />  
	<xsl:key name="gtinName" match="gtinName" use="concat(generate-id(..), '|', @lang)" />  
	<xsl:key name="productDescription" match="productDescription" use="concat(generate-id(..), '|', @lang)" />  
	<xsl:key name="prepmvl" match="value" use="concat(generate-id(..), '|', @qual)" />  
	<xsl:key name="ingredientmvl" match="value" use="concat(generate-id(..), '|', @qual)" />  



	<xsl:template match="functionalName">              
		<RelatedItem referenceKey="{concat('FUNCTIONALNAME_MVL','-',ancestor::item/gtin,'-', @lang)}"/>
	</xsl:template>

	<xsl:template match="handlingInstructionCode">              
		<RelatedItem referenceKey="{concat('HANDLINGINSTRUCTIONCODE_MVL','-',ancestor::item/gtin,'-', @lang)}"/>
	</xsl:template>

	<xsl:template match="gtinName">              
		<RelatedItem referenceKey="{concat('GTINNAME_MVL','-',ancestor::item/gtin,'-', @lang)}"/>
	</xsl:template>

	<xsl:template match="productDescription">              
		<RelatedItem referenceKey="{concat('ITEMDESCRIPTION_MVL','-',ancestor::item/gtin,'-', @lang)}"/>
	</xsl:template>

	<!-- booleanize test begins -->
	<xsl:template name="Booleanize">
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
			<xsl:when test="$value = 'NO'">FALSE</xsl:when>
			<xsl:when test="$value = 'no'">FALSE</xsl:when>
			<xsl:when test="$value = '30002654'">TRUE</xsl:when>
			<xsl:when test="$value = '30002960'">FALSE</xsl:when>
			<xsl:when test="$value = 'NOT_APPLICABLE'">FALSE</xsl:when>
			<xsl:when test="$value = 'UNSPECIFIED'">FALSE</xsl:when>
			<xsl:when test="$value = 'Y'">TRUE</xsl:when>
			<xsl:when test="$value = 'N'">FALSE</xsl:when>
			<xsl:when test="$value = '1'">TRUE</xsl:when>
			<xsl:when test="$value = '0'">FALSE</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<!-- booleanize test ends -->
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
</xsl:stylesheet>