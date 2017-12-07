<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="2.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Functions.xsl"/>
	<xsl:include href="CDA-Support-Files/Variables.xsl"/>
	<xsl:include href="CDA-Support-Files/TemplateIdentifiers-CDA.xsl"/>
	<xsl:include href="CDA-Support-Files/cnoid.xsl"/>
	<xsl:include href="CDA-Support-Files/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/PatientMedicalHistories.xsl"/>
	<xsl:include href="CDA-Support-Files/Encounter.xsl"/>
	<xsl:template match="/Encounter">
		<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:mif="urn:hl7-org:v3/mif" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:call-template name="CDAHeader">
				<xsl:with-param name="documentTypeNumber" select="'37'"/>
				<xsl:with-param name="documentName" select="'住院-首次病程记录'"/>
			</xsl:call-template>
			<!--PersonalInformation-->
			<!-- the first two line give the same code in 53 documents -->
			<recordTarget typeCode="RCT" contextControlCode="OP">
				<patientRole classCode="PAT">
					<!--住院号标识-->
					<xsl:comment>住院号标识</xsl:comment>
					<xsl:apply-templates select="Patient/InpatientID" mode="InpatientID"/>
					<!--患者-->
					<xsl:comment>患者信息</xsl:comment>
					<patient classCode="PSN" determinerCode="INSTANCE">
						<!--患者身份证号标识-->
						<xsl:apply-templates select="Patient/IDNo" mode="IDNo"/>
						<!--患者姓名，必选-->
						<Name>
							<xsl:variable name="contactFirstName" select="Patient/FirstName/text()"/>
							<xsl:variable name="contactMiddleName" select="Patient/MiddleName/text()"/>
							<xsl:variable name="contactLastName" select="Patient/LastName/text()"/>
							<xsl:value-of select="concat($contactLastName,$contactFirstName)"/>
						</Name>
						<!-- 性别，必选 -->
						<xsl:apply-templates select="Patient" mode="code-administrativeGender"/>
						<!-- 出生时间1..1,格式可能要转换，要求输出为yyyymmdd -->
						<xsl:apply-templates select="Patient/BirthTime" mode="birthTime"/>
						<!-- 年龄 -->
						<!--xsl:apply-templates select="Patient/Age" mode="Age"/-->
					</patient>
				</patientRole>
			</recordTarget>
			<xsl:comment>文档作者</xsl:comment>
			<xsl:apply-templates select="Creator" mode="Creator"/>
			<xsl:comment>保管机构</xsl:comment>
			<xsl:call-template name="Custodian"/>
			<component>
				<structuredBody>
					<xsl:comment>主诉章节1.1</xsl:comment>
					<component>
						<section>
							<code code="10154-3" displayName="CHIEF COMPLAINT" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<!-- 主诉-->
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.01.119.00" displayName="主诉" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="VisitDescription"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<xsl:comment>诊断记录</xsl:comment>
					<!--xsl:apply-templates select="Patient" mode="IllnessHistories"/-->
					<xsl:comment>治疗计划0..1R2</xsl:comment>
					<!--xsl:apply-templates select="Patient" mode="BloodTransfusionHistory"/-->
					<component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="GOL ">
									<code code="DE05.01.025.00" displayName="诊疗计划" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST"><xsl:value-of select="TreatmentPlan"/></value>
								</observation>
							</entry>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
	<!--PatientInformation Part-->
	<xsl:variable name="健康档案编号标识">2.16.156.10011.1.2</xsl:variable>
	<xsl:variable name="健康卡号标识">2.16.156.10011.1.19</xsl:variable>
	<xsl:variable name="处方编号标识">2.16.156.10011.1.20</xsl:variable>
	<xsl:variable name="addrNullFlavor" select="'UNK'"/>
</xsl:stylesheet>
