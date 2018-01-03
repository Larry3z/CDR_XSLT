<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	
	<!--适用待产记录-->
	<xsl:template match="PrenatalExamination" mode="PreE">
	<component>
				<section>
					<code code="57073-9" displayName="Prenatal events" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.067.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫底高度（cm） "/>
							<value xsi:type="PQ" value="{gdgd}" unit="cm"/>
						</observation>
					</entry>  
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.052.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="腹围（cm） "/>
							<value xsi:type="PQ" value="{fw}" unit="cm"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.01.044.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎方位代码 "/>
							<value xsi:type="CD" code="{twfw/code}" displayName="{twfw/displayname}" codeSystem="2.16.156.10011.2.3.1.106" codeSystemName="胎方位代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.183.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎心率（次/min） "/>
							<value xsi:type="PQ" value="{txl}" unit="次/min"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.135.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="头位难产情况的评估 "/>
							<value xsi:type="ST"><xsl:value-of select="twncqkdpg"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.247.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="出口横径（cm） "/>
							<value xsi:type="PQ" value="{ckhj}" unit="cm"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.175.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="骶耻外径（cm） "/>
							<value xsi:type="PQ" value="{dcwj}" unit="cm"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.239.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="坐骨结节间径（cm） "/>
							<value xsi:type="PQ" value="{zgjjjj}" unit="cm"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.245.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫缩情况 "/>
							<value xsi:type="ST"><xsl:value-of select="gsqk"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.248.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫颈厚度 "/>
							<value xsi:type="ST"><xsl:value-of select="gjhd"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.265.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="宫口情况 "/>
							<value xsi:type="ST"><xsl:value-of select="gkqk"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.155.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胎膜情况代码 "/>
							<value xsi:type="CD" code="{tmqk/code}" displayName="{tmqk/displayname}" codeSystem="2.16.156.10011.2.3.2.45" codeSystemName="胎膜情况代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.256.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="破膜方式代码 "/>
							<value xsi:type="CD" code="{pmfs/code}" displayName="{pmfs/displayname}" codeSystem="2.16.156.10011.2.3.2.46" codeSystemName="破膜方式代码表"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.262.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="先露位置 "/>
							<value xsi:type="ST"><xsl:value-of select="xlwz"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.30.062.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="羊水情况 "/>
							<value xsi:type="ST"><xsl:value-of select="ysqk"/></value>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.257.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="膀胱充盈标志 "/>
							<value xsi:type="BL" value="{pgcybz}"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.01.123.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="肠胀气标志 "/>
							<value xsi:type="BL" value="{czqbz}"/>
						</observation>
					</entry>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.50.139.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查方式代码 "/>
							<value xsi:type="CD" code="{jcfs/code}" displayName="{jcfs/displayname}" codeSystem="2.16.156.10011.2.3.2.47" codeSystemName="检查方式代码表"/>
						</observation>
					</entry>
				</section>
			</component>
	</xsl:template>
	
	
	
</xsl:stylesheet>
