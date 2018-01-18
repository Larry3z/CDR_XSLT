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
					<!-- 联系方式 -->
						<xsl:apply-templates select="Encounter/Patient" mode="MP"/>
						<xsl:apply-templates select="Encounter/Patient" mode="WP"/>
						<xsl:apply-templates select="Encounter/Patient" mode="EM"/>
					<patient classCode="PSN" determinerCode="INSTANCE">
						<!--患者身份证号-->
						<xsl:apply-templates select="Encounter/Patient" mode="IDNo"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Group"/>
						<xsl:apply-templates select="Encounter/Patient" mode="nationality"/>
						<xsl:apply-templates select="Encounter/Patient" mode="educationLevel"/>
						<xsl:apply-templates select="Encounter/Patient" mode="occupation"/>
						<!--xsl:apply-templates select="Encounter/Patient" mode="Age"/-->
					</patient>
				</patientRole>
			</recordTarget>
			<!-- 文档创作者 -->
			<author typeCode="AUT" contextControlCode="OP">
				<!--文档创作时间 1..1  -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--制定创作者 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</author>
			<xsl:apply-templates select="Author" mode="Author1"/>
	        <!--文档管理者1..1 -->
	        <xsl:apply-templates select="Custodian" mode="Custodian"/>
            <!--法定审核者 表达对文档直接起到法律效应的法定审核者信息 -->
            <xsl:comment>kaishi</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='医师']" mode="legalAuthenticator"/>
			<!--文档审核者 该部分信息表达文档经过了一定的审核，但还没达到一定的法律效应 -->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
			<relatedDocument typeCode="RPLC">
				<!--文档中医疗卫生事件的就诊场景,即入院场景记录-->
				<parentDocument>
					<id/>
					<setId/>
					<versionNumber/>
				</parentDocument>
			</relatedDocument>
			<!--关联活动信息 1..1R-->
			<componentOf>
				<encompassingEncounter>
					<!--入院时间 1..1-->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<location>
						<healthCareFacility>
							<serviceProviderOrganization>
								<asOrganizationPartOf classCode="PART">
									<!-- DE01.00.026.00病床号 1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
									<!-- DE01.00.019.00病房号1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
									<!-- DE08.10.026.00科室名称 1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
									<!-- DE08.10.054.00病区名称 1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
									<!--医疗机构名称 1..1 -->
									<xsl:apply-templates select="Sections/Section" mode="mode"/>
								</asOrganizationPartOf>
							</serviceProviderOrganization>
						</healthCareFacility>
					</location>
				</encompassingEncounter>
			</componentOf>
<component>
		<structuredBody>
			<!--
****************************
入院信息章节
****************************-->
			<component>
				<section>
					<code displayName="入院信息"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<!--HDSD00.09.053 DE05.10.053.00 入院原因 -->
							<code code="DE05.10.053.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院原因"/>
							<value xsi:type="ST"><xsl:value-of select="/Document/admissionAssessment/information/reason"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<!--HDSD00.09.052 DE06.00.339.00 入院途径代码 -->
							<code code="DE06.00.339.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院途径代码"/>
							<value xsi:type="CD" code="2" displayName="急诊" codeSystem="2.16.156.10011.2.3.1.270" codeSystemName="入院途径代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.237.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入病房方式"/>
							<!--HDSD00.09.050 DE06.00.237.00 入病房方式 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/admissionAssessment/information/enterWay"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--
***************************
症状章节
***************************-->
			<component>
				<section>
					<code code="11450-4" displayName="PROBLEM LIST" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.01.118.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="主要症状名称"/>
							<!--HDSD00.09.084 DE04.01.117.00 主要症状名称 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/symptom/description"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--
***************************
生命体征章节
***************************-->
			<component>
				<section>
					<code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="VITAL SIGNS"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.186.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体温(℃)"/>
							<!-- HDSD00.09.063 DE04.10.186.00 体温（℃）-->
							<value xsi:type="PQ" value="{/Document/sign/temperature}" unit="℃"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.118.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="脉率"/>
							<!-- HDSD00.09.040 DE04.10.118.00 脉率（次/min）-->
							<value xsi:type="PQ" value="{/Document/sign/pulseRate}" unit="次/min"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.081.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="呼吸频率"/>
							<!-- HDSD00.09.016 DE04.10.081.00 呼吸频率（次/min）-->
							<value xsi:type="PQ" value="{/Document/sign/breathingRate}" unit="次/min"/>
						</observation>
					</entry>
					<entry>
						<organizer classCode="BATTERY" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.10.174.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="收缩压"/>
									<!-- HDSD00.09.056 DE04.10.174.00 收缩压（mmHg）-->
									<value xsi:type="PQ" value="{/Document/sign/systolicPressure}" unit="mmHg"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.10.176.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="舒张压"/>
									<!-- HDSD00.09.058 DE04.10.176.00 舒张压（mmHg）-->
									<value xsi:type="PQ" value="{/Document/sign/diastolicPressure}" unit="mmHg"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.188.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体重"/>
							<!-- HDSD00.09.064 DE04.10.188.00 体重（kg）-->
							<value xsi:type="PQ" value="{/Document/sign/weight}" unit="kg"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--
***************************
既往史章节
***************************-->
			<component>
				<section>
					<code code="11348-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HISTORY OF PAST ILLNESS"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.026.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="疾病史(含外伤)"/>
							<!--HDSD00.09.031 DE02.10.026.00 疾病史（含外伤）-->
							<value xsi:type="ST"><xsl:value-of select="/Document/pastHistory/medicalHistory"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.008.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="传染病史"/>
							<!--HDSD00.09.009 DE02.10.008.00 传染病史 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/pastHistory/infectiousDiseases"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.101.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="预防接种史"/>
							<!--HDSD00.09.081 DE02.10.101.00 预防接种史 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/pastHistory/vaccination"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.061.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术史"/>
							<!--HDSD00.09.057 DE02.10.061.00 手术史 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/pastHistory/operationHistory"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.100.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血史"/>
							<!--HDSD00.09.059 DE02.10.100.00 输血史 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/pastHistory/bloodHistory"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.031.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="一般健康状况标志"/>
							<value xsi:type="BL" value="true"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.119.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="患者传染性标志"/>
							<value xsi:type="BL" value="true"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--
***************************
过敏史章节
***************************-->
			<component>
				<section>
					<!--code code="10155-0" codeSystem="2.16.840.1.113883.6.1"
codeSystemName="LOINC" displayName="HISTORY OF ALLERGIES"/-->
					<code code="48765-2" displayName="Allergies, adverse reactions, alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<!--HDSD00.09.015 DE02.10.022.00 过敏史 -->
							<code code="DE02.10.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="过敏史"/>
							<value xsi:type="ST"><xsl:value-of select="/Document/allergicHistory/description"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--
***************************
家族史章节
***************************-->
			<component>
				<section>
					<code code="10157-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HISTORY OF FAMILY MEMBER DISEASES"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.103.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="家族史"/>
							<!--HDSD00.09.033 DE02.10.103.00 家族史 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/houseHistory/description"/></value>
						</observation>
					</entry>
				</section>
			</component>
			<!--
***************************
健康评估章节
***************************-->
			<component>
				<section>
					<code code="51848-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Assessment note"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.001.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="Apgar评分值"/>
							<!--HDSD00.09.001 DE05.10.001.00 Apgar评分值-->
							<value xsi:type="INT" value="{/Document/healthAssessment/apgarScore}"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="发育程度代码"/>
							<!--HDSD00.09.011 DE05.10.022.00 发育程度代码 -->
							<value xsi:type="CD" code="1" displayName="正力型" codeSystem="2.16.156.10011.2.3.2.53" codeSystemName="发育程度代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.142.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="精神状态正常标志"/>
							<!--HDSD00.09.035 DE05.10.142.00 精神状态正常标志 -->
							<value xsi:type="BL" value="true"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.065.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="睡眠状况"/>
							<!--HDSD00.09.060 DE05.10.065.00 睡眠状况 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/healthAssessment/sleepState"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.158.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="特殊情况"/>
							<!--HDSD00.09.061 DE05.10.158.00 特殊情况 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/healthAssessment/pecialState"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.084.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="心理状态代码"/>
							<!--HDSD00.09.070 DE05.10.084.00 心理状态代码 -->
							<value xsi:type="CD" code="2" displayName="抑郁" codeSystem="2.16.156.10011.2.3.1.140" codeSystemName="心理状态代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.097.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="营养状态代码"/>
							<!--HDSD00.09.079 DE05.10.097.00 营养状态代码 -->
							<value xsi:type="CD" code="1" displayName="良好" codeSystem="2.16.156.10011.2.3.2.54" codeSystemName="营养状态代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.122.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="自理能力代码"/>
							<!--HDSD00.09.086 DE05.10.122.00 自理能力代码 -->
							<value xsi:type="CD" code="1" displayName="完全自理" codeSystem="2.16.156.10011.2.3.2.55" codeSystemName="自理能力代码表"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--
***************************
生活方式章节
***************************-->
			<component>
				<section>
					<code displayName="生活方式"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE03.00.070.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="吸烟标志"/>
							<!--HDSD00.09.068 DE03.00.070.00 吸烟标志-->
							<value xsi:type="BL" value="true"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE03.00.073.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="吸烟状况代码"/>
							<!--HDSD00.09.069 DE03.00.073.00 吸烟状况代码 -->
							<value xsi:type="CD" code="1" displayName="从不吸烟" codeSystem="2.16.156.10011.2.3.2.5" codeSystemName="吸烟状况代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE03.00.053.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="日吸烟量(支)"/>
							<!--HDSD00.09.048 DE03.00.053.00 日吸烟量（支）-->
							<value xsi:type="PQ" value="{/Document/lifeWay/dailySmoking}" unit="支"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE03.00.065.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="停止吸烟天数"/>
							<!--HDSD00.09.065 DE03.00.065.00 停止吸烟天数 -->
							<value xsi:type="PQ" value="{/Document/lifeWay/stopSmokingDay}" unit="d"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE03.00.030.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="饮酒标志"/>
							<!--HDSD00.09.075 DE03.00.030.00 饮酒标志 -->
							<value xsi:type="BL" value="true"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE03.00.076.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="饮酒频率代码"/>
							<!--HDSD00.09.076 DE03.00.076.00 饮酒频率代码 -->
							<value xsi:type="CD" code="1" displayName="从不" codeSystem="2.16.156.10011.2.3.1.16" codeSystemName="饮酒频率代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE03.00.054.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="日饮酒量（mL）"/>
							<!--HDSD00.09.049 DE03.00.054.00 日饮酒量（mL）-->
							<value xsi:type="PQ" value="{/Document/lifeWay/dailyDrinking}" unit="mL"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE03.00.080.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="饮食情况代码"/>
							<!--HDSD00.09.077 DE03.00.080.00 饮食情况代码 -->
							<value xsi:type="CD" code="1" displayName="良好" codeSystem="2.16.156.10011.2.3.2.34" codeSystemName="饮食情况代码表"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--
***************************
入院诊断章节
***************************-->
			<component>
				<section>
					<code code="46241-6" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HOSPITAL ADMISSION DX"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断编码"/>
							<!--HDSD00.09.054 DE05.01.024.00 入院诊断编码 -->
							<value xsi:type="CD" code="B95.100" displayName="B族链球菌感染"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--
***************************
护理观察章节
***************************-->
			<component>
				<section>
					<code displayName="护理观察"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.031.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理观察项目名称"/>
							<!--HDSD00.09.022 DE02.10.031.00 护理观察项目名称 -->
							<value xsi:type="ST"><xsl:value-of select="/Document/nurse/observe/item"/></value>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.028.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理观察结果"/>
									<!--HDSD00.09.021 DE02.10.028.00 护理观察结果 -->
									<value xsi:type="ST"><xsl:value-of select="/Document/nurse/observe/result"/></value>
								</observation>
							</entryRelationship>
						</observation>
					</entry>
				</section>
			</component>
			<!--
***************************
住院过程章节
***************************-->
			<component>
				<section>
					<code code="8648-8" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Hospital Course"/>
					<text/>
					<!-- 通知医师情况 -->
					<entry typeCode="COMP">
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.280.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="通知医师标志"/>
							<value xsi:type="BL" value="true"/>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.279.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="通知医师日期时间"/>
									<value xsi:type="TS" value="{/Document/enterProcess/informDoctorTime}"/>/
								</observation>
							</entryRelationship>
						</observation>
					</entry>
					<!-- 评估日期时间 -->
					<entry typeCode="COMP">
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.144.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="评估日期时间"/>
							<value xsi:type="TS" value="{/Document/enterProcess/assessTime}"/>
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
