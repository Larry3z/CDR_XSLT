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
			<!-- 主任医师签名 1..1 -->
			<authenticator>
				<!-- 签名时间 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!-- 签名 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<!-- 主治医师签名 1..1 -->
			<authenticator>
				<!-- 签名时间 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!-- 签名 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<!-- 住院医师签名 1..1 -->
			<authenticator>
				<!-- 签名时间 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!-- 签名 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
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
					<!--主要健康问题章节：入院情况 1..1 R-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<!--入院诊断章节1..1 R-->
					<xsl:comment>入院诊断章节</xsl:comment>
					<component>
						<section>
							
							<!--入院诊断编码 1..* R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--入院日期时间 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--阳性辅助检查结果 0..* R2 -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--中医“四诊”观察结果 0..1 O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--治则治法 0..1 O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
					<!--住院过程章节：诊疗过程描述 1..1 R-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<!--医嘱（用药）章节1..1 R-->
					<xsl:comment>医嘱章节</xsl:comment>
					<component>
						<section>
							<!--中药煎煮方法 0..1 O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--中药用药方法 0..1 O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
					<!--出院诊断章节1..1 R-->
					<xsl:comment>出院诊断章节</xsl:comment>
					<component>
						<section>
							<!--出院情况 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--出院日期时间 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--出院诊断-西医诊断名称 1..* R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--出院诊断-西医诊断编码 1..* R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--出院诊断-中医病名名称 0..* O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--出院诊断-中医病名代码 0..* O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--出院诊断-中医证候名称 0..1 O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--出院诊断-中医证候代码 0..1 O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--出院时症状与体征 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--出院医嘱 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
