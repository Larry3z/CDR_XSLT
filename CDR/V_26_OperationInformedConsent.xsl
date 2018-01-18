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
			<!--作者，保管机构1..1-->
			<xsl:apply-templates select="Author" mode="Author1"/>
			<xsl:apply-templates select="Custodian" mode="Custodian"/>
			<!-- 医生签名 1..1 -->
			<authenticator>
				<!--签名日期时间 1..1-->
				<xsl:apply-templates select="/authenticator/signatureTime"/>
				<!--医生签名 1..1-->
				<xsl:apply-templates select="/authenticator/doctorSignature"/>
				<!--职务类别代码 1..1 +displayName 1..1-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<!-- 手术者签名 1..1 -->
			<authenticator>
				<!--签名日期时间 1..1-->
				<xsl:apply-templates select="/operator/signatureTime"/>
				<!--手术者签名 1..1-->
				<xsl:apply-templates select="/operator/operatorSignature"/>
				<!--职务类别代码 1..1 +displayName 1..1-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<!-- 患者签名 1..1 -->
			<authenticator>
				<!--签名日期时间 1..1-->
				<xsl:apply-templates select="/patient/signatureTime"/>
				<!--患者签名 1..1-->
				<xsl:apply-templates select="/patient/patientSignature"/>
				<!--职务类别代码 1..1 +displayName 1..1-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<!-- 代理人签名 1..1 -->
			<authenticator>
				<!--签名日期时间 1..1-->
				<xsl:apply-templates select="/agent/signatureTime"/>
				<!--代理人签名 1..1-->
				<xsl:apply-templates select="/agent/agentSignature"/>
				<!--职务类别代码 1..1 +displayName 1..1-->
				<xsl:apply-templates select="Sections/Section" mode="mode"/>
			</authenticator>
			<relatedDocument typeCode="RPLC">
				<!--文档中医疗卫生事件的就诊场景,即入院场景记录-->
				<parentDocument>
					<id/>
					<setId/>
					<versionNumber/>
				</parentDocument>
			</relatedDocument>
			<!-- 病床号、病房、病区、科室和医院的关联 1..R-->
			<componentOf>
				<encompassingEncounter>
					<!--入院时间 1..1-->
					<xsl:apply-templates select="/Document/CreationTime"/>
					<location>
						<healthCareFacility>
							<serviceProviderOrganization>
								<asOrganizationPartOf classCode="PART">
									<!-- DE01.00.026.00病床号 1..1 -->
									<xsl:apply-templates select="/Document/bedNo"/>
									<!-- DE01.00.019.00病房号1..1 -->
									<xsl:apply-templates select="/Document/sickroomNo"/>
									<!-- DE08.10.026.00科室名称 1..1 -->
									<xsl:apply-templates select="/Document/department"/>
									<!-- DE08.10.054.00病区名称 1..1 -->
									<xsl:apply-templates select="/Document/infectedPatch"/>
									<!--医疗机构名称 1..1 -->
									<xsl:apply-templates select="/Document/Custodian/Organization/name"/>
								</asOrganizationPartOf>
							</serviceProviderOrganization>
						</healthCareFacility>
					</location>
				</encompassingEncounter>
			</componentOf>
			<component> 
    <structuredBody> 
      <!--
******************************
术前诊断章节
******************************-->  
      <component> 
        <section> 
          <code code="10219-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Surgical operation note preoperative Dx"/>  
          <text/>  
          <entry typeCode="COMP"> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>  
              <value xsi:type="CD"  code="B95.100" displayName="B族链球菌感染"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10" /> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--
******************************
治疗计划章节
******************************-->  
      <component> 
        <section> 
          <code code="18776-5" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="TREATMENT PLAN"/>  
          <text/>  
          <!--拟实施手术-->  
          <entry> 
            <!--拟实施手术-->  
            <procedure classCode="PROC" moodCode="RQO"> 
              <code code="84.51003" displayName="陶瓷脊椎融合物置入术" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表(ICD-9-CM)" />  
              <statusCode code="new"/>  
              <!--手术时间-->  
              <effectiveTime value="000000000000"/>  
              <!--手术方式描述-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.302.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术方式"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/treatPlan/operationWay"/></value> 
                </observation> 
              </entryRelationship>  
              <!--手术前的准备-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.271.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术前准备"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/treatPlan/preoperotivePreparation"/></value> 
                </observation> 
              </entryRelationship>  
              <!--手术禁忌症-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="DEF"> 
                  <code code="DE05.10.141.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术禁忌症"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/treatPlan/surgicalContraindication"/></value> 
                </observation> 
              </entryRelationship>  
              <!--手术指征-->  
              <entryRelationship typeCode="RSON"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.340.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术指征"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/treatPlan/operationIndication"/></value> 
                </observation> 
              </entryRelationship>  
              <!--拟麻醉信息-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.073.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="拟实施麻醉方法代码"/>  
                  <value code="1" codeSystem="2.16.156.10011.2.3.1.159" codeSystemName="麻醉方法代码表" xsi:type="CD" displayName="全身麻醉"/> 
                </observation> 
              </entryRelationship> 
            </procedure> 
          </entry>  
          <!--替代方案-->  
          <entry> 
            <observation classCode="OBS" moodCode="DEF"> 
              <code code="DE06.00.301.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="替代方案"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/treatPlan/replaceScheme"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--
******************************
意见章节
******************************-->  
      <component> 
        <section> 
          <code displayName="意见章节"/>  
          <text/>  
          <!--医疗机构意见-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE06.00.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="医疗机构的意见"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/suggestion/medicalInstitution"/></value> 
            </observation> 
          </entry>  
          <!--患者意见-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE06.00.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="患者的意见"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/suggestion/patientOpinion"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--
******************************
风险章节
******************************-->  
      <component> 
        <section> 
          <code displayName="操作风险"/>  
          <text/>  
          <!--手术中可能出现的意外-->  
          <entry> 
            <observation classCode="OBS" moodCode="DEF"> 
              <code code="DE05.10.162.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术中可能出现的意外及风险"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/operationRisk/inOperativeRick"/></value> 
            </observation> 
          </entry>  
          <!--手术后可能出现的意外-->  
          <entry> 
            <observation classCode="OBS" moodCode="DEF"> 
              <code code="DE05.01.075.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术后可能出现的意外以及风险"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/operationRisk/aftertraOperativeRick"/></value> 
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
