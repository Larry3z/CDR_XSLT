<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientMedicalHistories.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/LaboratoryExamination.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Encounter.xsl"/>
	<xsl:template match="/Document">
		<ClinicalDocument xmlns:mif="urn:hl7-org:v3/mif" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:hl7-org:v3">
			<xsl:comment>病历概要</xsl:comment>
			<!--PersonalInformation-->
			<!-- the first two line give the same code in 53 documents -->
			<recordTarget contextControlCode="OP" typeCode="RCT">
				<patientRole classCode="PAT">
					<xsl:apply-templates select="Encounter/Patient" mode="MPIID"/>
					<xsl:apply-templates select="Encounter/Patient" mode="HealthCardNumber"/>
					<xsl:apply-templates select="Encounter/Patient/Address" mode="Address"/>
					<xsl:apply-templates select="Encounter/Patient" mode="PhoneNumber"/>
					<xsl:comment>患者基本信息</xsl:comment>
					<patient classCode="PSN" determinerCode="INSTANCE">
						<id root="2.16.156.10011.1.3">
							<xsl:attribute name="extension"><xsl:value-of select="Encounter/Patient/IDNo"/></xsl:attribute>
						</id>
						<!--患者姓名，必选-->
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<!-- 性别，必选 -->
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<!-- 出生时间1..1,格式可能要转换，要求输出为yyyymmdd -->
						<xsl:apply-templates select="Encounter/Patient/BirthTime" mode="BirthTime"/>
						<!-- 婚姻状况1..1 -->
						<xsl:apply-templates select="Encounter/Patient/MaritalStatus" mode="code-maritalStatus"/>
						<!-- 民族1..1 -->
						<xsl:apply-templates select="Encounter/Patient" mode="code-ethnicGroup-patient"/>
						<!--工作单位0..1, 要求名称电话-->
						<xsl:apply-templates select="Encounter/Patient/employerOrganization" mode="EmployerOrganization"/>
						<!--职业0..1-->
						<xsl:apply-templates select="Encounter/Patient" mode="Occupation"/>
					</patient>
				</patientRole>
			</recordTarget>
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<xsl:comment>联系人1..*</xsl:comment>
			<xsl:apply-templates select="Encounter/Patient/SupportContacts" mode="CDRSupportContacts"/>
			<component>
				<structuredBody>
					<xsl:comment>实验室检验章节0..1R2仅包括血型</xsl:comment>
					<xsl:apply-templates select="Encounter/Patient/Blood" mode="LabE"/>
					<xsl:comment>既往史章节0..1R2</xsl:comment>
					<xsl:apply-templates select="Encounter/Patient/IllnessHistories" mode="IllnessHistories"/>
					<xsl:comment>输血章节,单条目0..1R2</xsl:comment>
					<xsl:apply-templates select="Encounter/Patient" mode="BloodTransfusionHistory"/>
					<xsl:comment>过敏史章节0..1R2</xsl:comment>
					<xsl:apply-templates select="Encounter/Patient/Allergies" mode="Allergies"/>
					<xsl:comment>预防接种章节0..1R2</xsl:comment>
					<xsl:apply-templates select="Encounter/Patient" mode="Immunizations"/>
					<xsl:comment>个人史章节0..1R2</xsl:comment>
					<xsl:apply-templates select="Encounter/Patient/SocialHistories" mode="SocialHistories"/>
					<xsl:comment>月经史章节0..1R2</xsl:comment>
					<xsl:apply-templates select="Encounter/Patient" mode="MenstrualHistory"/>
					<xsl:comment>家族史章节0..1R2</xsl:comment>
					<xsl:apply-templates select="Encounter/Patient" mode="FamilyHistories"/>
					-<relatedDocument typeCode="RPLC">
						<parentDocument>
							<id/>
							<setId/>
							<versionNumber/>
						</parentDocument>
					</relatedDocument>
					<xsl:comment>卫生事件1..1R</xsl:comment>
					<xsl:apply-templates select="Encounter" mode="EncounterSummary"/>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
	<!--PatientInformation Part-->
</xsl:stylesheet>
<!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\..\DataIn\CDR_EncounterSample_v1.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="no" profilemode="0" profiledepth="" profilelength=""
		          urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"
		          customvalidator="">
			<advancedProp name="bSchemaAware" value="false"/>
			<advancedProp name="xsltVersion" value="2.0"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="bGenerateByteCode" value="true"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="sInitialMode" value=""/>
		</scenario>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->
