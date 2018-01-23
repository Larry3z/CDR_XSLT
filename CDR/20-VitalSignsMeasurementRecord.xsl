<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader1.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/Body.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<!--xsl:include href="CDA-Support-Files/Export/Entry-Modules/LaboratoryExamination.xsl"/-->
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Diagnosis.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Medication.xsl"/>
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
			<!-- 文档作者 -->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<!-- 文档生成机构 -->
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!-- 护士签名 -->
			<xsl:comment>护士签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='护士']" mode="Authenticator"/>
			<xsl:apply-templates select="serviceEvent" mode="serviceEvent"/>
			<!--相关文档，暂时不用-->
			<xsl:call-template name="relatedDocument"/>
			<!--文档中医疗卫生事件的就诊场景,即入院场景记录-->
			<componentOf>
				<xsl:apply-templates select="Encounter" mode="Hosipitalization1"/>
			</componentOf>
			<!--文档体-->
			<component>
				<structuredBody>
					<!--诊断记录章节 1..1 R-->
					<xsl:comment>诊断记录章节 1..1 R</xsl:comment>
					<component>
						<section>
							<code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<xsl:apply-templates select="Diagnoses/Diagnosis[DiagnosisType='诊断编码']" mode="Diagnosis"/>
						</section>
					</component>
					<!--生命体征章节-->
					<xsl:comment>生命体征章节</xsl:comment>
					<component>
						<section>
							<code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="VITAL SIGNS"/>
							<text/>
							<!--呼吸频率条目 1..1 R-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign4"/>
							<!--脉率条目 1..1 R-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign3"/>
							<!--起搏器心率条目 1..1 R-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign7"/>
							<!--体温条目 1..1 R-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign2"/>
							<!--血压条目 1..1 R-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign6"/>
							<!--体重条目 1..1 R-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign1"/>
							<!--腹围条目 1..1 R-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign8"/>
						</section>
					</component>
					<!--护理观察章节-->
					<xsl:comment>护理观察章节</xsl:comment>
					<component>
						<section>
							<code displayName="护理观察"/>
							<text/>
							<!--多个观察写多个entry即可，每个观察对应着观察结果描述-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
									<text/>
									<!--护理观察项目名称条目 1..* R-->
									<xsl:apply-templates select="NursingObservation" mode="Nur1"/>
									<!--护理观察结果描述条目 1..* R-->
									<xsl:apply-templates select="NursingObservation" mode="Nur2"/>
								</observation>
							</entry>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
