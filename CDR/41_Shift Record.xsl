<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" xmlns:ms="urn:schemas-microsoft-com:xslt" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<!--xsl:include href="CDA-Support-Files/Export/Section-Modules/Encounter.xsl"/-->
	<xsl:template match="/Document">
		<ClinicalDocument xmlns:mif="urn:hl7-org:v3/mif" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:hl7-org:v3">
			<xsl:apply-templates select="." mode="CDAHeader"/>
			<xsl:comment>文档记录对象（患者） [1..*] contextControlCode="OP"表示本信息可以被重载</xsl:comment>
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
<<<<<<< HEAD
			<xsl:comment>文档创作者</xsl:comment>
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:comment>保管机构</xsl:comment>
			<xsl:apply-templates select="Custodian"/>
=======
			<!-- 作者 -->
			<xsl:apply-templates select="Author" mode="Author1"/>			 
			<!-- 保管机构 -->
			<xsl:apply-templates select="Custodian" mode="Custodian"/>			 
>>>>>>> 17b0d309215e57cd15897dd3a91808445d89bb2b
			<!-- 签名 -->
			<authenticator>
				<!--交班日期时间-->
				<time value="201201121234"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="{/Document/assignedPersonCode1}"/>
					<code displayName="交班者"/>
					<assignedPerson>
						<name>
							<xsl:value-of select="assignedPerson1"/>
						</name>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<authenticator>
				<!--交班日期时间-->
				<time value="201201121234"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="{/Document/assignedPersonCode2}"/>
					<code displayName="接班者"/>
					<assignedPerson>
						<name>
							<xsl:value-of select="assignedPerson2"/>
						</name>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<relatedDocument typeCode="RPLC">
				<parentDocument>
					<id/>
					<setId/>
					<versionNumber/>
				</parentDocument>
			</relatedDocument>
			<componentOf>
				<encompassingEncounter>
					<code displayName="入院日期时间"/>
					<xsl:variable name="AdminTime" select="/Document/Encounter/AdmissionTime"/>
					<effectiveTime value="{$AdminTime}"/>
					<location>
						<healthCareFacility>
							<serviceProviderOrganization>
								<asOrganizationPartOf classCode="PART">
									<!-- DE01.00.026.00病床号 -->
									<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
										<id root="2.16.156.10011.1.22" extension="-+11"/>
										<name>
											<xsl:value-of select="/Document/Encounter/Bed"/>
										</name>
										<!-- DE01.00.019.00病房号 -->
										<asOrganizationPartOf classCode="PART">
											<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
												<id root="2.16.156.10011.1.21" extension="-"/>
												<name>
													<xsl:value-of select="/Document/Encounter/Ward"/>
												</name>
												<!-- DE08.10.026.00科室名称 -->
												<asOrganizationPartOf classCode="PART">
													<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
														<id root="2.16.156.10011.1.26" extension="{Encounter/AdmissionLocationNo}"/>
														<name>
															<xsl:value-of select="Encounter/AdmissionLocation"/>
														</name>
														<!-- DE08.10.054.00病区名称 -->
														<asOrganizationPartOf classCode="PART">
															<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
																<id root="2.16.156.10011.1.27" extension="{Encounter/wholeOrganizationNo}"/>
																<name>
																	<xsl:value-of select="Encounter/wholeOrganization"/>
																</name>
																<!--医疗机构名称 -->
																<asOrganizationPartOf classCode="PART">
																	<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
																		<id root="2.16.156.10011.1.5" extension="HYFE"/>
																		<name>
																			<xsl:value-of select="'海医第二附属医院'"/>
																		</name>
																	</wholeOrganization>
																</asOrganizationPartOf>
															</wholeOrganization>
														</asOrganizationPartOf>
													</wholeOrganization>
												</asOrganizationPartOf>
											</wholeOrganization>
										</asOrganizationPartOf>
									</wholeOrganization>
								</asOrganizationPartOf>
							</serviceProviderOrganization>
						</healthCareFacility>
					</location>
				</encompassingEncounter>
			</componentOf>
			<!--文档体-->
			<component>
				<structuredBody>
					<!--主诉章节-->
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
					<xsl:comment>入院诊断章节(暂无可调用模板)</xsl:comment>
					<component>
						<section>
							<code code="46241-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HOSPITAL ADMISSION DX"/>
							<text/>
							<!--入院情况-->
							<xsl:apply-templates select="/Document" mode="ChiefComplaint"/>
							<!---entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE05.10.148.00" displayName="入院情况" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">一般</value>
								</observation>
							</entry-->
							<!--入院诊断-西医诊断编码-->
							<xsl:apply-templates select="/Document" mode="ChiefComplaint"/>
							<!--entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" displayName="入院诊断-西医诊断编码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="B95.100" displayName="B族链球菌感染" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entry-->
							<!--入院诊断-中医病名代码-->
							<xsl:apply-templates select="/Document" mode="ChiefComplaint"/>
							<!--entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" displayName="入院诊断-中医病名代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="BNG020" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)" displayName="黄疽病"/>
								</observation>
							</entry-->
							<xsl:apply-templates select="/Document" mode="ChiefComplaint"/>
							<!--入院诊断-中医证候代码-->
							<!--entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" displayName="入院诊断-中医证候代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="BNP051" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表（ GB/T 15657）" displayName="暴吐病"/>
								</observation>
							</entry-->
						</section>
					</component>
					<xsl:comment>治疗诊断章节</xsl:comment>
					<component>
						<section>
							<code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--条目:目前情况-->
							<xsl:apply-templates select="/Document" mode="ChiefComplaint"/>
							<!--entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE06.00.184.00" displayName="目前情况" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">高血压病</value>
								</observation>
							</entry-->
							<!--目前诊断-->
							<xsl:apply-templates select="/Document" mode="ChiefComplaint"/>
							<!--entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" displayName="目前诊断-西医诊断编码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="B95.100" displayName="B族链球菌感染" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entry-->
							<!--目前诊断-中医病名代码-->
							<xsl:apply-templates select="/Document" mode="ChiefComplaint"/>
							<!--entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" displayName="目前诊断-中医病名代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="BNG020" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)" displayName="黄疽病"/>
								</observation>
							</entry-->
							<!--目前诊断-中医证候代码-->
							<xsl:apply-templates select="/Document" mode="ChiefComplaint"/>
							<!--entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" displayName="目前诊断-中医证候代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="BNP051" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)" displayName="暴吐病"/>
								</observation>
							</entry-->
							<!--中医“四诊”观察结果-->
							<xsl:apply-templates select="/Document" mode="ChiefComplaint"/>
							<!--entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE02.10.028.00" displayName="中医“四诊”观察结果" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">舌红，苔薄腻，脉弦</value>
								</observation>
							</entry-->
						</section>
					</component>
					<xsl:comment>治疗计划章节</xsl:comment>
					<component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--诊疗计划-->
							<xsl:apply-templates select="Sections/Section[SectionCode='DE05.01.025.00']" mode="TreatmentPlanEntry"/>
							<!--治则治法-->
							<xsl:apply-templates select="Sections/Section[SectionCode='DE06.00.300.00']" mode="TreatmentPlanEntry"/>
						</section>
					</component>
					<xsl:comment>住院过程章节</xsl:comment>
					<component>
						<section>
							<code code="8648-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Hospital Course"/>
							<text/>
							<!--诊疗过程描述-->
							<xsl:apply-templates select="/Document" mode="ChiefComplaint"/>
							<!--entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.296.00" displayName="诊疗过程描述" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">对患者诊疗过程的详细描述</value>
								</observation>
							</entry-->
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
