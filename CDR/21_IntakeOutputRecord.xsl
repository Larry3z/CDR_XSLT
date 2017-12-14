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
			<!--作者，文档生成机构-->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!--签名 Authenticator-->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
			<!--关联活动信息 1..R-->
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
			<xsl:apply-templates select="Encounter" mode="Hosipitalization1"/>
			<!--文档体-->
			<component>
				<structuredBody>
					<!--1..1R--><!--诊断记录章节-->
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
					<!--1..1R--><!--生命体征章节-->
				    <xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
				    <!--1..1R--><!--护理记录章节-->
				    <xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
				    <component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--1..1R--><!--护理等级-->
							<xsl:apply-templates select="Sections/Section[SectionCode='DE05.01.025.00']" mode="TreatmentPlanEntry"/>
							<!--1..1R--><!--护理类型-->
							<xsl:apply-templates select="Sections/Section[SectionCode='DE06.00.300.00']" mode="TreatmentPlanEntry"/>
						</section>
					</component>
				    <!--1..1R--><!--护理观察章节-->
				    <xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
				    <component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--1..*R--><!--护理观察项目名称-->
							<xsl:apply-templates select="Sections/Section[SectionCode='DE05.01.025.00']" mode="TreatmentPlanEntry"/>
							<!--1..*R--><!--护理观察结果描述-->
							<xsl:apply-templates select="Sections/Section[SectionCode='DE06.00.300.00']" mode="TreatmentPlanEntry"/>
						</section>
					</component>
				    <!--1..1R--><!--护理操作章节-->
				    <xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
				    <!--0..1R2--><!--用药章节-->
				    <xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
				    <!--1..1R--><!--护理标志章节-->
				    <xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
				    <component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--1..1R--><!--呕吐标志-->
							<xsl:apply-templates select="Sections/Section[SectionCode='DE05.01.025.00']" mode="TreatmentPlanEntry"/>
							<!--1..1R--><!--排尿困难标志-->
							<xsl:apply-templates select="Sections/Section[SectionCode='DE06.00.300.00']" mode="TreatmentPlanEntry"/>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
