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
					<!--生命体征章节-->
					<component>
						<section>
							<code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="VITAL SIGNS"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.10.188.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体重"/>
									<!--N:定为生命体征，疑问-->
									<value xsi:type="PQ" value="{VitalSigns/Weight}" unit="kg"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--医嘱章节-->
					<component>
						<section>
							<!--N:!!!-->
							<code code="46209-3" codeSystem="2.16.840.1.113883.6.1" displayName="Provider Orders" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.286.00" displayName="医嘱类别" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="{Order/Category/code}" displayName="{Order/Category/displayName}" codeSystem="2.16.156.10011.2.3.2.58" codeSystemName="医嘱类别代码表"/>
								</observation>
							</entry>
							<entry>
								<organizer classCode="CLUSTER" moodCode="EVN">
									<statusCode/>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.289.00" displayName="医嘱项目类型" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="CD" code="{Order/ProjectType/code}" displayName="{Order/ProjectType/displayName}" codeSystem="2.16.156.10011.2.3.1.268" codeSystemName="医嘱项目类型代码表"/>
										</observation>
									</component>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.288.00" displayName="医嘱项目内容" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<effectiveTime>
												<!--医嘱计划开始日期时间-->
												<low value="{Order/PlanStartTime}"/>
												<!--医嘱计划结束日期时间-->
												<high value="{Order/PlanEndTime}"/>
											</effectiveTime>
											<!--医嘱计划信息-->
											<value xsi:type="ST"><xsl:value-of select="Order/PlanningInformation"/></value>
											<!--作者：医嘱开立者-->
											<author>
												<!--医嘱开立日期时间：DE06.00.220.00-->
												<time value="{Order/OpenInformation/Time}"/>
												<assignedAuthor>
													<id root="2.16.156.10011.1.4" extension="80456"/>
													<code displayName="医嘱开立者"/>
													<!--医嘱开立者签名：DE02.01.039.00-->
													<assignedPerson>
														<name><xsl:value-of select="Order/OpenInformation/Person"/></name>
													</assignedPerson>
													<!--医嘱开立科室：DE08.10.026.00-->
													<representedOrganization>
														<name><xsl:value-of select="Order/OpenInformation/Department"/></name>
													</representedOrganization>
												</assignedAuthor>
											</author>
											<!--医嘱审核-->
											<participant typeCode="ATND">
												<!--医嘱审核日期时间：DE09.00.088.00-->
												<time value="{Order/ToExamine/Time}"/>
												<participantRole classCode="ASSIGNED">
													<id root="2.16.156.10011.1.4" extension="81426"/>
													<!--角色-->
													<code displayName="医嘱审核人"/>
													<!--医嘱审核人签名：DE02.01.039.00-->
													<playingEntity classCode="PSN" determinerCode="INSTANCE">
														<name><xsl:value-of select="Order/ToExamine/Person"/></name>
													</playingEntity>
												</participantRole>
											</participant>
											<!--医嘱核对-->
											<participant typeCode="ATND">
												<!--医嘱核对日期时间：DE06.00.205.00-->
												<time value="{Order/Check/Time}"/>
												<participantRole classCode="ASSIGNED">
													<id root="2.16.156.10011.1.4" extension="121212"/>
													<!--角色-->
													<code displayName="医嘱核对人"/>
													<!--医嘱核对护士签名：DE02.01.039.00-->
													<playingEntity classCode="PSN" determinerCode="INSTANCE">
														<name><xsl:value-of select="Order/Check/Person"/></name>
													</playingEntity>
												</participantRole>
											</participant>
											<!--医嘱停止-->
											<participant typeCode="ATND">
												<!--医嘱停止日期时间：DE06.00.218.00-->
												<time value="{Order/Stop/Time}"/>
												<participantRole classCode="ASSIGNED">
													<id root="2.16.156.10011.1.4" extension="80456"/>
													<!--角色-->
													<code displayName="医嘱停止人"/>
													<!--停止医嘱者签名：DE02.01.039.00-->
													<playingEntity classCode="PSN" determinerCode="INSTANCE">
														<name><xsl:value-of select="Order/Stop/Person"/></name>
													</playingEntity>
												</participantRole>
											</participant>
											<!--医嘱取消-->
											<participant typeCode="ATND">
												<!--医嘱取消日期时间：DE06.00.234.00-->
												<time value="{Order/Cancel/Time}"/>
												<participantRole classCode="ASSIGNED">
													<id root="2.16.156.10011.1.4" extension="12121211212"/>
													<!--角色-->
													<code displayName="医嘱取消人"/>
													<!--取消医嘱者签名：DE02.01.039.00-->
													<playingEntity classCode="PSN" determinerCode="INSTANCE">
														<name><xsl:value-of select="Order/Cancel/Person"/></name>
													</playingEntity>
												</participantRole>
											</participant>
											<!--医嘱备注信息-->
											<entryRelationship typeCode="COMP">
												<observation classCode="OBS" moodCode="EVN">
													<code code="DE06.00.179.00" displayName="医嘱备注 信息" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
													<value xsi:type="ST"/>
												</observation>
											</entryRelationship>
											<!--医嘱执行状态-->
											<entryRelationship typeCode="COMP">
												<observation classCode="OBS" moodCode="EVN">
													<code code="DE06.00.290.00" displayName="医嘱执行状态" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
													<value xsi:type="ST"><xsl:value-of select="Order/Implement/State"/></value>
													<!--执行者-->
													<performer>
														<!--医嘱执行日期时间：DE06.00.222.00-->
														<time value="{Order/Implement/State}"/>
														<assignedEntity>
															<id root="2.16.156.10011.1.4" extension="5732"/>
															<code displayName="医嘱执行者"/>
															<!--医嘱执行者签名：DE02.01.039.00-->
															<assignedPerson>
																<name><xsl:value-of select="Order/Implement/Person"/></name>
															</assignedPerson>
															<!--医嘱执行科室：DE08.10.026.00-->
															<representedOrganization>
																<name><xsl:value-of select="Order/Implement/Department"/></name>
															</representedOrganization>
														</assignedEntity>
													</performer>
												</observation>
											</entryRelationship>
											<!--电子申请单编号：例如检查检验申请单编号？？？-->
											<entryRelationship typeCode="COMP">
												<observation classCode="OBS" moodCode="EVN">
													<code code="DE01.00.008.00" displayName="电子申请单编号" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
													<value xsi:type="ST"><xsl:value-of select="Order/ElectronicApplicationNumber"/></value>
												</observation>
											</entryRelationship>
											<!--处方药品组号：例如如果是用药医嘱的话指向处方单
号？？？-->
											<entryRelationship typeCode="COMP">
												<observation classCode="OBS" moodCode="EVN">
													<code code="DE08.50.056.00" displayName="处方药品组号" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
													<value xsi:type="ST"><xsl:value-of select="Order/PrescriptionDrugsNumberst"/></value>
												</observation>
											</entryRelationship>
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
