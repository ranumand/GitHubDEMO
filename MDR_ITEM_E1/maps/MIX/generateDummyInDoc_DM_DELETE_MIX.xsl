<?xml version="1.0" encoding="UTF-8"?>
<!-- 
<?xml-stylesheet type="text/xsl" href="MapDisplay.xsl"?>
-->
<xsl:stylesheet version="1.0" xmlns:format="com.martquest.util.XSLTFormatter" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:os="http://www.1sync.org" xmlns:java="http://xml.apache.org/xslt/java" xmlns:uuid="com.martquest.util.UUIDGen" xmlns:timezone="java.util.TimeZone" xmlns:alist="java.util.ArrayList" extension-element-prefixes="format alist" exclude-result-prefixes="java alist">
   <xsl:output method="xml" indent="yes" />
    <xsl:param name="Xsl_Param_productIDs"/>
   <xsl:template match="/">
     <Message xmlns:os="http://www.1sync.org" xmlns:timezone="java.util.TimeZone" xmlns:uuid="com.martquest.util.UUIDGen"
         externalControlNumber="1341557367296" externalVersion="2.6" language="en" messageType="Production"
         mlxmlVersion="2.6" protocol="1Sync" timestamp="1341557384275">
         <Header xmlns:eanucc="http://www.ean-ucc.org/schemas/1.3.1/eanucc"
            xmlns:eb="http://www.ebxml.org/namespaces/messageHeader"
            xmlns:se="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:ve="http://www.velosel.com/schema/messaging-extension/1.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <MessageHeader origin="OriginalSender" role="Buyer"/>
        <MessageHeader origin="Receiver" role="Retailer">
            <Enterprise>
                <PartyID>
                    <PartyName><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Retailer']/Enterprise/PartyID/PartyName/text()"/></PartyName>
                    <DBID><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Retailer']/Enterprise/PartyID/DBID/text()"/></DBID>
                    <ShortName><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Retailer']/Enterprise/PartyID/ShortName/text()"/></ShortName>
                </PartyID>
            </Enterprise>
            <Organization>
                <PartyID>
                    <PartyName><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Retailer']/Organization/PartyID/PartyName/text()"/></PartyName>
                    <DBID><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Retailer']/Organization/PartyID/DBID/text()"/></DBID>
                </PartyID>
            </Organization>
            <Member>
                <PartyID>
                    <PartyName><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Retailer']/Member/PartyID/PartyName/text()"/></PartyName>
                    <DBID><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Retailer']/Member/PartyID/DBID/text()"/></DBID>
                </PartyID>
            </Member>
            <Credential domain="GLN">
                <Identity><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Retailer']/Credential/Identity/text()"/></Identity>
            </Credential>
        </MessageHeader>
        <MessageHeader origin="Sender" role="Channel">
            <Enterprise>
                <PartyID>
                    <PartyName><xsl:value-of select="/Message/Header/MessageHeader[@origin='Sender' and @role='Channel']/Enterprise/PartyID/PartyName/text()"/></PartyName>
                    <DBID><xsl:value-of select="/Message/Header/MessageHeader[@origin='Sender' and @role='Channel']/Enterprise/PartyID/DBID/text()"/></DBID>
                    <ShortName><xsl:value-of select="/Message/Header/MessageHeader[@origin='Sender' and @role='Channel']/Enterprise/PartyID/ShortName/text()"/></ShortName>
                </PartyID>
            </Enterprise>
            <Organization>
                <PartyID>
                    <PartyName><xsl:value-of select="/Message/Header/MessageHeader[@origin='Sender' and @role='Channel']/Organization/PartyID/PartyName/text()"/></PartyName>
                    <DBID><xsl:value-of select="/Message/Header/MessageHeader[@origin='Sender' and @role='Channel']/Organization/PartyID/DBID/text()"/></DBID>
                </PartyID>
            </Organization>
            <Member>
                <PartyID>
                    <PartyName><xsl:value-of select="/Message/Header/MessageHeader[@origin='Sender' and @role='Channel']/Member/PartyID/PartyName/text()"/></PartyName>
                    <DBID><xsl:value-of select="/Message/Header/MessageHeader[@origin='Sender' and @role='Channel']/Member/PartyID/DBID/text()"/></DBID>
                </PartyID>
            </Member>
            <Credential domain="GLN">
                <Identity><xsl:value-of select="/Message/Header/MessageHeader[@origin='Sender' and @role='Channel']/Credential/Identity/text()"/></Identity>
            </Credential>
        </MessageHeader>
        <MessageHeader origin="IntendedReceiver"/>
    </Header>
    <Body>
        <Document subtype="ProdDataNotifAdd" type="ProdDataNotif">
            <BusinessDocument>
                <CatalogAction>
                    <CatalogActionHeader>
                        <ThisDocID>
                            <DocID>
                                <IDNumber></IDNumber>
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
                                <CodeType><xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/ActionCode/Code/CodeType/text()"/></CodeType>
                                <Value><xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/ActionCode/Code/Value/text()"/></Value>
                            </Code>
                        </ActionCode>
                        <Date>
                            <Code>
                                <CodeType></CodeType>
                                <Normal></Normal>
                            </Code>
                            <DateValue>
                                <Value></Value>
                            </DateValue>
                            <TimeValue>
                                <Value></Value>
                            </TimeValue>
                            <Normal></Normal>
                        </Date>
                        <Reference>
                            <ReferenceCode>
                                <Code>
                                    <CodeType><xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/Reference/ReferenceCode/Code/CodeType/text()"/></CodeType>
                                    <Normal><xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/Reference/ReferenceCode/Code/Normal/text()"/></Normal>
                                </Code>
                            </ReferenceCode>
                            <DocID>
                                <IDNumber></IDNumber>
                                <Agency>
                                    <Code>
                                        <CodeType><xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/Reference/DocID/Agency/Code/CodeType/text()"/></CodeType>
                                        <Normal><xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/Reference/DocID/Agency/Code/Normal/text()"/></Normal>
                                    </Code>
                                </Agency>
                            </DocID>
                        </Reference>
                        <URL>
                            <Code>
                                <CodeType><xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/URL/Code/CodeType/text()"/></CodeType>
                                <Normal><xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/URL/Code/Normal/text()"/></Normal>
                            </Code>
                        </URL>
                        <CatalogActionHeaderAck>
                            <AcknowledgmentCode>
                                <Code>
                                    <Value/>
                                </Code>
                            </AcknowledgmentCode>
                            <Instructions>
                                <Description>
                                    <Long/>
                                </Description>
                            </Instructions>
                            <Owner>
                                <PartyID>
                                    <PartyName/>
                                    <DBID/>
                                </PartyID>
                            </Owner>
                            <Workitem>
                                <DBID/>
                            </Workitem>
                        </CatalogActionHeaderAck>
                        <MasterCatalog>
                            <RevisionID>
                                <BaseName>ITEM_MASTER</BaseName>
                                <Version/>
                                <DBID><xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/MasterCatalog/RevisionID/DBID/text()"/></DBID>
                            </RevisionID>
                        </MasterCatalog>
                    </CatalogActionHeader>
                    <CatalogActionDetails>
					<xsl:call-template name="fillCatalogItem">
					</xsl:call-template>
                       
		</CatalogActionDetails>
	</CatalogAction>
</BusinessDocument>
<OriginalDocument/>
</Document>
</Body>
</Message>
</xsl:template>
 
		<xsl:template name="fillCatalogItem">
			<xsl:call-template name="parseString">
				<xsl:with-param name="list" select="$Xsl_Param_productIDs"/>
			</xsl:call-template>
		</xsl:template>
 
		 <xsl:template name="parseString">
			<xsl:param name="list"/>
			<xsl:choose>
				<xsl:when test="not(contains($list, ','))">
				<xsl:call-template name="createCINode">
					<xsl:with-param name="productID" select="normalize-space($list)"/>
				</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="createCINode">
						<xsl:with-param name="productID" select="normalize-space(substring-before($list, ','))"/>
					</xsl:call-template>
					<xsl:call-template name="parseString">
						<xsl:with-param name="list" select="substring-after($list, ',')"/>
					</xsl:call-template>
				</xsl:otherwise>
		   </xsl:choose>
		
		</xsl:template>
		
		<xsl:template name="createCINode">
			<xsl:param name="productID"/>
				<CatalogItem>
						<LineNumber>1</LineNumber>
						<PartNumber>
							<GlobalPartNumber>
								<ProdID>
									<IDNumber><xsl:value-of select="$productID"/></IDNumber>
									<IDExtension/>
									<Agency>
										<Code>
											<CodeType>Agency</CodeType>
											<Normal>SOURCE</Normal>
										</Code>
									</Agency>
									<ExternalKey>
										<Attribute name="PRODUCTID">
											<Value><xsl:value-of select="$productID"/></Value>
										</Attribute>
										<Attribute name="PRODUCTIDEXT">
											<Value/>
										</Attribute>
									</ExternalKey>
									<OriginalIDVersion></OriginalIDVersion>
									<IDVersion></IDVersion>
									<DBID/>
								</ProdID>
							</GlobalPartNumber>
						</PartNumber>
						<MasterCatalog>
							<RevisionID>
								<BaseName>ITEM_MASTER</BaseName>
								<Version/>
							</RevisionID>
							<DBID>
								<xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionHeader/MasterCatalog/RevisionID/DBID/text()"/>
							</DBID>
						</MasterCatalog>
						<Contact/>
						<Reference/>
						<URL/>
						<Extension/>
						<ItemData/>
						<ActionLog/>
				</CatalogItem>
		</xsl:template>
		
</xsl:stylesheet>
