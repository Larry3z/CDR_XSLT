<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="data.list">
		<item code="G31.901">大脑变性</item>
		<item code="G31.902">小脑变性</item>
	</xsl:variable>
	<xsl:key name="lookup.list" match="item" use="@code"/>
	<xsl:template match="/Document">
		<xsl:param name="font-size" select="14"/>
		<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:mif="urn:hl7-org:v3/mif" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:variable name="DCode" select="Diagnoses/Diagnosis/DiagnosisCode/Code"/>
			<Diagnosis>
				<DiseaseCode>
					<xsl:value-of select="$DCode"/>
				</DiseaseCode>
				<DiseaseName>
					<xsl:for-each select="document('')">
						<xsl:value-of select="key('lookup.list', $DCode)"/>
					</xsl:for-each>
				</DiseaseName>
			</Diagnosis>
		</ClinicalDocument>
	</xsl:template>
</xsl:stylesheet>
