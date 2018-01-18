<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/OIDs-IOT.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/CDAHeader.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/PatientInformation.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/ChiefComplaint.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Entry-Modules/TreatmentPlan.xsl"/>
	<xsl:include href="CDA-Support-Files/Export/Common/Histories.xsl"/>
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
							<!--手术史-->
							<xsl:apply-templates select="." mode="Surgery"/>
						</section>
					</component>
					<component>
						<section>
							<code code="10219-4" displayName="Surgical operation note preoperative Dx" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--术前诊断-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<!--术前诊断编码-->
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术前诊断编码"/>
									<value xsi:type="CD" code="B95.100" displayName="B族链球菌感染" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entry>
						</section>
					</component>
					<component>
						<section>
							<code code="47519-4" displayName="HISTORY OF PROCEDURES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<!-- 1..1 手术记录 -->
								<procedure classCode="PROC" moodCode="EVN">
									<code code="84.51003" displayName="陶瓷脊椎融合物置入术" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表(ICD-9-CM)"/>
									<!--操作日期/时间-->
									<effectiveTime>
										<!--手术开始日期时间-->
										<low value="{/Document/shuqianzhenduan/lowtime}"/>
										<!--手术结束日期时间-->
										<high value="{/Document/shuqianzhenduan/hightime}"/>
									</effectiveTime>
									<!--手术者-->
									<performer typeCode="PRF">
										<assignedEntity>
											<id root="2.16.156.10011.1.4" extension="-"/>
											<assignedPerson>
												<name>
													<xsl:value-of select="/Document/shuqianzhenduan/shoushuzhe"/>,</name>
											</assignedPerson>
										</assignedEntity>
									</performer>
									<!--第一助手-->
									<participant typeCode="ATND">
										<participantRole classCode="ASSIGNED">
											<id root="2.16.156.10011.1.4" extension="-"/>
											<code displayName="Ⅰ助"/>
											<playingEntity classCode="PSN" determinerCode="INSTANCE">
												<name>
													<xsl:value-of select="/Document/shuqianzhenduan/diyizhushou"/>
												</name>
											</playingEntity>
										</participantRole>
									</participant>
									<!--第二助手-->
									<participant typeCode="ATND">
										<participantRole classCode="ASSIGNED">
											<id root="2.16.156.10011.1.4" extension="-"/>
											<code displayName="Ⅱ助"/>
											<playingEntity classCode="PSN" determinerCode="INSTANCE">
												<name>
													<xsl:value-of select="/Document/shuqianzhenduan/dierzhushou"/>
												</name>
											</playingEntity>
										</participantRole>
									</participant>
									<!--器械护士姓名-->
									<participant typeCode="ATND">
										<participantRole classCode="ASSIGNED">
											<id root="2.16.156.10011.1.4" extension="-"/>
											<code displayName="器械护士"/>
											<playingEntity classCode="PSN" determinerCode="INSTANCE">
												<name>
													<xsl:value-of select="/Document/shuqianzhenduan/qixiehushi"/>
												</name>
											</playingEntity>
										</participantRole>
									</participant>
									<!--巡台护士姓名-->
									<participant typeCode="ATND">
										<participantRole classCode="ASSIGNED">
											<id root="2.16.156.10011.1.4" extension="78428"/>
											<code displayName="巡台护士"/>
											<playingEntity classCode="PSN" determinerCode="INSTANCE">
												<name>刘芳<xsl:value-of select="/Document/shuqianzhenduan/xuntaihushi"/>
												</name>
											</playingEntity>
										</participantRole>
									</participant>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.094.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术（操作）名称"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/shuqianzhenduan/shoushucaozuo"/>
											</value>
										</observation>
									</entryRelationship>
									<!--手术间编号-->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.256.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="患者实施手术所在的手术室编号术室编号"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/shuqianzhenduan/shoushushibianhao"/>
											</value>
										</observation>
									</entryRelationship>
									<!--手术级别 -->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.255.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术级别"/>
											<!--手术级别 -->
											<value xsi:type="CD" code="3" displayName="三级手术" codeSystem="2.16.156.10011.2.3.1.258" codeSystemName="手术级别代码表"/>
										</observation>
									</entryRelationship>
								</procedure>
							</entry>
						</section>
					</component>
					<!--失血章节-->
					<component>
						<section>
							<code code="55103-6" displayName="Surgical operation note estimated blood loss" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--出血量（mL）-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.097.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出血量（mL）"/>
									<value xsi:type="PQ" unit="-" value="{/Document/chuxueliang}"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--输血章节-->
					<component>
						<section>
							<code code="56836-0" displayName="History of blood transfusion" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--输血量（mL）-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<!--输血量（mL）-->
									<code code="DE06.00.267.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血量（mL）"/>
									<value xsi:type="PQ" unit="-" value="{/Document/shuxueliang}"/>
								</observation>
							</entry>
							<!--输血反应标志-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<!--输血反应标志-->
									<code code="DE06.00.264.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血反应标志"/>
									<value xsi:type="BL" value="{/Document/shuxuefanyingbiaozhi}"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--麻醉章节-->
					<component>
						<section>
							<code code="10213-7" displayName="Surgical operation note anesthesia" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<!-- 麻醉方式代码 -->
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.073.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉方式代码"/>
									<value code="1" displayName="全身麻醉" codeSystem="2.16.156.10011.2.3.1.159" codeSystemName="麻醉方法代码表" xsi:type="CD"/>
									<!-- 麻醉医师姓名 -->
									<performer>
										<assignedEntity>
											<id/>
											<assignedPerson>
												<name><xsl:value-of select="/Document/mazui/yishixingming"/></name>
											</assignedPerson>
										</assignedEntity>
									</performer>
								</observation>
							</entry>
						</section>
					</component>
					<!--用药章节-->
					<component>
						<section>
							<code code="10160-0" displayName="History of medication use" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--术前用药-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<!--术前用药-->
									<code code="DE06.00.136.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术前用药">
										<qualifier>
											<name displayName="术前用 药"/>
										</qualifier>
									</code>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/DrugUse/shuqianyongyao"/>
									</value>
								</observation>
							</entry>
							<!--术中用药-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<!--术中用药-->
									<code code="DE06.00.136.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术中用药">
										<qualifier>
											<name displayName="术中用 药"/>
										</qualifier>
									</code>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/DrugUse/shuzhongyongyao"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<!--输液章节-->
					<component>
						<section>
							<code code="10216-0" displayName="Surgical operation note fluids" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--输液量（mL）-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<!--输液量（mL）-->
									<code code="DE06.00.268.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="c（mL）"/>
									<value xsi:type="PQ" unit="-" value="{/Document/shuyeliang}"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--术后诊断章节-->
					<component>
						<section>
							<code code="10218-6" displayName="Surgical operation note postoperative Dx" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--术后诊断-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<!--术后诊断编码-->
									<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术后诊断编码"/>
									<value xsi:type="CD" code="B95.100" displayName="B族链球菌感染" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
								</observation>
							</entry>
						</section>
					</component>
					<!--手术过程描述章节-->
					<component>
						<section>
							<code code="8724-7" displayName="Surgical operation note description" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<!--手术过程描述-->
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.063.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术过程描述"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/shoushuguocheng/guochengmiaoshu"/>
									</value>
									<!--手术目标部位名称 -->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.187.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术目标部位名称"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/shoushuguocheng/buweimincheng"/>
											</value>
										</observation>
									</entryRelationship>
									<!--介入物名称 -->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE08.50.037.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="介入物名称"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/shoushuguocheng/jieruwumincheng"/>
											</value>
										</observation>
									</entryRelationship>
									<!--手术体位代码 -->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.260.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术体位代码"/>
											<value xsi:type="CD" code="1" displayName="胸部" codeSystem="2.16.156.10011.2.3.1.262" codeSystemName="手术体位代码表"/>
										</observation>
									</entryRelationship>
									<!--皮肤消毒描述-->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE08.50.057.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="皮肤消毒描述"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/shoushuguocheng/xiaodumiaoshu"/>
											</value>
										</observation>
									</entryRelationship>
									<!--手术切口描述-->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.321.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术切口描述"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/shoushuguocheng/qiekoumiaoshu"/>
											</value>
										</observation>
									</entryRelationship>
									<!--引流标志-->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE05.10.165.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="引流标志"/>
											<value xsi:type="BL" value="{/Document/shoushuguocheng/yinliubiaozhi}"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
						</section>
					</component>
					<!--引流章节-->
					<component>
						<section>
							<code code="11537-8" displayName="Surgical drains" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--引流标志-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<!--引流标志-->
									<code code="DE05.10.165.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="引流标志"/>
									<value xsi:type="BL" value="{/Document/yinliuzhangjie/yiniubiaozhi}"/>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE08.50.044.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="引流材料名称"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/yinliuzhangjie/cailiaomincheng"/>
											</value>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE08.50.045.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="引流材料数目"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/yinliuzhangjie/cailiaoshumu"/>
											</value>
										</observation>
									</entryRelationship>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE06.00.341.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="放置部位"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/yinliuzhangjie/fangzhibuwei"/>
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
