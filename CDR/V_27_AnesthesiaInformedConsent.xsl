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
					<!-- 门诊号 -->
					<xsl:apply-templates select="Sections/Section" mode="mode"/>
					<!-- 住院号标识 -->
					<xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/>
					<!--患者信息 -->
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
			<!--麻醉医师签名 DE02.01.039.00 -->
			<legalAuthenticator typeCode="LA">
				<!-- DE09.00.053.00麻醉医师签名日期时间 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--签名 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</legalAuthenticator>
			<!-- 患者签名 -->
			<authenticator>
				<!-- DE09.00.053.00签名日期时间 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--签名 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<!--代理人签名-->
			<authenticator>
				<!-- DE09.00.053.00签名日期时间 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--代理人关系-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--签名 1..1 -->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<!--关联活动信息 1..R-->
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
			<!--文档体-->
				<component>
		<structuredBody>
			<!--
****************************
术前诊断章节
****************************-->
			<component>
				<section>
					<code code="10219-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Surgical operation note preoperative Dx"/>
					<text/>
					<!--术前诊断编码-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术前诊断编码"/>
							<value xsi:type="CD"  code="B95.100" displayName="B族链球菌感染"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10" />
						</observation>
					</entry>
				</section>
			</component>
			<!--
****************************
治疗计划章节
****************************-->
			<component>
				<section>
					<code code="18776-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="TREATMENT PLAN"/>
					<text/>
					<entry>
						<!--拟实施麻醉-->
						<procedure classCode="PROC" moodCode="EVN">
							<code code="1" codeSystem="2.16.156.10011.2.3.1.159" codeSystemName=" 麻醉方法代码表" displayName="全身麻醉"/>
							<statusCode code="new"/>
							<!--拟实施时间-->
							<effectiveTime value="12737483828382"/>
							<!--拟实施手术-->
							<entryRelationship typeCode="CAUS">
								<procedure classCode="PROC" moodCode="EVN">
									<code code="1" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表（ICD-9-CM)" displayName="阑尾炎手术"/>
								</procedure>
							</entryRelationship>
							<!--拟行有创操作和检测方法-->
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.073.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="拟行有创操作和检测方法"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/treatPlan/invasiveMonitor"/></value>
								</observation>
							</entryRelationship>
							<!--基础疾病可能对麻醉产生的影像-->
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="DEF">
									<code code="DE05.10.146.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="基础疾病可能对麻醉产生的影响"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/treatPlan/basicNarcosisImage"/></value>
									<!--基础疾病-->
									<entryRelationship typeCode="CAUS">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE04.01.121.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="患者基础疾病"/>
											<value xsi:type="ST"><xsl:value-of select="/Document/treatPlan/basicDiseases"/>基础疾病</value>
										</observation>
									</entryRelationship>
								</observation>
							</entryRelationship>
							<!--使用麻醉镇痛泵标志-->
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="DEF">
									<code code="DE06.00.240.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="使用麻醉镇痛汞标志"/>
									<value xsi:type="BL" value="true"/>
								</observation>
							</entryRelationship>
							<!--参加麻醉安全保险标志-->
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="DEF">
									<code code="DE01.00.016.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="参加麻醉安全保险标志"/>
									<value xsi:type="BL" value="true"/>
								</observation>
							</entryRelationship>
						</procedure>
					</entry>
				</section>
			</component>
			<!--
****************************
意见章节
****************************-->
			<component>
				<section>
					<code displayName="意见章节"/>
					<text/>
					<!--医疗机构意见-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="医疗机构的意见"/>
							<value xsi:type="ST">医疗机构意见</value>
						</observation>
					</entry>
					<!--患者意见-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="患者的意见"/>
							<value xsi:type="ST">患者意见</value>
						</observation>
					</entry>
				</section>
			</component>
			<!--
****************************
风险章节
****************************-->
			<component>
				<section>
					<code displayName="操作风险"/>
					<text/>
					<!--麻醉中可能出现的意外-->
					<entry>
						<observation classCode="OBS" moodCode="DEF">
							<code code="DE05.01.075.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉中，麻醉后可能产发生的意外及并发症"/>
							<value xsi:type="ST">患者育龄女性，既往剖宫产史，否认高血压、糖尿病、心脑血管病史；否认药物、食物过敏史；否认腰椎外伤；否认服用抗凝药物史；否认哮喘、青光眼病史；平素活动量可，无明显心慌气短症状，查体：一般情况可，心肺听诊未见明显异常，未见明显硬膜外及腰麻禁忌症，ASA I级。
麻醉计划：拟行椎管内麻醉，选择合适的穿刺间隙，注意药物的剂量，注药的方向，控制合理的麻醉平面；注意仰卧位低血压综合征，警惕羊水栓塞；术中维持出入量及电解质平衡；术毕嘱患者去枕平卧。
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
