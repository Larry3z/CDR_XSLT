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
					<!-- 住院号 -->
					<xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/>
					<!--患者信息 -->
					<patient classCode="PSN" determinerCode="INSTANCE">
						<!--患者身份证号-->
						<xsl:apply-templates select="Encounter/Patient" mode="IDNo"/>
						<!--患者姓名-->
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<!--患者性别-->
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<!--患者年龄-->
						<xsl:apply-templates select="Encounter/Patient" mode="Age"/>
					</patient>
					<!--讨论的日期时间-->
					<providerOrganization classCode="ORG" determinerCode="INSTANCE">
						<asOrganizationPartOf classCode="PART">
							<!--讨论时间 -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--讨论地点 -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</asOrganizationPartOf>
					</providerOrganization>
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
			<!-- 签名 1..1 -->
			<authenticator>
				<!-- 手术者签名:DE09.00.053.00签名、日期时间 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!-- 麻醉医师签名:DE09.00.053.00签名、日期时间 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!-- 医师签名：DE09.00.053.00签名、日期时间 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<!--讨论成员信息 1..* :参加讨论成员名单-->
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<!--讨论主持人信息 1..1 :主持人姓名-->
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<!--病床号、病房、病区、科室和医院的关联 1..R-->
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
					<!--术前诊断章节0..1 R2-->
					<xsl:comment>术前诊断章节</xsl:comment>
					<component>
						<section>
							<!--术前诊断编码 0..* R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--入院日期时间 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
					<!--治疗计划章节1..1 R-->
					<xsl:comment>治疗计划章节</xsl:comment>
					<component>
						<section>
							<!--拟实施手术及操作名称 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--拟实施手术及操作编码 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--拟实施手术目标部位名称 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--拟实施手术及操作日期时间 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--拟实施麻醉方法代码 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
					<!--手术操作章节1..1 R-->
					<xsl:comment>手术操作章节</xsl:comment>
					<component>
						<section>
							<!--手术要点 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--术前准备 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--手术指征 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--手术方案 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--注意事项 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
					<!--术前总结章节1..1 R-->
					<xsl:comment>术前总结章节</xsl:comment>
					<component>
						<section>
							<!--讨论意见 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--讨论总结 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
