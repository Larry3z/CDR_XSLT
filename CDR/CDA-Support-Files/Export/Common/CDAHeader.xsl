<!-- This file contains templates regrading CDAHeader, Author, CreationTime-->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:template match="Document" mode="CDAHeader">
		<xsl:param name="documentTypeNumber"/>
		<xsl:param name="documentName"/>
		<!-- 头两行固定值， "CN" 代表中国 -->
		<realmCode code="CN"/>
		<typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/>
		<templateId root="{Type/TemplateID}"/>
		<code code="{Type/Code}" codeSystem="2.16.156.10011.2.4" codeSystemName="卫生信息共享文档规范编码体系"/>
		<title>
			<xsl:value-of select="Title"/>
		</title>
		<effectiveTime>
			<xsl:value-of select="CreationTime"/>
			<!--xsl:attribute name="value"><xsl:value-of select="format-dateTime(current-dateTime(), '[Y0001][M01][D01][H01][m01][s01]')"/></xsl:attribute-->
		</effectiveTime>
		<confidentialityCode code="N" codeSystem="2.16.840.1.113883.5.25" codeSystemName="Confidentiality" displayName="正常访问保密级别"/>
		<languageCode code="zh-CN"/>
		<setId/>
		<versionNumber/>
	</xsl:template>
	<!-- 文档创建者模板1-->
	<!-- DE09.00.053.00记录日期时间 完成此项业务活动时的公元纪年日期和时间的完整描述，暂时只用文档的生产时间，所以传入的是author,但要上一层去去CreationTime. -->
	<xsl:template match="Author" mode="Author1">
		<xsl:comment>文档作者</xsl:comment>
		<author typeCode="AUT" contextControlCode="OP">
			<time value="{../CreationTime}"/>
			<assignedAuthor classCode="ASSIGNED">
				<id root="2.16.156.10011.1.7" extension="{Id}"/>
				<assignedPerson>
					<name>
						<xsl:value-of select="Name"/>
					</name>
				</assignedPerson>
			</assignedAuthor>
		</author>
	</xsl:template>
	<!--保管机构模板-->
	<xsl:template match="*" mode="Custodian">
		<xsl:comment>保管机构</xsl:comment>
		<custodian typeCode="CST">
			<assignedCustodian classCode="ASSIGNED">
				<representedCustodianOrganization classCode="ORG" determinerCode="INSTANCE">
					<id root="2.16.156.10011.1.5" extension="{Organization/id}"/>
					<name>
						<xsl:value-of select="Organization/name"/>
					</name>
				</representedCustodianOrganization>
			</assignedCustodian>
		</custodian>
	</xsl:template>
	<!-- 法律责任参与者签名 -->
	<xsl:template match="*" mode="legalAuthenticator">
		<xsl:comment>法律责任参与者签名</xsl:comment>
		<legalAuthenticator>
			<!-- 签名 -->
			<time/>
			<signatureCode/>
			<assignedEntity>
				<id root="2.16.156.10011.1.4" extension="{identifier}"/>
				<code displayName="{PractitionerRole}"/>
				<assignedPerson classCode="PSN" determinerCode="INSTANCE">
					<name>
						<xsl:value-of select="Name"/>
					</name>
				</assignedPerson>
			</assignedEntity>
		</legalAuthenticator>
	</xsl:template>
	<!-- 其他参与者签名 -->
	<xsl:template match="*" mode="Authenticator">
		<xsl:comment>其他参与者签名</xsl:comment>
		<authenticator>
			<time/>
			<signatureCode/>
			<assignedEntity>
				<id root="2.16.156.10011.1.4" extension="{identifier}"/>
				<code displayName="{PractitionerRole}"/>
				<assignedPerson classCode="PSN" determinerCode="INSTANCE">
					<name>
						<xsl:value-of select="Name"/>
					</name>
				</assignedPerson>
			</assignedEntity>
		</authenticator>
	</xsl:template>
	<!--相关文档, 暂时不用-->
	<xsl:template name="relatedDocument">
		<xsl:comment>相关文档</xsl:comment>
		<relatedDocument typeCode="RPLC">
			<parentDocument>
				<id/>
				<setId/>
				<versionNumber/>
			</parentDocument>
		</relatedDocument>
	</xsl:template>
	
	
	
	<!--住院状况模板1-->
	<xsl:template match="*" mode="Hosipitalization1">
		<xsl:comment>相关文档</xsl:comment>
		<encompassingEncounter>
			<effectiveTime/>
			<location>
				<healthCareFacility>
					<serviceProviderOrganization>
						<asOrganizationPartOf classCode="PART">
							<!-- DE01.00.026.00病床号 -->
							<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
								<id root="2.16.156.10011.1.22" extension="{Hospitalization/Location/bed}"/>
								<!-- DE01.00.019.00病房号 -->
								<asOrganizationPartOf classCode="PART">
									<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
										<id root="2.16.156.10011.1.21" extension="{Hospitalization/Location/room}"/>
										<name>无</name>
										<!-- DE08.10.026.00科室名称 -->
										<asOrganizationPartOf classCode="PART">
											<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
												<id root="2.16.156.10011.1.26" extension="{AdmissionLocationNo}"/>
												<name><xsl:value-of select="AdmissionLocation"/></name>
												<!-- DE08.10.054.00病区名称 -->
												<asOrganizationPartOf classCode="PART">
													<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
														<id root="2.16.156.10011.1.27" extension="--"/>
														<name><xsl:value-of select="Hospitalization/Location/ward"/></name>
														<!--XX医院 -->
														<asOrganizationPartOf classCode="PART">
															<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
																<id root="2.16.156.10011.1.5" extension="--"/>
																<name><xsl:value-of select="HealthCareFacility"/></name>
															</wholeOrganization>
														</asOrganizationPartOf>
													</wholeOrganization>
												</asOrganizationPartOf>
											</wholeOrganization>
										</asOrganizationPartOf>
									</wholeOrganization>
								</asOrganizationPartOf>
							</wholeOrganization>
						</asOrganizationPartOf>
					</serviceProviderOrganization>
				</healthCareFacility>
			</location>
		</encompassingEncounter>
	</xsl:template>
	<!--reserved-->
	<xsl:template match="*" mode="Creator">
		<!--创建者-->
		<author typeCode="AUT" contextControlCode="OP">
			<!--建档日期时间1..1， 格式20120909112212-->
			<time ><xsl:value-of select="CreationTime"/></time>
			<assignedAuthor classCode="ASSIGNED">
				<id root="2.16.156.10011.1.7">
					<xsl:attribute name="id"><xsl:value-of select="ID"/></xsl:attribute>
				</id>
				<!--建档者姓名-->
				<assignedPerson>
					<name>
						<xsl:value-of select="Creator"/>
					</name>
				</assignedPerson>
				<!--建档机构-->
				<representedOrganization>
					<id root="2.16.156.10011.1.5" extension="1234567890"/>
					<name><xsl:value-of select="Encounter/HealthCareFacility"/></name>
				</representedOrganization>
			</assignedAuthor>
		</author>
	</xsl:template>
</xsl:stylesheet>
