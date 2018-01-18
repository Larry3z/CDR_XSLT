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
				<code code="C0005" codeSystem="2.16.156.10011.2.4" codeSystemName="卫生信息共享文档规范编码体系"/>
	<title>中药处方</title>

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
						<!--xsl:apply-templates select="Encounter/Patient" mode="Age"/-->
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
			<!--
********************************************************
诊断章节
********************************************************
-->
			<!--诊断章节-->
			<component>
				<section>
					<code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--条目：诊断-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.024.00" displayName="西医诊断编码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="CD" code="K31.500" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10" displayName="十二指肠梗阻"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="中医诊断病名代码">
								<qualifier>
									<name displayName="中医诊断病名代码"/>
								</qualifier>
							</code>
							<value xsi:type="CD" code="BNS130" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)" displayName="关格病"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="中医证候代码">
								<qualifier>
									<name displayName="中医证候代码"/>
								</qualifier>
							</code>
							<value xsi:type="CD" code="BWA010" displayName="石瘿病" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--
********************************************************
用药章节
********************************************************
-->
			<!--用药章节 1..*-->
			<component>
				<section>
					<code code="10160-0" displayName="HISTORY OF MEDICATION USE" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--处方条目-->
					<entry>
						<substanceAdministration classCode="SBADM" moodCode="EVN">
							<text/>
							<routeCode code="1" displayName="口服" codeSystem="2.16.156.10011.2.3.1.158" codeSystemName="用药途径代码表"/>
							<!--用药剂量-单次 -->
							<doseQuantity value="{/Document/DrugUse/dose}" unit="mg"/>
							<!--用药频率 -->
							<rateQuantity>
							     <translation code="{/Document/DrugUse/times}" displayName="bid"/>
							</rateQuantity>
							<!--药物剂型 -->
							<administrationUnitCode code="47" displayName="灌汤剂" codeSystem="2.16.156.10011.2.3.1.211" codeSystemName="药物剂型代码表"></administrationUnitCode>
							<consumable>
								<manufacturedProduct>
									<manufacturedLabeledDrug>
										<!--药品代码及名称(通用名) -->
										<code/>
																				<name><xsl:value-of select="/Document/DrugUse/name"/> </name>

									</manufacturedLabeledDrug>
								</manufacturedProduct>
							</consumable>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE08.50.043.00" displayName="药物规格" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/DrugUse/size"/></value>
								</observation>
							</entryRelationship>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.135.00" displayName="药物使用总剂量" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="PQ" value="{/Document/DrugUse/total}" unit="mg"/>
								</observation>
							</entryRelationship>
						</substanceAdministration>
					</entry>
					<!--处方有效天数-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.294.00" displayName="处方有效天数" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="PQ" value="{/Document/DrugUse/days}"  unit="天"/>
						</observation>
					</entry>
					<!--处方药品组号-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE08.50.056.00" displayName="处方药品组号" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="INT" value="{/Document/DrugUse/group}"/>
						</observation>
					</entry>
					<!--中药饮片处方-->
					<entry>
						<observation classCode="OBS" moodCode="EVN ">
							<code code="DE08.50.049.00" displayName="中药饮片处方" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="ST"><xsl:value-of select="/Document/DrugUse/text"/></value>
							<!--中药饮片剂数-->
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE08.50.050.00" displayName="中药饮片剂数" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="PQ" value="{/Document/DrugUse/MedicinePieces/times}" unit="剂"/>
								</observation>
							</entryRelationship>
							<!--中药饮片煎煮法-->
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE08.50.047.00" displayName="中药煎煮法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/DrugUse/MedicinePieces/boilingway"/></value>
								</observation>
							</entryRelationship>
							<!--中药用药方法-->
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN ">
									<code code="DE06.00.136.00" displayName="中药用药法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/DrugUse/MedicinePieces/useway"/></value>
								</observation>
							</entryRelationship>
						</observation>
					</entry>
					<!-- 处方类别代码 DE08.50.032.00 处方类别代码 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE08.50.032.00" displayName="处方类别代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="CD" code="1" codeSystem="2.16.156.10011.2.3.2.40" codeSystemName="处方类别代码表" displayName="中药饮片处方"/>
						</observation>
					</entry>
				</section>
			</component>
			<!--
**********************************************
费用章节
**********************************************
-->
			<component>
				<section>
					<code code="48768-6" displayName="PAYMENT SOURCES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE07.00.004.00" displayName="处方药品金额" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="MO"  value="{/Document/cost/cost4}" currency="元"/>
						</observation>
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
					<!--处方备注信息-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.179.00" displayName="处方备注信息" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
							<value xsi:type="ST"><xsl:value-of select="/Document/TreatmentPlan/postscript"/></value>
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
		</structuredBody>
	</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
