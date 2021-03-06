<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<!--适用文档：死亡记录-->
	<xsl:template match="AutopsyOpinion" mode="AOpi">
			<!--尸检意见章节-->
			<component>
				<section>
					<code displayName="尸检意见章节"/>
					<text/>
					<entry>
						<observation classCode="OBS" moodCode="EVN">
							<code code="DE09.00.115.00" codeSystem="2.16.156.10011.2.2.1" codeSystemName="卫生信息数据元目录" displayName="家属是否同意尸体解剖标志"/>
							<value xsi:type="BL" value="xxxx"/>
						</observation>
					</entry>
				</section>
			</component>
		</xsl:template>
</xsl:stylesheet>
