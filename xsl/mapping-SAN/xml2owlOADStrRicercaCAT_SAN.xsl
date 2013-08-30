<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:bio="http://purl.org/vocab/bio/0.1/" xmlns="http://lod.xdams.org/reload/oad/" xml:base="http://lod.xdams.org/reload/oad/" xmlns:eac-cpf="http://archivi.ibc.regione.emilia-romagna.it/ontology/eac-cpf/" xmlns:viaf="http://viaf.org/ontology/1.1/#" xmlns:gn="http://www.geonames.org/ontology#" xmlns:daia="http://purl.org/ontology/daia/" xmlns:oad="http://lod.xdams.org/reload/oad/" xmlns:ricerca-san="http://san.mibac.it/ricerca-san/" xmlns:scons="http://san.mibac.it/scons-san/" xmlns:ead-str="http://san.mibac.it/ricerca-san/" xmlns:xlink="http://www.w3.org/1999/xlink">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" cdata-section-elements="p" indent="yes"/>
	<xsl:template match="*">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="/">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:bio="http://purl.org/vocab/bio/0.1/" xmlns="http://lod.xdams.org/reload/oad/" xml:base="http://lod.xdams.org/reload/oad/" xmlns:eac-cpf="http://archivi.ibc.regione.emilia-romagna.it/ontology/eac-cpf/" xmlns:viaf="http://viaf.org/ontology/1.1/#" xmlns:gn="http://www.geonames.org/ontology#" xmlns:daia="http://purl.org/ontology/daia/" xmlns:oad="http://lod.xdams.org/reload/oad/" xmlns:ricerca-san="http://san.mibac.it/ricerca-san/" xmlns:scons="http://san.mibac.it/scons-san/" xmlns:ead-str="http://san.mibac.it/ricerca-san/" xmlns:xlink="http://www.w3.org/1999/xlink">
			<xsl:for-each select="//ricerca-san:ead">
				<xsl:variable name="id" select="ricerca-san:did/ricerca-san:unitid"/>
				<xsl:call-template name="scriviRDF"/>
			</xsl:for-each>
		</rdf:RDF>
	</xsl:template>
	<xsl:template name="scriviRDF">
		<xsl:param name="rdf"/>
		<xsl:variable name="id">
			<xsl:value-of select="ricerca-san:eadheader/ricerca-san:eadid"/>
		</xsl:variable>
		<xsl:variable name="title">
			<xsl:value-of select="ricerca-san:eadheader/ricerca-san:filedesc/ricerca-san:titlestmt/ricerca-san:titleproper"/>
		</xsl:variable>
	
		<xsl:element name="oad:findingAid">
			<xsl:attribute name="rdf:about">findingAid/<xsl:value-of select="$id"/></xsl:attribute>
			<xsl:element name="rdfs:label">
				<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#string</xsl:attribute>
				<xsl:value-of select="$title"/>
			</xsl:element>
			<xsl:element name="dc:title">
				<xsl:value-of select="$title"/>
			</xsl:element>
			<xsl:if test="ricerca-san:eadheader/ricerca-san:filedesc/ricerca-san:titlestmt/ricerca-san:author/text()">
				<xsl:element name="dc:creator">
					<xsl:value-of select="ricerca-san:eadheader/ricerca-san:filedesc/ricerca-san:titlestmt/ricerca-san:author"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="ricerca-san:eadheader/ricerca-san:filedesc/ricerca-san:publicationstmt/ricerca-san:date/text()">
				<xsl:element name="dc:date">
					<xsl:value-of select="ricerca-san:eadheader/ricerca-san:filedesc/ricerca-san:publicationstmt/ricerca-san:date"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="ricerca-san:eadheader/ricerca-san:filedesc/ricerca-san:publicationstmt/ricerca-san:publisher/text() or ricerca-san:eadheader/ricerca-san:filedesc/ricerca-san:publicationstmt/ricerca-san:address/text()">
				<xsl:element name="dc:publisher">
					<xsl:if test="ricerca-san:eadheader/ricerca-san:filedesc/ricerca-san:publicationstmt/ricerca-san:address/text()">
						<xsl:value-of select="ricerca-san:eadheader/ricerca-san:filedesc/ricerca-san:publicationstmt/ricerca-san:address"/>: </xsl:if>
					<xsl:value-of select="ricerca-san:eadheader/ricerca-san:filedesc/ricerca-san:publicationstmt/ricerca-san:publisher"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="ricerca-san:eadheader/ricerca-san:eadid/@URL">
				<xsl:element name="dcterms:isReferencedBy">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="ricerca-san:eadheader/ricerca-san:eadid/@URL"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:if test="ricerca-san:eadheader/ricerca-san:filedesc/@URL">
				<xsl:element name="dcterms:isReferencedBy">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="ricerca-san:eadheader/ricerca-san:eadid/@URL"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:if test="ricerca-san:eadheader/ricerca-san:filedesc/ricerca-san:notestmt/ricerca-san:note/text()">
				<xsl:for-each select="ricerca-san:eadheader/ricerca-san:filedesc/ricerca-san:notestmt/ricerca-san:note">
					<xsl:element name="dc:description">
						<xsl:value-of select="text()"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
			<xsl:element name="dcterms:provenance">
				<xsl:attribute name="rdf:resource"><xsl:for-each select="ancestor::node()[name()='record']"><xsl:value-of select="node()[name()='header']//node()[name()='setSpec']/text()"/></xsl:for-each></xsl:attribute>
				<!--NON E' RESOURCE!!!!-->
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="text()">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>
</xsl:stylesheet>
