<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="2.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/Histories.xsl"/>
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
						<!-- 开立科室 0..1 这部分比较特别，不用单独做模板了-->
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
			<!--作者(处方开立医生)，保管机构-->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!--主要参与者签名 legalAuthenticator-->
			<!--Practitioner的来源假设已有的文档中有这部分，否则要到真正的源去去值，分别是：
				处方审核药剂师: Administrations/Administration/Auditor
				处方调配药剂师: Dispenses/Dispense/Dispenser
				处方核对药剂师: Administrations/Administration/Reviewer
				处方发药药剂师: Administrations/Administration/Practitioner
			-->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='处方审核药剂师']" mode="legalAuthenticator"/>
			<!--次要参与者签名 Authenticator-->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='处方审核药剂师']" mode="Authenticator"/>
			<xsl:call-template name="relatedDocument"/>
			<!--文档体开始-->
			<component>
		<structuredBody>
			<!--诊断记录章节-->
			<component>
				<section>
					<code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.11883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--条目：诊断-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.024.00" displayName="诊断代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="CD" code="B95.100" displayName="B族链球菌感染"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--用药章节 1..*-->
			<component>
				<section>
					<code code="10160-0" codeSystem="2.16.840.1.113883.6.1" displayName="HISTORY
OF MEDICATION USE" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<substanceAdministration classCode="SBADM" moodCode="EVN">
							<text/>
							<routeCode code="1" displayName="口服" codeSystem="2.16.156.10011.2.3.1.158" codeSystemName="用药途径代码表"/>
							<!--用药剂量-单次 -->
							<doseQuantity value="{/Document/DrugUse/dose}" unit="mg"/>
							<!--用药频率 -->
							<rateQuantity>
							     <translation code="{/Document/DrugUse/times}" displayName="bid"/>
							</rateQuantity>
							<!--药物剂型 -->
							<administrationUnitCode code="47" displayName="灌汤剂" codeSystem="2.16.156.10011.2.3.1.211" codeSystemName="药物剂型代码表"></administrationUnitCode>
							<consumable>
								<manufacturedProduct>
									<manufacturedLabeledDrug>
										<!--药品代码及名称(通用名) -->
										<code/>
										<name><xsl:value-of select="/Document/DrugUse/name"/> </name>
									</manufacturedLabeledDrug>
								</manufacturedProduct>
							</consumable>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE08.50.043.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="药物规格"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/DrugUse/size"/></value>
								</observation>
							</entryRelationship>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.135.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="药物使用总剂量"/>
									<value xsi:type="PQ" value="{/Document/DrugUse/total}"/>
								</observation>
							</entryRelationship>
						</substanceAdministration>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.294.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="处方有效天数"/>
							<value xsi:type="PQ" value="{/Document/DrugUse/days}" unit="天"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE08.50.056.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="处方药品组号"/>
							<value xsi:type="INT" value="{/Document/DrugUse/group}"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.179.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="处方备注信息"/>
							<value xsi:type="ST"><xsl:value-of select="/Document/DrugUse/text"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--费用章节-->
			<component>
				<section>
					<code code="48768-6" displayName="PAYMENT SOURCES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE07.00.004.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="处方药品金额"/>
							<value xsi:type="MO" value="{/Document/cost/cost4}" currency="元"/>
						</observation>
					</entry>
				</section>
			</component>
		</structuredBody>
	</component>
		</ClinicalDocument>
	
	</xsl:template>
</xsl:stylesheet>
