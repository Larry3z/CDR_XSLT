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
					<!-- 住院号标识 -->
					<xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/>
					<!--电子申请单编号标识 1..1 -->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
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
			<!-- 文档创作者 -->
			<author typeCode="AUT" contextControlCode="OP">
				<!--文档创作时间 1..1  -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--制定创作者 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</author>
			<!-- 保管机构 1..1 -->
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<!-- 会诊申请相关 1..1-会诊申请医师 -->
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<!--会诊医师相关 1..1-->
			<authenticator>
				<!--会诊日期时间 1..1-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--会诊医师签名 1..1-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--会诊医师所在医疗机构名称-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<!--会诊申请医疗机构名称 1..1-->
			<authenticator>
				<!--申请会诊科室名称 1..1-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--申请会诊机构名称 1..1-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<!--会诊所在医疗机构名称 1..1-->
			<authenticator>
				<!--会诊科室名称 1..1-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--会诊所在机构名称 1..1-->
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
					<!--健康评估章节:病历概要 1..1 R-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<!--诊断记录章节1..1 R-->
					<xsl:comment>诊断记录章节</xsl:comment>
					<component>
						<section>
							<!--西医诊断 1..* R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--中医病名 1..* O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--中医证候 1..* O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--中医“四诊”观察结果 1..1 O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
					<!--辅助检查章节 0..1 R2-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<!--治疗计划章节1..1 R-->
					<xsl:comment>治疗计划章节</xsl:comment>
					<component>
						<section>
							<!--诊疗过程名称条目 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--治则治法 0..1 O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--会诊目的 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
					<!--会诊原因章节1..1 R-->
					<xsl:comment>会诊原因章节</xsl:comment>
					<component>
						<section>
							<!--会诊类型条目 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--会诊原因 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
					<!--会诊意见章节 1..1 R-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<!--住院过程章节 1..1 R-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
