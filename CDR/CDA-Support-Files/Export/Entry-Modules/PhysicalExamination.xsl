<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	
	
	<!--适用出院小结、门急诊病历-->
	<xsl:template match=" PhysicalExamination " mode="PhyE">
	<component>
				<section>
					<code code="29545-1" displayName="PHYSICAL EXAMINATION" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
					<text/>
					<!--体格检查-一般状况检查结果-->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.258.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体格检查"/>
							<value xsi:type="ST"><xsl:value-of select="doc2-3/tgjcjg"/></value>
						</observation>
					</entry>
				</section>
			</component>
	</xsl:template>
	
	<!--适用检查报告-->
	<xsl:template match="PhysicalExamination" mode="PhyE1">
	<component> 
        <section> 
          <code code="29545-1" displayName="PHYSICAL EXAMINATION" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--特殊检查条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.01.079.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="特殊检查标志"/>  
              <value xsi:type="ST"><xsl:value-of select="doc6/tsjcbz"/></value> 
            </observation> 
          </entry>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE02.10.027.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查方法名称"/>  
              <value xsi:type="ST"><xsl:value-of select="doc6/jcfamc"/></value> 
            </observation> 
          </entry>  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.30.018.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查类别"/>  
              <value xsi:type="ST"><xsl:value-of select="doc6/jclb"/></value> 
            </observation> 
          </entry>  
          <entry> 
            <organizer classCode="CLUSTER" moodCode="EVN"> 
              <statusCode/>  
              <component> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE04.30.019.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查项目代码"/>  
                  <!-- 检查日期 -->  
                  <effectiveTime value="{doc6/jcTime}"/>  
                  <value xsi:type="ST"><xsl:value-of select="doc6/jcxmdm"/></value>  
                  <entryRelationship typeCode="COMP"> 
                    <observation classCode="OBS" moodCode="EVN"> 
                      <code code="DE04.30.019.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="标本类别"/>  
                      <!-- DE04.50.137.00标本采样日期时间
DE04.50.141.00 接收标本日期时间 -->  
                      <effectiveTime> 
                        <low value="{doc6/ybcjTime}"/>  
                        <high value="{doc6/ybjsTime}"/> 
                      </effectiveTime>  
                      <value xsi:type="ST"><xsl:value-of select="doc6/bblb"/></value> 
                    </observation> 
                  </entryRelationship>  
                  <entryRelationship typeCode="COMP"> 
                    <observation classCode="OBS" moodCode="EVN"> 
                      <code code="DE04.50.135.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="标本状态"/>  
                      <value xsi:type="ST"><xsl:value-of select="doc6/ybzt"/></value> 
                    </observation> 
                  </entryRelationship>  
                  <entryRelationship typeCode="COMP"> 
                    <observation classCode="OBS" moodCode="EVN"> 
                      <code code="DE04.30.019.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="标本固定液名称"/>  
                      <value xsi:type="ST"><xsl:value-of select="doc6/ybgdymc"/></value> 
                    </observation> 
                  </entryRelationship> 
                </observation> 
              </component>  
              <component> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE04.30.017.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="-"/>  
                  <value xsi:type="CD" code="{doc6/jcjg/code}" displayName="{doc6/jcjg/displayname}" codeSystem="2.16.156.10011.2.3.2.38" codeSystemName="检查/检验结果代码表"/> 
                </observation> 
              </component>  
              <component> 
                <observation classCode="OBS" moodCode="EVN"> 
                  <code code="DE04.30.015.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="检查定量结果"/>  
                  <value xsi:type="REAL" value="{doc6/jcdljg}"/>  
                  <entryRelationship typeCode="COMP"> 
                    <observation classCode="OBS" moodCode="EVN"> 
                      <code code="DE04.30.016.00" displayName="检查定量 结果计量单位" codeSystemName="卫生信息数据元目录" codeSystem="2.16.156.10011.2.2.1"/>  
                      <value xsi:type="ST"><xsl:value-of select="doc6/jcdljgdw"/></value> 
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
	<xsl:template match="PhysicalExamination" mode="PhyE2">
	<component>
				<section>
					<code code="29545-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="PHYSICAL EXAMINATION"/>
					<text/>
					<!-- 体重 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.188.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="体重"/>
							<value xsi:type="PQ" value="{doc10/tz}" unit="kg"/>
						</observation>
					</entry>
					<!-- 一般状况检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.219.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="一般状况检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="doc10/ybzk"/></value>
						</observation>
					</entry>
					<!-- 精神状态正常标志 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE05.10.142.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="精神状态正常标志"/>
							<value xsi:type="BL" value="{doc10/jszt}"/>
						</observation>
					</entry>
					<!-- 心脏听诊结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.207.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="心脏听诊结果"/>
							<value xsi:type="ST"><xsl:value-of select="doc10/xztz"/></value>
						</observation>
					</entry>
					<!-- 肺部听诊结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.031.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="肺部听诊结果"/>
							<value xsi:type="ST"><xsl:value-of select="doc10/fbtz"/></value>
						</observation>
					</entry>
					<!-- 四肢检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.179.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="四肢检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="doc10/szjc"/></value>
						</observation>
					</entry>
					<!-- 脊柱检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.093.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="脊柱检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="doc10/jzjc"/></value>
						</observation>
					</entry>
					<!-- 腹部检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.046.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="腹部检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="doc10/fbjc"/></value>
						</observation>
					</entry>
					<!-- 气管检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE06.00.230.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="气管检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="doc10/qgjc"/></value>
						</observation>
					</entry>
					<!-- 牙齿检查结果 -->
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE04.10.264.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="牙齿检查结果"/>
							<value xsi:type="ST"><xsl:value-of select="doc10/ycjc"/></value>
						</observation>
					</entry>
				</section>
			</component>
	</xsl:template>
	
	<!--适用入院记录-->
	<xsl:template match="PhysicalExamination" mode="PhyE3">
	<component> 
        <section> 
          <code code="29545-1" displayName="PHYSICAL EXAMINATION" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <text/>  
          <!--体格检查-一般状况检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.219.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="一般状况检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="doc34/ybzk"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-皮肤和黏膜检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.126.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="皮肤和黏膜检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="doc34/pfnmjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-全身浅表淋巴结检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.114.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="全身浅表淋巴结检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="doc34/lbjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-头部及其器官检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.261.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="头部及其器官检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="doc34/tbjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-颈部检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.255.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="颈部检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="doc34/jbjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-胸部检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.263.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="胸部检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="doc34/xbjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-腹部检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.046.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="腹部检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="doc34/fbjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-肛门指诊检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.065.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="肛门指诊检查结果描述"/>  
              <value xsi:type="ST"><xsl:value-of select="doc34/gmzz"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-外生殖器检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.195.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="外生殖器检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="doc34/szqjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-脊柱检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.093.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="脊柱检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="doc34/jzjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-四肢检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.10.179.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="四肢检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="doc34/szjc"/></value> 
            </observation> 
          </entry>  
          <!--体格检查-神经系统检查结果-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE05.10.149.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="神经系统检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="doc34/sjxtjc"/></value> 
            </observation> 
          </entry>  
          <!--专科情况-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE08.10.061.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="专科情况"/>  
              <value xsi:type="ST"><xsl:value-of select="doc34/zkqk"/></value> 
            </observation> 
          </entry> 
        </section> 
      </component> 
	</xsl:template>
	
	
	
</xsl:stylesheet>
