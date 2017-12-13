<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="2.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Diagnosis.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Medication.xsl"/>
	<xsl:template match="/Document">
		<ClinicalDocument xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:hl7-org:v3" xmlns:mif="urn:hl7-org:v3/mif">
			<xsl:apply-templates select="." mode="CDAHeader"/>
			<xsl:comment>病人信息</xsl:comment>
			<recordTarget contextControlCode="OP" typeCode="RCT">
				<patientRole classCode="PAT">
					<!--门（急）诊号标识 1..1 -->
					<xsl:apply-templates select="/Encounter/Patient/OutpatientID" mode="OutpatientID"/>
					<!--处方编号 1..1-->
					<xsl:apply-templates select="Patient/HealthCardNumber" mode="PatientHealthCardNumber"/>
					<patient classCode="PSN" determinerCode="INSTANCE">
						<!--患者身份证号-->
						<xsl:apply-templates select="Encounter/Patient" mode="IDNo"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Age"/>
						<!-- 开立科室 0..1 -->
						<providerOrganization>
							<id root="2.16.156.10011.1.26"/>
							<name>
								<xsl:value-of select="Encounter/AdmissionLocation"/>
								<!--xsl:value-of select="Encounter/Order/Orderby"/-->
							</name>
							<asOrganizationPartOf>
								<wholeOrganization>
									<!-- 机构代码 -->
									<id root="2.16.156.10011.1.5" extension="--"/>
									<name>
										<xsl:value-of select="Encounter/HealthCareFacility"/>
									</name>
								</wholeOrganization>
							</asOrganizationPartOf>
						</providerOrganization>
					</patient>
				</patientRole>
			</recordTarget>
			<!--作者，保管机构-->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!--主要参与者签名 legalAuthenticator-->
			<xsl:comment>kaishi</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='医师']" mode="legalAuthenticator"/>
			<!--次要参与者签名 Authenticator-->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
			<!--相关文档，暂时不用-->
			<xsl:comment>处方开立医生 1..1</xsl:comment>
			<author contextControlCode="OP" typeCode="AUT">
				<time>
					<xsl:attribute name="value"><xsl:value-of select="CreationTime"/></xsl:attribute>
				</time>
				<assignedAuthor classCode="ASSIGNED">
					<id root="2.16.156.10011.1.7"/>
					<xsl:attribute name="extension"><xsl:value-of select="OrderedBy"/></xsl:attribute>
					<assignedPerson>
						<name>
							<xsl:value-of select="OrderedBy"/>
						</name>
					</assignedPerson>
				</assignedAuthor>
			</author>
			<xsl:comment>保管机构 1..1</xsl:comment>
			<xsl:call-template name="Custodian"/>
			<xsl:comment>处方审核药剂师签名 1..*</xsl:comment>
			<legalAuthenticator>
				<xsl:apply-templates select="Administrations/Administration/Auditor" mode="pharmacist">
					<xsl:with-param name="displayname" select="'处方审核药剂师'"/>
				</xsl:apply-templates>
			</legalAuthenticator>
			<xsl:comment>处方调配药剂师签名1..*</xsl:comment>
			<Authenticator>
				<xsl:apply-templates select="Dispenses/Dispense/Dispenser" mode="pharmacist">
					<xsl:with-param name="displayname" select="'处方调配药剂师'"/>
				</xsl:apply-templates>
			</Authenticator>
			<xsl:comment>处方核对药剂师签名 1..*</xsl:comment>
			<Authenticator>
				<xsl:apply-templates select="Administrations/Administration/Reviewer" mode="pharmacist">
					<xsl:with-param name="displayname" select="'处方核对药剂师'"/>
				</xsl:apply-templates>
			</Authenticator>
			<xsl:comment>处方发药药剂师签名 1..*</xsl:comment>
			<Authenticator>
				<xsl:apply-templates select="Administrations/Administration/Practitioner" mode="pharmacist">
					<xsl:with-param name="displayname" select="'处方发药药剂师'"/>
				</xsl:apply-templates>
			</Authenticator>
			<!--关联活动 0..1-->
			<relatedDocument typeCode="RPLC">
				<parentDocument>
					<id/>
					<setId/>
					<versionNumber/>
				</parentDocument>
			</relatedDocument>
			<component>
				<structuredBody>
					<xsl:comment>诊断记录章节 1..1</xsl:comment>
					<component>
						<xsl:apply-templates select="Encounter/Diagnoses/Diagnosis" mode="Diagnosis2"/>
					</component>
					<xsl:comment>用药章节_1..1</xsl:comment>
					<component>
						<xsl:apply-templates select="." mode="HistoryOfMedication"/>
					</component>
					<xsl:comment>费用章节</xsl:comment>
					<component>
						<xsl:apply-templates select="." mode="payment"/>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
	<xsl:template match="Auditor|Practitioner|Reviewer|Dispenser" mode="pharmacist">
		<xsl:param name="displayname"/>
		<time/>
		<signatureCode/>
		<assignedEntity>
			<id root="2.16.156.10011.1.4" extension="医务人员编号"/>
			<code displayName="{$displayname}"/>
			<assignedPerson classCode="PSN" determinerCode="INSTANCE">
				<name>
					<xsl:value-of select="Name"/>
				</name>
			</assignedPerson>
		</assignedEntity>
	</xsl:template>
	
	<xsl:template match="*" mode="payment">
		<section>
			<code code="48768-6" displayName="PAYMENT SOURCES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
			<text/>
			<entry>
				<observation classCode="OBS" moodCode="EVN">
					<code code="DE07.00.004.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="处方药品金额"/>
					<value xsi:type="MO" value="{Payment/Bill}" currency="元"/>
				</observation>
			</entry>
		</section>
	</xsl:template>
</xsl:stylesheet>
