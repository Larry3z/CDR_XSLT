<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
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
						<!--xsl:apply-templates select="Encounter/Patient" mode="BirthTime"/-->
						<xsl:apply-templates select="Encounter/Patient" mode="Age"/>
					</patient>
				</patientRole>
			</recordTarget>
			<!-- 创作者信息 1..1-->
			<author typeCode="AUT" contextControlCode="OP">
				<!--填表日期 1..1  -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--访视医生姓名 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</author>
            <!-- 文档管理者信息 1..1 -->
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<!--文档审核者 该部分信息表达文档经过了一定的审核，但还没达到一定的法律效应 -->
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<relatedDocument typeCode="RPLC">
				<!--文档中医疗卫生事件的就诊场景,即入院场景记录-->
				<parentDocument>
					<id/>
					<setId/>
					<versionNumber/>
				</parentDocument>
			</relatedDocument>
			<component>
		<structuredBody>
			<!--
*****************************
主要健康问题章节
*****************************-->
			<component>
				<section>
					<code code="11450-4" displayName="PROBLEM LIST" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.024.00" displayName="疾病诊断编码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="CD" code="B95.100" displayName="B族链球菌感染"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
8						</observation>
					</entry>
				</section>
			</component>
			<!--
*****************************
护理记录章节
*****************************-->
			<component>
				<section>
					<code displayName="护理记录"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.211.00" displayName="护理等级代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.020 DE06.00.211.00 护理等级代码 -->
							<value xsi:type="CD" code="1" displayName="特级护理" codeSystem="2.16.156.10011.2.3.1.259" codeSystemName="护理等级代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.212.00" displayName="护理类型代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.023 DE06.00.212.00 护理类型代码 -->
							<value xsi:type="CD" code="1" displayName="基础护理" codeSystem="2.16.156.10011.2.3.1.260" codeSystemName="护理类型代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.136.00" displayName="护理问题" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.024 DE05.10.136.00 护理问题 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/nurse/note/operate/question"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.342.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理操作名称"/>
							<value xsi:type="ST"><xsl:value-of select="/Document/nurse/note/operate/name"/></value>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.210.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理操作项目类目名称"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/nurse/note/operate/categoryName"/></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.209.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理操作结果"/>
											<value xsi:type="ST"><xsl:value-of select="/Document/nurse/note/operate/result"/></value>
										</observation>
									</entryRelationship>
								</observation>
							</entryRelationship>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.209.00" displayName="导管护理" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.010 DE06.00.209.00 导管护理描述 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/nurse/note/catheterDescription"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.259.00" displayName="体位护理" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.062 DE04.10.259.00 体位护理 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/nurse/note/positionDescription"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.50.068.00" displayName="皮肤护理" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!--HDSD00.09.044 DE04.50.068.00 皮肤护理 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/nurse/note/skinDescription"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.229.00" displayName="气管护理代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<!-- HDSD00.09.046 DE06.00.229.00 气管护理代码 -->
							<value xsi:type="CD" code="1" displayName="翻身拍背" codeSystem="2.16.156.10011.2.3.2.50" codeSystemName="气管护理代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.178.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="安全护理代码"/>
							<!--HDSD00.09.002 DE06.00.178.00 安全护理代码 -->
							<value xsi:type="CD" code="1" displayName="勤巡视病房" codeSystem="2.16.156.10011.2.3.2.52" codeSystemName="安全护理代码表"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--
*****************************
健康指导章节
*****************************-->
			<component>
				<section>
					<code code="69730-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Instructions"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.291.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="饮食指导代码"/>
							<!--HDSD00.09.078 DE06.00.291.00 饮食指导代码 -->
							<value xsi:type="CD" code="01" displayName="普通饮食" codeSystem="2.16.156.10011.2.3.1.263" codeSystemName="饮食指导代码表"/>
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
