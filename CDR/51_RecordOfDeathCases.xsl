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
			<!-- 主任医师签名 -->
			<authenticator>
				<time value="{authenticator/AttendingDoctor/Time}"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="医务人员编码"/>
					<code displayName="主任医师"/>
					<assignedPerson classCode="PSN" determinerCode="INSTANCE">
						<name>
							<xsl:value-of select="authenticator/AttendingDoctor/Name"/>
						</name>
						<professionalTechnicalPosition>
					<professionaltechnicalpositionCode code="{authenticator/AttendingDoctor/ProfessionaltechnicalpositionCode}" codeSystem="2.16.156.10011.2.3.1.209" codeSystemName="专业技术职务类别代码表" displayName="{authenticator/AttendingDoctor/Title}"/>
				</professionalTechnicalPosition>
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
						<name>
							<xsl:value-of select="authenticator/ChiefPhysician/Name"/>
						</name>
						<professionalTechnicalPosition>
					<professionaltechnicalpositionCode code="{authenticator/ChiefPhysician/ProfessionaltechnicalpositionCode}" codeSystem="2.16.156.10011.2.3.1.209" codeSystemName="专业技术职务类别代码表" displayName="{authenticator/ChiefPhysician/Title}"/>
				</professionalTechnicalPosition>
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
						<name>
							<xsl:value-of select="authenticator/Inpatient/Name"/>
						</name>
						<professionalTechnicalPosition>
					<professionaltechnicalpositionCode code="{authenticator/Inpatient/ProfessionaltechnicalpositionCode}" codeSystem="2.16.156.10011.2.3.1.209" codeSystemName="专业技术职务类别代码表" displayName="{authenticator/Inpatient/Title}"/>
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
					<!--死亡原因章节 -->
					<component>
						<section>
							<code displayName="死亡原因"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="直接死亡原因名称"/>
									<value xsi:type="ST"><xsl:value-of select="DeathCause/DirectCause"/></value>
									<entryRelationship typeCode="CAUS">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.01.021.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="直接死亡原因编码"/>
											<value xsi:type="CD" code="{DeathCause/DirectCauseCode/code}" displayName="{DeathCause/DirectCauseCode/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
						</section>
					</component>
					<!--诊断章节-->
					<component>
						<section>
							<code code="11535-2" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="死亡诊断名称"/>
									<value xsi:type="ST"><xsl:value-of select="Diagnosis/DeathDiagnosis/Name"/></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.01.021.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="死亡诊断编码"/>
											<value xsi:type="CD" code="{Diagnosis/DeathDiagnosis/code}" displayName="{Diagnosis/DeathDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
						</section>
					</component>
					<!--讨论内容章节-->
					<component>
						<section>
							<code code="DE06.00.181.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName=" 卫生信息数据元目录" displayName="死亡讨论记录"/>
							<text><xsl:value-of select=" DiscussionContent"/></text>
						</section>
					</component>
					<!--讨论总结章节 -->
					<component>
						<section>
							<code code="DE06.00.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName=" 卫生信息数据元目录" displayName="主持人总结意见"/>
							<text><xsl:value-of select="DiscussionSummary"/></text>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
