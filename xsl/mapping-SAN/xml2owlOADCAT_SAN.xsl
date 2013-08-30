<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:bio="http://purl.org/vocab/bio/0.1/" xmlns="http://lod.xdams.org/reload/oad/" xml:base="http://lod.xdams.org/reload/oad/" xmlns:eac-cpf="http://archivi.ibc.regione.emilia-romagna.it/ontology/eac-cpf/" xmlns:viaf="http://viaf.org/ontology/1.1/#" xmlns:gn="http://www.geonames.org/ontology#" xmlns:daia="http://purl.org/ontology/daia/" xmlns:oad="http://lod.xdams.org/reload/oad/" xmlns:ead-san="http://san.mibac.it/ead-san/" xmlns:scons="http://san.mibac.it/scons-san/" xmlns:ead-str="http://san.mibac.it/ricerca-san/" xmlns:xlink="http://www.w3.org/1999/xlink">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" cdata-section-elements="p" indent="yes"/>
	<xsl:template match="*">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="/">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:bio="http://purl.org/vocab/bio/0.1/" xmlns="http://lod.xdams.org/reload/oad/" xml:base="http://lod.xdams.org/reload/oad/" xmlns:eac-cpf="http://archivi.ibc.regione.emilia-romagna.it/ontology/eac-cpf/" xmlns:viaf="http://viaf.org/ontology/1.1/#" xmlns:gn="http://www.geonames.org/ontology#" xmlns:daia="http://purl.org/ontology/daia/" xmlns:oad="http://lod.xdams.org/reload/oad/" xmlns:ead-san="http://san.mibac.it/ead-san/" xmlns:scons="http://san.mibac.it/scons-san/" xmlns:ead-str="http://san.mibac.it/ricerca-san/" xmlns:xlink="http://www.w3.org/1999/xlink">
			<xsl:for-each select="//ead-san:ead">
				<xsl:variable name="id" select="ead-san:did/ead-san:unitid"/>
				<xsl:call-template name="scriviRDF"/>
			</xsl:for-each>
		</rdf:RDF>
	</xsl:template>
	<xsl:template name="scriviRDF">
		<xsl:param name="rdf"/>
		<xsl:variable name="id">
			<xsl:value-of select="ead-san:archdesc/ead-san:did/ead-san:unitid"/>
		</xsl:variable>
		<xsl:element name="oad:uod">
			<xsl:attribute name="rdf:about">uod/<xsl:value-of select="$id"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="ead-san:archdesc/ead-san:did/ead-san:unittitle[not(@type)] or ead-san:archdesc/ead-san:did/ead-san:unittitle[@type='principale']">
					<xsl:element name="rdfs:label">
						<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#string</xsl:attribute>
						<xsl:apply-templates select="ead-san:archdesc/ead-san:did/ead-san:unittitle[@type='principale']"/>
						<xsl:apply-templates select="ead-san:archdesc/ead-san:did/ead-san:unittitle[not(@type)]"/>
					</xsl:element>
					<xsl:element name="dc:title">
						<xsl:apply-templates select="ead-san:archdesc/ead-san:did/ead-san:unittitle[@type='principale']"/>
						<xsl:apply-templates select="ead-san:archdesc/ead-san:did/ead-san:unittitle[not(@type)]"/>
					</xsl:element>
					<xsl:element name="oad:title">
						<xsl:apply-templates select="ead-san:archdesc/ead-san:did/ead-san:unittitle[@type='principale']"/>
						<xsl:apply-templates select="ead-san:archdesc/ead-san:did/ead-san:unittitle[not(@type)]"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="dcterms:alternative">
						<xsl:apply-templates select="ead-san:archdesc/ead-san:did/ead-san:unittitle[@type]"/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
	
			
			<xsl:element name="oad:has_level">
				<xsl:attribute name="rdf:resource">levelOfDescription/<xsl:value-of select="ead-san:archdesc/@level"/></xsl:attribute>
			</xsl:element>
			<xsl:if test="ead-san:archdesc/@otherlevel">
				<xsl:element name="oad:has_otherlevel">
					<xsl:value-of select="ead-san:archdesc/@otherlevel"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="ead-san:archdesc/ead-san:processinfo">
				<xsl:for-each select="ead-san:archdesc/ead-san:processinfo">
					<xsl:element name="oad:archivistsNote">
						<xsl:value-of select="text()"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="ead-san:archdesc/ead-san:relatedmaterial/ead-san:archref/text()">
				<xsl:element name="dcterms:isPartOf">
					<xsl:attribute name="rdf:resource">uod/<xsl:value-of select="normalize-space(ead-san:archdesc/ead-san:relatedmaterial/ead-san:archref)"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:element name="dcterms:provenance">
				<xsl:attribute name="rdf:resource"><xsl:for-each select="ancestor::node()[name()='record']"><xsl:value-of select="node()[name()='header']//node()[name()='setSpec']/text()"/></xsl:for-each></xsl:attribute>
				<!--NON E' RESOURCE!!!!-->
			</xsl:element>
			<xsl:if test="ead-san:archdesc/ead-san:did/ead-san:unitid">
				<xsl:element name="oad:referenceCode">
					<xsl:value-of select="normalize-space(ead-san:archdesc/ead-san:did/ead-san:unitid/text())"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="ead-san:archdesc/ead-san:did/ead-san:unitdate">
				<xsl:element name="dc:date">
					<xsl:value-of select="normalize-space(ead-san:archdesc/ead-san:did/ead-san:unitdate/text())"/>
				</xsl:element>
				<xsl:element name="oad:date">
					<xsl:value-of select="normalize-space(ead-san:archdesc/ead-san:did/ead-san:unitdate/text())"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="ead-san:archdesc/ead-san:did/ead-san:unitdate/@normal">
				<xsl:element name="dcterms:temporal">
					<xsl:value-of select="substring(ead-san:archdesc/ead-san:did/ead-san:unitdate/@normal,1,4)"/>-<xsl:value-of select="substring(ead-san:archdesc/ead-san:did/ead-san:unitdate/@normal,5,2)"/>-<xsl:value-of select="substring(ead-san:archdesc/ead-san:did/ead-san:unitdate/@normal,7,2)"/>/<xsl:value-of select="substring(ead-san:archdesc/ead-san:did/ead-san:unitdate/@normal,10,4)"/>-<xsl:value-of select="substring(ead-san:archdesc/ead-san:did/ead-san:unitdate/@normal,14,2)"/>-<xsl:value-of select="substring(ead-san:archdesc/ead-san:did/ead-san:unitdate/@normal,16,2)"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="ead-san:archdesc/ead-san:did/ead-san:physdesc/ead-san:extent">
				<xsl:for-each select="ead-san:archdesc/ead-san:did/ead-san:physdesc/ead-san:extent">
					<xsl:element name="oad:extentAndMedium">
						<xsl:value-of select="normalize-space(text())"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="ead-san:archdesc/ead-san:did/physdesc[not(@label)]">
				<xsl:for-each select="ead-san:archdesc/ead-san:did/physdesc[not(@label)]">
					<xsl:element name="oad:extentAndMedium">
						<xsl:value-of select="normalize-space(extent/text())"/>&#160;<xsl:value-of select="normalize-space(genreform/text())"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="ead-san:archdesc/ead-san:did/ead-san:abstract">
				<xsl:element name="oad:scopeAndContent">
					<xsl:value-of select="normalize-space(ead-san:archdesc/ead-san:did/ead-san:abstract/text())"/>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="ead-san:archdesc/ead-san:otherfindaid">
				<xsl:element name="oad:has_findingAid">
					<xsl:attribute name="rdf:resource">findingAid/<xsl:value-of select="ead-san:extref"/></xsl:attribute>
				</xsl:element>
			</xsl:for-each>
			<xsl:element name="oad:languageScriptsOfMaterials">
				<xsl:attribute name="rdf:resource">http://id.loc.gov/vocabulary/iso639-1/it</xsl:attribute>
			</xsl:element>
			<xsl:element name="dcterms:isReferencedBy">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="ead-san:archdesc/ead-san:did/ead-san:unitid/@identifier"/></xsl:attribute>
			</xsl:element>
			<xsl:if test="ead-san:archdesc/ead-san:did/ead-san:origination">
				<xsl:for-each select="ead-san:archdesc/ead-san:did/ead-san:origination">
					<xsl:element name="oad:has_production">
						<xsl:attribute name="rdf:resource">production/<xsl:value-of select="normalize-space(text())"/></xsl:attribute>
						<!-- CHIEDERE A SILVIA PERCHE? NON C'E' MAI IN RELOAD-->
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="ead-san:archdesc/ead-san:did/ead-san:repository">
				<xsl:for-each select="ead-san:archdesc/ead-san:did/ead-san:repository">
					<xsl:element name="oad:has_custody">
						<xsl:attribute name="rdf:resource">custody/<xsl:value-of select="normalize-space(@id)"/></xsl:attribute>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="ead-san:archdesc/ead-san:abstract">
				<xsl:element name="oad:scopeAndContent">
					<xsl:value-of select="normalize-space(ead-san:archdesc/ead-san:abstract/text())"/>
				</xsl:element>
			</xsl:if>
		</xsl:element>
		<xsl:for-each select="ead-san:archdesc/ead-san:otherfindaid">
			<xsl:element name="oad:findingAid">
				<xsl:attribute name="rdf:about">findingAid/<xsl:value-of select="ead-san:extref"/></xsl:attribute>
				<xsl:element name="rdfs:label">Collegamento con lo strumento di ricerca</xsl:element>
			</xsl:element>
		</xsl:for-each>
		<xsl:if test="ead-san:archdesc/ead-san:did/ead-san:origination">
			<xsl:for-each select="ead-san:archdesc/ead-san:did/ead-san:origination">
				<xsl:element name="oad:production">
					<xsl:attribute name="rdf:about">production/<xsl:value-of select="normalize-space(text())"/></xsl:attribute>
					<xsl:element name="rdfs:label">Collegamento con il soggetto produttore</xsl:element>
					<xsl:element name="oad:has_entity">
						<xsl:attribute name="rdf:resource">eac-cpf/<xsl:value-of select="normalize-space(text())"/></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="ead-san:archdesc/ead-san:did/ead-san:repository">
			<xsl:for-each select="ead-san:archdesc/ead-san:did/ead-san:repository">
				<xsl:element name="oad:custody">
					<xsl:attribute name="rdf:about">custody/<xsl:value-of select="normalize-space(@id)"/></xsl:attribute>
					<xsl:element name="rdfs:label">Collegamento con il soggetto conservatore</xsl:element>
					<xsl:element name="oad:has_entity">
						<xsl:attribute name="rdf:resource">eac-cpf/<xsl:value-of select="normalize-space(@id)"/></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="text()">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>
</xsl:stylesheet>
