<?xml version="1.0" encoding="UTF-8"?>
<!-- 
<?xml-stylesheet type="text/xsl" href="MapDisplay.xsl"?>
-->
<xsl:stylesheet version="1.0" xmlns:format="com.martquest.util.XSLTFormatter" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:os="http://www.1sync.org" xmlns:java="http://xml.apache.org/xslt/java" xmlns:uuid="com.martquest.util.UUIDGen" xmlns:timezone="java.util.TimeZone" xmlns:alist="java.util.ArrayList" extension-element-prefixes="format alist" exclude-result-prefixes="java alist">
   <xsl:output method="xml" indent="yes" />
    <xsl:param name="Xsl_Param_ReplacedGTIN"/>
	<xsl:param name="Xsl_Param_ROOT_PKID"/>
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
        <MessageHeader origin="Receiver" role="Supplier">
            <Enterprise>
                <PartyID>
                    <PartyName><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Supplier']/Enterprise/PartyID/PartyName/text()"/></PartyName>
                    <DBID><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Supplier']/Enterprise/PartyID/DBID/text()"/></DBID>
                    <ShortName><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Supplier']/Enterprise/PartyID/ShortName/text()"/></ShortName>
                </PartyID>
            </Enterprise>
            <Organization>
                <PartyID>
                    <PartyName><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Supplier']/Organization/PartyID/PartyName/text()"/></PartyName>
                    <DBID><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Supplier']/Organization/PartyID/DBID/text()"/></DBID>
                </PartyID>
            </Organization>
            <Member>
                <PartyID>
                    <PartyName><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Supplier']/Member/PartyID/PartyName/text()"/></PartyName>
                    <DBID><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Supplier']/Member/PartyID/DBID/text()"/></DBID>
                </PartyID>
            </Member>
            <Credential domain="GLN">
                <Identity><xsl:value-of select="/Message/Header/MessageHeader[@origin='Receiver' and @role='Supplier']/Credential/Identity/text()"/></Identity>
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
       <Document>
            <xsl:attribute name="subtype"><xsl:value-of select="/Message/Body[1]/Document[1]/@subtype"/></xsl:attribute>
            <xsl:attribute name="type">EDIT PRODUCT</xsl:attribute> 
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
						<MasterCatalog>
                            <RevisionID>
                                <BaseName>ITEM_MASTER</BaseName>
                                <Version/>
                                <DBID><xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionDetails/CatalogItem/MasterCatalog/RevisionID[BaseName='ITEM_MASTER']/DBID/text()"/></DBID>
                            </RevisionID>
                        </MasterCatalog>
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
                        
                    </CatalogActionHeader>
                    <CatalogActionDetails>
                        <xsl:call-template name="writeCatalogItem">
                           <xsl:with-param name="replacedGTIN" select="$Xsl_Param_ReplacedGTIN"></xsl:with-param>
                            <xsl:with-param name="lineNumber">1</xsl:with-param>
                        </xsl:call-template>
                       
		</CatalogActionDetails>
	</CatalogAction>
</BusinessDocument>
<OriginalDocument/>
</Document>
</Body>
</Message>
   </xsl:template>
    
    <xsl:template name="writeCatalogItem">
        <xsl:param name="replacedGTIN"></xsl:param>
        <xsl:param name="lineNumber"></xsl:param>
        
        <xsl:variable name="gtin" select="$replacedGTIN"></xsl:variable>
        
        <xsl:choose>
            <xsl:when test="translate($gtin,' ','')!=''">
                <CatalogItem>
                    <LineNumber><xsl:value-of select="$lineNumber"/></LineNumber>
                    <PartNumber>
                        <GlobalPartNumber>
                            <ProdID>
                                <IDNumber><xsl:value-of select="$gtin"/></IDNumber>
                                <IDExtension/>
                                <Agency>
                                    <Code>
                                        <CodeType>Agency</CodeType>
                                        <Normal>SOURCE</Normal>
                                    </Code>
                                </Agency>
                                <ExternalKey>
                                    <Attribute name="PRODUCTID">
                                        <Value><xsl:value-of select="$gtin"/></Value>
                                    </Attribute>
                                    <Attribute name="PRODUCTIDEXT">
                                        <Value/>
                                    </Attribute>
                                </ExternalKey>
                                <OriginalIDVersion></OriginalIDVersion>
                                <IDVersion></IDVersion>
                                <DBID><xsl:value-of select="$Xsl_Param_ROOT_PKID"/></DBID>
                            </ProdID>
                        </GlobalPartNumber>
                    </PartNumber>
                    <MasterCatalog>
                        <RevisionID>
                            <BaseName>ITEM_MASTER</BaseName>
                            <Version/>
							<DBID><xsl:value-of select="/Message/Body/Document/BusinessDocument/CatalogAction/CatalogActionDetails/CatalogItem/MasterCatalog/RevisionID[BaseName='ITEM_MASTER']/DBID/text()"/></DBID>
						</RevisionID>                        
                    </MasterCatalog>
                    <Contact/>
                    <Reference/>
                    <URL/>
                    <Extension/>
                    <ItemData/>
                    <ActionLog/>
                </CatalogItem>
                
            </xsl:when>            
        </xsl:choose>
    </xsl:template>

	 <xsl:template match="/Message/Body[1]/Document[1]">
        <xsl:element name="Document">
            <xsl:attribute name="type">EDIT PRODUCT</xsl:attribute>
            <xsl:attribute name="subtype"><xsl:value-of select="@subtype"/></xsl:attribute>
           <xsl:copy-of select="BusinessDocument"/>
        </xsl:element>
    </xsl:template>
	
	
	
	</xsl:stylesheet>
