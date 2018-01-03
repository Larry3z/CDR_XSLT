<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/AssistantExamination.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/PhysicalExamination.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Diagnosis.xsl"/>
	<!--xsl:include href="CDA-Support-Files/Export/Section-Modules/Encounter.xsl"/-->
	<xsl:template match="/Document">
		<ClinicalDocument xmlns:mif="urn:hl7-org:v3/mif" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:hl7-org:v3">
			<xsl:apply-templates select="." mode="CDAHeader"/>
			
			<xsl:comment>病人信息</xsl:comment>
			<recordTarget typeCode="RCT" contextControlCode="OP">
				<patientRole classCode="PAT">
					<!-- 住院号标识 -->
					<xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/>
					<!-- 现住址  门牌号、村、乡、县、市、省、邮政编码、联系电话-->
					<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
					<patient classCode="PSN" determinerCode="INSTANCE">
						<!--患者身份证号-->
						<xsl:apply-templates select="Encounter/Patient" mode="IDNo"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<xsl:apply-templates select="Encounter/Patient" mode="BirthTime"/>
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"  婚姻状况代码     /-->
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"   民族代码/-->
						<!-- 年龄 -->
						<!--xsl:apply-templates select="Encounter/Patient" mode="Age"/-->
						<!--职业状况-->
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
					</patient>
				</patientRole>
			</recordTarget>
			
			<!--以下省略很多机构签名等等 -->
			<relatedDocument typeCode="RPLC">
				<!--文档中医疗卫生事件的就诊场景,即入院场景记录-->
				<parentDocument>
					<id/>
					<setId/>
					<versionNumber/>
				</parentDocument>
			</relatedDocument>
			<!-- 病床号、病房、病区、科室和医院的关联 -->
			
			<!--文档体-->
			<component>
				<structuredBody>
					<!--主诉章节-->
					<xsl:apply-templates select="Patient" mode="Blood"/>
					<!--现病史章节-->
					<xsl:apply-templates select="Patient" mode="Blood"/>
					<!--既往史章节-->
					<xsl:comment>既往史章节</xsl:comment>
					<component>
						<section>
							<!--一般健康状况标志 0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--患者传染病标志 1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--婚育史 0..* R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--过敏史 0..* R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--手术史 0..* R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
						</section>
					</component>
					<!--预防接种史章节-->
					<xsl:apply-templates select="Patient" mode="Blood"/>
					<!--输血章节-->
					<xsl:apply-templates select="Patient" mode="Blood"/>
					<!--个人史章节-->
					<xsl:apply-templates select="Patient" mode="Blood"/>
					<!--月经史史章节-->
					<xsl:apply-templates select="Patient" mode="Blood"/>
					<!--家族史章节-->
					<xsl:apply-templates select="Patient" mode="Blood"/>
					<!--生命体征章节-->
					<xsl:comment>生命体征章节</xsl:comment>
					<component>
						<section>
							<!--体温  1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--脉率  1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--呼吸频率  1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--血压  1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--身高  0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--体重  0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
						</section>
					</component>
					<!--体格检查章节-->
					<xsl:comment>体格检查章节</xsl:comment>
					<xsl:apply-templates select="Sections/Section/PhysicalExamination" mode="PhyE3"/>
					<!--辅助检查章节-->
					<xsl:apply-templates select="Encounter/Orders/RadOrder/Results/Result/ResultItems/Observation/Comments" mode="AssE"/>
					<!--主要健康问题章节-->
					<xsl:comment>主要健康问题章节</xsl:comment>
					<component>
						<section>
							<!--陈述内容可靠标志 1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--初步诊断-西医   1..1  R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--中医“四诊”观察结果   0..1  O-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--初步诊断-中医   0..1  O-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--修正诊断-西医   0..1  R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--修正诊断-中医   0..1  R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--确定诊断-西医   1..*  R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--确定诊断-西医   1..*  O-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--补充诊断-西医   0..1  R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
						</section>
					</component>
					<!--治疗计划章节-->
					<xsl:apply-templates select="Patient" mode="Blood"/>
				</structuredBody>
			</component>
			
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
