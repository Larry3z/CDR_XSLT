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
			<!-- 医师签名 1..1 -->
			<authenticator>
				<time value="{authenticator/time}"/>
				<signatureCode/>
				<assignedEntity>
					<id root="2.16.156.10011.1.4" extension="医务人员编号"/>
					<code code="医师"/>
					<assignedPerson>
						<name><xsl:value-of select="authenticator/name"/></name>
					</assignedPerson>
				</assignedEntity>
			</authenticator>
			<!--联系人 -->
			<participant typeCode="NOT">
				<!--联系人@classCode：CON，固定值，表示角色是联系人 -->
				<associatedEntity classCode="ECON">
					<!--联系人电话-->
					<telecom value="{Contacts/Phone}"/>
					<!--联系人-->
					<associatedPerson>
						<!--姓名-->
						<name><xsl:value-of select="Contacts/Name"/></name>
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
					<!--手术操作章节-->
					<xsl:comment>手术操作章节</xsl:comment>
					<component>
						<section>
							<code code="47519-4" displayName="HISTORY OF PROCEDURES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!-- 手术及操作编码 DE06.00.093.00 -->
							<entry>
								<procedure classCode="PROC" moodCode="EVN">
									<code xsi:type="CD" code="{SurgicalOperation/Operation/code}" displayName="{SurgicalOperation/Operation/displayName}" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表(ICD-9-CM)"/>
								</procedure>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.094.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术名称"/>
									<value xsi:type="ST"><xsl:value-of select="SurgicalOperation/Name"/></value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.187.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术目标部位名称"/>
									<value xsi:type="ST"><xsl:value-of select="SurgicalOperation/SurgicalSite"/></value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.221.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术日期时间"/>
									<value xsi:type="TS" value="{SurgicalOperation/OperationTime}"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.073.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉方法代码"/>
									<value xsi:type="CD" code="{SurgicalOperation/Anaesthesia/code}" displayName="{SurgicalOperation/Anaesthesia/displayName}" codeSystem="2.16.156.10011.2.3.1.159" codeSystemName="麻醉方法代码表"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.063.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术过程"/>
									<value xsi:type="ST"><xsl:value-of select="SurgicalOperation/OperationProcess"/></value>
								</observation>
							</entry>
						</section>
					</component>
					<!--术后诊断章节-->
					<xsl:comment>术后诊断章节</xsl:comment>
					<component>
						<section>
							<code code="10218-6" displayName="Surgical operation note postoperative Dx" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术后诊断名称"/>
									<value xsi:type="ST"><xsl:value-of select="PreoperativeDiagnosis/Name"/></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术后诊断编码"/>
											<value xsi:type="CD" code="{PreoperativeDiagnosis/code}" displayName="{PreoperativeDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.070.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="诊断依据"/>
									<value xsi:type="ST"><xsl:value-of select="PreoperativeDiagnosis/DiagnosticBasis"/></value>
								</observation>
							</entry>
						</section>
					</component>
					<!--注意事项章节-->
					<xsl:comment>注意事项章节</xsl:comment>
					<component>
						<section>
							<code code="DE09.00.119.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName=" 卫生信息数据元目录" displayName="注意事项章节"/>
							<text value="{PreoperativeDiagnosis/Attention}"/>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
