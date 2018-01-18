<?xml version="1.0" encoding="UTF-8"?>
<!-- 		source: HIP CDR 从encounter生成的xml
		traget: 互连互通文档01-病例概要
		如需数据结构有变动，或者用其他数据比如SDA3, 只需要很少修改，比如一些XPath
 -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientMedicalHistories.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Section-Modules/Encounter.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/Histories.xsl"/>
	<xsl:template match="Document">
		<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:mif="urn:hl7-org:v3/mif" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:apply-templates select="." mode="CDAHeader"/>
			<!--PersonalInformation-->
			<!-- the first two line give the same code in 53 documents -->
			<recordTarget contextControlCode="OP" typeCode="RCT">
				<patientRole classCode="PAT">
					<xsl:comment>健康档案号</xsl:comment>
					<xsl:apply-templates select="Patient/MPIID" mode="PatientMPIID"/>
					<xsl:comment>健康卡号</xsl:comment>
					<xsl:apply-templates select="Patient/HealthCardNumber" mode="PatientHealthCardNumber"/>
					<xsl:comment>患者家庭住址，门牌-村街-乡-县-市-省必须，邮编可选</xsl:comment>
					<xsl:apply-templates select="Patient/Address" mode="CDRAddress"/>
					<xsl:comment>患者联系电话</xsl:comment>
					<xsl:apply-templates select="Patient/PhoneNumber"/>
					<xsl:comment>患者基本信息</xsl:comment>
					<patient classCode="PSN" determinerCode="INSTANCE">
						<id root="2.16.156.10011.1.3">
							<xsl:attribute name="extension"><xsl:value-of select="Patient/IDNo"/></xsl:attribute>
						</id>
						<!--患者姓名，必选-->
						<xsl:apply-templates select="Patient" mode="CDRName"/>
						<!-- 性别，必选 -->
						<xsl:apply-templates select="Patient/Gender" mode="CDRGender"/>
						<!-- 出生时间1..1,格式可能要转换，要求输出为yyyymmdd -->
						<xsl:apply-templates select="Patient/BirthTime" mode="BirthTime"/>
						<!-- 婚姻状况1..1 -->
						<xsl:apply-templates select="Patient/MaritalStatus" mode="code-maritalStatus"/>
						<!-- 民族1..1 -->
						<xsl:apply-templates select="Patient" mode="code-ethnicGroup-patient"/>
						<!--工作单位0..1, 要求名称电话-->
						<xsl:apply-templates select="Patient/employerOrganization" mode="EmployerOrganization"/>
						<!--职业0..1-->
						<xsl:apply-templates select="Patient/Occupation" mode="Occupation"/>
					</patient>
				</patientRole>
			</recordTarget>
			<xsl:comment>文档作者</xsl:comment>
			<xsl:apply-templates select="Creator" mode="Creator"/>
			<xsl:comment>保管机构</xsl:comment>"/>

				<xsl:apply-templates select="Custodian" mode="Custodian"/>		
			<xsl:comment>联系人1..*</xsl:comment>
			<xsl:apply-templates select="Patient/SupportContacts" mode="CDRSupportContacts"/>
			<component>
				<structuredBody>
					<!--实验室检验章节-->
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
											<value xsi:type="CD" code="1" codeSystem="2.16.156.10011.2.3.1.250" codeSystemName="Rh(D)血型代码表" displayName="阴性"/>
										</observation>
									</component>
									<!--Rh血型-->
									<component typeCode="COMP" contextConductionInd="true">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE04.50.001.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="CD" code="1" codeSystem="2.16.156.10011.2.3.1.85" codeSystemName="ABO血型代码表" displayName="A型"/>
										</observation>
									</component>
								</organizer>
							</entry>
						</section>
					</component>
					<!--既往史章节-->
					<component>
						<section>
							<code code="11348-0" displayName="HISTORY OF PAST ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--疾病史（含外伤）-->
							<xsl:apply-templates select="." mode="Illness"/>
							<!--传染病史-->
							<xsl:apply-templates select="." mode="Infect"/>
							<!--手术史-->
							<xsl:apply-templates select="." mode="Surgery"/>
							<!--婚育史条目-->
							<xsl:apply-templates select="." mode="Marital"/>
						</section>
					</component>
					<!--输血章节-->
					<component>
						<section>
							<code code="56836-0" displayName="History of blood transfusion" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<xsl:apply-templates select="." mode="Blood"/>
						</section>
					</component>
					<!--过敏史章节-->
					<component>
						<section>
							<code code="48765-2" displayName="Allergies, adverse reactions, alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--过敏史条目-->
							<xsl:apply-templates select="." mode="Allergy"/>
						</section>
					</component>
					<!--预防接种史章节-->
					<component>
						<section>
							<code code="11369-6" codeSystem="2.16.840.1.113883.6.1" displayName="HISTORYOF IMMUNIZATIONS" codeSystemName="LOINC"/>
							<text/>
							<xsl:apply-templates select="." mode="Vaccination"/>
						</section>
					</component>
					<!--个人史章节-->
					<xsl:apply-templates select="." mode="Social"/>
					<!--月经史章节-->
					<xsl:apply-templates select="." mode="Menstruation"/>
					<!--家族史章节-->
					<xsl:apply-templates select="." mode="Family"/>
					<!--卫生事件章节-->
					<component>
						<section>
							<code displayName="卫生事件"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE08.10.026.00" displayName="医疗机构科室名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/HealthEvent/ksName"/>
									</value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.01.060.00" displayName="患者类型代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="1" displayName="门诊" codeSystem="2.16.156.10011.2.3.1.271" codeSystemName="患者类型代码表"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE01.00.010.00" displayName="门（急）诊号" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/HealthEvent/EmergencyNO"/>
									</value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE01.00.014.00" displayName="住院号" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/HealthEvent/InHospitalNO"/>
									</value>
								</observation>
							</entry>
							<entry>
								<organizer classCode="BATTERY" moodCode="EVN">
									<statusCode/>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.092.00" displayName="入院日期" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/HealthEvent/AdmissionDate"/>
											</value>
										</observation>
									</component>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.017.00" displayName="出院日期" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/HealthEvent/DischargeDate"/>
											</value>
										</observation>
									</component>
								</organizer>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.01.018.00" displayName="发病日期时间" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="TS" value="{/Document/HealthEvent/InvasionDate}"> </value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.053.00" displayName="就诊原因" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<!--就诊日期时间 DE06.00.062.00-->
									<effectiveTime value="20130202123422"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/HealthEvent/Reason"/>
									</value>
								</observation>
							</entry>
							<!--条目诊断-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" displayName="西医诊断编码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
										<qualifier>
											<name displayName="西医诊断编码"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="B95.100" displayName="B族链球菌感染" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.113.00" displayName="病情转归代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="CD" code="1" codeSystem="2.16.156.10011.2.3.1.148" codeSystemName="病情转归代码表" displayName="治愈"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
							<!--条目诊断-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.024.00" displayName="其他西医诊断编码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
										<qualifier>
											<name displayName="其他西医诊断编码"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="B95.100" displayName="B族链球菌感染" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.130.00" displayName="中医病名代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
										<qualifier>
											<name displayName="中医病名代码"/>
										</qualifier>
									</code>
									<value xsi:type="CD" code="BEA" displayName="儿科癌病类" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.130.00" displayName="中医证候代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录">
												<qualifier>
													<name displayName="{/Document/HealthEvent/ID}"/>
												</qualifier>
											</code>
											<value xsi:type="CD" code="BNP050" displayName="呕吐病" codeSystem="2.16.156.10011.2.3.3.14" codeSystemName="中医病证分类与代码表( GB/T 15657)"/>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.113.00" displayName="病情转归代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="CD" code="1" codeSystem="2.16.156.10011.2.3.1.148" codeSystemName="病情转归代码表" displayName="治愈"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
							<entry>
								<procedure classCode="PROC" moodCode="EVN">
									<!--手术及操作编码 DE06.00.093.00-->
									<code code="1" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表（ICD-9-CM）"/>
								</procedure>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE08.50.022.00" displayName="关键药物名称" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/HealthEvent/DrugName"/>
									</value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.136.00" displayName="关键药物用法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/HealthEvent/UseWay"/>
											</value>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.129.00" displayName="药物不良反应情况" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/HealthEvent/BadEffect"/>
											</value>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.164.00" displayName="中药使用类别代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="CD" code="1" displayName="未使用" codeSystem="2.16.156.10011.2.3.1.157" codeSystemName="中药使用类别代码表"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.251.00" displayName="其他医学处置" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/HealthEvent/Treatment"/>
									</value>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.021.00" displayName="根本死因代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="CD" code="R57.101" displayName="失血性休克" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.01.039.00" displayName="责任医师姓名" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/HealthEvent/DoctorName"/>
									</value>
								</observation>
							</entry>
							<!--费用条目-->
							<entry>
								<organizer classCode="CLUSTER" moodCode="EVN">
									<statusCode/>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE02.01.044.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="医疗保险类别代码"/>
											<value xsi:type="CD" code="99" displayName="其他" codeSystem="2.16.156.10011.2.3.1.248" codeSystemName="医疗保险类别代码表"/>
										</observation>
									</component>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE07.00.007.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="医疗付费方式代码"/>
											<value xsi:type="CD" code="99" displayName="其他" codeSystem="2.16.156.10011.2.3.1.269" codeSystemName="医疗付费方式代码表"/>
										</observation>
									</component>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE07.00.004.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="门诊费用金额"/>
											<value xsi:type="MO" value="{/Document/cost/cost1}" currency="元"/>
										</observation>
									</component>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE07.00.010.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="住院费用金额"/>
											<value xsi:type="MO" value="{/Document/cost/cost2}" currency="元"/>
										</observation>
									</component>
									<component>
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE07.00.001.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="个人承担费用金额"/>
											<value xsi:type="MO" value="{/Document/cost/cost3}" currency="元"/>
										</observation>
									</component>
								</organizer>
							</entry>
						</section>
					</component>
				</structuredBody>
			</component>
		</ClinicalDocument>
	</xsl:template>
	<!--PatientInformation Part-->
</xsl:stylesheet>
<!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\..\DataIn\CDR_EncounterSample_v1.xml" htmlbaseurl="" outputurl="" processortype="saxon8" useresolver="no" profilemode="0" profiledepth="" profilelength=""
		          urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"
		          customvalidator="">
			<advancedProp name="bSchemaAware" value="false"/>
			<advancedProp name="xsltVersion" value="2.0"/>
			<advancedProp name="iWhitespace" value="0"/>
			<advancedProp name="bWarnings" value="true"/>
			<advancedProp name="bXml11" value="false"/>
			<advancedProp name="bUseDTD" value="false"/>
			<advancedProp name="bXsltOneIsOkay" value="true"/>
			<advancedProp name="bTinyTree" value="true"/>
			<advancedProp name="bGenerateByteCode" value="true"/>
			<advancedProp name="bExtensions" value="true"/>
			<advancedProp name="iValidation" value="0"/>
			<advancedProp name="iErrorHandling" value="fatal"/>
			<advancedProp name="sInitialTemplate" value=""/>
			<advancedProp name="sInitialMode" value=""/>
		</scenario>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->