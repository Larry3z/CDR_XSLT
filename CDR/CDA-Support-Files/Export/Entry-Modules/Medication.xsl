<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">
	<!--适用文档：西药处方-->
	<xsl:template match="Medication" mode="Medi1">
		<component>
			<section>
				<code code="10160-0" codeSystem="2.16.840.1.113883.6.1" displayName="HISTORY
OF MEDICATION USE" codeSystemName="LOINC"/>
				<text/>
				<entry>
					<substanceAdministration classCode="SBADM" moodCode="EVN">
						<text/>
						<!--服用方式-->
						<routeCode code="xxxx" displayName="xxxx" codeSystem="2.16.156.10011.2.3.1.158" codeSystemName="用药途径代码表"/>
						<!--用药剂量-单次 -->
						<doseQuantity value="xxxx" unit="mg"/>
						<!--用药频率 -->
						<rateQuantity>
							<translation code="xxxx" displayName="xxxx"/>
						</rateQuantity>
						<!--药物剂型 -->
						<administrationUnitCode code="xxxx" displayName="xxxx" codeSystem="2.16.156.10011.2.3.1.211" codeSystemName="药物剂型代码表"/>
						<consumable>
							<manufacturedProduct>
								<manufacturedLabeledDrug>
									<!--药品代码及名称(通用名) -->
									<code/>
									<name>xxxx</name>
								</manufacturedLabeledDrug>
							</manufacturedProduct>
						</consumable>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE08.50.043.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="药物规格"/>
								<!--药物描述-->
								<value xsi:type="ST">xxxx</value>
							</observation>
						</entryRelationship>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.135.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="药物使用总剂量"/>
								<value xsi:type="PQ" value="xxxx"/>
							</observation>
						</entryRelationship>
					</substanceAdministration>
				</entry>
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.294.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="处方有效天数"/>
						<value xsi:type="PQ" value="xxxx" unit="天"/>
					</observation>
				</entry>
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE08.50.056.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="处方药品组号"/>
						<value xsi:type="INT" value="xxxx"/>
					</observation>
				</entry>
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.179.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="处方备注信息"/>
						<value xsi:type="ST">xxxx</value>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!--适用文档：中药处方-->
	<xsl:template match="Medication" mode="Medi2">
		<component>
			<section>
				<code code="10160-0" displayName="HISTORY OF MEDICATION USE" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<!--处方条目-->
				<entry>
					<substanceAdministration classCode="SBADM" moodCode="EVN">
						<text/>
						<routeCode code="xxxx" displayName="口服" codeSystem="2.16.156.10011.2.3.1.158" codeSystemName="用药途径代码表"/>
						<!--用药剂量-单次 -->
						<doseQuantity value="xxxx" unit="mg"/>
						<!--用药频率 -->
						<rateQuantity>
							<translation code="xxxx" displayName="xxxx"/>
						</rateQuantity>
						<!--药物剂型 -->
						<administrationUnitCode code="xxxx" displayName="xxxx" codeSystem="2.16.156.10011.2.3.1.211" codeSystemName="药物剂型代码表"/>
						<consumable>
							<manufacturedProduct>
								<manufacturedLabeledDrug>
									<!--药品代码及名称(通用名) -->
									<code/>
									<name>xxxx</name>
								</manufacturedLabeledDrug>
							</manufacturedProduct>
						</consumable>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE08.50.043.00" displayName="药物规格" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
								<value xsi:type="ST">xxxx</value>
							</observation>
						</entryRelationship>
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN">
								<code code="DE06.00.135.00" displayName="药物使用总剂量" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
								<value xsi:type="PQ" value="xxxx" unit="mg"/>
							</observation>
						</entryRelationship>
					</substanceAdministration>
				</entry>
				<!--处方有效天数-->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE06.00.294.00" displayName="处方有效天数" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="PQ" value="xxxx" unit="天"/>
					</observation>
				</entry>
				<!--处方药品组号-->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE08.50.056.00" displayName="处方药品组号" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="INT" value="xxxx"/>
					</observation>
				</entry>
				<!--中药饮片处方-->
				<entry>
					<observation classCode="OBS" moodCode="EVN ">
						<code code="DE08.50.049.00" displayName="中药饮片处方" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="ST">中药饮片处方的详细描述</value>
						<!--中药饮片剂数-->
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN ">
								<code code="DE08.50.050.00" displayName="中药饮片剂数" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
								<value xsi:type="PQ" value="xxxx" unit="剂"/>
							</observation>
						</entryRelationship>
						<!--中药饮片煎煮法-->
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN ">
								<code code="DE08.50.047.00" displayName="中药煎煮法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
								<value xsi:type="ST">xxxx</value>
							</observation>
						</entryRelationship>
						<!--中药用药方法-->
						<entryRelationship typeCode="COMP">
							<observation classCode="OBS" moodCode="EVN ">
								<code code="DE06.00.136.00" displayName="中药用药法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
								<value xsi:type="ST">xxxx</value>
							</observation>
						</entryRelationship>
					</observation>
				</entry>
				<!-- 处方类别代码 DE08.50.032.00 处方类别代码 -->
				<entry>
					<observation classCode="OBS" moodCode="EVN">
						<code code="DE08.50.032.00" displayName="处方类别代码" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="CD" code="xxxx" codeSystem="2.16.156.10011.2.3.2.40" codeSystemName="处方类别代码表" displayName="xxxx"/>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
	<!--适用文档：上级医师查房-->
	<xsl:template match="Medication" mode="Medi3">
		<component>
			<section>
				<code code="10160-0" displayName="HISTORY OF MEDICATION USE" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>
				<text/>
				<!--中药煎煮法-->
				<entry>
					<observation classCode="OBS" moodCode="EVN ">
						<code code="DE08.50.047.00" displayName="中药煎煮方法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="ST"><xsl:value-of select="DecoctionDescription"/></value>
					</observation>
				</entry>
				<!--中药用药方法-->
				<entry>
					<observation classCode="OBS" moodCode="EVN ">
						<code code="DE06.00.136.00" displayName="中药用药方法" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录"/>
						<value xsi:type="ST"><xsl:value-of select="TookDescription"/></value>
					</observation>
				</entry>
			</section>
		</component>
	</xsl:template>
    <!--适用文档：一般手术记录-->
	<xsl:template match="Medication" mode="Medi4">
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
              <value xsi:type="ST">xxxx</value> 
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
              <value xsi:type="ST">xxxx</value> 
            </observation> 
          </entry> 
        </section> 
      </component>  
	</xsl:template>
	<!--适用文档：出入量记录-->
	<xsl:template match="Medication" mode="Medi5">
	<component>
				<section>
					<code code="10160-0" codeSystem="2.16.840.1.113883.6.1" displayName="HISTORY
OF MEDICATION USE" codeSystemName="LOINC"/>
					<text/>
					<entry>
						<substanceAdministration classCode="SBADM" moodCode="EVN">
							<text/>
							<!--药物使用途径代码：DE06.00.134.00-->
							<routeCode code="xxxx" displayName="xxxx" codeSystem="2.16.156.10011.2.3.1.158" codeSystemName="用药途径代码表"/>
							<!--用药剂量-单次 -->
							<doseQuantity value="xxxx" unit="mg"/>
							<!--用药频率-->
							<rateQuantity>
								<translation code="xxxx" displayName="bid"/>
							</rateQuantity>
							<consumable>
								<manufacturedProduct>
									<manufacturedLabeledDrug>
										<!--药品名称 -->
										<code/>
										<name>氢氯噻臻</name>
									</manufacturedLabeledDrug>
								</manufacturedProduct>
							</consumable>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.136.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="药物用法"/>
									<!--药物用法描述-->
									<value xsi:type="ST">药物用法描述</value>
								</observation>
							</entryRelationship>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.164.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="中药使用类别代码"/>
									<!--中药使用类别代码-->
									<value code="1" displayName="未使用" codeSystem="2.16.156.10011.2.3.1.157" codeSystemName="中药使用类别代码表" xsi:type="CD"/>
								</observation>
							</entryRelationship>
							<entryRelationship typeCode="COMP">
								<observation classCode="OBS" moodCode="EVN">
									<code code="DE06.00.135.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="药物使用总剂量"/>
									<!--药物使用总剂量-->
									<value xsi:type="PQ" value="100.00" unit="mg"/>
								</observation>
							</entryRelationship>
						</substanceAdministration>
					</entry>
				</section>
			</component>
	</xsl:template>
</xsl:stylesheet>
