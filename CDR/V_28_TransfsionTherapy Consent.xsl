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
					<!-- 门诊号标识 -->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<!-- 知情同意书编号标识 -->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<patient classCode="PSN" determinerCode="INSTANCE">
						<!--患者身份证号-->
						<xsl:apply-templates select="Encounter/Patient" mode="IDNo"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<xsl:apply-templates select="Encounter/Patient" mode="BirthTime"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Age"/>
					</patient>
				</patientRole>
			</recordTarget>
			<!-- 文档创作者 -->
			<author typeCode="AUT" contextControlCode="OP">
				<!--文档创作时间 1..1  -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--制定创作者 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</author>
			<!-- 签名 -->
			<authenticator>
				<!--医师签名 1..1  -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--患者签名 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--代理人签名 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<relatedDocument typeCode="RPLC">
			<!--文档中医疗卫生事件的就诊场景,即入院场景记录-->
				<parentDocument>
					<id/>
					<setId/>
					<versionNumber/>
				</parentDocument>
			</relatedDocument>
			<!-- 病床号、病房、病区、科室和医院的关联 1..R -->
			<componentOf>
				<encompassingEncounter>
					<!--入院时间 1..1-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<location>
						<healthCareFacility>
							<serviceProviderOrganization>
								<asOrganizationPartOf classCode="PART">
									<!-- DE01.00.026.00病床号 1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
									<!-- DE01.00.019.00病房号1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
									<!-- DE08.10.026.00科室名称 1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
									<!-- DE08.10.054.00病区名称 1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
									<!--医疗机构名称 1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
								</asOrganizationPartOf>
							</serviceProviderOrganization>
						</healthCareFacility>
					</location>
				</encompassingEncounter>
			</componentOf>
			<component>
		<structuredBody>
			<!--
***************************
诊断章节
***************************-->
			<component>
				<section>
					<code code="29548-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Diagnosis"/>
					<text/>
					<!--疾病诊断编码-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="疾病诊断编码"/>
							<value xsi:type="CD"  code="B95.100" displayName="B族链球菌感染"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10" />
						</observation>
					</entry>
				</section>
			</component>
			<!--
***************************
输血章节
***************************-->
			<component>
				<section>
					<code code="56836-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="History of blood transfusion"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.106.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--1无，2有，9未说明-->
							<value xsi:type="CD" code="1" displayName="无" codeSystem="2.16.156.10011.2.3.2.42" codeSystemName="输血史标识代码表"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--
***************************
治疗计划章节
***************************-->
			<component>
				<section>
					<code code="18776-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="TREATMENT PLAN"/>
					<text/>
					<entry>
						<!--输血过程-->
						<procedure classCode="PROC" moodCode="EVN">
							<code/>
							<!--输血时间-->
							<effectiveTime/>
							<!--输血方式-->
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.266.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血方式"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/treatPlan/transfusion/traWay"/></value>
								</observation>
							</entryRelationship>
							<!--输血指征-->
							<entryRelationship typeCode="CAUS">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.340.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血指征"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/treatPlan/transfusion/traIndication"/></value>
								</observation>
							</entryRelationship>
							<!--输血品种代码-->
							<entryRelationship typeCode="COMP">
								<substanceAdministration classCode="SBADM" moodCode="RQO">
									<consumable>
										<manufacturedProduct>
											<manufacturedMaterial>
												<code code="11" codeSystem="2.16.156.10011.2.3.1.251" codeSystemName="输血品种代码表" displayName="浓缩红细胞"/>
											</manufacturedMaterial>
										</manufacturedProduct>
									</consumable>
								</substanceAdministration>
							</entryRelationship>
							<!--输血前有关检查项目以及结果-->
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.109.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血前有关检查项目以及结果"/>
									<value xsi:type="ED"><xsl:value-of select="/Document/treatPlan/transfusion/traInspectionItemResult"/></value>
								</observation>
							</entryRelationship>
						</procedure>
					</entry>
				</section>
			</component>
			<!--
***************************
意见章节
***************************-->
			<component>
				<section>
					<code displayName="意见章节"/>
					<text/>
					<!--医疗机构意见-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="医疗机构的意见"/>
							<value xsi:type="ST"><xsl:value-of select="/Document/suggestion/medicalInstitution"/></value>
						</observation>
					</entry>
					<!--患者意见-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="患者的意见"/>
							<value xsi:type="ST"><xsl:value-of select="/Document/suggestion/patientOpinion"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--
***************************
风险章节
***************************-->
			<component>
				<section>
					<code displayName="操作风险"/>
					<text/>
					<!--输血风险及可能发生的不良后果-->
					<entry>
						<observation classCode="OBS" moodCode="DEF">
							<code code="DE06.00.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血风险及可能发生的不良后果"/>
							<value xsi:type="ST"><xsl:value-of select="/Document/operationRisk/transfusionRisk"/></value>
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
