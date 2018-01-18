<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<!--xsl:include href="CDA-Support-Files/Export/Section-Modules/Encounter.xsl"/-->
	<xsl:template match="/Document">
		<ClinicalDocument xmlns:mif="urn:hl7-org:v3/mif" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:hl7-org:v3">
			<xsl:apply-templates select="." mode="CDAHeader"/>
			<xsl:comment>病人信息</xsl:comment>
			<recordTarget contextControlCode="OP" typeCode="RCT">
				<patientRole classCode="PAT">
					<!-- 住院号标识 -->
					<xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/>
					<patient classCode="PSN" determinerCode="INSTANCE">
						<!--患者身份证号-->
						<xsl:apply-templates select="Encounter/Patient" mode="IDNo"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<!--xsl:apply-templates select="Encounter/Patient" mode="BirthTime"/-->
						<xsl:apply-templates select="Encounter/Patient" mode="Age"/>
					</patient>
				</patientRole>
			</recordTarget>
			<!--作者，保管机构1..1-->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!-- 签名 1..1 -->
			<authenticator>
				<!--签名日期时间 1..1-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--医生签名 1..1-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--职务类别代码 1..1 +displayName 1..1-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<!--文档中医疗卫生事件的就诊场景,即入院场景记录 1..1R-->
			<componentOf>
				<encompassingEncounter>
					<!--入院时间 1..1-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<location>
						<healthCareFacility>
							<serviceProviderOrganization>
								<asOrganizationPartOf classCode="PART">
									<!-- DE01.00.026.00病床号 1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
									<!-- DE01.00.019.00病房号1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
									<!-- DE08.10.026.00科室名称 1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
									<!-- DE08.10.054.00病区名称 1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
									<!--医疗机构名称 1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
								</asOrganizationPartOf>
							</serviceProviderOrganization>
						</healthCareFacility>
					</location>
				</encompassingEncounter>
			</componentOf>
			<!--文档体-->
			<component>
		<structuredBody>
			<!--
*****************************
诊断章节
*****************************
-->
			<component>
				<section>
					<code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="疾病诊断编码"/>
							<value xsi:type="CD"  code="B95.100" displayName="B族链球菌感染"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--
*****************************
高值耗材章节
*****************************
-->
			<!--高值耗材章节（同用药章节） -->
			<component>
				<section>
					<code code="10160-0" codeSystem="2.16.840.1.113883.6.1" displayName="HISTORY
OF MEDICATION USE" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<substanceAdministration classCode="SBADM" moodCode="EVN">
							<text/>
							<!--使用途径：DE06.00.242.00-->
							<routeCode nullFlavor="OTH">
								<originalText><xsl:value-of select="/Document/expensive/useRoad"/></originalText>
							</routeCode>
							<!--耗材数量DE06.00.241.00、耗材单位DE08.50.034.00 -->
							<doseQuantity value="{/Document/expensive/doseQuantity}" unit="mg"/>
							<consumable>
								<manufacturedProduct>
									<!--产品编码-->
									<id/>
									<manufacturedMaterial>
										<!--材料名称 -->
										<code/>
										<name><xsl:value-of select="/Document/expensive/materialName"/></name>
									</manufacturedMaterial>
									<manufacturerOrganization>
										<name><xsl:value-of select="/Document/expensive/manufacturerName"/></name>
										<asOrganizationPartOf>
											<wholeOrganization>
												<name><xsl:value-of select="/Document/expensive/supplierName"/></name>
											</wholeOrganization>
										</asOrganizationPartOf>
									</manufacturerOrganization>
								</manufacturedProduct>
							</consumable>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE08.50.035.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产品供应商"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/expensive/supplierName"/></value>
								</observation>
							</entryRelationship>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE08.50.058.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="植入性耗材标志"/>
									<!-- 植入性耗材标志：DE08.50.058.00 -->
									<value xsi:type="BL" value="true"/>
								</observation>
							</entryRelationship>
						</substanceAdministration>
					</entry>
				</section>
			</component>
		</structuredBody>
	</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
