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
			<!-- 文档创作者 -->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<!-- 保管机构 -->
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!--接生者签名-->
			<xsl:comment>接生者签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='接生者']" mode="Authenticator"/>
			<!--助产者签名-->
			<xsl:comment>助产者签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='助产者']" mode="Authenticator"/>
			<!--助手签名-->
			<xsl:comment>助手签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='助手']" mode="Authenticator"/>
			<!--护婴者签名-->
			<xsl:comment>护婴者签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='护婴者']" mode="Authenticator"/>
			<!--指导者签名-->
			<xsl:comment>指导者签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='指导者']" mode="Authenticator"/>
			<!--记录人签名-->
			<xsl:comment>记录人签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='记录人']" mode="Authenticator"/>
			<xsl:apply-templates select="Linkman" mode="Linkman"/>
			<!--相关文档，暂时不用-->
			<xsl:call-template name="relatedDocument"/>
			<!-- 病床号、病房、病区、科室和医院的关联 -->
			<componentOf>
				<xsl:apply-templates select="Encounter" mode="Hosipitalization1"/>
			</componentOf>
			<!--文档体-->
			<component>
				<structuredBody>
					<!--既往史章节-->
					<xsl:comment>既往史章节</xsl:comment>
					<component>
						<section>
							<code code="11348-0" displayName="HISTORY OF PAST ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<!--孕次 1..1 R-->
							<xsl:apply-templates select="Encounter/Patient/Allergies/Allergy" mode="Gravidity"/>
							<!--产次 1..1 R-->
							<xsl:apply-templates select="Encounter/Patient/Allergies/Allergy" mode="CC"/>
						</section>
					</component>
					<!--阴道分娩章节-->
					<xsl:comment>阴道分娩章节</xsl:comment>
					<component>
						<section>
							<code code="57074-7" displayName="labor and delivery process" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<!--预产期 1..1 R-->
							<xsl:apply-templates select="HealthProblem" mode="HealthProblem8"/>
							<!--临产日期时间 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery1"/>
							<!--胎膜破裂日期时间 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery2"/>
							<!--前羊水性状 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery3"/>
							<!--前羊水量 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery4"/>
							<xsl:apply-templates select="Delivery" mode="Delivery5"/>
							<!--第1产程时长 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery6"/>
							<!--宫口开全日期时间 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery7"/>
							<!--第2产程时长 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery8"/>
							<!--胎儿娩出日期时间 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery9"/>
							<!--第3产程时长 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery10"/>
							<!--胎盘娩出日期时间 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery11"/>
							<!--总产程时长 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery12"/>
							<!--胎方位代码 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery17"/>
							<!--胎儿娩出助产标志 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery13"/>
							<!--助产方式 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery14"/>
							<!--胎盘娩出情况 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery15"/>
							<!--胎膜完整情况标志 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery16"/>
							<!--羊水性状 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery18"/>
							<!--羊水量 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery19"/>
							<!--脐带长度 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery20"/>
							<!--绕颈身 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery21"/>
							<!--脐带异常情况标志 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery22"/>
							<!--产时用药 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery23"/>
							<!--预防措施 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery24"/>
							<!--产妇会阴切开标志 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery25"/>
							<!--会阴切开位置 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery26"/>
							<!--产妇会阴缝合针数 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery27"/>
							<!--产妇会阴裂伤程度代码 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery28"/>
							<!--会阴血肿标志 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery29"/>
							<!--阴道血肿大小 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery30"/>
							<!--阴道血肿处理 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery31"/>
							<!--麻醉方法代码 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery32"/>
							<!--麻醉药物名称 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery33"/>
							<!--阴道裂伤标志 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery34"/>
							<!--阴道血肿标志 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery35"/>
							<!--宫颈裂伤标志 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery36"/>
							<!--宫颈缝合情况 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery37"/>
							<!--产后用药 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery38"/>
							<!--分娩过程摘要 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery39"/>
							<!--宫缩情况 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery40"/>
							<!--子宫情况 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery41"/>
							<!--恶露状况 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery42"/>
							<!--会阴情况 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery43"/>
							<!--修补手术过程 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery44"/>
							<!--存脐带血情况标志 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery45"/>
						</section>
					</component>
					<!--产后处置章节-->
					<xsl:comment>产后处置章节</xsl:comment>
					<component>
						<section>
							<code code="57076-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="postpartum hospitalization treatment"/>
							<!--产后诊断 1..1 R-->
							<xsl:apply-templates select="PostpartumDisposal" mode="PD1"/>
							<!--产后观察日期时间 1..1 R-->
							<xsl:apply-templates select="PostpartumDisposal" mode="PD2"/>
							<!--产后检查时间 1..1 R-->
							<xsl:apply-templates select="PostpartumDisposal" mode="PD3"/>
							<!--产后血压 1..1 R-->
							<xsl:apply-templates select="VitalSign" mode="VitalSign6"/>
							<!--产后脉搏 1..1 R-->
							<xsl:apply-templates select="PostpartumDisposal" mode="PD4"/>
							<!--产后心率 1..1 R-->
							<xsl:apply-templates select="PostpartumDisposal" mode="PD5"/>
							<!--产后出血量 1..1 R-->
							<xsl:apply-templates select="PostpartumDisposal" mode="PD6"/>
							<!--产后宫缩 1..1 R-->
							<xsl:apply-templates select="PostpartumDisposal" mode="PD7"/>
							<!--产后宫底高度 1..1 R-->
							<xsl:apply-templates select="PostpartumDisposal" mode="PD8"/>
							<!--肛查 1..1 R-->
							<xsl:apply-templates select="PostpartumDisposal" mode="PD9"/>
						</section>
					</component>
					<!--新生儿章节-->
					<xsl:comment>新生儿章节</xsl:comment>
					<component>
						<section>
							<code code="57075-4" displayName="newborn delivery information" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<!--新生儿性别代码 1..1 R-->
							<xsl:apply-templates select="Neonatus" mode="Neonatus1"/>
							<!--新生儿出生体重 1..1 R-->
							<xsl:apply-templates select="Neonatus" mode="Neonatus2"/>
							<!--新生儿出生身高 1..1 R-->
							<xsl:apply-templates select="Neonatus" mode="Neonatus3"/>
							<!--产瘤大小 1..1 R-->
							<xsl:apply-templates select="Neonatus" mode="Neonatus4"/>
							<!--产瘤部位 1..1 R-->
							<xsl:apply-templates select="Neonatus" mode="Neonatus5"/>
						</section>
					</component>
					<!--分娩评估章节-->
					<xsl:comment>分娩评估章节</xsl:comment>
					<component>
						<section>
							<code code="51848-0" displayName="Assessment note" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<!--Apgar评分间隔时间代码 1..1 R-->
							<xsl:apply-templates select="ChildbearingEstimate" mode="CE1"/>
							<!--Apger评分值 1..1 R-->
							<xsl:apply-templates select="ChildbearingEstimate" mode="CE2"/>
							<!--分娩结局代码 1..1 R-->
							<xsl:apply-templates select="ChildbearingEstimate" mode="CE3"/>
							<!--新生儿异常情况代码 1..1 R-->
							<xsl:apply-templates select="ChildbearingEstimate" mode="CE4"/>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
