<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Diagnosis.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/PhysicalExamination.xsl"/>
	<!--xsl:include href="CDA-Support-Files/Export/Section-Modules/Encounter.xsl"/-->
	<xsl:template match="/Document">
		<ClinicalDocument xmlns:mif="urn:hl7-org:v3/mif" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:hl7-org:v3">
			<xsl:apply-templates select="." mode="CDAHeader"/>
			
			<xsl:comment>病人信息</xsl:comment>
			<recordTarget typeCode="RCT" contextControlCode="OP">
				<patientRole classCode="PAT">
					<!-- 住院号标识 -->
					<xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/>
					<!-- 现住址  门牌号、村、乡、县、市、省、邮政编码、联系电话-->
					<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
					<patient classCode="PSN" determinerCode="INSTANCE">
						<!--患者身份证号-->
						<xsl:apply-templates select="Encounter/Patient" mode="IDNo"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Name"/>
						<xsl:apply-templates select="Encounter/Patient" mode="Gender"/>
						<xsl:apply-templates select="Encounter/Patient" mode="BirthTime"/>
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"  婚姻状况代码     /-->
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"   民族代码/-->
						<!-- 年龄 -->
						<!--xsl:apply-templates select="Encounter/Patient" mode="Age"/-->
						<!--职业状况-->
						<!--xsl:apply-templates select="Encounter/Patient" mode="InpatientID"/-->
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
      <!--主诉章节-->  
      <component> 
        <section> 
          <code code="10154-3" displayName="CHIEF COMPLAINT" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--主诉条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.01.119.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="主诉"/>  
              <value xsi:type="ST"><xsl:value-of select="Cc/Record"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--现病史章节-->  
      <component> 
        <section> 
          <code code="10164-2" displayName="HISTORY OF PRESENT ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--现病史条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.10.071.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="现病史"/>  
              <value xsi:type="ST"><xsl:value-of select="hpi/Record"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--既往史章节-->  
      <component> 
        <section> 
          <code code="11348-0" displayName="HISTORY OF PAST ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--一般健康状况标志-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.10.031.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="一般健康状况标志"/>  
              <value xsi:type="BL" value="{PMH/GHsign}"/>  
              <!--疾病史（含外伤）-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE02.10.026.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="疾病史（含外伤）"/>  
                  <value xsi:type="ST"><xsl:value-of select="PMH/DH"/></value> 
                </observation> 
              </entryRelationship> 
            </observation> 
          </entry>  
          <!--患者传染性标志-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.10.119.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="患者传染性标志"/>  
              <value xsi:type="BL" value="{PMH/InfectiousSign}"/>  
              <!--传染病史-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE02.10.008.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="传染病史"/>  
                  <value xsi:type="ST"><xsl:value-of select="PMH/IH"/></value> 
                </observation> 
              </entryRelationship> 
            </observation> 
          </entry>  
          <!--婚育史条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.10.098.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="婚育史"/>  
              <value xsi:type="ST"><xsl:value-of select="PMH/EH"/></value> 
            </observation> 
          </entry>  
          <!--过敏史条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.10.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="过敏史"/>  
              <value xsi:type="ST"><xsl:value-of select="PMH/AH"/></value> 
            </observation> 
          </entry>  
          <!--手术史条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.10.061.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术史"/>  
              <value xsi:type="ST"><xsl:value-of select="PMH/SH"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--预防免疫史章节-->  
      <component> 
        <section> 
          <code code="11369-6" displayName="HISTORY OF IMMUNIZATIONS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.10.101.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="预防接种史"/>  
              <value xsi:type="ST"><xsl:value-of select="PMH/ImmH"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--输血章节-->  
      <component> 
        <section> 
          <code code="56836-0" displayName="History of blood transfusion" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--输血史条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.10.100.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血史"/>  
              <value xsi:type="ST"><xsl:value-of select="PMH/BtH"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--个人史章节-->  
      <component> 
        <section> 
          <code code="29762-2" displayName="Social history" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--个人史条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.10.097.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="个人史"/>  
              <value xsi:type="ST"><xsl:value-of select="PMH/PH"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--月经史章节-->  
      <component> 
        <section> 
          <code code="49033-4" displayName="Menstrual History" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--月经史条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.10.102.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="月经史"/>  
              <value xsi:type="ST"><xsl:value-of select="PMH/MH"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--家族史章节-->  
      <component> 
        <section> 
          <code code="10157-6" displayName="HISTORY OF FAMILY MEMBER DISEASES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--家族史条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.10.103.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="家族史"/>  
              <value xsi:type="ST"><xsl:value-of select="PMH/FH"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--生命体征章节-->  
      <component> 
        <section> 
          <code code="8716-3" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="VITAL SIGNS"/>  
          <text/>  
          <!--体格检查-体温（℃）-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.186.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体温（℃）"/>  
              <value xsi:type="PQ" value="{VitalSigns/Btemperature}" unit="℃"/> 
            </observation> 
          </entry>  
          <!--体格检查-脉率（次/min）-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.118.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="脉率（次/min）"/>  
              <value xsi:type="PQ" value="{VitalSigns/Pfrequency}" unit="次/min"/> 
            </observation> 
          </entry>  
          <!--体格检查-呼吸频率（次/min）-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.082.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="呼吸频率（次/min）"/>  
              <value xsi:type="PQ" value="{VitalSigns/Breathrate}" unit="次/min"/> 
            </observation> 
          </entry>  
          <!--体格检查-血压（mmHg）-->  
          <entry> 
            <organizer classCode="BATTERY" moodCode="EVN"> 
              <code displayName="血压"/>  
              <statusCode/>  
              <component> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE04.10.174.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="收缩压"/>  
                  <value xsi:type="PQ" value="{VitalSigns/ssBP}" unit="mmHg"/> 
                </observation> 
              </component>  
              <component> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE04.10.176.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="舒张压"/>  
                  <value xsi:type="PQ" value="{VitalSigns/szBP}" unit="mmHg"/> 
                </observation> 
              </component> 
            </organizer> 
          </entry>  
          <!--体格检查-身高（cm）-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.167.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="身高（cm）"/>  
              <value xsi:type="PQ" value="{VitalSigns/height}" unit="cm"/> 
            </observation> 
          </entry>  
          <!--体格检查-体重（kg）-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.188.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体重（kg）"/>  
              <value xsi:type="PQ" value="{VitalSigns/weight}" unit="kg"/> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--体格检查章节-->  
      <component> 
        <section> 
          <code code="29545-1" displayName="PHYSICAL EXAMINATION" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--体格检查-一般状况检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.219.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="一般状况检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="PhysicalCheck/ybzk"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-皮肤和黏膜检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.126.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="皮肤和黏膜检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="PhysicalCheck/pfnmjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-全身浅表淋巴结检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.114.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="全身浅表淋巴结检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="PhysicalCheck/lbjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-头部及其器官检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.261.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="头部及其器官检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="PhysicalCheck/tbjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-颈部检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.255.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="颈部检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="PhysicalCheck/jbjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-胸部检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.263.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胸部检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="PhysicalCheck/xbjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-腹部检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.046.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="腹部检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="PhysicalCheck/fbjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-肛门指诊检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.065.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="肛门指诊检查结果描述"/>  
              <value xsi:type="ST"><xsl:value-of select="PhysicalCheck/gmzz"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-外生殖器检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.195.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="外生殖器检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="PhysicalCheck/szqjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-脊柱检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.093.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="脊柱检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="PhysicalCheck/jzjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-四肢检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.179.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="四肢检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="PhysicalCheck/szjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-神经系统检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.10.149.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="神经系统检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="PhysicalCheck/sjxtjc"/></value> 
            </observation> 
          </entry>  
          <!--专科情况-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE08.10.061.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="专科情况"/>  
              <value xsi:type="ST"><xsl:value-of select="PhysicalCheck/zkqk"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--辅助检查章节-->  
      <component> 
        <section> 
          <code displayName="辅助检查"/>  
          <text/>  
          <!--辅助检查结果条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.30.009.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="辅助检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="AuxiliaryExamina/Record"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--
********************************************************
主要健康问题章节
********************************************************
-->  
      <component> 
        <section> 
          <code code="11450-4" displayName="PROBLEM LIST" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--陈述内容可靠标志-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.10.143.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="陈述内容可靠标志"/>  
              <value xsi:type="BL" value="{MajorHealthProblems/StateReliaSign}"/> 
            </observation> 
          </entry>  
          <!--初步诊断-西医条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="初步诊断-西医诊断名称"/>  
              <!--初步诊断日期-->  
              <effectiveTime value="{MajorHealthProblems/cz/CurrentDiagnosis/czTime}"/>  
              <value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/cz/CurrentDiagnosis/Name"/></value>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <!--初步诊断-西医诊断编码-代码-->  
                  <code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="初步诊断-西医诊断编码"/>  
                  <value xsi:type="CD" code="{MajorHealthProblems/cz/CurrentDiagnosis/code}" displayName="{MajorHealthProblems/cz/CurrentDiagnosis/displayName}"  codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/> 
                </observation> 
              </entryRelationship>  
              <!--入院诊断顺位-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE05.01.080.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断顺位"/> 
                  <value xsi:type="INT" value="{MajorHealthProblems/cz/CurrentDiagnosis/ryNum}"/> 
                </observation> 
              </entryRelationship> 
            </observation> 
          </entry>  
          <!--中医“四诊”观察结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.10.028.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="中医“四诊”观察结果"/>  
              <value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/cz/TCM/TCPsizhen"/></value> 
            </observation> 
          </entry>  
          <!--初步诊断-中医条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="初步诊断-中医病名名称"/>  
              <!--初步诊断日期-->  
              <effectiveTime value="{MajorHealthProblems/cz/TCM/czTime}"/>  
              <value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/cz/TCM/Name"/></value>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <!--初步诊断-中医诊断编码-代码-->  
                  <code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="初步诊断-中医病名代码"/>  
                  <value xsi:type="CD"   code="{MajorHealthProblems/cz/TCM/code}" displayName="{MajorHealthProblems/cz/TCM/displayName}"  codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/> 
                </observation> 
              </entryRelationship>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <!--初步诊断-中医证候编码-名称-->  
                  <code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="初步诊断-中医证候名称"/>  
                  <value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/cz/TCM/zhName"/></value> 
                </observation> 
              </entryRelationship>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <!--初步诊断-中医证候编码-代码-->  
                  <code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="初步诊断-中医证候代码"/>  
                  <value xsi:type="CD" code="{MajorHealthProblems/cz/TCM/zhcode}" displayName="{MajorHealthProblems/cz/TCM/zhdisplayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/> 
                </observation> 
              </entryRelationship>  
              <!--入院诊断顺位-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE05.01.080.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断顺位"/>  
                  <value xsi:type="INT" value="{MajorHealthProblems/cz/TCM/ryNum}"/> 
                </observation> 
              </entryRelationship> 
            </observation> 
          </entry>  
          <!--修正诊断-西医条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="修正诊断-西医诊断名称"/>  
              <!--修正诊断日期-->  
              <effectiveTime value="{MajorHealthProblems/xz/CurrentDiagnosis/xzTime}"/>  
              <value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/xz/CurrentDiagnosis/Name"/></value>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <!--修正诊断-西医诊断编码-代码-->  
                  <code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="修正诊断-西医诊断编码"/>  
                  <value xsi:type="CD" code="{MajorHealthProblems/xz/CurrentDiagnosis/code}" displayName="{MajorHealthProblems/xz/CurrentDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/> 
                </observation> 
              </entryRelationship>  
              <!--入院诊断顺位-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE05.01.080.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断顺位"/>  
                  <value xsi:type="INT" value="{MajorHealthProblems/xz/CurrentDiagnosis/ryNum}"/> 
                </observation> 
              </entryRelationship> 
            </observation> 
          </entry>  
          <!--修正诊断-中医条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="修正诊断-中医病名名称"/>  
              <!--修正诊断日期-->  
              <effectiveTime value="{MajorHealthProblems/xz/TCM/xzTime}"/>  
              <value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/xz/TCM/Name"/></value>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <!--修正诊断-中医诊断编码-代码-->  
                  <code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="修正诊断-中医病名代码"/>  
                  <value xsi:type="CD" code="{MajorHealthProblems/xz/TCM/code}" displayName="{MajorHealthProblems/xz/TCM/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/> 
                </observation> 
              </entryRelationship>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <!--修正诊断-中医证候编码-名称-->  
                  <code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="修正诊断-中医证候名称"/>  
                  <value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/xz/TCM/zhName"/></value> 
                </observation> 
              </entryRelationship>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <!--修正诊断-中医证候编码-代码-->  
                  <code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="修正诊断-中医证候代码"/>  
                  <value xsi:type="CD" code="{MajorHealthProblems/xz/TCM/zhcode}" displayName="{MajorHealthProblems/xz/TCM/zhdisplayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/> 
                </observation> 
              </entryRelationship>  
              <!--入院诊断顺位-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE05.01.080.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断顺位"/> 
                  <value xsi:type="INT" value="{MajorHealthProblems/xz/TCM/ryNum}"/> 
                </observation> 
              </entryRelationship> 
            </observation> 
          </entry>  
          <!--确定诊断-西医条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="确定诊断-西医诊断名称"/>  
              <!--确定诊断日期-->  
              <effectiveTime value="{MajorHealthProblems/qd/CurrentDiagnosis/qdTime}"/>  
              <value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/qd/CurrentDiagnosis/Name"/></value>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <!--确定诊断-西医诊断编码-代码-->  
                  <code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="确定诊断-西医诊断编码"/>  
                  <value xsi:type="CD" code="{MajorHealthProblems/qd/CurrentDiagnosis/code}" displayName="{MajorHealthProblems/qd/CurrentDiagnosis/displayName}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/> 
                </observation> 
              </entryRelationship>  
              <!--入院诊断顺位-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE05.01.080.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断顺位"/>  
                  <value xsi:type="INT" value="{MajorHealthProblems/qd/CurrentDiagnosis/ryNum}"/> 
                </observation> 
              </entryRelationship> 
            </observation> 
          </entry>  
          <!--确定诊断-中医条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="确定诊断-中医病名名称"/>  
              <!--确定诊断日期-->  
              <effectiveTime value="{MajorHealthProblems/qd/TCM/qdTime}"/>  
              <value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/qd/TCM/Name"/></value>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <!--确定诊断-中医诊断编码-代码-->  
                  <code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="确定诊断-中医病名代码"/>  
                  <value xsi:type="CD" code="{MajorHealthProblems/qd/TCM/code}" displayName="{MajorHealthProblems/qd/TCM/displayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/> 
                </observation> 
              </entryRelationship>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <!--确定诊断-中医证候编码-名称-->  
                  <code code="DE05.10.172.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="确定诊断-中医证候名称"/>  
                  <value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/qd/TCM/zhName"/></value> 
                </observation> 
              </entryRelationship>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <!--确定诊断-中医证候编码-代码-->  
                  <code code="DE05.10.130.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="确定诊断-中医证候代码"/>  
                  <value xsi:type="CD" code="{MajorHealthProblems/qd/TCM/zhcode}" displayName="{MajorHealthProblems/qd/TCM/zhdisplayName}" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/> 
                </observation> 
              </entryRelationship>  
              <!--入院诊断顺位-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE05.01.080.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断顺位"/>  
                  <value xsi:type="INT" value="{MajorHealthProblems/qd/TCM/ryNum}"/> 
                </observation> 
              </entryRelationship> 
            </observation> 
          </entry>  
          <!--补充诊断-西医条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.01.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="补充诊断-西医诊断名称"/>  
              <!--补充诊断日期-->  
              <effectiveTime value="{MajorHealthProblems/bc/CurrentDiagnosis/bcTime}"/>  
              <value xsi:type="ST"><xsl:value-of select="MajorHealthProblems/bc/CurrentDiagnosis/Name"/></value>  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <!--补充诊断-西医诊断编码-代码-->  
                  <code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="补充诊断-西医诊断编码"/>  
                  <value xsi:type="CD" code="{MajorHealthProblems/bc/CurrentDiagnosis/code}" displayName="{MajorHealthProblems/bc/CurrentDiagnosis/displayName}"  codeSystem="2.16.156.10011.2.3.3.11.3" codeSystemName="诊断代码表（ICD-10）"/> 
                </observation> 
              </entryRelationship>  
              <!--入院诊断顺位-->  
              <entryRelationship typeCode="COMP"> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE05.01.080.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="入院诊断顺位"/>  
                  <value xsi:type="INT" value="{MajorHealthProblems/bc/CurrentDiagnosis/ryNum}"/> 
                </observation> 
              </entryRelationship> 
            </observation> 
          </entry> 
        </section> 
      </component>  
      <!--治疗计划章节-->  
      <component> 
        <section> 
          <code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--治则治法条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE06.00.300.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="治则治法"/>  
              <value xsi:type="ST"><xsl:value-of select="TreatmentPlan/Accountability"/></value> 
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
