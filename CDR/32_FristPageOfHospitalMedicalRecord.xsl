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
			<recordTarget typeCode="RCT" contextControlCode="OP">
				<patientRole classCode="PAT">
					<!-- 健康卡号 -->
					<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
					<!-- 住院号标识 -->
					<xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/>
					<!-- 病案号标识 -->
					<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
					<!-- 现住址  门牌号、村、乡、县、市、省、邮政编码、联系电话-->
					<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
					<patient classCode="PSN" determinerCode="INSTANCE">
						<!--患者身份证号-->
						<xsl:apply-templates select="Encounter/Patient" mode="IDNo"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<xsl:apply-templates select="Encounter/Patient" mode="BirthTime"/>
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"  婚姻状况代码     /-->
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"   民族代码/-->
						<!-- 出生地 县、市、省、邮政编码-->
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
						<!-- 国籍 -->
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
						<!-- 年龄 -->
						<!--xsl:apply-templates select="Encounter/Patient" mode="Age"/-->
						<!-- 工作单位 -->
						<employerOrganization>
							<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/  名称、电话-->
							<!-- 工作地址 门牌号、村、乡、县、市、省、邮政编码-->
							<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
						</employerOrganization>
						<!-- 户口信息 门牌号、村、乡、县、市、省、邮政编码-->
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
						<!-- 籍贯信息 市、省-->
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
						<!--职业状况-->
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
					</patient>
					<!--提供患者服务机构-->
					<providerOrganization classCode="ORG" determinerCode="INSTANCE">
						<!--机构标识号-->
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
						<!--住院机构名称-->
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
					</providerOrganization>
				</patientRole>
			</recordTarget>
			
			<!--文档体-->
			<component>
		<structuredBody>
			<!--
********************************************************
生命体征章节
********************************************************
-->
			<component>
				<section>
					<code code="8716-3" displayName="VITAL SIGNS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.019.00" displayName="新生儿入院体重（g）" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="PQ" value="{VitalSigns/HWON}" unit="g"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.019.00" displayName="新生儿出生体重（g）" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="PQ" value="{VitalSigns/BWON}" unit="g"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--
********************************************************
诊断记录章节
********************************************************
-->
			<component>
				<section>
					<code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--门（急）诊诊断-中医诊断条目-->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="门（急）诊诊断（中医诊断）名称">
										<qualifier>
											<name displayName="中医诊断名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST"><xsl:value-of select="Diagnosis/TCM/Name"/></value>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="门（急）诊诊断（中医诊断）病名编码
">
										<qualifier>
											<name displayName="中医诊断代码"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="{Diagnosis/TCM/code}" displayName="{Diagnosis/TCM/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!--门（急）诊诊断-中医诊断症候条目-->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="门（急）诊诊断（中医证候）名称">
										<qualifier>
											<name displayName="中医证候名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST"><xsl:value-of select="Diagnosis/TCMSymptom/Name"/></value>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="门（急）诊诊断（中医证候）证候编码
">
										<qualifier>
											<name displayName="中医证候代码"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="{Diagnosis/TCMSymptom/code}" displayName="{Diagnosis/TCMSymptom/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!--门（急）诊诊断-西医诊断条目-->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="门（急）诊诊断（西医诊断）名称">
										<qualifier>
											<name displayName="西医诊断名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST"><xsl:value-of select="Diagnosis/CurrentDiagnosis/Name"/></value>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="门（急）诊诊断（西医诊断）疾病编码
">
										<qualifier>
											<name displayName="西医诊断代码"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="{Diagnosis/CurrentDiagnosis/code}" displayName="{Diagnosis/CurrentDiagnosis/displayName}"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!--病理诊断-疾病名称-->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<!-- 病理号标识 -->
									<id root="2.16.156.10011.1.8" extension="PA345677"/>
									<code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="病理诊断名称">
										<qualifier>
											<name displayName="病理诊断名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST"><xsl:value-of select="Diagnosis/Disease/Name"/></value>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="病理诊断编码">
										<qualifier>
											<name displayName="病理诊断代码"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="{Diagnosis/Disease/code}" displayName="{Diagnosis/Diseases/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</component>
						</organizer>
					</entry>
				</section>
			</component>
			<!--
********************************************************
主要健康问题章节
********************************************************
-->
			<component>
				<section>
					<code code="11450-4" displayName="PROBLEM LIST" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--治疗类别-->
					<entry>
						<observation classCode="OBS" moodCode="EVN ">
							<code code="DE06.00.304.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="CD" code="{MajorHealthProblems/TreatCategory/code}" codeSystem="2.16.156.10011.2.3.1.264" codeSystemName="治疗类别代码表" displayName="{MajorHealthProblems/TreatCategory/displayName}"/>
						</observation>
					</entry>
					<!--实施临床路径 -->
					<entry>
						<observation classCode="OBS " moodCode="EVN">
							<code code="HDSD00.12.099" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="实施临床路径"/>
							<value xsi:type="CD" code="{MajorHealthProblems/IOCP/code}" codeSystem="2.16.156.10011.2.3.2.57" codeSystemName="实施临床路径标志代码表" displayName="{MajorHealthProblems/IOCP/displayName}"/>
						</observation>
					</entry>
					<!--住院者疾病状态代码-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.119.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="住院者疾病状态代码"/>
							<value xsi:type="CD" code="{MajorHealthProblems/ISOD/code}" codeSystem="2.16.156.10011.2.3.1.100" codeSystemName="住院者疾病状态代码表" displayName="{MajorHealthProblems/ISOD/displayName}"/>
						</observation>
					</entry>
					<!--住院患者损伤和中毒外部原因-->
					<entry typeCode="COMP">
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.152.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="损伤中毒的外部原因"/>
							<value xsi:type="ST"><xsl:value-of select="MajorHealthProblem/ECOIP/cuas"/></value>
							<entryRelationship typeCode="REFR" negationInd="false">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.078.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="损伤中毒的外部原因-疾病编码"/>
									<value xsi:type="CD" code="{MajorHealthProblems/ECOIP/code}" displayName="{MajorHealthProblems/ECOIP/displayName}"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entryRelationship>
						</observation>
					</entry>
					<!--颅脑损伤患者入院前昏迷时间-->
					<entry typeCode="COMP">
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.138.01" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="颅脑损伤患者入院前昏迷时间-d"/>
									<value xsi:type="PQ" unit="d" value="{MajorHealthProblems/PTWCI/d}"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.138.02" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="颅脑损伤患者入院前昏迷时间-h"/>
									<value xsi:type="PQ" unit="h" value="{MajorHealthProblems/PTWCI/h}"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.138.03" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="颅脑损伤患者入院前昏迷时间-min"/>
									<value xsi:type="PQ" unit="min" value="{MajorHealthProblems/PTWCI/min}"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!--颅脑损伤患者入院后昏迷时间-->
					<entry typeCode="COMP">
						<organizer classCode="CLUSTER" moodCode="EVN">
							<code displayName="颅脑损伤患者入院后昏迷时间"/>
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.138.01" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="颅脑损伤患者入
院后昏迷时间-d"/>
									<value xsi:type="PQ" unit="d" value="{MajorHealthProblems/ATWCI/d}"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.138.02" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="颅脑损伤患者入
院后昏迷时间-h"/>
									<value xsi:type="PQ" unit="h" value="{MajorHealthProblems/ATWCI/h}"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.138.03" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="颅脑损伤患者入
院后昏迷时间-min"/>
									<value xsi:type="PQ" unit="min" value="{MajorHealthProblems/ATWCI/min}"/>
								</observation>
							</component>
						</organizer>
					</entry>
				</section>
			</component>
			<!--
********************************************************
转科记录章节
********************************************************
-->
			<component>
				<section>
					<code code="42349-1" displayName="REASON FOR REFERRAL" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--转科条目-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code/>
							<value xsi:type="ST"><xsl:value-of select="TransRecord/TransReason"/></value>
							<!--转科原因（数据元）-->
							<author>
								<time/>
								<assignedAuthor>
									<id/>
									<representedOrganization>
										<!--住院患者转科科室名称-->
										<name><xsl:value-of select="TransRecord/TransName"/></name>
									</representedOrganization>
								</assignedAuthor>
							</author>
						</observation>
					</entry>
				</section>
			</component>
			<!--
********************************************************
出院诊断章节
********************************************************
-->
			<component>
				<section>
					<code code="11535-2" displayName="Discharge Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--出院中医诊断-主病 -->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院中医诊断-主病名称">
										<qualifier>
											<name displayName="主病名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST"><xsl:value-of select="ADiagnosis/TCM/Name"/></value>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<!--住院患者疾病中医诊断主病编码-->
									<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院中医诊断-主病编码">
										<qualifier>
											<name displayName="主病代码"/>
										</qualifier>
									</code>
							<value xsi:type="CD"  code="{ADiagnosis/TCM/code}" displayName="{ADiagnosis/TCM/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE09.00.104.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院中医诊断-主病-入院病情代码">
										<qualifier>
											<name displayName="中医主病入院病情"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="{ADiagnosis/TCM/Acode}" displayName="{ADiagnosis/TCM/AdisplayName}" codeSystem="2.16.156.10011.2.3.1.253" codeSystemName="入院病情代码表"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!--出院中医主证诊断条目-->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院中医诊断-主证名称">
										<qualifier>
											<name displayName="主证名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST"><xsl:value-of select="ADiagnosis/TCM/MCname"/></value>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN ">
									<!--住院患者疾病中医诊断主证编码-->
									<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院中医诊断-主证代码">
										<qualifier>
											<name displayName="主证代码"/>
										</qualifier>
									</code>
									<!--中医诊断代码/疾病诊断名称-->
									<value xsi:type="CD" code="{ADiagnosis/TCM/MCcode}" displayName="{ADiagnosis/TCM/MCdisplayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE09.00.104.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院中医诊断-主证-入院病情代码
">
										<qualifier>
											<name displayName="中医主证入院病情"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="{ADiagnosis/TCM/MCAcode}" displayName="{ADiagnosis/TCM/MCAdisplayName}" codeSystem="2.16.156.10011.2.3.1.253" codeSystemName="入院病情代码表"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!--出院西医主要诊断条目-->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院西医诊断-主要诊断-疾病名称">
										<qualifier>
											<name displayName="主要诊断-疾病名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST"><xsl:value-of select="ADiagnosis/CurrentDiagnosis/Name"/></value>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<!--住院患者疾病西医主要诊断类型代码-->
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="西医出院诊断-主要诊断-疾病编码
">
										<qualifier>
											<name displayName="主要诊断疾病编码"/>
										</qualifier>
									</code>
									<!--西医疾病诊断代码/疾病诊断名称-->
									<value xsi:type="CD" code="{ADiagnosis/CurrentDiagnosis/code}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10" displayName="{ADiagnosis/CurrentDiagnosis/displayName}"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE09.00.104.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院西医诊断-主要诊断-入院病情代码
">
										<qualifier>
											<name displayName="主要诊断-入院病情代码"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="{ADiagnosis/CurrentDiagnosis/Acode}" displayName="{ADiagnosis/CurrentDiagnosis/AdisplayName}" codeSystem="2.16.156.10011.2.3.1.253" codeSystemName="入院病情代码表"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!--西医出院诊断-其他诊断-->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院西医诊断-其他诊断名称">
										<qualifier>
											<name displayName="其他诊断名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST"><xsl:value-of select="ADiagnosis/CurrentDiagnosis/otherName"/></value>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<!--住院患者疾病西医其他诊断类型代码-->
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="西医出院诊断-其他诊断疾病编码">
										<qualifier>
											<name displayName="其他诊断疾病编码"/>
										</qualifier>
									</code>
									<!--西医疾病诊断代码/疾病诊断名称-->
									<value xsi:type="CD" code="{ADiagnosis/CurrentDiagnosis/othercode}" displayName="{ADiagnosis/CurrentDiagnosis/otherdisplayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE09.00.104.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院西医诊断-其他诊断-入院病情代码
">
										<qualifier>
											<name displayName="其他诊断-入院病情代码"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="{ADiagnosis/CurrentDiagnosis/otherAcode}" displayName="有" codeSystem="2.16.156.10011.2.3.1.253" codeSystemName="{ADiagnosis/CurrentDiagnosis/otherAdisplayName}"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!--离院方式-->
					<entry typeCode="COMP">
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.223.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="离院方式"/>
							<value xsi:type="CD" code="{ADiagnosis/WayOuts/code}" codeSystem="2.16.156.10011.2.3.1.265" codeSystemName="离院方式代码表" displayName="{ADiagnosis/CurrentDiagnosis/displayName}"/>
						</observation>
					</entry>
					<!--拟接受医疗机构名称-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE08.10.013.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="拟接受医疗机构名称"/>
							<value xsi:type="ST"><xsl:value-of select="ADiagnosis/AcceptInstitutionName"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--
********************************************************
过敏史章节
********************************************************
-->
			<component>
				<section>
					<code code="48765-2" displayName="Allergies, adverse reactions, alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry typeCode="DRIV">
						<act classCode="ACT" moodCode="EVN">
							<code/>
							<!--药物过敏标志-->
							<entryRelationship typeCode="SUBJ">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.023.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="BL" value="{Anaphylaxiss/sign}"/>
									<participant typeCode="CSM">
										<participantRole classCode="MANU">
											<playingEntity classCode="MMAT">
												<!--住院患者过敏源-->
												<code code="DE02.10.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="过敏药物"/>
												<desc xsi:type="ST"><xsl:value-of select="Anaphylaxiss/medicine"/></desc>
											</playingEntity>
										</participantRole>
									</participant>
								</observation>
							</entryRelationship>
						</act>
					</entry>
				</section>
			</component>
			<!--
********************************************************
实验室检验章节
********************************************************
-->
			<component>
				<section>
					<code code="30954-2" displayName="STUDIES SUMMARY" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry typeCode="COMP">
						<!-- 血型-->
						<organizer classCode="BATTERY" moodCode="EVN">
							<statusCode/>
							<component typeCode="COMP" contextConductionInd="true">
								<!-- ABO血型 -->
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.50.001.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value code="{LaboratoryExamination/BloodType/code}" xsi:type="CD" codeSystem="2.16.156.10011.2.3.1.85" codeSystemName="ABO血型代码表" displayName="{LaboratoryExamination/BloodType/displayName}"/>
								</observation>
							</component>
							<component typeCode="COMP" contextConductionInd="true">
								<!-- Rh血型 -->
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.50.010.00" codeSystem="2.16.156.10011.2.2.2" codeSystemName="卫生信息数据元目录"/>
									<value code="{LaboratoryExamination/BloodType/Naturecode}" xsi:type="CD" codeSystem="2.16.156.10011.2.3.1.250" displayName="{LaboratoryExamination/BloodType/NaturedisplayName}" codeSystemName="Rh(D)血型代码表"/>
								</observation>
							</component>
						</organizer>
					</entry>
				</section>
			</component>
			<!--
********************************************************
手术操作章节
********************************************************
-->
			<component>
				<section>
					<code code="47519-4" displayName="HISTORY OF PROCEDURES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<!-- 1..1 手术记录 -->
						<procedure classCode="PROC" moodCode="EVN">
							<code code="1" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="
手术(操作)代码表（ICD-9-CM）"/>
							<statusCode/>
							<!--操作日期/时间-->
							<effectiveTime value="{SurgicalOperation/Time}"/>
							<!--手术者-->
							<performer>
								<assignedEntity>
									<id root="2.16.156.10011.1.4" extension="{SurgicalOperation/SurgeonNum}"/>
									<assignedPerson>
										<name><xsl:value-of select="SurgicalOperation/SurgeonName"/></name>
									</assignedPerson>
								</assignedEntity>
							</performer>
							<!--第一助手-->
							<participant typeCode="ATND">
								<participantRole classCode="ASSIGNED">
									<id root="2.16.156.10011.1.4" extension="{SurgicalOperation/FANum}"/>
									<code displayName="第一助手"/>
									<playingEntity classCode="PSN" determinerCode="INSTANCE">
										<name><xsl:value-of select="SurgicalOperation/FAName"/></name>
									</playingEntity>
								</participantRole>
							</participant>
							<!--第二助手-->
							<participant typeCode="ATND">
								<participantRole classCode="ASSIGNED">
									<id root="2.16.156.10011.1.4" extension="{SurgicalOperation/SANum}"/>
									<code displayName="第二助手"/>
									<playingEntity classCode="PSN" determinerCode="INSTANCE">
										<name><xsl:value-of select="SurgicalOperation/SAName"/></name>
									</playingEntity>
								</participantRole>
							</participant>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.094.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术（操作）名称"/>
									<value xsi:type="ST"><xsl:value-of select="SurgicalOperation/OperativeName"/></value>
								</observation>
							</entryRelationship>
							<!--手术级别 -->
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.255.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术级别"/>
									<!--手术级别 -->
									<value xsi:type="CD" code="{SurgicalOperation/SLcode}" displayName="{SurgicalOperation/SLdisplayName}" codeSystem="2.16.156.10011.2.3.1.258" codeSystemName="手术级别代码表" />
								</observation>
							</entryRelationship>
							<!--手术切口类别 -->
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.257.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术切口类别代码"/>
									<!--手术级别 -->
									<value xsi:type="CD" code="{SurgicalOperation/SIcode}" displayName="{SurgicalOperation/SIdisplayName}" codeSystem="2.16.156.10011.2.3.1.256" codeSystemName="手术切口类别代码表"/>
								</observation>
							</entryRelationship>
							<!--手术切口愈合等级-->
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.147.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术切口愈合等级"/>
									<!--手术切口愈合等级-->
									<value xsi:type="CD" code="{SurgicalOperation/HGOSIcode}" displayName="{SurgicalOperation/HGOSIdisplayName}" codeSystem="2.16.156.10011.2.3.1.257" codeSystemName="手术切口愈合等级代码表"/>
								</observation>
							</entryRelationship>
							<!-- 0..1 麻醉信息 -->
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.073.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉方法代码"/>
									<value codeSystem="2.16.156.10011.2.3.1.159" code="{SurgicalOperation/AMcode}" displayName="{SurgicalOperation/AMdisplayName}" codeSystemName="麻醉方法代码表" xsi:type="CD"/>
									<!--麻醉医生-->
									<performer>
										<assignedEntity>
											<id root="2.16.156.10011.1.4" extension="{SurgicalOperation/AnesthesiologistNum}
"/>
											<assignedPerson>
												<name><xsl:value-of select="SurgicalOperation/AnesthesiologistName"/></name>
											</assignedPerson>
										</assignedEntity>
									</performer>
								</observation>
							</entryRelationship>
						</procedure>
					</entry>
				</section>
			</component>
			<!--
*******************************************************
住院史章节
*******************************************************
-->
			<component>
				<section>
					<code code="11336-5" codeSystem="2.16.840.1.113883.6.1" displayName="HISTORY
OF HOSPITALIZATIONS" codeSystemName="LOINC"/>
					<text/>
					<!--住院次数 -->
					<entry typeCode="COMP">
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.090.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="住院次数"/>
							<value unit="次" xsi:type="PQ" value="{HistoryHospital/frequency}"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--
********************************************************
行政管理章节
********************************************************
-->
			<component>
				<section>
					<code displayName="行政管理"/>
					<text/>
					<!--死亡患者尸检标志-->
					<entry typeCode="COMP">
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE09.00.108.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="死亡患者尸检标志"/>
							<value xsi:type="BL" value="{AdminManage/AutopsySign}"/>
						</observation>
					</entry>
					<!--病案质量-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE09.00.103.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="病案质量"/>
							<!-- 质控日期 -->
							<effectiveTime xsi:type="IVL_TS" value="{AdminManage/QCTime}"/>
							<value xsi:type="CD" code="{AdminManage/QCLcode}" codeSystem="2.16.156.10011.2.3.2.29" codeSystemName="病案质量等级表" displayName="{AdminManage/QCLdisplayName}"/>
							<author>
								<time/>
								<assignedAuthor>
									<id root="2.16.156.10011.1.4" extension="{AdminManage/QCDNum}"/>
									<code displayName="质控医生"/>
									<assignedPerson>
										<name><xsl:value-of select="AdminManage/QCDName"/></name>
									</assignedPerson>
								</assignedAuthor>
							</author>
							<author>
								<time/>
								<assignedAuthor>
									<id root="2.16.156.10011.1.4" extension="{AdminManage/QCNNum}"/>
									<code displayName="质控护士"/>
									<assignedPerson>
										<name><xsl:value-of select="AdminManage/QCNName"/></name>
									</assignedPerson>
								</assignedAuthor>
							</author>
						</observation>
					</entry>
				</section>
			</component>
			<!--
*******************************************************
住院过程章节
*******************************************************
-->
			<component>
				<section>
					<code code="8648-8" displayName="Hospital Course" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--实际住院天数 -->
					<entry typeCode="COMP">
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.310.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="实际住院天数"/>
							<value xsi:type="PQ" value="{HospitalizationProcess/AHdays}" unit="天"/>
						</observation>
					</entry>
					<entry>
						<!--出院科室及病房 -->
						<act classCode="ACT" moodCode="EVN">
							<code/>
							<author>
								<time/>
								<assignedAuthor>
									<id/>
									<representedOrganization>
										<!--住院患者出院病房、科室名称-->
										<id root="2.16.156.10011.1.21" extension="003"/>
										<name><xsl:value-of select="HospitalizationProcess/LPW"/></name>
										<asOrganizationPartOf classCode="PART">
											<wholeOrganization classCode="ORG" determinerCode="INSTANCE">
												<id root="2.16.156.10011.1.26" extension="567"/>
												<name><xsl:value-of select="HospitalizationProcess/LPD"/></name>
											</wholeOrganization>
										</asOrganizationPartOf>
									</representedOrganization>
								</assignedAuthor>
							</author>
						</act>
					</entry>
				</section>
			</component>
			<!--
***********************************************
治疗计划章节
***********************************************
-->
			<component>
				<section>
					<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!-- 有否出院31天内再住院计划 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.194.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院31天内再住院标志"/>
							<value xsi:type="BL" value="{treatPlan/RehosSign}"/>
							<entryRelationship typeCode="GEVL" negationInd="false">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.195.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院31天内再住院目的"/>
									<value xsi:type="ST"><xsl:value-of select="treatPlan/objective"/></value>
								</observation>
							</entryRelationship>
						</observation>
					</entry>
				</section>
			</component>
			<!--
********************************************************
费用章节
********************************************************
-->
			<component>
				<section>
					<code code="48768-6" displayName="PAYMENT SOURCES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--医疗付款方式 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE07.00.007.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="医疗付款方式代码"/>
							<value xsi:type="CD" code="{cost/MPMcode}" displayName="{cost/MPMdisplayName}" codeSystem="2.16.156.10011.2.3.1.269" codeSystemName="医疗付费方式代码表"/>
						</observation>
					</entry>
					<!--住院总费用 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="HDSD00.12.169" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="住院总费用"/>
							<value xsi:type="MO" value="{cost/TotalH}" currency="元"/>
							<entryRelationship typeCode="COMP" negationInd="false">
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.170" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="住院总费用-自付金额（元）"/>
									<value xsi:type="MO" value="{cost/SPay}" currency="元"/>
								</observation>
							</entryRelationship>
						</observation>
					</entry>
					<!--综合医疗服务费 -->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.174" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="综合医疗服务费-一般医疗服务费"/>
									<value xsi:type="MO" value="{cost/GS}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.175" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="综合医疗服务费-一般医疗服务费-中医辨证论治
费"/>
									<value xsi:type="MO" value="{cost/TCMS}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.176" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="综合医疗服务费-一般医疗服务费-中医辨证论治
会诊费"/>
									<value xsi:type="MO" value="{cost/TCMSC}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.177" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="综合医疗服务费-一般治疗操作费"/>
									<value xsi:type="MO" value="{cost/GT}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.172" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="综合医疗服务费-护理费"/>
									<value xsi:type="MO" value="{cost/Nursing}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.173" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="综合医疗服务费-其他费用"/>
									<value xsi:type="MO" value="{cost/GSOther}" currency="元"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!--诊断类服务费 -->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.136" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="诊断-病理诊断费"/>
									<value xsi:type="MO" value="{cost/pathological}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.138" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="诊断-实验室诊断费"/>
									<value xsi:type="MO" value="{cost/laboratory}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.1139" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="诊断-影像学
诊断费"/>
									<value xsi:type="MO" value="{cost/imaging}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.137" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="诊断-临床诊断项目费"/>
									<value xsi:type="MO" value="{cost/ClinicalProject}" currency="元"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!--治疗类服务费 -->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.145" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="治疗-非手术治疗项目费"/>
									<value xsi:type="MO" value="{cost/NonST}" currency="元"/>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="HDSD00.12.146" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="治疗-非手术
治疗项目费-临床物理治疗费"/>
											<value xsi:type="MO" value="{cost/NonSTCP}" currency="元"/>
										</observation>
									</entryRelationship>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.147" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="治疗-手术治疗费"/>
									<value xsi:type="MO" value="{cost/ST}" currency="元"/>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="HDSD00.12.148" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="治疗-手术治
疗费-麻醉费"/>
											<value xsi:type="MO" value="{cost/anesthesia}" currency="元"/>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="HDSD00.12.149" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="治疗-手术治
疗费-手术费"/>
											<value xsi:type="MO" value="{cost/surgery}" currency="元"/>
										</observation>
									</entryRelationship>
								</observation>
							</component>
						</organizer>
					</entry>
					<!--康复费类服务费 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="HDSD00.12.062" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="康复费"/>
							<value xsi:type="MO" value="{cost/rehabilitat}" currency="元"/>
						</observation>
					</entry>
					<!--以下三条目标识类true or false-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.243.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="使用医疗机构中药制剂"/>
							<value xsi:type="BL" value="{cost/TCMPsign}"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.245.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="使用中医诊疗技术标志"/>
							<value xsi:type="BL" value="{cost/TCMDTTsign}"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.180.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="辩证施护标志"/>
							<value xsi:type="BL" value="{cost/DNsign}"/>
						</observation>
					</entry>
					<!--以上三条为标志类条目-->
					<!--中医类费 -->
					<entry>
						<organizer classCode="CLUSTER " moodCode="EVN ">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.156" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="中医诊断费"/>
									<value xsi:type="MO" value="{cost/TCMD}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.157" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="中医治疗费"/>
									<value xsi:type="MO" value="{cost/TCMT}" currency="元"/>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="HDSD00.12.163" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="中医类-中医
治疗费-中医外治"/>
											<value xsi:type="MO" value="{cost/TCMet}" currency="元"/>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="HDSD00.12.160" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="中医类-中医
治疗费-中医骨伤"/>
											<value xsi:type="MO" value="{cost/Fractures}" currency="元"/>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="HDSD00.12.158" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="中医类-中医
治疗费-针刺与灸法"/>
											<value xsi:type="MO" value="{cost/AM}" currency="元"/>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="HDSD00.12.162" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="中医类-中医
治疗费-中医推拿治疗"/>
											<value xsi:type="MO" value="{cost/massage}" currency="元"/>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="HDSD00.12.159" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="中医类-中医
治疗费-中医肛肠治疗"/>
											<value xsi:type="MO" value="{cost/anorectal}" currency="元"/>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="HDSD00.12.161" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="中医类-中医
治疗费-中医特殊治疗"/>
											<value xsi:type="MO" value="{cost/TCMspecial}" currency="元"/>
										</observation>
									</entryRelationship>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.153" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="中医其他治疗费"/>
									<value xsi:type="MO" value="{cost/TCMOther}" currency="元"/>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="HDSD00.12.155" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="中医类-中医
其他费-中药特殊调配加工"/>
											<value xsi:type="MO" value="{cost/SPTM}" currency="元"/>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="HDSD00.12.154" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="中医类-中医
治疗费-辩证施膳"/>
											<value xsi:type="MO" value="{cost/DE}" currency="元"/>
										</observation>
									</entryRelationship>
								</observation>
							</component>
						</organizer>
					</entry>
					<!--西药费 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="HDSD00.12.113" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="西药费"/>
							<value xsi:type="MO" value="{cost/WM}" currency="元"/>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.114" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="西药费-抗菌药物费用"/>
									<value xsi:type="MO" value="{cost/Antimicrobial}" currency="元"/>
								</observation>
							</entryRelationship>
						</observation>
					</entry>
					<!--中药费 -->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.151" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="中药费-中成药费"/>
									<value xsi:type="MO" value="{cost/PCM}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.150" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="中药费-中草药费"/>
									<value xsi:type="MO" value="{cost/CHM}" currency="元"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!-- 血液和血液制品类服务费 -->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.130" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="血费"/>
									<value xsi:type="MO" value="{cost/blood}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.126" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="白蛋白类制品费"/>
									<value xsi:type="MO" value="{cost/Albumin}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.128" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="球蛋白类制品费"/>
									<value xsi:type="MO" value="{cost/Globulin}" currency="元"/>
								</observation>
							</component>
							<!-- 凝血因子类制品费 -->
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.127" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="凝血因子类制品费"/>
									<value xsi:type="MO" value="{cost/ClotSubclass}" currency="元"/>
								</observation>
							</component>
							<!--细胞因子类制品费 -->
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.129" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="细胞因子类制品费"/>
									<value xsi:type="MO" value="{cost/CellSubclass}" currency="元"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!-- 使用中医诊疗设备标志 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.244.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="使用中医诊疗设备标志"/>
							<value xsi:type="BL" value="{cost/TCMDTEsign}"/>
						</observation>
					</entry>
					<!--耗材类费用-->
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.045" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="一次性医用材料费-检查用"/>
									<value xsi:type="MO" value="{cost/DisposC}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.047" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="一次性医用材料费-治疗用"/>
									<value xsi:type="MO" value="{cost/DisposT}" currency="元"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="HDSD00.12.046" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="一次性医用材料费-手术用"/>
									<value xsi:type="MO" value="{cost/DisposS}" currency="元"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!--其他费 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="HDSD00.12.092" codeSystem="2.16.156.10011.2.2.4" codeSystemName="住院病案首页基本数据集" displayName="其他费"/>
							<value xsi:type="MO" value="{cost/Other}" currency="元"/>
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
