<?xml version='1.0'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="*" mode="CDAHeader">
		<Title>
			<xsl:value-of select="Title"/>
		</Title>
		<id root="2.16.156.10011.1.1" extension="{ID}"/>
	</xsl:template>
</xsl:stylesheet>