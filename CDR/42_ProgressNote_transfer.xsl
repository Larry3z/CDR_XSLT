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
			<!-- 签名 -->
			<authenticator>
				<!--转出日期时间-->
				<time value="000000000000"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="76452"/>
					<code displayName="转出医师签名"/>
					<assignedPerson>
						<name>
							<xsl:value-of select="assignedPerson2"/>
						</name>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<authenticator>
				<!--转入日期时间-->
				<time value="000000000000"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="76452"/>
					<code displayName="转入医师签名"/>
					<assignedPerson>
						<name>
							<xsl:value-of select="assignedPerson2"/>
						</name>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<!--关联活动信息 1..R-->
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
			<!--文档体-->
			<component>
				<structuredBody>
					<!--主诉章节：主诉条目 1..1 R-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<!--入院诊断章节1..1 R-->
					<xsl:comment>入院诊断章节</xsl:comment>
					<component>
						<section>
							<!--入院情况 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--入院诊断-西医诊编码 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--入院诊断-中医病名代码 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--入院诊断-中医证候代码 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
					<!--入诊断记录章节1..1 R-->
					<xsl:comment>诊断记录章节</xsl:comment>
					<component>
						<section>
							<!--目前情况 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							
							<!--目前诊断-西医诊断编码 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--目前诊断- 中医病名代码 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--目前诊断- 中医证候代码 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
					
					<!--治疗计划章节1..1 R-->
					<xsl:comment>治疗计划章节</xsl:comment>
					<component>
						<section>
							<!--治疗计划条目：转入诊疗计划 患者转入科室后的诊疗计划，具体的检查、中西医治疗措施及中
医调护 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--治则治法 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--注意事项 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
					<!--转科记录章节1..1 R-->
					<xsl:comment>专科记录章节</xsl:comment>
					<component>
						<section>
							<!--转科记录类型条目 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--转出科室 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--转入科室 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--转科目的 1..1 R -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
					<!--用药章节1..1 R-->
					<xsl:comment>用药章节</xsl:comment>
					<component>
						<section>
							<!--中药处方医嘱内容 0..1 O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--中药煎煮法 0..1 O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
							<!--中药用药方法 0..1 O -->
							<xsl:apply-templates select="Sections/Section" mode="mode"/>
						</section>
					</component>
					<!--住院过程章节：诊疗过程描述 1..1 R-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
