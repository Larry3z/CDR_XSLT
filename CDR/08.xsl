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
			<!--次要参与者签名 Authenticator-->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
			
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
      <!--既往史章节-->  
      <component> 
        <section> 
          <code code="11348-0" displayName="HISTORY OF PAST ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.10.165.00" displayName="有创诊疗操作标志" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>  
              <value xsi:type="BL" value="false"/> 
            </observation> 
          </entry>  
          <entry> 
            <!--过敏史标志-->  
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.10.023.00" displayName="过敏史标志" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>  
              <value xsi:type="BL" value="true"/>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE02.10.022.00" displayName="过敏史" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/Allergies//Allergy/FreeTextAllergy"/></value> 
                </observation> 
              </entryRelationship> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--生命体征章节-->  
      <component> 
        <section> 
          <code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="VITAL SIGNS"/>  
          <text/>  
          <!--体格检查-体重（kg）-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.188.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体重（kg）"/>  
              <value xsi:type="PQ" value="{/Document/shengmintizheng/weight}" unit="kg"/> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--入院诊断章节-->  
      <component> 
        <section> 
          <code code="46241-6" displayName="HOSPITAL ADMISSION DX" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--疾病诊断编码-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="疾病诊断编码"/>  
              <value xsi:type="CD"  code="B95.100" displayName="B族链球菌感染"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--治疗计划章节-->  
      <component> 
        <section> 
          <code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--处理及指导意见-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE06.00.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="处理及指导意见"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/TreatmentPlan/zhidaoyijian"/></value> 
            </observation> 
          </entry>  
          <!--医嘱使用备注-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE06.00.179.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="医嘱使用备注"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/TreatmentPlan/shiyongbeizhu"/></value> 
            </observation> 
          </entry>  
          <!--今后治疗方案-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE06.00.159.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="今后治疗方案"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/TreatmentPlan/zhiliaofangan"/></value> 
            </observation> 
          </entry>  
          <!--随访条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE06.00.108.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="随访方式"/>  
              <!--随访时间（数据元）-->  
              <effectiveTime value="{/Document/TreatmentPlan/suifangshijian}"/>  
              <value code="1" codeSystem="2.16.156.10011.2.3.1.183" codeSystemName="随访方式代码表" xsi:type="CD" displayName="门诊"/>  
              <!--随访周期建议代码-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.112.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="随访周期建议代码"/>  
                  <value xsi:type="CD" code="01" displayName="每2周" codeSystem="2.16.156.10011.2.3.1.184" codeSystemName="随访周期建议代码表"/> 
                </observation> 
              </entryRelationship> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--手术操作章节-->  
      <component> 
        <section> 
          <code code="47519-4" displayName="HISTORY OF PROCEDURES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <entry> 
            <!--1..1 手术记录-->  
            <procedure classCode="PROC" moodCode="EVN"> 
              <code code="84.51003" displayName="陶瓷脊椎融合物置入术" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表(ICD-9-CM)"/>  
              <!--操作日期/时间-->  
              <effectiveTime> 
                <!--操作结束日期时间-->  
                <high value="{/Document/OperationTechnique/date}"/> 
              </effectiveTime>  
              <!--操作名称-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.094.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="操作名称"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/OperationTechnique/name"/></value> 
                </observation> 
              </entryRelationship>  
              <!--操作目标部位名称-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.187.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术目标部位名称"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/OperationTechnique/position"/></value> 
                </observation> 
              </entryRelationship>  
              <!--介入物名称-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE08.50.037.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="介入物名称"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/OperationTechnique/intervene"/></value> 
                </observation> 
              </entryRelationship>  
              <!--操作方法描述-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.251.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="操作方法描述"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/OperationTechnique/way"/></value> 
                </observation> 
              </entryRelationship>  
              <!--操作次数-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.250.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="操作次数"/>  
                  <value xsi:type="INT" value="{/Document/OperationTechnique/times}"/> 
                </observation> 
              </entryRelationship> 
            </procedure> 
          </entry> 
        </section> 
      </component>  
      <!--用药管理章节-->  
      <component> 
        <section> 
          <code code="18610-6" codeSystem="2.16.840.1.113883.6.1" displayName="MEDICATION ADMINISTERED" codeSystemName="LOINC"/>  
          <text/>  
          <entry> 
            <substanceAdministration classCode="SBADM" moodCode="EVN"> 
              <!--药物使用途径代码-->  
              <routeCode code="1" displayName="口服" codeSystem="2.16.156.10011.2.3.1.158" codeSystemName="用药途径代码表"/>  
              <!--药物使用次剂量-->  
              <doseQuantity value="{/Document/DrugUse/dose}" unit="mg"/>  
              <consumable> 
                <manufacturedProduct> 
                  <manufacturedLabeledDrug> 
                    <!--药品代码及名称(通用名)-->  
                    <code/>  
                    <name><xsl:value-of select="/Document/DrugUse/name"/></name> 
                  </manufacturedLabeledDrug> 
                </manufacturedProduct> 
              </consumable>  
              <!--药物用法-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.136.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="药物用法"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/DrugUse/useway"/></value> 
                </observation> 
              </entryRelationship>  
              <!--中药使用类别代码-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.164.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="中药使用类别代码"/>  
                  <value xsi:type="CD" code="1" displayName="未使用" codeSystem="2.16.156.10011.2.3.1.157" codeSystemName="中药使用类别代码表"/> 
                </observation> 
              </entryRelationship>  
              <!--药物使用频率-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.133.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="药物使用频率"/>  
                  <value xsi:type="CD" code="01" displayName="bid" codeSystem="2.16.156.10011.2.3.1.267" codeSystemName="药物使用频次代码表"/> 
                </observation> 
              </entryRelationship>  
              <!--药物剂型代码-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE08.50.011.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="药物剂型代码"/>  
                  <value xsi:type="CD" code="01" displayName="片剂(素片、压制片),浸膏片,非包衣片" codeSystem="2.16.156.10011.2.3.1.211" codeSystemName="药物剂型代码表"/> 
                </observation> 
              </entryRelationship>  
              <!--药物使用剂量单位-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE08.50.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="药物使用剂量单位"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/DrugUse/danwei"/></value> 
                </observation> 
              </entryRelationship>  
              <!--药物使用总剂量-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.135.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="药物使用总剂量"/>  
                  <value xsi:type="PQ" value="{/Document/DrugUse/total}" unit="g"/> 
                </observation> 
              </entryRelationship> 
            </substanceAdministration> 
          </entry> 
        </section> 
      </component> 
    </structuredBody> 
  </component> 
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylesheet edited using Stylus Studio - (c) 2004-2009. Progress Software Corporation. All rights reserved. -->



