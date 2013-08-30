<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:bio="http://purl.org/vocab/bio/0.1/" xmlns:eac-cpf="http://archivi.ibc.regione.emilia-romagna.it/ontology/eac-cpf/" xmlns:viaf="http://viaf.org/ontology/1.1/#" xmlns:gn="http://www.geonames.org/ontology#" xmlns:daia="http://purl.org/ontology/daia/" xmlns:oad="http://lod.xdams.org/reload/oad/" xmlns:scons-san="http://san.mibac.it/scons-san/" xmlns:scons="http://san.mibac.it/scons-san/" xmlns:ead-str="http://san.mibac.it/ricerca-san/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ocsa="http://lod.xdams.org/reload/ocsa/" xmlns="http://lod.xdams.org/reload/ocsa/" xml:base="http://lod.xdams.org/reload/ocsa/" xmlns:event="http://purl.org/NET/c4dm/event.owl#" xmlns:gr="http://purl.org/goodrelations/v1" xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:time="http://www.w3.org/2006/time#" xmlns:schema="http://schema.org/" xmlns:vcard="http://www.w3.org/2006/vcard/ns#" xmlns:org="http://www.w3.org/ns/org#">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" cdata-section-elements="p" indent="yes"/>
	<xsl:template match="*">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="/">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:bio="http://purl.org/vocab/bio/0.1/" xmlns:eac-cpf="http://archivi.ibc.regione.emilia-romagna.it/ontology/eac-cpf/" xmlns:viaf="http://viaf.org/ontology/1.1/#" xmlns:gn="http://www.geonames.org/ontology#" xmlns:daia="http://purl.org/ontology/daia/" xmlns:oad="http://lod.xdams.org/reload/oad/" xmlns:scons-san="http://san.mibac.it/scons-san/" xmlns:scons="http://san.mibac.it/scons-san/" xmlns:ead-str="http://san.mibac.it/ricerca-san/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ocsa="http://lod.xdams.org/reload/ocsa/" xmlns="http://lod.xdams.org/reload/ocsa/" xml:base="http://lod.xdams.org/reload/ocsa/" xmlns:event="http://purl.org/NET/c4dm/event.owl#" xmlns:gr="http://purl.org/goodrelations/v1" xmlns:bibo="http://purl.org/ontology/bibo/" xmlns:time="http://www.w3.org/2006/time#" xmlns:schema="http://schema.org/" xmlns:vcard="http://www.w3.org/2006/vcard/ns#" xmlns:org="http://www.w3.org/ns/org#">
			<xsl:for-each select="//scons-san:scons">
				<xsl:call-template name="scriviRDF"/>
				<xsl:call-template name="scrividesc"/>
				<xsl:call-template name="scrivicontrol"/>
				<xsl:call-template name="scriviPlace"/>
				<xsl:call-template name="scriviAdr"/>
				<xsl:call-template name="scriviContact"/>
				<xsl:call-template name="scriviPubl"/>
				<xsl:call-template name="scriviServ"/>
				
				<xsl:for-each select="scons-san:orario">
				<xsl:call-template name="scriviOpeningHours"/>
				</xsl:for-each>
			</xsl:for-each>
		</rdf:RDF>
	</xsl:template>
	<xsl:template name="scriviRDF">
		<xsl:variable name="id">
			<xsl:value-of select="scons-san:identifier/scons-san:recordId"/>
		</xsl:variable>
		<xsl:element name="eac-cpf:corporateBody">
			<xsl:attribute name="rdf:about">eac-cpf/<xsl:value-of select="$id"/></xsl:attribute>
			<xsl:element name="rdfs:label">
				<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#string</xsl:attribute>
				<xsl:value-of select="scons-san:formaautorizzata"/>
			</xsl:element>
			<xsl:element name="dc:title">
				<xsl:value-of select="scons-san:formaautorizzata"/>
			</xsl:element>
			<xsl:element name="dc:coverage">
				<xsl:value-of select="scons-san:localizzazione"/>
				<xsl:if test="scons-san:localizzazione/@cap">, <xsl:value-of select="scons-san:localizzazione/@cap"/>
				</xsl:if>
				<xsl:if test="scons-san:localizzazione/@comune">, <xsl:value-of select="scons-san:localizzazione/@comune"/>
				</xsl:if>
				<xsl:if test="scons-san:localizzazione/@provincia">, <xsl:value-of select="scons-san:localizzazione/@provincia"/>
				</xsl:if>
				<xsl:if test="scons-san:localizzazione/@paese">, <xsl:value-of select="scons-san:localizzazione/@paese"/>
				</xsl:if>
			</xsl:element>
			<xsl:for-each select="scons-san:localizzazione">
				<xsl:variable name="apos">'</xsl:variable>
				<xsl:variable name="spazio" select="' '"/>
				<xsl:variable name="about">
					<xsl:value-of select="translate(translate(translate(text(),'àèéìòù','aeeiou'),$spazio,'_'),$apos,'_')"/>_<xsl:value-of select="translate(translate(translate(@comune,'àèéìòù','aeeiou'),$spazio,'_'),$apos,'_')"/>
				</xsl:variable>
				<xsl:element name="eac-cpf:hasPlace">
					<xsl:attribute name="rdf:resource"><xsl:text>luoghiSAN/</xsl:text><xsl:value-of select="$about"/></xsl:attribute>
				</xsl:element>
			</xsl:for-each>
			<xsl:element name="foaf:name">
				<xsl:value-of select="scons-san:formaautorizzata"/>
			</xsl:element>
			<xsl:element name="dcterms:provenance">
				<xsl:attribute name="rdf:resource"><xsl:for-each select="ancestor::node()[name()='record']"><xsl:value-of select="node()[name()='header']//node()[name()='setSpec']/text()"/></xsl:for-each></xsl:attribute>
				<!--NON E' RESOURCE!!!!-->
			</xsl:element>
			<xsl:element name="dcterms:isReferencedBy">
				<xsl:attribute name="rdf:resource"><xsl:value-of select="scons-san:identifier/@href"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="eac-cpf:control">
				<xsl:attribute name="rdf:resource">control/<xsl:value-of select="scons-san:identifier/scons-san:recordId"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="eac-cpf:description">
				<xsl:attribute name="rdf:resource">description/<xsl:value-of select="scons-san:identifier/scons-san:recordId"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="ocsa:has_contactArea">
				<xsl:attribute name="rdf:resource">contactArea/<xsl:value-of select="$id"/></xsl:attribute>
			</xsl:element>
			<xsl:if test="scons-san:consultazione/text()">
				<xsl:element name="ocsa:has_publicArea">
					<xsl:attribute name="rdf:resource">publicArea/<xsl:value-of select="$id"/>_1</xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:if test="scons-san:altroaccesso/text()">
				<xsl:element name="ocsa:has_publicArea">
					<xsl:attribute name="rdf:resource">publicArea/<xsl:value-of select="$id"/>_2</xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:if test="scons-san:orario/text()">
				<xsl:element name="gr:hasOpeningHoursSpecification">
					<xsl:attribute name="rdf:resource">openinghours/<xsl:value-of select="$id"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:if test="scons-san:servizi/text()">
				<xsl:for-each select="scons-san:servizi">
					<xsl:element name="ocsa:has_service">
						<xsl:attribute name="rdf:resource">service/<xsl:value-of select="$id"/></xsl:attribute>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
		</xsl:element>
	
	
<xsl:element name="org:Organization"><xsl:attribute name="rdf:about">eac-cpf/<xsl:value-of select="$id"/></xsl:attribute></xsl:element>
	</xsl:template>
	<xsl:template name="scrivicontrol">
		<xsl:element name="eac-cpf:controlArea">
			<xsl:attribute name="rdf:about">control/<xsl:value-of select="scons-san:identifier/scons-san:recordId"/></xsl:attribute>
			<xsl:element name="rdfs:label">
				<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#string</xsl:attribute>Area del controllo: <xsl:value-of select="scons-san:formaautorizzata"/>
			</xsl:element>
			<xsl:element name="eac-cpf:recordID">
				<xsl:value-of select="scons-san:identifier/scons-san:recordId"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template name="scrividesc">
		<xsl:element name="eac-cpf:descriptionArea">
			<xsl:attribute name="rdf:about">description/<xsl:value-of select="scons-san:identifier/scons-san:recordId"/></xsl:attribute>
			<xsl:element name="rdfs:label">
				<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#string</xsl:attribute>Area della descrizione: <xsl:value-of select="scons-san:formaautorizzata"/>
			</xsl:element>
			<xsl:for-each select="scons-san:cpfDescription/scons-san:identity/scons-san:nameEntry">
				<xsl:element name="eac-cpf:nameEntry">
					<xsl:attribute name="rdf:parseType">Resource</xsl:attribute>
					<xsl:element name="foaf:name">
						<xsl:value-of select="scons-san:formaautorizzata"/>
					</xsl:element>
					<xsl:if test="eac-san:scons/formeparallele">
						<xsl:element name="foaf:name">
							<xsl:value-of select="eac-san:scons/formeparallele"/>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:for-each>
			<xsl:if test="scons-san:tipologia">
				<xsl:for-each select="scons-san:tipologia">
					<xsl:element name="eac-cpf:descriptiveNote">
						<xsl:value-of select="text()"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="scons-san:descrizione">
				<xsl:element name="eac-cpf:biogHist">
					<xsl:value-of select="scons-san:descrizione"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="scons-san:localizzazione">
				<xsl:for-each select="scons-san:localizzazione">
					<xsl:variable name="apos">'</xsl:variable>
					<xsl:variable name="spazio" select="' '"/>
					<xsl:variable name="about">
						<xsl:value-of select="translate(translate(translate(text(),'àèéìòù','aeeiou'),$spazio,'_'),$apos,'_')"/>_<xsl:value-of select="translate(translate(translate(@comune,'àèéìòù','aeeiou'),$spazio,'_'),$apos,'_')"/>
					</xsl:variable>
					<xsl:element name="eac-cpf:hasPlace">
						<xsl:attribute name="rdf:resource"><xsl:text>luoghiSAN/</xsl:text><xsl:value-of select="$about"/></xsl:attribute>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template name="scriviContact">
		<xsl:element name="ocsa:contactArea">
			<xsl:attribute name="rdf:about">contactArea/<xsl:value-of select="scons-san:identifier/scons-san:recordId"/></xsl:attribute>
			<xsl:if test="scons-san:sitoweb">
				<xsl:element name="foaf:homepage">
					<xsl:attribute name="rdf:resource"><xsl:value-of select="scons-san:sitoweb /@href"/></xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template name="scriviOpeningHours">
		
			<xsl:element name="gr:OpeningHoursSpecification">
				<xsl:attribute name="rdf:about">openinghours/<xsl:value-of select="parent::scons-san:scons/scons-san:identifier/scons-san:recordId"/></xsl:attribute>
				<xsl:element name="rdfs:label">
					<xsl:value-of select="text()"/>
				</xsl:element>
			</xsl:element>
	</xsl:template>
	
	<xsl:template name="scriviServ">
		<xsl:for-each select="servizi">
			<xsl:element name="ocsa:service">
				<xsl:attribute name="rdf:about">service/<xsl:value-of select="scons-san:identifier/scons-san:recordId"/></xsl:attribute>
				<xsl:element name="rdfs:label">
					<xsl:value-of select="text()"/>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="scriviPubl">
		<xsl:if test="scons-san:consultazione/text()">
			<xsl:element name="ocsa:publicArea">
				<xsl:attribute name="rdf:about">publicArea/<xsl:value-of select="scons-san:identifier/scons-san:recordId"/>_1</xsl:attribute>
				<xsl:element name="rdfs:label">
					<xsl:text>Servizio di consultazione al pubblico:</xsl:text>
					<xsl:if test="scons-san:consultazione/text()='true'">si</xsl:if>
					<xsl:if test="scons-san:consultazione/text()='false'">no</xsl:if>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<xsl:if test="scons-san:altroaccesso/text()">
			<xsl:element name="ocsa:publicArea">
				<xsl:attribute name="rdf:about">publicArea/<xsl:value-of select="scons-san:identifier/scons-san:recordId"/>_2</xsl:attribute>
				<xsl:element name="rdfs:label">
					<xsl:value-of select="scons-san:altroaccesso/text()"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="scriviPlace">
		<xsl:param name="place"/>
		<xsl:if test="scons-san:localizzazione">
			<xsl:for-each select="scons-san:localizzazione">
				<xsl:variable name="apos">'</xsl:variable>
				<xsl:variable name="spazio" select="' '"/>
				<xsl:variable name="about">
					<xsl:value-of select="translate(translate(translate(text(),'àèéìòù','aeeiou'),$spazio,'_'),$apos,'_')"/>_<xsl:value-of select="translate(translate(translate(@comune,'àèéìòù','aeeiou'),$spazio,'_'),$apos,'_')"/>
				</xsl:variable>
				<xsl:element name="eac-cpf:place">
					<xsl:attribute name="rdf:about"><xsl:text>luoghiSAN/</xsl:text><xsl:value-of select="$about"/></xsl:attribute>
					<xsl:element name="rdfs:label">
						<xsl:attribute name="xml:lang">it</xsl:attribute>
						<xsl:value-of select="self::scons-san:localizzazione"/>
						<xsl:if test="@cap">, <xsl:value-of select="@cap"/>
						</xsl:if>
						<xsl:if test="@comune">, <xsl:value-of select="@comune"/>
						</xsl:if>
						<xsl:if test="@provincia">, <xsl:value-of select="@provincia"/>
						</xsl:if>
						<xsl:if test="@paese">, <xsl:value-of select="@paese"/>
						</xsl:if>
					</xsl:element>
					<xsl:element name="dc:title">
						<xsl:attribute name="xml:lang">it</xsl:attribute>
						<xsl:value-of select="self::scons-san:localizzazione"/>
						<xsl:if test="@cap">, <xsl:value-of select="@cap"/>
						</xsl:if>
						<xsl:if test="@comune">, <xsl:value-of select="@comune"/>
						</xsl:if>
						<xsl:if test="@provincia">, <xsl:value-of select="@provincia"/>
						</xsl:if>
						<xsl:if test="@paese">, <xsl:value-of select="@paese"/>
						</xsl:if>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="scriviAdr">
		<xsl:param name="adr"/>
		<xsl:for-each select="scons-san:localizzazione">
			<xsl:variable name="apos">'</xsl:variable>
			<xsl:variable name="spazio" select="' '"/>
			<xsl:variable name="about">
				<xsl:value-of select="translate(translate(translate(text(),'àèéìòù','aeeiou'),$spazio,'_'),$apos,'_')"/>_<xsl:value-of select="translate(translate(translate(@comune,'àèéìòù','aeeiou'),$spazio,'_'),$apos,'_')"/>
			</xsl:variable>
			<xsl:element name="vcard:Address">
				<xsl:element name="rdfs:label">Indirizzo</xsl:element>
				<xsl:if test="text()">
					<xsl:element name="vcard:streetAddress">
						<xsl:value-of select="text()"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="@paese">
					<xsl:element name="vcard:country-name">
						<xsl:value-of select="@paese"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="@provincia">
					<xsl:element name="gn:parentADM1">
						<xsl:value-of select="@provincia"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="@comune">
					<xsl:element name="gn:name">
						<xsl:value-of select="@comune"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="@cap">
					<xsl:element name="gn:postalCode">
						<xsl:value-of select="@cap"/>
					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
