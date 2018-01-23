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
					<!-- 住院号 -->
					<xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/>
					<!--患者信息 -->
					<patient classCode="PSN" determinerCode="INSTANCE">
						<!--患者身份证号-->
						<xsl:apply-templates select="Encounter/Patient" mode="IDNo"/>
						<!--患者姓名-->
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<!--患者性别-->
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<!--患者年龄-->
						<xsl:apply-templates select="Encounter/Patient" mode="Age"/>
					</patient>
				</patientRole>
			</recordTarget>
			<!-- 作者 -->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<!-- 保管机构 -->
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!-- 主任医师签名 -->
			<authenticator>
				<time value="{authenticator/AttendingDoctor/Time}"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="医务人员编码"/>
					<code displayName="主任医师"/>
					<assignedPerson classCode="PSN" determinerCode="INSTANCE">
						<name><xsl:value-of select="authenticator/AttendingDoctor/Name"/></name>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<!-- 主治医师签名 -->
			<authenticator>
				<time value="{authenticator/ChiefPhysician/Time}"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="医务人员编码"/>
					<code displayName="主治医师"/>
					<assignedPerson classCode="PSN" determinerCode="INSTANCE">
						<name><xsl:value-of select="authenticator/ChiefPhysician/Name"/></name>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<!-- 住院医师签名 -->
			<authenticator>
				<time value="{authenticator/Inpatient/Time}"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="医务人员编码"/>
					<code displayName="住院医师"/>
					<assignedPerson classCode="PSN" determinerCode="INSTANCE">
						<name><xsl:value-of select="authenticator/Inpatient/Name"/></name>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<!-- 病床号、病房、病区、科室和医院的关联 -->
			<componentOf>
				<encompassingEncounter>
					<effectiveTime/>
					<location>
						<healthCareFacility>
							<serviceProviderOrganization>
								<asOrganizationPartOf classCode="PART">
									<!--HDSD00.09.003 DE01.00.026.00 病床号 -->
									<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
										<id root="2.16.156.10011.1.22" extension="1-32"/>
										<!--HDSD00.09.004 DE01.00.019.00 病房号 -->
										<asOrganizationPartOf classCode="PART">
											<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
												<id root="2.16.156.10011.1.21" extension="-"/>
												<!--HDSD00.09.036 DE08.10.026.00 科室名称 -->
												<asOrganizationPartOf classCode="PART">
													<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
														<!--HDSD00.09.005 DE08.10.054.00 病区名称
-->
														<asOrganizationPartOf classCode="PART">
															<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
																<name>普通外科一病房</name>
																<!--XXX医院 -->
																<asOrganizationPartOf classCode="PART">
																	<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
																		<id root="2.16.156.10011.1.5" extension="12345678890"/>
																		<name>北京大学第三医院</name>
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
					<!-- 主要健康问题章节 -->
					<xsl:comment>主要健康问题</xsl:comment>
					<component>
						<section>
							<code code="11450-4" displayName="Problem list" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.148.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院情况"/>
									<value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/AdmissionDiagnosis"/></value>
								</observation>
							</entry>
						</section>
					</component>
					<!--入院诊断章节 -->
					<xsl:comment>入院诊断</xsl:comment>
					<component>
						<section>
							<code code="11535-2" displayName="HOSPITAL DISCHARGE DX" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断编码"/>
									<value xsi:type="CD" code="{HospitolDiagnoses/DiagnosticCode/code}" displayName="{HospitolDiagnoses/DiagnosticCode/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.092.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院日期时间"/>
									<value xsi:type="TS" value="{HospitolDiagnoses/Time}"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.50.128.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="阳性辅助检查结果"/>
									<value xsi:type="ST"><xsl:value-of select="HospitolDiagnoses/PositiveAuxiliaryExaminationResults"/></value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.028.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="中医“四诊”观察结果"/>
									<value xsi:type="ST"><xsl:value-of select="HospitolDiagnoses/TCMsizhen"/></value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.300.00" displayName="治则治法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST"><xsl:value-of select="HospitolDiagnoses/Accountability"/></value>
								</observation>
							</entry>
						</section>
					</component>
					<!-- 住院过程章节 -->
					<xsl:comment>住院过程</xsl:comment>
					<component>
						<section>
							<code code="8648-8" displayName="Hospital Course" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.296.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="诊疗过程描述"/>
									<value xsi:type="ST"><xsl:value-of select="HospitalizationProcess/DiagnosisTreatmentProcess"/></value>
								</observation>
							</entry>
						</section>
					</component>
					<!-- 医嘱（用药）章节 -->
					<xsl:comment>医嘱（用药）</xsl:comment>
					<component>
						<section>
							<code code="46209-3" codeSystem="2.16.840.1.113883.6.1" displayName="Provider
Orders" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE08.50.047.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="中药煎煮方法"/>
									<value xsi:type="ST"><xsl:value-of select="Medication/DecoctingMethod"/> </value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.136.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="中药用药方法"/>
									<value xsi:type="ST"><xsl:value-of select="Medication/MedicationMethod"/></value>
								</observation>
							</entry>
						</section>
					</component>
					<!-- 出院诊断章节 -->
					<xsl:comment>出院诊断</xsl:comment>
					<component>
						<section>
							<code code="11535-2" displayName="Discharge Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.193.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院情况"/>
									<value xsi:type="ST"><xsl:value-of select="DischargeDiagnosis/DischargeSituation"/></value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.017.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院日期时间"/>
									<value xsi:type="TS" value="{DischargeDiagnosis/Time}"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-西医诊断名称"/>
									<value xsi:type="ST"><xsl:value-of select="DischargeDiagnosis/WesternDiagnosis/Name"/></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-西医诊断编码"/>
											<value xsi:type="CD" code="{DischargeDiagnosis/WesternDiagnosis/code}" displayName="{DischargeDiagnosis/WesternDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-中医病名名称">
										<qualifier>
											<name displayName="中医病名名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST"><xsl:value-of select="DischargeDiagnosis/TCMName/Name"/></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-中医病名代码">
												<qualifier>
													<name displayName="中医病名代码"/>
												</qualifier>
											</code>
											<value xsi:type="CD" code="{DischargeDiagnosis/TCMName/DiseaseClassificationCode/code}" displayName="{DischargeDiagnosis/TCMName/DiseaseClassificationCode/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-中医证候名称">
										<qualifier>
											<name displayName="中医症候名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST"><xsl:value-of select="DischargeDiagnosis/TCMSymptom/Name"/></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-中医证候代码">
												<qualifier>
													<name displayName="中医症候代码"/>
												</qualifier>
											</code>
											<value xsi:type="CD" code="{DischargeDiagnosis/TCMSymptom/DiseaseClassificationCode/code}" displayName="{DischargeDiagnosis/TCMSymptom/DiseaseClassificationCode/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.01.117.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院时症状与体征"/>
									<value xsi:type="ST"><xsl:value-of select="DischargeDiagnosis/DischargeSymptoms"/></value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.287.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院医嘱"/>
									<value xsi:type="ST"><xsl:value-of select="DischargeDiagnosis/DischargeOrder"/></value>
								</observation>
							</entry>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
