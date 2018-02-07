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
			<recordTarget typeCode="RCT" contextControlCode="OP">
				<patientRole>
					<!--门诊号-->
					<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
					<!--住院号-->
					<xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/>
					<!-- 知情同意书编号 -->
					<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
					<patient>
						<!--患者身份证号标识-->
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
			
			<!--文档体-->
			<component>
		<structuredBody>
			<!--诊断记录章节-->
			<component>
				<section>
					<code code="29548-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Diagnosis"/>
					<title/>
					<text/>
					<!--疾病诊断编码-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="疾病诊断编码"/>
							<value xsi:type="CD"  code="{Diagnosis/CurrentDiagnosis/code}" displayName="{Diagnosis/CurrentDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--知情同意章节-->
			<component>
				<section>
					<code code="34895-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="EDUCATION NOTE"/>
					<text/>
					<!-- DE09.00.117.00知情同意书名称 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE09.00.117.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="知情同意书名称"/>
							<value xsi:type="ST"><xsl:value-of select="InformedConsent/ICname"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE09.00.116.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="知情同意内容"/>
							<value xsi:type="ST"><xsl:value-of select="InformedConsent/ICrecord"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--意见章节-->
			<component>
				<section>
					<code displayName="意见章节"/>
					<text/>
					<!--医疗机构意见-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="医疗机构的意见"/>
							<value xsi:type="ST"><xsl:value-of select="Opinion/MI"/></value>
						</observation>
					</entry>
					<!--患者意见-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="患者的意见"/>
							<value xsi:type="ST"><xsl:value-of select="Opinion/Patient"/></value>
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
