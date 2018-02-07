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
						<Organization>
							<xsl:apply-templates select="Custodian/Organization" mode="Id"/>
							<xsl:apply-templates select="Custodian/Organization" mode="Name"/>
							<xsl:apply-templates select="Custodian/Organization" mode="Type"/>
							<!--xsl:apply-templates select="Encounter/Patient" mode="IDNo"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<xsl:apply-templates select="Encounter/Patient" mode="BirthTime"/-->
						</Organization>
					</patient>
				</patientRole>
			</recordTarget>
			<!--作者，文档生成机构-->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!--签名 Authenticator-->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
			<!--关联活动信息 1..R-->
			<componentOf>
				<encompassingEncounter>
					<!--入院时间 1..1-->
					<xsl:apply-templates select="/Document/CreationTime"/>
					<location>
						<healthCareFacility>
							<serviceProviderOrganization>
								<asOrganizationPartOf classCode="PART">
									<!-- DE01.00.026.00病床号 1..1 -->
									<xsl:apply-templates select="/Document/bedNo"/>
									<!-- DE01.00.019.00病房号1..1 -->
									<xsl:apply-templates select="/Document/sickroomNo"/>
									<!-- DE08.10.026.00科室名称 1..1 -->
									<xsl:apply-templates select="/Document/department"/>
									<!-- DE08.10.054.00病区名称 1..1 -->
									<xsl:apply-templates select="/Document/infectedPatch"/>
									<!--医疗机构名称 1..1 -->
									<xsl:apply-templates select="/Document/Custodian/Organization/name"/>
								</asOrganizationPartOf>
							</serviceProviderOrganization>
						</healthCareFacility>
					</location>
				</encompassingEncounter>
			</componentOf>
			<xsl:apply-templates select="Encounter" mode="Hosipitalization1"/>
			<!--文档体-->
			<component>
				<structuredBody>
					<!--
***********************************
诊断章节
***********************************
                -->
					<component>
						<section>
							<code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="疾病诊断编码"/>
									<value xsi:type="CD" code="B95.100" displayName="B族链球菌感染" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--
***********************************
生命体征章节
***********************************
                -->
					<component>
						<section>
							<code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="VITAL SIGNS"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.10.188.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体重（kg）"/>
									<value xsi:type="PQ" value="{/Document/sign/weight}" unit="kg"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--
***********************************
护理记录章节
***********************************
                -->
					<component>
						<section>
							<code displayName="护理记录"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.211.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理等级代码"/>
									<value xsi:type="CD" code="1" displayName="特级护理" codeSystem="2.16.156.10011.2.3.1.259" codeSystemName="护理等级代码表"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.212.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理类型代码"/>
									<value xsi:type="CD" code="1" displayName="基础护理" codeSystem="2.16.156.10011.2.3.1.260" codeSystemName="护理类型代码表"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--
***********************************
护理观察章节
***********************************
                -->
					<component>
						<section>
							<code displayName="护理观察"/>
							<text/>
							<!--多个观察写多个entry即可，每个观察对应着观察结果描述-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.031.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理观察项目名称"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/nurse/observe/item"/></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE02.10.028.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理观察结果"/>
											<value xsi:type="ST"><xsl:value-of select="/Document/nurse/observe/result"/></value>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
						</section>
					</component>
					<!--
***********************************
护理操作章节
***********************************
                -->
					<!--护理操作章节：一个护理操作对应多个操作项目类目，一个操作项目类目又对应多个操作结果-->
					<component>
						<section>
							<code displayName="护理操作"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.342.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理操作名称"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/nurse/operate/name"/></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.210.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理操作项目类目名称"/>
											<value xsi:type="ST"><xsl:value-of select="/Document/nurse/operate/categoryName"/></value>
											<entryRelationship typeCode="COMP">
												<observation classCode="OBS" moodCode="EVN">
													<code code="DE06.00.209.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理操作结果"/>
													<value xsi:type="ST"><xsl:value-of select="/Document/nurse/operate/result"/></value>
												</observation>
											</entryRelationship>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
						</section>
					</component>
					<!--
***********************************
用药章节
***********************************
                -->
					<component>
						<section>
							<code code="10160-0" codeSystem="2.16.840.1.113883.6.1" displayName="HISTORY OF MEDICATION USE" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<substanceAdministration classCode="SBADM" moodCode="EVN">
									<text/>
									<!--药物使用途径代码：DE06.00.134.00-->
									<routeCode code="1" displayName="口服" codeSystem="2.16.156.10011.2.3.1.158" codeSystemName="用药途径代码表"/>
									<!--用药剂量-单次 -->
									<doseQuantity value="{/Document/medication/doseQuantity}" unit="mg"/>
									<!--用药频率-->
									<rateQuantity>
										<translation code="01" displayName="bid"/>
									</rateQuantity>
									<consumable>
										<manufacturedProduct>
											<manufacturedLabeledDrug>
												<!--药品名称 -->
												<code/>
												<name><xsl:value-of select="/Document/medication/name"/></name>
											</manufacturedLabeledDrug>
										</manufacturedProduct>
									</consumable>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.136.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="药物用法"/>
											<!--药物用法描述-->
											<value xsi:type="ST"><xsl:value-of select="/Document/medication/direction"/></value>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.164.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="中药使用类别代码"/>
											<!--中药使用类别代码-->
											<value code="1" displayName="未使用" codeSystem="2.16.156.10011.2.3.1.157" codeSystemName="中药使用类别代码表" xsi:type="CD"/>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.135.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="药物使用总剂量"/>
											<!--药物使用总剂量-->
											<value xsi:type="PQ" value="{/Document/medication/sumQuantity}" unit="mg"/>
										</observation>
									</entryRelationship>
								</substanceAdministration>
							</entry>
						</section>
					</component>
					<!--
***********************************
护理标志章节
***********************************
                -->
					<component>
						<section>
							<code displayName="护理标志"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.01.048.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="呕吐标志"/>
									<value xsi:type="BL" value="true"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.01.051.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="排尿困难标志"/>
									<value xsi:type="BL" value="false"/>
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
