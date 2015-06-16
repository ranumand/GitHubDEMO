<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:format="com.martquest.util.XSLTFormatter" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:os="http://www.1sync.org" xmlns:java="http://xml.apache.org/xslt/java" xmlns:uuid="com.martquest.util.UUIDGen" xmlns:timezone="java.util.TimeZone" xmlns:alist="java.util.ArrayList" extension-element-prefixes="format alist" exclude-result-prefixes="java alist">
	<xsl:output method="xml" indent="yes" />
	<xsl:param name="Xsl_Param_DelItemMasterID"/>
	<xsl:param name="Xsl_Param_delproductIDs"/>
	<xsl:variable name="Hinfo" select="//hierarchyInformation/publishedGTIN"/>
	<xsl:template match="/">
		<OriginalDocument>
			<xsl:copy-of select="//os:envelope"/>
			<xsl:variable name="operation" select="//hierarchyInformation/operation"/>
			<xsl:variable name="string_Delimited">a  b</xsl:variable>				
			<xsl:if test="$operation = 'DELETE'">
				<DELETEITEMS>									
					<xsl:call-template name="parseString">
						<xsl:with-param name="list" select="$Xsl_Param_DelItemMasterID"/>						
						<xsl:with-param name="productID" select="$Xsl_Param_delproductIDs"/>
					</xsl:call-template>
				</DELETEITEMS>
			</xsl:if>
		</OriginalDocument>
	</xsl:template>

	<xsl:template name="parseString">
		<xsl:param name="list"/>
		<xsl:param name="productID"/>
		<xsl:if test="contains($list, ' ')">
			<xsl:variable name="id" select="substring-before($list, ' ')"/>
			<xsl:choose>
				<xsl:when test="$productID !='dummy' ">
					<!--productid is not null -->
					<xsl:choose>
						<xsl:when test='$Hinfo = $id'>
							<xsl:if test="contains($productID,$id)">
								<PRODUCTID>
									<xsl:value-of select="$id"/>
								</PRODUCTID>
								<PUBLISHED_GTIN_FLG>
									<xsl:text>FALSE</xsl:text>
								</PUBLISHED_GTIN_FLG>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<PRODUCTID>
								<xsl:value-of select="$id"/>
							</PRODUCTID>
							<PUBLISHED_GTIN_FLG>
								<xsl:text>FALSE</xsl:text>
							</PUBLISHED_GTIN_FLG>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!--productid is  null -->
					<!--<xsl:if test='$Hinfo != $id'>-->	
					<PRODUCTID>
						<xsl:value-of select="$id"/>
					</PRODUCTID>
					<PUBLISHED_GTIN_FLG>
						<xsl:text>FALSE</xsl:text>
					</PUBLISHED_GTIN_FLG>
					<!--</xsl:if>-->
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="parseString">
				<xsl:with-param name="list" select="substring-after($list, ' ')"/>
				<xsl:with-param name="productID" select="$productID"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="not(contains($list, ' '))">
			<xsl:choose>
				<xsl:when test="$productID !='dummy' ">
					<!--productid is not null -->	
					<xsl:choose>
						<xsl:when test='$Hinfo = $list'>	
							<xsl:if test="contains($productID,$list)">
								<PRODUCTID>
									<xsl:value-of select="$list"/>
								</PRODUCTID>
								<PUBLISHED_GTIN_FLG>
									<xsl:text>FALSE</xsl:text>
								</PUBLISHED_GTIN_FLG>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<PRODUCTID>
								<xsl:value-of select="$list"/>
							</PRODUCTID>
							<PUBLISHED_GTIN_FLG>
								<xsl:text>FALSE</xsl:text>
							</PUBLISHED_GTIN_FLG>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!--productid is  null -->
					<!--<xsl:if test='$Hinfo != $list'>	-->
					<PRODUCTID>
						<xsl:value-of select="$list"/>
					</PRODUCTID>
					<PUBLISHED_GTIN_FLG>
						<xsl:text>FALSE</xsl:text>
					</PUBLISHED_GTIN_FLG>
					<!--</xsl:if>-->
				</xsl:otherwise>
			</xsl:choose>						
		</xsl:if>		
	</xsl:template>
</xsl:stylesheet>
