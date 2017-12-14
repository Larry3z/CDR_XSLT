<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Diagnosis.xsl"/>
	<!--xsl:include href="CDA-Support-Files/Export/Section-Modules/Encounter.xsl"/-->
	<xsl:template match="/Document">
		<ClinicalDocument xmlns:mif="urn:hl7-org:v3/mif" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:hl7-org:v3">
			<xsl:apply-templates select="." mode="CDAHeader"/>
			<xsl:comment>病人信息</xsl:comment>
			<!--文档记录对象（患者） [1..*] contextControlCode="OP"表示本信息可以被重载-->
			<recordTarget contextControlCode="OP" typeCode="RCT">
				<patientRole classCode="PAT">
					<!-- 门诊号 -->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<!-- 住院号标识 -->
					<xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/>
					<!--患者信息 -->
					<patient classCode="PSN" determinerCode="INSTANCE">
						<!--患者身份证号-->
						<xsl:apply-templates select="Encounter/Patient" mode="IDNo"/>
						<!--患者姓名-->
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<!--患者性别-->
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<!--患者出生日期-->
						<xsl:apply-templates select="Encounter/Patient" mode="BirthTime"/>
						<!--患者年龄-->
						<xsl:apply-templates select="Encounter/Patient" mode="Age"/>
					</patient>
				</patientRole>
			</recordTarget>
			<!-- 作者 -->
			<xsl:apply-templates select="Author" mode="Author1"/>			 
			<!-- 保管机构 -->
			<xsl:apply-templates select="Custodian" mode="Custodian"/>	
			<!--麻醉医师签名 DE02.01.039.00 -->
			<legalAuthenticator typeCode="LA">
				<!-- DE09.00.053.00麻醉医师签名日期时间 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--签名 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</legalAuthenticator>
			<!-- 患者签名 -->
			<authenticator>
				<!-- DE09.00.053.00签名日期时间 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--签名 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<!--代理人签名-->
			<authenticator>
				<!-- DE09.00.053.00签名日期时间 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--代理人关系-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--签名 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
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
			<!--
**************************************************
文档体
**************************************************
-->
			<component>
				<structuredBody>
					<!--术前诊断章节:术前诊断代码 1..1 R-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<!--治疗计划章节:拟实施麻醉条目 1..1 R-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<!--意见章节1..1 R-->
					<xsl:comment>意见章节</xsl:comment>
					<component>
						<section>
							<!--医疗机构意见 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--患者意见 1..1 O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							
						</section>
					</component>
					<!--风险章节 1..1 R-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
