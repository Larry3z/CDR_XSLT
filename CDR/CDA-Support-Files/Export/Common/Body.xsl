<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<!--适用病历概要、麻醉记录、输血记录、手术护理、住院病案首页、中医住院病案首页-->
	<xsl:template match="*" mode="Diagnosis">
		<xsl:variable name="displayName">
			<xsl:choose>
				<xsl:when test="DiagnosisType ='诊断编码'">疾病诊断编码</xsl:when>
				<xsl:otherwise>诊断编码</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="{$displayName}"/>
				<value xsi:type="CD" code="{DiagnosisCode/Code}" displayName="{DiagnosisCode/Name}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
			</observation>
		</entry>
	</xsl:template>
	<!--实验室章节-->
	<xsl:template match="Blood" mode="LabE">
		<!--血型-->
		<entry typeCode="COMP">
			<organizer classCode="BATTERY" moodCode="EVN">
				<statusCode/>
				<!--ABO血型-->
				<component typeCode="COMP" contextConductionInd="true">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.010.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="CD" code="{BloodABO/Code}" codeSystem="2.16.156.10011.2.3.1.85" codeSystemName="ABO血型代码表" displayName="{BloodABO/DisplayName}"/>
					</observation>
				</component>
				<!--Rh血型-->
				<component typeCode="COMP" contextConductionInd="true">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.001.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="CD" code="{BloodRH/Code}" codeSystem="2.16.156.10011.2.3.1.250" codeSystemName="Rh(D)血型代码表" displayName="{BloodRH/DisplayName}"/>
					</observation>
				</component>
			</organizer>
		</entry>
	</xsl:template>
	<xsl:template match="Blood" mode="LabE1">
		<!--血型-->
		<entry typeCode="COMP">
			<organizer classCode="BATTERY" moodCode="EVN">
				<statusCode/>
				<!--ABO血型-->
				<component typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.010.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="CD" code="{BloodABO/Code}" codeSystem="2.16.156.10011.2.3.1.85" codeSystemName="ABO血型代码表" displayName="{BloodABO/DisplayName}"/>
					</observation>
				</component>
				<!--Rh血型-->
				<component typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.001.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="CD" code="{BloodRH/Code}" codeSystem="2.16.156.10011.2.3.1.250" codeSystemName="Rh(D)血型代码表" displayName="{BloodRH/DisplayName}"/>
					</observation>
				</component>
			</organizer>
		</entry>
	</xsl:template>
	<xsl:template match="Blood" mode="LabE2">
		<!--血型-->
		<entry>
			<organizer classCode="BATTERY" moodCode="EVN">
				<statusCode/>
				<!--ABO血型-->
				<component>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.010.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="CD" code="{BloodABO/Code}" codeSystem="2.16.156.10011.2.3.1.85" codeSystemName="ABO血型代码表" displayName="{BloodABO/DisplayName}"/>
					</observation>
				</component>
				<!--Rh血型-->
				<component>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.001.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="CD" code="{BloodRH/Code}" codeSystem="2.16.156.10011.2.3.1.250" codeSystemName="Rh(D)血型代码表" displayName="{BloodRH/DisplayName}"/>
					</observation>
				</component>
			</organizer>
		</entry>
	</xsl:template>
	<!-- 过敏史章节 -->
	<xsl:template match="Allergy" mode="Allergy">
		<component>
			<section>
				<code code="48765-2" displayName="Allergies, adverse reactions, alerts" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<entry typeCode="DRIV">
					<act classCode="ACT" moodCode="EVN">
						<code/>
						<entryRelationship typeCode="SUBJ">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE02.10.023.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="过敏史标志"/>
								<value xsi:type="BL" value="{value}"/>
								<participant typeCode="CSM">
									<participantRole classCode="MANU">
										<playingEntity classCode="MMAT">
											<!--过敏史描述-->
											<code code="DE02.10.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="过敏史"/>
											<desc xsi:type="ST">
												<xsl:value-of select="FreeTextAllergy"/>
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
	</xsl:template>
	<xsl:template match="Allergy" mode="Allergy1">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="过敏史描述"/>
				<value xsi:type="ST">
					<xsl:value-of select="FreeTextAllergy"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<!--既往史-->
	<xsl:template match="IllnessHistories" mode="Surgery">
		<xsl:comment>手术史</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.061.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="{IllnessHistory1/Type} "/>
				<value xsi:type="ST">
					<xsl:value-of select="IllnessHistory1/NoteText"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="IllnessHistories" mode="Past">
		<xsl:comment>既往史</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.099.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="{IllnessHistory2/Type} "/>
				<value xsi:type="ST">
					<xsl:value-of select="IllnessHistory2/NoteText"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="IllnessHistories" mode="Pregnancy">
		<xsl:comment>既往孕产史</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.098.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="{IllnessHistory3/Type} "/>
				<value xsi:type="ST">
					<xsl:value-of select="IllnessHistory3/NoteText"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="Allergy" mode="Gravidity">
		<xsl:comment>孕次</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.01.108.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="孕次"/>
				<value xsi:type="INT" value="{YunCi}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="Allergy" mode="CC">
		<xsl:comment>产次</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.002.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产次"/>
				<value xsi:type="INT" value="{ChanCi}"/>
			</observation>
		</entry>
	</xsl:template>
	<!--产前检查章节-->
	<xsl:template match="*" mode="PrenatalExamination">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.067.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫底高度（cm） "/>
				<value xsi:type="PQ" value="{HeightOfFundus}" unit="cm"/>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.052.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="腹围（cm） "/>
				<value xsi:type="PQ" value="{GirthOfPaunch}" unit="cm"/>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.01.044.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎方位代码 "/>
				<value xsi:type="CD" code="{PositionOfFoetus/Code}" displayName="{PositionOfFoetus/Name}" codeSystem="2.16.156.10011.2.3.1.106" codeSystemName="胎方位代码表"/>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.183.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎心率（次/min） "/>
				<value xsi:type="PQ" value="{FetalHeartRate}" unit="次/min"/>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.135.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="头位难产情况的评估 "/>
				<value xsi:type="ST">
					<xsl:value-of select="FirstFetalDystocia"/>
				</value>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.247.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出口横径（cm） "/>
				<value xsi:type="PQ" value="{TransverseOutlet}" unit="cm"/>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.175.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="骶耻外径（cm） "/>
				<value xsi:type="PQ" value="{ExternalConjugate}" unit="cm"/>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.239.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="坐骨结节间径（cm） "/>
				<value xsi:type="PQ" value="{BiischialDiameter}" unit="cm"/>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.245.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫缩情况 "/>
				<value xsi:type="ST">
					<xsl:value-of select="UterineContraction"/>
				</value>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.248.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫颈厚度 "/>
				<value xsi:type="ST">
					<xsl:value-of select="CervicalThickness"/>
				</value>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.265.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫口情况 "/>
				<value xsi:type="ST">
					<xsl:value-of select="UterineMouthCondition"/>
				</value>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.155.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎膜情况代码 "/>
				<value xsi:type="CD" code="{TaiMo/Code}" displayName="{TaiMo/Name}" codeSystem="2.16.156.10011.2.3.2.45" codeSystemName="胎膜情况代码表"/>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.256.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="破膜方式代码 "/>
				<value xsi:type="CD" code="{PoMo/Code}" displayName="{PoMo/Name}" codeSystem="2.16.156.10011.2.3.2.46" codeSystemName="破膜方式代码表"/>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.262.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="先露位置 "/>
				<value xsi:type="ST">
					<xsl:value-of select="XLWeiZhi"/>
				</value>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.30.062.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="羊水情况 "/>
				<value xsi:type="ST">
					<xsl:value-of select="YangShui"/>
				</value>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.257.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="膀胱充盈标志 "/>
				<value xsi:type="BL" value="{BladderFillingMarker}"/>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.01.123.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="肠胀气标志 "/>
				<value xsi:type="BL" value="{IntestinalFlatulenceMark}"/>
			</observation>
		</entry>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.50.139.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查方式代码 "/>
				<value xsi:type="CD" code="{TestMode/Code}" displayName="{TestMode/Name}" codeSystem="2.16.156.10011.2.3.2.47" codeSystemName="检查方式代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<!--处置计划章节-->
	<xsl:template match="*" mode="DPlan1">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.014.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="处置计划 "/>
				<value xsi:type="ST">
					<xsl:value-of select="Plan"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="DPlan2">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.011.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="计划选取的分娩方式 "/>
				<value xsi:type="CD" code="{FenMian/Code}" displayName="{FenMian/Name}" codeSystem="2.16.156.10011.2.3.1.10" codeSystemName="分娩方式代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="DPlan3">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE09.00.053.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产程记录日期时间 "/>
				<value xsi:type="TS" value="{Time}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="DPlan4">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.190.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产程经过 "/>
				<value xsi:type="ST">
					<xsl:value-of select="ChanCheng"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<!--器械物品核对章节-->
	<xsl:template match="*" mode="Check1">
		<!--巡台护士-->
		<xsl:comment>巡台护士</xsl:comment>
		<participant typeCode="ATND">
			<!--签名日期时间：DE09.00.053.00-->
			<xsl:comment>签名日期时间</xsl:comment>
			<time value="{PatrolNurse/Time}"/>
			<participantRole classCode="ASSIGNED">
				<id root="2.16.156.10011.1.4" extension="医务人员编码"/>
				<!--角色-->
				<code displayName="巡台护士"/>
				<!--巡台护士签名：DE02.01.039.00-->
				<xsl:comment>巡台护士签名</xsl:comment>
				<playingEntity classCode="PSN" determinerCode="INSTANCE">
					<name>
						<xsl:value-of select="PatrolNurse/Name"/>
					</name>
				</playingEntity>
			</participantRole>
		</participant>
		<!--器械护士-->
		<xsl:comment>器械护士</xsl:comment>
		<participant typeCode="ATND">
			<!--签名日期时间：DE09.00.053.00-->
			<xsl:comment>签名日期时间</xsl:comment>
			<time value="{Time}"/>
			<participantRole classCode="ASSIGNED">
				<id root="2.16.156.10011.1.4" extension="医务人员编码"/>
				<!--角色-->
				<code displayName="器械护士"/>
				<!--器械护士签名：DE02.01.039.00-->
				<xsl:comment>器械护士签名</xsl:comment>
				<playingEntity classCode="PSN" determinerCode="INSTANCE">
					<name>
						<xsl:value-of select="InstrumentNurse/Name"/>
					</name>
				</playingEntity>
			</participantRole>
		</participant>
	</xsl:template>
	<xsl:template match="*" mode="Check2">
		<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE08.50.042.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术中所用物品名称"/>
									<value xsi:type="ST">
									<xsl:value-of select="WuPinName"/>
									</value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE09.00.111.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术前清点标志"/>
											<value xsi:type="BL" value="{BiaoZhi}"/>
										</observation>
									</entryRelationship>
								</observation>
							</component>
	</xsl:template>
	<xsl:template match="*" mode="Check3">
		<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE08.50.042.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术中所用物品名称"/>
									<value xsi:type="ST">
									<xsl:value-of select="WuPinName"/>
									</value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE09.00.111.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="关前核对标志"/>
											<value xsi:type="BL" value="{BiaoZhi}"/>
										</observation>
									</entryRelationship>
								</observation>
							</component>
	</xsl:template>
	<xsl:template match="*" mode="Check4">
		<component>
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE08.50.042.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术中所用物品名称"/>
									<value xsi:type="ST">
									<xsl:value-of select="WuPinName"/>
									</value>
									<entryRelationship typeCode="COMP">
										<observation classCode="OBS" moodCode="EVN">
											<code code="DE09.00.111.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="关后核对标志"/>
											<value xsi:type="BL" value="{BiaoZhi}"/>
										</observation>
									</entryRelationship>
								</observation>
							</component>
	</xsl:template>
	<!--皮肤章节-->
	<xsl:template match="*" mode="Skin1">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.126.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="皮肤检查描述"/>
				<value xsi:type="ST">
					<xsl:value-of select="MiaoShu"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<!--输液章节-->
	<xsl:template match="*" mode="Trans24">
		<component>
			<section>
				<code code="10216-0" displayName="Surgical operation note fluids" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<!--术中输液项目 -->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="{Code}" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="{Name}"/>
						<value xsi:type="ST">
							<xsl:value-of select="Depict"/>
						</value>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!--输血章节-->
	<xsl:template match="*" mode="Metachysis">
		<entry>
			<procedure classCode="PROC" moodCode="EVN">
				<!--输血日期时间 -->
				<xsl:comment>输血日期时间</xsl:comment>
				<effectiveTime>
					<high value="{Time}"/>
				</effectiveTime>
				<!--输血品种代码 -->
				<xsl:comment>输血品种代码</xsl:comment>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE08.50.040.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血品种代码"/>
						<value xsi:type="CD" code="{pinzhong/Code}" displayName="{pinzhong/Name}" codeSystem="2.16.156.10011.2.3.1.251" codeSystemName="输血品种代码表"/>
					</observation>
				</entryRelationship>
				<!--输血量（mL） -->
				<xsl:comment>输血量（mL）</xsl:comment>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.267.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血量（mL）"/>
						<value xsi:type="PQ" value="{BloodVolume}" unit="mL"/>
					</observation>
				</entryRelationship>
				<!--输血量计量单位 -->
				<xsl:comment>输血量计量单位</xsl:comment>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE08.50.036.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血量计量单位"/>
						<value xsi:type="ST">
							<xsl:value-of select="Unit"/>
						</value>
					</observation>
				</entryRelationship>
				<!--输血反应标志 -->
				<xsl:comment>输血反应标志</xsl:comment>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.264.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血反应标志"/>
						<value xsi:type="BL" value="{biaozhi}"/>
					</observation>
				</entryRelationship>
			</procedure>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Metachysis1">
		<entry>
			<procedure>
				<entryRelationship typeCode="COMP">
					<!-- 输血史标识代码 -->
					<xsl:comment>输血史标识代码</xsl:comment>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.106.00" displayName="输血史标识代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="CD" code="{SXShi/Code}" displayName="{SXShi/Name}" codeSystem="2.16.156.10011.2.3.2.42" codeSystemName="输血史标识代码表"/>
					</observation>
				</entryRelationship>
				<entryRelationship typeCode="COMP">
					<!-- 输血性质代码 -->
					<xsl:comment>输血性质代码</xsl:comment>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.147.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血性质代码"/>
						<value xsi:type="CD" code="{SXXingZhi/Code}" displayName="{SXXingZhi/Name}" codeSystem="2.16.156.10011.2.3.2.43" codeSystemName="输血性质代码表"/>
					</observation>
				</entryRelationship>
				<entryRelationship typeCode="COMP">
					<!-- 申请 -->
					<xsl:comment>申请</xsl:comment>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.001.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="申请ABO血型代码"/>
						<value xsi:type="CD" code="{BloodABO/Code}" displayName="{BloodABO/DisplayName}" codeSystem="2.16.156.10011.2.3.1.85" codeSystemName="ABO血型代码表"/>
					</observation>
				</entryRelationship>
				<entryRelationship typeCode="COMP">
					<!-- 申请Rh血型代码 -->
					<xsl:comment>申请Rh血型代码</xsl:comment>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.010.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="申请Rh（D）血型代码"/>
						<value code="{BloodRH/Code}" xsi:type="CD" codeSystem="2.16.156.10011.2.3.1.250" displayName="{BloodRH/DisplayName}" codeSystemName="Rh(D)血型代码表"/>
					</observation>
				</entryRelationship>
				<!-- 输血指征 -->
				<xsl:comment>输血指征</xsl:comment>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.340.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血指征"/>
						<value xsi:type="ST">
							<xsl:value-of select="SXZhiZheng"/>
						</value>
					</observation>
				</entryRelationship>
				<!-- 输血过程记录 -->
				<xsl:comment>输血过程记录</xsl:comment>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.181.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血过程记录"/>
						<value xsi:type="ST">
							<xsl:value-of select="BloodRecode"/>
						</value>
					</observation>
				</entryRelationship>
				<!-- 血袋编码 -->
				<xsl:comment>血袋编码</xsl:comment>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE01.00.023.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="血袋编码"/>
						<value xsi:type="{BloodBagNO/Type}" value="{BloodBagNO/NO}"/>
					</observation>
				</entryRelationship>
				<!--输血反应类型 -->
				<xsl:comment>输血反应类型</xsl:comment>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.265.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血反应类型"/>
						<value xsi:type="CD" code="{MetachysisReaction/Code}" displayName="{MetachysisReaction/Name}" codeSystem="2.16.156.10011.2.3.1.252" codeSystemName="输血反应类型代码表"/>
					</observation>
				</entryRelationship>
				<!-- 输血次数 -->
				<xsl:comment>输血次数</xsl:comment>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.263.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血次数"/>
						<value xsi:type="{Amount/Type}" value="{Amount/CiShu}"/>
					</observation>
				</entryRelationship>
				<!-- 输血原因 -->
				<xsl:comment>输血原因</xsl:comment>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.107.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血原因"/>
						<value xsi:type="ST">
							<xsl:value-of select="Reason"/>
						</value>
					</observation>
				</entryRelationship>
			</procedure>
		</entry>
	</xsl:template>
	<!--麻醉章节-->
	<xsl:template match="*" mode="Anaesthesia">
		<component>
			<section>
				<code code="59774-0" displayName="Procedure anesthesia" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<entry>
					<!-- 1..1 麻醉记录 -->
					<xsl:comment>麻醉记录</xsl:comment>
					<procedure classCode="PROC" moodCode="EVN">
						<!--麻醉方法代码-->
						<xsl:comment>麻醉方法代码</xsl:comment>
						<code code="{Method/Code}" displayName="{Method/Name}" codeSystem="2.16.156.10011.2.3.1.159" codeSystemName="麻醉方法代码表"/>
						<effectiveTime>
							<!--麻醉开始日期时间-->
							<xsl:comment>麻醉开始日期时间</xsl:comment>
							<low value="{Time}"/>
						</effectiveTime>
						<!--ASA分级标准代码 -->
						<xsl:comment>ASA分级标准代码</xsl:comment>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE05.10.129.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="ASA分级标准代码"/>
								<value xsi:type="CD" code="{ASA/Code}" displayName="{ASA/Name}" codeSystem="2.16.156.10011.2.3.1.255" codeSystemName="美国麻醉医师协会(ASA)分级标准代码表"/>
							</observation>
						</entryRelationship>
						<!--气管插管分类 -->
						<xsl:comment>气管插管分类</xsl:comment>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.228.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="气管插管分类"/>
								<value xsi:type="ST">
									<xsl:value-of select="TrachealClassification"/>
								</value>
							</observation>
						</entryRelationship>
						<!--麻醉药物名称 -->
						<xsl:comment>麻醉药物名称</xsl:comment>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE08.50.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉药物名称"/>
								<value xsi:type="ST">
									<xsl:value-of select="MedicineName"/>
								</value>
							</observation>
						</entryRelationship>
						<!--麻醉体位 -->
						<xsl:comment>麻醉体位</xsl:comment>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE04.10.260.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉体位"/>
								<value xsi:type="ST">
									<xsl:value-of select="AnestheticBody"/>
								</value>
							</observation>
						</entryRelationship>
						<!--呼吸类型代码 -->
						<xsl:comment>呼吸类型代码</xsl:comment>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.208.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="呼吸类型代码"/>
								<value xsi:type="CD" code="{BreathType/Code}" displayName="{BreathType/Name}" codeSystem="2.16.156.10011.2.3.2.1" codeSystemName="呼吸类型代码表"/>
							</observation>
						</entryRelationship>
						<!--麻醉描述 -->
						<xsl:comment>麻醉描述</xsl:comment>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.226.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉描述"/>
								<value xsi:type="ST">
									<xsl:value-of select="Depict"/>
								</value>
							</observation>
						</entryRelationship>
						<!--麻醉合并症标志代码 -->
						<xsl:comment>麻醉合并症标志代码</xsl:comment>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE05.01.077.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉合并症标志代码"/>
								<value xsi:type="CD" code="{AnaesthesiaComplication/Code}" displayName="AnaesthesiaComplication/Name" codeSystem="2.16.156.10011.2.3.2.59" codeSystemName="麻醉合并症标志代码表"/>
							</observation>
						</entryRelationship>
						<!--穿刺过程 -->
						<xsl:comment>穿刺过程</xsl:comment>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE05.10.063.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="穿刺过程"/>
								<value xsi:type="ST">
									<xsl:value-of select="Puncture"/>
								</value>
							</observation>
						</entryRelationship>
						<!--麻醉效果 -->
						<xsl:comment>麻醉效果</xsl:comment>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.253.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉效果"/>
								<value xsi:type="ST">
									<xsl:value-of select="AnaesthesiaEffect"/>
								</value>
							</observation>
						</entryRelationship>
						<!--麻醉前用药 -->
						<xsl:comment>麻醉前用药</xsl:comment>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.136.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉前用药"/>
								<value xsi:type="ST">
									<xsl:value-of select="PreanestheticMedication"/>
								</value>
							</observation>
						</entryRelationship>
					</procedure>
				</entry>
			</section>
		</component>
	</xsl:template>
	<xsl:template match="*" mode="Anaesthesia1">
		<component>
			<section>
				<code code="59774-0" displayName="Procedure anesthesia" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<!-- 麻醉方法代码 -->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.073.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉方法代码"/>
						<value xsi:type="CD" code="{Method/Code}" displayName="{Method/Name}" codeSystem="2.16.156.10011.2.3.1.159" codeSystemName="麻醉方法代码表"/>
						<!-- 麻醉适应证 -->
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.227.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉适应证"/>
								<value xsi:type="ST">
									<xsl:value-of select="Indication"/>
								</value>
							</observation>
						</entryRelationship>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!--主要健康问题章节-->
	<xsl:template match="*" mode="HealthProblem">
		<entry>
			<!--常规监测项目名称 -->
			<xsl:comment>常规监测项目名称</xsl:comment>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.216.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="常规监测项目名称"/>
				<value xsi:type="ST">
					<xsl:value-of select="RoutineName"/>
				</value>
				<!--常规监测项目结果 -->
				<xsl:comment>常规监测项目结果</xsl:comment>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.281.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="常规监测项目结果"/>
						<value xsi:type="ST">
							<xsl:value-of select="RoutineResult"/>
						</value>
					</observation>
				</entryRelationship>
			</observation>
		</entry>
		<entry>
			<!--特殊监测项目名称 -->
			<xsl:comment>特殊监测项目名称</xsl:comment>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.216.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="特殊监测项目名称"/>
				<value xsi:type="ST">
					<xsl:value-of select="SpecialName"/>
				</value>
				<!--特殊监测项目结果 -->
				<xsl:comment>特殊监测项目结果</xsl:comment>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.281.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="特殊监测项目结果"/>
						<value xsi:type="ST">
							<xsl:value-of select="SpecialResult"/>
						</value>
					</observation>
				</entryRelationship>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="HealthProblem1">
		<!-- 麻醉恢复情况 -->
		<xsl:comment>麻醉恢复情况</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.225.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉恢复情况"/>
				<value xsi:type="ST">
					<xsl:value-of select="Recovery"/>
				</value>
			</observation>
		</entry>
		<!-- 清醒日期时间 -->
		<xsl:comment>清醒日期时间</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.233.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="清醒日期时间"/>
				<value xsi:type="TS" value="{QXTime}"/>
			</observation>
		</entry>
		<!-- 拔除气管插管标志 -->
		<xsl:comment>拔除气管插管标志</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.165.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="拔除气管插管标志"/>
				<value xsi:type="BL" value="{Symbol}"/>
			</observation>
		</entry>
		<!-- 特殊情况 -->
		<xsl:comment>特殊情况</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.158.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="特殊情况"/>
				<value xsi:type="ST">
					<xsl:value-of select="SpecialCase"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="HealthProblem2">
		<!--疾病诊断-->
		<xsl:comment>疾病诊断</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<!--疾病诊断编码-->
				<xsl:comment>疾病诊断编码</xsl:comment>
				<code code="DE05.01.024.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="疾病诊断编码"/>
				<value xsi:type="CD" code="{DiseaseCode/Code}" displayName="{DiseaseCode/Name}" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="ICD-10"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="HealthProblem3">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.197.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="待产日期时间 "/>
				<value xsi:type="TS" value="{DCTime}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="HealthProblem4">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.01.108.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="孕次 "/>
				<value xsi:type="INT" value="{PregnancyTime}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="HealthProblem5">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.002.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产次 "/>
				<value xsi:type="INT" value="{BirthTime}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="HealthProblem6">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.051.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="末次月经日期 "/>
				<value xsi:type="TS" value="{LMPTime}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="HealthProblem7">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.261.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="受孕形式代码 "/>
				<value xsi:type="CD" code="{FertilizationForm/Code}" displayName="{FertilizationForm/Name}" codeSystem="2.16.156.10011.2.3.2.44" codeSystemName="受孕形式代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="HealthProblem8">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.098.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="预产期 "/>
				<value xsi:type="TS" value="{YuChanDate}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="HealthProblem9">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.013.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产前检查标志 "/>
				<value xsi:type="BL" value="{CQJianCha}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="HealthProblem10">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.161.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产前检查异常情况 "/>
				<value xsi:type="ST">
					<xsl:value-of select="Abnormal"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="HealthProblem11">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.070.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="此次妊娠特殊情况 "/>
				<value xsi:type="ST">
					<xsl:value-of select="Special"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<!--阴道分娩章节-->
	<xsl:template match="*" mode="Delivery1">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.224.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="临产日期时间"/>
				<value xsi:type="TS" value="{DeliveryTime}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery2">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.154.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎膜破裂日期时间"/>
				<value xsi:type="TS" value="{TMPoLieTime}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery3">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.30.058.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="前羊水性状"/>
				<value xsi:type="ST">
					<xsl:value-of select="AmnioticFluidCharacter"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery4">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.30.057.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="前羊水量（mL）"/>
				<value xsi:type="PQ" value="{AmnioticFluidAmount}" unit="ml"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery5">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.250.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫缩开始日期时间"/>
				<value xsi:type="TS" value="{UterineContractionTime}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery6">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.021.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="第1产程时长（min）"/>
				<value xsi:type="PQ" value="{FirstDurationOfLabor}" unit="min"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery7">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.250.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫口开全日期时间"/>
				<value xsi:type="TS" value="{UterineOpeningTime}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery8">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.019.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="第2产程时长（min）"/>
				<value xsi:type="PQ" value="{SecondDurationOfLabor}" unit="min"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery9">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.01.014.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎儿娩出日期时间"/>
				<value xsi:type="TS" value="{FetalDisengagementTime}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery10">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.020.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="第3产程时长（min）"/>
				<value xsi:type="PQ" value="{ThirdDurationOfLabor}" unit="min"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery11">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.273.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎盘娩出日期时间"/>
				<value xsi:type="TS" value="{MazaTime}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery12">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.236.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="总产程时长（min）"/>
				<value xsi:type="PQ" value="{ZongChengTime}" unit="min"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery13">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.311.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎儿娩出助产标志"/>
				<value xsi:type="BL" value="{ZhuChanSign}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery14">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.312.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="助产方式"/>
				<value xsi:type="ST">
					<xsl:value-of select="ZhuChanFS"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery15">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.157.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎盘娩出情况"/>
				<value xsi:type="ST">
					<xsl:value-of select="TPMCQK"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery16">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.156.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎膜完整情况标志"/>
				<value xsi:type="BL" value="{TPSign}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery17">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.01.044.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎方位代码"/>
				<value xsi:type="CD" code="{PositionOfFoetus/Code}" displayName="{PositionOfFoetus/Name}" codeSystem="2.16.156.10011.2.3.1.106" codeSystemName="胎方位代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery18">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.30.063.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="羊水性状"/>
				<value xsi:type="ST">
					<xsl:value-of select="YangShui"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery19">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.30.061.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="羊水量（mL）"/>
				<value xsi:type="PQ" value="{YangShuiAmount}" unit="ml"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery20">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.30.055.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="脐带长度（cm）"/>
				<value xsi:type="PQ" value="{UmbilicalCordLength}" unit="cm"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery21">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.30.059.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="绕颈身（周）"/>
				<value xsi:type="PQ" value="{RaoJingShen}" unit="周"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery22">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.145.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="脐带异常情况标志"/>
				<value xsi:type="BL" value="{QDYCSign}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery23">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE08.50.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产时用药"/>
				<value xsi:type="ST">
					<xsl:value-of select="CSYongYao"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery24">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.295.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="预防措施"/>
				<value xsi:type="ST">
					<xsl:value-of select="YFCS"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery25">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.165.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产妇会阴切开标志"/>
				<value xsi:type="BL" value="{CFHYSign}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery26">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.252.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="会阴切开位置"/>
				<value xsi:type="ST">
					<xsl:value-of select="HY"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery27">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.011.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产妇会阴缝合针数"/>
				<value xsi:type="INT" value="{FHZS}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery28">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.01.003.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产妇会阴裂伤程度代码"/>
				<value xsi:type="CD" code="{LSCD/Code}" displayName="{LSCD/Name}" codeSystem="2.16.156.10011.2.3.1.109" codeSystemName="会阴裂伤情况代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery29">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.253.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="会阴血肿标志"/>
				<value xsi:type="BL" value="{XZSign}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery30">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.254.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="会阴血肿大小"/>
				<value xsi:type="ST">
					<xsl:value-of select="XZ"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery31">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.213.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="会阴血肿处理"/>
				<value xsi:type="ST">
					<xsl:value-of select="XZCL"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery32">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.073.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉方法代码"/>
				<value xsi:type="CD" code="{Method/Code}" displayName="{Method/Name}" codeSystem="2.16.156.10011.2.3.1.159" codeSystemName="麻醉方法代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery33">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE08.50.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉药物名称"/>
				<value xsi:type="ST">
					<xsl:value-of select="MedicineName"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery34">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.163.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="阴道裂伤标志"/>
				<value xsi:type="BL" value="{YDLSSign}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery35">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.164.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="阴道血肿标志"/>
				<value xsi:type="BL" value="{YDLSSign}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery36">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.249.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫颈裂伤标志"/>
				<value xsi:type="BL" value="{GJLSSign}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery37">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.200.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫颈缝合情况"/>
				<value xsi:type="ST">
					<xsl:value-of select="GJFH"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery38">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE08.50.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产后用药"/>
				<value xsi:type="ST">
					<xsl:value-of select="CHYY"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery39">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.182.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="分娩过程摘要"/>
				<value xsi:type="ST">
					<xsl:value-of select="FMGC"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery40">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.245.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫缩情况"/>
				<value xsi:type="ST">
					<xsl:value-of select="UterineContraction"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery41">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.233.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="子宫情况"/>
				<value xsi:type="ST">
					<xsl:value-of select="UterineMouthCondition"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery42">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.025.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="恶露状况"/>
				<value xsi:type="ST">
					<xsl:value-of select="ELZK"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery43">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.137.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="会阴情况"/>
				<value xsi:type="ST">
					<xsl:value-of select="HYQK"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery44">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.284.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="修补手术过程"/>
				<value xsi:type="ST">
					<xsl:value-of select="XBSS"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Delivery45">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.50.138.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="存脐带血情况标志"/>
				<value xsi:type="BL" value="{QDDXSign}"/>
			</observation>
		</entry>
	</xsl:template>
	<!-- 产后处置章节 -->
	<xsl:template match="*" mode="PD1">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.007.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产后诊断"/>
				<value xsi:type="ST">
					<xsl:value-of select="CHZD"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="PD2">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.218.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产后观察日期时间"/>
				<value xsi:type="TS" value="{CHGCTime}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="PD3">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.246.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产后检查时间（min）"/>
				<value xsi:type="PQ" value="{CHJCTime}" unit="min"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="PD4">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.118.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产后脉搏（次/min ）"/>
				<value xsi:type="PQ" value="{CHMB}" unit="次/min"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="PD5">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.206.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产后心率（次/min ）"/>
				<value xsi:type="PQ" value="{CHXL}" unit="/次min"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="PD6">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.012.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产后出血量（mL）"/>
				<value xsi:type="PQ" value="{CHCXL}" unit="ml"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="PD7">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.245.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产后宫缩"/>
				<value xsi:type="ST">
					<xsl:value-of select="CHGS"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="PD8">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.067.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产后宫底高度（cm）"/>
				<value xsi:type="PQ" value="{CHGDGD}" unit="cm"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="PD9">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.240.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="肛查"/>
				<value xsi:type="ST">
					<xsl:value-of select="GangCha"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<!-- 新生儿章节 -->
	<xsl:template match="*" mode="Neonatus1">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.01.040.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="新生儿性别代码"/>
				<value xsi:type="CD" code="{Gender/Code}" displayName="{Gender/Name}" codeSystem="2.16.156.10011.2.3.3.4" codeSystemName="生理性别代码表(GB/T 2261.1)"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Neonatus2">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.019.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="新生儿出生体重（g）"/>
				<value xsi:type="PQ" value="{Weight}" unit="g"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Neonatus3">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="新生儿出生身长（cm）"/>
				<value xsi:type="PQ" value="{Stature}" unit="cm"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Neonatus4">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.168.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产瘤大小"/>
				<value xsi:type="ST">
					<xsl:value-of select="ChanLiu"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Neonatus5">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.167.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产瘤部位"/>
				<value xsi:type="ST">
					<xsl:value-of select="CLBW"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<!-- 分娩评估章节 -->
	<xsl:template match="*" mode="CE1">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.215.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="Apgar评分间隔时间代码 "/>
				<value xsi:type="CD" code="{PFJianGe/Code}" displayName="{PFJianGe/Name}" codeSystem="2.16.156.10011.2.3.2.48" codeSystemName="Apgar评分间隔时间代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="CE2">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.001.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="Apgar评分值"/>
				<value xsi:type="INT" value="{FenZhi}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="CE3">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.026.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="分娩结局代码"/>
				<value xsi:type="CD" code="{FMJieJu/Code}" displayName="{FMJieJu/Name}" codeSystem="2.16.156.10011.2.3.2.49" codeSystemName="分娩结局代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="CE4">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.160.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="新生儿异常情况代码"/>
				<value xsi:type="CD" code="{YiChang/Code}" displayName="{YiChang/Name}" codeSystem="2.16.156.10011.2.3.1.254" codeSystemName="新生儿异常情况代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<!--生命体征章节-->
	<xsl:template match="*" mode="VitalSign1">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.188.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体重"/>
				<value xsi:type="PQ" value="{Weight}" unit="kg"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="VitalSign2">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.186.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体温"/>
				<value xsi:type="PQ" value="{Temperature}" unit="℃"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="VitalSign3">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.118.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="脉率"/>
				<value xsi:type="PQ" value="{PulseRate}" unit="次/min"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="VitalSign4">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.081.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="呼吸频率"/>
				<value xsi:type="PQ" value="{BreathingRate}" unit="次/min"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="VitalSign5">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.206.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="心率"/>
				<value xsi:type="PQ" value="{HeartRate}" unit="次/min"/>
			</observation>
		</entry>
	</xsl:template>
	<!--体格检查-血压（mmHg）-->
	<xsl:template match="*" mode="VitalSign6">
		<entry>
			<organizer classCode="BATTERY" moodCode="EVN">
				<code displayName="血压"/>
				<statusCode/>
				<component>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.10.174.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="收缩压"/>
						<value xsi:type="PQ" value="{SystolicPressure}" unit="mmHg"/>
					</observation>
				</component>
				<component>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.10.176.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="舒张压"/>
						<value xsi:type="PQ" value="{DiastolicPressure}" unit="mmHg"/>
					</observation>
				</component>
			</organizer>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="VitalSign7">
		<!-- 起搏器心率 -->
		<xsl:comment>起搏器心率</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.206.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="起搏器心率（次/min）"/>
				<value xsi:type="PQ" value="{Pacemaker }" unit="次/min"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="VitalSign9">
		<!-- 血糖检测值（mmol/L） -->
		<xsl:comment>血糖检测值（mmol/L）</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.50.102.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="血糖检测值（mmol/L）"/>
				<value xsi:type="PQ" value="3.4" unit="mmol/L"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="VitalSign8">
		<!-- 腹围-->
		<xsl:comment>腹围</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.052.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="腹围（cm）"/>
				<value xsi:type="PQ" value="{FuWei}" unit="cm"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="VitalSign10">
		<!-- 血氧饱和度（%）-->
		<xsl:comment>血氧饱和度（%）</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.50.149.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="血氧饱和度（%）"/>
				<value xsi:type="PQ" value="{XYSaturation}" unit="%"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="VitalSign11">
		<xsl:comment>孕前体重（kg）</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.188.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="孕前体重（kg） "/>
				<value xsi:type="PQ" value="{Weight}" unit="kg"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="VitalSign12">
		<xsl:comment>产前体重（kg）</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.188.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产前体重（kg） "/>
				<value xsi:type="PQ" value="{Weight}" unit="kg"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="VitalSign13">
		<xsl:comment>身高（cm）</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.167.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="身高（cm） "/>
				<value xsi:type="PQ" value="{Height}" unit="cm"/>
			</observation>
		</entry>
	</xsl:template>
	<!--四肢章节-->
	<xsl:template match="*" mode="Limbs">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.237.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="足背动脉搏动标志"/>
				<value xsi:type="BL" value="{value}"/>
			</observation>
		</entry>
	</xsl:template>
	<!--护理记录章节-->
	<xsl:template match="*" mode="NurR1">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.211.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理等级代码"/>
				<value xsi:type="CD" code="{Rank/Code}" displayName="{Rank/Name}" codeSystem="2.16.156.10011.2.3.1.259" codeSystemName="护理等级代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="NurR2">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.212.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理类型代码"/>
				<value xsi:type="CD" code="{Type/Code}" displayName="{Type/Name}" codeSystem="2.16.156.10011.2.3.1.260" codeSystemName="护理类型代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="NurR3">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.209.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="导管护理描述"/>
				<value xsi:type="ST">
					<xsl:value-of select="DaoGuanHL"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="NurR4">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.229.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="气管护理代码"/>
				<value xsi:type="CD" code="{QiGuanHL/Code}" displayName="{QiGuanHL/Name}" codeSystem="2.16.156.10011.2.3.2.50" codeSystemName="气管护理代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="NurR5">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.259.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体位护理"/>
				<value xsi:type="ST">
					<xsl:value-of select="TiWeiHL"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="NurR6">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.50.068.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="皮肤护理"/>
				<value xsi:type="ST">
					<xsl:value-of select="PiFuHL"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="NurR7">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.292.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="营养护理"/>
				<value xsi:type="ST">
					<xsl:value-of select="YingYangHL"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="NurR8">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.283.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="心理护理代码"/>
				<value xsi:type="CD" code="{XinLiHL/Code}" displayName="{XinLiHL/Name}" codeSystem="2.16.156.10011.2.3.2.51" codeSystemName="心理护理代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="NurR9">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.178.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="安全护理代码"/>
				<value xsi:type="CD" code="{AnQuanHL/Code}" displayName="{AnQuanHL/Name}" codeSystem="2.16.156.10011.2.3.2.52" codeSystemName="安全护理代码表"/>
			</observation>
		</entry>
	</xsl:template>
	<!--护理观察章节-->
	<xsl:template match="*" mode="Nur1">
		<xsl:comment>护理观察项目名称</xsl:comment>
		<code code="DE02.10.031.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理观察项目名称"/>
		<value xsi:type="ST">
			<xsl:value-of select="Name"/>
		</value>
	</xsl:template>
	<xsl:template match="*" mode="Nur2">
		<xsl:comment>护理观察结果描述</xsl:comment>
		<entryRelationship typeCode="COMP">
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.028.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理观察结果"/>
				<value xsi:type="ST">
					<xsl:value-of select="MiaoShu"/>
				</value>
			</observation>
		</entryRelationship>
	</xsl:template>
	<xsl:template match="*" mode="Nur3">
		<xsl:comment>简要病情</xsl:comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.181.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="简要病情"/>
				<value xsi:type="ST">
					<xsl:value-of select="BingQing"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<!--护理操作章节-->
	<xsl:template match="*" mode="NurP1">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.342.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理操作名称"/>
				<value xsi:type="ST">
					<xsl:value-of select="Name"/>
				</value>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.210.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理操作项目类目名称"/>
						<value xsi:type="ST">
							<xsl:value-of select="LeiMu"/>
						</value>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.209.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="护理操作结果"/>
								<value xsi:type="ST">
									<xsl:value-of select="Result"/>
								</value>
							</observation>
						</entryRelationship>
					</observation>
				</entryRelationship>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="NurP2">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.207.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="呼吸机监护项目"/>
				<value xsi:type="ST">
					<xsl:value-of select="BreathingMachine"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<!--手术评估标志章节-->
	<xsl:template match="*" mode="SurgicalEvaluation1">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.204.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="发出手术安全核对表标志">
					<qualifier>
						<name displayName="{Name1}"/>
					</qualifier>
				</code>
				<value xsi:type="BL" value="{Value1}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="SurgicalEvaluation2">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.338.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="收回手术安全核对表标志">
					<qualifier>
						<name displayName="{Name2}"/>
					</qualifier>
				</code>
				<value xsi:type="BL" value="{Value2}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="SurgicalEvaluation3">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.204.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="发出手术风险评估表标志">
					<qualifier>
						<name displayName="{Name3}"/>
					</qualifier>
				</code>
				<value xsi:type="BL" value="{Value3}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="SurgicalEvaluation4">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.338.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="收回手术风险评估表标志">
					<qualifier>
						<name displayName="{Name4}"/>
					</qualifier>
				</code>
				<value xsi:type="BL" value="{Value4}"/>
			</observation>
		</entry>
	</xsl:template>
	<!--护理隔离-->
	<xsl:template match="*" mode="CloseOff">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.201.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="隔离标志"/>
				<value xsi:type="BL" value="true"/>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.202.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="隔离种类代码"/>
						<value xsi:type="CD" code="{Code}" displayName="{Name}" codeSystem="2.16.156.10011.2.3.1.261" codeSystemName="隔离种类代码表"/>
					</observation>
				</entryRelationship>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="Inspect">
		<!--一般状况检查章节-->
		<component>
			<section>
				<code code="10210-3" displayName="GENERAL STATUS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<!--一般状况检查结果-->
				<xsl:comment>一般状况检查结果</xsl:comment>
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.10.219.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="一般状况检查结果"/>
						<value xsi:type="ST">
							<xsl:value-of select="Result"/>
						</value>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!--手术操作章节-->
	<xsl:template match="*" mode="OP">
		<component>
			<section>
				<code code="47519-4" displayName="HISTORY OF PROCEDURES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<entry>
					<!-- 1..1 手术记录 -->
					<xsl:comment>手术记录</xsl:comment>
					<procedure classCode="PROC" moodCode="EVN">
						<code code="1" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表（ICD-9-CM）"/>
						<!--操作日期/时间-->
						<xsl:comment>操作日期/时间</xsl:comment>
						<effectiveTime>
							<!--手术开始日期时间-->
							<xsl:comment>手术开始日期时间</xsl:comment>
							<low value="{StartTime}"/>
							<!--手术结束日期时间-->
							<xsl:comment>手术结束日期时间</xsl:comment>
							<high value="{EndTime}"/>
						</effectiveTime>
						<!--手术者姓名-->
						<xsl:comment>手术者姓名</xsl:comment>
						<performer>
							<assignedEntity>
								<id root="2.16.156.10011.1.4" extension="医务人员编号"/>
								<assignedPerson>
									<name>
										<xsl:value-of select="Performer"/>
									</name>
								</assignedPerson>
							</assignedEntity>
						</performer>
						<!--手术间编号-->
						<xsl:comment>手术间编号</xsl:comment>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.256.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="患者实施手术所在的手术室编号"/>
								<value xsi:type="ST">
									<xsl:value-of select="OperatingRoomNO"/>
								</value>
							</observation>
						</entryRelationship>
						<!--手术体位代码 -->
						<xsl:comment>手术体位代码 </xsl:comment>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.260.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术体位代码"/>
								<value xsi:type="CD" code="{SSTiWei/Code}" displayName="{SSTiWei/Name}" codeSystem="2.16.156.10011.2.3.1.262" codeSystemName="手术体位代码表"/>
							</observation>
						</entryRelationship>
						<!--诊疗过程描述 -->
						<xsl:comment>诊疗过程描述</xsl:comment>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.296.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="诊疗过程描述"/>
								<value xsi:type="ST">
									<xsl:value-of select="ZLMiaoShu"/>
								</value>
							</observation>
						</entryRelationship>
					</procedure>
				</entry>
			</section>
		</component>
	</xsl:template>
	<xsl:template match="*" mode="OP1">
		<component>
			<section>
				<code code="47519-4" displayName="HISTORY OF PROCEDURES" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<!-- 手术及操作编码 DE06.00.093.00 -->
				<entry>
					<procedure classCode="PROC" moodCode="EVN">
						<code xsi:type="CD" code="{SSCode}" displayName="{SSName}" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表(ICD-9-CM)"/>
					</procedure>
				</entry>
			</section>
		</component>
	</xsl:template>
	<xsl:template match="*" mode="OP2">
		<entry>
			<!-- 1..1 手术记录 -->
			<procedure classCode="PROC" moodCode="EVN">
				<!--手术及操作编码:DE06.00.093.00-->
				<code code="{SSCode}" displayName="{SSName}" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表(ICD-9-CM)"/>
				<statusCode/>
				<!--手术时间：开始日期时间DE06.00.218.00、结束日期时间DE06.00.221.00-->
				<xsl:comment>操作日期/时间</xsl:comment>
				<effectiveTime>
					<!--手术开始日期时间-->
					<xsl:comment>手术开始日期时间</xsl:comment>
					<low value="{StartTime}"/>
					<!--手术结束日期时间-->
					<xsl:comment>手术结束日期时间</xsl:comment>
					<high value="{EndTime}"/>
				</effectiveTime>
				<!--手术目标部位名称：DE06.00.187.00-->
				<targetSiteCode code="{SSMuBiao/Code}" displayName="{SSMuBiao/Name}" codeSystem="2.16.156.10011.2.3.1.266" codeSystemName="手术目标部位编码"/>
				<!--手术操作者：DE02.01.039.00-->
				<xsl:comment>手术者姓名</xsl:comment>
				<performer>
					<assignedEntity>
						<id root="2.16.156.10011.1.4" extension="医务人员编号"/>
						<assignedPerson>
							<name>
								<xsl:value-of select="Performer"/>
							</name>
						</assignedPerson>
					</assignedEntity>
				</performer>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.30.060.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="术中病理标志"/>
						<value xsi:type="BL" value="{PathologicalMarkers}"/>
					</observation>
				</entryRelationship>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.317.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="准备事项"/>
						<value xsi:type="ST">
							<xsl:value-of select="SurgicalPreparation"/>
						</value>
					</observation>
				</entryRelationship>
				<xsl:comment>手术间编号</xsl:comment>
				<entryRelationship typeCode="COMP">
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.256.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术间编号"/>
						<value xsi:type="ST">
							<xsl:value-of select="OperatingRoomNO"/>
						</value>
					</observation>
				</entryRelationship>
				<!-- 出入手术室时间 -->
				<xsl:comment>出入手术室时间</xsl:comment>
				<entryRelationship typeCode="COMP">
					<organizer classCode="BATTERY" moodCode="EVN">
						<statusCode/>
						<!-- DE06.00.236.00入手术室日期时间 DE06.00.191.00 出手术室日期时间 -->
						<effectiveTime>
							<low value="{InTime}"/>
							<high value="{OutTime}"/>
						</effectiveTime>
					</organizer>
				</entryRelationship>
			</procedure>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP3">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.109.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="产前诊断"/>
				<value xsi:type="ST">
					<xsl:value-of select="CQZhenDuan"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP4">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.340.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术指征"/>
				<value xsi:type="ST">
					<xsl:value-of select="SSZhiZheng"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP5">
		<entry>
			<procedure classCode="PROC" moodCode="EVN">
				<code xsi:type="CD" code="{SSCode}" displayName="{SSName}" codeSystem="2.16.156.10011.2.3.3.12" codeSystemName="手术(操作)代码表(ICD-9-CM)"/>
			</procedure>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP6">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.221.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术开始日期时间"/>
				<value xsi:type="TS" value="{StartTime}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP7">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.260.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉体位"/>
				<value xsi:type="ST">
					<xsl:value-of select="AnestheticBody"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP8">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.253.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="麻醉效果"/>
				<value xsi:type="ST">
					<xsl:value-of select="MZXiaoGuo"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP9">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.063.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="剖宫产手术过程"/>
				<value xsi:type="ST">
					<xsl:value-of select="PFCGC"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP10">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.173.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎儿娩出方式"/>
				<value xsi:type="ST">
					<xsl:value-of select="TEMC"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP11">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.153.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎盘黄染">
					<qualifier>
						<name displayName="胎盘黄 染"/>
					</qualifier>
				</code>
				<value xsi:type="ST">
					<xsl:value-of select="TPHR"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP12">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.153.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎膜黄染">
					<qualifier>
						<name displayName="胎膜黄 染"/>
					</qualifier>
				</code>
				<value xsi:type="ST">
					<xsl:value-of select="TMHR"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP13">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.30.054.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="脐带缠绕情况"/>
				<value xsi:type="ST">
					<xsl:value-of select="QDCR"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP14">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.30.056.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="脐带扭转（周）"/>
				<value xsi:type="PQ" value="{QDNZ}" unit="周"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP15">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.200.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="子宫壁缝合情况"/>
				<value xsi:type="ST">
					<xsl:value-of select="ZGFH"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP16">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE08.50.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫缩剂名称"/>
				<value xsi:type="ST">
					<xsl:value-of select="GSJName"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP17">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.136.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫缩剂使用方法"/>
				<value xsi:type="ST">
					<xsl:value-of select="GSJShiYong"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP18">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE08.50.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术用药"/>
				<value xsi:type="ST">
					<xsl:value-of select="SSYongYao"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP19">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.293.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术用药量"/>
				<value xsi:type="ST">
					<xsl:value-of select="YongYaoAmount"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP20">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.233.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="腹腔探查子宫"/>
				<value xsi:type="ST">
					<xsl:value-of select="FQTanCha"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP21">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.10.042.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="腹腔探查附件"/>
				<value xsi:type="ST">
					<xsl:value-of select="FQTCFuJian"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP22">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.30.053.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫腔探查异常情况标志"/>
				<value xsi:type="BL" value="{GQYiChang}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP23">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.166.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫腔探查肌瘤标志"/>
				<value xsi:type="BL" value="{GQJiLiu}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP24">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE04.30.052.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫腔探查处理情况"/>
				<value xsi:type="ST">
					<xsl:value-of select="GQChuLi"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP25">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE05.10.134.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术时产妇情况"/>
				<value xsi:type="ST">
					<xsl:value-of select="CFQingKuang"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP26">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.097.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出血量（mL）"/>
				<value xsi:type="PQ" value="{ChuXueAmount}" unit="ml"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP27">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.262.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血成分"/>
				<value xsi:type="ST">
					<xsl:value-of select="SXChengFen"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP28">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.267.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血量（mL）"/>
				<value xsi:type="PQ" value="{ShuXueAmount}" unit="ml"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP29">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.268.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输液量（mL）"/>
				<value xsi:type="PQ" value="{ShuYeAmount}" unit="ml"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP30">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.318.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="供氧时间（min）"/>
				<value xsi:type="PQ" value="{GongYangTime}" unit="min"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP31">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE08.50.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="其他用药"/>
				<value xsi:type="ST">
					<xsl:value-of select="QTYongYao"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP32">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.179.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="其他情况"/>
				<value xsi:type="ST">
					<xsl:value-of select="QTQingKuang"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP33">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.218.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术结束日期时间"/>
				<value xsi:type="TS" value="{EndTime}"/>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="*" mode="OP34">
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE06.00.259.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术全程时间（min）"/>
				<value xsi:type="PQ" value="{QCTime}" unit="min"/>
			</observation>
		</entry>
	</xsl:template>
	<!--失血章节-->
	<xsl:template match="*" mode="Hemorrhage">
		<component>
			<section>
				<code code="55103-6" displayName="Surgical operation note estimated blood loss" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<!--出血量（mL）-->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.097.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出血量（mL）"/>
						<value xsi:type="PQ" unit="{Unit}" value="{Liang}"/>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!--术后去向章节-->
	<xsl:template match="*" mode="Postoperative">
		<component>
			<section>
				<code code="59775-7" displayName="Procedure disposition" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<!--患者去向代码 -->
				<xsl:comment>患者去向代码</xsl:comment>
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.185.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="患者去向代码"/>
						<effectiveTime>
							<!--出手术室日期时间-->
							<xsl:comment>出手术室日期时间</xsl:comment>
							<high value="{Time}"/>
						</effectiveTime>
						<value xsi:type="ST">
							<xsl:value-of select="Type"/>
						</value>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!--住院过程章节 术后交接-->
	<xsl:template match="*" mode="PostoperativeHandover">
		<code code="DE06.00.206.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="病人交接核对项目"/>
		<value xsi:type="ST">
			<xsl:value-of select="XiangMu"/>
		</value>
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
								<value xsi:type="ST">
									<xsl:value-of select="Display"/>
								</value>
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
						<code code="DE02.10.027.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验方法名称"/>
						<value xsi:type="ST">
							<xsl:value-of select="CheckProject"/>
						</value>
					</observation>
				</entry>
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.30.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验类别"/>
						<value xsi:type="ST">
							<xsl:value-of select="CheckCategory"/>
						</value>
					</observation>
				</entry>
				<entry>
					<organizer classCode="CLUSTER" moodCode="EVN">
						<statusCode/>
						<component>
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE04.30.019.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验项目代码"/>
								<!-- 检验时间 -->
								<effectiveTime value="{CheckTime}"/>
								<value xsi:type="ST">
									<xsl:value-of select="CheckCode"/>
								</value>
								<entryRelationship typeCode="COMP">
									<observation classCode="OBS" moodCode="EVN">
										<code code="DE04.50.134.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="标本类别"/>
										<!-- DE04.50.137.00	标本采样日期时间
		DE04.50.141.00	接收标本日期时间 -->
										<effectiveTime>
											<low value="{SamplingTime}"/>
											<high value="{AcceptTime}"/>
										</effectiveTime>
										<value xsi:type="ST">
											<xsl:value-of select="SpecimenCategory"/>
										</value>
									</observation>
								</entryRelationship>
								<entryRelationship typeCode="COMP">
									<observation classCode="OBS" moodCode="EVN">
										<code code="DE04.50.135.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="标本状态"/>
										<value xsi:type="ST">
											<xsl:value-of select="SpecimenState"/>
										</value>
									</observation>
								</entryRelationship>
							</observation>
						</component>
						<component>
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE04.30.017.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验结果代码"/>
								<value xsi:type="CD" code="{ResultsCode}" codeSystem="2.16.156.10011.2.3.2.38" codeSystemName="检查/检验结果代码表" displayName="{ResultsDisplayName}"/>
							</observation>
						</component>
						<component>
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE04.30.015.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检验定量结果"/>
								<value xsi:type="REAL" value="{ResultsValue}"/>
								<entryRelationship typeCode="COMP">
									<observation classCode="OBS" moodCode="EVN">
										<code code="DE04.30.016.00" displayName="检查定量结果计量单位" codeSystemName="卫生信息数据元目录" codeSystem="2.16.156.10011.2.2.1"/>
										<value xsi:type="ST">
											<xsl:value-of select="Unit"/>
										</value>
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
						<value xsi:type="ST">
							<xsl:value-of select="ElectrocardiogramResult"/>
						</value>
					</observation>
				</entry>
				<!-- 胸部X线检查结果 -->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.30.045.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胸部X线检查结果"/>
						<value xsi:type="ST">
							<xsl:value-of select="X-RayResult"/>
						</value>
					</observation>
				</entry>
				<!-- CT检查结果 -->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.30.005.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="CT检查结果"/>
						<value xsi:type="ST">
							<xsl:value-of select="CTResult"/>
						</value>
					</observation>
				</entry>
				<!-- B超检查结果 -->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.30.002.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="B超检查结果"/>
						<value xsi:type="ST">
							<xsl:value-of select="UltrasoundResult"/>
						</value>
					</observation>
				</entry>
				<!-- MRI检查结果 -->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.30.009.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="MRI检查结果"/>
						<value xsi:type="ST">
							<xsl:value-of select="MRIResult"/>
						</value>
					</observation>
				</entry>
				<!-- 肺功能检查结果 -->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.30.009.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="肺功能检查结果"/>
						<value xsi:type="ST">
							<xsl:value-of select="LungFunction"/>
						</value>
					</observation>
				</entry>
				<!-- 血常规检查结果 -->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.128.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="血常规检查结果"/>
						<value xsi:type="ST">
							<xsl:value-of select="RoutineBlood"/>
						</value>
					</observation>
				</entry>
				<!-- 尿常规检查结果 -->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.048.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="尿常规检查结果"/>
						<value xsi:type="ST">
							<xsl:value-of select="RoutineUrine"/>
						</value>
					</observation>
				</entry>
				<!-- 凝血功能检查结果 -->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.142.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="凝血功能检查结果"/>
						<value xsi:type="ST">
							<xsl:value-of select="BloodCoagulation"/>
						</value>
					</observation>
				</entry>
				<!-- 肝功能检查结果 -->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.026.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="肝功能检查结果"/>
						<value xsi:type="ST">
							<xsl:value-of select="LiverFunction"/>
						</value>
					</observation>
				</entry>
				<!-- 血气分析检查结果 -->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE04.50.128.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="血气分析检查结果"/>
						<value xsi:type="ST">
							<xsl:value-of select="Respiratory-BloodCheck"/>
						</value>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!--适用住院病程，抢救记录-->
	<xsl:template match="LaboratoryExamination" mode="LabE4">
		<component>
			<section>
				<code code="30954-2" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="STUDIES SUMMARY"/>
				<text/>
				<!--检查/检验项目-->
				<entry>
					<observation classCode="OBS " moodCode="EVN ">
						<code code="DE04.30.020.00" displayName="检查/检验项目名称" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="ST">
							<xsl:value-of select="doc44/jcxmmc"/>
						</value>
						<entryRelationship typeCode="COMP">
							<!--检查/检验结果-->
							<observation classCode="OBS " moodCode="EVN ">
								<code code="DE04.30.009.00" displayName="检查/检验结果" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
								<value xsi:type="ST">
									<xsl:value-of select="doc44/jcjg"/>
								</value>
							</observation>
						</entryRelationship>
						<entryRelationship typeCode="COMP">
							<!--检查/检验定量结果-->
							<observation classCode="OBS " moodCode="EVN ">
								<code code="DE04.30.015.00" displayName="检查/检验定量结果" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="卫生信息数据元目录"/>
								<value xsi:type="PQ" value="{doc44/jydljg}" unit="{doc44/jydljgdw}"/>
							</observation>
						</entryRelationship>
						<entryRelationship typeCode="COMP">
							<!--检查/检验结果代码-->
							<observation classCode="OBS " moodCode="EVN ">
								<code code="DE04.30.017.00" displayName="检查/检验结果代码" codeSystem="2.16.156.10011.2.3.3.11" codeSystemName="卫生信息数据元目录"/>
								<value xsi:type="CD" code="{doc44/jcjgdm/code}" displayName="{doc44/jcjgdm/displayname}" codeSystem="2.16.156.10011.2.3.2.38" codeSystemName="检查/检验结果代码表"/>
								<!--1.正常 2.异常 3.不确定-->
							</observation>
						</entryRelationship>
					</observation>
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
								<value xsi:type="ST">
									<xsl:value-of select="doc53/yxjcjg"/>
								</value>
							</observation>
						</component>
					</organizer>
				</entry>
			</section>
		</component>
	</xsl:template>
</xsl:stylesheet>
