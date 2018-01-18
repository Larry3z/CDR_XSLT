<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<!--xsl:include href="CDA-Support-Files/Export/Section-Modules/Encounter.xsl"/-->
	<xsl:include href="CDA-Support-Files/Export/Common/Histories.xsl"/>
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
						<xsl:apply-templates select="Encounter/Patient" mode="BirthTime"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Age"/>
					</patient>
				</patientRole>
			</recordTarget>
			<!--作者，保管机构-->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!--主要参与者签名 legalAuthenticator-->
			<xsl:comment>kaishi</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='医师']" mode="legalAuthenticator"/>
			<!--以下省略很多机构签名等等 -->
			<relatedDocument typeCode="RPLC">
				<!--文档中医疗卫生事件的就诊场景,即入院场景记录-->
				<parentDocument>
					<id/>
					<setId/>
					<versionNumber/>
				</parentDocument>
			</relatedDocument>
			<!-- 病床号、病房、病区、科室和医院的关联 -->
			<!--文档体-->
			<component>
				<structuredBody>
					<!-- 过敏史章节 -->
					<component>
						<section>
							<code code="48765-2" displayName="Allergies, adverse reactions, alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.023.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="过敏史标志"/>
									<value xsi:type="BL" value="true"/>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.01.022.00" displayName="过敏史" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/Allergies/Allergy/FreeTextAllergy"/>
											</value>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
						</section>
					</component>
					<!--主诉章节-->
					<component>
						<section>
							<code code="10154-3" displayName="CHIEF COMPLAINT" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--主诉条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.01.119.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="主诉"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/Section/textContent"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--现病史章节-->
					<xsl:apply-templates select="." mode="Present"/>
					
					<!-- 既往史章节 -->
					<xsl:value-of select="/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:04:07Z']/NoteText"/>
					<component>
						<section>
							<code code="11348-0" displayName="HISTORY OF PAST ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<xsl:apply-templates select="." mode="Past"/>
						</section>
					</component>
					<!--体格检查章节-->
					<component>
						<section>
							<code code="29545-1" displayName="PHYSICAL EXAMINATION" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--体格检查-一般状况检查结果-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.10.258.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体格检查"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/PhysicalExam"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!-- 实验室检验章节 -->
					<component>
						<section>
							<code code="30954-2" displayName="STUDIES SUMMARY" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<organizer classCode="CLUSTER" moodCode="EVN">
									<statusCode/>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE04.30.010.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="辅助检查项目"/>
										</observation>
									</component>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE04.30.009.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="辅助检查结果"/>
											<value xsi:type="ST"/>
											<xsl:value-of select="/Document/Auxiliary"/>
										</observation>
									</component>
								</organizer>
							</entry>
						</section>
					</component>
					<!-- 诊断记录章节 -->
					<component>
						<section>
							<code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--初诊标志代码-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.196.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="初诊标志代码"/>
									<value xsi:type="CD" code="1" codeSystem="2.16.156.10011.2.3.2.39" codeSystemName="初诊标志代码表" displayName="初诊"/>
								</observation>
							</entry>
							<!--中医“四诊”观察结果-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.028.00" displayName="中医“四诊”观察结果" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/Observation"/>
									</value>
								</observation>
							</entry>
							<!--条目：诊断-->
							<entry>
								<organizer classCode="CLUSTER" moodCode="EVN">
									<statusCode/>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.01.025.00" displayName="诊断名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/Diagnosis/Name"/>
											</value>
										</observation>
									</component>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.01.024.00" displayName="诊断代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="CD" code="B95.100" displayName="B族链球菌感染" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
										</observation>
									</component>
								</organizer>
							</entry>
							<entry>
								<organizer classCode="CLUSTER" moodCode="EVN">
									<statusCode/>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.172.00" displayName="中医病名名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
												<qualifier>
													<name displayName="中医病名名称"/>
												</qualifier>
											</code>
											<value xsi:type="ST"><xsl:value-of select="/Document/MedicalIlness"/></value>
										</observation>
									</component>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.130.00" displayName="中医病名代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
												<qualifier>
													<name displayName="中医病名代码"/>
												</qualifier>
											</code>
											<value xsi:type="CD" code="BEA" displayName="儿科癌病类" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表(GB/T 15657)"/>
										</observation>
									</component>
								</organizer>
							</entry>
							<entry>
								<organizer classCode="CLUSTER" moodCode="EVN">
									<statusCode/>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.172.00" displayName="中医证候名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
												<qualifier>
													<name displayName="中医证候名称"/>
												</qualifier>
											</code>
											<value xsi:type="ST"><xsl:value-of select="/Document/name1"/></value>
										</observation>
									</component>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.130.00" displayName="中医证候代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
												<qualifier>
													<name displayName="中医证候代码"/>
												</qualifier>
											</code>
											<value xsi:type="CD" code="BNP050" displayName="呕吐病" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
										</observation>
									</component>
								</organizer>
							</entry>
						</section>
					</component>
					<!-- 治疗计划章节 -->
					<component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--辨证依据描述-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.132.00" displayName="辨证依据" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/Dialectical"/></value>
								</observation>
							</entry>
							<!--治则治法-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.300.00" displayName="治则治法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/Law"/></value>
								</observation>
							</entry>
						</section>
					</component>
					<!--医嘱章节-->
					<component>
						<section>
							<code code="46209-3" codeSystem="2.16.840.1.113883.6.1" displayName="Provider
Orders" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<organizer classCode="CLUSTER" moodCode="EVN">
									<statusCode/>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.289.00" displayName="医嘱项目类型" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="CD" code="01" displayName="药品类医嘱" codeSystem="2.16.156.10011.2.3.1.268" codeSystemName="医嘱项目类型代码表"/>
										</observation>
									</component>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.288.00" displayName="医嘱项目内容" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<effectiveTime>
												<!--医嘱计划开始日期时间-->
												<low value="{/Document/RadOrder/CreationTime}"/>
												<!--医嘱计划结束日期时间-->
												<high value="{/Document/RadOrder/LastTime}"/>
											</effectiveTime>
											<!--医嘱计划信息-->
											<value xsi:type="ST"><xsl:value-of select="/Document/Comments"/></value>
											<!--执行者-->
											<performer>
												<!--医嘱执行日期时间：DE06.00.222.00-->
												<time value="{/Document/RadOrder/OrderedBy/time1}"/>
												<assignedEntity>
													<id root="2.16.156.10011.1.4"/>
													<!--角色-->
													<code displayName="医嘱执行者"/>
													<!--医嘱执行者签名：DE02.01.039.00-->
													<assignedPerson>
														<name><xsl:value-of select="/Document/RadOrder/OrderedBy/Name1"/></name>
													</assignedPerson>
													<!--医嘱执行科室：DE08.10.026.00-->
													<representedOrganization>
														<name><xsl:value-of select="/Document/RadOrder/OrderedBy/Organizaton1"/></name>
													</representedOrganization>
												</assignedEntity>
											</performer>
											<!--作者：医嘱开立者-->
											<author>
												<!--医嘱开立日期时间：DE06.00.220.00-->
												<time value="{/Document/RadOrder/OrderedBy/time2}"/>
												<assignedAuthor>
													<id root="2.16.156.10011.1.4"/>
													<!--角色-->
													<code displayName="医嘱开立者"/>
													<!--医嘱开立者签名：DE02.01.039.00-->
													<assignedPerson>
														<name><xsl:value-of select="/Document/RadOrder/OrderedBy/Name2"/></name>
													</assignedPerson>
													<!--医嘱开立科室：DE08.10.026.00-->
													<representedOrganization>
														<name><xsl:value-of select="/Document/RadOrder/OrderedBy/Organizaton2"/></name>
													</representedOrganization>
												</assignedAuthor>
											</author>
											<!--医嘱审核-->
											<participant typeCode="ATND">
												<!--医嘱审核日期时间：DE09.00.088.00-->
												<time value="{/Document/RadOrder/OrderedBy/time3}"/>
												<participantRole classCode="ASSIGNED">
													<id root="2.16.156.10011.1.4"/>
													<!--角色-->
													<code displayName="医嘱审核人"/>
													<!--医嘱审核人签名：DE02.01.039.00-->
													<playingEntity classCode="PSN" determinerCode="INSTANCE">
														<name><xsl:value-of select="/Document/RadOrder/OrderedBy/Name3"/></name>
													</playingEntity>
												</participantRole>
											</participant>
											<!--医嘱取消-->
											<participant typeCode="ATND">
												<!--医嘱取消日期时间：DE06.00.234.00-->
												<time value="{/Document/RadOrder/OrderedBy/time4}"/>
												<participantRole classCode="ASSIGNED">
													<id root="2.16.156.10011.1.4"/>
													<!--角色-->
													<code displayName="医嘱取消人"/>
													<!--取消医嘱者签名：DE02.01.039.00-->
													<playingEntity classCode="PSN" determinerCode="INSTANCE">
														<name><xsl:value-of select="/Document/RadOrder/OrderedBy/Name4"/></name>
													</playingEntity>
												</participantRole>
											</participant>
											<!--医嘱备注信息-->
											<entryRelationship typeCode="COMP">
												<observation classCode="OBS" moodCode="EVN">
													<code code="DE06.00.179.00" displayName="医嘱备注
信息" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
													<value xsi:type="ST"><xsl:value-of select="/Document/RadOrder/Description"/></value>
												</observation>
											</entryRelationship>
											<!--医嘱执行状态-->
											<entryRelationship typeCode="COMP">
												<observation classCode="OBS" moodCode="EVN">
													<code code="DE06.00.290.00" displayName="医嘱执行
状态" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
													<value xsi:type="ST"><xsl:value-of select="/Document/RadOrder/Status"/></value>
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
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
