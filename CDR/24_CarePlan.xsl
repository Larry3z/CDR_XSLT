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
			<!-- 创作者信息 1..1-->
			<author typeCode="AUT" contextControlCode="OP">
				<!--填表日期 1..1  -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--访视医生姓名 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</author>
            <!-- 文档管理者信息 1..1 -->
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<!--文档审核者 该部分信息表达文档经过了一定的审核，但还没达到一定的法律效应 -->
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
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
			<!--主要健康问题章节 1..1 R-->
			<xsl:comment>主要健康问题章节</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<!--护理记录章节 1..1 R-->
			<xsl:comment>护理记录章节</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<component>
				<section>
				<!--护理等级 1..1 R-->
				<xsl:comment>护理等级</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--护理类型 1..1 R-->
				<xsl:comment>护理类型</xsl:comment>				
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--护理问题 1..1 R-->
				<xsl:comment>护理问题</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--护理操作名称 1..1 R-->
				<xsl:comment>护理操作名称</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--导管护理 1..1 R-->
				<xsl:comment>导管护理</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--体位护理 1..1 R-->
				<xsl:comment>体位护理</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--皮肤护理 1..1 R-->
				<xsl:comment>皮肤护理</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
                <!--气管护理 1..1 R-->
                <xsl:comment>气管护理</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--安全护理 1..1 R-->
				<xsl:comment>安全护理</xsl:comment>
				<xsl:apply-templates select="Sections/Section" mode="mode"/>	
				</section>
			</component>
			<!--健康指导章节 1..1 R-->
			<xsl:comment>健康指导章节</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
		</structuredBody>
	</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
