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
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/GeneralConditionSurvey.xsl"/>
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
					<!--提供患者服务机构-->
					<xsl:comment>提供患者服务机构</xsl:comment>
					<providerOrganization classCode="ORG" determinerCode="INSTANCE">
						<!--机构标识号-->
						<id root="2.16.156.10011.1.5" extension="1234567890"/>
						<!--住院机构名称-->
						<name>
							<xsl:value-of select="Custodian/Organization/name"/>
						</name>
					</providerOrganization>
					<!--providerOrganization classCode="ORG" determinerCode="INSTANCE"-->
					<!--机构标识号-->
					<!--xsl:comment>机构标识号</xsl:comment>
				       <id root="2.16.156.10011.1.5" extension="1234567890"/-->
					<!--住院机构名称-->
					<!--xsl:comment>住院机构名称</xsl:comment>
				       <name>xx医院</name>
			        </providerOrganization-->
				</patientRole>
			</recordTarget>
			<!-- 文档创作者 -->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<!-- 保管机构 -->
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!--麻醉医师签名-->
			<xsl:comment>麻醉医师签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='麻醉医师']" mode="Authenticator"/>
			<!--xsl:apply-templates select="Practitioners/Practitioner1" mode="Authenticator1"/-->
			<!--authenticator-->
			<!--签名日期时间-->
			<!--time value="201210111212"/>
		       <signatureCode/>
		        <assignedEntity>
			      <id root="2.16.156.10011.1.4" extension="医务人员编号"/>
			      <code displayName="麻醉医师"/>
			        <assignedPerson>
				       <name>签名人姓名</name>
			        </assignedPerson>
		        </assignedEntity>
	        </authenticator-->
			<!--相关文档，暂时不用-->
			<xsl:call-template name="relatedDocument"/>
			<!-- 病床号、病房、病区、科室和医院的关联 -->
			<componentOf>
				<xsl:apply-templates select="Encounter" mode="Hosipitalization1"/>
			</componentOf>
			<!--文档体-->
			<component>
				<structuredBody>
					<!-- 生命体征章节 1..1 R -->
					<xsl:comment>生命体征章节</xsl:comment>
					<component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--体重条目 1..1 R-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign1"/>
							<!--出生体重条目 1..1 R-->
							<!--xsl:apply-templates select="Sections/Section[SectionCode='DE06.00.300.00']" mode="TreatmentPlanEntry"/-->
						</section>
					</component>
<<<<<<< HEAD
					<!--一般状况检查章节-->
					<xsl:comment>一般状况检查章节</xsl:comment>
					<xsl:apply-templates select="Inspect" mode="Inspect"/>
					<!--实验室检查章节-->
					<xsl:comment>实验室检查章节</xsl:comment>
=======
			        
			        <!--一般状况检查章节 1..1 R-->
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
			        <!--实验室检查章节-->
			        <xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
			        <!--术前诊断章节-->
			        <xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
			        <!--术后诊断章节-->
			        <xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
			        <!--手术操作章节-->
			        <xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
			        <!--麻醉章节-->
			        <xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
			        <!--主要健康问题章节-->
			        <xsl:comment>主要问题章节</xsl:comment>
>>>>>>> 12a402f3817ecedeefc4f4e4cf3a5f471691e749
					<component>
						<section>
							<code code="30954-2" displayName="STUDIES SUMMARY" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<xsl:apply-templates select="Encounter/Patient/Blood" mode="LabE"/>
						</section>
					</component>
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
					<!--手术操作章节-->
					<xsl:comment>手术操作章节</xsl:comment>
					<xsl:apply-templates select="OP" mode="OP1"/>
					<!--麻醉章节-->
					<xsl:comment>麻醉章节</xsl:comment>
					<xsl:apply-templates select="Anaesthesia" mode="Anaesthesia1"/>
					<!--主要健康问题章节-->
					<xsl:comment>主要问题章节</xsl:comment>
					<component>
						<section>
							<code code="11450-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="PROBLEM LIST"/>
							<text/>
							<xsl:apply-templates select="HealthProblem" mode="HealthProblem1"/>
							<!--麻醉恢复情况条目 1..1 R-->
							<!--xsl:apply-templates select="Sections/Section[SectionCode='DE05.01.025.00']" mode="TreatmentPlanEntry"/-->
							<!--清醒日期时间条目 1..1 R-->
							<!--xsl:apply-templates select="Sections/Section[SectionCode='DE05.01.025.00']" mode="TreatmentPlanEntry"/-->
							<!--拔除气管插管标志条目 0..1 R2-->
							<!--xsl:apply-templates select="Sections/Section[SectionCode='DE05.01.025.00']" mode="TreatmentPlanEntry"/-->
							<!--特殊情况条目 0..* R2-->
							<!--xsl:apply-templates select="Sections/Section[SectionCode='DE05.01.025.00']" mode="TreatmentPlanEntry"/-->
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
