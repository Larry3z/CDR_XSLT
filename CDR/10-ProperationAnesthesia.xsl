<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Diagnosis.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/LaboratoryExamination.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/PhysicalExamination.xsl"/>
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
			<!--作者，保管机构-->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!--次要参与者签名 Authenticator-->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
			<!-- 病床号、病房、病区、科室和医院的关联 -->
			<componentOf>
				<xsl:apply-templates select="Encounter" mode="Hosipitalization1"/>
			</componentOf>
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
					<xsl:comment>术前诊断章节</xsl:comment>
					<xsl:apply-templates select="Diagnoses" mode="D1"/>
					<component>
						<section>
							<xsl:comment>术前诊断条目1..1R</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>术前合并疾病中用药0..*R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
						</section>
					</component>
					<xsl:comment>现病史章节</xsl:comment>
					<xsl:apply-templates select="Diagnoses" mode="Complaint"/>
					<xsl:comment>既往史章节</xsl:comment>
					<xsl:apply-templates select="Diagnoses" mode="Problem"/>
					<xsl:comment>体格检查</xsl:comment>
					<xsl:apply-templates select="Sections/Section/PhysicalExamination" mode="PhyE2"/>
					<component>
						<section>
							<xsl:comment>体重0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>一般状况检查结果0..*R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>精神状态正常标志0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>心脏听诊结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>肺部听诊结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>四肢检查结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>术前用药0..*R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>脊柱检查结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>术前用药0..*R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>肺部检查结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>气管检查结果0..*R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>牙齿检查结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
						</section>
					</component>
					<xsl:comment>实验室检查章节</xsl:comment>
					<xsl:apply-templates select="LaboratoryExamination" mode="LabE3"/>
					<component>
						<section>
							<xsl:comment>血型1..1R</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>心电图检查结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>胸部X线检查结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>CT检查结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>B超检查结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>MRI检擦结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>肺功能检查结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>血常规检查结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>凝血功能检查结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
com				<xsl:comment>肝功能检查结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>血气分析检查结果0..1R2</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
						</section>
					</component>:

				
				<xsl:comment>治疗计划章节</xsl:comment>
					<xsl:apply-templates select="Diagnoses" mode="a"/>
					<component>
						<section>
							<xsl:comment>拟实施手术及操作编码1..*R</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
							<xsl:comment>拟实施手术麻醉方法代码1..*R</xsl:comment>
							<xsl:apply-templates select="Diagnoses" mode="a"/>
						</section>
					</component>:


	
				
			</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
