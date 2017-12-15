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
						<!--主要参与者签名 legalAuthenticator--><xsl:comment>kaishi</xsl:comment>
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
			<xsl:comment>过敏史章节</xsl:comment>
			
					<!--过敏史章节-->
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
			<xsl:comment>主诉章节</xsl:comment>	
			
			<!--主诉章节-->
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
					<xsl:comment>现病史章节</xsl:comment>
			<!--现病史章节-->
			<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
			<xsl:comment> 既往史章节</xsl:comment>
			
			<!-- 既往史章节 -->
			<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
			<xsl:comment>体格检查章节</xsl:comment>
			<!--体格检查章节-->
			<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
			<xsl:comment>实验室检验章节</xsl:comment>
			<!-- 实验室检验章节 -->
			<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
			<xsl:comment>诊断记录章节</xsl:comment>
			
			<!-- 诊断记录章节 -->
			<component>
				<section>
					<code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<xsl:comment>--初诊标志条目1..1R--</xsl:comment>
					<!--初诊标志条目1..1R-->
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
					<!--entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.196.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="初诊标志代码"/>
							<value xsi:type="CD" code="1" codeSystem="2.16.156.10011.2.3.2.39" codeSystemName="初诊标志代码表" displayName="初诊"/>
						</observation>
					</entry -->
					<xsl:comment>中医 “四诊”观察条目0..1O</xsl:comment>
			<!-- 中医 “四诊”观察条目0..1O -->
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
					<!--entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.028.00" displayName="中医“四诊”观察结果" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="ST">观察结果描述</value>
						</observation>
					</entry-->
					<xsl:comment>西医诊断条目0..* R2</xsl:comment>
			<!--西医诊断条目0..* R2 -->
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
					<!--entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.025.00" displayName="诊断名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">先天性心脏病</value>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" displayName="诊断代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="B95.100" displayName="B族链球菌感染"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</component>
						</organizer>
					</entry-->
					<xsl:comment>中医 病名条目0..*O</xsl:comment>
                 <!--中医 病名条目0..*O -->
                 <xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
                 
					<!--entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.172.00" displayName="中医病名名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
										<qualifier>
											<name displayName="中医病名名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST">中医病名名称</value>
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
					</entry-->
					<xsl:comment>中医证候条目0..* O</xsl:comment>
					<!--中医证候条目0..* O -->
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
					
					<!--entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.172.00" displayName="中医证候名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
										<qualifier>
											<name displayName="中医证候名称"/>
										</qualifier>
									</code>
									<value xsi:type="ST">中医证候名称</value>
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
					</entry-->
				</section>
			</component>
			<xsl:comment>治疗计划章节</xsl:comment>
			<!-- 治疗计划章节 -->
			<component>
				<section>
					<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<xsl:comment>辨证依据描述0..1 R2</xsl:comment>
					<!--辨证依据描述0..1 R2-->
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
					<!--entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.132.00" displayName="辨证依据" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="ST">辨证依据描述</value>
						</observation>
					</entry -->
					<xsl:comment>治则治法0..1 R2</xsl:comment>
					<!--治则治法0..1 R2 -->
					<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
					<!--entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.300.00" displayName="治则治法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="ST">自由文本</value>
						</observation>
					</entry-->
				</section>
			</component>
			<xsl:comment>医嘱章节1..* R</xsl:comment>
			<!--医嘱章节1..* R-->
			<xsl:apply-templates select="Sections/Section[SectionCode='DE04.01.119.00']" mode="ChiefComplaint"/>
			
		</structuredBody>
	</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
