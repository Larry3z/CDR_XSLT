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
			<authenticator>
				<!--签名日期时间-->
				<time value="{authenticator/time}"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="医务人员编码"/>
					<code displayName="医师签名"/>
					<assignedPerson classCode="PSN" determinerCode="INSTANCE">
						<name>
							<xsl:value-of select="authenticator/name"/>
						</name>
						<professionalTechnicalPosition>
							<professionaltechnicalpositionCode code="{authenticator/professionalTechnicalPosition/code}" codeSystem="2.16.156.10011.2.3.1.209" codeSystemName="专业技术职务类别代码表" displayName="{authenticator/professionalTechnicalPosition/displayName}"/>
						</professionalTechnicalPosition>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<!--讨论成员信息-->
			<participant typeCode="CON">
				<associatedEntity classCode="ECON">
					<!--参加讨论人员名单-->
					<associatedPerson>
						<name>
							<xsl:value-of select="Practitioners/Practitioner[identifier='H001']/Name"/>
						</name>
						<name>
							<xsl:value-of select="Practitioners/Practitioner[identifier='H002']/Name"/>
						</name>
						<name>
							<xsl:value-of select="Practitioners/Practitioner[identifier='H003']/Name"/>
						</name>
						<name>
							<xsl:value-of select="Practitioners/Practitioner[identifier='H004']/Name"/>
						</name>
						<name>
							<xsl:value-of select="Practitioners/Practitioner[identifier='H005']/Name"/>
						</name>
					</associatedPerson>
				</associatedEntity>
			</participant>
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
					<!--诊断记录章节 1..1 R-->
					<xsl:comment>诊断记录章节</xsl:comment>
					<component>
						<section>
							<code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--条目:疾病诊断-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE05.01.025.00" displayName="疾病诊断名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST"><xsl:value-of select="Diagnosis/Disease/Name"/></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.01.024.00" displayName="疾病诊断编码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="CD" code="{Diagnosis/Disease/code}" displayName="{Diagnosis/Disease/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
							<!--病情变换情况-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.134.00" displayName="病情变化情况" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST"><xsl:value-of select="Diagnosis/ConditionChange"/></value>
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
							<!--注意事项-->
							<entry>
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE09.00.119.00" displayName="注意事项" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST"><xsl:value-of select="TreatmentPlan/Attention"/></value>
								</observation>
							</entry>
						</section>
					</component>
					<!--手术操作-->
					<xsl:comment>手术操作章节</xsl:comment>
					<component>
						<section>
							<code code="47519-4" displayName="HISTORY OF PROCEDURES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<!-- 1..1 手术及操作编码 -->
								<procedure classCode="PROC" moodCode="EVN">
									<code code="{SurgicalOperation/Operation/code}" displayName="{SurgicalOperation/Operation/displayName}" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表(ICD-9-CM)"/>
									<statusCode/>
									<!--手术操作目标部位名称DE06.00.187.00-->
									<targetSiteCode value="{SurgicalOperation/TargetSite}"/>
									<!--手术及操作名称-->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN ">
											<code code="DE06.00.094.00" displayName="手术及操作名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="ST"><xsl:value-of select="SurgicalOperation/Name"/></value>
										</observation>
									</entryRelationship>
									<!--介入物名称-->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS " moodCode="EVN ">
											<code code="DE08.50.037.00" displayName="介入物名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="ST"><xsl:value-of select="SurgicalOperation/InterventionName"/></value>
										</observation>
									</entryRelationship>
									<!--操作方法-->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN ">
											<code code="DE06.00.251.00" displayName="操作方法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="ST"><xsl:value-of select="SurgicalOperation/OperationMethod"/></value>
										</observation>
									</entryRelationship>
									<!--操作次数-->
									<entryRelationship typeCode="COMP ">
										<observation classCode="OBS" moodCode="EVN ">
											<code code="DE06.00.250.00" displayName="操作次数" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="PQ" value="{SurgicalOperation/OperationTimes}" unit="次"/>
										</observation>
									</entryRelationship>
								</procedure>
							</entry>
							<!--抢救措施-->
							<entry>
								<procedure classCode="ACT" moodCode="EVN ">
									<code code="DE06.00.094.00" displayName="抢救措施" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<text xsi:type="ST"><xsl:value-of select="SurgicalOperation/RescueMeasures"/></text>
								</procedure>
							</entry>
							<!--抢救开始日期时间-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.221.00" displayName="抢救开始日期时间" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="TS" value="{SurgicalOperation/RescueStartTime}"/>
								</observation>
							</entry>
							<!--抢救结束日期时间-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.218.00" displayName="抢救结束日期时间" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="TS" value="{SurgicalOperation/RescueEndTime}"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--实验室检查章节1..1 R-->
					<component>
						<section>
							<code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="STUDIES SUMMARY"/>
							<text/>
							<!--检查/检验项目-->
							<entry>
								<observation classCode="OBS " moodCode="EVN ">
									<code code="DE04.30.020.00" displayName="检查/检验项目名称" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST"><xsl:value-of select="LaboratoryExamination/InspectName"/></value>
									<entryRelationship typeCode="COMP">
										<!--检查/检验结果-->
										<observation classCode="OBS " moodCode="EVN ">
											<code code="DE04.30.009.00" displayName="检查/检验结果" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="ST"><xsl:value-of select="LaboratoryExamination/InspectResultContent"/></value>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<!--检查/检验定量结果-->
										<observation classCode="OBS " moodCode="EVN ">
											<code code="DE04.30.015.00" displayName="检查/检验定量结果" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="PQ" value="{LaboratoryExamination/ResultValue}" unit="uIu/ml"/>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<!--检查/检验结果代码-->
										<observation classCode="OBS " moodCode="EVN ">
											<code code="DE04.30.017.00" displayName="检查/检验结果代码" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="CD" code="{LaboratoryExamination/Result/code}" displayName="{LaboratoryExamination/Result/displayName}" codeSystem="2.16.156.10011.2.3.2.38" codeSystemName="检查/检验结果代码表"/>
											<!--1.正常 2.异常 3.不确定-->
										</observation>
									</entryRelationship>
								</observation>
							</entry>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
