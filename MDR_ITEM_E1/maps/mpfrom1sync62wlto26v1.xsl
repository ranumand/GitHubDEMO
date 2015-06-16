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
										<xsl:variable name="isBaseUnit" select="isBaseUnit"/>
										<xsl:variable name="vendorProprietary" select="flex/attrGroup[@name='vendorProprietary']"/>
										<xsl:variable name="piHierarchyAttributes" select="flex/attrGroup[@name='piHierarchyAttributes']"/>
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
												<!-- ITEM_MASTER attributes -->												
												<Attribute>
													<xsl:attribute name="name">ISTRADEITEMADISPLAYUNIT</xsl:attribute>
													<Value>
														<xsl:value-of select="flex/attr[@name='isTradeItemADisplayUnit']"/>
													</Value>
												</Attribute>
												<Attribute name="ITEMHASASWELLALLOWANCE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroItemHasASwellAllowance']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="CENTSOFF">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroCentsOff']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISINTENDED4HUMANCONSUMPTION">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsItemIntendedForHumanConsumption']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="BASEITEMAVAILABILITY">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroBaseItemAvailability']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="MODELGTINEXISTS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$piHierarchyAttributes/attr[@name='kroModelGTINExists']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="STERILE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroSterile']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTISWORNINORONTHEBODY">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsWornInOrOnTheBody']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="LINERS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroLiners']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="REUSABLEMEDICALEQUIPMENT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroReusableMedicalEquipment']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISCHEMICAL">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsChemical']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ARCHSUPPORTCLAIM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroArchSupportClaim']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ANTIFUNGALCLAIM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroAntifungalClaim']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="BATTERYINCLUDED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroBatteryIncluded']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="READYTODRINK">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroReadyToDrink']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="MEDICALDOCUMENTATIONREQUIRD">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroMedicalDocumentationRequired']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="STUFFEDFILLED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroStuffedFilled']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PDT4LVSTCKKPTRSDONFRMRNCH">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductForLivestockKeptOrRaisedOnAFarmOrRanch']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="NONGMOPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroNonGMOProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="GLACEPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroGlaceProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PITTEDSTONED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPittedStoned']"/>
													</Value>
												</Attribute>
												<Attribute name="TRANSPARENTCONSUMERPKG">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroTransparentConsumerPackaging']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ITEMISASEAFOODRUB">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroItemIsaSeafoodRub']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="CONTAINSMONOSODIUMGLUTAMATE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsMonosodiumGlutamate']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="WASSUBCLASSDEFAULTED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroWasSubclassDefaulted']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="RECLAIMELIGIBLE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroReclaimEligible']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISITEMUSDAELIGIBLE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsItemUSDAEligible']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ISPRESLICED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIsPresliced']"/>
													</Value>
												</Attribute>
												<Attribute name="ISCOOKED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsCooked']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ISODORELIMINATOR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIsOdorEliminator']"/>
													</Value>
												</Attribute>
												<Attribute name="ISPOISONOUS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsPoisonous']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISSANITIZER">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsSanitizer']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISCORROSIVE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsCorrosive']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="HAZMATMAXIMUMQUANTITY">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroHazmatMaximumQuantity']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISREACTIVE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsReactive']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISPOWERED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsPowered']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="WILLPRODUCTEMITODOR">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroWillProductEmitOdor']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="FLEXPACKAGING">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroFlexPackaging']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="INNERSEAL">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroInnerSeal']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="NOTEARS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroNoTears']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ENDUSERPKGCONTENTBYWGT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroEndUserPackagingContentByWeight']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISRECYCLABLEFLAGONPACKAGE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsRecyclableFlagOnPackage']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="HASDESCCONSRCOMPOSTABILITY">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroHasDescriptionOfConsumerCompostability']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISFINISHEDPKGRECYLABLE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsFinishedPkgRecylable']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISVARIANCESWELLRECLAIM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroVarianceSwellReclaim']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="CONTAINSAMMONIA">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsAmmonia']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="CONTAINCROUTONORSLDDRESSING">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsCroutonOrSaladDressing']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ISWASHEDANDREADYTOEAT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIsWashedAndReadyToEat']"/>
													</Value>
												</Attribute>
												<Attribute name="ISSPINACHONLY">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsSpinachOnly']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISSHREDDEDLETTUCE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsShreddedLettuce']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISSALADBLEND">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsSaladBlend']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISBREAKFASTSAUSAGE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsBreakfastSausage']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="NATURALFLAG">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroNaturalFlag']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="IS100PERCENTPASTEURIZED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIs100PercentPasteurized']"/>
														</xsl:call-template>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">ISPRODUCTAEROSOL</xsl:attribute>
													<Value>
														<xsl:value-of select="flex/attr[@name='isProductAerosol']"/>
													</Value>
												</Attribute>														


												<Attribute name="CERTIFIEDFORPASSOVERDIET">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroCertifiedForPassoverDiet']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="FLAMMABLECOMBUSTIBLE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroFlammableCombustible']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISCOLESLAWORSHREDDEDCABBAGE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsColeSlawOrShreddedCabbage']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISCONSUMERUNIT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="isConsumerUnit"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISBASEUNIT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="isBaseUnit"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISORDERABLEUNIT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="isOrderableUnit"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISDISPATCHUNIT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="isDispatchUnit"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISINVOICEUNIT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="isInvoiceUnit"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">HASDISPLAYREADYPACKAGING</xsl:attribute>
													<Value>
														<xsl:value-of select="flex/attr[@name='hasDisplayReadyPackaging']"/>
													</Value>
												</Attribute>
												<Attribute name="PRICINGONPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="flex/attr[@name='pricingOnProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISVARIABLEWEIGHTITEM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="isVariableWeightItem"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="HASBATCHNUMBER">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="hasBatchNumber"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ISDISINFECTANT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIsDisinfectant']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">HYPOALLERGENIC</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroHypoallergenic']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">RINSEOFF</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroRinseOff']"/>
													</Value>
												</Attribute>	
												<Attribute>
													<xsl:attribute name="name">TIMEOFAPPLICATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTimeOfApplicationV10336']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPCLNSRCSMTCRMVRNONPWRD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCleansersCosmeticsRemoversNonPoweredV10312']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFEXFOLIANTSMASKS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfExfoliantsMasksV10325']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSKINDRYINGPOWDER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSkinDryingPowderV10324']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFTONERSASTRINGENTS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfTonersAstringentsV10323']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ANTIPERSPIRANT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAntiperspirant']"/>
													</Value>
												</Attribute>
												<Attribute name="CLINICALCLAIM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroClinicalClaim']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PROFESSIONALGRADEPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProfessionalGradeProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBRUSH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBrushV10853']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCOMB</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCombV10852']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFHAIRACCESSORY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHairAccessoryV10313']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFHAIRAIDNONPOWERED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHairAidNonPoweredV10087']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFHAIRCURLERSROLLERS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHairCurlersRollersV10726']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">BATTERYORRECHARGEABLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroBatteryOrRechargeableV10352']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DISPOSABLEREPLACEABLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDisposableReplaceableV10346']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ETHNICITYTARGET</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroEthnicityTargetV10345'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroEthnicityTargetV10345']"/>
															</xsl:when>

															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroEthnicityTargetV10997'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroEthnicityTargetV10997']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>



												<Attribute>
													<xsl:attribute name="name">NUMBEROFBLADESONPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfBladesOnProduct']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFFRAGRANCE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFragranceV10661']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPHAIRREMOVESHAVEACCESSORY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHairRemovalShavingAccessoriesV10722']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPSHAVINGRZRNONDISPNONPWRD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfShavingRazorsNonDisposalbeNonPoweredV10724']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CORDEDCORDLESS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCordedCordlessV10316']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DENTURECARETYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDentureCareTypeV10326']"/>
													</Value>
												</Attribute>
												<Attribute name="FLUORIDECLAIM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroFluorideClaim']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">POWERSOURCE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPowerSourceV10575']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPOFDENTUREORTHODONTICCARE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDentureOrthodonticCareV10705']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPDENTUREORTHDNTCCLEANSNG</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDentureOrthodonticCleansingV10706']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFORALCAREAIDSPOWERED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfOralCareAidsPoweredV10318']"/>
													</Value>
												</Attribute>
												<Attribute name="WHITENINGCLAIM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroWhiteningClaim']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="DEXTROMETHORPHANPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroDextromethorphanDMProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="IFSYRUPLOZENGEEXPECTORANT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIfSyrupLozengeExpectorant']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SPRAYORSTRIP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSprayOrStripV10116']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFEARNASALCAREPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfEarNasalCareProductV10119']"/>
													</Value>
												</Attribute>
												<Attribute name="AIDSPREVENTIONSPREADDISEASE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroAidsInThePreventionOrSpreadOfDisease']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">BRACETARGET</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroBraceTargetV10328']"/>
													</Value>
												</Attribute>
												<Attribute name="DURABLEMEDICALEQUIPMENT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroDurableMedicalEquipment']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ISLINIMENT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsLiniment']"/>
														</xsl:call-template>
													</Value>
												</Attribute>	
												<Attribute name="LATEXPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroLatexProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="MEDICALPDTSUITABLE4HOMEUSE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroMedicalProductSuitableForHomeUse']"/>
														</xsl:call-template>
													</Value>
												</Attribute>												
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFBERRY_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfBerryV10452']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFCHERRY_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfCherryV10451']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFGRAPEFRUIT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfGrapefruitV10450']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">VARIETYOFPEACH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroVarietyOfPeachV10464']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NOSGLSERVEPKGSINCONSUMERUNT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfSingleServePackagesInConsumerUnit']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PARTSOFARTICHOKE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPartsOfArtichokeV10459']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFASPARAGUS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfAsparagusV10463']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBEAN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBeanV10443']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFMUSHROOMS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfMushroomsV10460']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPEA</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPeaV10462']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPOTATO</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPotatoV10509']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSOUP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSoupV10107']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CONSUMERSEGMENTTYPE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerSegmentTypeV10394'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerSegmentTypeV10394']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerSegmentTypeV10996'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerSegmentTypeV10996']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerSegmentTypeV11023'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerSegmentTypeV11023']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerSegmentTypeV11034'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerSegmentTypeV11034']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PETTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPetTypeV10623']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SIZEOFANIMALTARGETED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSizeOfAnimalTargetedV10797']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PCTANIMALBYPRODUCTCONTAINED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPercentageOfAnimalByProductContained']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TARGETEDANIMALAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetedAnimalAgeV10905']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">GUARANTEEDANALYSIS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroGuaranteedAnalysis']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FEEDINGINSTRUCTIONS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFeedingInstructions']"/>
													</Value>
												</Attribute>
												
												
												<Attribute>
													<xsl:attribute name="name">TYPEOFBAKINGCOOKINGMIX</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfBakingCookingMixV10650'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfBakingCookingMixV10650']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfBakingCookingMixV11450'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfBakingCookingMixV11450']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">TYPEOFSUGARSUGARSUBSTITUTE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSugarSugarSubstituteV10608']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSYRUPTREACLEMOLASSES</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfSyrupTreacleMolassesV10609'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfSyrupTreacleMolassesV10609']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfSyrupTreacleMolassesV10903'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfSyrupTreacleMolassesV10903']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTISMARINATED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsMarinated']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ITEMISBAKEDBEAN">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroItemIsBakedBean']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="CONDENSEDSOUP">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroCondensedSoup']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="DOESCONSUMERGTINFITSTRRACK">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroDoesConsumerGTINFitInStoreSectionRack']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTISGRAINFREE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsGrainFree']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="DIABETICCLAIM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroDiabeticClaim']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTENDORSEDBYTHEADA">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductEndorsedByTheAmericanDiabetesAssociationADA']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPPETHYGIENESANITARYPRTCTN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPetHygieneSanitaryProtectionV10393']"/>
													</Value>
												</Attribute>
												<Attribute name="PETSNACK">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroPetSnack']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TOMATOPRODUCTPREP_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTomatoProductPreparationV10094']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">ICESOURCE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIceSourceV10401']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSWEETPIEORPASTRY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSweetPieOrPastryV10162']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">LEVELOFPULP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLevelOfPulpV10448']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">VITAMINCPERCENTOFRDA</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroVitaminCPercentOfRecommendedDailyAllowance']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">REDY2DRINKTEABREWORINSTANT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroReadyToDrinkTeaBrewedOrInstantV10449']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">VARTYRDYDRNKCOFFEECOFFEESUB</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroVarietyOfReadyToDrinkCoffeeOrCoffeeSubstituteV10948']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ROASTOFCOFFEE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroRoastOfCoffeeV10949']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCREAMERWHITENER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCreamerWhitenerV10950']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">HONEYPRODUCTPREPARATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroHoneyProductPreparationV10483']"/>
													</Value>
												</Attribute>
												<Attribute name="HONEYTRUESOURCECERTIFICATN">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroHoneyTrueSourceCertification']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTISSEEDLESS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsSeedless']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCHOCOLATE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfChocolateV10108']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPCONFECTIONERYBASEDSPREAD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfConfectioneryBasedSpreadV10110']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFHONEY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHoneyV10095']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEJAMMARMALADEORCONFITURE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfJamMarmaladeOrConfitureV10109']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PERCENTOFPEANUTS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPercentOfPeanuts']"/>
													</Value>
												</Attribute>
												<Attribute name="ADDEDDHAORARA">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroAddedDHAOrARA']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FEEDINGMECHANISM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFeedingMechanismV10344']"/>
													</Value>
												</Attribute>
												<Attribute name="YOGURTPRESENT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroYogurtPresent']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSNACKORMEAL</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfSnackOrMealV10744'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfSnackOrMealV10744']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfSnackOrMealV10837'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfSnackOrMealV10837']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfSnackOrMealV11451'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfSnackOrMealV11451']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFMARINADE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfMarinade']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFMARINADE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfMarinadeV10213']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPETFOODDRINKDISPENSER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPetFoodDrinkDispenserV10637']"/>
													</Value>
												</Attribute>
												<Attribute name="FACIALMOISTURIZER">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroFacialMoisturizer']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">DISTRIBUTORNAME_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$piHierarchyAttributes/attrMany[@name='kroDistributorName']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">ISMEDICATED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIsMedicated']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TARGETMARKET</xsl:attribute>
													<Value>
														<xsl:value-of select="targetMarket"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">EVENTTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$piHierarchyAttributes/attr[@name='kroEventType']"/>
													</Value>
												</Attribute>												
												<Attribute>
													<xsl:attribute name="name">STARTAVAILABILITYDATE</xsl:attribute>
													<Value>
														<xsl:value-of select="startAvailabilityDate"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PACKAGINGMARKEDRETURNABLE</xsl:attribute>
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="packagingMarkedReturnable"/>
														</xsl:call-template>
													</Value>													
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">HI</xsl:attribute>
													<Value>	
														<xsl:value-of select="hi"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TI</xsl:attribute>
													<Value>	
														<xsl:value-of select="ti"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SHIPPINGCASETYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroShippingCaseType']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DISPLAYTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDisplayType']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FRONTOFPACKLABELCLAIMS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFrontOfPackLabelClaims']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">VENDORSWELLPERCENTAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroVendorSwellPercentage']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">POSTCONRECYCLEDMATCONTENT</xsl:attribute>
													<Value>
														<xsl:value-of select="flex/attr[@name='postConsumerRecycledMaterialContent']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">POSTINDSTRIALPERCENTRECYCLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPostIndustrialPercentRecycle']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TOTALRECYCLABLECONTENT</xsl:attribute>
													<Value>
														<xsl:value-of select="flex/attr[@name='totalRecyclableContent']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">LIQUIDDELIVERY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLiquidDelivery']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFLETTUCE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfLettuce']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SALADBLEND</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSaladBlend']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SALADMEAT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSaladMeat']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">MEATFLAVOR_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroMeatFlavor']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">ISCONTINUOUS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIsContinuous']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">FOODSPICELEVEL_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroFoodSpiceLevel']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFCOMPOSTABILTY_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfCompostabilty']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">COFFEEFILTERSIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCoffeeFilterSize']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FILTERCLEANER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFilterCleaner']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">FLAVOR_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroFlavor']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">DESIGNORPRINT</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroDesignOrPrint'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroDesignOrPrint']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroDesignOrPrintOnProductV10874'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroDesignOrPrintOnProductV10874']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroDesignOrPrintV10963'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroDesignOrPrintV10963']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroDesignOrPrintOnProductV10964'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroDesignOrPrintOnProductV10964']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroDesignOrPrintV11113'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroDesignOrPrintV11113']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">SHIPSUSTAINABILITY_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroShipSustainability']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFAPPLE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfAppleV10946']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">RECYCLEMATERIAL_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroRecycleMaterial']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">FAMILYTREEPRIMARYDEPARTMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFamilyTreePrimaryDepartment']"/>														
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FAMILYTREERECAPDEPARTMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFamilyTreeRecapDepartment']"/>														
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FAMILYTREESUBDEPARTMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFamilyTreeSubDepartment']"/>														
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FAMILYTREECLASS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFamilyTreeClass']"/>													
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FAMILYTREESUBCLASS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFamilyTreeSubClass']"/>														
													</Value>
												</Attribute>
												<!--BOC BW mapping of Kroger Family Tree Data-->
												<!--BOC BW mapping of Kroger Family Tree Data For Non Shipper and Simple Shipper Hierarchy-->


												<xsl:if test="((not($noOfCases>1) or not($noOfBaseUnits>1)) and ((not(string-length($familytreeclasscode) = 0)) or ((not($isBaseUnit = 'false')) and not(string-length($vendorProprietary/attr[@name='kroFamilyTreePrimaryDepartment']) = 0))))">
													<Attribute>
														<xsl:attribute name="name">FAMILY_TREE_PRIMARY_DPT_CD</xsl:attribute>
														<Value>
															<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='FAMILYTREEPRIMARYDEPARTMENT']"/>
														</Value>
													</Attribute>
													<Attribute>
														<xsl:attribute name="name">FAMILY_TREE_RECAP_DPT_CD</xsl:attribute>
														<Value>
															<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='FAMILYTREERECAPDEPARTMENT']"/>
														</Value>
													</Attribute>
													<Attribute>
														<xsl:attribute name="name">FAMILY_TREE_DPT_CD</xsl:attribute>
														<Value>
															<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='FAMILY_TREE_DPT_CD']"/>
														</Value>
													</Attribute>
													<Attribute>
														<xsl:attribute name="name">FAMILY_TREE_CLASS_CD</xsl:attribute>
														<Value>
															<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='FAMILY_TREE_CLASS_CD']"/>
														</Value>
													</Attribute>
													<Attribute>
														<xsl:attribute name="name">FAMILY_TREE_SUB_CLASS_CD</xsl:attribute>
														<Value>
															<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='FAMILY_TREE_SUB_CLASS_CD']"/>
														</Value>
													</Attribute>
												</xsl:if>
												<!--EOC BW mapping of Kroger Family Tree Data For Non Shipper and Simple Shipper Hierarchy-->

												<!--BOC BW mapping of Kroger Family Tree Data For Complex Shipper Hierarchy-->
												<xsl:if test="((($noOfCases)>1 and  ($noOfBaseUnits)>1) and (((not($isBaseUnit = 'false')) and (not(string-length($vendorProprietary/attr[@name='kroFamilyTreePrimaryDepartment']) = 0))) or not(string-length(/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='FAMILY_TREE_CLASS_CD']) = 0)))">

													<Attribute>
														<xsl:attribute name="name">FAMILY_TREE_PRIMARY_DPT_CD</xsl:attribute>
														<Value>
															<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='FAMILYTREEPRIMARYDEPARTMENT']"/>
														</Value>
													</Attribute>
													<Attribute>
														<xsl:attribute name="name">FAMILY_TREE_RECAP_DPT_CD</xsl:attribute>
														<Value>
															<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='FAMILYTREERECAPDEPARTMENT']"/>
														</Value>
													</Attribute>
													<Attribute>
														<xsl:attribute name="name">FAMILY_TREE_DPT_CD</xsl:attribute>
														<Value>
															<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='FAMILY_TREE_DPT_CD']"/>
														</Value>
													</Attribute>
													<Attribute>
														<xsl:attribute name="name">FAMILY_TREE_CLASS_CD</xsl:attribute>
														<Value>
															<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='FAMILY_TREE_CLASS_CD']"/>
														</Value>
													</Attribute>
													<Attribute>
														<xsl:attribute name="name">FAMILY_TREE_SUB_CLASS_CD</xsl:attribute>
														<Value>
															<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='FAMILY_TREE_SUB_CLASS_CD']"/>
														</Value>
													</Attribute>
												</xsl:if>
												<!--EOC BW mapping of Kroger Family Tree Data For Complex Shipper Hierarchy-->

												<!--EOC BW mapping of Kroger Family Tree Data-->
												<!--BOC BW mapping of MTX-5077-->
												<Attribute name="MARKDOWN_POSSIBLE_FLG">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='MARKDOWN_POSSIBLE_FLG']"/>
														</xsl:call-template>		
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">EQUIVALENTUOMQUANTITY_UOM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attrQual[@name='kroEquivalentUOMQuantity']/@qual"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">EQUIVALENTUOMQUANTITY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attrQual[@name='kroEquivalentUOMQuantity']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TEMPERATURECONTROLLED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTemperatureControlled']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CENTSOFFQUANTITY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCentsOffQuantity']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">EVENTCODE</xsl:attribute>
													<Value>
														<xsl:value-of select="$piHierarchyAttributes/attr[@name='kroEventCode']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CENTSOFFAMOUNT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCentsOffAmount']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SHIPPINGRESTRICTION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroShippingRestriction']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ESTIMATEAVERAGESALESVOLUME</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attrQual[@name='kroEstimateAverageSalesVolumePerWeekPerStoreInPieces']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">AEROSOLLEVEL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAerosolLevel']"/>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFMEAT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfMeat']/value|
														$vendorProprietary/attrMany[@name='kroTypeOfMeatV10938']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFBABYHBCPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBabyHBCProduct']"/>
													</Value>
												</Attribute>												
												<Attribute>
													<xsl:attribute name="name">TYPEOFSALADMIXPACKAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSaladMixPackage']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBREAKFASTSIDEDISH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBreakfastSideDish']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">COFFEEFILTERPRODUCTFORM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCoffeeFilterProductForm']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPESEAFOODSPICEORSEASONING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSeafoodSpiceOrSeasoningV10503']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSEAFOODMIX</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSeafoodMixV10501']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPCLNSRCSMTCRMVRPWRD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCleansersCosmeticsRemoversPoweredV10004']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFHAIRAIDPOWERED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHairAidPoweredV10005']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SHOELACELENGTH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroShoelaceLength']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSHOELACE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfShoeLaceV10880']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSHINEPOLISHBUFF</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfShinePolishBuffV10879']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCATLITTERACCESSORY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCatLitterAccessoryV10395']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCATLITTER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCatLitterV10397']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TARGETEDFORSNGLORMULTIUSER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetedForSingleOrMultipleUserV10396']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PARASITESTARGETED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroParasitesTargetedV10485']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPETTOY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPetToyV10573']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFUSE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfUseV10547']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSPERMICIDESTREATMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSpermicidesTreatmentV10309']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFHOMEDIAGNOSTICTEST</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHomeDiagnosticTestV10311']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEDIAPHRAGMORCERVICALCAP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDiaphragmOrCervicalCapV10308']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SPERMBLOCKER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSpermBlockerV10354']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PRODUCTUSEINTERNALEXTERNAL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProductUseInternalExternalV10351']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DISPLAYREADOUTTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDisplayReadoutTypeV10350']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">MEDICALTEST</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMedicalTest']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DIETARYMEDICALINTENDEDUSE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDietaryMedicalIntendedUseV10791']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCAKE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCakeV10160']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">VITAMINMINERAL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroVitaminMineralV10117']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEMEDICATEDORTHOFOOTWEAR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfMedicatedOrthopedicFootwearV10137']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFFOOTCAREHYGIENEAID</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFootCareHygieneAidV10115']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SOCKSORFOOTIES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSocksOrFootiesV10334']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">EARPLUGRATING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroEarPlugRating']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPOPTICAPPLNCCARECNTCTLENS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfOpticAppliancesCareContactLensV10304']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPCONTACTLENSGASPERMBLSOFT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfContactLensGasPermeableSoftV10305']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FIRSTAIDINTENDEDUSE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFirstAidIntendedUseV10933']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ACTIVEINGREDIENTSPERCENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroActiveIngredientsPercent']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">WIDTHOFFIRSTAIDPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWidthOfFirstAidProduct']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">LENGTHOFFIRSTAIDPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLengthOfFirstAidProduct']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPHOMEDIAGNOSTICPDTACCSSRY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHomeDiagnosticProductsAccessoriesV10619']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFFIRSTAIDICEHEATEDPACK</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFirstAidIceHeatedPackV10785']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPFIRSTAIDDRESSBNDGPLASTER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFirstAidDressingsBandagesPlastersV10301']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFFIRSTAIDACCESSORY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFirstAidAccessoryV10302']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFFIRSTAIDSLINGSUPPORT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFirstAidSlingSupportV10303']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TARGETDIET</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetDietV10327']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFDIETARYAID</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDietaryAidV10645']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEDIETAIDAPPETITEFATCNTRL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDietaryAidAppetiteFatControlV10310']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CONDOMGENDERTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCondomGenderTypeV10307']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFAPPLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfApple']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CONTAINSFISHSHELLFISH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroContainsFishShellfishV10280']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">RETURNGOODSPOLICY</xsl:attribute>
													<Value>
														<xsl:value-of select="flex/attr[@name='returnGoodsPolicy']"/>
													</Value>
												</Attribute>
												<!--Attribute>
													<xsl:attribute name="name">NOOFSERVINGSPERPACKAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="flex/attr[@name='numberOfServingsPerPackage']"/>
													</Value>
												</Attribute-->
												<Attribute>
													<xsl:attribute name="name">PERCENTOFPRDTTAGGEDWITHEAS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPercentOfProductTaggedWithEAS']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PRODUCTID</xsl:attribute>
													<Value>
														<xsl:value-of select="gtin"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PRODUCTIDEXT</xsl:attribute>
													<Value/>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">INFORMATIONPROVIDERNAME</xsl:attribute>
													<Value>
														<xsl:value-of select="informationProviderName"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">GTIN</xsl:attribute>
													<Value>
														<xsl:value-of select="gtin"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">SCENT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroScent']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">BRANDOWNERGLN</xsl:attribute>
													<Value>
														<xsl:value-of select="brandOwnerGLN"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">GLOBALCLASSCAT_CODE</xsl:attribute>
													<Value>
														<xsl:value-of select="globalClassificationCategory/code"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">UI_PRODUCTDESCRIPTION</xsl:attribute>
													<Value>
														<xsl:value-of select="productDescription[ @lang='en' ]"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">BRANDNAME</xsl:attribute>
													<Value>
														<xsl:value-of select="brandName"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PRODUCTTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="productType"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">BRANDOWNERNAME</xsl:attribute>
													<Value>
														<xsl:value-of select="brandOwnerName"/>
													</Value>
												</Attribute>												
												<Attribute>
													<xsl:attribute name="name">PRIMARYCONTACTNAME</xsl:attribute>
													<Value>
														<xsl:value-of select="$piHierarchyAttributes/attr[@name='kroPrimaryContactName']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">MODELGTIN</xsl:attribute>
													<Value>
														<xsl:value-of select="$piHierarchyAttributes/attr[@name='kroModelGTIN']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">ITEMSUBMISSIONREASONCODE</xsl:attribute>
													<Value>
														<xsl:value-of select="$piHierarchyAttributes/attr[@name='kroItemSubmissionReasonCode']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ITEMSOURCE</xsl:attribute>
													<Value>
														<xsl:value-of select="flex/attr[@name='itemSource']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">COMMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$piHierarchyAttributes/attr[@name='kroComment']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CORPORATEVENDORNUMBER</xsl:attribute>
													<Value>
														<xsl:if test="$piHierarchyAttributes/attr[@name='kroCorporateVendorNumber']">
															<xsl:value-of select="$piHierarchyAttributes/attr[@name='kroCorporateVendorNumber']"/>
														</xsl:if>
													</Value>
												</Attribute>
												<Attribute name="FIRSTORDERDATE">
													<Value>
														<xsl:value-of select="firstOrderDate"/>
													</Value>
												</Attribute>
												<Attribute name="FIRSTSHIPDATE">
													<Value>
														<xsl:call-template name="getDateTime1">
															<xsl:with-param name="dateTime" select="firstShipDate"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="LASTORDERDATE">
													<Value>
														<xsl:value-of select="lastOrderDate"/>
													</Value>
												</Attribute>
												<Attribute name="LASTSHIPDATE">
													<Value>
														<xsl:value-of select="lastShipDate"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PRIMARYCONTACTEMAIL</xsl:attribute>
													<Value>
														<xsl:value-of select="$piHierarchyAttributes/attr[@name='kroPrimaryContactEmail']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">INFORMATIONPROVIDERGLN</xsl:attribute>
													<Value>
														<xsl:value-of select="informationProviderGLN"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NONGTINPALLETHI</xsl:attribute>
													<Value>
														<xsl:value-of select="nonGTINPalletHi"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NONGTINPALLETTI</xsl:attribute>
													<Value>
														<xsl:value-of select="nonGTINPalletTi"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PALLETCODE</xsl:attribute>
													<Value>
														<xsl:value-of select="palletCode"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">MAXIMUMORDERQUANTITY</xsl:attribute>
													<Value>
														<xsl:value-of select="maximumOrderQuantity"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">MINIMUMORDERQUANTITY</xsl:attribute>
													<Value>
														<xsl:value-of select="minimumOrderQuantity"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">REPLACEDITEMGTIN</xsl:attribute>
													<Value>
														<xsl:value-of select="replacedItemGTIN"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SUBBRAND</xsl:attribute>
													<Value>
														<xsl:value-of select="subBrand"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SECURITYTAGTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="securityTagType"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SECURITYTAGLOCATION</xsl:attribute>
													<Value>
														<xsl:value-of select="securityTagLocation"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">MINTRADEITMLIFESPANFRARRVL</xsl:attribute>
													<Value>
														<xsl:value-of select="minimumTradeItemLifespanFromArrival"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">COFFEEFILTERTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCoffeeFilterType']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">GLOBALCLASSCAT_DEFINITION</xsl:attribute>
													<Value>
														<xsl:value-of select="globalClassificationCategory/definition"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">GLOBALCLASSCAT_NAME</xsl:attribute>
													<Value>
														<xsl:value-of select="globalClassificationCategory/name"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DISCONTINUEDATE</xsl:attribute>
													<Value>
														<xsl:value-of select="discontinueDate"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CANCELDATE</xsl:attribute>
													<Value>
														<xsl:value-of select="cancelDate"/>
													</Value>
												</Attribute>
												<MultiValueAttribute> 
													<xsl:attribute name="name">COUPONFAMILYCODE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each   select="couponFamilyCode
														 |flex/attrGroup[@name='avp']/attr[@name='additionalCouponFamilyCode']"> 
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute> 
													<xsl:attribute name="name">TYPEOFMINERAL_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfMineralV10891']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<Attribute>
													<xsl:attribute name="name">NONTHERMALPRESERVATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNonThermalPreservation']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">REFRIGERATIONSTATE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroRefrigerationState']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute> 
													<xsl:attribute name="name">TYPEOFCHEESE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfCheese']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>												
												<Attribute>
													<xsl:attribute name="name">TYPEOFAIRFRESHENER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfAirFreshener']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFDRESSING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDressing']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFSANDWICHSPREAD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSandwichSpread']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">COTTONWOOLPRODUCTFORM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCottonWoolProductForm']"/>
													</Value>
												</Attribute>



												<Attribute>
													<xsl:attribute name="name">OTHERSALADTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherSaladType']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PAPERFILTERTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPaperFilterType']"/>
													</Value>
												</Attribute>

												<Attribute name="CONSUMERLIFESTAGE">
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerLifestage'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerLifestage']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerLifestageV10079'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerLifestageV10079']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerLifestageV10081'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerLifestageV10081']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerLifestageV10082'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerLifestageV10082']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerLifestageV10083'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerLifestageV10083']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerLifestageV10593'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerLifestageV10593']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerLifestageV10594'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerLifestageV10594']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerLifestageV10620'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerLifestageV10620']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerLifestageV10762'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerLifestageV10762']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerLifestageV11069'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerLifestageV11069']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 
												<Attribute name="TOTALQTYNEXTLOWERTRADEITEM">
													<Value>
														<xsl:value-of select="//link/parentItem[@gtin = current()/gtin]/@totalQuantityOfNextLowerLevelTradeItem"/>
													</Value>
												</Attribute>
												<MultiValueAttribute name="UNDANGEROUSGOODSNUMBER_MVL">
													<ValueList>
														<xsl:for-each select="hazardousMaterial/dangerousGoods/unDangerousGoodsNumber">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute name="PACKAGEMARKSETHICAL_MVL">
													<ValueList>
														<xsl:for-each select="packageMarksEthical">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>


												<MultiValueAttribute name="PRIMARYCONTACTPHONE_MVL">
													<ValueList>
														<xsl:for-each select="$piHierarchyAttributes/attrMany[@name='kroPrimaryContactPhone']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute name="COUNTRYOFORIGIN_MVL">
													<ValueList>
														<xsl:for-each select="countryOfOrigin">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute name="NUTRITIONALCLAIMS_MVL">																	
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroNutritionalClaims']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute name="TYPEOFVEGETABLE_MVL">
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfVegetable']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute name="BARCODETYPE_MVL">
													<ValueList>
														<xsl:for-each select="barCodeType">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<Attribute>
													<xsl:attribute name="name">BPAFREEPRODUCTPACKAGING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroBisphenolaBPAFreeProductPackaging']"/>
													</Value>
												</Attribute>	
												<Attribute name="CANSNESTFOREASYSTACKING">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroCansNestForEasyStacking']"/>
														</xsl:call-template>
													</Value>
												</Attribute>			
												<Attribute>
													<xsl:attribute name="name">LVLSUGARSUCROSESWEETNRCLAIM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLevelOfSugarSucroseSweetenerClaimV10423']"/>
													</Value>
												</Attribute>		
												<Attribute>
													<xsl:attribute name="name">MFGTREATMENTCOOKINGPROCESS</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroManufacturersTreatmentCookingProcessV10058'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroManufacturersTreatmentCookingProcessV10058']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroManufacturersTreatmentCookingProcessV10059'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroManufacturersTreatmentCookingProcessV10059']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroManufacturersTreatmentCookingProcessV10061'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroManufacturersTreatmentCookingProcessV10061']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroManufacturersTreatmentCookingProcessV10063'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroManufacturersTreatmentCookingProcessV10063']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroManufacturersTreatmentCookingProcessV10064'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroManufacturersTreatmentCookingProcessV10064']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroManufacturersTreatmentCookingProcessV10065'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroManufacturersTreatmentCookingProcessV10065']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroManufacturersTreatmentCookingProcessV10066'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroManufacturersTreatmentCookingProcessV10066']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroManufacturersTreatmentCookingProcessV10561'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroManufacturersTreatmentCookingProcessV10561']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroManufacturersTreatmentCookingProcessV10621'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroManufacturersTreatmentCookingProcessV10621']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroManufacturersTreatmentCookingProcessV10982'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroManufacturersTreatmentCookingProcessV10982']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroManufacturersTreatmentCookingProcessV10993'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroManufacturersTreatmentCookingProcessV10993']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroManufacturersTreatmentCookingProcessV11021'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroManufacturersTreatmentCookingProcessV11021']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroManufacturersTreatmentCookingProcessV11078'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroManufacturersTreatmentCookingProcessV11078']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroManufacturersTreatmentCookingProcessV11121'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroManufacturersTreatmentCookingProcessV11121']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroManufacturersTreatmentCookingProcessV11190'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroManufacturersTreatmentCookingProcessV11190']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroManufacturersTreatmentCookingProcessV11423'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroManufacturersTreatmentCookingProcessV11423']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroManufacturersTreatmentCookingProcessV11442'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroManufacturersTreatmentCookingProcessV11442']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 
												<Attribute name="PRODUCTSUITABLEFORVEGANS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductConsideredSuitableForVegans']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PDTSUITABLEFORVEGETARIANS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductConsideredSuitableForVegetarians']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">RECIPEOFFOODPRODUCT</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroRecipeOfFoodProductV10098'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroRecipeOfFoodProductV10098']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroRecipeOfFoodProductV10099'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroRecipeOfFoodProductV10099']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroRecipeOfFoodProductV10599'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroRecipeOfFoodProductV10599']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroRecipeOfFoodProductV10600'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroRecipeOfFoodProductV10600']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroRecipeOfFoodProductV10628'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroRecipeOfFoodProductV10628']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroRecipeOfFoodProductV10813'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroRecipeOfFoodProductV10813']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroRecipeOfFoodProductV11250'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroRecipeOfFoodProductV11250']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroRecipeOfFoodProductV11415'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroRecipeOfFoodProductV11415']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroRecipeOfFoodProductV11447'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroRecipeOfFoodProductV11447']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroRecipeOfFoodProductV11428'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroRecipeOfFoodProductV11428']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>	
												<Attribute>
													<xsl:attribute name="name">OTHERRECIPEOFFOODPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherRecipeOfFoodProduct']"/>
													</Value>
												</Attribute>	
												<Attribute name="ISTRADEITEMGLUTENFREE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="flex/attrGroup[@name='avp']/attr[@name='isTradeItemGlutenFree']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">EDIBLESTATE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroEdibleStateV10421']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">LEVELOFSALTSODIUMCLAIM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLevelOfSaltSodiumClaimV10438']"/>
													</Value>
												</Attribute>												
												<Attribute>
													<xsl:attribute name="name">MATURITYOFVEGETABLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMaturityOfVegetableV10300']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFCORN_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfCornV10468']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>														
												<Attribute>
													<xsl:attribute name="name">NOPIECESFIXEDINCONSUMERPKG</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNoOfPiecesFixedInConsumerPackage']"/>
													</Value>
												</Attribute>			
												<Attribute>
													<xsl:attribute name="name">PACKEDPICKLEDORMARINADEPDT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPackedPickledOrMarinadeOfProductV10444']"/>
													</Value>
												</Attribute>				
												<Attribute>
													<xsl:attribute name="name">PRODUCTSTYLE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductStyleV10795'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductStyleV10795']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductStyleV10811'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductStyleV10811']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductStyleV10816'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductStyleV10816']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductStyleV10819'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductStyleV10819']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductStyleV10820'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductStyleV10820']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductStyleV10839'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductStyleV10839']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductStyleV10889'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductStyleV10889']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductStyleV10935'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductStyleV10935']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductStyleV11019'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductStyleV11019']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductStyleV11284'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductStyleV11284']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductStyleV11266'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductStyleV11266']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductStyleV11444'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductStyleV11444']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 	
												<Attribute>
													<xsl:attribute name="name">METHODOFCOOKINGREHEATING</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroMethodOfCookingReheatingV10405'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroMethodOfCookingReheatingV10405']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroMethodOfCookingReheatingV10408'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroMethodOfCookingReheatingV10408']"/>
															</xsl:when>															
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 			
												<Attribute name="VEGETARIANQUALIFIEDPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroVegetarianQualifiedProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>	
												<Attribute>
													<xsl:attribute name="name">ADDLINGREDIENTREQDFORPREP</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroAdditionalIngredientsRequiredForPreparationV10479'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroAdditionalIngredientsRequiredForPreparationV10479']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroAdditionalIngredientsRequiredForPreparationV10767'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroAdditionalIngredientsRequiredForPreparationV10767']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroAdditionalIngredientsRequiredForPreparationV10980'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroAdditionalIngredientsRequiredForPreparationV10980']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DRYORWET</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDryOrWetV10779']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">LEVELOFCOOKING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLevelOfCookingV10151']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPATE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPateV10432']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSAUCECONDIMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSauceCondimentV10211']"/>
													</Value>
												</Attribute>		
												<Attribute>
													<xsl:attribute name="name">DIFFERENTIATINGINGREDIENT</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroDifferentiatingIngredientV10424'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroDifferentiatingIngredientV10424']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroDifferentiatingIngredientV10615'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroDifferentiatingIngredientV10615']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 	
												<Attribute>
													<xsl:attribute name="name">OTHERFLAVOR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherFlavor']"/>
													</Value>
												</Attribute>	
												<Attribute>
													<xsl:attribute name="name">PRIMARYMEALPROTEINTYPE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroPrimaryMealProteinTypeV10320'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroPrimaryMealProteinTypeV10320']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroPrimaryMealProteinTypeV10584'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroPrimaryMealProteinTypeV10584']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroPrimaryMealProteinTypeV10585'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroPrimaryMealProteinTypeV10585']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroPrimaryMealProteinTypeV10598'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroPrimaryMealProteinTypeV10598']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroPrimaryMealProteinTypeV11248'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroPrimaryMealProteinTypeV11248']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 	
												<Attribute>
													<xsl:attribute name="name">BONELESSCLAIM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroBonelessClaim']"/>
													</Value>
												</Attribute>	
												<Attribute>
													<xsl:attribute name="name">FOODBEVERAGETYPE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroFoodBeverageTypeV10342'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroFoodBeverageTypeV10342']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroFoodBeverageTypeV10658'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroFoodBeverageTypeV10658']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroFoodBeverageTypeV10745'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroFoodBeverageTypeV10745']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroFoodBeverageTypeV10757'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroFoodBeverageTypeV10757']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroFoodBeverageTypeV11445'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroFoodBeverageTypeV11445']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 
												<Attribute>
													<xsl:attribute name="name">FRESHORSEAWATERFARMED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFreshOrSeawaterFarmedV10067']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">HARVESTTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroHarvestTypeV10506']"/>
													</Value>
												</Attribute>	
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFFRUIT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfFruitV10019']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>			
												<MultiValueAttribute>
													<xsl:attribute name="name">BASEINGREDIENT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroBaseIngredientV10596']/value|
														$vendorProprietary/attrMany[@name='kroBaseIngredientV10939']/value|
														$vendorProprietary/attrMany[@name='kroBaseIngredientV10971']/value|
														$vendorProprietary/attrMany[@name='kroBaseIngredientV11252']/value
														">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>	
												<Attribute>
													<xsl:attribute name="name">PRIMARYADDITIVE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroPrimaryAdditiveV10511'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroPrimaryAdditiveV10511']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroPrimaryAdditiveV10906'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroPrimaryAdditiveV10906']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroPrimaryAdditiveV11183'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroPrimaryAdditiveV11183']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">ADDEDFLAVORING_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroAddedFlavoringV10106']/value|
														$vendorProprietary/attrMany[@name='kroAddedFlavoringV11003']/value|
														$vendorProprietary/attrMany[@name='kroAddedFlavoringV11046']/value
														">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>	
												<Attribute>
													<xsl:attribute name="name">KIPPERMETHODOFFLAVORING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroKipperMethodOfFlavoringV10455']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PACKAGINGARRANGEMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPackagingArrangementV10457']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SIZEDESCRIPTION</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSizeDescriptionV10277'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroSizeDescriptionV10277']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSizeDescriptionV10278'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSizeDescriptionV10278']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSizeDescriptionV10835'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroSizeDescriptionV10835']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSizeDescriptionV10897'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSizeDescriptionV10897']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSizeDescriptionV10898'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSizeDescriptionV10898']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSizeDescriptionV10899'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSizeDescriptionV10899']"/>
															</xsl:when>															
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSizeDescriptionV10581'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSizeDescriptionV10581']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 																							
												<Attribute name="SKINLESSCLAIM">
													<Value>
														<xsl:call-template name="Booleanize"> 
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroSkinlessClaim']"/>
														</xsl:call-template>
													</Value>
												</Attribute>																								
												<Attribute name="TUNASRCDFRISSFORMSCAPVPACKR">
													<Value>
														<xsl:call-template name="Booleanize"> 
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroTunaSourcedFromAnISSFOrMSCApprovedPacker']"/>
														</xsl:call-template> 
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFAQUATICINVERTEBRATE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfAquaticInvertebrateV10102']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFCRAB_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfCrabV10497']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>	
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFFISHSURIMIREPTILE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfFishSurimiReptileV10001']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>	
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFSHELLFISH_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfShellFishV10022']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>	
												<Attribute>
													<xsl:attribute name="name">TYPEOFTUNA</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfTunaV10456']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSALMON</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSalmonV10648']"/>
													</Value>
												</Attribute>
												<Attribute name="INSAUCE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroInSauce']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CONSUMERPRODUCTTYPE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10338'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10338']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10340'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10340']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10651'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10651']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10721'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10721']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10751'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10751']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10752'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10752']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10800'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10800']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10824'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10824']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10827'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10827']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10828'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10828']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10832'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10832']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10834'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10834']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10838'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10838']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10841'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10841']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10847'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10847']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10848'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10848']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10875'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10875']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10876'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10876']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10877'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10877']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10883'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10883']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10884'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10884']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10885'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10885']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10886'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10886']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10887'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10887']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10901'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10901']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10902'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10902']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10929'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10929']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10934'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10934']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10947'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10947']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10952'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroConsumerProductTypeV10952']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10953'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10953']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10961'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10961']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10979'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10979']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV10986'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV10986']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11014'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11014']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11024'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11024']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11040'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11040']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11119'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11119']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11120'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11120']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11114'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11114']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11200'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11200']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11389'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11389']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11261'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11261']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11386'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11386']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11392'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11392']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11310'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11310']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11268'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11268']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroConsumerProductTypeV11298'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroConsumerProductTypeV11298']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 
												<Attribute>
													<xsl:attribute name="name">PRODUCTSOURCE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductSourceV10121'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductSourceV10121']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductSourceV10123'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductSourceV10123']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductSourceV10578'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductSourceV10578']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductSourceV10764'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductSourceV10764']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSourceOfMilkUsedToProduceProduct'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSourceOfMilkUsedToProduceProduct']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductSourceV10577'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductSourceV10577']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductSourceV11123'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductSourceV11123']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductSourceV11188'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductSourceV11188']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductSourceV11179'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductSourceV11179']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 
												<Attribute>
													<xsl:attribute name="name">VITAMINAPERQUARTININTLUNITS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroVitaminAPerQuartInInternationalUnits']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PROCUREMENT_VARIANT_FLG</xsl:attribute>
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='KGR_PV_FLG']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SALES_VARIANT_FLG</xsl:attribute>
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='KGR_SV_FLG']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">VITAMINDPERQUARTININTLUNITS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroVitaminDPerQuartInInternationalUnits']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERCONSUMERPRODUCTTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherConsumerProductType']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">MFGRECOMMENDEDFEEDINGGUIDE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroManufacturersRecommendedFeedingGuide']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFINNERPACKAGING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfInnerPackagingV10784']"/>
													</Value>
												</Attribute>
												<Attribute name="INNEROUTERCONSUMERPACKAGE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroInnerOuterConsumerPackage']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">BENEFIT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroBenefitV10349']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10843']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10846']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10849']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10851']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10854']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10858']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10862']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10863']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10864']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10865']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10866']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10960']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10962']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV10965']/value|
										                $vendorProprietary/attrMany[@name='kroBenefitV10968']/value|										
														$vendorProprietary/attrMany[@name='kroBenefitV10860']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV11216']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV11218']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV11203']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV11206']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV11199']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV11260']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV11383']/value|
														$vendorProprietary/attrMany[@name='kroBenefitV11396']/value
														">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute> 

												<Attribute>
													<xsl:attribute name="name">OTHERBENEFIT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherBenefit']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHVLUADDINGRDNTCUSTBENEFIT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherValueAddedIngredientForCustomerBenefit']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEFLAVOROFPETFOOD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeFlavorOfPetFoodV10436']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">VLUADDINGRED4CUSTMRBNFT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroValueAddedIngredientForCustomerBenefitV10359']/value|
														$vendorProprietary/attrMany[@name='kroValueAddedIngredientForCustomerBenefitV10360']/value|
														$vendorProprietary/attrMany[@name='kroValueAddedIngredientForCustomerBenefitV10809']/value|
														$vendorProprietary/attrMany[@name='kroValueAddedIngredientForCustomerBenefitV10842']/value|
														$vendorProprietary/attrMany[@name='kroValueAddedIngredientForCustomerBenefitV10826']/value|
														$vendorProprietary/attrMany[@name='kroValueAddedIngredientForCustomerBenefitV10844']/value|
														$vendorProprietary/attrMany[@name='kroValueAddedIngredientForCustomerBenefitV11130']/value|
														$vendorProprietary/attrMany[@name='kroValueAddedIngredientForCustomerBenefitV11202']/value|
														$vendorProprietary/attrMany[@name='kroValueAddedIngredientForCustomerBenefitV10361']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute> 
												<Attribute>
													<xsl:attribute name="name">TYPEOFVINEGAR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfVinegarV10150']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPASTAORNOODLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPastaOrNoodleV10478']"/>
													</Value>
												</Attribute>
												<Attribute name="WHOLEGRAINSCONTAINEDINPDT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroWholeGrainsContainedInProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">INSTANTPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroInstantProduct']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">PASTARECIPESTUFFEDWITH_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroPastaRecipeStuffedWithV10467']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>	
												<Attribute>
													<xsl:attribute name="name">OTHERTARGETUSEAPPLICATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTargetUseApplication']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">EXTRUDED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroExtruded']"/>
													</Value>
												</Attribute>
												<Attribute name="DIAPERSIZE">
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDiaperSize']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFMILK</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfMilkV10453']"/>
													</Value>
												</Attribute>
												<Attribute name="FIBERADDED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroFiberAdded']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="GRANOLA">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroGranola']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="TRAILMIX">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroTrailMix']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">OUTERCOATINGOFPRODUCT</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroOuterCoatingOfProductV10476'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroOuterCoatingOfProductV10476']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroOuterCoatingOfProductV10955'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroOuterCoatingOfProductV10955']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PRODUCTCONSISTENCY</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductConsistencyV10532'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductConsistencyV10532']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductConsistencyV10533'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductConsistencyV10533']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductConsistencyV10535'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductConsistencyV10535']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductConsistencyV10536'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductConsistencyV10536']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductConsistencyV10821'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductConsistencyV10821']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductConsistencyV10908'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductConsistencyV10908']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductConsistencyV10988'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductConsistencyV10988']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 
												<Attribute>
													<xsl:attribute name="name">TYPEOFFRUITNUTSEEDMIX</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFruitNutSeedMixV10427']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPROCESSEDCEREAL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfProcessedCerealV10101']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERTYPEVLUADDENHANCEMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfValueAddedEnhancement']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">REFRIGERATIONCLAIM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroRefrigerationClaimV10155']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFVALUEADDEDENHANCEMENT</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10653'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10653']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10822'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfValueAddedEnhancementV10822']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10840'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfValueAddedEnhancementV10840']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10855'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfValueAddedEnhancementV10855']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10856'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfValueAddedEnhancementV10856']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10867'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10867']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10868'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfValueAddedEnhancementV10868']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10869'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10869']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10870'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfValueAddedEnhancementV10870']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10871'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10871']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10872'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfValueAddedEnhancementV10872']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 
												<Attribute>
													<xsl:attribute name="name">LEVELOFFATCLAIM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLevelOfFatClaimV10439']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBREAD</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfBreadV10120'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfBreadV10120']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfBreadV11452'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfBreadV11452']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
								
												<Attribute>
													<xsl:attribute name="name">GRAMFATPRREGAMTCSTMRLYCNSMD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroGramsOfFatPerRegularAmountCustomarilyConsumed']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERSHAPEOFCONSUMERPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherShapeOfConsumerProduct']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PERCENTOFIRONPEROZ</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPercentOfIronPerOz']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SHAPEOFCONSUMERPRODUCT</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroShapeOfConsumerProductV10499'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroShapeOfConsumerProductV10499']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroShapeOfConsumerProductV11323'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroShapeOfConsumerProductV11323']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroShapeOfConsumerProductV11265'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroShapeOfConsumerProductV11265']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroShapeOfConsumerProductV11421'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroShapeOfConsumerProductV11421']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">WHOLEGRAINPERCENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWholeGrainPercent']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">AMOUNTOFSUGARORSWEETENERS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAmountOfSugarOrSweeteners']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FEEDINGSTG</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFeedingStageV10343']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPBABYINFANTSPECIALISEDBVR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBabyInfantSpecialisedBeverageV10660']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCEREALGRAIN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCerealGrainV10126']"/>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTISAUTHENTICINTLFOOD">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsAuthenticInternationalFood']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFDRESSINGORDIP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfDressingOrDip']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">COOKINGTIME</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCookingTime']"/>
													</Value>
												</Attribute>
												<Attribute name="ENTREEPREPAREDINASINGLEPAN">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroEntreePreparedInaSinglePan']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTISASIDEDISH">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsaSideDish']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ITEMISAPILAF">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroItemIsaPilaf']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PREPARATIONTIME</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPreparationTime']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">OTHERCOLOR_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroOtherColor']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>	
												<Attribute name="RICEMILLED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroRiceMilled']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="RICESPROUTED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroRiceSprouted']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="CONTAINSIRON">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsIron']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERNUTRITIONALBASE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherNutritionalBase']"/>
													</Value>
												</Attribute>
												<Attribute name="SENSITIVECLAIM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroSensitiveClaim']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="TAMPERPROOFSEAL">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroTamperProofSeal']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">RECONSTITUTEDVALUE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroReconstitutedValue']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERSCENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherScent']"/>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTISANTIBACTERIAL">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsAntiBacterial']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="FRAGRANCEFREEPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroFragranceFreeProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FROMCONCENTRATE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFromConcentrate']"/>
													</Value>
												</Attribute>
												<Attribute name="ISPDTDSGNHIGHEFFCNCYMACHINE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsProductDesignedHighEfficiencyMachines']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="DYEFREEPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroDyeFreeProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">IFPRETREATMENTWASH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIfPreTreatmentWash']"/>
													</Value>
												</Attribute>
												<Attribute name="INWASHNONWASHSTAINREMOVERS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroInWashNonWashStainRemovers']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFCLEANINGCAREAID</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfCleaningCareAid']"/>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTDESIGNED4PETCLEANUP">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductDesignedForPetCleanUp']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTISBLEACHFREE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsBleachFree']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERDESIGNORPRINTONPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherDesignOrPrintOnProduct']"/>
													</Value>
												</Attribute>
												<Attribute name="FLUSHABILITY">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroFlushability']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PDTABLETOUSEDINDISPENSER">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductAbleToUsedInDispenser']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTSOLDWITHDISPENSER">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductSoldWithDispenser']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="MOIST">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroMoist']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">AREALENGTHXWIDTHOFBAG</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAreaLengthXWidthOfBag']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFBASEMATERIAL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfBaseMaterial']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CONTAINERCAPACITY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroContainerCapacity']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DIAMETEROFTHECONSUMERITEM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDiameterOfTheConsumerItem']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CAPACITYOFBAG</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attrQual[@name='kroCapacityOfBag']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">LINEARFOOTAGEOFPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLinearFootageOfProduct']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CAPACITYOFBAGUOM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attrQual[@name='kroCapacityOfBag']/@qual"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ALCOHOLPERCENTAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAlcoholPercentage']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERBASEFLAVORCOOKINGWINE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherBaseFlavorOfCookingWine']"/>
													</Value>
												</Attribute>
												<Attribute name="VINEGARFRITALYWTHMODENASEAL">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroVinegarFromItalyWithModenaSeal']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ACIDITYLEVEL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAcidityLevel']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">OTHERACTIVEINGREDIENTS_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroOtherActiveIngredients']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>	
												<Attribute>
													<xsl:attribute name="name">SUNPROTECTIONFACTORVALUESPF</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSunProtectionFactorValueSPF']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">LENGTHOFDOSEEFFECTIVENESS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLengthOfDoseEffectiveness']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFSAUSAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSausage']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TRANFATPERAMTCSTMRLYCNSMD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTransFatPerRegularAmountCustomarilyConsumed']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ISDRSSDPCNDMNTSPCTPSPRDMRND</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIsItemADressingOrDipSauceCondimentSpiceToppingSpreadOrMarinadeV10212']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">AEROSOLNFPASTORAGELEVEL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAerosolNationalFireProtectionAssociationNFPAStorageLevel']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CHLSTRLPRREGAMTCSTMRLYCNSMD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCholesterolPerRegularAmountCustomarilyConsumed']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCHUTNEYORRELISH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfChutneyOrRelishV10154']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFFOODGLAZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFoodGlazeV10429']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FORMOFSAUCEPACKET</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFormOfSaucePacketV10441']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBAKINGCOOKINGSUPPLY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBakingCookingSupplyV10409']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPSAVORYPIEPASTRYPZZQUICHE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSavoryPiePastryPizzaOrQuicheV10440']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ANCIENTGRAIN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAncientGrainV10477']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">LENGTHOFGRAIN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLengthOfGrainV10480']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFLIMABEANS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfLimaBeansV10482']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFRICE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfRiceV10481']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NUTRITIONALBASE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNutritionalBaseV10341']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">INDOOROROUTDOORUSE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroIndoorOrOutdoorUseV10168'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroIndoorOrOutdoorUseV10168']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroIndoorOrOutdoorUseV10676'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroIndoorOrOutdoorUseV10676']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 
												<Attribute>
													<xsl:attribute name="name">TYPEOFEDIBLEANIMALFAT</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfEdibleAnimalFatV10607'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfEdibleAnimalFatV10607']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfEdibleAnimalFatV10606'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfEdibleAnimalFatV10606']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FIBERCONTENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFiberContentV10527']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TARGETGENDER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetGenderV10493']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PRODUCTAKITORREFILL</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductaKitOrRefillV10281'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductaKitOrRefillV10281']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductaKitOrRefillV10836'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductaKitOrRefillV10836']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFDETERGENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDetergentV10414']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEDISHCLEANCAREAUTOMATIC</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDishCleaningCareAutomaticV10167']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PRODUCTCONCENTRATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProductConcentrationV10370']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFFABRICFINISHERSTARCH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFabricFinisherStarchV10655']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFLAUNDRYADDITIVE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfLaundryAdditiveV10413']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFLAUNDRYDRYCLEANING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfLaundryDryCleaningV10613']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFSTAINREMOVER_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfStainRemoverV10806']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>	
												<Attribute>
													<xsl:attribute name="name">TYPEOFLAUNDRYCOLOURCARE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfLaundryColourCareV10612']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DISPENSERTYPE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroDispenserTypeV10314'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroDispenserTypeV10314']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroDispenserTypeV10845'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroDispenserTypeV10845']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">IFABRASIVE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIfAbrasiveV10604']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">MATERIALOFTARGETSURFACE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMaterialOfTargetSurfaceV10768']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PDTUSEDFORLIGHTORDARKWOOD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProductUsedForLightOrDarkWoodV10366']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">STRENGTHACTIONCLAIM</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroStrengthActionClaimV10369'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroStrengthActionClaimV10369']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroStrengthActionClaimV10829'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroStrengthActionClaimV10829']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 
												<Attribute>
													<xsl:attribute name="name">TARUSEPRODUCTONWOODSURFACES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetUseOfProductOnWoodSurfacesV10537']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFDISINFECTANT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDisinfectantV10605']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEDRAINTREATPIPEUNBLOCKER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDrainTreatmentPipeUnblockersV10614']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFMOULDMILDEWREMOVERS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfMouldMildewRemoversV10770']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSURFACECAREPROTECTION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSurfaceCareProtectionV10611']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSURFACECLEANERS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSurfaceCleanersV10610']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFTOILETCLEANINGPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfToiletCleaningProductsV10772']"/>
													</Value>
												</Attribute>
												<Attribute> 
													<xsl:attribute name="name">TYPEOFCLEANINGCAREAID</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfCleaningCareAidV10007'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfCleaningCareAidV10007']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfCleaningCareAidV10831'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfCleaningCareAidV10831']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute> 
													<xsl:attribute name="name">TYPEOFINSOLE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfInsoleV10850'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfInsoleV10850']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfInsoleV10878'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfInsoleV10878']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFWATERSOFTENER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfWaterSoftenerV10417']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SOFTNESSLEVELOFPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSoftnessLevelOfProductV10363']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">THICKNESSOFPRODUCTPLY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroThicknessOfProductPlyV10364']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">THICKNESSOFPRODUCTROLL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroThicknessOfProductRollV10805']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFWIPESPERSONAL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfWipesPersonalV10166']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPAPERORCLOTHPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPaperOrClothProductV10804']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPFACIALTISSUEHNDKRCHFDISP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFacialTissueHandkerchiefsDisposableV10419']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">HOTANDORCOLDCUP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroHotAndOrColdCupV10447']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PAPERSTRENGTH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPaperStrengthV10367']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TRANSLUCENTORCLEAR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTranslucentOrClearV10909']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBASEMATERIAL</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfBaseMaterialV10072'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfBaseMaterialV10072']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfBaseMaterialV10073'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfBaseMaterialV10073']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfBaseMaterialV10586'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfBaseMaterialV10586']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11108'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11108']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11271'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11271']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11385'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11385']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11408'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11408']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11318'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11318']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11290'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11290']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11299'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11299']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11394'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBaseMaterialV11394']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCOOKINGENHANCER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCookingEnhancerV10356']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFDISPOSABLETABLEWARE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDisposableTablewareV10588']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEORALCAREAIDSNONPOWERED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfOralCareAidsNonPoweredV10315']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFDISPOSABLEFOODWRAP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDisposableFoodWrapV10165']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CLOSURETYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroClosureTypeV10330']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSTOCKLIQUIDBONES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfStockLiquidBonesV10164']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">BASEFLAVOROFCOOKINGWINE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroBaseFlavorOfCookingWineV10442']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">IMITATIONORREALBASEOFPDT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroImitationOrRealBaseOfProductV10368']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">MECHANICALPROCESSING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMechanicalProcessingV10153']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFDRIEDBREAD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDriedBreadV10157']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFNUTSEED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfNutSeedV10158']"/>
													</Value>
												</Attribute>
												<Attribute name="OVERNIGHTPROTECTION">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroOvernightProtection']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBABYDIAPER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBabyDiaper']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TARGETAGEDSEGMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetAgedSegmentV10548']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ABSORBENCYLEVELCLAIM</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroAbsorbencyLevelClaimV10415'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroAbsorbencyLevelClaimV10415']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroAbsorbencyLevelClaimV10888'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroAbsorbencyLevelClaimV10888']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>												
												<Attribute>
													<xsl:attribute name="name">ADDITIVEFORODOR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAdditiveForOdorV10322']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">APPLICATORTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroApplicatorTypeV10347']"/>
													</Value>
												</Attribute>
												<Attribute name="DRUGFACTLABELINGONPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroDrugFactLabelingOnProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ENEMAORDOUCHE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroEnemaOrDoucheV10306']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FEMININECLEANINGPDTCONTAINS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFeminineCleaningProductContains']"/>
													</Value>
												</Attribute>
												<Attribute name="ADULTINCONTINENCERELATED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroAdultIncontinenceRelated']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">VITAMINLETTER_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroVitaminLetterV10355']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>	
												<Attribute name="ISANTISEPTIC">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsAntiseptic']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="PRODUCTSECUREDWITHWINGS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductSecuredWithWings']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="TRAVELSIZE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroTravelSize']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFADULTINCONTINENCEPADS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfAdultIncontinencePadsV10416']"/>
													</Value>
												</Attribute>
												<Attribute name="BIODEGRADABILITY">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroBiodegradability']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFREFUSEBAG</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfRefuseBagV10017']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPDESSERTSAUCETOPPNGFILLNG</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDessertSauceToppingFillingV10358']"/>
													</Value>
												</Attribute>
												<Attribute name="PDT4TREATOFNICOTINEADDICTN">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsForTheTreatmentOfNicotineAddiction']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DOSAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDosage']"/>
													</Value>
												</Attribute>
												<Attribute name="MEDICALSUPPLY">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroMedicalSupply']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="CONTAINSCAFFEINE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsCaffeine']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="STIMULANT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroStimulant']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="THERMAL">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroThermal']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PSEUDOEPHEDRINEFLAG">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroPseudoephedrineFlag']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFHERBALSUPPLEMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfHerbalSupplement']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFMINERAL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfMineral']"/>
													</Value>
												</Attribute>
												<Attribute name="CONTAINSFLOUR">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsFlour']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERCLEANINGCAREINTENDUSE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherCleaningCareIntendedUse']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DISPOSABLEPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDisposableProduct']"/>
													</Value>
												</Attribute>
												<Attribute name="ACCELERANT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroAccelerant']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">WATERRESISTANTCLAIM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWaterResistantClaim']"/>
													</Value>
												</Attribute>
												<Attribute name="INSECTREPELLENTCLAIM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroInsectRepellentClaim']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="HOTSMOKED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroHotSmoked']"/>
														</xsl:call-template>
													</Value>
												</Attribute>												
												<Attribute name="COLDSMOKED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroColdSmoked']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">GLAZEDPERCENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroGlazedPercent']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PERCENTBROKEN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPercentBroken']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">WATERPICKUPPERCENTAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWaterPickupPercentage']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SOAKTIME</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSoakTime']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FILLETSIZEVARIABLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFilletSizeVariable']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FILLETSIZEFIXED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFilletSizeFixed']"/>
													</Value>
												</Attribute>
												<Attribute name="CONTAINSTAILS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsTails']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="CONTAINSCOLLARS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsCollars']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="CONTAINSMEATORMEATSUBS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsMeatOrMeatSubstitutes']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEHSHLDFOODBEVSTRGCNTNR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHouseholdFoodBeverageStorageContainers']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SPECIESOFSHELLFISH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSpeciesOfShellfishV10402']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">HARVESTBODYOFWATER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroHarvestBodyOfWaterV10403']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">VARIETYOFPOPCORN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroVarietyOfPopcornV10008']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPENUTSPRODUCTCONTAINS_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfNutsProductContainsV10469']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">TYPEEDIBLEVEGETABLEPLANTOIL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfEdibleVegetableOrPlantOilV10420']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">SNACKPARTYTRAYCONTAINS_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroSnackPartyTrayContainsV10375']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">FORMATOFLABELCOUPONTICKET</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFormatOfLabelsCouponsTicketsV10617']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SUSTAINABILITYACCREDITATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSustainabilityAccreditation']"/>
													</Value>
												</Attribute>
												<Attribute name="GFSICERTIFIED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroGlobalFoodSafetyInitiativeGFSICertified']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="SNACK">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroSnack']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ISITEMASALADORSPREAD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIsItemASaladOrSpreadV10530']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPICKLE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfPickleV10437'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfPickleV10437']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfPickleV11446'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfPickleV11446']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
									
												<Attribute>
													<xsl:attribute name="name">TYPEOFHERBSPICE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfHerbSpiceV10435'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfHerbSpiceV10435']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfHerbSpiceV11448'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfHerbSpiceV11448']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFFLOUR</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfFlourV10399'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfFlourV10399']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfFlourV11449'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfFlourV11449']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
									
												<Attribute>
													<xsl:attribute name="name">TYPEOFDESSERT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDessertV10161']"/>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTISBROTH">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsBroth']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">WEIGHTRANGEFORCONSUMERPKG</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWeightRangeForConsumerPackageV10373']"/>
													</Value>
												</Attribute>
												<Attribute name="PRODUCTISLUNCHMEAT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsLunchmeat']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">MEATORIGIN_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroMeatOriginV10321']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">PERCENTPOULTRY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPercentPoultry']"/>
													</Value>
												</Attribute>
												<Attribute name="SINGLEITEMMEAL">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroSingleItemMeal']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PREPAREDPROCESSEDMEALKIT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroPreparedProcessedMealKit']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PREPPRESERVDFOODVARIETYPCKS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroPreparedPreservedFoodsVarietyPacks']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="CONVENIENCEMEALCONTAINDRINK">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroConvenienceMealContainsDrink']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="PORKCRACKLING">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroPorkCrackling']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPOULTRY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPoultryV10371']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPESKINCAREMOISTURIZINGPDT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSkinCareMoisturizingProductV10118']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PROGRAMPHASEORSTEP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProgramPhaseOrStepV10335']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFHABITTREATMENT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfHabitTreatmentV10922']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">SYMPTOMRELIEF</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSymptomReliefV10128'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroSymptomReliefV10128']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSymptomReliefV10129'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroSymptomReliefV10129']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSymptomReliefV10130'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSymptomReliefV10130']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSymptomReliefV10132'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSymptomReliefV10132']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSymptomReliefV10133'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSymptomReliefV10133']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSymptomReliefV10134'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSymptomReliefV10134']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSymptomReliefV10135'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSymptomReliefV10135']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSymptomReliefV10136'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSymptomReliefV10136']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSymptomReliefV11234'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSymptomReliefV11234']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSymptomReliefV11205'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroSymptomReliefV11205']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 
												<MultiValueAttribute>
													<xsl:attribute name="name">ACTIVEINGREDIENTS_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroActiveIngredientsV10297']/value|
														$vendorProprietary/attrMany[@name='kroActiveIngredientsV10587']/value|
														$vendorProprietary/attrMany[@name='kroActiveIngredientsV10765']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute> 
												<Attribute>
													<xsl:attribute name="name">AGERESTRICTED</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroAgeRestrictedV10498'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroAgeRestrictedV10498']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroAgeRestrictedV11041'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroAgeRestrictedV11041']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroAgeRestrictedV11073'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroAgeRestrictedV11073']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PSEAMOUNTINPKG</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPSEAmountInPkgV10486']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFHERBALSUPPLEMENT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfHerbalSupplementV10892']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBISCUITCOOKIE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfBiscuitCookieV10105'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfBiscuitCookieV10105']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfBiscuitCookieV11435'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfBiscuitCookieV11435']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFFIRESTARTERBURNINGPDT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFireStarterBurningProductV10895']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CANNINGJARSREGULARWIDEMOUTH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCanningJarsRegularAndWideMouthV10279']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CANNINGMIXES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCanningMixesV10332']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCANNINGADDITIVE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCanningAdditiveV10894']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCANNINGPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCanningProductV10689']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">INTENDEDUSE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIntendedUseV10543']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPECLEANINGCAREACCESSORIES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCleaningCareAccessoriesV10508']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFHANDWEAR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHandwearV10753']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">VERTICALSHAPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroVerticalShapeV10331']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PERSONALAREA</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPersonalAreaV10329']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TARGRPINSECTPESTRODENTICIDE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetGroupOfInsecticidesPesticidesRodenticidesV10002']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFNONPERSONALREPELLENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfNonPersonalRepellentV10003']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERCOOKWAREINTENDEDUSE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherCookwareIntendedUse']"/>
													</Value>
												</Attribute>
												<Attribute name="CONTAINSPATTERN">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsPattern']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">COOKWAREINTENDEDUSE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCookwareIntendedUseV10542']"/>
													</Value>
												</Attribute>
												<Attribute name="DROWSINESSWARNING">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroDrowsinessWarning']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DXMAMOUNTINPACKAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDXMAmountInPackage']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">ACTIVEINGREDIENTMED_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroActiveIngredientsMedication']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFCUTSLICE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfCutSliceV10076']/value|
														$vendorProprietary/attrMany[@name='kroTypeOfCutSliceV11157']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCASINGFORMEATPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCasingForMeatProductV10504']"/>
													</Value>
												</Attribute>
												<Attribute name="CONTAINSNITRITES">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsNitrites']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="CONTAINSNITRATES">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsNitrates']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">BACONFORM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroBaconFormV10374']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ANATOMICALFORM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAnatomicalFormV10936']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FIRMNESSOFCHEESE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFirmnessOfCheeseV10426']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PIECESINCONSPKGFIXORVARY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPiecesInConsumerPackageFixedOrVariableV10505']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">OTHERTYPEOFCUTSLICE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroOtherTypeOfCutSlice']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">NOPCSVARIABLERNGCONSPKG_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroNoOfPiecesVariableRangeInConsumerPackage']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">ADDITIVESOLUTIONTYPEUSED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAdditiveSolutionTypeUsedV10372']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">CHICKENCUT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroChickenCutV10434']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">LIGHTORDARKMEAT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLightOrDarkMeatV10782']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ADDITIVESOLUTIONPERCENTAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAdditiveSolutionPercentage']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">BEEFGRADE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroBeefGradeV10502']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">BEEFTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroBeefTypeV10388']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PERCENTLEAN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPercentLean']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ANIMALRAISEDINCAGEFREEENV</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAnimalRaisedInaCageFreeEnvironment']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ANIMALRAISEDINFREERANGEENV</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAnimalRaisedInaFreeRangeEnvironment']"/>
													</Value>
												</Attribute>
												<Attribute name="CONTAINSADDITIVESSOLUTION">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsAdditivesSolution']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="DOESPKGCNTNMORETHN1VRYOFITM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroDoesPackageContainMoreThanOneVarietyTypeOfItem']"/>
														</xsl:call-template>
													</Value>
												</Attribute>												
												<Attribute>
													<xsl:attribute name="name">ANIMALFEEDTYPEALLVEGETABLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAnimalFeedTypeIsAllVegetable']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ISANIMALGRASSFED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIsAnimalGrassFed']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">ESTABLISHMENTNO_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroEstablishmentNo']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute name="ORGANICCLAIM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroOrganicClaim']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFCONSUMERPACKAGE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfConsumerPackageV10319']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">RECYCLEDMATERIALCONTENT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroRecycledMaterialContent']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<Attribute>
													<xsl:attribute name="name">SNACKTYPEORTHEME</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSnackTypeOrTheme']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">LVLCNCNTRTN4LNDRYDTRGNTADD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLevelOnConcentrationForLaundryDetergentsOrAdditivesV10470']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERMEATSALADS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherMeatSalads']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SPINACHTARGETUSE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSpinachTargetUseV10496']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCABBAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCabbageV10431']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFHEADICEBERGLETTUCE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHeadIcebergLettuceV10430']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">INITIALTERMS</xsl:attribute>
													<Value>
														<xsl:value-of select="$piHierarchyAttributes/attr[@name='kroInitialTerms']"/>
													</Value>
												</Attribute>
												<Attribute name="SELLABLEFLAG">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroSellableFlag']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="EXTENDEDPAYMENTTERMSFLAG">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$piHierarchyAttributes/attr[@name='kroExtendedPaymentTermsFlag']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FREEFORMCOMMENT4EXTENDTERMS</xsl:attribute>
													<Value>
														<xsl:value-of select="$piHierarchyAttributes/attr[@name='kroFreeFormCommentsForExtendedTerms']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">REQUESTOROFITEM</xsl:attribute>
													<Value>
														<xsl:value-of select="$piHierarchyAttributes/attr[@name='kroRequestorOfItem']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERENZYMESOURCE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherEnzymeSource']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">CONSMRPKGCHARACTERISTIC_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroConsumerPackageCharacteristicsV10021']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute name="PACKAGEDANDREADYFORSALE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroPackagedAndReadyForSale']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">PRODUCTDATINGMETHOD_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroProductDatingMethod']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">ENZYMESOURCE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroEnzymeSourceV10915']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">GELATINSOURCE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroGelatinSourceV10916']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">OTHERGELATINSOURCE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherGelatinSource']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFCONSUMERPACKAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfConsumerPackage']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHCONSMRPKGCHARACTERISTICS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherConsumerPackageCharacteristics']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">MINIMUMDAYSOFSHELFLIFEINSTR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMinimumDaysOfShelfLifeInStore']"/>
													</Value>
												</Attribute>
												<!--Attribute>
													<xsl:attribute name="name">MAXIMUMDAYSATPRODUCTION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMaximumDaysAtProduction']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">MINIMUMDAYSATPRODUCTION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMinimumDaysAtProduction']"/>
													</Value>
												</Attribute-->
												<Attribute>
													<xsl:attribute name="name">CALIFORNIAREDEMPTIONVALUE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCaliforniaRedemptionValue']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFLABELING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfLabelingV10514']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">COLOR_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroColorV10825']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute> 
													<xsl:attribute name="name">PRODUCTFORM</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10024'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10024']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10025'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10025']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10026'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10026']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10027'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10027']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10028'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10028']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10032'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10032']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10034'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10034']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10036'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10036']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10039'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10039']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10040'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10040']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10041'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10041']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10042'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10042']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10043'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10043']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10044'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10044']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10045'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10045']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10046'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10046']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10047'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10047']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10048'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10048']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10049'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10049']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10051'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10051']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10052'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10052']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10053'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10053']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10054'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10054']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10055'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10055']"/>
															</xsl:when>				
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10521'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10521']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10525'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10525']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10545'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10545']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10546'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10546']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10590'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10590']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10624'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10624']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10625'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10625']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10626'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10626']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10627'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10627']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10670'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10670']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10680'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10680']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10690'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10690']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10749'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10749']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10808'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10808']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10818'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10818']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10830'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10830']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10857'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10857']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10861'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10861']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10881'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10881']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10890'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10890']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10904'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroProductFormV10904']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10932'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10932']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10981'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10981']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV10977'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV10977']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11012'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11012']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11022'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11022']"/>
															</xsl:when>															
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11033'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11033']"/>
															</xsl:when>															
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11018'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11018']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroCheeseProductForm'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroCheeseProductForm']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroSaladDressingFormation'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroSaladDressingFormation']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroBabyTreatmentFormation'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroBabyTreatmentFormation']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroPaperTowelProductForm'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroPaperTowelProductForm']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroMeatShape'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroMeatShape']"/>
															</xsl:when>	
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11075'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11075']"/>
															</xsl:when>	
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11124'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11124']"/>
															</xsl:when>	
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11049'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11049']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11008'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11008']"/>
															</xsl:when>	
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11189'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11189']"/>
															</xsl:when>		
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11181'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11181']"/>
															</xsl:when>	
															<xsl:when test="not(string-length($vendorProprietary/attr[@name ='kroBabyTreatmentFormationV11217'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroBabyTreatmentFormationV11217']"/>
															</xsl:when>	
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11201'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11201']"/>
															</xsl:when>	
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11249'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11249']"/>
															</xsl:when>	
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11254'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11254']"/>
															</xsl:when>	
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11267'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11267']"/>
															</xsl:when>						
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11427'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11427']"/>
															</xsl:when>	
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11422'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11422']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11434'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11434']"/>
															</xsl:when>		
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11436'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11436']"/>
															</xsl:when>	
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroProductFormV11441'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroProductFormV11441']"/>
															</xsl:when>	
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute> 
													<xsl:attribute name="name">FISHSHELLFISHCUTSHAPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFishShellfishCutShapeV10069']"/>
													</Value>
												</Attribute>  
												<Attribute> 
													<xsl:attribute name="name">METHODSTYLEOFPREPARATION</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroMethodStyleOfPreparationV10490'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroMethodStyleOfPreparationV10490']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroMethodStyleOfPreparationV10492'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroMethodStyleOfPreparationV10492']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroMethodStyleOfPreparationV10551'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroMethodStyleOfPreparationV10551']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroMethodStyleOfPreparationV10583'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroMethodStyleOfPreparationV10583']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroMethodStyleOfPreparationV10815'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroMethodStyleOfPreparationV10815']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroMethodStyleOfPreparationV10487'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroMethodStyleOfPreparationV10487']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroMethodStyleOfPreparationV10488'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroMethodStyleOfPreparationV10488']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroMethodStyleOfPreparationV10491'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroMethodStyleOfPreparationV10491']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroMethodStyleOfPreparationV10945'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroMethodStyleOfPreparationV10945']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroMethodStyleOfPreparationV10987'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroMethodStyleOfPreparationV10987']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute> 
													<xsl:attribute name="name">TYPEOFCAVIAR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCaviarV10454']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">ADDEDINGREDIENTS_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroAddedIngredientsV10138']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10139']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10140']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10141']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10144']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10145']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10146']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10147']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10148']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10149']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10595']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10812']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10814']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10833']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10954']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV10966']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV11173']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV11255']/value|
														$vendorProprietary/attrMany[@name='kroAddedIngredientsV11420']/value">

															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute> 
												<Attribute name="CONTAINSCHLORINE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsChlorine']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">SKINCARETARGETEDUSE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroSkincareTargetedUseV10529']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute> 
													<xsl:attribute name="name">TYPEOFSANDWICH</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfSandwichV10794'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfSandwichV10794']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfSandwichV10927'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfSandwichV10927']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfSandwichV11416'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfSandwichV11416']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute> 
												<Attribute>
													<xsl:attribute name="name">TARGETUSEAPPLICATION</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10010'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10010']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10012'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10012']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10013'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10013']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10015'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10015']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10091'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10091']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10092'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10092']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10093'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10093']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10538'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10538']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10539'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10539']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10540'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10540']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10541'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10541']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10558'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10558']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10579'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10579']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10630'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10630']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10631'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10631']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10657'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10657']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10662'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10662']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10710'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10710']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10755'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10755']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10766'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10766']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10789'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTargetUseApplicationV10789']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10802'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10802']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10823'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10823']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10873'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10873']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10907'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10907']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10931'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10931']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10970'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10970']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV10983'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV10983']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV11037'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV11037']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV11054'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV11054']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTargetUseApplicationV11134'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTargetUseApplicationV11134']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTargetUseApplicationV11111'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetUseApplicationV11111']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTargetUseApplicationV10011'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetUseApplicationV10011']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTargetUseApplicationV11081'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetUseApplicationV11081']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTargetUseApplicationV11209'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetUseApplicationV11209']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTargetUseApplicationV11388'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetUseApplicationV11388']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTargetUseApplicationV11384'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetUseApplicationV11384']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTargetUseApplicationV11321'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetUseApplicationV11321']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTargetUseApplicationV11279'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetUseApplicationV11279']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTargetUseApplicationV11395'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetUseApplicationV11395']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name='kroTargetUseApplicationV11304'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetUseApplicationV11304']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute name="BREADED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroBreaded']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="INTENDUSAGEASTOPORINGREDNT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIntendedToBeUsedAsAToppingOrIngredient']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="SINGLEINGREDIENT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroSingleIngredient']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="STUFFINGPREPAREDPROCESSED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroStuffingPreparedAndProcessed']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">PLANTLINENUMBER_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$piHierarchyAttributes/attrMany[@name='kroPlantLineNumber']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">ESTIMATEAVGSALESVOLUMEUOM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attrQual[@name='kroEstimateAverageSalesVolumePerWeekPerStoreInPieces']/@qual"/>	
													</Value>
												</Attribute>

												<Attribute name="SUSHI">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroSushi']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="PRODUCTISPICKLED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsPickled']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="INSTOREPREPAREDPACKAGED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroInStorePreparedPackaged']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="CALIFORNIAREDEMPTIONFLAG">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroCaliforniaRedemptionFlag']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">OTHERADDEDINGREDIENTS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherAddedIngredients']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">OTHEROUTERCOATINGOFPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherOuterCoatingOfProduct']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">JUICEPERCENTAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroJuicePercentage']"/>
													</Value>
												</Attribute>
												<xsl:if test="gtin=../hierarchyInformation/publishedGTIN">
													<Attribute>
														<xsl:attribute name="name">PUBLISHED_GTIN_FLG</xsl:attribute>   
														<Value>	TRUE</Value>    
													</Attribute>
												</xsl:if>

												<!--BOC Mapping attributes Derived from BW -->
												<Attribute name="SHIPPER_FLG">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='KGR_SHIPPER_FLG']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<xsl:if test="gtin = $root_gtin">
													<Attribute name="ITEM_DATA_SOURCE_NME">
														<Value>
															<xsl:value-of select="$itemsourceorigin"/>
														</Value>
													</Attribute>
												</xsl:if>			
												<Attribute name="ISSCANNABLEBARCODE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin=$keyid]/ns0:derived_attr[@name='ISSCANNABLEBARCODE']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="KROGER_NATURAL_FOODS_FLG">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin=$keyid]/ns0:derived_attr[@name='KROGER_NATURAL_FOODS_FLG']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">EAS_TAG_CLASS_CD</xsl:attribute>
													<Value>													
														<xsl:choose>
															<xsl:when test="($isBaseUnit = 'true' and string-length(/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='EAS_CD']) > 0 )">
																<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='EAS_CD']"/>
															</xsl:when>															
															<xsl:otherwise>
																<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/hierarchy/sv_item[@gtin=$keyid]/ns0:derived_attr[@name='EAS_CD']"/>
															</xsl:otherwise>
														</xsl:choose>														
													</Value>
												</Attribute>																							


												<Attribute>
													<xsl:attribute name="name">IMPORTED_CHEESE_FLG</xsl:attribute>
													<Value>

														<xsl:choose>
															<xsl:when test="($isBaseUnit = 'true' and string-length(/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='ISIMPORTEDCHEESE']) > 0 )">
																<xsl:call-template name="Booleanize">
																	<xsl:with-param name="value" select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='ISIMPORTEDCHEESE']"/>
																</xsl:call-template>	
															</xsl:when>															
															<xsl:otherwise>
																<xsl:call-template name="Booleanize">
																	<xsl:with-param name="value" select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/hierarchy/sv_item[@gtin=$keyid]/ns0:derived_attr[@name='ISIMPORTEDCHEESE']"/>	
																</xsl:call-template>	
															</xsl:otherwise>
														</xsl:choose>	

													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">FLASH_POINT_TEMP_VLU</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="$isBaseUnit = 'true'">
																<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='FLASH_POINT_TEMP_VLU']"/>
															</xsl:when>				
														</xsl:choose>													    
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DLV_TO_DC_TEMP_MIN_VLU</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="$isBaseUnit = 'true'">
																<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='DLV_TO_DC_TEMP_MIN_VLU']"/>
															</xsl:when>				
														</xsl:choose>													    
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DLV_TO_DC_TEMP_MAX_VLU</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="$isBaseUnit = 'true'">
																<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='DLV_TO_DC_TEMP_MAX_VLU']"/>
															</xsl:when>				
														</xsl:choose>													    
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">STORAGE_TEMP_MIN_VLU</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="$isBaseUnit = 'true'">
																<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='STORAGE_TEMP_MIN_VLU']"/>
															</xsl:when>		
														</xsl:choose>													    
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">STORAGE_TEM_MAX_VLU</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="$isBaseUnit = 'true'">
																<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='STORAGE_TEM_MAX_VLU']"/>
															</xsl:when>				
														</xsl:choose>													    
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">FLASH_POINT_TEMP_UOM_CD</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="((not(string-length(hazardousMaterial/flashPointTemperature/@uom)) = 0) and $isBaseUnit = 'true')">
																<xsl:value-of select="'FA'"/>
															</xsl:when>															
															<xsl:otherwise/>
														</xsl:choose>	
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DLV_TO_DC_TEMP_MAX_UOM_CD</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="((not(string-length(deliveryToDCTemperatureMaximum/@uom)) = 0) and $isBaseUnit = 'true')">
																<xsl:value-of select="'FA'"/>
															</xsl:when>															
															<xsl:otherwise/>
														</xsl:choose>	
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DLV_TO_DC_TEMP_MIN_UOM_CD</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="((not(string-length(deliveryToDCTemperatureMinimum/@uom)) = 0) and $isBaseUnit = 'true')">
																<xsl:value-of select="'FA'"/>
															</xsl:when>															
															<xsl:otherwise/>
														</xsl:choose>	
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">STORAGE_TEMP_MIN_UOM_CD</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="((not(string-length(storageHandlingTempMin/@uom)) = 0) and $isBaseUnit = 'true')">
																<xsl:value-of select="'FA'"/>
															</xsl:when>															
															<xsl:otherwise/>
														</xsl:choose>
													</Value>												
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">STORAGE_TEM_MAX_UOM_CD</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="((not(string-length(storageHandlingTempMax/@uom)) = 0) and $isBaseUnit = 'true')">
																<xsl:value-of select="'FA'"/>
															</xsl:when>															
															<xsl:otherwise/>
														</xsl:choose>	
													</Value>	
												</Attribute>

												<Attribute name="BONUS_PACK_FLG">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='bns_pak_fl']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="NET_WEIGHT_VLU">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='NET_WEIGHT_VLU']"/>
													</Value>
												</Attribute>
												<Attribute name="GROSS_WEIGHT_VLU">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='GROSS_WEIGHT_UOM_VLU']"/>
													</Value>
												</Attribute>
												<Attribute name="PRODUCT_CLASS_CD">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='PRODUCT_CLASS_CD']"/>
													</Value>
												</Attribute>
												<Attribute name="GROSS_WEIGHT_UOM_CD">
													<Value>
														<xsl:value-of select="&quot;LB&quot;"/>
													</Value>
												</Attribute>
												<Attribute name="NET_WEIGHT_UOM_CD">
													<Value>
														<xsl:value-of select="&quot;LB&quot;"/>
													</Value>
												</Attribute>
												<Attribute name="HEIGHT_UOM_CD">
													<Value>
														<xsl:value-of select="&quot;IN&quot;"/>
													</Value>
												</Attribute>
												<Attribute name="DEPTH_UOM_CD">
													<Value>
														<xsl:value-of select="&quot;IN&quot;"/>
													</Value>
												</Attribute>
												<Attribute name="WIDTH_UOM_CD">
													<Value>
														<xsl:value-of select="&quot;IN&quot;"/>
													</Value>
												</Attribute>
												<Attribute name="DEPTH_VLU">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='OVERRIDE_DEPTH_VLU']"/>
													</Value>
												</Attribute>
												<Attribute name="HEIGHT_VLU">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='OVERRIDE_HEIGHT_VLU']"/>
													</Value>
												</Attribute>
												<Attribute name="WIDTH_VLU">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='OVERRIDE_WIDTH_VLU']"/>
													</Value>
												</Attribute> 
												<Attribute name="NET_CONTENT_UOM_CD">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='OVERRIDE_NET_CONTENT_UOM_CD']"/>
													</Value>
												</Attribute>
												<Attribute name="NET_CONTENT_VLU">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='OVERRIDE_NET_CONTENT_VLU']"/>
													</Value>
												</Attribute>


												<Attribute name="EAS_TAGGING_METHOD_CD">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/hierarchy/sv_item[@gtin= $keyid]/ns0:derived_attr[@name='EAS_TAGGING_METHOD_CD']"/>
													</Value>
												</Attribute>
												<Attribute name="KLP_KMP_CD">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='KLP_KMP_CD']"/>
													</Value>
												</Attribute>
												<Attribute name="PROMOTIONAL_PACK_CD">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='PROMOTIONAL_PACK_CD']"/>
													</Value>
												</Attribute>
												<Attribute name="KROGER_MANUFACTURING_CD">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='Kroger_Manufacture_CD']"/>
													</Value>
												</Attribute>
												<Attribute name="CORPORATE_BRAND_TYPE_CD">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='CORP_BRAND_ITEM_TYPE']"/>
													</Value>
												</Attribute>
												<Attribute name="CASE_DSC_TXT">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='CASE_DSC_TXT']"/>
													</Value>
												</Attribute>
												<Attribute name="SHELF_TAG_DSC">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='SHELF_TAG_DSC']"/>
													</Value>
												</Attribute>
												<!-- Kroger Bulk Flag mapping -->
												<Attribute name="KROGER_BULK_ITEM_FLG">
													<Value>
														<xsl:value-of select="/Message/Body/Document/OriginalDocument/os:envelope/catalogueItemNotification/document/ns0:kgr_derived/item_attributes[@gtin= $keyid]/ns0:derived_attr[@name='KGR_BULK_FLG']"/>
													</Value>
												</Attribute>
												<Attribute name="MILKPRODUCTSUBSTITUTE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroMilkProductSubstitute']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PROBIOTICCLAIM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProbioticClaim']"/>
													</Value>
												</Attribute>
												<Attribute name="PRICEIMPRINTONPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroPriceImprintOnProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCANDY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCandyV10412']"/>
													</Value>
												</Attribute>
												<Attribute name="COCOAPRODUCTDUTCHPROCESSED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroCocoaProductDutchProcessed']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFCOATINGFILLING_MVL</xsl:attribute>
													<ValueList>														
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfCoatingFillingV10973']/value|
														$vendorProprietary/attrMany[@name='kroTypeOfCoatingFillingV11137']/value |	$vendorProprietary/attrMany[@name='kroTypeOfCoatingFillingV11155']/value|								$vendorProprietary/attrMany[@name='kroTypeOfCoatingFillingV11437']/value|
														$vendorProprietary/attrMany[@name='kroTypeOfCoatingFillingV11429']/value
														">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">TYPECREAMORCREAMSUBSTITUTE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCreamOrCreamSubstituteV10978']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PRODUCTCONTAINSPULP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProductContainsPulp']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CONTAINSASELFRISINGAGENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroContainsASelfRisingAgent']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFSEASONALPACKAGING_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfSeasonalPackagingV10994']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">THEMEORCHARACTER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroThemeOrCharacter']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCHOCOLATECOCOAMALT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfChocolateCocoaMaltV10992']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">WITHADDEDMILK</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWithAddedMilk']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PCTOFCACAOINPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPercentOfCacaoInProduct']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFTEA</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfTeaV11001']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">VARIETYOFTEA</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroVarietyOfTeaV11002']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">ORIGINOFTEA_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroOriginOfTeaV11004']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">TYPEEDIBLEVEGETABLEPLANTFAT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfEdibleVegetablePlantFatV11005']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">VARIETYFRUITHERBALINFUSION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroVarietyOfFruitHerbalInfusionV11006']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PREPARATIONFORMAT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPreparationFormatV11007']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFADDEDPROTEIN_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfAddedProteinV11009']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">GRADEOFOLIVEOIL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroGradeOfOliveOilV11011']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFOLIVE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfOlive']"/>
													</Value>
												</Attribute>
												<Attribute name="BEVERAGEINTENDEDBESERVEDHOT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroBeverageIntendedToBeServedHot']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">BOTANICALVARIETY_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroBotanicalVarietyV11015']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">DECAFFEINATED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDecaffeinated']"/>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">ORIGINOFCOFFEE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroOriginOfCoffeeV11016']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute name="DOMESTICATEDANIMAL">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroDomesticatedAnimal']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="REQDEQUIVALENTUOMOVERRIDE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroRequiredEquivalentUOMOverride']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="EATINGUTENSILPROVIDEBYSTORE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroEatingUtensilsProvidedByTheStore']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEBABYINFANTSPECIALFD_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfBabyInfantSpecialisedFoodV10972']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<Attribute>
													<xsl:attribute name="name">VARIETYOFREADYTODRINKTEA</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroVarietyOfReadyToDrinkTeaV11017']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSPORTSDRINK</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSportsDrinkV11020']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CARBONATEDBEVERAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCarbonatedBeverage']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFICECREAMORICENOVELTY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfIceCreamOrIceNoveltyV10425']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPECAKEDECORACCESNONEDIBLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCakeDecorationAccessoryNonEdibleV10985']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSTIMULANTSENERGYDRINK</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfStimulantsEnergyDrinkV10989']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFHAIRCOLOUR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHairColourV11026']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">LEVELOFPERMANENCECLAIM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLevelOfPermanenceClaimV11027']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEHAIRCONDITIONERTREATMNT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHairConditionerTreatmentV11028']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFHAIRSTYLINGNONPOWERED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHairStylingNonPoweredV11029']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFHAIRPERMING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHairPermingV11030']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TARGETHAIRTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetHairTypeV11031']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFHAIRSHAMPOO</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHairShampooV11032']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ANTIDANDRUFFCLAIM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAntiDandruffClaim']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ADDINGREDIENTFORCONSBENEFIT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAdditionalIngredientForConsumerBenefit']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SHADEFAMILYANDCLASSIFICATN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroShadeFamilyAndClassification']"/>
													</Value>
												</Attribute>
												<Attribute name="STEMHASBEENREMOVED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroStemHasBeenRemoved']"/>
														</xsl:call-template>
													</Value>
												</Attribute>			
												<Attribute name="PDTINTENDASICECREAMTOPPING">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIntendedToBeUsedAsAnIceCreamTopping']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFCHEWINGGUM_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfChewingGumV10974']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFCONE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfConeV10984']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">PRODUCTFREEFROM_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroProductFreeFromV11038']/value |
														$vendorProprietary/attrMany[@name='kroProductFreeFromV11193']/value | $vendorProprietary/attrMany[@name='kroProductFreeFromV11186']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												<MultiValueAttribute>
													<xsl:attribute name="name">TOOLSINCLUDED_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroToolsIncludedV11039']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<Attribute>
													<xsl:attribute name="name">ASSORTEDPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAssortedProductV10976']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PACKAGINGSIZE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroPackagingSizeV10995'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroPackagingSizeV10995']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroPackagingSizeV11272'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroPackagingSizeV11272']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>
												<Attribute name="NOVELTYITEM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroNoveltyItem']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute name="ANTIBIOTICFREE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroAntibioticFree']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">INDUSTRYCERTIFICATIONS_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroIndustryCertifications']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<Attribute>
													<xsl:attribute name="name">SHARPNESSOFCHEESE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSharpnessOfCheeseV11013']"/>
													</Value>
												</Attribute>

												<Attribute name="PDTTOBESOLDINDELISPECCHSSHP">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsIntendedToBeSoldInTheDeliSpecialtyCheeseShoppe']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFWATER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfWaterV11035']"/>
													</Value>
												</Attribute>

												<Attribute name="PRODUCTBOTTLEDATTHESOURCE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductBottledAtTheSource']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">OTHERCHEESEPRODUCTTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherCheeseProductType']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFEXTRACT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfExtractV10571']"/>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEARTIFICIALCOLORING_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfArtificialColoringV10572']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<Attribute>
													<xsl:attribute name="name">STGOFBABYINFANTFOODDRINK</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroStageOfBabyInfantFoodDrinkV10990']"/>
													</Value>
												</Attribute>

												<Attribute name="GRAINSPROUTED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroGrainSprouted']"/>
														</xsl:call-template>
													</Value>
												</Attribute>



												<Attribute name="MULTIPLEPANELS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroMultiplePanels']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">SPECIALITEMCODE</xsl:attribute>
													<Value>
														<xsl:value-of select="specialItemCode"/>
													</Value>
												</Attribute>




												<Attribute>
													<xsl:attribute name="name">ALCOHOLPROOF</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAlcoholProof']"/>
													</Value>
												</Attribute>


												<Attribute name="ITEMSUBMISSIONDATE">
													<Value>
														<xsl:call-template name="getDateTime1">
															<xsl:with-param name="dateTime" select="flex/attr[@name='itemSubmissionDate']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="CONTAINSPOTASSIUMCHLORIDE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsPotassiumChloride']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFALCOHOLICBEVCONTENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfAlcoholicBeverageContentV10999']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPENONALCOHOLICBEVCONTENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfNonAlcoholicBeverageContentV11000']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">CIGARSTYLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCigarStyleV11042']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFSMOKINGACCESSORY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSmokingAccessoryV11043']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFTOBACCO</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfTobaccoV11044']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEELECTRONICCIGACCSSRY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfElectronicCigaretteOrAccessoryV11045']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">FORMATOFCIGAR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFormatOfCigarV11050']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">DIAMETEROFCIGARETTE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDiameterOfCigaretteV11051']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">HERBALPRODUCT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroHerbalProduct']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">LENGTHOFCIGARETTE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLengthOfCigaretteV11053']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">ORIGINOFCIGAR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOriginOfCigarV11055']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFFILTER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFilterV11056']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">FLVRHERBALCIGNONTOBACCO</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFlavourOfHerbalCigaretteNonTobaccoV11057']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">LEVELOFCARBONATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLevelOfCarbonationV11071']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">METHODOFCARBONATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMethodOfCarbonationV11072']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFNURSINGHYGIENE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfNursingHygieneV11122']"/>
													</Value>
												</Attribute>

												<Attribute name="PRODUCTEASTAGGED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductEASTagged']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">COLOROFTOBACCO</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroColorOfTobaccoV11126']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">STRENGTHOFTOBACCO</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroStrengthOfTobaccoV11127']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">METHODOFROASTING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMethodOfRoastingV11128']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">METHODOFSALTING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMethodOfSaltingV11129']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">HULLEDORINSHELL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroHulledOrInShellV11131']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFPEANUTORCULTIVAR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPeanutOrCultivarV11132']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">SIZEOFNUT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSizeOfNutV11135']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PDTVACUUMHERMETICALLYSEALED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProductVacuumOrHermeticallySealedV11136']"/>
													</Value>
												</Attribute>



												<Attribute>
													<xsl:attribute name="name">TARGETCUISINE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetCuisineV10446']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">ACTIVITYREQTOPREPPDTFORSALE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroActivityRequiredToPrepareProductForSale']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFCOOKINGSAUCE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCookingSauceV11047']"/>
													</Value>
												</Attribute>

												<Attribute name="ANMLRSDWITHOUTGRWTHHORMONES">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroAnimalRaisedWithoutGrowthHormones']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PARTOFHERBSPICE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPartOfHerbSpiceV11074']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">HERBSPICE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroHerbSpiceV11076']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFDRIEDPEPPER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDriedPepperV11077']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEKITCHENSTORAGEACCESSORY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfKitchenStorageAccessoryV11102']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFBOTTLESTOPPERPOURER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBottleStopperPourerV11103']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFICEWINEBUCKET</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfIceWineBucketV11104']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFSALTPEPPERSPICEMILL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSaltPepperSpiceMillV11105']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEGRNDRJUCRICECRUSHNONPWR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfGrinderJuicerIceCrusherNonPoweredV11106']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEFOODPREPARATIONEQUIPMNT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFoodPreparationEquipmentV11107']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEFOODMEASURINGEQUIPMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFoodMeasuringEquipmentV11109']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEBEVDCRATNACCSSRYNONEDBL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBeverageDecorAccessoryNonEdibleV11110']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">RIGHTHANDEDLEFTHANDED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroRightHandedLeftHandedV11112']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PRODUCTHASSERRATEDBLADES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProductHasSerratedBlades']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TURKEYCUT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTurkeyCutV11138']"/>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">LEVELOFNONGMOCLAIM_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroLevelOfNonGMOClaimV11147']/value |
														$vendorProprietary/attrMany[@name='KroLevelOfNonGMOClaimV11147']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<Attribute name="ITEMISALIVELIVING">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroItemIsAliveLiving']"/>
														</xsl:call-template>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">LEVELOFDIOPTER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLevelOfDiopterV11125']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">STYLEOFFRAMES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroStyleOfFrames']"/>
													</Value>
												</Attribute>

												<Attribute name="PDTLABELDWITHFDAAPPROVEDNDC">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsLabeledWithAnFDAApprovedNationalDrugCodeNDC']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">NATIONALDRUGCODENDC</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNationalDrugCodeNDC']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">QUS_RGD_PDT_CNC_PHN_NO</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroQuestionsRegardingThisProductContactPhoneNumber']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">QUS_RGD_PDT_EML_SOC_MIA_INF</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroQuestionsRegardingThisProductContactEmailOrSocialMediaInformation']"/>
													</Value>
												</Attribute>


												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFJUICE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfJuiceV10422']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">METHODOFSWEETENING_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroMethodOfSweeteningV10471']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>


												<Attribute name="SUBSTITUTABLE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroSubstitutable']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="SCANACTIVATED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroScanActivated']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="PROMOTIONALITEM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroPromotionalItem']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="BOXEDSET">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroBoxedSet']"/>
														</xsl:call-template>
													</Value>
												</Attribute>


												<Attribute name="ONTHESTALK">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroOnTheStalk']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="ITEMHASPMAPLU">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroItemHasPMAPLU']"/>
														</xsl:call-template>
													</Value>
												</Attribute>


												<MultiValueAttribute>
													<xsl:attribute name="name">GROWINGMETHOD_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroGrowingMethodV11148']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>



												<MultiValueAttribute>
													<xsl:attribute name="name">VARIETYOFPRODUCE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroVarietyOfProduceV11150']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">HARVESTSTATE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroHarvestStateV11156']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">HARVESTCITY_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroHarvestCity']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFONION_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfOnionV11165']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFMELON_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfMelonV11167']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">PMAPLUNUMBER_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroPMAPLUNumber']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>


												<Attribute>
													<xsl:attribute name="name">CONTENTSUBJECT</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroContentSubjectV11058'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroContentSubjectV11058']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroContentSubjectV11066'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroContentSubjectV11066']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEGREETINGCARDINVITATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfGreetingCardInvitationV11059']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFGIFTWRAP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfGiftWrapV11060']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFGIFTWRAPACCESSORY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfGiftWrapAccessoryV11061']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEDECORATIVEMAGNETSTICKER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDecorativeMagnetStickerV11062']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFSTATIONERY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfStationeryV11063']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFINVITATIONPADNOTELETS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfInvitationPadNoteletsV11064']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFSTICKYNOTEPAPERCUBE</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfStickyNotePaperCubeV11065'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfStickyNotePaperCubeV11065']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfStickyNotePaperCubeV11380'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfStickyNotePaperCubeV11380']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFPARTYITEM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPartyItemV11067']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFPRINTEDPERIODICAL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPrintedPeriodicalV11068']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">FREQUENCYOFPUBLICATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFrequencyOfPublicationV11070']"/>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPETBLWRSRVEATDRINKEQP_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfTablewareServingEatingDrinkingEquipV11101']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<Attribute>
													<xsl:attribute name="name">TITLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTitle']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TIMEOFHARVEST</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTimeOfHarvestV11149']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFHERBICIDE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHerbicideV11151']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFPESTICIDE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPesticideV11152']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFWASHSOLUTION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfWashSolutionV11153']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">DRYINGOPTIONS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDryingOptionsV11154']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">ITEMISCOATED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroItemIsCoated']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PARTYTRAYFRUITPERCENTAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPartyTrayFruitPercentage']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PARTYTRAYVEGETABLEPERCENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPartyTrayVegetablePercentage']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">COLOROFGRAPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroColorOfGrapeV11166']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">ITEMSEEDLESS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroItemSeedless']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFORANGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfOrangeV11168']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PERCENTAGEPMAPLUSTICKERED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPercentagePMAPLUStickered']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PERCENTAGEPMAPLUSTICKERED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPercentagePMAPLUStickered']"/>
													</Value>
												</Attribute>



												<Attribute>
													<xsl:attribute name="name">TYPEOFPEACH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPeachV11158']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">ITEMISRIPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroItemIsRipe']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">EASYOPEN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroEasyOpen']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">COCONUTINHUSK</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCoconutInHusk']"/>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFGIFTITEM_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfGiftItemV11159']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>


												<Attribute>
													<xsl:attribute name="name">NONFOODITEMPERCENTAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNonFoodItemPercentage']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">FOODITEMPERCENTAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFoodItemPercentage']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFGIFTBASKET</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfGiftBasketV11160']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">SPECIALOCCASIONCLAIM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSpecialOccasionClaimV11161']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFWINE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfWineV11162']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFBEER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBeerV11163']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFSPIRIT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSpiritV11164']"/>
													</Value>
												</Attribute>

												<Attribute name="CONTAINSFUZZ">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsFuzz']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PLANTLIFESPAN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPlantLifespanV11169']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">CROSSPOLLINATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCrossPollination']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PESTRESISTANT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPestResistant']"/>
													</Value>
												</Attribute>



												<Attribute>
													<xsl:attribute name="name">TYPEOFPESTRESISTANCE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeofPestResistance']"/>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFFERTILIZER_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfFertilizerV11170']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFPESTCONTROLMETHOD_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfPestControlMethodV11171']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<Attribute>
													<xsl:attribute name="name">PLANTEDIBLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPlantEdible']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">PLANTFRAGRANT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPlantFragrant']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">NONTOXIC</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNonToxic']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">PLANTVARIEGATED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPlantVariegated']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PLANTFLOWERING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPlantFlowering']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PLANTGROWNUPSIDEDOWN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPlantGrownUpsideDown']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PLANTSTAKED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPlantStaked']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">PLANTCAGED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPlantCaged']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">PLANTRESIDUE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPlantResidue']"/>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">MONTHSOFMATURITY_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroMonthsOfMaturityV11172']/value">		
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>


												<Attribute>
													<xsl:attribute name="name">TYPEFURNITURECVRCLOTHDETACH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFurnitureCoverOrClothDetachableV11079']"/>
													</Value>
												</Attribute>



												<Attribute>
													<xsl:attribute name="name">TYPEOFTOWEL</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfTowelV11080'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfTowelV11080']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfTowelV11401'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfTowelV11401']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPENONDISPOSABLETABLEWARE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfNonDisposableTablewareV11082']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFKITCHENTEXTILE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfKitchenTextileV11083']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFELECTRICALCLOTHESIRON</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfElectricalClothesIronV11084']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">INSTALLATIONTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroInstallationTypeV11085']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">FRIDGEFREEZERCONFIGURATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFridgeFreezerConfigurationV11086']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFHOTBEVERAGEMAKER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHotBeverageMakerV11087']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">FOODBEVSTORAGECONTAINERS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFoodBeverageStorageContainersV11088']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">OVENTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOvenTypeV11089']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFMICROWAVECOOKWARE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfMicrowaveCookwareV11090']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PRODUCTATTACHMENTS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProductAttachmentsV11091']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">HANDHELDSTANDALONE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroHandheldStandAloneV11092']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFFROZENDRINKSMAKERICE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFrozenDrinksMakerIceV11093']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">SNOWCONEACCESSORIES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSnowConeAccessoriesV11094']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">GRILLELECTRICTYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroGrillElectricTypeV11095']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFPANCAKEDOUGHNUTMAKER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPancakeDoughnutMakerV11096']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TURNOVERPOPUP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTurnoverPopUpV11097']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">NUMBEROFSLOTS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfSlotsV11098']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFSANDWICHWAFFLEMAKER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSandwichWaffleMakerV11099']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFAPPLIANCE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfApplianceV11100']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFBEVERAGESERVED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBeverageServedV11115']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFSTEAMCLEANERS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSteamCleanersV11116']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFVACUUMCLEANER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfVacuumCleanerV11117']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPECOOKBAKEOVENGRILLWARE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCookwareBakewareOvenwareGrillwareV11118']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">PRODUCTHASNONSTICKCOATING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProductHasNonStickCoating']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PRODUCTISSUITABLE4MICROWAVE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProductIsSuitableForTheMicrowave']"/>
													</Value>
												</Attribute>




												<Attribute name="ACCESSORIESINCLUDED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroAccessoriesIncluded']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="CONTAINSWHOLEGRAINS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsWholeGrains']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">CORDLENGTH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCordLength']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">IFFOLDABLECOLLAPSIBLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroIfFoldableCollapsible']"/>
													</Value>
												</Attribute>


												<Attribute name="ITEMISGLAZED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroItemIsGlazed']"/>
														</xsl:call-template>
													</Value>
												</Attribute>



												<MultiValueAttribute>
													<xsl:attribute name="name">ITEMSAFEFOR_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroItemSafeForV11194']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>



												<Attribute>
													<xsl:attribute name="name">NOOFSERVINGSPERPACKAGEDECML</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfServingsPerPackageDecimal']"/>
													</Value>
												</Attribute>


												<Attribute name="REMOVABLEWATERTANK">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroRemovableWaterTank']"/>
														</xsl:call-template>
													</Value>
												</Attribute>


												<!-- Start 5.1 attributes-->

												<Attribute>
													<xsl:attribute name="name">GLUTENPARTSPERMILLION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroGlutenPartsPerMillion']"/>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">GLUTENFREEBASIS_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroGlutenFreeBasisV11409']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<Attribute>
													<xsl:attribute name="name">OTHERORGANICCLAIMAGENCY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherOrganicClaimAgency']"/>
													</Value>
												</Attribute>


												<Attribute name="FROZENCLAIM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroFrozenClaim']"/>
														</xsl:call-template>
													</Value>
												</Attribute>



												<Attribute>
													<xsl:attribute name="name">MAXTIMEWITHOUTREFRIGERATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMaximumTimeWithoutRefrigeration']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">OILPERCENTAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOilPercentage']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">BUTTERFATPERCENTAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroButterfatPercentage']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFCURD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCurdV11187']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">MILKFATPERCENTAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMilkfatPercentage']"/>
													</Value>
												</Attribute>


												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEMILKMILKSUBSTITUTE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfMilkOrMilkSubstituteV11184']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>


												<Attribute>
													<xsl:attribute name="name">SHELLEGGSIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroShellEggSizeV11182']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">EGGQUALITYSTANDARD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroEggQualityStandardV11180']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">EGGPROCESSORTREATMNTPROCESS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroEggProcessorTreatmentProcessV11191']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PARTOFEGG</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPartOfEggV11177']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">INSHELLPASTEURIZATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroInShellPasteurizationV11176']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">PRODUCTIONMETHOD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProductionMethodV11175']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">SHELLCOLOR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroShellColorV11174']"/>
													</Value>
												</Attribute>
												<!--End 5.1 attributes-->
												<!--Start 5.2 attributes-->


												<Attribute>
													<xsl:attribute name="name">TYPEOFMUGCUP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfMugCupV11213']"/>
													</Value>
												</Attribute>


												<MultiValueAttribute>
													<xsl:attribute name="name">FOLDCOLLAPSEDETCHRETRCT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroFoldableCollapsibleDetachableRetractableV11214']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>


												<MultiValueAttribute>
													<xsl:attribute name="name">COLOROFLID_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroColorOfLidV11215']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>


												<Attribute>
													<xsl:attribute name="name">TARGETAREAFORCOSMETIC</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetAreaForCosmeticV11220']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPECOSMETICAIDSACCESSORIES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCosmeticAidsAccessoriesV11229']"/>
													</Value>
												</Attribute>



												<Attribute>
													<xsl:attribute name="name">TYPEOFCOSMETICSEYES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCosmeticsEyesV11219']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFCOSMETICSLIPS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCosmeticsLipsV11221']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFCOSMETICSNAILS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCosmeticsNailsV11222']"/>
													</Value>
												</Attribute>



												<Attribute>
													<xsl:attribute name="name">WATERPROOF</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWaterproof']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFCOSMETICSCOMPLEXION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCosmeticsComplexionV11223']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">LONGLASTINGCLAIM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLongLastingClaim']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">ACETONEFREE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAcetoneFree']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPENAILCLNSRCOSMETICREMOVR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfNailCleanserCosmeticRemoverV11224']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFNAILAIDNONPOWERED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfNailAidNonPoweredV11225']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPENAILACCESSORYNONPOWERED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfNailsAccessoriesNonPoweredV11226']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFNAILTREATMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfNailTreatmentV11227']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFFALSENAILS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFalseNailsV11228']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFMATERIAL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfMaterialV11230']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">MANICUREPEDICURE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroManicurePedicureV11231']"/>
													</Value>
												</Attribute>

												<Attribute name="MULTIPLESHADES">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroMultipleShades']"/>
														</xsl:call-template>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFCANDLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCandleV11210']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFCANDLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfCandle']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFCANDLEHOLDERACCESSORY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCandleHolderAccessoryV11211']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">TYPEOFESSENTIALOIL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfEssentialOilV11212']"/>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">DROPSPERUNIT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDropsPerUnit']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">AMMONIAFREE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAmmoniaFreeV11197']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TARGETEDHAIRCOLOR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTargetedHairColorV11198']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFPASTAORNOODLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfPastaOrNoodle']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEBUTTERBUTTERSUBSTITUTE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfButterOrButterSubstituteV11232']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">SLICED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSlicedV11195']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFMEAT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfMeat']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFVEGETABLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfVegetable']"/>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFPIZZACRUST_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfPizzaCrustV11410']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>


												<Attribute name="MICROWAVEABLE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroMicrowaveable']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<!--End 5.2 attributes-->

												<!-- Start 5.3 attributes-->


												<Attribute>
													<xsl:attribute name="name">TYPEOFHOMEDECOR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHomeDecor']"/>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFDOMESTICGOOD</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfDomesticGoodV11325'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfDomesticGoodV11325']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfDomesticGoodV11391'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name ='kroTypeOfDomesticGoodV11391']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>

												<Attribute name="REALDAIRYSEAL">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroRealDairySeal']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">SOLDHOTORCOLD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSoldHotOrColdV10285']"/>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TOFUTEXTURE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTofuTextureV11247']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEYOGURTYOGURTSUB_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfYogurtYogurtSubstituteV11253']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<Attribute>
													<xsl:attribute name="name">TYPEOFFILLING</xsl:attribute>
													<Value>
														<xsl:choose>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfFillingV11311'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfFillingV11311']"/>
															</xsl:when>
															<xsl:when test="not(string-length($vendorProprietary/attr[@name = 'kroTypeOfFillingV11324'] )) = 0">
																<xsl:value-of select="$vendorProprietary/attr[@name = 'kroTypeOfFillingV11324']"/>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</Value>
												</Attribute>

												<Attribute>
													<xsl:attribute name="name">WASHABLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWashable']"/>
													</Value>
												</Attribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFCLEANINGSOLUTION_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfCleaningSolutionV11387']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<Attribute name="PRODUCTARENTAL">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductARental']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="ISITMINTENDEDTOBECOOKDINSTR">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsItemIntendedToBeCookedInStore']"/>
														</xsl:call-template>
													</Value>
												</Attribute>



												<!-- End 5.3 attributes-->

												<!-- Start 5.4 attributes-->
												<Attribute name="ADDITIONALLABELING">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroAdditionalLabeling']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="SOAKERPADUSED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroSoakerPadUsed']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="TAREUSED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroTareUsed']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="USDAINSPECTEDPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroUSDAInspectedProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="POTTEDPLANT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroPottedPlant']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="VASEINCLUDED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroVaseIncluded']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="SCOTCHGUARDED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroScotchguarded']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="SOLDASPARTOFASET">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroSoldAsPartOfASet']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="CONTAINER">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainer']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="PRODUCTISLED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductIsLed']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="WRINKLEFREE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroWrinkleFree']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="GUSSETED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroGusseted']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="ZIPPERONPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroZipperOnProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="ANTIMICROBIAL">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroAntimicrobial']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="CONTAINSPRONGS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroContainsProngs']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="DUALENDED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroDualEnded']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="EVELOPEINCLUDED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroEvelopeIncluded']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="HOLEPUNCHED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroHolepunched']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="PAINTBRUSHINCLUDED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroPaintBrushIncluded']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="PROTRACTORWITHARM">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProtractorWithArm']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="REFILLABLE">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroRefillable']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="SCENTED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroScented']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="SCRAPCATCHER">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroScrapCatcher']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="SUCTIONCUPSINCLUDED">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroSuctionCupsIncluded']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="PRODUCTCONTAINSPORK">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroProductContainsPork']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="ALCOHOLPRESENTINPRODUCT">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroAlcoholPresentInProduct']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="ALCOHOLUSEDINPROCESSING">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroAlcoholUsedInProcessing']"/>
														</xsl:call-template>
													</Value>
												</Attribute>

												<Attribute name="ISITEMREGISTEREDWITHWERCS">
													<Value>
														<xsl:call-template name="Booleanize">
															<xsl:with-param name="value" select="$vendorProprietary/attr[@name='kroIsItemRegisteredWithWERCS']"/>
														</xsl:call-template>
													</Value>
												</Attribute>


												<Attribute>
													<xsl:attribute name="name">MAXDAYSOFSHELFLIFEATWHSDC</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMaximumDaysOfShelfLifeAtWareHouseDistributionCenter']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">DAIRYGRADE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroDairyGradeV11251']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERBASEINGREDIENTS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherBaseIngredients']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFTEAPOTCAFETIERE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfTeapotCafetiereV11257']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEHSHLDH2OFLTRORCARTRIDGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHouseholdWaterFilterWaterFilterCartridgeV11258']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFTHERMALCONTAINER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfThermalContainerV11259']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PORTABLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPortable']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFLAMP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfLampV11262']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFLAMP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfLamp']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERTYPEOFLAMPSHADE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTypeOfLampshade']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NUMBEROFSOAKERPADS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfSoakerPads']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">OTHERTRIMSTANDARD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherTrimStandard']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TAREAMOUNT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTareAmount']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TRIMSTANDARD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTrimStandardV11269']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYEOFTARE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTyeOfTareV11270']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NUMBEROFSTROKES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfStrokesV11274']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PHOTOGRAPHALBUMFORMAT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPhotographAlbumFormatV11280']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">WITHMATBORDER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWithMatBorder']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FRAMESIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFrameSizeV11282']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NUMBEROFSHEETS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfSheets']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NUMBEROFPHOTOS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfPhotos']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFIMAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfImageV11283']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEARTIFICLFLOWERPLANTTREE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfArtificialFlowerPlantTreeV11285']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PREASSEMBLEDREQUIREASSEMBLY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPreassembledRequiresAssemblyV11291']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFFURNITURE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFurnitureV11292']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEHOUSEHOLDOFFCCHAIRSTOOL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfHouseholdOfficeChairStoolV11293']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FABRICPATTERN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFabricPatternV11294']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFFINISH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFinishV11295']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFFABRIC</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfFabricV11296']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NUMBEROFPIECESINSET</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfPiecesInSet']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFTABLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfTableV11297']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CANDLECONSTITUENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCandleConstituentV11300']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">AROMADELIVERY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAromaDeliveryV11301']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CANDLESIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCandleSizeV11302']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFWAX</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfWaxV11303']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">WITHLID</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWithLid']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFWALLDECOR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfWallDecorV11309']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCLOCK</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfClockV11306']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ANALOGDIGITAL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAnalogDigitalV11307']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">CLOCKNUMBERS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroClockNumbersV11308']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">WALLMOUNTED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWallMounted']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SELFADHESIVE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSelfAdhesive']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">THREADCOUNT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroThreadCountV11312']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBEDDING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBeddingV11313']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">BEDDINGSIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroBeddingSizeV11314']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">REVERSIBLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroReversible']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PILLOWSIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroPillowSizeV11316']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPMTTRSSPLLWDUVETPROTECTOR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfMattressPillowDuvetProtectorV11317']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">HEATEDNOTHEATED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroHeatedNotHeatedV11319']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">PRODUCTTEXTURE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProductTextureV11320']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPILLOW</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPillowV11322']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ANTIMITETREATED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAntiMiteTreated']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">BINDERWIDTH</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroBinderWidth']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">BOUNDUNBOUND</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroBoundUnboundV11326']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">BOXCAPACITY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroBoxCapacity']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FILESIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFileSizeV11329']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">FILINGITEMDURABILITY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFilingItemDurabilityV11330']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">MECHANICALPENCILLEADSIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroMechanicalPencilLeadSizeV11331']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NOTEBOOKPAPERSIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNotebookPaperSizeV11332']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NUMBEROFFONTSIZES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfFontSizes']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NUMBEROFHEATSETTINGS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfHeatSettings']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NUMBEROFHOLES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfHoles']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NUMBEROFPOCKETS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfPockets']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NUMBEROFTABS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfTabs']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">RECYCLEDPAPER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroRecycledPaper']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">RULINGONPAPER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroRulingOnPaperV11333']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SHREDSIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroShredSize']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SHREDDERBASKETVOLUME</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroShredderBasketVolume']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">STAPLESIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroStapleSize']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">STICKERCOUNT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroStickerCount']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TAPEDURABILITY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTapeDurabilityV11334']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">THICKNESSOFPOINT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroThicknessOfPoint']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFACTIVITYPAINT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfActivityPaintV11336']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFARTCRAFTITEM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfArtCraftItemV11337']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEARTISTSBRUSHAPPLICATOR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfArtistsBrushApplicatorV11338']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFARTISTSPAINTDYE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfArtistsPaintDyeV11339']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBINDER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBinderV11340']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBINDING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBindingV11341']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCHILDRENSACTIVITYITEM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfChildrensActivityItemV11342']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCLOSURE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfClosureV11343']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFLOCK</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfLockV11356']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFNEEDLEWORKFASTENER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfNeedleworkFastenerV11358']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFNEEDLEWORKTHREAD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfNeedleworkThreadV11359']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFNEEDLEWORKTOOL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfNeedleworkToolV11360']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFNOTION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfNotionV11362']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPADDING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPaddingV11363']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPAINTBRUSHTIP</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPaintBrushTipV11364']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEPAPERCRAFTTOOLNONPOWERD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPaperCraftToolNonPoweredV11365']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPAPERCARDUNPRINTED</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPaperCardUnprintedV11367']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFPEN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfPenV11368']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSCHOOLSUPPLY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSchoolSupplyV11370']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSKETCHPAD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSketchPadV11372']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSPECIALTYMARKER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSpecialtyMarkerV11373']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSTATIONERYFASTENER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfStationeryFastenerV11376']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFSTATIONERYGLUE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfStationeryGlueV11377']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">NUMBEROFPAGES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNumberOfPages']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFWRITINGINSTRUMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfWritingInstrumentV11381']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">WEIGHTOFPAPER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWeightOfPaper']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFTARGETBATTERYUSE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfTargetBatteryUseV11390']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">AUTOMOTIVEBATTERYVOLTAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAutomotiveBatteryVoltage']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">COLDCRANKINGAMPSCCA</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroColdCrankingAmpsCCA']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">WARRANTY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWarranty']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">AUTOMOTIVEBATTERYGROUPSIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAutomotiveBatteryGroupSize']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SICCORSIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSiccorSize']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFCURTAINTRACK</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfCurtainTrackV11393']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">EXTENDABLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroExtendable']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">LENGTHOFDOMESTICGOOD</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroLengthOfDomesticGood']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SLATSIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSlatSize']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBLIND</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBlindV11397']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFTOPTREATMENT</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfTopTreatmentV11398']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">ENDSHAPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroEndShapeV11399']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBATHROOMITEM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBathroomItemV11400']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBATHROOMACCESSORY</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBathroomAccessoryV11402']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBATHROOMFURNITURE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBathroomFurnitureV11403']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBATHROOMHARDWARE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBathroomHardwareV11404']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEBATHROOMUTILITYORGANIZR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBathroomUtilityOrganizerV11405']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">TYPEOFBATHROOMRUG</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBathroomRugV11406']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">SUPPLIERPROVIDEDSHIPPERDSC</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSupplierProvidedShipperDescription']"/>
													</Value>
												</Attribute>
												<Attribute>
													<xsl:attribute name="name">WPSIDNUMBER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWPSIDNumber']"/>
													</Value>
												</Attribute>


												<MultiValueAttribute>
													<xsl:attribute name="name">INKCOLOR_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroInkColorV11233']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">BEEFCUT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroBeefCutV11256']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFLAMPSHADE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfLampshadeV11263']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFHARDWIRELIGHT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfHardwireLightV11264']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">OILTYPE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroOilTypeV11275']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFENGINEOILTARGET_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfEngineOilTargetV11276']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPELUBRICANTAPPLICATN_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfLubricantApplicationV11277']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">VISCOSITYRATNGORRLTDSTD_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroViscosityRatingIndicationOrRelatedStandardV11278']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">MTHDPHOTOGRAPHSTRGDSPLY_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroMethodofPhotographStorageDisplayV11281']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFBOUQUET_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfBouquetV11286']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFFLOWERSTEM_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfFlowerStemV11287']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">PLANTDESIGNHOLDER_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroPlantDesignHolderV11288']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">FLORALPLANTACCENTS_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroFloralPlantAccentsV11289']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFMIRROR_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfMirrorV11305']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">CLIPSIZE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroClipSizeV11327']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">COLOROFLEAD_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroColorOfLeadV11328']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TIPSIZE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTipSizeV11335']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFCORRECTIONITEM_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfCorrectionItemV11344']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFCOVER_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfCoverV11345']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFDIVIDERTAB_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfDividerTabV11346']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFDRYERASEBOARD_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfDryEraseBoardV11347']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">DRYERASEMARKER_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroDryEraseMarkerV11348']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFENVELOPE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfEnvelopeV11349']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFERASER_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfEraserV11350']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEFILESFOLDERWALLET_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfFilesFoldersWalletsV11351']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFKIT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfKitV11352']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFLABELMAKER_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfLabelMakerV11353']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFLABELINDEXCARD_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfLabelIndexCardV11354']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFLAMINATOR_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfLaminatorV11355']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFMAILINGPRODUCT_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfMailingProductV11357']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFNOTEBOOKPORTFOLIO_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfNotebookPortfolioV11361']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFPAPERSHREDDER_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfPaperShredderV11366']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFCLOSURE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfClosureV11369']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFSCISSORS_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfScissorsV11371']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFSTAPLER_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfStaplerV11374']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPESTATIONERYADHSVTAPE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfStationeryAdhesiveTapeV11375']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPSTNRYSTRGDSKACCSSRY_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfStationeryItemStorageDeskAccessoryV11378']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFSTENCIL_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfStencilV11379']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">WRITINGINSTRUMENTSTYLE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroWritingInstrumentStyleV11382']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">FREESTANDMOUNTED_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroFreestandMountedV11407']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<MultiValueAttribute>
													<xsl:attribute name="name">WERCSPDTCLASSIFICATION_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroWERCSProductClassificationV11440']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>

												<!--End 5.4 attributes-->
												
												<!-- Start 6.1 attributes-->
												
												
												<Attribute>
													<xsl:attribute name="name">ALCOHOLMANUFACTUREDFLAG</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAlcoholManufacturedFlagV10293']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">ALCOHOLPRODCTCLASSIFICATION</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroAlcoholProductClassificationV10400']"/>
													</Value>
												</Attribute>
												
												<MultiValueAttribute>
												<xsl:attribute name="name">ADDITIONALPRODUCTS_MVL</xsl:attribute>
													<ValueList>														
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroAdditionalProductsV11411']/value|
														$vendorProprietary/attrMany[@name='kroAdditionalProductsV11414']/value 	
														">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												
												<MultiValueAttribute>
													<xsl:attribute name="name">OTHERADDITIONALPRODUCTS_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroOtherAdditionalProducts']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												
												
												<MultiValueAttribute>
													<xsl:attribute name="name">TYPEOFWING_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroTypeOfWingV11412']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												
													
												<Attribute>
													<xsl:attribute name="name">OTHERFISHSHELLFISHCUTSHAPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherFishShellfishCutShape']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">CALCULATEDWGTWATCHERSPOINTS</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroCalculatedWeightWatchersPoints']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">GRAMSOFFIBER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroGramsOfFiber']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">GRAMSOFNETCARBOHYDRATES</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroGramsOfNetCarbohydrates']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">GRAMSOFPROTEIN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroGramsOfProtein']"/>
													</Value>
												</Attribute>
												
												
												<Attribute>
													<xsl:attribute name="name">GRAMSOFSUGAR</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroGramsOfSugar']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">SAUCEINCLUDEDINPACKAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSauceIncludedInPackage']"/>
													</Value>
												</Attribute>
												
												
												<Attribute>
													<xsl:attribute name="name">TYPEOFENTREE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfEntreeV11413']"/>
													</Value>
												</Attribute>
												
												
												<Attribute>
													<xsl:attribute name="name">WGTWATCHERSPOINTSAVAILABLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroWeightWatchersPointsAvailable']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">TYPEOFBAGEL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBagelV11417']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">OTHERANCIENTGRAIN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOtherAncientGrain']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">TYPEOFSPROUTEDGRAIN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfSproutedGrainV11418']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">SPROUTEDGRAINPERCENTAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroSproutedGrainPercentage']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">TYPEOFBATTER</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBatterV11419']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">PRODUCTSTEAMINGSAFE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProductSteamingSafe']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">GRAMSOFWHOLEGRAIN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroGramsOfWholeGrain']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">STYLEOFCHEESECAKE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroStyleOfCheesecakeV11424']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">FLAVOROFICING</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFlavorOfIcingV11425']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">TYPEOFBREAKFASTITEM</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfBreakfastItemV11426']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">TYPEOFDINNERROLL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroTypeOfDinnerRollV11430']"/>
													</Value>
												</Attribute>
												
												
												<Attribute>
													<xsl:attribute name="name">FROSTINGINCLUDEDINPACKAGE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroFrostingIncludedInPackage']"/>
													</Value>
												</Attribute>
												
												
												<Attribute>
													<xsl:attribute name="name">OLIVESIZE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOliveSizeV11431']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">NATURALORCHEMICALPRESERVATN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNaturalOrChemicalPreservationV11432']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">OLIVETYPE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroOliveTypeV11433']"/>
													</Value>
												</Attribute>
												
												<MultiValueAttribute>
													<xsl:attribute name="name">FLAVOROFCAKE_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroFlavorOfCakeV11438']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												
												
												<Attribute>
													<xsl:attribute name="name">CONSUMERUNITRESEALABLE</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroConsumerUnitResealable']"/>
													</Value>
												</Attribute>
												
												
												<Attribute>
													<xsl:attribute name="name">PRODUCTMADEFROMMYCOPROTEIN</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroProductMadeFromMycoprotein']"/>
													</Value>
												</Attribute>
												
												<Attribute>
													<xsl:attribute name="name">NATIONALYOGURTASSOCIATNSEAL</xsl:attribute>
													<Value>
														<xsl:value-of select="$vendorProprietary/attr[@name='kroNationalYogurtAssociationSeal']"/>
													</Value>
												</Attribute>
												
												<MultiValueAttribute>
													<xsl:attribute name="name">GOODSOURCECONTAINS_MVL</xsl:attribute>
													<ValueList>
														<xsl:for-each select="$vendorProprietary/attrMany[@name='kroGoodSourceContainsV11443']/value">
															<Value>
																<xsl:value-of select="."/>
															</Value>
														</xsl:for-each>
													</ValueList>
												</MultiValueAttribute>
												
												<!-- End 6.1 attributes-->
												
												
												
												
												
											</ItemData>
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

												<!-- RELATIONSHIP: Item_Master_FUNCTIONALNAME_MVL -->

												<Relationship>
													<RelationType>Item_Master_FUNCTIONALNAME_MVL</RelationType>
													<RelatedItems count="{count(functionalName[generate-id() = generate-id(key('functional', concat(generate-id(..), '|', @lang))[1])])}">
														<xsl:apply-templates select="functionalName[generate-id() = generate-id(key('functional', concat(generate-id(..), '|', @lang))[1])]"/> 
													</RelatedItems>
												</Relationship>

												<!-- RELATIONSHIP: Item_Master_GTINNAME_MVL -->

												<Relationship>
													<RelationType>Item_Master_GTINNAME_MVL</RelationType>
													<RelatedItems count="{count(gtinName[generate-id() = generate-id(key('gtinName', concat(generate-id(..), '|', @lang))[1])])}">
														<xsl:apply-templates select="gtinName[generate-id() = generate-id(key('gtinName', concat(generate-id(..), '|', @lang))[1])]"/> 
													</RelatedItems>
												</Relationship>

												<!-- RELATIONSHIP: Item_Master_HANDLINGINSTRUCTIONCODE_MVL -->

												<Relationship>
													<RelationType>Item_Master_HANDLINGINSTRUCTIONCODE_MVL</RelationType>
													<RelatedItems count="{count(handlingInstructionCode[generate-id() = generate-id(key('handlingInstructionCode', concat(generate-id(..), '|', @lang))[1])])}">
														<xsl:apply-templates select="handlingInstructionCode[generate-id() = generate-id(key('handlingInstructionCode', concat(generate-id(..), '|', @lang))[1])]"/> 
													</RelatedItems>
												</Relationship>

												<!-- RELATIONSHIP: Descriptions_for_Item -->

												<Relationship>
													<RelationType>Descriptions_for_Item</RelationType>
													<RelatedItems count="{count(productDescription[generate-id() = generate-id(key('productDescription', concat(generate-id(..), '|', @lang))[1])])}">
														<xsl:apply-templates select="productDescription[generate-id() = generate-id(key('productDescription', concat(generate-id(..), '|', @lang))[1])]"/> 
													</RelatedItems>
												</Relationship>

												<!-- RELATIONSHIP: Item_Master_GPC_BRICK_MVL -->
												<Relationship>
													<RelationType>Item_Master_GPC_BRICK_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(flex/attrGroup[@name='gpcBrickAttributes']/attrGroupMany[@name='gpcBrickAttributeValues']/row)"/>
														</xsl:attribute>
														<xsl:for-each select="flex/attrGroup[@name='gpcBrickAttributes']/attrGroupMany[@name='gpcBrickAttributeValues']/row">
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="concat('GPC_Brick_MVL',ancestor::item/gtin,attr[@name='gpcBrickAttribute'])"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>

												<!-- RELATIONSHIP: Measures_MVL -->
												<Relationship>
													<RelationType>ITEM_MASTER_Measures_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(height|width|depth)"/>
														</xsl:attribute>
														<xsl:for-each select="height|width|depth">
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="concat('Measures_MVL',ancestor::item/gtin,local-name(),@uom)"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>
												<!-- RELATIONSHIP: Weight_MVL -->
												<Relationship>
													<RelationType>Item_Master_Weight_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(netContent|grossWeight|netWeight|drainedWeight)"/>
														</xsl:attribute>
														<xsl:for-each select="netContent|grossWeight|netWeight|drainedWeight">
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="concat('Weight_MVL',ancestor::item/gtin,local-name(),@uom)"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>
												<!-- RELATIONSHIP: Temperature_MVL -->
												<Relationship>
													<RelationType>Item_Master_Temperature_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(deliveryToDCMinimum|deliveryToDCMaximum|deliveryToDCTemperatureMaximum|deliveryToDCTemperatureMinimum|storageHandlingTempMax|storageHandlingTempMin)"/>
														</xsl:attribute>
														<xsl:for-each select="deliveryToDCMinimum|deliveryToDCMaximum|deliveryToDCTemperatureMaximum|deliveryToDCTemperatureMinimum|storageHandlingTempMax|storageHandlingTempMin">
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="concat('Temperature_MVL',ancestor::item/gtin,local-name(),@uom)"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>

												<!-- RELATIONSHIP: Food_And_Bev_Allergen_MVL -->
												<Relationship>
													<RelationType>Item_Master_Food_And_Bev_Allergen_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(flex//attrGroupMany[@name = 'foodAndBevAllergen']/row)"/>
														</xsl:attribute>
														<xsl:for-each select="flex//attrGroupMany[@name = 'foodAndBevAllergen']/row">
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="concat('Food_And_Bev_Allergen_MVL','-',ancestor::item/gtin,'-',position())"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>
												<!-- RELATIONSHIP: Food_And_Bev_Diet_MVL -->
												<Relationship>
													<RelationType>Item_Master_Food_And_Bev_Diet_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(flex//attrGroupMany[@name ='foodAndBevDietTypeInfo']/row)"/>
														</xsl:attribute>
														<xsl:for-each select="flex//attrGroupMany[@name ='foodAndBevDietTypeInfo']/row">
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="concat('Food_And_Bev_Diet_MVL',ancestor::item/gtin,attr[@name='dietTypeCode'])"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>
												<!-- RELATIONSHIP: Food_And_Bev_Ingredient_MVL -->
												<Relationship>
													<RelationType>Item_Master_Food_And_Bev_Ingredient_MVL</RelationType>
													<RelatedItems 
													count="{count(flex/attrQualMany[@name='ingredientsList']/value[generate-id() = generate-id(key('ingredientmvl', concat(generate-id(..), '|', @qual))[1])])}">

														<xsl:for-each select="flex/attrQualMany[@name='ingredientsList']/value[generate-id() = generate-id(key('ingredientmvl', concat(generate-id(..), '|', @qual))[1])]">

															<RelatedItem referenceKey="{concat('Food_And_Bev_Ingredient_MVL','-',ancestor::item/gtin,'-',@qual)}"/>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>
												<!-- RELATIONSHIP: Food_And_Bev_Nutrifacts_MVL -->

												<Relationship>
													<RelationType>Item_Master_Food_And_Bev_Nutrifacts_MVL</RelationType>
													<RelatedItems>
														<xsl:for-each select="flex/attrGroupMany[@name='foodAndBevNutrientInfo']/row">                                
															<xsl:variable name="foodAndBevNutrientInfo" select="." />
															<xsl:variable name="foodAndBevNutrient" select="attrGroupMany[@name = 'foodAndBevNutrient']/row" />
															<xsl:variable name="nutrientQuantityContained" select="attrGroupMany[@name = 'foodAndBevNutrient']/row/attrQualMany[@name = 'nutrientQuantityContained']/value" /> 
															<xsl:variable name="servingSize" select="attrQualMany[@name = 'servingSize']/value" />         
															<xsl:attribute name="count">
																<xsl:value-of select="count($foodAndBevNutrient) * count($servingSize) "/>
															</xsl:attribute>                                                                                  
															<xsl:for-each select="$foodAndBevNutrient">
																<xsl:variable name="FABN" select="attr[@name='nutrientTypeCode']"/>
																<xsl:choose>
																	<xsl:when test="$nutrientQuantityContained">
																		<xsl:for-each select="attrQualMany[@name='nutrientQuantityContained']/value">
																			<xsl:variable name="NQC" select="." />
																			<xsl:for-each select="$servingSize">
																				<xsl:variable name="SS" select="." />
																				<RelatedItem referenceKey="Food_And_Bev_Nutrifacts_MVL-{ancestor::item/gtin}-{$foodAndBevNutrientInfo/attr[@name='preparationState']}-{$SS}-{$SS/@qual}-{$FABN}-{$NQC}-{$NQC/@qual}" />                                                                     
																			</xsl:for-each>
																		</xsl:for-each>
																	</xsl:when>
																	<xsl:otherwise/>
																</xsl:choose>
															</xsl:for-each>
															<xsl:for-each select="$foodAndBevNutrient">
																<xsl:variable name="FABN" select="attr[@name='nutrientTypeCode']"/>
																<xsl:if test="not(attrQualMany[@name='nutrientQuantityContained'])">
																	<xsl:for-each select="$servingSize">
																		<xsl:variable name="SS" select="." />
																		<RelatedItem referenceKey="Food_And_Bev_Nutrifacts_MVL-{ancestor::item/gtin}-{$foodAndBevNutrientInfo/attr[@name='preparationState']}-{$SS}-{$SS/@qual}-{$FABN}--" />                          
																	</xsl:for-each>
																</xsl:if>
															</xsl:for-each>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>

												<!-- RELATIONSHIP: Food_And_Bev_Prep_MVL -->

												<Relationship>
													<RelationType>Item_Master_Food_And_Bev_Prep_MVL</RelationType>
													<RelatedItems 
													count="{count(flex/attrGroupMany[@name ='foodAndBevPreparationInfo']/row/attrQualMany[@name='preparationInstructions']/value[generate-id() = generate-id(key('prepmvl', concat(generate-id(..), '|', @qual))[1])])}">
														<xsl:for-each select="flex/attrGroupMany[@name ='foodAndBevPreparationInfo']/row/attrQualMany[@name='preparationInstructions']/value[generate-id() = generate-id(key('prepmvl', concat(generate-id(..), '|', @qual))[1])]">
															<RelatedItem referenceKey="{concat('Food_And_Bev_Prep_MVL','-',ancestor::item/gtin,'-',../../attr[@name='preparationType'],'-',@qual)}"/>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>

												<!-- RELATIONSHIP: Authorized_Region_MVL -->
												<Relationship>
													<RelationType>Item_Master_Authorized_Region_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(flex//attrGroupMany[@name='kroRegions']/row)"/>
														</xsl:attribute>
														<xsl:for-each select="flex//attrGroupMany[@name='kroRegions']/row">
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="concat('Authorized_Region_MVL',$keyid,attr[@name='kroRegionsItemCanBeSuppliedTo'],attr[@name='kroDistributionTypeByRegion'])"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>
												<!-- RELATIONSHIP: Item_Image -->
												<Relationship>
													<RelationType>Images_for_Item</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(flex/attrGroupMany[@name='externalFileLink']/row)"/>
														</xsl:attribute>
														<xsl:for-each select="flex/attrGroupMany[@name='externalFileLink']/row">
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="concat('Item_Image',ancestor::item/gtin,attr[@name='typeOfInformation'],position())"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>

												<!-- RELATIONSHIP: Promotional_Trade_Item_MVL -->
												<Relationship>
													<RelationType>Item_Master_Promotional_Trade_Item_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(flex/attrGroupMany[@name='promotional']/row)"/>
														</xsl:attribute>
														<xsl:for-each select="flex/attrGroupMany[@name='promotional']/row">
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="concat('PROMOTIONAL_ITEM',ancestor::item/gtin,attr[@name='nonPromotionalItem'])"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>
												<!-- RELATIONSHIP: Organic_claim -->
												<Relationship>
													<RelationType>Item_Organic_Claim</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(organic)"/>
														</xsl:attribute>
														<xsl:for-each select="organic">
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="concat('Organic_Claim',ancestor::item/gtin,claimAgency/text(),tradeItemCode/text())"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>

												<!-- MIX-1 Start: New Repository Relationship -->

												<!--RELATIONSHIP: RetailPriceOnTradeItem_MVL -->
												<Relationship>
													<RelationType>Item_Master_RetailPriceOnTradeItem_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(retailPriceOnTradeItem)"/>
														</xsl:attribute>
														<xsl:for-each select="retailPriceOnTradeItem">
															<RelatedItem>
																<xsl:attribute name="referenceKey">																	
																	<xsl:value-of select="concat('RetailPriceOnTradeItem_MVL',ancestor::item/gtin,@currency)"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship> 

												<!--RELATIONSHIP: OrderSizingFactor_MVL -->
												<Relationship>
													<RelationType>Item_Master_OrderSizingFactor_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(orderSizingFactor)"/>
														</xsl:attribute>
														<xsl:for-each select="orderSizingFactor">
															<RelatedItem>
																<xsl:attribute name="referenceKey">																	
																	<xsl:value-of select="concat('OrderSizingFactor_MVL',ancestor::item/gtin,@uom)"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship> 

												<!--RELATIONSHIP: FlashPointTemperature_MVL -->
												<Relationship>
													<RelationType>Item_Master_FlashPointTemperature_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(hazardousMaterial/flashPointTemperature)"/>
														</xsl:attribute>
														<xsl:for-each select="hazardousMaterial/flashPointTemperature">
															<RelatedItem>
																<xsl:attribute name="referenceKey">																	
																	<xsl:value-of select="concat('FlashPointTemperature_MVL',ancestor::item/gtin,@uom)"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship> 

												<!--RELATIONSHIP: Manufacturer_MVL -->
												<Relationship>
													<RelationType>Item_Master_Manufacturer_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(manufacturer/gln)"/>
														</xsl:attribute>
														<xsl:for-each select="manufacturer">
															<RelatedItem>
																<xsl:attribute name="referenceKey">																	
																	<xsl:value-of select="concat('Manufacturer_MVL',ancestor::item/gtin,'-',gln,'-',position())"/> 															
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship> 

												<!--RELATIONSHIP: CataloguePrice_MVL -->
												<Relationship>
													<RelationType>Item_Master_CataloguePrice_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(cataloguePrice/price)"/>
														</xsl:attribute>
														<xsl:for-each select="cataloguePrice">
															<RelatedItem>
																<xsl:attribute name="referenceKey">																	
																	<xsl:value-of select="concat('CataloguePrice_MVL',ancestor::item/gtin,price/@currency)"/> 															
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship> 


												<!--RELATIONSHIP: Peg_Measurement_MVL -->
												<Relationship>
													<RelationType>Item_Master_Peg_Measurement_MVL</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count(pegMeasurements/pegVertical|pegMeasurements/pegHorizontal)"/>
														</xsl:attribute>
														<xsl:for-each select="pegMeasurements/pegVertical|pegMeasurements/pegHorizontal">
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="concat('Peg_Measurement_MVL',ancestor::item/gtin,local-name(),ancestor::pegMeasurements/pegHoleNumber,@uom)"/>																	
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship>
												<!--RELATIONSHIP: Corporate_Average_List_Cost -->
												<Relationship>
													<RelationType>Item_Master_Corporate_Average_List_Cost</RelationType>
													<RelatedItems>
														<xsl:attribute name="count">
															<xsl:value-of select="count($piHierarchyAttributes/attrGroupMany[@name='kroInitialCorpListCost'] )"/>
														</xsl:attribute>
														<xsl:for-each select="$piHierarchyAttributes/attrGroupMany[@name='kroInitialCorpListCost']/row">
															<RelatedItem>
																<xsl:attribute name="referenceKey">																	
																	<xsl:value-of select="concat('Corporate_Average_List_Cost', '_', attr[@name='kroInitialCorporateGTIN'])"/>
																</xsl:attribute>
															</RelatedItem>
														</xsl:for-each>
													</RelatedItems>
												</Relationship> 											

											</RelationshipData>
										</CatalogItem>
										<!-- Catalog: FUNCTIONALNAME_MVL-->

										<xsl:for-each select="functionalName[generate-id() = generate-id(key('functional', concat(generate-id(..), '|', @lang))[1])]"> 
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('FUNCTIONALNAME_MVL','-',ancestor::item/gtin,'-',@lang)"/>													
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="@lang"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="@lang"/>
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
														<BaseName>FUNCTIONALNAME_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="@lang"/>
														</Value>
													</Attribute>												
													<MultiValueAttribute>
														<xsl:attribute name="name">FUNCTIONALNAME_MVL</xsl:attribute>
														<ValueList>			
															<xsl:for-each select="../functionalName[@lang=current()/@lang]">
																<Value>
																	<xsl:value-of select="."/>
																</Value>
															</xsl:for-each>

														</ValueList>
													</MultiValueAttribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>FUNCTIONALNAME_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>

										<!-- Catalog: GTINNAME_MVL-->

										<xsl:for-each select="gtinName[generate-id() = generate-id(key('gtinName', concat(generate-id(..), '|', @lang))[1])]"> 
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('GTINNAME_MVL','-',ancestor::item/gtin,'-',@lang)"/>													
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="@lang"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="@lang"/>
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
														<BaseName>GTINNAME_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="@lang"/>
														</Value>
													</Attribute>												
													<MultiValueAttribute>
														<xsl:attribute name="name">GTINNAME_MVL</xsl:attribute>
														<ValueList>			
															<xsl:for-each select="../gtinName[@lang=current()/@lang]">
																<Value>
																	<xsl:value-of select="."/>
																</Value>
															</xsl:for-each>
														</ValueList>
													</MultiValueAttribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>GTINNAME_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>

										<!-- Catalog: HANDLINGINSTRUCTIONCODE_MVL-->

										<xsl:for-each select="handlingInstructionCode[generate-id() = generate-id(key('handlingInstructionCode', concat(generate-id(..), '|', @lang))[1])]"> 
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('HANDLINGINSTRUCTIONCODE_MVL','-',ancestor::item/gtin,'-',@lang)"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="@lang"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="@lang"/>
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
														<BaseName>HANDLINGINSTRUCTIONCODE_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="@lang"/>
														</Value>
													</Attribute>												
													<MultiValueAttribute>
														<xsl:attribute name="name">HANDLINGINSTRUCTIONCODE_MVL</xsl:attribute>
														<ValueList>			
															<xsl:for-each select="../handlingInstructionCode[@lang=current()/@lang]">
																<Value>
																	<xsl:value-of select="."/>
																</Value>
															</xsl:for-each>

														</ValueList>
													</MultiValueAttribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>HANDLINGINSTRUCTIONCODE_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>			

										<!-- Catalog: ITEMDESCRIPTION_MVL-->

										<xsl:for-each select="productDescription[generate-id() = generate-id(key('productDescription', concat(generate-id(..), '|', @lang))[1])]"> 
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('ITEMDESCRIPTION_MVL','-',ancestor::item/gtin,'-',@lang)"/>													
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="@lang"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="@lang"/>
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
														<BaseName>ITEMDESCRIPTION_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="@lang"/>
														</Value>
													</Attribute>

													<MultiValueAttribute>
														<xsl:attribute name="name">PRODUCTDESCRIPTION_MVL</xsl:attribute>
														<ValueList>			
															<xsl:for-each select="../productDescription[@lang=current()/@lang]">
																<Value>
																	<xsl:value-of select="."/>
																</Value>
															</xsl:for-each>
														</ValueList>
													</MultiValueAttribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Item_Description_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>	

										<!-- Catalog: GPC_Brick_MVL-->

										<!-- Catalog: GPC_Brick_MVL -->
										<xsl:for-each select="flex/attrGroup[@name='gpcBrickAttributes']/attrGroupMany[@name='gpcBrickAttributeValues']/row">
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('GPC_Brick_MVL',ancestor::item/gtin, attr[@name='gpcBrickAttribute'])"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="attr[@name='gpcBrickAttribute']"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="attr[@name='gpcBrickAttribute']"/>
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
														<BaseName>GPC_Brick_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="attr[@name='gpcBrickAttribute']"/>
														</Value>
													</Attribute>
													<Attribute name="GPCBRICKATTRIBUTE">
														<Value>
															<xsl:value-of select="attr[@name='gpcBrickAttribute']"/>
														</Value>
													</Attribute>
													<Attribute name="GPCBRICKATTRIBUTEDEF">
														<Value>
															<xsl:value-of select="attr[@name='gpcBrickAttributeDef']"/>
														</Value>
													</Attribute>
													<Attribute name="GPCBRICKATTRIBUTENAME">
														<Value>
															<xsl:value-of select="attr[@name='gpcBrickAttributeName']"/>
														</Value>
													</Attribute>
													<Attribute name="GPCBRICKATTRIBUTEVALUE">
														<Value>
															<xsl:value-of select="attr[@name='gpcBrickAttributeValue']"/>
														</Value>
													</Attribute>
													<Attribute name="GPCBRICKATTRIBUTEVALUENAME">
														<Value>
															<xsl:value-of select="attr[@name='gpcBrickAttributeValueName']"/>
														</Value>
													</Attribute>
													<Attribute name="GPCBRICKCODE">
														<Value>
															<xsl:value-of select="../../attr[@name='gpcBrickCode']"/>
														</Value>
													</Attribute> 
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>GPC_BRICK_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>
										<!-- Catalog: Measures_MVL -->
										<xsl:for-each select="height|width|depth">
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('Measures_MVL',ancestor::item/gtin,local-name(),@uom)"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="concat(local-name(),'-',@uom)"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="concat(local-name(),'-',@uom)"/>
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
														<BaseName>Measures_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="concat(local-name(),'-',@uom)"/>
														</Value>
													</Attribute>
													<Attribute name="DIMENSION_TYPE">
														<Value>
															<xsl:value-of select="local-name()"/>
														</Value>
													</Attribute>
													<Attribute name="UOM">
														<Value>
															<xsl:value-of select="@uom"/>
														</Value>
													</Attribute>
													<Attribute name="VALUE">
														<Value>
															<xsl:value-of select="."/>
														</Value>
													</Attribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Measures_MVL_ITEM_MASTER</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>
										<!-- Catalog: Weight_MVL -->
										<xsl:for-each select="netContent|grossWeight|netWeight|drainedWeight">
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('Weight_MVL',ancestor::item/gtin,local-name(),@uom)"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="concat(local-name(),'-',@uom)"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="concat(local-name(),'-',@uom)"/>
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
														<BaseName>Weight_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="concat(local-name(),'-',@uom)"/>
														</Value>
													</Attribute>
													<Attribute name="WEIGHT_TYPE">
														<Value>
															<xsl:value-of select="local-name()"/>
														</Value>
													</Attribute>
													<Attribute name="UOM">
														<Value>
															<xsl:value-of select="@uom"/>
														</Value>
													</Attribute>
													<Attribute name="VALUE">
														<Value>
															<xsl:value-of select="."/>
														</Value>
													</Attribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Measures_MVL_ITEM_MASTER</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>
										<!-- Catalog: Temperature_MVL -->
										<xsl:for-each select="deliveryToDCMinimum|deliveryToDCMaximum|deliveryToDCTemperatureMaximum|deliveryToDCTemperatureMinimum|storageHandlingTempMax|storageHandlingTempMin">
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('Temperature_MVL',ancestor::item/gtin,local-name(),@uom)"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="concat(local-name(),'-',@uom)"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="concat(local-name(),'-',@uom)"/>
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
														<BaseName>Temperature_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="concat(local-name(),'-',@uom)"/>
														</Value>
													</Attribute>
													<Attribute name="TEMPERATURE_TYPE">
														<Value>
															<xsl:value-of select="local-name()"/>
														</Value>
													</Attribute>
													<Attribute name="UOM">
														<Value>
															<xsl:value-of select="@uom"/>
														</Value>
													</Attribute>
													<Attribute name="VALUE">
														<Value>
															<xsl:value-of select="."/>
														</Value>
													</Attribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Temperature_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>

										<!-- Catalog: Food_And_Bev_Allergen_MVL -->
										<xsl:for-each select="flex//attrGroupMany[@name = 'foodAndBevAllergen']/row">
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('Food_And_Bev_Allergen_MVL','-',ancestor::item/gtin,'-',position())"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="concat(attr[@name='allergenSpecificationAgency'], '-',attr[@name='allergenTypeCode'], '-', attr[@name='allergenSpecificationName'],'-',attr[@name='levelOfContainment'])"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="concat(attr[@name='allergenSpecificationAgency'], '-',attr[@name='allergenTypeCode'], '-', attr[@name='allergenSpecificationName'],'-',attr[@name='levelOfContainment'])"/>
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
														<BaseName>Food_And_Bev_Allergen_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="concat(attr[@name='allergenSpecificationAgency'], '-',attr[@name='allergenTypeCode'], '-', attr[@name='allergenSpecificationName'],'-',attr[@name='levelOfContainment'])"/>
														</Value>
													</Attribute>
													<Attribute name="ALLERGENSPECIFICATIONAGENCY">
														<Value>
															<xsl:value-of select="attr[@name='allergenSpecificationAgency']"/>
														</Value>
													</Attribute>
													<Attribute name="ALLERGENSPECIFICATIONNAME">
														<Value>
															<xsl:value-of select="attr[@name='allergenSpecificationName']"/>
														</Value>
													</Attribute>
													<Attribute name="ALLERGENTYPECODE">
														<Value>
															<xsl:value-of select="attr[@name='allergenTypeCode']"/>
														</Value>
													</Attribute>
													<Attribute name="LEVELOFCONTAINMENT">
														<Value>
															<xsl:value-of select="attr[@name='levelOfContainment']"/>
														</Value>
													</Attribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Food_And_Bev_Allergen_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>
										<!-- Catalog: Food_And_Bev_Diet_MVL -->
										<xsl:for-each select="flex//attrGroupMany[@name ='foodAndBevDietTypeInfo']/row">
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('Food_And_Bev_Diet_MVL',ancestor::item/gtin,attr[@name='dietTypeCode'])"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="attr[@name='dietTypeCode']"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="attr[@name='dietTypeCode']"/>
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
														<BaseName>Food_And_Bev_Diet_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="attr[@name='dietTypeCode']"/>
														</Value>
													</Attribute>
													<Attribute name="DIETTYPESUBCODE">
														<Value>
															<xsl:value-of select="attr[@name='dietTypeSubcode']"/>
														</Value>
													</Attribute>

												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Food_And_Bev_Diet_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>
										<!-- Catalog: Food_And_Bev_Ingredient_MVL -->										
										<xsl:for-each select="flex/attrQualMany[@name='ingredientsList']/value[generate-id() = generate-id(key('ingredientmvl', concat(generate-id(..), '|', @qual))[1])]">
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('Food_And_Bev_Ingredient_MVL','-',ancestor::item/gtin,'-',@qual)"/>													
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="@qual"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="@qual"/>
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
														<BaseName>FOOD_AND_BEV_INGREDIENT_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="@qual"/>
														</Value>
													</Attribute>
													<MultiValueAttribute>
														<xsl:attribute name="name">INGREDIENTSLIST_MVL</xsl:attribute>
														<ValueList>         
															<xsl:for-each select="../value[@qual=current()/@qual]">                                           
																<Value>
																	<xsl:value-of select="."/> 
																</Value>
															</xsl:for-each>
														</ValueList>
													</MultiValueAttribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Food_And_Bev_Ingredient_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>
										<!-- Catalog: Food_And_Bev_Nutrifacts_MVL -->

										<xsl:for-each select="flex/attrGroupMany[@name='foodAndBevNutrientInfo']/row">                                
											<xsl:variable name="foodAndBevNutrientInfo" select="." />
											<xsl:variable name="foodAndBevNutrient" select="attrGroupMany[@name = 'foodAndBevNutrient']/row" />
											<xsl:variable name="nutrientQuantityContained" select="attrGroupMany[@name = 'foodAndBevNutrient']/row/attrQualMany[@name = 'nutrientQuantityContained']/value" /> 
											<xsl:variable name="servingSize" select="attrQualMany[@name = 'servingSize']/value" />    
											<xsl:for-each select="$foodAndBevNutrient">
												<xsl:variable name="FABN" select="attr[@name='nutrientTypeCode']"/>
												<xsl:variable name="mp" select="attr[@name='measurementPrecision']"/>
												<xsl:variable name="podvi" select="attr[@name='percentageOfDailyValueIntake']"/>
												<xsl:if test="attrQualMany[@name='nutrientQuantityContained']">
													<xsl:for-each select="attrQualMany[@name='nutrientQuantityContained']/value">
														<xsl:variable name="NQC" select="." />
														<xsl:for-each select="$servingSize">
															<xsl:variable name="SS" select="." />
															<CatalogItem>
																<xsl:attribute name="key">
																	<xsl:value-of select="concat('Food_And_Bev_Nutrifacts_MVL','-',ancestor::item/gtin,'-',$foodAndBevNutrientInfo/attr[@name='preparationState'],'-',$SS,'-',$SS/@qual,'-',$FABN,'-',$NQC,'-',$NQC/@qual)"/>
																</xsl:attribute>
																<LineNumber>
																	<xsl:number/>
																</LineNumber>
																<PartNumber>
																	<GlobalPartNumber>
																		<ProdID>
																			<IDNumber>
																				<xsl:value-of select="ancestor::item/gtin"/>
																			</IDNumber>
																			<IDExtension>
																				<xsl:value-of select="concat($foodAndBevNutrientInfo/attr[@name='preparationState'], '-',$SS,'-',$SS/@qual,'-', $FABN,'-',$NQC,'-',$NQC/@qual)"/>
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
																						<xsl:value-of select="ancestor::item/gtin"/>
																					</Value>
																				</Attribute>
																				<Attribute name="PRODUCTIDEXT">
																					<Value>
																						<xsl:value-of select="concat($foodAndBevNutrientInfo/attr[@name='preparationState'], '-',$SS,'-',$SS/@qual,'-', $FABN,'-',$NQC,'-',$NQC/@qual)"/>
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
																		<BaseName>Food_And_Bev_Nutrifacts_MVL</BaseName>
																		<Version/>
																		<DBID/>
																	</RevisionID>
																</MasterCatalog>
																<ItemData>
																	<Attribute name="PRODUCTID">
																		<Value>
																			<xsl:value-of select="ancestor::item/gtin"/>
																		</Value>
																	</Attribute>
																	<Attribute name="PRODUCTIDEXT">
																		<Value>
																			<xsl:value-of select="concat($foodAndBevNutrientInfo/attr[@name='preparationState'], '-',$SS,'-',$SS/@qual,'-', $FABN,'-',$NQC,'-',$NQC/@qual)"/>
																		</Value>
																	</Attribute>
																	<Attribute name="PREPARATIONSTATE">
																		<Value>
																			<xsl:value-of select="$foodAndBevNutrientInfo/attr[@name='preparationState']"/>
																		</Value>
																	</Attribute>
																	<Attribute name="SERVINGSIZE">
																		<Value>
																			<xsl:value-of select="$SS"/>
																		</Value>
																	</Attribute>
																	<Attribute name="SERVINGSIZE_UOM">
																		<Value>
																			<xsl:value-of select="$SS/@qual"/>
																		</Value>
																	</Attribute>
																	<Attribute name="NUTRIENTTYPECODE">
																		<Value>
																			<xsl:value-of select="$FABN"/>
																		</Value>
																	</Attribute>
																	<Attribute name="MEASUREMENTPRECISION">
																		<Value>
																			<xsl:value-of select="$mp"/>
																		</Value>
																	</Attribute>
																	<Attribute name="PERCENTAGEOFDAILYVLUINTAKE">
																		<Value>
																			<xsl:value-of select="$podvi"/>
																		</Value>
																	</Attribute>
																	<Attribute name="NUTRIENTQUANTITYCONTAINED">
																		<Value>
																			<xsl:value-of select="$NQC"/>
																		</Value>
																	</Attribute>
																	<Attribute name="NUTRIENTQTYCONTAINEDUOM">
																		<Value>
																			<xsl:value-of select="$NQC/@qual"/>
																		</Value>
																	</Attribute>
																</ItemData>

																<RelationshipData>
																	<Relationship>
																		<RelationType>Food_And_Bev_Nutrifacts_MVL_Item_Master</RelationType>
																		<RelatedItems>
																			<xsl:attribute name="count">1</xsl:attribute>
																			<RelatedItem>
																				<xsl:attribute name="referenceKey">
																					<xsl:value-of select="ancestor::item/gtin"/>
																				</xsl:attribute>
																			</RelatedItem>
																		</RelatedItems>
																	</Relationship>
																</RelationshipData>
															</CatalogItem>
														</xsl:for-each>
													</xsl:for-each>
												</xsl:if> 
											</xsl:for-each>
											<xsl:for-each select="$foodAndBevNutrient">
												<xsl:variable name="FABN" select="attr[@name='nutrientTypeCode']"/>
												<xsl:variable name="mp" select="attr[@name='measurementPrecision']"/>
												<xsl:variable name="podvi" select="attr[@name='percentageOfDailyValueIntake']"/>
												<xsl:if test="not(attrQualMany[@name='nutrientQuantityContained'])">
													<xsl:for-each select="$servingSize">
														<xsl:variable name="SS" select="." />
														<CatalogItem>
															<xsl:attribute name="key">
																<xsl:value-of select="concat('Food_And_Bev_Nutrifacts_MVL','-',ancestor::item/gtin,'-',$foodAndBevNutrientInfo/attr[@name='preparationState'],'-',$SS,'-',$SS/@qual,'-',$FABN,'-','-')"/>																    
															</xsl:attribute>
															<LineNumber>
																<xsl:number/>
															</LineNumber>
															<PartNumber>
																<GlobalPartNumber>
																	<ProdID>
																		<IDNumber>
																			<xsl:value-of select="ancestor::item/gtin"/>
																		</IDNumber>
																		<IDExtension>
																			<xsl:value-of select="concat($foodAndBevNutrientInfo/attr[@name='preparationState'], '-',$SS,'-',$SS/@qual,'-', $FABN,'-','-')"/>
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
																					<xsl:value-of select="ancestor::item/gtin"/>
																				</Value>
																			</Attribute>
																			<Attribute name="PRODUCTIDEXT">
																				<Value>
																					<xsl:value-of select="concat($foodAndBevNutrientInfo/attr[@name='preparationState'], '-',$SS,'-',$SS/@qual,'-', $FABN,'-','-')"/>
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
																	<BaseName>Food_And_Bev_Nutrifacts_MVL</BaseName>
																	<Version/>
																	<DBID/>
																</RevisionID>
															</MasterCatalog>
															<ItemData>
																<Attribute name="PRODUCTID">
																	<Value>
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="concat($foodAndBevNutrientInfo/attr[@name='preparationState'], '-',$SS,'-',$SS/@qual,'-', $FABN,'-','-')"/>
																	</Value>
																</Attribute>
																<Attribute name="PREPARATIONSTATE">
																	<Value>
																		<xsl:value-of select="$foodAndBevNutrientInfo/attr[@name='preparationState']"/>
																	</Value>
																</Attribute>
																<Attribute name="SERVINGSIZE">
																	<Value>
																		<xsl:value-of select="$SS"/>
																	</Value>
																</Attribute>
																<Attribute name="SERVINGSIZE_UOM">
																	<Value>
																		<xsl:value-of select="$SS/@qual"/>
																	</Value>
																</Attribute>
																<Attribute name="NUTRIENTTYPECODE">
																	<Value>
																		<xsl:value-of select="$FABN"/>
																	</Value>
																</Attribute>
																<Attribute name="MEASUREMENTPRECISION">
																	<Value>
																		<xsl:value-of select="$mp"/>
																	</Value>
																</Attribute>
																<Attribute name="PERCENTAGEOFDAILYVLUINTAKE">
																	<Value>
																		<xsl:value-of select="$podvi"/>
																	</Value>
																</Attribute>                                            
															</ItemData>
															<RelationshipData>
																<Relationship>
																	<RelationType>Food_And_Bev_Nutrifacts_MVL_Item_Master</RelationType>
																	<RelatedItems>
																		<xsl:attribute name="count">1</xsl:attribute>
																		<RelatedItem>
																			<xsl:attribute name="referenceKey">
																				<xsl:value-of select="ancestor::item/gtin"/>
																			</xsl:attribute>
																		</RelatedItem>
																	</RelatedItems>
																</Relationship>
															</RelationshipData>
														</CatalogItem>
													</xsl:for-each>
												</xsl:if>       
											</xsl:for-each>
										</xsl:for-each> 
										<!-- CATALOG: Corporate_Average_List_Cost-->	
										<xsl:for-each select="$piHierarchyAttributes/attrGroupMany[@name='kroInitialCorpListCost']/row">					
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('Corporate_Average_List_Cost', '_', attr[@name='kroInitialCorporateGTIN'])"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select= "$root_gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select= "attr[@name='kroInitialCorporateGTIN']"/>
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
																		<xsl:value-of select= "$root_gtin"/>	
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select= "attr[@name='kroInitialCorporateGTIN']"/>
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
														<BaseName>Corporate_Average_List_Cost</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select= "$root_gtin"/>	
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select= "attr[@name='kroInitialCorporateGTIN']"/>
														</Value>
													</Attribute>
													<Attribute name="INITIALCORPORATEAVGLISTCOST">
														<Value>
															<xsl:value-of select="attr[@name='kroInitialCorporateAvgListCost']"/>
														</Value>
													</Attribute>
													<Attribute name="INITIALCORPORATEPRODUCTTYPE">
														<Value>
															<xsl:value-of select="attr[@name='kroInitialCorporateProductType']"/>
														</Value>
													</Attribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Corporate_Average_List_Cost_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>		


										<!-- CATALOG: RetailPriceOnTradeItem_MVL-->
										<xsl:for-each select="retailPriceOnTradeItem">						
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('RetailPriceOnTradeItem_MVL',ancestor::item/gtin,@currency)"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select= "@currency"/>

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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select= "@currency"/>
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
														<BaseName>RetailPriceOnTradeItem_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select= "@currency"/>
														</Value>
													</Attribute>
													<Attribute name="RETAILPRICEONTRADEITEM">
														<Value>
															<xsl:value-of select="."/>
														</Value>
													</Attribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>RetailPriceOnTradeItem_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="$keyid"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>			

										<!-- CATALOG: OrderSizingFactor_MVL-->
										<xsl:for-each select="orderSizingFactor">						
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('OrderSizingFactor_MVL',ancestor::item/gtin,@uom)"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select= "@uom"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select= "@uom"/>
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
														<BaseName>OrderSizingFactor_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select= "@uom"/>
														</Value>
													</Attribute>
													<Attribute name="ORDERSIZINGFACTOR">
														<Value>
															<xsl:value-of select="."/>
														</Value>
													</Attribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>OrderSizingFactor_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="$keyid"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>		

										<!-- CATALOG: FlashPointTemperature_MVL-->

										<xsl:for-each select="hazardousMaterial/flashPointTemperature">						
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('FlashPointTemperature_MVL',ancestor::item/gtin,@uom)"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select= "@uom"/>

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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select= "@uom"/>
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
														<BaseName>FlashPointTemperature_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select= "@uom"/>
														</Value>
													</Attribute>
													<Attribute name="FLASHPOINTTEMPERATURE">
														<Value>
															<xsl:value-of select="."/>
														</Value>
													</Attribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>FlashPointTemperature_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="$keyid"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>		

										<!-- CATALOG: Manufacturer_MVL-->

										<xsl:for-each select="manufacturer">						
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('Manufacturer_MVL',ancestor::item/gtin,'-',gln,'-',position())"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="concat(gln,'-',name)"/>																
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="concat(gln,'-',name)"/>	
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
														<BaseName>Manufacturer_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select= "concat(gln,'-',name)"/>
														</Value>
													</Attribute>
													<Attribute name="MANUFACTURER_NAME">
														<Value>
															<xsl:value-of select= "name"/>
														</Value>
													</Attribute>
													<Attribute name="MANUFACTURER_GLN">
														<Value>
															<xsl:value-of select= "gln"/>
														</Value>
													</Attribute>
													<MultiValueAttribute>
														<xsl:attribute name="name">MFGPLANTIDENTIFICATNGLN_MVL</xsl:attribute>
														<ValueList>
															<xsl:for-each select="manufacturingPlantIdentificationGLN">
																<Value>
																	<xsl:value-of select="."/>
																</Value>
															</xsl:for-each>
														</ValueList>
													</MultiValueAttribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Manufacturer_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="$keyid"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>		

										<!-- CATALOG: CataloguePrice_MVL-->

										<xsl:for-each select="cataloguePrice">						
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('CataloguePrice_MVL',ancestor::item/gtin,price/@currency)"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="concat(effectiveStartDate,'-',price/@currency)"/>															
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="concat(effectiveStartDate,'-',price/@currency)"/>
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
														<BaseName>CataloguePrice_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="concat(effectiveStartDate,'-',price/@currency)"/>															
														</Value>
													</Attribute>
													<Attribute name="CATALOGUEPRICE_CURRENCYCODE">
														<Value>
															<xsl:value-of select= "price/@currency"/>
														</Value>
													</Attribute>
													<Attribute name="PRICE">
														<Value>
															<xsl:value-of select= "price"/>
														</Value>
													</Attribute>
													<Attribute name="EFFECTIVESTARTDATE">
														<Value>
															<xsl:value-of select= "effectiveStartDate"/>
														</Value>
													</Attribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>CataloguePrice_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="$keyid"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>				

										<!-- CATALOG: Peg_Measurement_MVL-->

										<xsl:for-each select="pegMeasurements/pegVertical|pegMeasurements/pegHorizontal">				
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('Peg_Measurement_MVL',ancestor::item/gtin,local-name(),ancestor::pegMeasurements/pegHoleNumber,@uom)"/>							
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="concat(../pegHoleNumber,'-',local-name(),'-',@uom)"/>																	
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="concat(../pegHoleNumber,'-',local-name(),'-',@uom)"/>	
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
														<BaseName>Peg_Measurement_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="concat(../pegHoleNumber,'-',local-name(),'-',@uom)"/>													
														</Value>
													</Attribute>
													<Attribute name="PEG_MEASURE_TYPE">
														<Value>
															<xsl:value-of select="local-name()"/>
														</Value>
													</Attribute>
													<Attribute name="PEGUOM">
														<Value>
															<xsl:value-of select= "@uom"/>
														</Value>
													</Attribute> 
													<Attribute name="PEGHOLETYPE">
														<Value>
															<xsl:value-of select= "../pegHoleType"/>  
														</Value>
													</Attribute>
													<Attribute name="PEGHOLENUMBER">
														<Value>
															<xsl:value-of select= "../pegHoleNumber"/>
														</Value>
													</Attribute>
													<xsl:if test="local-name() = 'pegHorizontal'">
														<Attribute name="VALUE">
															<Value>
																<xsl:value-of select= "../pegHorizontal[@uom=current()/@uom]"/>
															</Value>
														</Attribute>
													</xsl:if>
													<xsl:if test="local-name() = 'pegVertical'">
														<Attribute name="VALUE">
															<Value>
																<xsl:value-of select= "../pegVertical[@uom=current()/@uom]"/>
															</Value>
														</Attribute>
													</xsl:if>	
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Peg_Measurement_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="$keyid"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>	

										<!-- Catalog: Food_And_Bev_Prep_MVL -->								

										<xsl:for-each select="flex/attrGroupMany[@name ='foodAndBevPreparationInfo']/row/attrQualMany[@name='preparationInstructions']/value[generate-id() = generate-id(key('prepmvl', concat(generate-id(..), '|', @qual))[1])]"> 
											<CatalogItem>
												<xsl:attribute name="key">            
													<xsl:value-of select="concat('Food_And_Bev_Prep_MVL','-',ancestor::item/gtin,'-',../../attr[@name='preparationType'],'-',@qual)"/>                       
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="concat(../../attr[@name='preparationType'], '-', @qual)"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="concat(../../attr[@name='preparationType'], '-', @qual)"/>
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
														<BaseName>Food_And_Bev_Prep_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="concat(../../attr[@name='preparationType'], '-', @qual)"/>
														</Value>
													</Attribute>
													<Attribute name="PREPARATIONTYPE">
														<Value>
															<xsl:value-of select="../../attr[@name='preparationType']"/>
														</Value>
													</Attribute>
													<MultiValueAttribute>
														<xsl:attribute name="name">PREPARATIONINSTRUCTIONS_MVL</xsl:attribute>
														<ValueList>         
															<xsl:for-each select="../value[@qual=current()/@qual]">                                           
																<Value>
																	<xsl:value-of select="."/> 
																</Value>
															</xsl:for-each>
														</ValueList>
													</MultiValueAttribute>
													<Attribute name="LANGUAGE_CODE">
														<Value>
															<xsl:value-of select="./@qual"/>
														</Value>
													</Attribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Food_And_Bev_Prep_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>

										<!-- Catalog: Authorized_Region_MVL -->
										<xsl:for-each select="flex//attrGroupMany[@name='kroRegions']/row">
											<xsl:variable name="regionNme">
												<Value>
													<xsl:value-of select="attr[@name='kroRegionsItemCanBeSuppliedTo']"/>
												</Value>
											</xsl:variable>
											<xsl:variable name="sourceNme">
												<Value>
													<xsl:value-of select="attr[@name='kroDistributionTypeByRegion']"/>
												</Value>
											</xsl:variable>
											<xsl:variable name="hierarchyLevelProductType">
												<Value>
													<xsl:value-of select="attr[@name='kroHierarchyLevelProductType']"/>
												</Value>
											</xsl:variable>

											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('Authorized_Region_MVL',$keyid,attr[@name='kroRegionsItemCanBeSuppliedTo'], attr[@name='kroDistributionTypeByRegion'])"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="$keyid"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="concat(attr[@name='kroRegionsItemCanBeSuppliedTo'], '_', attr[@name='kroDistributionTypeByRegion'])"/>
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
																		<xsl:value-of select="$keyid"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="concat(attr[@name='kroRegionsItemCanBeSuppliedTo'], '_', attr[@name='kroDistributionTypeByRegion'])"/>
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
														<BaseName>Authorized_Region_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="$keyid"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="concat(attr[@name='kroRegionsItemCanBeSuppliedTo'], '_', attr[@name='kroDistributionTypeByRegion'])"/>
														</Value>
													</Attribute>
													<Attribute name="REGIONSITEMCANBESUPPLIEDTO">
														<Value>
															<xsl:value-of select="attr[@name='kroRegionsItemCanBeSuppliedTo']"/>
														</Value>
													</Attribute>
													<Attribute name="FIRSTAVAILABLEDATEBYREGION">
														<Value>
															<xsl:value-of select="attr[@name='kroFirstAvailableDateByRegion']"/>
														</Value>
													</Attribute>
													<Attribute name="ENDAVAILABILITYDATEBYREGION">
														<Value>
															<xsl:value-of select="attr[@name='kroEndAvailabilityDateByRegion']"/>
														</Value>
													</Attribute>
													<Attribute name="INITIALLISTCOST">
														<Value>
															<xsl:value-of select="attr[@name='kroInitialListCost']"/>
														</Value>
													</Attribute>
													<Attribute name="INITIALPROMOCOSTDETAILS">
														<Value>
															<xsl:value-of select="attr[@name='kroInitialPromotionalCostDetails']"/>
														</Value>
													</Attribute>
													<Attribute name="INITIALPROMOTIONALCOST">
														<Value>
															<xsl:value-of select="attr[@name='kroInitialPromotionalCost']"/>
														</Value>
													</Attribute>
													<Attribute name="DISTRIBUTIONTYPEBYREGION">
														<Value>
															<xsl:value-of select="attr[@name='kroDistributionTypeByRegion']"/>
														</Value>
													</Attribute>


													<Attribute name="REGIONORDERLEADTIMEUOM">
														<Value>
															<xsl:value-of select="attr[@name='kroRegionOrderLeadTimeUOM']"/>
														</Value>
													</Attribute>

													<Attribute name="REGIONORDERLEADTIME">
														<Value>
															<xsl:value-of select="attr[@name='kroRegionOrderLeadTime']"/>
														</Value>
													</Attribute>
													<MultiValueAttribute>
														<xsl:attribute name="name">TRANSPORTATIONOPTIONS_MVL</xsl:attribute>
														<ValueList>
															<xsl:for-each select="attrMany[@name='kroTransportationOptions']/value">
																<Value>
																	<xsl:value-of select="."/>
																</Value>
															</xsl:for-each>
														</ValueList>
													</MultiValueAttribute>	
													<Attribute name="HIERARCHYLEVELPRODUCTTYPE">
														<Value>
															<xsl:value-of select="attr[@name='kroHierarchyLevelProductType']"/>
														</Value>
													</Attribute>                
													<Attribute name="DISPATCH_UNIT_ITEM_ID">
														<Value>
															<xsl:value-of select="../../../../../item[isDispatchUnit='true' and productType=$hierarchyLevelProductType][1]/gtin"/>																	
														</Value>
													</Attribute>
													<MultiValueAttribute name="DIVISION_MVL">
														<ValueList>
															<xsl:for-each select="../../attrGroupMany[@name='kroRegions']/row[attr[@name='kroDistributionTypeByRegion']/text() = $sourceNme and attr[@name='kroRegionsItemCanBeSuppliedTo']/text() = $regionNme]/attr[@name='kroDivision']">
																<Value>
																	<xsl:value-of select="."/>
																</Value>
															</xsl:for-each>
														</ValueList>
													</MultiValueAttribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Authorized_Region_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="$keyid"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>
										<!-- Catalog: Item_Image -->
										<xsl:for-each select="flex/attrGroupMany[@name='externalFileLink']/row">
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('Item_Image',ancestor::item/gtin,attr[@name='typeOfInformation'],position())"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>																
																<xsl:value-of select="concat(position(),'-',attr[@name='typeOfInformation'],'-',attrQualMany[@name='externalFileLinkContentDescription']/value/@qual)"/>															  
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="concat(position(),'-',attr[@name='typeOfInformation'],'-',attrQualMany[@name='externalFileLinkContentDescription']/value/@qual)"/>															   	
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
														<BaseName>Item_Image</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="concat(position(),'-',attr[@name='typeOfInformation'],'-',attrQualMany[@name='externalFileLinkContentDescription']/value/@qual)"/>						
														</Value>
													</Attribute>
													<Attribute name="FILEEFFECTIVESTARTDATETIME">
														<Value>
															<xsl:call-template name="getDateTime1">
																<xsl:with-param name="dateTime" select="attr[@name='fileEffectiveStartDateTime']"/>
															</xsl:call-template>
														</Value>
													</Attribute>
													<Attribute name="FILEEFFECTIVEENDDATETIME">
														<Value>
															<xsl:call-template name="getDateTime1">
																<xsl:with-param name="dateTime" select="attr[@name='fileEffectiveEndDateTime']"/>
															</xsl:call-template>
														</Value>
													</Attribute>
													<Attribute name="FILEFORMATNAME">
														<Value>
															<xsl:value-of select="attr[@name='fileFormatName']"/>
														</Value>
													</Attribute>
													<Attribute name="EXTERNALFILELINKFILENAME">
														<Value>
															<xsl:value-of select="attr[@name='externalFileLinkFileName']"/>
														</Value>
													</Attribute>
													<Attribute name="IMAGE_SEQUENCE_NO">
														<Value>
															<xsl:value-of select="position()"/>
														</Value>
													</Attribute>
													<Attribute name="UNIFORMRESOURCEIDENTIFIER">
														<Value>
															<xsl:value-of select="attr[@name='uniformResourceIdentifier']"/>
														</Value>
													</Attribute>
													<Attribute name="TYPEOFINFORMATION">
														<Value>
															<xsl:value-of select="attr[@name='typeOfInformation']"/>
														</Value>
													</Attribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Item_Image_ITEM_MASTER</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>

										<!-- Catalog: Promotional_Trade_Item_MVL -->
										<xsl:for-each select="flex/attrGroupMany[@name='promotional']/row">
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('PROMOTIONAL_ITEM',ancestor::item/gtin,attr[@name='nonPromotionalItem'])"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="attr[@name='nonPromotionalItem']"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="attr[@name='nonPromotionalItem']"/>
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
														<BaseName>PROMOTIONAL_TRADE_ITEM_MVL</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="attr[@name='nonPromotionalItem']"/>
														</Value>
													</Attribute>
													<Attribute name="PROMOTIONALTYPECODE">
														<Value>
															<xsl:value-of select="attr[@name='promotionalTypeCode']"/>
														</Value>
													</Attribute>
													<Attribute name="FREEQTYOFNEXTLOWERLEVEL">
														<Value>
															<xsl:value-of select="attrQualMany[@name='freeQtyOfNextLowerLevel']/value[1]/text()"/>
														</Value>
													</Attribute>
													<Attribute name="FREEQTYOFNEXTLOWERLEVELUOM">
														<Value>
															<xsl:value-of select="attrQualMany[@name='freeQtyOfNextLowerLevel']/value[1]/@qual"/>
														</Value>
													</Attribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Promotional_Trade_Item_MVL_Item_Master</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
											</CatalogItem>
										</xsl:for-each>
										<!-- Catalog: Organic_Claim -->
										<xsl:for-each select="organic">
											<CatalogItem>
												<xsl:attribute name="key">
													<xsl:value-of select="concat('Organic_Claim',ancestor::item/gtin,claimAgency/text(),tradeItemCode/text())"/>
												</xsl:attribute>
												<LineNumber>
													<xsl:number/>
												</LineNumber>
												<PartNumber>
													<GlobalPartNumber>
														<ProdID>
															<IDNumber>
																<xsl:value-of select="ancestor::item/gtin"/>
															</IDNumber>
															<IDExtension>
																<xsl:value-of select="concat(claimAgency/text(),'-',tradeItemCode/text())"/>
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
																		<xsl:value-of select="ancestor::item/gtin"/>
																	</Value>
																</Attribute>
																<Attribute name="PRODUCTIDEXT">
																	<Value>
																		<xsl:value-of select="concat(claimAgency/text(),'-',tradeItemCode/text())"/>
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
														<BaseName>ORGANIC_CLAIM</BaseName>
														<Version/>
														<DBID/>
													</RevisionID>
												</MasterCatalog>
												<ItemData>
													<Attribute name="PRODUCTID">
														<Value>
															<xsl:value-of select="ancestor::item/gtin"/>
														</Value>
													</Attribute>
													<Attribute name="PRODUCTIDEXT">
														<Value>
															<xsl:value-of select="concat(claimAgency/text(),'-',tradeItemCode/text())"/>
														</Value>
													</Attribute>
													<Attribute name="CLAIMAGENCY">
														<Value>
															<xsl:value-of select="claimAgency/text()"/>
														</Value>
													</Attribute>
													<Attribute name="TRADEITEMCODE">
														<Value>
															<xsl:value-of select="tradeItemCode/text()"/>
														</Value>
													</Attribute>
												</ItemData>
												<RelationshipData>
													<Relationship>
														<RelationType>Organic_Claim_Items</RelationType>
														<RelatedItems>
															<xsl:attribute name="count">1</xsl:attribute>
															<RelatedItem>
																<xsl:attribute name="referenceKey">
																	<xsl:value-of select="ancestor::item/gtin"/>
																</xsl:attribute>
															</RelatedItem>
														</RelatedItems>
													</Relationship>
												</RelationshipData>
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
			<xsl:when test="$value = 'No'">FALSE</xsl:when>
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