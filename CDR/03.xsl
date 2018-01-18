<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/Histories.xsl"/>
	<!--xsl:include href="CDA-Support-Files/Export/Section-Modules/Encounter.xsl"/-->
	<xsl:template match="/Document">
		<ClinicalDocument xmlns:mif="urn:hl7-org:v3/mif" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:hl7-org:v3">
			<xsl:apply-templates select="." mode="CDAHeader"/>
			<code code="C0003" codeSystem="2.16.156.10011.2.4" codeSystemName="卫生信息共享文档规范编码体系"/>
			<title>急诊留观病历</title>
			<!-- 医师签名 -->
			<!--legalAuthenticator>
		<time/>
		<signatureCode/>
		<assignedEntity>
			<id root="2.16.156.10011.1.4" extension="医务人员编号"/>
			<code displayName="责任医生"/>
			<assignedPerson>
				<name>责任医生姓名</name>
			</assignedPerson>
		</assignedEntity>
	</legalAuthenticator>
	<relatedDocument typeCode="RPLC">
		<parentDocument>
			<id/>
			<setId/>
			<versionNumber/>
		</parentDocument>
	</relatedDocument-->
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
									<entryRelationship typeCode="SUBJ">
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
					<!-- 主诉章节 -->
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
					<component>
						<section>
							<code code="11348-0" displayName="HISTORY OF PAST ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.099.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="既往史"/>
									<xsl:apply-templates select="." mode="Past"/>
								</observation>
							</entry>
						</section>
					</component>
					<!-- 体格检查章节 -->
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
											<value xsi:type="ST">
												<xsl:value-of select="/Document/Auxiliary"/>
											</value>
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
											<value xsi:type="ST">
												<xsl:value-of select="/Document/MedicalIlness"/>
											</value>
										</observation>
									</component>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.130.00" displayName="中医病名代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
												<qualifier>
													<name displayName="中医病名代码"/>
												</qualifier>
											</code>
											<value xsi:type="CD" code="1" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表（ GB/T 15657）"/>
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
											<value xsi:type="ST">
												<xsl:value-of select="/Document/name1"/>
											</value>
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
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.132.00" displayName="辨证依据" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<text>
										<xsl:value-of select="/Document/Dialectical"/>
									</text>
								</observation>
							</entry>
							<!--治则治法-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.300.00" displayName="治则治法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="01" codeSystem="2.16.156.10011.2.3.3.15" codeSystemName="治则治法代码表（GB/T 16751.3-1997）"/>
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
											<value xsi:type="ST">
												<xsl:value-of select="/Document/Comments"/>
											</value>
											<!--执行者-->
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
														<name>
															<xsl:value-of select="/Document/RadOrder/OrderedBy/Name1"/>
														</name>
													</assignedPerson>
													<!--医嘱执行科室：DE08.10.026.00-->
													<representedOrganization>
														<name>
															<xsl:value-of select="/Document/RadOrder/OrderedBy/Organizaton1"/>
														</name>
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
														<name>
															<xsl:value-of select="/Document/RadOrder/OrderedBy/Name2"/>
														</name>
													</assignedPerson>
													<!--医嘱开立科室：DE08.10.026.00-->
													<representedOrganization>
														<name>
															<xsl:value-of select="/Document/RadOrder/OrderedBy/Organizaton2"/>
														</name>
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
														<name>
															<xsl:value-of select="/Document/RadOrder/OrderedBy/Name3"/>
														</name>
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
														<name>
															<xsl:value-of select="/Document/RadOrder/OrderedBy/Name4"/>
														</name>
													</playingEntity>
												</participantRole>
											</participant>
											<!--医嘱备注信息-->
											<entryRelationship typeCode="COMP">
												<observation classCode="OBS" moodCode="EVN">
													<code code="DE06.00.179.00" displayName="医嘱备注
信息" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
													<value xsi:type="ST">
														<xsl:value-of select="/Document/RadOrder/Description"/>
													</value>
												</observation>
											</entryRelationship>
											<!--医嘱执行状态-->
											<entryRelationship typeCode="COMP">
												<observation classCode="OBS" moodCode="EVN">
													<code code="DE06.00.290.00" displayName="医嘱执行
状态" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
													<value xsi:type="ST">
														<xsl:value-of select="/Document/RadOrder/Status"/>
													</value>
												</observation>
											</entryRelationship>
										</observation>
									</component>
								</organizer>
							</entry>
						</section>
					</component>
					<!-- 手术操作章节 -->
					<component>
						<section>
							<code code="47519-4" displayName="HISTORY OF PROCEDURES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<!-- 1..1 手术记录 -->
								<procedure classCode="PROC" moodCode="EVN">
									<code code="84.51004" displayName="金属脊椎融合物置入术" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表(ICD-9-CM)"/>
									<statusCode/>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.094.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术（操作）名称"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/OperationTechnique/name"/>
											</value>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.093.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术及操作目标部位名称"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/OperationTechnique/position"/>
											</value>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE08.50.037.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="介入物名称"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/OperationTechnique/intervene"/>
											</value>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.251.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="操作方法描述"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/OperationTechnique/way"/>
											</value>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.250.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="操作次数"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/OperationTechnique/times"/>
											</value>
										</observation>
									</entryRelationship>
								</procedure>
							</entry>
						</section>
					</component>
					<!-- 抢救记录章节 -->
					<component>
						<section>
							<code displayName="抢救记录章节"/>
							<text/>
							<!-- 急诊抢救记录 抢救开始日期时间 抢救结束日期时间 急诊抢救记录 -->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.181.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="急诊抢救记录"/>
									<effectiveTime>
										<low value="{/Document/SaveRecord/lowtime}"/>
										<high value="{/Document/SaveRecord/hightime
										}"/>
									</effectiveTime>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/SaveRecord/record"/>
									</value>
									<entryRelationship typeCode="COMP">
										<organizer classCode="CLUSTER" moodCode="EVN">
											<statusCode/>
											<!-- 参加抢救人员名单 -->
											<component>
												<observation classCode="OBS" moodCode="EVN">
													<code code="DE08.30.032.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="参加抢救人员名
单"/>
													<value xsi:type="ST">
														<xsl:value-of select="/Document/SaveRecord/people"/>
													</value>
												</observation>
											</component>
											<!-- 专业技术职务类别代码 -->
											<component>
												<observation classCode="OBS" moodCode="EVN">
													<code code="DE08.30.031.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="专业技术职务类
别代码"/>
													<value xsi:type="CD" code="1" codeSystem="2.16.156.10011.2.3.1.209" codeSystemName="专业技术职务类别代码表"/>
												</observation>
											</component>
										</organizer>
									</entryRelationship>
								</observation>
							</entry>
						</section>
					</component>
					<!-- 住院过程章节 -->
					<component>
						<section>
							<code code="8648-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Hospital Course"/>
							<text/>
							<!-- 急诊留观病程记录 -->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.181.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="急诊留观病程记录"/>
									<!-- 收入观察室日期时间 -->
									<effectiveTime value="20120303111213"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/HospitalProcess/text"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!-- 其他相关信息章节 -->
					<component>
						<section>
							<code displayName="其他相关信息"/>
							<text/>
							<!-- 注意事项 -->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE09.00.119.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="注意事项"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/RelatedInfoemation/matters"/>
									</value>
								</observation>
							</entry>
							<!-- 患者去向代码 -->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.185.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="患者去向代码"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/RelatedInfoemation/ID"/>
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
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
