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
					<!-- 住院号标识 -->
					<xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/>
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
						<!-- 年龄 -->
						<!--xsl:apply-templates select="Encounter/Patient" mode="Age"/-->
						<!--职业状况-->
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
					</patient>
				</patientRole>
			</recordTarget>
			
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
			<!--主诉章节-->
			<component>
				<section>
					<code code="10154-3" displayName="CHIEF COMPLAINT" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--主诉条目-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.01.119.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="主诉"/>
							<value xsi:type="ST"><xsl:value-of select="Cc/Record"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--现病史章节-->
			<component>
				<section>
					<code code="10164-2" displayName="HISTORY OF PRESENT ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--现病史条目-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.071.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="现病史"/>
							<value xsi:type="ST"><xsl:value-of select="hpi/Record"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--主要健康问题章节 -->
			<component>
				<section>
					<code code="11450-4" displayName="PROBLEM LIST" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--陈述内容可靠标志-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.143.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="陈述内容可靠标志"/>
							<value xsi:type="BL" value="{MajorHealthProblems/StateReliaSign}"/>
						</observation>
					</entry>
					<!--症状名称-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.01.118.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="症状名称"/>
							<value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/symptom/name"/></value>
							<!--症状描述-->
							<entryRelationship typeCode="SUBJ" inversionInd="false">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.01.117.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="症状描述"/>
									<value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/symptom/record"/></value>
								</observation>
							</entryRelationship>
						</observation>
					</entry>
					<!--中医“四诊”观察结果-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.028.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="中医“四诊”观察结果"/>
							<value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/cz/TCM/TCPsizhen"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--
********************************************************
入院诊断章节
********************************************************
-->
			<component>
				<section>
					<code code="46241-6" displayName="HOSPITAL ADMISSION DX" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--入院诊断-西医条目-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断-西医诊断名称"/>
							<value xsi:type="ST"><xsl:value-of select="Diagnosis/CurrentDiagnosis/Name"/></value>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<!--入院诊断-西医诊断编码-代码-->
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断-西医诊断编码"/>
									<value xsi:type="CD" code="{Diagnosis/CurrentDiagnosis/code}" displayName="{Diagnosis/CurrentDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entryRelationship>
						</observation>
					</entry>
					<!--入院诊断-中医条目-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断-中医病名名称"/>
							<value xsi:type="ST"><xsl:value-of select="Diagnosis/TCM/Name"/></value>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<!--入院诊断-中医诊断编码-代码-->
									<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断-中医病名代码"/>
									<value xsi:type="CD" code="{Diagnosis/TCM/code}" displayName="{Diagnosis/TCM/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</entryRelationship>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<!--入院诊断-中医证候编码-名称-->
									<code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断-中医证候名称"/>
									<value xsi:type="ST"><xsl:value-of select="Diagnosis/TCMSymptom/Name"/></value>
								</observation>
							</entryRelationship>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<!--入院诊断-中医证候编码-代码-->
									<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断-中医证候代码"/>
									<value xsi:type="CD" code="{Diagnosis/TCMSymptom/code}" displayName="{Diagnosis/TCMSymptom/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</entryRelationship>
						</observation>
					</entry>
				</section>
			</component>
			<!--治疗计划章节-->
			<component>
				<section>
					<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--治则治法条目-->
					<entry>
						<observation classCode="OBS" moodCode="INT">
							<code code="DE06.00.300.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="治则治法"/>
							<value xsi:type="ST"><xsl:value-of select="TreatmentPlan/Accountability"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--住院过程章节-->
			<component>
				<section>
					<code code="8648-8" displayName="HOSPITAL COURSE" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--入院情况条目-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.148.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院情况"/>
							<value xsi:type="ST"><xsl:value-of select="HospitalizationProcess/Admission"/></value>
						</observation>
					</entry>
					<!--诊疗过程描述条目-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.296.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="诊疗过程描述"/>
							<value xsi:type="ST"><xsl:value-of select="HospitalizationProcess/DT"/></value>
						</observation>
					</entry>
					<!--出院情况条目-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.193.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院情况"/>
							<value xsi:type="ST"><xsl:value-of select="HospitalizationProcess/Leave"/></value>
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
					<!--出院诊断-西医条目-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-西医诊断名称"/>
							<value xsi:type="ST"><xsl:value-of select="ADiagnosis/CurrentDiagnosis/Name"/></value>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<!--出院诊断-西医诊断编码-代码-->
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-西医诊断编码"/>
									<value xsi:type="CD" code="{ADiagnosis/CurrentDiagnosis/code}" displayName="{ADiagnosis/CurrentDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entryRelationship>
						</observation>
					</entry>
					<!--出院诊断-中医条目-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-中医病名名称"/>
							<value xsi:type="ST"><xsl:value-of select="ADiagnosis/TCM/Name"/></value>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<!--出院诊断-中医诊断编码-代码-->
									<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-中医病名代码"/>
									<value xsi:type="CD" code="{ADiagnosis/TCM/code}" displayName="{ADiagnosis/TCM/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</entryRelationship>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<!--出院诊断-中医证候编码-名称-->
									<code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-中医证候名称"/>
									<value xsi:type="ST"><xsl:value-of select="ADiagnosis/TCMSymptom/Name"/></value>
								</observation>
							</entryRelationship>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<!--出院诊断-中医证候编码-代码-->
									<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院诊断-中医证候代码"/>
									<value xsi:type="CD" code="{ADiagnosis/TCMSymptom/code}" displayName="{ADiagnosis/TCMSymptom/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
								</observation>
							</entryRelationship>
						</observation>
					</entry>
				</section>
			</component>
			<!--医嘱章节-->
			<component>
				<section>
					<code code="46209-3" displayName="PROVIDER ORDERS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--出院医嘱条目-->
					<entry>
						<observation classCode="OBS" moodCode="RQO">
							<code code="DE06.00.287.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出院医嘱"/>
							<!--出院医嘱开立日期时间-->
							<effectiveTime value="{Order/cyTime}"/>
							<value xsi:type="ST"><xsl:value-of select="Order/DischargeOrder"/></value>
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
