<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/SurgicalOperation.xsl"/>
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
						<!--xsl:apply-templates select="Encounter/Patient" mode="Age"/-->
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
						<name>
							<xsl:value-of select="authenticator/AttendingDoctor/Name"/>
						</name>
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
			<component>
				<structuredBody>
					<!--入院诊断章节-->
					<xsl:comment>入院诊断章</xsl:comment>
					<component>
						<section>
							<code code="11535-2" displayName="HOSPITAL DISCHARGE DX" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.092.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院日期时间"/>
									<value xsi:type="TS" value="{HospitolDiagnoses/Admission}"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断编码"/>
									<value xsi:type="CD" code="{HospitolDiagnoses/DiagnosticCode/code}" displayName="{HospitolDiagnoses/DiagnosticCode/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.148.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院情况"/>
									<value xsi:type="ST"><xsl:value-of select="HospitolDiagnoses/Admission"/></value>
								</observation>
							</entry>
						</section>
					</component>
					<!--住院过程章节-->
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
					<!--死亡原因章节-->
					<xsl:comment>死亡原因</xsl:comment>
					<component>
						<section>
							<code displayName="死亡原因章节"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.01.036.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="死亡日期时间"/>
									<value xsi:type="TS" value="{DeathCause/Time}"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="直接死亡原因名称"/>
									<value xsi:type="ST"><xsl:value-of select="DeathCause/DirectCause"/></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="直接死亡原因编码"/>
											<value xsi:type="CD" code="{DeathCause/DirectCauseCode/code}" displayName="{DeathCause/DirectCauseCode/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
						</section>
					</component>
					<!--诊断章节-->
					<xsl:comment>诊断</xsl:comment>
					<component>
						<section>
							<code code="11535-2" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="死亡诊断名称"/>
									<value xsi:type="ST"><xsl:value-of select="Diagnosis/DeathDiagnosis/Name"/></value>
									<entryRelationship typeCode="CAUS">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="死亡诊断编码"/>
											<value xsi:type="CD" code="{Diagnosis/DeathDiagnosis/code}" displayName="{Diagnosis/DeathDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
						</section>
					</component>
					<!--尸检意见章节-->
					<xsl:comment>尸检意见</xsl:comment>
					<component>
						<section>
							<code displayName="尸检意见章节"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE09.00.115.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="家属是否同意尸体解剖标志"/>
									<value xsi:type="BL" value="{AutopsyOpinion}"/>
								</observation>
							</entry>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
