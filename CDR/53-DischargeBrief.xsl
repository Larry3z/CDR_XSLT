<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
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
			<recordTarget contextControlCode="OP" typeCode="RCT">
				<patientRole classCode="PAT">
					<!-- 住院号标识 -->
					<xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/>
					<patient classCode="PSN" determinerCode="INSTANCE">
						<!--患者身份证号-->
						<xsl:apply-templates select="Encounter/Patient" mode="IDNo"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<!--xsl:apply-templates select="Encounter/Patient" mode="BirthTime"/-->
						<xsl:apply-templates select="Encounter/Patient" mode="Age"/>
					</patient>
					<!--提供患者服务机构-->
					<providerOrganization classCode="ORG" determinerCode="INSTANCE">
						<id root="2.16.156.10011.1.5" extension="住院机构名称"/>
						<!--住院机构名称-->
						<name><xsl:value-of select="Encounter/HealthCareFacility"/></name>
					</providerOrganization>
				</patientRole>
			</recordTarget>
			<!--作者，保管机构-->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!--主要参与者签名 legalAuthenticator-->
			<legalAuthenticator typeCode="LA">
				<!-- HDSD00.16.028 DE09.00.053.00 签名日期时间 -->
				<time value="{authenticator/Inpatient/Time}"/>
				<signatureCode/>
				<assignedEntity>
					<!--HDSD00.16.053 DE02.01.039.00 住院医师签名-->
					<id root="2.16.156.10011.1.4" extension="81503"/>
					<code displayName="住院医师"/>
					<assignedPerson>
						<name><xsl:value-of select="authenticator/Inpatient/Name"/></name>
					</assignedPerson>
				</assignedEntity>
			</legalAuthenticator>
			<!--文档审核者 该部分信息表达文档经过了一定的审核，但还没达到一定的法律效应 -->
			<authenticator typeCode="AUTHEN">
				<!-- HDSD00.16.028 DE09.00.053.00 签名日期时间 -->
				<time value="{authenticator/SuperiorPhysician/Time}"/>
				<signatureCode/>
				<assignedEntity classCode="ASSIGNED">
					<!--HDSD00.16.035 DE02.01.039.00 上级医师签名 -->
					<id root="2.16.156.10011.1.4" extension="74489"/>
					<code displayName="上级医师"/>
					<assignedPerson classCode="PSN">
						<name><xsl:value-of select="authenticator/SuperiorPhysician/Name"/></name>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<participant typeCode="NOT">
				<associatedEntity classCode="ECON">
					<telecom value="{Contacts/Phone}"/>
					<!--联系人-->
					<associatedPerson>
						<!--HDSD00.16.024 DE02.01.039.00 联系人姓名-->
						<name><xsl:value-of select="Contacts/Name"/></name>
					</associatedPerson>
				</associatedEntity>
			</participant>
			<componentOf>
				<xsl:apply-templates select="Encounter" mode="Hosipitalization1"/>
			</componentOf>
			<relatedDocument typeCode="RPLC">
				<parentDocument>
					<id/>
					<setId/>
					<versionNumber/>
				</parentDocument>
			</relatedDocument>
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
			<component>
				<structuredBody>
					<!--主要健康问题章节-->
					<xsl:comment>主要健康问题</xsl:comment>
					<component>
						<section>
							<code code="11450-4" displayName="PROBLEM LIST" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--HDSD00.16.030 DE05.10.148.00 入院情况 条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.148.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院情况"/>
									<value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/AdmissionDiagnosis"/></value>
								</observation>
							</entry>
						</section>
					</component>
					<!--入院诊断章节-->
					<xsl:comment>入院诊断</xsl:comment>
					<component>
						<section>
							<code code="46241-6" displayName="HOSPITAL ADMISSION DX" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--HDSD00.16.032 DE05.01.024.00 入院诊断-西医诊断编码 条目-->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断-西医诊断编码"/>
									<value xsi:type="CD" code="{HospitolDiagnoses/WesternDiagnosis/code}" displayName="{HospitolDiagnoses/WesternDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entry>
							<!--HDSD00.16.033 DE05.10.130.00 入院诊断-中医病名代码 条目-->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断-中医病名代码"/>
									<value xsi:type="CD" code="{HospitolDiagnoses/TCPName/code}" displayName="{HospitolDiagnoses/TCPName/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</entry>
							<!--HDSD00.16.034 DE05.10.130.00 入院诊断-中医证候代码 条目-->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断-中医证候代码"/>
									<value xsi:type="CD" code="{HospitolDiagnoses/TCPSymptom/code}" displayName="{HospitolDiagnoses/TCPSymptom/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--出院诊断章节-->
					<xsl:comment>出院诊断</xsl:comment>
					<component>
						<section>
							<code code="11535-2" displayName="Discharge Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--HDSD00.16.008 DE05.01.024.00 出院诊断-西医诊断编码 条目-->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-西医诊断编码"/>
									<value xsi:type="CD" code="{DischargeDiagnosis/WesternDiagnosis/code}" displayName="{DischargeDiagnosis/WesternDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entry>
							<!--HDSD00.16.009 DE05.10.130.00 出院诊断-中医病名代码 条目-->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-中医病名代码"/>
									<value xsi:type="CD" code="{DischargeDiagnosis/TCMName/DiseaseNameCode/code}" displayName="{DischargeDiagnosis/TCMName/DiseaseNameCode/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</entry>
							<!--HDSD00.16.010 DE05.10.130.00 出院诊断-中医诊断代码 条目-->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-中医证候代码"/>
									<value xsi:type="CD" code="{DischargeDiagnosis/TCMSymptom/DiseaseNameCode/code}" displayName="{DischargeDiagnosis/TCMSymptom/DiseaseNameCode/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</entry>
							<!--HDSD00.16.051 DE02.10.028.00 中医“四诊”观察结果 条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.028.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="中医“四诊”观察结果"/>
									<value xsi:type="ST"><xsl:value-of select="DischargeDiagnosis/TCMsizhen"/></value>
								</observation>
							</entry>
							<!--HDSD00.16.006 DE04.01.117.00 出院时症状与体征 条目-->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.01.117.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院时症状与体征"/>
									<value xsi:type="ST"><xsl:value-of select="DischargeDiagnosis/DischargeSign"/></value>
								</observation>
							</entry>
							<!--HDSD00.16.004 DE06.00.193.00 出院情况 条目 -->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.193.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院情况"/>
									<value xsi:type="ST"><xsl:value-of select="DischargeDiagnosis/DischargeSituation"/></value>
								</observation>
							</entry>
						</section>
					</component>
					<!--手术操作章节-->
					<xsl:comment>手术操作</xsl:comment>
					<component>
						<section>
							<code code="47519-4" displayName="HISTORY OF PROCEDURES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--手术记录条目-->
							<entry>
								<!-- 手术记录 -->
								<procedure classCode="PROC" moodCode="EVN">
									<!--HDSD00.16.038 DE06.00.093.00 手术及操作编码 -->
									<code code="{SurgicalOperation/SurgicalRecords/Operation/code}" displayName="{SurgicalOperation/SurgicalRecords/Operation/displayName}" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表(ICD-9-CM)"/>
									<statusCode/>
									<!--手术及操作编码、操作日期/时间-->
									<!--HDSD00.16.039 DE06.00.221.00 手术及操作开始日期时间 -->
									<effectiveTime value="20141204230800"/>
									<!--HDSD00.16.040 DE06.00.257.00 手术切口类别代码 -->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.257.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术切口类别代码"/>
											<value xsi:type="CD" code="{SurgicalOperation/SurgicalRecords/SurgicalIncision/code}" displayName="{SurgicalOperation/SurgicalRecords/SurgicalIncision/displayName}" codeSystem="2.16.156.10011.2.3.1.256" codeSystemName="手术切口类别代码表"/>
										</observation>
									</entryRelationship>
									<!--HDSD00.16.029 DE05.10.147.00 切口愈合等级代码 -->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.147.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="切口愈合等级代码"/>
											<value xsi:type="CD" code="{SurgicalOperation/SurgicalRecords/SurgicalHealingGrade/code}" displayName="{SurgicalOperation/SurgicalRecords/SurgicalHealingGrade/displayName}" codeSystem="2.16.156.10011.2.3.1.257" codeSystemName="手术切口愈合等级代码表"/>
										</observation>
									</entryRelationship>
									<!--HDSD00.16.025 DE06.00.073.00 麻醉方法代码 -->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.073.00" codeSystem="2.16.156.10011.2.2.2" codeSystemName="卫生信息数据元目录" displayName="麻醉方法代码"/>
											<value code="{SurgicalOperation/SurgicalRecords/Anaesthesia/code}" displayName="{SurgicalOperation/SurgicalRecords/Anaesthesia/displayName}" codeSystem="2.16.156.10011.2.3.1.159" codeSystemName="麻醉方法代码表" xsi:type="CD"/>
										</observation>
									</entryRelationship>
									<!-- HDSD00.16.037 DE05.10.063.00 手术过程 -->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.063.00" codeSystem="2.16.156.10011.2.2.2" codeSystemName="卫生信息数据元目录" displayName="手术过程"/>
											<value xsi:type="ST"><xsl:value-of select="SurgicalOperation/SurgicalRecords/OperationProcess"/></value>
										</observation>
									</entryRelationship>
								</procedure>
							</entry>
						</section>
					</component>
					<!-- 治疗计划章节 -->
					<xsl:comment>治疗计划</xsl:comment>
					<component>
						<section>
							<code code="18776-5" codeSystem="2.16.840.1.113883.6.1" displayName="TREATMENT PLAN" codeSystemName="LOINC"/>
							<text/>
							<!--HDSD00.16.048 DE06.00.300.00 治则治法 条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.300.00" codeSystem="2.16.156.10011.2.3.3.15" codeSystemName="卫生信息数据元目录" displayName="治则治法"/>
									<value xsi:type="ST"><xsl:value-of select="TreatmentPlan/Accountability"/></value>
									<!--GB/T 16751.3-1997-->
								</observation>
							</entry>
						</section>
					</component>
					<!--住院过程章节-->
					<xsl:comment>住院过程</xsl:comment>
					<component>
						<section>
							<code code="8648-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Hospital Course"/>
							<text/>
							<!--HDSD00.16.045 DE06.00.296.00 诊疗过程描述 条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.296.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="诊疗过程描述"/>
									<value xsi:type="ST"><xsl:value-of select="HospitalizationProcess/DiagnosisTreatmentProcess"/></value>
								</observation>
							</entry>
							<!--HDSD00.16.047 DE05.10.113.00 治疗结果代码 条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.113.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="治疗结果代码"/>
									<value xsi:type="CD" code="{HospitalizationProcess/TreatmentResults/code}" displayName="{HospitalizationProcess/TreatmentResults/displayName}" codeSystem="2.16.156.10011.2.3.1.148" codeSystemName="病情转归代码表"/>
								</observation>
							</entry>
							<!--HDSD00.16.036 DE06.00.310.00 实际住院天数 条目-->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.310.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="实际住院天数"/>
									<value xsi:type="PQ" value="{HospitalizationProcess/Days}" unit="天"/>
								</observation>
							</entry>
						</section>
					</component>
					<!-- 医嘱章节-->
					<xsl:comment>医嘱</xsl:comment>
					<component>
						<section>
							<code code="46209-3" codeSystem="2.16.840.1.113883.6.1" displayName="Provider Orders" codeSystemName="LOINC"/>
							<text/>
							<!--HDSD00.16.049 DE08.50.047.00 中药煎煮方法 条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE08.50.047.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="中药煎煮方法"/>
									<value xsi:type="ST"><xsl:value-of select="Order/DecoctingMethod"/></value>
								</observation>
							</entry>
							<!--HDSD00.16.050 DE06.00.136.00 中药用药方法 条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.136.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="中药用药方法"/>
									<value xsi:type="ST"><xsl:value-of select="Order/MedicationMethod"/></value>
								</observation>
							</entry>
							<!--HDSD00.16.007 DE06.00.287.00 出院医嘱 条目-->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.287.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院医嘱"/>
									<value xsi:type="ST"><xsl:value-of select="Order/DischargeOrder"/></value>
								</observation>
							</entry>
						</section>
					</component>
					<!--实验室检查章节-->
					<xsl:comment>实验室检查</xsl:comment>
					<component>
						<section>
							<code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="STUDIES SUMMARY"/>
							<text/>
							<!--阳性辅助检查结果条目-->
							<entry typeCode="COMP" contextConductionInd="true">
								<!--阳性辅助检查结果-->
								<organizer classCode="BATTERY" moodCode="EVN">
									<statusCode/>
									<component typeCode="COMP" contextConductionInd="true">
										<!--HDSD00.16.042 DE04.50.128.00 阳性辅助检查结果 -->
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE04.50.128.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="ST"><xsl:value-of select="LaboratoryExamination/PositiveAuxiliaryExaminationResults"/></value>
										</observation>
									</component>
								</organizer>
							</entry>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
