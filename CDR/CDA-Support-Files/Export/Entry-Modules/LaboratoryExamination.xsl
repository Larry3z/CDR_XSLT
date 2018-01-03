<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<!--适用病历概要、麻醉记录、输血记录、手术护理、住院病案首页、中医住院病案首页-->
	<xsl:template match="Blood" mode="LabE">
    <component>
				<section>
					<code code="30954-2" displayName="STUDIES SUMMARY" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--血型-->
					<entry typeCode="COMP">
						<organizer classCode="BATTERY" moodCode="EVN">
							<statusCode/>
							<!--ABO血型-->
							<component typeCode="COMP" contextConductionInd="true">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.50.010.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="{RhBlood/Code}" codeSystem="2.16.156.10011.2.3.1.250" codeSystemName="Rh(D)血型代码表" displayName="{RhBlood/DisplayName}"/>
								</observation>
							</component>
							<!--Rh血型-->
							<component typeCode="COMP" contextConductionInd="true">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.50.001.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="{ABOBlood/Code}" codeSystem="2.16.156.10011.2.3.1.85" codeSystemName="ABO血型代码表" displayName="{ABOBlood/DisplayName}"/>
								</observation>
							</component>
						</organizer>
					</entry>
				</section>
			</component>	
	</xsl:template>
	
	<!--适用门急诊病历、急诊留观病历-->
	<xsl:template match="Observation" mode="LabE1">
	<component>
				<section>
					<code code="30954-2" displayName="STUDIES SUMMARY" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.010.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="辅助检查项目"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.009.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="辅助检查结果"/>
									<value xsi:type="ST"><xsl:value-of select="Display"/></value>
								</observation>
							</component>
						</organizer>
					</entry>
				</section>
			</component>
	</xsl:template>
	
	<!--适用检验报告-->
	<xsl:template match="LaboratoryExamination" mode="LabE2">
	<component>
				<section>
					<code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="STUDIES SUMMARY"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE02.10.027.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验方法名称"></code>
							<value xsi:type="ST"><xsl:value-of select="CheckProject"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.30.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验类别"></code>
							<value xsi:type="ST"><xsl:value-of select="CheckCategory"/></value>
						</observation>
					</entry>
					
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.019.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验项目代码"></code>
									<!-- 检验时间 -->
									<effectiveTime value="{CheckTime}"/>
									<value xsi:type="ST"><xsl:value-of select="CheckCode"/></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE04.50.134.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="标本类别"></code>
											<!-- DE04.50.137.00	标本采样日期时间
		DE04.50.141.00	接收标本日期时间 -->
											<effectiveTime>
												<low value="{SamplingTime}"></low>
												<high value="{AcceptTime}"></high>
											</effectiveTime>
											<value xsi:type="ST"><xsl:value-of select="SpecimenCategory"/></value>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE04.50.135.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="标本状态"></code>
											<value xsi:type="ST"><xsl:value-of select="SpecimenState"/></value>
										</observation>
									</entryRelationship>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.017.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验结果代码"></code>
									<value xsi:type="CD" code="{ResultsCode}" codeSystem="2.16.156.10011.2.3.2.38" codeSystemName="检查/检验结果代码表" displayName="{ResultsDisplayName}"></value>
								</observation>
							</component>
							
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.015.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验定量结果"></code>
									<value xsi:type="REAL" value="{ResultsValue}"></value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE04.30.016.00" displayName="检查定量结果计量单位" codeSystemName="卫生信息数据元目录" codeSystem="2.16.156.10011.2.2.1" />
											<value xsi:type="ST"><xsl:value-of select="Unit"/></value>
										</observation>
									</entryRelationship>
								</observation>
							</component>
						</organizer>
					</entry>
				</section>
			</component>
	</xsl:template>
	
	<!--适用麻醉术前访视记录-->
	<xsl:template match="LaboratoryExamination" mode="LabE3">
	<component>
				<section>
					<code code="30954-2" displayName="STUDIES SUMMARY" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry typeCode="COMP">
						<!-- 血型-->
						<organizer classCode="BATTERY" moodCode="EVN">
							<statusCode/>
							<component typeCode="COMP">
								<!-- ABO血型 -->
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.50.001.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="ABO血型代码"/>
									<value xsi:type="CD" code="{Boold/ABOBlood/Code}" displayName="{Boold/ABOBoold/DisplayName}" codeSystem="2.16.156.10011.2.3.1.85" codeSystemName="ABO血型代码表"/>
								</observation>
							</component>
							<component typeCode="COMP">
								<!-- Rh血型 -->
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.50.010.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="Rh（D）血型代码"/>
									<value xsi:type="CD" code="{Boold/RhBlood/Code}" displayName="{RhBlood/DisplayName}" codeSystem="2.16.156.10011.2.3.1.250" codeSystemName="Rh(D)血型代码表"/>
								</observation>
							</component>
						</organizer>
					</entry>
					<!-- 心电图检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.30.043.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="心电图检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="ElectrocardiogramResult"/></value>
						</observation>
					</entry>
					<!-- 胸部X线检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.30.045.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胸部X线检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="X-RayResult"/></value>
						</observation>
					</entry>
					<!-- CT检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.30.005.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="CT检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="CTResult"/></value>
						</observation>
					</entry>
					<!-- B超检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.30.002.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="B超检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="UltrasoundResult"/></value>
						</observation>
					</entry>
					<!-- MRI检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.30.009.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="MRI检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="MRIResult"/></value>
						</observation>
					</entry>
					<!-- 肺功能检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.30.009.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="肺功能检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="LungFunction"/></value>
						</observation>
					</entry>
					<!-- 血常规检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.50.128.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="血常规检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="RoutineBlood"/></value>
						</observation>
					</entry>
					<!-- 尿常规检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.50.048.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="尿常规检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="RoutineUrine"/></value>
						</observation>
					</entry>
					<!-- 凝血功能检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.50.142.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="凝血功能检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="BloodCoagulation"/></value>
						</observation>
					</entry>
					<!-- 肝功能检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.50.026.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="肝功能检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="LiverFunction"/></value>
						</observation>
					</entry>
					<!-- 血气分析检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.50.128.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="血气分析检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="Respiratory-BloodCheck"/></value>
						</observation>
					</entry>
				</section>
			</component>
	</xsl:template>
	
	<!--适用住院病程，抢救记录-->
	<xsl:template match=" LaboratoryExamination " mode="LabE4">
	<component>
				<section>
					<code code="30954-2" displayName="STUDIES SUMMARY" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<organizer classCode="CLUSTER" moodCode="EVN">
							<statusCode/>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.010.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="辅助检查项目"/>
								</observation>
							</component>
							<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.009.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="辅助检查结果"/>
									<value xsi:type="ST">辅助检查结果描述</value>
								</observation>
							</component>
						</organizer>
					</entry>
				</section>
			</component>
	</xsl:template>
	
    <!--适用出院小结-->
    <xsl:template match=" LaboratoryExamination " mode="LabE5">
	<component> 
        <section> 
          <code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="STUDIES SUMMARY"/>  
          <text/>  
          <!--阳性辅助检查结果条目-->  
          <entry typeCode="COMP" contextConductionInd="true"> 
            <!--阳性辅助检查结果-->  
            <organizer classCode="BATTERY" moodCode="EVN"> 
              <statusCode/>  
              <component typeCode="COMP" contextConductionInd="true"> 
                <!--HDSD00.16.042 DE04.50.128.00 阳性辅助检查结果 -->  
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE04.50.128.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>  
                  <value xsi:type="ST">自由文本</value> 
                </observation> 
              </component> 
            </organizer> 
          </entry> 
        </section> 
      </component> 
	</xsl:template>

	
</xsl:stylesheet>