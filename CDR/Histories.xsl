<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:include href="CDA-Support-Files/Export/Common/Histories.xsl"/>
	<xsl:template match="Document">
		<ClinicalDocument xmlns:mif="urn:hl7-org:v3/mif" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:hl7-org:v3">
			<component>
				<structuredBody>
					<commont>病历概要，入院记录 -个人史章节</commont>
					<component>
						<section>
							<code code="29762-2" displayName="Social history" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--个人史条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.097.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="个人史"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/SocialHistories/SocialHistory/SocialHabitComments"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<commont>病历概要，入院评估，一般护理记录-过敏史章节</commont>
					<component>
						<section>
							<code code="48765-2" displayName="Allergies, adverse reactions, alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--过敏史条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<xsl:apply-templates select="." mode="Allergy"/>
								</observation>
							</entry>
						</section>
					</component>
					<commont>门急诊留观病例，门急诊病历-过敏史章节</commont>
					<component>
						<section>
							<code code="48765-2" displayName="Allergies, adverse reactions, alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<xsl:apply-templates select="." mode="AllergyStatus"/>
									<entryRelationship typeCode="SUBJ">
										<observation classCode="OBS" moodCode="EVN">
											<xsl:apply-templates select="." mode="Allergy"/>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
						</section>
					</component>
					<commont>手术护理记录，病重（病危）护理记录-过敏史章节</commont>
					<component>
						<section>
							<code code="48765-2" displayName="Allergies, adverse reactions, alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry typeCode="DRIV">
								<act classCode="ACT" moodCode="EVN">
									<code/>
									<entryRelationship typeCode="SUBJ">
										<observation classCode="OBS" moodCode="EVN">
											<xsl:apply-templates select="." mode="AllergyStatus"/>
											<participant typeCode="CSM">
												<participantRole classCode="MANU">
													<playingEntity classCode="MMAT">
														<!--过敏史描述-->
														<xsl:apply-templates select="." mode="Allergy"/>
													</playingEntity>
												</participantRole>
											</participant>
										</observation>
									</entryRelationship>
								</act>
							</entry>
						</section>
					</component>
					<commont>中医住院病案首页-过敏史章节</commont>
					<component>
						<section>
							<code code="48765-2" displayName="Allergies, adverse reactions, alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry typeCode="DRIV">
								<act classCode="ACT" moodCode="EVN">
									<code/>
									<!--药物过敏标志-->
									<entryRelationship typeCode="SUBJ">
										<observation classCode="OBS" moodCode="EVN">
											<xsl:apply-templates select="." mode="AllergyStatus"/>
											<participant typeCode="CSM">
												<participantRole classCode="MANU">
													<playingEntity classCode="MMAT">
														<!--住院患者过敏源-->
														<code code="DE02.10.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="过敏药物"/>
														<desc xsi:type="ST">
															<xsl:value-of select="/Document/Allergies/Allergy/AllergyCategory"/>
														</desc>
													</playingEntity>
												</participantRole>
											</participant>
										</observation>
									</entryRelationship>
								</act>
							</entry>
						</section>
					</component>
					<commont>住院病案首页-过敏史章节</commont>
					<component>
						<section>
							<code code="48765-2" displayName="Allergies, adverse reactions, alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry typeCode="DRIV">
								<act classCode="ACT" moodCode="EVN">
									<code nullFlavor="NA"/>
									<entryRelationship typeCode="SUBJ">
										<observation classCode="OBS" moodCode="EVN">
											<xsl:apply-templates select="." mode="AllergyStatus"/>
											<participant typeCode="CSM">
												<participantRole classCode="MANU">
													<playingEntity classCode="MMAT">
														<!--住院患者过敏源-->
														<code code="DE02.10.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="过敏药物"/>
														<desc xsi:type="ST">
															<xsl:value-of select="/Document/Allergies/Allergy/AllergyCategory"/>
														</desc>
													</playingEntity>
												</participantRole>
											</participant>
										</observation>
									</entryRelationship>
								</act>
							</entry>
						</section>
					</component>
					<commont>病历概要-既往史章节</commont>
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
					<commont>待产记录-既往史章节</commont>
					<component>
						<section>
							<code code="11348-0" displayName="HISTORY OF PAST ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--既往史-->
							<xsl:apply-templates select="." mode="Past"/>
							<!--手术史-->
							<xsl:apply-templates select="." mode="Surgery"/>
							<!--既往孕产史-->
							<xsl:apply-templates select="." mode="Pregnancy"/>
						</section>
					</component>
					<commont>急诊留观病历，门急诊病历-既往史章节</commont>
					<component>
						<section>
							<code code="11348-0" displayName="HISTORY OF PAST ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--既往史-->
							<xsl:apply-templates select="." mode="Past"/>
						</section>
					</component>
					<commont>麻醉术前访视记录-既往史章节</commont>
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
					<commont>入院记录-既往史章节</commont>
					<component>
						<section>
							<code code="11348-0" displayName="HISTORY OF PAST ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--一般健康状况标志-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<xsl:apply-templates select="." mode="HealthStatus"/>
									<!--疾病史（含外伤）-->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE02.10.026.00" displayName="疾病史（含外伤）" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:03:27Z']/NoteText"/>
											</value>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
							<!--患者传染性标志-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<xsl:apply-templates select="." mode="InfectionStatus"/>
									<!--传染病史-->
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE02.10.008.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="传染病史"/>
											<value xsi:type="ST">
												<xsl:value-of select="/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T17:33:10Z']/NoteText"/>
											</value>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
							<!--婚育史条目-->
							<xsl:apply-templates select="." mode="Marital"/>
							<!--过敏史条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<xsl:apply-templates select="." mode="Allergy"/>
								</observation>
							</entry>
							<!--手术史条目-->
							<xsl:apply-templates select="." mode="Surgery"/>
						</section>
					</component>
					<commont>入院评估-既往史章节</commont>
					<component>
						<section>
							<code code="11348-0" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HISTORY OF PAST ILLNESS"/>
							<text/>
							<!--疾病史（含外伤）-->
							<xsl:apply-templates select="." mode="Illness"/>
							<!--传染病史-->
							<xsl:apply-templates select="." mode="Infect"/>
							<!--预防接种史条目-->
							<xsl:apply-templates select="." mode="Vaccination"/>
							<!--手术史条目-->
							<xsl:apply-templates select="." mode="Surgery"/>
							<!--输血史条目-->
							<xsl:apply-templates select="." mode="Blood"/>
							<!--一般健康状况标志-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<xsl:apply-templates select="." mode="HealthStatus"/>
								</observation>
							</entry>
							<!--患者传染性标志-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<xsl:apply-templates select="." mode="InfectionStatus"/>
								</observation>
							</entry>
						</section>
					</component>
					<commont>一般手术记录-既往史章节</commont>
					<component>
						<section>
							<code code="11348-0" displayName="HISTORY OF PAST ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--手术史-->
							<xsl:apply-templates select="." mode="Surgery"/>
						</section>
					</component>
					<commont>阴道分娩记录-既往史章节</commont>
					<component>
						<section>
							<code code="11348-0" displayName="HISTORY OF PAST ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE04.01.108.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="孕次"/>
									<value xsi:type="INT" value="{/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:04:08Z']/Perganttime}"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.002.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产次"/>
									<value xsi:type="INT" value="{/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:04:08Z']/Childbirthtime}"/>
								</observation>
							</entry>
						</section>
					</component>
					<commont>治疗记录-既往史章节</commont>
					<component>
						<section>
							<code code="11348-0" displayName="HISTORY OF PAST ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.165.00" displayName="有创诊疗操作标志" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<value xsi:type="BL" value="{/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:04:14Z']/IllnessID}"/>
								</observation>
							</entry>
							<entry>
								<!--过敏史标志-->
								<observation classCode="OBS" moodCode="EVN">
									<xsl:apply-templates select="." mode="AllergyStatus"/>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<entry>
												<observation classCode="OBS" moodCode="EVN">
													<xsl:apply-templates select="." mode="Allergy"/>
												</observation>
											</entry>
										</observation>
									</entryRelationship>
								</observation>
							</entry>
						</section>
					</component>
					<commont>病历概要，入院记录，入院评估-家族史章节</commont>
					<component>
						<section>
							<code code="10157-6" displayName="HISTORY OF FAMILY MEMBER DISEASES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.103.00" displayName="家族史" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
									<xsl:value-of select="/Document/FamilyHistory[CreationTime='2017-11-27T18:04:14Z']/NoteText"/>
								</observation>
							</entry>
						</section>
					</component>
					<commont>入院评估-生活方式章节</commont>
					<component>
						<section>
							<code displayName="生活方式"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE03.00.070.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="吸烟标志"/>
									<!--HDSD00.09.068 DE03.00.070.00 吸烟标志-->
									<value xsi:type="BL" value="{/Document/LifeHabits/LifeHabit1/ID}"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE03.00.073.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="吸烟状况代码"/>
									<!--HDSD00.09.069 DE03.00.073.00 吸烟状况代码 -->
									<value xsi:type="CD" code="1" displayName="从不吸烟" codeSystem="2.16.156.10011.2.3.2.5" codeSystemName="吸烟状况代码表"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE03.00.053.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="日吸烟量(支)"/>
									<!--HDSD00.09.048 DE03.00.053.00 日吸烟量（支）-->
									<value xsi:type="PQ" value="{/Document/LifeHabits/LifeHabit1/Number}" unit="支"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE03.00.065.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="停止吸烟天数"/>
									<!--HDSD00.09.065 DE03.00.065.00 停止吸烟天数 -->
									<value xsi:type="PQ" value="{/Document/LifeHabits/LifeHabit1/Day}" unit="d"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE03.00.030.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="饮酒标志"/>
									<!--HDSD00.09.075 DE03.00.030.00 饮酒标志 -->
									<value xsi:type="BL" value="{/Document/LifeHabits/LifeHabit2/ID}"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE03.00.076.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="饮酒频率代码"/>
									<!--HDSD00.09.076 DE03.00.076.00 饮酒频率代码 -->
									<value xsi:type="CD" code="1" displayName="从不" codeSystem="2.16.156.10011.2.3.1.16" codeSystemName="饮酒频率代码表"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE03.00.054.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="日饮酒量（mL）"/>
									<!--HDSD00.09.049 DE03.00.054.00 日饮酒量（mL）-->
									<value xsi:type="PQ" value="{/Document/LifeHabits/LifeHabit1/Number} " unit="mL"/>
								</observation>
							</entry>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE03.00.080.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="饮食情况代码"/>
									<!--HDSD00.09.077 DE03.00.080.00 饮食情况代码 -->
									<value xsi:type="CD" code="1" displayName="良好" codeSystem="2.16.156.10011.2.3.2.34" codeSystemName="饮食情况代码表"/>
								</observation>
							</entry>
						</section>
					</component>
					<commont>入院记录-预防接种史章节</commont>
					<component>
						<section>
							<code code="11369-6" displayName="HISTORY OF IMMUNIZATIONS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--预防接种史条目-->
							<xsl:apply-templates select="." mode="Vaccination"/>
						</section>
					</component>
					<commont>入病历概要，入院记录-月经史章节</commont>
					<component>
						<section>
							<code code="49033-4" displayName="Menstrual History" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.102.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="月经史"/>
									<value xsi:type="ST">
										<xsl:value-of select="/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:04:06Z']/NoteText"/>
									</value>
								</observation>
							</entry>
						</section>
					</component>
					<component>
						<commont>中医住院病案首页，住院病案首页-住院史章节</commont>
						<section>
							<code code="11336-5" codeSystem="2.16.840.1.113883.6.1" displayName="HISTORY
OF HOSPITALIZATIONS" codeSystemName="LOINC"/>
							<text/>
							<!--住院次数 -->
							<entry typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.090.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="住院次数"/>
									<value unit="次" xsi:type="PQ"/>
									<xsl:value-of select="/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:04:15Z']/IllnessTime"/>
								</observation>
							</entry>
						</section>
					</component>
					<commont>24h内入出院记录，急诊留观病历，门急诊病历，入院记录-现病史史章节</commont>
					<!--现病史章节-->
					<component>
						<section>
							<code code="10164-2" displayName="HISTORY OF PRESENT ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--现病史条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE02.10.071.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="现病史"/>
									<value xsi:type="ST">"<xsl:value-of select="/Document/Problems/Problem[CreationTime='2017-12-01T17:33:11Z']/Comments"/>"</value>
								</observation>
							</entry>
						</section>
					</component>
					<commont>麻醉术前访示记录-现病史史章节</commont>
					<!--现病史章节-->
					<component>
						<section>
							<code code="10164-2" displayName="HISTORY OF PRESENT ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
							<text/>
							<!--简要病史条目-->
							<entry>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE05.10.140.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="简要病史"/>
									<value xsi:type="ST">"<xsl:value-of select="/Document/Problems/Problem[CreationTime='2017-12-01T17:33:10Z']/Comments"/>"</value>
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
