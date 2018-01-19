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
					<!--电子申请单编号标识-->
					<id root="2.16.156.10011.1.24" extension="{ElectronicApplicationNumber}"/>
					<!--患者信息 -->
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
			<!-- 会诊申请相关 -->
			<authenticator>
				<time value="{Consultation/ApplicationConsultation/Time}"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="医务人员编码"/>
					<code displayName="会诊申请医师"/>
					<assignedPerson classCode="PSN" determinerCode="INSTANCE">
						<name>
							<xsl:value-of select="Consultation/ApplicationConsultation/DoctorName"/>
						</name>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<!--会诊医师相关-->
			<authenticator>
				<!--会诊日期时间-->
				<time xsi:type="TS" value="{Consultation/ConsultationDoctor/Time}"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="医务人员编码"/>
					<code displayName="会诊医师"/>
					<assignedPerson classCode="PSN" determinerCode="INSTANCE">
						<name>
							<xsl:value-of select="Consultation/ConsultationDoctor/Name"/>
						</name>
					</assignedPerson>
					<!--会诊医师所在医疗机构名称-->
					<representedOrganization>
						<name>
							<xsl:value-of select="Consultation/ConsultationDoctor/MedicalInstitution"/>
						</name>
					</representedOrganization>
				</assignedEntity>
			</authenticator>
			<!--会诊申请医疗机构名称-->
			<authenticator>
				<time value="{Consultation/ApplyMedicalInstitution/Time}"/>
				<signatureCode/>
				<assignedEntity>
					<id/>
					<code displayName="会诊申请医疗机构"/>
					<representedOrganization>
						<asOrganizationPartOf>
							<wholeOrganization>
								<id root="2.16.156.10011.1.26" extension="申请会诊科室"/>
								<name>
									<xsl:value-of select="Consultation/ApplyMedicalInstitution/Department"/>
								</name>
								<asOrganizationPartOf>
									<wholeOrganization>
										<id root="2.16.156.10011.1.5" extension="申请会诊机构名称"/>
										<name>
											<xsl:value-of select="Consultation/ApplyMedicalInstitution/Name"/>
										</name>
									</wholeOrganization>
								</asOrganizationPartOf>
							</wholeOrganization>
						</asOrganizationPartOf>
					</representedOrganization>
				</assignedEntity>
			</authenticator>
			<!--会诊所在医疗机构名称-->
			<authenticator>
				<time value="{Consultation/MedicalInstitutionLocated/Time}"/>
				<signatureCode/>
				<assignedEntity>
					<id/>
					<code displayName="会诊所在机构"/>
					<representedOrganization>
						<asOrganizationPartOf>
							<wholeOrganization>
								<id root="2.16.156.10011.1.26" extension="会诊科室名称"/>
								<name>
									<xsl:value-of select="Consultation/MedicalInstitutionLocated/Department"/>
								</name>
								<asOrganizationPartOf>
									<wholeOrganization>
										<id root="2.16.156.10011.1.5" extension="会诊所在医疗机构名称"/>
										<name>
											<xsl:value-of select="Consultation/MedicalInstitutionLocated/Name"/>
										</name>
									</wholeOrganization>
								</asOrganizationPartOf>
							</wholeOrganization>
						</asOrganizationPartOf>
					</representedOrganization>
				</assignedEntity>
			</authenticator>
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
					<!--健康评估章节-->
					<comment>健康评估</comment>
					<component>
						<section>
							<code code="51848-0" displayName="Assessment note" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<!-- 病历摘要-->
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.182.00" displayName="病历摘要" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="CaseSummary"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--诊断章节-->
					<comment>诊断</comment>
					<component>
						<section>
							<code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--西医诊断-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="西医诊断名称"/>
									<value xsi:type="ST">患者所患疾病的西医诊断名称</value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.01.024.00" displayName="西医诊断编码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="CD" code="{Diagnosis/CurrentDiagnosis/code}" displayName="{Diagnosis/CurrentDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
							<!--中医病名-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE05.10.172.00" displayName="中医诊断名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
										<qualifier>
											<name displayName="中医诊断名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST">
										<xsl:value-of select="Diagnosis/TCPSymptom/Name"/>
									</value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.130.00" displayName="中医病名代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
												<qualifier>
													<name displayName="中医病名代码"/>
												</qualifier>
											</code>
											<value xsi:type="CD" code="{Diagnosis/TCPName/code}" displayName="{Diagnosis/TCPName/code}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
							<!--中医证候-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE05.10.172.00" displayName="中医诊断症候名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
										<qualifier>
											<name displayName="中医证候名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST">
										<xsl:value-of select="Diagnosis/TCPSymptom/Name"/>
									</value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.130.00" displayName="中医证候代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
												<qualifier>
													<name displayName="中医证候代码"/>
												</qualifier>
											</code>
											<value xsi:type="CD" code="{Diagnosis/TCPSymptom/code}" displayName="{Diagnosis/TCPSymptom/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
										</observation>
									</entryRelationship>
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
					<!--辅助检查章节 0..1 R2-->
					<comment>辅助检查</comment>
					<component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--诊疗过程名称-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE06.00.297.00" displayName="诊疗过程名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="SupplementaryExamination/DiagnosisTreatmentProcess"/>
									</value>
								</observation>
							</entry>
							<!--治则治法-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.300.00" displayName="治则治法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="SupplementaryExamination/Accountability"/>
									</value>
								</observation>
							</entry>
							<!--会诊目的-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.214.00" displayName="会诊目的" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="SupplementaryExamination/ConsultationPurpose"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--治疗计划章节-->
					<comment>治疗计划</comment>
					<component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--诊疗过程名称-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE06.00.297.00" displayName="诊疗过程名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="TreatmentPlan/DiagnosisProcess"/>
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
							<!--会诊目的-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.214.00" displayName="会诊目的" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="TreatmentPlan/ConsultationPurpose"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--
********************************************************
会诊原因章节
********************************************************
-->
					<!--会诊原因章节-->
					<comment>会诊原因</comment>
					<component>
						<section>
							<code displayName="会诊原因"/>
							<text/>
							<!--会诊类型-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.319.00" displayName="会诊类型" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="Consultation/CauseConsultation/Type"/>
									</value>
								</observation>
							</entry>
							<!--会诊原因-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.039.00" displayName="会诊原因" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="Consultation/CauseConsultation/DetailedDescription"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--会诊意见章节-->
					<comment>会诊意见</comment>
					<component>
						<section>
							<code displayName="会诊意见"/>
							<text/>
							<!--会诊意见-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.018.00" displayName="会诊意见" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="Consultation/CauseConsultation/Opinion"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--
****************************************************
住院过程章节
****************************************************
-->
					<comment>住院过程</comment>
					<component>
						<section>
							<code code="8648-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Hospital Course"/>
							<text/>
							<!--诊疗过程描述-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.296.00" displayName="诊疗过程描述" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="HospitalCourse"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
