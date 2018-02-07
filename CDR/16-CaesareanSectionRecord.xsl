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
			<!--手术者签名-->
			<xsl:comment>手术者签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='手术者']" mode="Authenticator"/>
			<!--麻醉师签名-->
			<xsl:comment>麻醉师签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='麻醉医师']" mode="Authenticator"/>
			<!--器械护士签名-->
			<xsl:comment>器械护士签名</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='器械护士']" mode="Authenticator"/>
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
			<!--participant typeCode="NOT"-->
			<!--联系人@classCode：CON，固定值，表示角色是联系人 -->
			<!--associatedEntity classCode="ECON"-->
			<!--联系人电话-->
			<!--telecom value="13811113372"/-->
			<!--联系人-->
			<!--associatedPerson-->
			<!--姓名-->
			<!--name>于洪浩</name> 
                    </associatedPerson> 
                </associatedEntity> 
            </participant-->
			<!--相关文档，暂时不用-->
			<xsl:call-template name="relatedDocument"/>
			<!-- 病床号、病房、病区、科室和医院的关联 -->
			<componentOf>
				<xsl:apply-templates select="Encounter" mode="Hosipitalization1"/>
			</componentOf>
			<!--文档体-->
			<component>
				<structuredBody>
					<!--手术操作章节-->
					<xsl:comment>手术操作章节</xsl:comment>
					<component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--待产日期时间 1..1 R-->
							<xsl:apply-templates select="HealthProblem" mode="HealthProblem3"/>
							<!--胎膜完整情况标志 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery16"/>
							<!--脐带长度 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery20"/>
							<!--绕颈身 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery21"/>
							<!--产前诊断 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP3"/>
							<!--手术指征 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP4"/>
							<!--手术及操作编码 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP5"/>
							<!--手术开始日期时间 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP6"/>
							<!--麻醉方法代码 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery32"/>
							<!--麻醉体位 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP7"/>
							<!--麻醉效果 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP8"/>
							<!--剖宫产手术过程 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP9"/>
							<!--子宫情况 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery41"/>
							<!--胎方位-->
							<xsl:apply-templates select="Delivery" mode="Delivery17"/>
							<!--胎儿娩出方式 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP10"/>
							<!--胎盘黄染 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP11"/>
							<!--胎膜黄染 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP12"/>
							<!--脐带缠绕情况 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP13"/>
							<!--脐带扭转 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP14"/>
							<!--存脐带血情况标志 1..1 R-->
							<xsl:apply-templates select="Delivery" mode="Delivery45"/>
							<!--子宫壁缝合情况 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP15"/>
							<!--宫缩剂名称 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP16"/>
							<!--宫缩剂使用方法 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP17"/>
							<!--手术用药 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP18"/>
							<!--手术用药量 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP19"/>
							<!--腹腔探查子宫 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP20"/>
							<!--腹腔探查附件 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP21"/>
							<!--宫腔探查异常情况标志 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP22"/>
							<!--宫腔探查肌瘤标志 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP23"/>
							<!--宫腔探查处理情况 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP24"/>
							<!--手术时产妇情况 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP25"/>
							<!--出血量 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP26"/>
							<!--输血成分 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP27"/>
							<!--输血量 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP28"/>
							<!--供氧时间 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP29"/>
							<!--其他用药 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP30"/>
							<!--其他情况 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP31"/>
							<!--手术结束日期时间 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP32"/>
							<!--手术全程时间 1..1 R-->
							<xsl:apply-templates select="OP" mode="OP33"/>
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
						</section>
					</component>
					<!--新生儿章节-->
					<xsl:comment>新生儿章节</xsl:comment>
					<component>
						<section>
							<code code="57075-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="newborn delivery information"/>
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
							<text/>
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
