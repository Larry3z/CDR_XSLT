<!-- This file contains templates regrading CDAHeader, Author, CreationTime-->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<xsl:template match="Document" mode="Surgery">
		<comment>手术史</comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.061.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="手术史 "/>
				<value xsi:type="ST">
					<xsl:value-of select="/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:03:32Z']/NoteText"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="Document" mode="Illness">
		<comment>疾病史</comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.026.00" displayName="疾病史（含外伤）" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
				<value xsi:type="ST">
					<xsl:value-of select="/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:03:27Z']/NoteText"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="Document" mode="Infect">
		<comment>传染病史</comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.008.00" displayName="传染病史" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
				<value xsi:type="ST">
					<xsl:value-of select="/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T17:33:10Z']/NoteText"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="Document" mode="Marital">
		<comment>婚育史</comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.098.00" displayName="婚育史" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
				<value xsi:type="ST">
					<xsl:value-of select="/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:03:36Z']/NoteText"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="Document" mode="Past">
		<comment>既往史</comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.099.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="既往史 "/>
				<value xsi:type="ST">
					<xsl:value-of select="/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:04:07Z']/NoteText"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="Document" mode="Allergy">
		<comment>过敏史</comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.022.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="过敏史"/>
				<value xsi:type="ST">
					<xsl:value-of select="/Document/Allergies/Allergy/FreeTextAllergy"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="Document" mode="Blood">
		<comment>输血史</comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.100.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="输血史"/>
				<!--HDSD00.09.059 DE02.10.100.00 输血史 -->
				<value xsi:type="ST">
					<xsl:value-of select="/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:04:12Z']/NoteText"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="Document" mode="Pregnancy">
		<comment>既往孕产史</comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.098.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="既往孕产史 "/>
				<value xsi:type="ST">
					<xsl:value-of select="/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:04:08Z']/NoteText"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="Document" mode="Vaccination">
		<comment>预防接种史</comment>
		<entry>
			<observation classCode="OBS" moodCode="EVN">
				<code code="DE02.10.101.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="预防接种史"/>
				<!--HDSD00.09.081 DE02.10.101.00 预防接种史 -->
				<value xsi:type="ST">
					<xsl:value-of select="/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:04:13Z']/NoteText"/>
				</value>
			</observation>
		</entry>
	</xsl:template>
	<xsl:template match="Document" mode="HealthStatus">
		<comment>健康状况标志</comment>
		<code code="DE05.10.031.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="一般健康状况标志"/>
		<value xsi:type="BL" value="{/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:03:27Z']/IllnessID}"/>
	</xsl:template>
	<xsl:template match="Document" mode="InfectionStatus">
		<comment>患者传染性标志</comment>
		<code code="DE05.10.119.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="患者传染性标志"/>
		<value xsi:type="BL" value="{/Document/IllnessHistories/IllnessHistory[CreationTime='2017-11-01T18:04:11Z']/IllnessID}"/>
	</xsl:template>
	<xsl:template match="Document" mode="AllergyStatus">
		<comment>过敏标志</comment>
		<code code="DE02.10.023.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
		<value xsi:type="BL" value="{/Document/Allergies/Allergy/AllergyID}"/>
	</xsl:template>
	<xsl:template match="Document" mode="Social">
		<comment>个人史章节</comment>
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
	</xsl:template>
	<xsl:template match="Document" mode="Menstruation">
		<comment>月经史</comment>
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
	</xsl:template>
	<xsl:template match="Document" mode="Family">
		<comment>家族史</comment>
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
	</xsl:template>
	<xsl:template match="Document" mode="Present">
		<comment>现病史</comment>
		<component>
			<section>
				<code code="10164-2" displayName="HISTORY OF PRESENT ILLNESS" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<!--现病史条目-->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE02.10.071.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="现病史"/>
						<value xsi:type="ST"><xsl:value-of select="/Document/Problems/Problem1/Comments"/></value>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
	
</xsl:stylesheet>
