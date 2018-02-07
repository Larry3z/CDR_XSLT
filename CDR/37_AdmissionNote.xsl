<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Diagnosis.xsl"/>
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
						<xsl:apply-templates select="Encounter/Patient" mode="BirthTime"/>
						<!--xsl:apply-templates select="Encounter/Patient" mode="Age"/-->
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

			<!--作者，保管机构-->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!--主要参与者签名 legalAuthenticator--><xsl:comment>kaishi</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='医师']" mode="legalAuthenticator"/>
			<!--次要参与者签名 Authenticator-->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
			<!--相关文档，暂时不用-->
			<xsl:call-template name="relatedDocument"/>
			<!-- 病床号、病房、病区、科室和医院的关联 -->
			<componentOf>
			<xsl:apply-templates select="Encounter" mode="Hosipitalization1"/>
			</componentOf>



<!--文档体-->
			<component>
		<structuredBody>
			<!--
**********************************
主诉章节
**********************************
-->
			<component>
				<section>
					<code code="10154-3" displayName="CHIEF COMPLAINT" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<!-- 主诉-->
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.01.119.00" displayName="主诉" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="ST"><xsl:value-of select="Cc/Record"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--
*************************************
诊断章节
*************************************
-->
			<component>
				<section>
					<code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN ">
							<code code="DE05.10.133.00" displayName="病历特点" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="ST"><xsl:value-of select="Diagnosis/characteristics"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.028.00" displayName="中医“四诊”观察结果" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="ST"><xsl:value-of select="Diagnosis/TCPsizhen"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.070.00" displayName="诊断依据" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="ST"><xsl:value-of select="Diagnosis/Basis"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="初步诊断-西医诊断编码"/>
							<value xsi:type="CD" code="{MajorHealthProblems/cz/CurrentDiagnosis/code}" displayName="{MajorHealthProblems/cz/CurrentDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="初步诊断-中医病名代码">
								<qualifier>
									<name displayName="中医病名代码"/>
								</qualifier>
							</code>
							<value xsi:type="CD" code="{MajorHealthProblems/cz/TCM/code}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)" displayName="{MajorHealthProblems/cz/TCM/displayName}"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="初步诊断-中医证候代码">
								<qualifier>
									<name displayName="中医证候代码"/>
								</qualifier>
							</code>
							<value xsi:type="CD" code="{MajorHealthProblems/cz/TCM/zhcode}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表（ GB/T 15657-1995）" displayName="{MajorHealthProblems/cz/TCM/zhdisplayName}"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN ">
							<code code="DE05.01.025.00" displayName="鉴别诊断-西医诊断名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/jb/xyName"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN ">
							<code code="DE05.10.172.00" displayName="鉴别诊断-中医病名名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
								<qualifier>
									<name displayName="中医病名名称"/>
								</qualifier>
							</code>
							<value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/jb/zyName"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN ">
							<code code="DE05.10.172.00" displayName="鉴别诊断-中医证候名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
								<qualifier>
									<name displayName="中医证候名称"/>
								</qualifier>
							</code>
							<value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/jb/zhName"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--
**********************************
治疗计划章节
**********************************
-->
			<component>
				<section>
					<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="GOL ">
							<code code="DE05.01.025.00" displayName="诊疗计划" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="ST"><xsl:value-of select="TreatmentPlan/zlPlan"/></value>
						</observation>
					</entry>
					<!--治则治法-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.300.00" displayName="治则治法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="ST"><xsl:value-of select="TreatmentPlan/Accountability"/></value>
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
