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
			<!--入院信息章节 1..1 R-->
			<xsl:comment>入院信息章节</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<component>
				<section>
				<!--入院原因 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--入院途径 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--入病房方式 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>	
				</section>
			</component>
			<!--症状章节 补充LOINC代码 1..1 R-->
			<xsl:comment>症状章节 补充LOINC代码</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<!--生命体征章节 1..1 R-->
			<xsl:comment>生命体征章节</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<component>
				<section>
				<!--体温 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--脉搏 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--呼吸频率 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--血压 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--体重 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>	
				</section>
			</component>
			<!--既往史章节 1..1 R-->
			<xsl:comment>既往史章节</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<component>
				<section>
				<!--疾病史（含外伤） 0..* R2-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--传染病史 0..* R2-->				
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--预防接种史 0..* R2-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--手术史 0..* R2-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--输血史 0..* R2-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>	
				</section>
			</component>
			<!--过敏史章节 1..1 R-->
			<xsl:comment>过敏史章节</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<!--家族史章节 1..1 R-->
			<xsl:comment>家族史章节</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<!--健康评估章节 1..1 R-->
			<xsl:comment>健康评估章节</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<component>
				<section>
				<!--Apgar评分值 0..1 R2-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--发育程度 0..1 R2-->				
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--精神状态正常标志 0..1 R2-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--睡眠状况 0..1 R2-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--特殊情况 0..1 R2-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--心理状况 0..1 R2-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--营养状况 0..1 R2-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
                <!--自理能力 0..1 R2-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>	
				</section>
			</component>
			<!--生活方式章节 1..1 R-->
			<xsl:comment>生活方式章节</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<component>
				<section>
				<!--吸烟标志 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--吸烟状况 1..1 R-->				
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--日吸烟量 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--停止吸烟天数 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--饮酒标志 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--饮酒频率 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
				<!--日饮酒量 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
                <!--饮食情况代码 1..1 R-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>	
				</section>
			</component>
			<!--入院诊断章节 1..1 R-->
			<xsl:comment>入院诊断章节</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
			<!--护理观察章节 1..1 R-->
			<xsl:comment>护理观察章节</xsl:comment>
			<xsl:apply-templates select="Sections/Section" mode="mode"/>
		</structuredBody>
	</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->
