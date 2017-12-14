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
			<!--文档审核者 该部分信息表达文档经过了一定的审核，但还没达到一定的法律效应 -->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
			<relatedDocument typeCode="RPLC">
				<!--文档中医疗卫生事件的就诊场景,即入院场景记录-->
				<parentDocument>
					<id/>
					<setId/>
					<versionNumber/>
				</parentDocument>
			</relatedDocument>
			<component>
		    <structuredBody>
			<!--出院诊断章节 1..1 R-->
			<xsl:comment>出院诊断章节</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<component>
				<section>
				<!--出院诊断编码 1..* R-->
				<xsl:comment>出院诊断编码</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--出院日期时间 1..1 R-->
                <xsl:comment>出院日期时间</xsl:comment>				
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--出院情况 1..1 R-->
                <xsl:comment>出院情况</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--离院方式 1..1 R-->
                <xsl:comment>离院方式</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>	
				</section>
			</component>
			<!--健康指导章节 1..1 R -->
			<xsl:comment>健康指导章节</xsl:comment>
            <xsl:apply-templates select="Sections/Section" mode="mode"/>
			<component>
				<section>
				<!--饮食指导 0..* R2-->
				<xsl:comment>饮食指导</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--生活方式指导 0..* R2-->
                <xsl:comment>生活方式指导</xsl:comment>				
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--宣教内容 0..* R2-->
                <xsl:comment>宣教内容</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--复诊指导 0..* R2-->
                <xsl:comment>复诊指导</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--用药指导 0..* R2-->
                <xsl:comment>用药指导</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>	
				</section>
			</component>
			<!--健康评估章节 1..1 R -->
			<xsl:comment>健康评估章节</xsl:comment>
            <xsl:apply-templates select="Sections/Section" mode="mode"/>
			<component>
				<section>
				<!--自理能力评估 0..1 R2-->
				<xsl:comment>自理能力评估</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--饮食情况评估 0..1 R2-->
                <xsl:comment>饮食情况评估</xsl:comment>				
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				</section>
			</component>
		</structuredBody>
	</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
