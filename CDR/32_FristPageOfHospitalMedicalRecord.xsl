<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Diagnosis.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/LaboratoryExamination.xsl"/>
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
						<xsl:apply-templates select="Encounter/Patient/BirthTime" mode="BirthTime"/>
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
					<!--生命体征章节-->
					<xsl:comment>生命体征章节</xsl:comment>
					<component>
						<section>
							<!--入院体重 0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--医疗机构意见 0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
						</section>
					</component>
					<!--诊断记录章节-->
					<xsl:comment>诊断记录章节</xsl:comment>
					<component>
						<section>
							<!--门（急）诊诊断   1..* R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--病理诊断  1..* R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
						</section>
					</component>
					<!--主要健康问题章节-->
					<xsl:comment>主要健康问题章节</xsl:comment>
					<component>
						<section>
							<!--住院者疾病状态代码  1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--损伤和中毒外部原因  0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--颅脑损伤患者入院前昏迷时间  0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--颅脑损伤患者入院后昏迷时间  0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
						</section>
					</component>
					<!--转科记录章节-->
					<xsl:apply-templates select="Patient" mode="Blood"/>
					<!--出院诊断章节-->
					<xsl:comment>出院诊断章节</xsl:comment>
					<component>
						<section>
							<!--主要疾病   1..*  R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--其他疾病  1..*  R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--离院方式  1..1  R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
						</section>
					</component>
					<!--过敏史章节-->
					<xsl:apply-templates select="Patient" mode="Blood"/>
					<!--实验室检查章节-->
					<xsl:apply-templates select="Encounter/Patient/Blood" mode="LabE"/>
					<!--手术操作章节-->
					<xsl:apply-templates select="Patient" mode="Blood"/>
					<!--住院史章节-->
					<xsl:apply-templates select="Patient" mode="Blood"/>
					<!--住院过程章节-->
					<xsl:comment>住院过程章节</xsl:comment>
					<component>
						<section>
							<!--住院天数 1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--出院天数及病房 1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
						</section>
					</component>
					<!--行政管理章节-->
					<xsl:comment>行政管理章节</xsl:comment>
					<component>
						<section>
							<!--死亡患者尸检标志 0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--病案质量控制 0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
						</section>
					</component>
					<!--治疗计划章节-->
					<xsl:apply-templates select="Patient" mode="Blood"/>
					<!--费用章节-->
					<xsl:comment>费用章节</xsl:comment>
					<component>
						<section>
							<!--医疗付款方式 1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--住院总费用 1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--综合医疗服务费 1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--诊断类服务费 1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--治疗类服务费 1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--康复费类服务费 0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--中医治疗费 0..1 O-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--西药费 1..1 R-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--中药费 0..1 O-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--血液和血液制品类服务费 0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--耗材类费 0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
							<!--其他费 0..1 R2-->
							<xsl:apply-templates select="Patient" mode="Blood"/>
						</section>
					</component>
				</structuredBody>
			</component>
			
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
