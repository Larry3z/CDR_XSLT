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
			<!--主要参与者签名 legalAuthenticator-->
			<xsl:comment>kaishi</xsl:comment>
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole='医师']" mode="legalAuthenticator"/>
			<!--次要参与者签名 Authenticator-->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
			<!--次要参与者签名 Authenticator-->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
			<!-- 检查申请机构及科室 -->
			<xsl:apply-templates select="Practitioners/Practitioner[PractitionerRole!='医师']" mode="Authenticator"/>
			<!--participant typeCode="PRF"> 
    <time/>
    <associatedEntity classCode="ASSIGNED"> 
      <scopingOrganization> 
        <id root="2.16.156.10011.1.26" extension="{/Document/assignedPersonCode1}"/>
        <name>
        							<xsl:value-of select="name1"/>
</name>  
        <asOrganizationPartOf> 
          <wholeOrganization> 
            <id root="2.16.156.10011.1.5" extension="{/Document/assignedPersonCode1}"/>
            <name>							<xsl:value-of select="name2"/>
</name> 
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
      <!-- 诊断记录章节-->  
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
              <value xsi:type="CD" code="B95.100" displayName="B族链球菌感染" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>  
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
      <!-- 主诉章节 -->  
      <component> 
        <section> 
          <code code="10154-3" displayName="CHIEF COMPLAINT" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--主诉条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.01.119.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="主诉"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/Section/textContent"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!-- 症状章节 -->  
      <component> 
        <section> 
          <code code="11450-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="PROBLEM LIST"/>  
          <text/>  
          <!-- 症状描述条目 -->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.01.117.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="症状描述"/>  
              <!-- 症状开始时间与停止时间 -->  
              <effectiveTime> 
                <low value="{/Document/zhengzhuang/lowtime}"/>  
                <high value="{/Document/zhengzhuang/hightime}"/> 
              </effectiveTime>  
              <value xsi:type="ST"><xsl:value-of select="/Document/text"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!-- 手术操作章节 -->  
      <component> 
        <section> 
          <code code="47519-4" displayName="HISTORY OF PROCEDURES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <entry> 	
            <!-- 1..1 手术记录 -->  
            <procedure classCode="PROC" moodCode="EVN"> 
              <code code="54.74002" displayName="大网膜包肾术" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表(ICD-9-CM)"/>  
              <statusCode/>  
              <!--操作日期/时间-->  
              <effectiveTime value="{/Document/OperationTechnique/date}"/>  
              <!-- 操作部位代码 -->  
              <targetSiteCode code="99" codeSystem="2.16.156.10011.2.3.1.266" codeSystemName="操作部位代码表" displayName="其他"/>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.094.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术（操作）名称"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/OperationTechnique/name"/></value> 
                </observation> 
              </entryRelationship>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE08.50.037.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="介入物名称"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/OperationTechnique/intervene"/></value> 
                </observation> 
              </entryRelationship>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.251.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="操作方法描述"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/OperationTechnique/way"/></value> 
                </observation> 
              </entryRelationship>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.250.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="操作次数"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/OperationTechnique/times"/></value> 
                </observation> 
              </entryRelationship>  
              <!-- 0..1 麻醉信息 -->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.073.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉方式代码"/>  
                  <value code="1" displayName="全身麻醉" codeSystem="2.16.156.10011.2.3.1.159" codeSystemName="麻醉方法代码表" xsi:type="CD"/>  
                  <!-- 麻醉医师签名 -->  
                  <performer> 
                    <assignedEntity> 
                      <id/>  
                      <assignedPerson> 
                        <name><xsl:value-of select="/Document/OperationTechnique/mazuiyishi"/></name> 
                      </assignedPerson> 
                    </assignedEntity> 
                  </performer> 
                </observation> 
              </entryRelationship>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE02.10.028.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉观察结果"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/OperationTechnique/observation"/></value> 
                </observation> 
              </entryRelationship>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE06.00.307.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉中西医标识代码"/>  
                  <value code="1" codeSystem="2.16.156.10011.2.3.2.41" displayName="西医麻醉" codeSystemName="麻醉中西医标识代码表" xsi:type="CD"/> 
                </observation> 
              </entryRelationship> 
            </procedure> 
          </entry> 
        </section> 
      </component>  
      <!-- 体格检查章节-->  
      <component> 
        <section> 
          <code code="29545-1" displayName="PHYSICAL EXAMINATION" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--特殊检查条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.01.079.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="特殊检查标志"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/tigejiancha/jianchabiaozhi"/></value> 
            </observation> 
          </entry>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.10.027.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查方法名称"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/tigejiancha/fangfamingcheng"/></value> 
            </observation> 
          </entry>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.30.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查类别"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/tigejiancha/jianchaleibie"/></value> 
            </observation> 
          </entry>  
          <entry> 
            <organizer classCode="CLUSTER" moodCode="EVN"> 
              <statusCode/>  
              <component> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE04.30.019.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查项目代码"/>  
                  <!-- 检查日期 -->  
                  <effectiveTime value="{/Document/tigejiancha/jianchariqi}"/>  
                  <value xsi:type="ST"><xsl:value-of select="/Document/tigejiancha/xiangmudaima"/></value>  
                  <entryRelationship typeCode="COMP"> 
                    <observation classCode="OBS" moodCode="EVN"> 
                      <code code="DE04.30.019.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="标本类别"/>  
                      <!-- DE04.50.137.00标本采样日期时间
DE04.50.141.00 接收标本日期时间 -->  
                      <effectiveTime> 
                        <low value="{/Document/tigejiancha/lowtime}"/>  
                        <high value="{/Document/tigejiancha/hightime}"/> 
                      </effectiveTime>  
                      <value xsi:type="ST"><xsl:value-of select="/Document/tigejiancha/biaobenleibie"/></value> 
                    </observation> 
                  </entryRelationship>  
                  <entryRelationship typeCode="COMP"> 
                    <observation classCode="OBS" moodCode="EVN"> 
                      <code code="DE04.50.135.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="标本状态"/>  
                      <value xsi:type="ST"><xsl:value-of select="/Document/tigejiancha/biaobenzhuangtai"/></value> 
                    </observation> 
                  </entryRelationship>  
                  <entryRelationship typeCode="COMP"> 
                    <observation classCode="OBS" moodCode="EVN"> 
                      <code code="DE04.30.019.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="标本固定液名称"/>  
                      <value xsi:type="ST"><xsl:value-of select="/Document/tigejiancha/gdymc"/></value> 
                    </observation> 
                  </entryRelationship> 
                </observation> 
              </component>  
              <component> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE04.30.017.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="-"/>  
                  <value xsi:type="CD" code="3" displayName="不确定" codeSystem="2.16.156.10011.2.3.2.38" codeSystemName="检查/检验结果代码表"/> 
                </observation> 
              </component>  
              <component> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE04.30.015.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查定量结果"/>  
                  <value xsi:type="REAL" value="{/Document/tigejiancha/dljg}"/>  
                  <entryRelationship typeCode="COMP"> 
                    <observation classCode="OBS" moodCode="EVN"> 
                      <code code="DE04.30.016.00" displayName="检查定量 结果计量单位" codeSystemName="卫生信息数据元目录" codeSystem="2.16.156.10011.2.2.1"/>  
                      <value xsi:type="ST"><xsl:value-of select="/Document/tigejiancha/jldw"/></value> 
                    </observation> 
                  </entryRelationship> 
                </observation> 
              </component> 
            </organizer> 
          </entry> 
        </section> 
      </component>  
      <!-- 其他处置章节 -->  
      <component> 
        <section> 
          <code displayName="其他处置章节"/>  
          <text/>  
          <!-- 诊疗过程描述 -->  
          <entry typeCode="COMP"> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE06.00.296.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="诊疗过程描述"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/qitachuzhizhangjie/gcms"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!-- 检查报告章节 -->  
      <component> 
        <section> 
          <code displayName="检查报告"/>  
          <text/>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.50.131.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查报告结果-客观所见"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/jianchabaogao/keguansuojian"/></value> 
            </observation> 
          </entry>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.50.132.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查报告结果-主观提示"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/jianchabaogao/zhuguantishi"/></value> 
            </observation> 
          </entry>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE08.10.026.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查报告科室"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/jianchabaogao/keshi"/></value> 
            </observation> 
          </entry>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE08.10.013.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查报告机构名称"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/jianchabaogao/jigoumingcheng"/></value> 
            </observation> 
          </entry>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE06.00.179.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查报告备注"/>  
              <value xsi:type="ST"><xsl:value-of select="/Document/jianchabaogao/beizhu"/></value> 
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
