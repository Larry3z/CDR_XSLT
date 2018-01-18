<?xml version="1.0" encoding="UTF-8"?>
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
			<!--文档记录对象（患者） [1..*] contextControlCode="OP"表示本信息可以被重载-->
			<recordTarget contextControlCode="OP" typeCode="RCT">
				<patientRole classCode="PAT">
					<!-- 住院号标识 -->
					<xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/>
					<patient classCode="PSN" determinerCode="INSTANCE">
						<!--患者身份证号-->
						<xsl:apply-templates select="Encounter/Patient" mode="IDNo"/>
						<!--患者姓名-->
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<!--患者性别-->
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<!--患者出生日期-->
						<xsl:apply-templates select="Encounter/Patient" mode="BirthTime"/>
						<!--患者年龄-->
						<xsl:apply-templates select="Encounter/Patient" mode="Age"/>
					</patient>
				</patientRole>
			</recordTarget>
			<!-- 作者 -->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<!-- 保管机构 -->
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!-- 签名 1..1 -->
			<xsl:comment>医生签名</xsl:comment>
			<authenticator>
				<time value="{authenticator/time}"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="医务人员编码"/>
					<code displayName="医师签名"/>
					<assignedPerson>
						<name>
							<xsl:value-of select="authenticator/name"/>
						</name>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<!--小结日期时间-->
			<xsl:comment>小结日期时间</xsl:comment>
			<documentationOf>
				<serviceEvent>
					<code/>
					<effectiveTime value="{effectiveTime}"/>
				</serviceEvent>
			</documentationOf>
			<!--关联活动信息 1..R-->
			<xsl:comment>关联活动信息</xsl:comment>
			<componentOf>
				<encompassingEncounter>
					<code displayName="入院日期时间"/>
					<xsl:variable name="AdminTime" select="Encounter/AdmissionTime"/>
					<effectiveTime value="{$AdminTime}"/>
					<location>
						<healthCareFacility>
							<serviceProviderOrganization>
								<asOrganizationPartOf classCode="PART">
									<!-- DE01.00.026.00病床号 -->
									<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
										<id root="2.16.156.10011.1.22" extension="-+11"/>
										<name>
											<xsl:value-of select="Encounter/Hospitalization/Location/bed"/>
										</name>
										<!-- DE01.00.019.00病房号 -->
										<asOrganizationPartOf classCode="PART">
											<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
												<id root="2.16.156.10011.1.21" extension="-"/>
												<name>
													<xsl:value-of select="Encounter/Hospitalization/Location/ward"/>
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
																			<xsl:value-of select="Encounter/HealthCareFacility"/>
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
			<!--
**************************************************
文档体
**************************************************
-->
			<component>
				<structuredBody>
					<!--主诉章节1..1 R-->
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
					<!--入院诊断章节1..1 R-->
					<xsl:comment>入院诊断章节</xsl:comment>
					<component>
						<section>
							<code code="46241-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HOSPITAL ADMISSION DX"/>
							<text/>
							<!--入院情况-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE05.10.148.00" displayName="入院情况" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="HospitolDiagnoses/Admission"/>
									</value>
								</observation>
							</entry>
							<!--入院诊断-西医诊断名称-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断-西医诊断编码"/>
									<value xsi:type="CD" code="{HospitolDiagnoses/WesternDiagnosis/code}" displayName="{HospitolDiagnoses/WesternDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.1.256" codeSystemName="西医诊断编码"/>
								</observation>
							</entry>
							<!--入院诊断-中医病名代码-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" displayName="入院诊断-中医病名代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
										<qualifier>
											<name displayName="中医病名代码"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="{HospitolDiagnoses/TCPName/code}" displayName="{HospitolDiagnoses/TCPName/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</entry>
							<!--入院诊断-中医证候代码-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" displayName="入院诊断-中医证候代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
										<qualifier>
											<name displayName="中医 证候名称"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="{HospitolDiagnoses/TCPSymptom/code}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表（ GB/T 15657-1995）"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--诊断章节1..1 R-->
					<xsl:comment>诊断章节</xsl:comment>
					<component>
						<section>
							<code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--条目:目前情况-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE06.00.184.00" displayName="目前情况" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="Diagnosis/CurrentSituation"/>
									</value>
								</observation>
							</entry>
							<!--目前诊断-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" displayName="目前诊断-西医诊断编码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="{Diagnosis/CurrentDiagnosis/code}" displayName="{Diagnosis/CurrentDiagnosis/displayName}" codeSystemName="ICD-10"/> 
								</observation>
							</entry>
							<!--目前诊断-中医病名代码-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" displayName="目前诊断-中医病名代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
										<qualifier>
											<name displayName="中医病名代码"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="{Diagnosis/TCPName/code}" displayName="{Diagnosis/TCPName/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</entry>
							<!--目前诊断-中医证候代码-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" displayName="目前诊断-中医证候代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
										<qualifier>
											<name displayName="中医 证候代码"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="{Diagnosis/TCPSymptom/code}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表（ GB/T 15657-1995）"/>
								</observation>
							</entry>
							<!--中医“四诊”观察结果-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE02.10.028.00" displayName="中医“四诊”观察结果" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="Diagnosis/TCPsizhen"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--治疗计划章节1..1 R-->
					<xsl:comment>治疗计划章节</xsl:comment>
					<component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--今后治疗方案-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.159.00" displayName="今后治疗方案" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="TreatmentPlan/FutureTreatment"/>
									</value>
								</observation>
							</entry>
							<!--治则治法-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.300.00" displayName="治则治法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="TreatmentPlan/Accountability"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--用药章节1..1 R-->
					<xsl:comment>用药章节</xsl:comment>
					<component>
						<section>
							<code code="10160-0" codeSystem="2.16.840.1.113883.6.1" displayName="HISTORY OF MEDICATION USE" codeSystemName="LOINC"/>
							<text/>
							<!--医嘱内容-->
							<entry>
								<observation classCode="OBS " moodCode="EVN ">
									<code code="DE06.00.287.00" displayName="医嘱内容" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="TreatmentPlan/Accountability"/>
									</value>
								</observation>
							</entry>
							<!--中药煎煮方法-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE08.50.047.00" displayName="中药煎煮方法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="TreatmentPlan/DecoctingMethod"/>
									</value>
								</observation>
							</entry>
							<!--中药用药方法-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE06.00.136.00" displayName="中药用药方法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="TreatmentPlan/MedicationMethod"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--住院过程章节1..1 R -->
					<xsl:comment>住院过程章节</xsl:comment>
					<component>
						<section>
							<code code="8648-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Hospital Course"/>
							<text/>
							<!--诊疗过程描述-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.296.00" displayName="诊疗过程描述" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">对患者诊疗过程的详细描述</value>
								</observation>
							</entry>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
