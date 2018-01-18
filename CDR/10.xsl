<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<!--xsl:include href="CDA-Support-Files/Export/Section-Modules/Encounter.xsl"/-->
	<xsl:include href="CDA-Support-Files/Export/Common/Histories.xsl"/>
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
					<!--
********************************************************
术前诊断章节
********************************************************
-->
					<component>
						<section>
							<code code="10219-4" displayName="Surgical operation note preoperative Dx" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--术前诊断-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<!--术前诊断编码-->
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术前诊断编码"/>
									<value xsi:type="CD" code="S06.902" displayName="创伤性颅内海绵窦损伤" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entry>
							<!-- 术前合并疾病 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.01.076.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术前合并疾病"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/shuqianzhenduan/shuqianhebingjibing"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--现病史章节-->
					<component>
						<section>
							<code code="10164-2" displayName="HISTORY OF PRESENT ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--简要病史条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.140.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="简要病史"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/Problems/Problem2/Comments"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--既往史章节-->
					<component>
						<section>
							<code code="11348-0" displayName="HISTORY OF PAST ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--过敏史条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<xsl:apply-templates select="." mode="Allergy"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--体格检查章节-->
					<component>
						<section>
							<code code="29545-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="PHYSICAL EXAMINATION"/>
							<text/>
							<!-- 体重 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.10.188.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体重"/>
									<value xsi:type="PQ" value="{/Document/tigejiancha/tizhong}" unit="kg"/>
								</observation>
							</entry>
							<!-- 一般状况检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.10.219.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="一般状况检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/tigejiancha/ybzkjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- 精神状态正常标志 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.142.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="精神状态正常标志"/>
									<value xsi:type="BL" value="{/Document/tigejiancha/jsztzcbz}"/>
								</observation>
							</entry>
							<!-- 心脏听诊结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.10.207.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="心脏听诊结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/tigejiancha/xztzjg"/>
									</value>
								</observation>
							</entry>
							<!-- 肺部听诊结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.10.031.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="肺部听诊结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/tigejiancha/fbtzjg"/>
									</value>
								</observation>
							</entry>
							<!-- 四肢检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.10.179.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="四肢检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/tigejiancha/szjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- 脊柱检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.10.093.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="脊柱检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/tigejiancha/jzjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- 腹部检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.10.046.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="腹部检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/tigejiancha/fbjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- 气管检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.230.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="气管检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/tigejiancha/qgjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- 牙齿检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.10.264.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="牙齿检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/tigejiancha/ycjcjg"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--
********************************************************
实验室检查章节
********************************************************
-->
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
											<value xsi:type="CD" code="1" displayName="A型" codeSystem="2.16.156.10011.2.3.1.85" codeSystemName="ABO血型代码表"/>
										</observation>
									</component>
									<component typeCode="COMP">
										<!-- Rh血型 -->
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE04.50.010.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="Rh（D）血型代码"/>
											<value xsi:type="CD" code="2" displayName="阳性" codeSystem="2.16.156.10011.2.3.1.250" codeSystemName="Rh(D)血型代码表"/>
										</observation>
									</component>
								</organizer>
							</entry>
							<!-- 心电图检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.043.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="心电图检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/shiyanshijiancha/xdtjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- 胸部X线检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.045.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胸部X线检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/shiyanshijiancha/xbjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- CT检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.005.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="CT检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/shiyanshijiancha/CTjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- B超检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.002.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="B超检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/shiyanshijiancha/Bcjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- MRI检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.009.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="MRI检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/shiyanshijiancha/MRIjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- 肺功能检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.30.009.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="肺功能检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/shiyanshijiancha/fgnjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- 血常规检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.50.128.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="血常规检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/shiyanshijiancha/xcgjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- 尿常规检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.50.048.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="尿常规检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/shiyanshijiancha/ncgjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- 凝血功能检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.50.142.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="凝血功能检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/shiyanshijiancha/nxgnjcjg"/>
述</value>
								</observation>
							</entry>
							<!-- 肝功能检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.50.026.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="肝功能检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/shiyanshijiancha/fgnjcjg"/>
									</value>
								</observation>
							</entry>
							<!-- 血气分析检查结果 -->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.50.128.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="血气分析检查结果"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/shiyanshijiancha/xqfxjcjg"/>
述</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--
********************************************************
治疗计划章节
********************************************************
-->
					<component>
						<section>
							<code code="18776-5" displayName="TREATMENT PLAN" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!-- 拟实施手术及操作编码 DE06.00.093.00 -->
							<entry>
								<procedure classCode="PROC" moodCode="EVN">
									<code xsi:type="CD" code="02.34002" displayName="脑室-腹腔分流术" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表(ICD-9-CM)"/>
									<!--手术间编号-->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.256.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="患者实施手术所在的手术室编号"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/TreatmentPlan/shoushushibianhao"/>
											</value>
										</observation>
									</entryRelationship>
								</procedure>
							</entry>
							<entry>
								<!-- 拟实施麻醉方法代码 -->
								<observation classCode="OBS" moodCode="INT">
									<code code="DE06.00.073.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="拟实施麻醉方法代码"/>
									<value xsi:type="CD" code="1" displayName="全身麻醉" codeSystem="2.16.156.10011.2.3.1.159" codeSystemName="麻醉方法代码表"/>
									<!-- 术前麻醉医嘱 -->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="INT">
											<code code="DE06.00.287.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术前麻醉医嘱"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/TreatmentPlan/shuqianmazuiyizhu"/>
											</value>
										</observation>
									</entryRelationship>
									<!-- 麻醉适应证 -->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.227.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉适应证"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/TreatmentPlan/mazuishiyingzheng"/>
											</value>
										</observation>
									</entryRelationship>
									<!-- 注意事项 -->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE09.00.119.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="注意事项"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/TreatmentPlan/zhuyishixiang"/>
											</value>
										</observation>
									</entryRelationship>
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
