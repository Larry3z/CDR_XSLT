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
      <!--诊断记录章节-->  
      <component> 
        <section> 
          <code code="29548-5" displayName="Diagnosis" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--条目：诊断-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.01.024.00" displayName="诊断代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>  
              <!--诊断日期-->  
              <effectiveTime value="{/Document/Diagnosis/date}"/>  
              <value xsi:type="CD" code="B95.100" displayName="B族链球菌感染"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>  
              <performer> 
                <assignedEntity> 
                  <id/>  
                  <representedOrganization> 
                    <name><xsl:value-of select="/Document/Diagnosis/organization"/></name> 
                  </representedOrganization> 
                </assignedEntity> 
              </performer> 
            </observation> 
          </entry> 
        </section> 
      </component>  
			<!--实验室检查章节-->
			<component>
				<section>
					<code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="STUDIES SUMMARY"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.027.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验方法名称"></code>
							<value xsi:type="ST"><xsl:value-of select="/Document/shiyanshijiancha/fangfamingcheng"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.30.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验类别"></code>
							<value xsi:type="ST"><xsl:value-of select="/Document/shiyanshijiancha/jianchaleibie"/></value>
						</observation>
					</entry>
					
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.019.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验项目代码"></code>
									<!-- 检验时间 -->
									<effectiveTime value="{/Document/shiyanshijiancha/jianyanshijian}"/>
									<value xsi:type="ST"><xsl:value-of select="/Document/shiyanshijiancha/xiangmudaima"/></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE04.50.134.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="标本类别"></code>
											<!-- DE04.50.137.00	标本采样日期时间
		DE04.50.141.00	接收标本日期时间 -->
											<effectiveTime>
												<low value="{/Document/shiyanshijiancha/lowtime}"></low>
												<high value="{/Document/shiyanshijiancha/hightime}"></high>
											</effectiveTime>
											<value xsi:type="ST"><xsl:value-of select="/Document/shiyanshijiancha/biaobenleibie"/></value>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE04.50.135.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="标本状态"></code>
											<value xsi:type="ST"><xsl:value-of select="/Document/shiyanshijiancha/biaobenzhuangtai"/></value>
										</observation>
									</entryRelationship>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.017.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验结果代码"></code>
									<value xsi:type="CD" code="1" codeSystem="2.16.156.10011.2.3.2.38" codeSystemName="检查/检验结果代码表" displayName="异常"></value>
								</observation>
							</component>
							
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.015.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验定量结果"></code>
									<value xsi:type="REAL" value="{/Document/shiyanshijiancha/dljg}"></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE04.30.016.00" displayName="检查定量结果计量单位" codeSystemName="卫生信息数据元目录" codeSystem="2.16.156.10011.2.2.1" />
											<value xsi:type="ST"><xsl:value-of select="/Document/shiyanshijiancha/jldw"/></value>
										</observation>
									</entryRelationship>
								</observation>
							</component>
						</organizer>
					</entry>
				</section>
			</component> 
      <!--检验报告章节-->  
      <component> 
        <section> 
          <code displayName="检验报告"/>  
          <text/>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.50.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验报告结果"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/jianyanbaogao/jieguo"/></value> 
            </observation> 
          </entry>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE08.10.026.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验报告科室"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/jianyanbaogao/keshi"/></value> 
            </observation> 
          </entry>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE08.10.013.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验报告机构名称"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/jianyanbaogao/jigoumingcheng"/></value> 
            </observation> 
          </entry>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE06.00.179.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验报告备注"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/jianyanbaogao/beizhu"/></value> 
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
	
	
	