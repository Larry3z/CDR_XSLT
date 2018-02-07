<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader1.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/Body.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
<<<<<<< HEAD
	<!--xsl:include href="CDA-Support-Files/Export/Entry-Modules/LaboratoryExamination.xsl"/-->
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Diagnosis.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Medication.xsl"/>
=======
	<!--xsl:include href="CDA-Support-Files/Export/Section-Modules/Diagnosis.xsl"/-->
>>>>>>> 12a402f3817ecedeefc4f4e4cf3a5f471691e749
	<xsl:template match="/Document">
		<ClinicalDocument xmlns:mif="urn:hl7-org:v3/mif" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:hl7-org:v3">
			<xsl:apply-templates select="." mode="CDAHeader"/>
			<xsl:comment>病人信息</xsl:comment>
			<recordTarget contextControlCode="OP" typeCode="RCT">
				<patientRole classCode="PAT">
					<!--门诊号标识-->
					<xsl:comment>门诊号标识</xsl:comment>
					<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
					<id root="{PatientNo/Root}" extension="{PatientNo/Extension}"/>
					<!--电子申请单编号-->
					<xsl:comment>电子申请单编号</xsl:comment>
					<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
					<id root="{Number/Root}" extension="{Number/Extension}"/>
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
			<!-- 文档创作者 -->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<!-- 保管机构 -->
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!--麻醉师签名 -->
			<xsl:comment>麻醉师签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='麻醉医师']" mode="Authenticator"/>
			<!--相关文档，暂时不用-->
			<xsl:call-template name="relatedDocument"/>
			<!-- 病床号、病房、病区、科室和医院的关联 -->
			<componentOf>
				<xsl:apply-templates select="Encounter" mode="Hosipitalization1"/>
			</componentOf>
			<!--文档体-->
			<component>
				<structuredBody>
<<<<<<< HEAD
					<xsl:comment>实验室检查</xsl:comment>
					<!--实验室检查章节-->
					<component>
						<section>
							<code code="30954-2" displayName="STUDIES SUMMARY" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<xsl:apply-templates select="Encounter/Patient/Blood" mode="LabE1"/>
						</section>
					</component>
=======
					<!--实验室检查章节-->
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
>>>>>>> 12a402f3817ecedeefc4f4e4cf3a5f471691e749
					<!--术前诊断章节-->
					<xsl:comment>术前诊断章节</xsl:comment>
					<component>
						<section>
							<code code="10219-4" displayName="Surgical operation note preoperative Dx" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<xsl:apply-templates select="Diagnoses/Diagnosis[DiagnosisType='术前诊断']" mode="DiagnosisEntry1"/>
						</section>
					</component>
					<!--术后诊断章节-->
					<xsl:comment>术后诊断章节</xsl:comment>
					<component>
						<section>
							<code code="10218-6" displayName="Surgical operation note postoperative Dx" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<xsl:apply-templates select="Diagnoses/Diagnosis[DiagnosisType='术后诊断']" mode="DiagnosisEntry1"/>
						</section>
					</component>
					<!--用药管理章节-->
					<xsl:comment>用药管理章节</xsl:comment>
					<component>
						<section>
							<code code="18610-6" displayName="MEDICATION ADMINISTERED" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<xsl:apply-templates select="Encounter/Orders/Medication" mode="MedicationEntry"/>
						</section>
					</component>
					<!--输液章节-->
					<xsl:comment>输液章节</xsl:comment>
					<xsl:apply-templates select="Transfusion" mode="Trans24"/>
					<!--输血章节-->
					<component>
						<section>
							<code code="56836-0" codeSystem="2.16.840.1.113883.6.1" displayName="History of blood transfusion" codeSystemName="LOINC"/>
							<text/>
							<xsl:comment>输血章节</xsl:comment>
							<xsl:apply-templates select="Metachysis" mode="Metachysis"/>
						</section>
					</component>
					<!--麻醉章节-->
					<xsl:comment>麻醉章节</xsl:comment>
					<xsl:apply-templates select="Anaesthesia" mode="Anaesthesia"/>
					<!--主要健康问题章节-->
					<xsl:comment>主要健康问题章节</xsl:comment>
					<component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<xsl:apply-templates select="HealthProblem" mode="HealthProblem"/>
							<!--常规监测项目条目 1..* R-->
							<!--xsl:apply-templates select="Sections/Section[SectionCode='DE05.01.025.00']" mode="TreatmentPlanEntry"/-->
							<!--特殊监测项目条目 0..* R2-->
							<!--xsl:apply-templates select="Sections/Section[SectionCode='DE06.00.300.00']" mode="TreatmentPlanEntry"/-->
						</section>
					</component>
					<!--生命体征章节-->
					<xsl:comment>生命体征章节</xsl:comment>
					<component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<!--体重条目 0..1 R2-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign1"/>
							<!--体温条目 1..* R-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign2"/>
							<!--脉率条目 0..1 R2-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign3"/>
							<!--呼吸频率条目 1..* R-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign4"/>
							<!--心率条目 1..* R-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign5"/>
							<!--血压条目 1..* R-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign6"/>
						</section>
					</component>
					<!--手术操作章节-->
					<xsl:comment>手术操作章节</xsl:comment>
					<xsl:apply-templates select="OP" mode="OP"/>
					<!--失血章节-->
					<xsl:comment>失血章节</xsl:comment>
					<xsl:apply-templates select="Hemorrhage" mode="Hemorrhage"/>
					<!--术后去向章节-->
					<xsl:comment>术后去向章节</xsl:comment>
					<xsl:apply-templates select="Postoperative" mode="Postoperative"/>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
