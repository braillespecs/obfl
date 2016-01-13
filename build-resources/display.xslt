<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xs fn html">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"
	 doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	 doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

	<xsl:template match="processing-instruction()">
		<!-- Adds a toc based on all hx elements following the <?toc?> instruction -->
		<xsl:if test="name() = 'toc'">
			<ul>
				<xsl:apply-templates select="following::html:h2" mode="sublist"/>
			</ul>
		</xsl:if>
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="html:h1|html:h2|html:h3|html:h4|html:h5|html:h6" mode="sublist">
		<xsl:variable name="id" select="generate-id()"/>
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="level" select="number(substring(local-name(), 2))"/>
		<!-- For some reason I couldn't do this with the if function, perhaps XPath 1.0? -->
		<xsl:variable name="id-value">
			<xsl:choose>
				<xsl:when test="@id"><xsl:value-of select="@id"></xsl:value-of></xsl:when>
				<xsl:otherwise><xsl:value-of select="$id"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<li><a href="#{$id-value}"><xsl:value-of select="."/></a>
			<xsl:variable name="nodes" select="following::*[
				(self::html:h1 or self::html:h2 or self::html:h3 or self::html:h4 or self::html:h5 or self::html:h6) 
				and number(substring(local-name(), 2))= $level + 1
				and preceding::*[name()=$name][1][generate-id() = $id]
				]"/>
			<xsl:if test="count($nodes)>0">
			<ul>
			<xsl:for-each select="$nodes">		
					<xsl:apply-templates select="." mode="sublist"/>
			</xsl:for-each>
			</ul>
			</xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match="html:h1|html:h2|html:h3|html:h4|html:h5|html:h6">
		<xsl:variable name="id" select="generate-id()"/>
		<xsl:copy>
			<xsl:if test="not(@id)">
				<xsl:attribute name="id" >
					<xsl:value-of select="$id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*|*|comment()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>