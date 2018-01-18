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
			<!--作者，保管机构1..1-->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!--文档审核者 该部分信息表达文档经过了一定的审核，但还没达到一定的法律效应 -->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
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
			<!--
******************************
出院诊断章节
******************************-->
			<component>
				<section>
					<code code="11535-2" displayName="Discharge Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.024.00" displayName="出院诊断编码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.008 DE05.01.024.00 出院诊断编码 -->
							<value xsi:type="CD" code="B95.100" displayName="B族链球菌感染"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.017.00" displayName="出院日期时间" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.007 DE06.00.017.00 出院日期时间 -->
							<value xsi:type="TS" value="{/Document/leaveDiagnose/leaveTime}"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.193.00" displayName="出院情况" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.006 DE06.00.193.00 出院情况 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/leaveDiagnose/leaveState"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.223.00" displayName="离院方式代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.037 DE06.00.223.00 离院方式代码 -->
							<value xsi:type="CD" code="1" displayName="医嘱离院" codeSystem="2.16.156.10011.2.3.1.265" codeSystemName="离院方式代码表"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--
******************************
健康指导章节
******************************-->
			<component>
				<section>
					<code code="69730-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Instructions"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.291.00" displayName="饮食指导代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.077 DE03.00.080.00 饮食情况代码 -->
							<value xsi:type="CD" code="01" displayName="普通饮食" codeSystem="2.16.156.10011.2.3.1.263" codeSystemName="饮食指导代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.238.00" displayName="生活方式指导" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.055 DE06.00.238.00 生活方式指导 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/healthGuide/lifeway"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.124.00" displayName="宣教内容" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.072 DE06.00.124.00 宣教内容 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/healthGuide/propagandaEducation"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.299.00" displayName="复诊指导" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.012 DE06.00.299.00 复诊指导 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/healthGuide/returnVisit"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.136.00" displayName="用药指导" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.080 DE06.00.136.00 用药指导 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/healthGuide/pharmacy"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--
******************************
健康评估章节
******************************-->
			<component>
				<section>
					<code code="51848-0" displayName="Assessment note" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.122.00" displayName="自理能力代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.086 DE05.10.122.00 自理能力代码 -->
							<value xsi:type="CD" code="1" displayName="完全自理" codeSystem="2.16.156.10011.2.3.2.55" codeSystemName="自理能力代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE03.00.080.00" displayName="饮食情况代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.077 DE03.00.080.00 饮食情况代码 -->
							<value xsi:type="CD" code="1" displayName="良好" codeSystem="2.16.156.10011.2.3.2.34" codeSystemName="饮食情况代码表"/>
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
