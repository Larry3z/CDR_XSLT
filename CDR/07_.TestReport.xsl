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
			<!--作者，保管机构-->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
						<!--主要参与者签名 legalAuthenticator--><xsl:comment>kaishi</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='医师']" mode="legalAuthenticator"/>
							<!--次要参与者签名 Authenticator-->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
			<!--次要参与者签名 Authenticator-->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
			
			
			  <!--检验申请机构及科室-->  
			  			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>

  <!--participant typeCode="PRF"> 
    <time/>
    <associatedEntity classCode="ASSIGNED"> 
      <scopingOrganization> 
        <id root="2.16.156.10011.1.26" extension="1290100"/>  
        <name>美容成形</name>  
        <asOrganizationPartOf> 
          <wholeOrganization> 
            <id root="2.16.156.10011.1.5" extension="1234567890"/>  
            <name>北京大学第三医院</name> 
          </wholeOrganization> 
        </asOrganizationPartOf> 
      </scopingOrganization> 
    </associatedEntity> 
  </participant>  
  <relatedDocument typeCode="RPLC"> 
    <parentDocument> 
      <id/>  
      <setId/>  
      <versionNumber/> 
    </parentDocument> 
  </relatedDocument-->  

<!-- 病床号、病房、病区、科室和医院的关联 -->
			<componentOf>
			<xsl:apply-templates select="Encounter" mode="Hosipitalization1"/>
			</componentOf>		



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
				<xsl:comment>诊断章节</xsl:comment>
				<xsl:apply-templates select="Diagnoses" mode="D1"/>
				
				<xsl:comment>实验室检查章节</xsl:comment>
				<xsl:apply-templates select="LaboratoryExamination" mode="LabE2"/>

<component>
					<section>				 
				 <xsl:comment>检查方法名称1..1R</xsl:comment>
						<xsl:apply-templates select="Diagnoses" mode="a"/>
				 <xsl:comment>检查类别1..1R</xsl:comment>
						<xsl:apply-templates select="Diagnoses" mode="a"/>
				 <xsl:comment>检查项目1..*R</xsl:comment>
						<xsl:apply-templates select="Diagnoses" mode="a"/>
					</section>
				</component>




				<xsl:comment>检查报告章节</xsl:comment>
				<component>
					<section>
						<code displayName="检查报告"/>
						<text/>
						<xsl:comment>检查报告结果-客观所见 0..1 R2</xsl:comment>
						<!--检查报告结果 1..1 R -->
						<xsl:apply-templates select="Diagnoses" mode="a"/>
						<xsl:comment> 检查报告科室名称1..1 R </xsl:comment>
						<!-- 检查报告科室名称1..1 R -->
						<xsl:apply-templates select="Diagnoses" mode="a"/>
						<xsl:comment>检查报告机构名称1..1 R3</xsl:comment>
						<!-- 检查报告机构名称1..1 R3-->
						<xsl:apply-templates select="Diagnoses" mode="a"/>
						<xsl:comment>检查报告备注0..1 R2</xsl:comment>
						<!--检查报告备注0..1 R2 -->
						<xsl:apply-templates select="Diagnoses" mode="a"/>
					</section>
				</component>
			</structuredBody>
		</component>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->	
	
	
	