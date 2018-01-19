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
					<!--讨论的日期时间-->
					<providerOrganization classCode="ORG" determinerCode="INSTANCE">
						<asOrganizationPartOf classCode="PART">
							<!--讨论时间 -->
							<effectiveTime value="{Discuss/Time}"/>
							<wholeOrganization>
								<addr>
									<xsl:value-of select="Discuss/Place"/>
								</addr>
							</wholeOrganization>
						</asOrganizationPartOf>
					</providerOrganization>
				</patientRole>
			</recordTarget>
			<!-- 作者 -->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<!-- 保管机构 -->
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!-- 签名 1..1 -->
			<authenticator>
				<!-- DE09.00.053.00签名日期时间 -->
				<time value="{authenticator/SurgicalSignature/Surgeon/Time}"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="-"/>
					<code displayName="手术者"/>
					<assignedPerson>
						<name>
							<xsl:value-of select="authenticator/SurgicalSignature/Surgeon/Name"/>
						</name>
						<professionalTechnicalPosition>
							<professionaltechnicalpositionCode code="{authenticator/SurgicalSignature/Surgeon/ProfessionaltechnicalpositionCode}" codeSystem="2.16.156.10011.2.3.1.209" codeSystemName="专业技术职务类别代码表" displayName="{authenticator/SurgicalSignature/Surgeon/Title}"/>
						</professionalTechnicalPosition>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<authenticator>
				<!-- DE09.00.053.00签名日期时间 -->
				<time value="{authenticator/SurgicalSignature/Anesthesiologist/Time}"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="-"/>
					<code displayName="麻醉医师"/>
					<assignedPerson>
						<name>
							<xsl:value-of select="authenticator/SurgicalSignature/Anesthesiologist/Name"/>
						</name>
						<professionalTechnicalPosition>
							<professionaltechnicalpositionCode code="{authenticator/SurgicalSignature/Anesthesiologist/ProfessionaltechnicalpositionCode}" codeSystem="2.16.156.10011.2.3.1.209" codeSystemName="专业技术职务类别代码表" displayName="{authenticator/SurgicalSignature/Anesthesiologist/Title}"/>
						</professionalTechnicalPosition>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<authenticator>
				<!-- DE09.00.053.00签名日期时间 -->
				<time value="{authenticator/SurgicalSignature/Physician/Time}"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="医务人员编号"/>
					<code displayName="医师"/>
					<assignedPerson>
						<name>
							<xsl:value-of select="authenticator/SurgicalSignature/Physician/Name"/>
						</name>
						<professionalTechnicalPosition>
							<professionaltechnicalpositionCode code="{authenticator/SurgicalSignature/Physician/ProfessionaltechnicalpositionCode}" codeSystem="2.16.156.10011.2.3.1.209" codeSystemName="专业技术职务类别代码表" displayName="{authenticator/SurgicalSignature/Physician/Title}"/>
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
			<!--讨论主持人信息-->
			<participant typeCode="ORG">
				<associatedEntity classCode="ECON">
					<id root="2.16.156.10011.1.4" extension="医务人员编码"/>
					<associatedPerson>
						<!--主持人姓名-->
						<name>
							<xsl:value-of select="Practitioners/Compere"/>
						</name>
					</associatedPerson>
				</associatedEntity>
			</participant>
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
					<!--术前诊断章节-->
					<xsl:comment>术前诊断</xsl:comment>
					<component>
						<section>
							<code code="10219-4" displayName="Surgical operation note preoperative Dx" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术前诊断编码"/>
									<value xsi:type="CD" code="{PreoperativeDiagnosis/code}" displayName="{PreoperativeDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.092.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院日期时间"/>
									<value xsi:type="TS" value="{PreoperativeDiagnosis/DateAdmission}"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--治疗计划章节-->
					<xsl:comment>治疗计划</xsl:comment>
					<component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.094.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="拟实施手术及操作名称"/>
									<value xsi:type="ST"><xsl:value-of select="SurgicalOperation/Name"/></value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.093.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="拟实施手术及操作编码"/>
									<value xsi:type="CD" code="{SurgicalOperation/Operation/code}" displayName="{SurgicalOperation/Operation/displayName}" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表(ICD-9-CM)"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.187.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="拟实施手术目标部位名称"/>
									<value xsi:type="ST"><xsl:value-of select="SurgicalOperation/SurgicalSite"/></value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.221.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="拟实施手术及操作日期时间"/>
									<value xsi:type="TS" value="{SurgicalOperation/OperationTime}"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.073.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="拟实施麻醉方法代码"/>
									<value xsi:type="CD" code="{SurgicalOperation/Anaesthesia/code}" displayName="{SurgicalOperation/Anaesthesia/displayName}" codeSystem="2.16.156.10011.2.3.1.159" codeSystemName="麻醉方法代码表"/>
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
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.254.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术要点"/>
									<value xsi:type="ST"><xsl:value-of select="Operation/OperationPoints"/></value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.271.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术前准备"/>
									<value xsi:type="ST"><xsl:value-of select="Operation/PreoperativePreparation"/></value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.340.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术指征"/>
									<value xsi:type="ST"><xsl:value-of select="Operation/Indications"/></value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.301.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术方案"/>
									<value xsi:type="ST"><xsl:value-of select="Operation/surgicalProgram"/></value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE09.00.119.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="注意事项"/>
									<value xsi:type="ST"><xsl:value-of select="Operation/AttentionMatters"/></value>
								</observation>
							</entry>
						</section>
					</component>
					<!--术前总结章节-->
					<xsl:comment>术前总结</xsl:comment>
					<component>
						<section>
							<code displayName="讨论总结"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="讨论意见"/>
									<value xsi:type="ST"><xsl:value-of select="PreoperativeSummary/DiscussionOpinion"/></value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="讨论结论"/>
									<value xsi:type="ST"><xsl:value-of select="PreoperativeSummary/DiscussionConclusions"/></value>
								</observation>
							</entry>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
