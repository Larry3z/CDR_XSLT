<?xml version="1.0" encoding="UTF-8"?>
<!-- Created with Liquid Studio 2017 - Developer Bundle Edition (Trial) 15.1.4.7515 (https://www.liquid-technologies.com) -->
<xsl:stylesheet version="1.0" xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:isc="http://extension-functions.intersystems.com" xmlns:exsl="http://exslt.org/common" xmlns:set="http://exslt.org/sets" exclude-result-prefixes="isc sdtc exsl set">

	<!--适用入院记录、住院病程，会诊记录、住院病程，术前小结-->
	<xsl:template match="Comments" mode="AssE">
	<component> 
        <section> 
          <code displayName="辅助检查"/>  
          <text/>  
          <!--辅助检查结果条目-->  
          <entry> 
            <observation classCode="OBS" moodCode="EVN"> 
              <code code="DE04.30.009.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="辅助检查结果"/>  
              <value xsi:type="ST"><xsl:value-of select="."/></value> 
            </observation> 
          </entry> 
        </section> 
      </component> 
	</xsl:template>
	
</xsl:stylesheet>
