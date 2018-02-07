<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader1.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/Body.xsl"/>
	<!--xsl:include href="CDA-Support-Files/Export/Common/Histories1.xsl"/-->
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
	<!--xsl:include href="CDA-Support-Files/Export/Section-Modules/Encounter.xsl"/-->
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
			<!--巡台护士签名-->
			<xsl:comment>巡台护士签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='巡台护士']" mode="Authenticator"/>
			<!--器械护士签名-->
			<xsl:comment>器械护士签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='器械护士']" mode="Authenticator"/>
			<!--交接护士签名-->
			<xsl:comment>交接护士签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='交接护士']" mode="Authenticator"/>
			<!--转运者签名-->
			<xsl:comment>转运者签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='转运者']" mode="Authenticator"/>
			<!--相关文档，暂时不用-->
			<xsl:call-template name="relatedDocument"/>
			<!-- 病床号、病房、病区、科室和医院的关联 -->
			<componentOf>
				<xsl:apply-templates select="Encounter" mode="Hosipitalization1"/>
			</componentOf>
			<!--文档体-->
			<component>
				<structuredBody>
					<!--术前诊断章节-->
					<xsl:comment>术前诊断章节</xsl:comment>
					<component>
						<section>
							<code code="10219-4" displayName="Surgical operation note preoperative Dx" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<xsl:apply-templates select="Diagnoses/Diagnosis[DiagnosisType='术前诊断']" mode="DiagnosisEntry1"/>
						</section>
					</component>
					<!--生命体征章节-->
					<xsl:comment>生命体征章节</xsl:comment>
					<component>
						<section>
							<code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="VITAL SIGNS"/>
							<text/>
							<xsl:apply-templates select="VitalSign" mode="VitalSign1"/>
						</section>
					</component>
					<!--实验室检查章节-->
<<<<<<< HEAD
					<xsl:comment>实验室检查章节</xsl:comment>
					<component>
						<section>
							<code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="STUDIES SUMMARY"/>
							<text/>
							<xsl:apply-templates select="Encounter/Patient/Blood" mode="LabE2"/>
						</section>
					</component>
=======
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
>>>>>>> 12a402f3817ecedeefc4f4e4cf3a5f471691e749
					<!--皮肤章节-->
					<xsl:comment>皮肤章节</xsl:comment>
					<component>
						<section>
							<code code="29302-7" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="INTEGUMENTARY SYSTEM"/>
							<text/>
							<xsl:apply-templates select="Skin" mode="Skin1"/>
						</section>
					</component>
					<!--过敏史章节-->
					<xsl:comment>过敏史章节</xsl:comment>
					<xsl:apply-templates select="Encounter/Patient/Allergies/Allergy" mode="Allergy"/>
					<!--护理记录章节-->
					<xsl:comment>护理记录章节</xsl:comment>
					<component>
						<section>
							<code displayName="护理记录"/>
							<text/>
							<!--护理等级条目 1..1 R-->
							<xsl:apply-templates select="NursingRecords" mode="NurR1"/>
							<!--护理类型条目 1..1 R-->
							<xsl:apply-templates select="NursingRecords" mode="NurR2"/>
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
									<!--护理观察项目名称条目 1..* R-->
									<xsl:apply-templates select="NursingObservation" mode="Nur1"/>
									<!--护理观察结果描述条目 1..* R-->
									<xsl:apply-templates select="NursingObservation" mode="Nur2"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--护理操作章节-->
					<xsl:comment>护理操作章节</xsl:comment>
					<component>
						<section>
							<code displayName="护理操作"/>
							<text/>
							<xsl:apply-templates select="NursingProcedure" mode="NurP1"/>
						</section>
					</component>
					<!--器械物品核对章节-->
					<xsl:comment>器械物品核对章节</xsl:comment>
					<component>
						<section>
							<code displayName="术前器械物品核对"/>
							<text/>
							<!--术前-->
							<xsl:comment>术前</xsl:comment>
							<entry>
								<organizer classCode="CLUSTER" moodCode="EVN">
									<code/>
									<statusCode code="completed"/>
									<!--术前器械物品核对条目 1..1 R-->
									<xsl:apply-templates select="Check" mode="Check1"/>
									<xsl:apply-templates select="Check" mode="Check2"/>
								</organizer>
							</entry>
							<!--关前核对-->
							<xsl:comment>关前核对</xsl:comment>
							<entry>
								<organizer classCode="CLUSTER" moodCode="EVN">
									<code/>
									<statusCode/>
									<!--关前器械物品核对条目 1..1 R-->
									<xsl:apply-templates select="Check" mode="Check1"/>
									<xsl:apply-templates select="Check" mode="Check3"/>
								</organizer>
							</entry>
							<!--关后核对-->
							<xsl:comment>关后核对</xsl:comment>
							<entry>
								<organizer classCode="CLUSTER" moodCode="EVN">
									<code/>
									<statusCode code="completed"/>
									<!--关后器械物品核对条目 1..1 R-->
									<xsl:apply-templates select="Check" mode="Check1"/>
									<xsl:apply-templates select="Check" mode="Check4"/>
								</organizer>
							</entry>
						</section>
					</component>
					<!--手术操作章节-->
					<xsl:comment>手术操作章节</xsl:comment>
					<component>
						<section>
							<code code="47519-4" displayName="HISTORY OF PROCEDURES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<xsl:apply-templates select="OP" mode="OP2"/>
						</section>
					</component>
					<!--术后交接章节-->
					<xsl:comment>术后交接章节</xsl:comment>
					<component>
						<section>
							<code code="8648-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Hospital Course"/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<xsl:apply-templates select="Postoperative" mode="Postoperative"/>
									<xsl:comment>交接护士签名</xsl:comment>
									<author>
										<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='交接护士']" mode="Authenticator"/>
									</author>
									<!--转运者-->
									<xsl:comment>转运者签名</xsl:comment>
									<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='转运者']" mode="Authenticator"/>
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
