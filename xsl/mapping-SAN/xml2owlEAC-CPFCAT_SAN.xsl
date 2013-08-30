<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:bio="http://purl.org/vocab/bio/0.1/" xmlns="http://lod.xdams.org/reload/oad/" xml:base="http://lod.xdams.org/reload/oad/" xmlns:eac-cpf="http://archivi.ibc.regione.emilia-romagna.it/ontology/eac-cpf/" xmlns:viaf="http://viaf.org/ontology/1.1/#" xmlns:gn="http://www.geonames.org/ontology#" xmlns:daia="http://purl.org/ontology/daia/" xmlns:oad="http://lod.xdams.org/reload/oad/" xmlns:eac-san="http://san.mibac.it/eac-san/" xmlns:scons="http://san.mibac.it/scons-san/" xmlns:ead-str="http://san.mibac.it/ricerca-san/" xmlns:xlink="http://www.w3.org/1999/xlink">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" cdata-section-elements="p" indent="yes"/>
	<xsl:template match="*">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="/">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:bio="http://purl.org/vocab/bio/0.1/" xmlns="http://lod.xdams.org/reload/oad/" xml:base="http://lod.xdams.org/reload/oad/" xmlns:eac-cpf="http://archivi.ibc.regione.emilia-romagna.it/ontology/eac-cpf/" xmlns:viaf="http://viaf.org/ontology/1.1/#" xmlns:gn="http://www.geonames.org/ontology#" xmlns:daia="http://purl.org/ontology/daia/" xmlns:oad="http://lod.xdams.org/reload/oad/" xmlns:eac-san="http://san.mibac.it/eac-san/" xmlns:scons="http://san.mibac.it/scons-san/" xmlns:ead-str="http://san.mibac.it/ricerca-san/" xmlns:xlink="http://www.w3.org/1999/xlink">
			<xsl:for-each select="//eac-san:eac-cpf">
				<xsl:variable name="id" select="eac-san:control/eac-san:otherRecordId"/>
				<xsl:call-template name="preliminare"/>
			</xsl:for-each>
		</rdf:RDF>
	</xsl:template>
	<xsl:template name="preliminare">
		<xsl:variable name="id">
			<xsl:value-of select="eac-san:control/eac-san:otherRecordId"/>
		</xsl:variable>
		<xsl:variable name="entityType">
			<xsl:value-of select="eac-san:cpfDescription/eac-san:identity/eac-san:entityType/text()"/>
		</xsl:variable>
		<xsl:if test="$entityType='corporateBody'">
			<xsl:element name="eac-cpf:corporateBody">
				<xsl:call-template name="scriviRDF">
					<xsl:with-param name="id" select="$id"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
		<xsl:if test="$entityType='family'">
			<xsl:element name="eac-cpf:family">
				<xsl:call-template name="scriviRDF">
					<xsl:with-param name="id" select="$id"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
		<xsl:if test="$entityType='person'">
			<xsl:element name="eac-cpf:person">
				<xsl:call-template name="scriviRDF">
					<xsl:with-param name="id" select="$id"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
		<xsl:if test="eac-san:control">
			<xsl:element name="eac-cpf:controlArea">
				<xsl:call-template name="scrivicontrol">
					<xsl:with-param name="id" select="$id"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
		<xsl:if test="eac-san:cpfDescription">
			<xsl:element name="eac-cpf:descriptionArea">
				<xsl:call-template name="scrividesc">
					<xsl:with-param name="id" select="$id"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
		<xsl:if test="eac-san:cpfDescription/eac-san:relations">
			<xsl:call-template name="scrivirel">
				<xsl:with-param name="id" select="$id"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="eac-san:cpfDescription/eac-san:description/eac-san:placeDates/eac-san:placeDate/eac-san:place">
			<xsl:call-template name="scriviPlace">
				<xsl:with-param name="place" select="$id"/>
			</xsl:call-template>
		</xsl:if>
		
	</xsl:template>
	<xsl:template name="scriviRDF">
		<xsl:param name="id"/>
		<xsl:attribute name="rdf:about">eac-cpf/<xsl:value-of select="$id"/></xsl:attribute>
		<xsl:element name="rdfs:label">
			<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#string</xsl:attribute>
			<xsl:choose>
				<xsl:when test="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel">
					<xsl:value-of select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel/eac-san:nameEntry[@langCode='ita']/eac-san:part[not(@localType)]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntry/eac-san:part[not(@localType)]"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="eac-san:cpfDescription/eac-san:description/eac-san:existDates">,&#160;<xsl:value-of select="eac-san:cpfDescription/eac-san:description/eac-san:existDates/eac-san:dateSet/eac-san:date/text()"/>
			</xsl:if>
		</xsl:element>
		<xsl:element name="dc:title">
			<xsl:choose>
				<xsl:when test="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel">
					<xsl:value-of select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel/eac-san:nameEntry[@langCode='ita']/eac-san:part[not(@localType)]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntry/eac-san:part[not(@localType)]"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="eac-san:cpfDescription/eac-san:description/eac-san:existDates">,&#160;<xsl:value-of select="eac-san:cpfDescription/eac-san:description/eac-san:existDates/eac-san:dateSet/eac-san:date/text()"/>
			</xsl:if>
		</xsl:element>
		<xsl:element name="dc:date">
			<xsl:apply-templates select="eac-san:cpfDescription/eac-san:description/eac-san:existDates/eac-san:dateSet/eac-san:date/text()"/>
		</xsl:element>
		<xsl:element name="dcterms:temporal">
			<xsl:value-of select="substring(eac-san:cpfDescription/eac-san:description/eac-san:existDates/eac-san:dateSet/eac-san:date/@standardDate,1,4)"/>-<xsl:value-of select="substring(eac-san:cpfDescription/eac-san:description/eac-san:existDates/eac-san:dateSet/eac-san:date/@standardDate,5,2)"/>-<xsl:value-of select="substring(eac-san:cpfDescription/eac-san:description/eac-san:existDates/eac-san:dateSet/eac-san:date/@standardDate,7,2)"/>/<xsl:value-of select="substring(eac-san:cpfDescription/eac-san:description/eac-san:existDates/eac-san:dateSet/eac-san:date/@standardDate,10,4)"/>-<xsl:value-of select="substring(eac-san:cpfDescription/eac-san:description/eac-san:existDates/eac-san:dateSet/eac-san:date/@standardDate,14,2)"/>-<xsl:value-of select="substring(eac-san:cpfDescription/eac-san:description/eac-san:existDates/eac-san:dateSet/eac-san:date/@standardDate,16,2)"/>
		</xsl:element>
		<xsl:element name="dc:coverage">
			<xsl:value-of select="eac-san:cpfDescription/eac-san:description/eac-san:placeDates/eac-san:placeDate/eac-san:place"/>
		</xsl:element>
		<xsl:choose>
			<xsl:when test="eac-san:cpfDescription/eac-san:identity/eac-san:entityType[text()='corporateBody']">
				<xsl:element name="foaf:name">
					<xsl:choose>
						<xsl:when test="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel">
							<xsl:value-of select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel/eac-san:nameEntry[@langCode='ita']/eac-san:part[not(@localType)]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntry/eac-san:part[not(@localType)]"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:when>
			<xsl:when test="eac-san:cpfDescription/eac-san:identity/eac-san:entityType[text()='person']">
				<xsl:element name="foaf:firstName">
					<xsl:choose>
						<xsl:when test="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel">
							<xsl:value-of select="substring-before(eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel/eac-san:nameEntry[@langCode='ita']/eac-san:part[not(@localType)]/text(),' ')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before(eac-san:cpfDescription/eac-san:identity/eac-san:nameEntry/eac-san:part[not(@localType)]/text(),' ')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:element name="foaf:surname">
					<xsl:choose>
						<xsl:when test="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel">
							<xsl:value-of select="substring-after(eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel/eac-san:nameEntry[@langCode='ita']/eac-san:part[not(@localType)]/text(),' ')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-after(eac-san:cpfDescription/eac-san:identity/eac-san:nameEntry/eac-san:part[not(@localType)]/text(),' ')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:when>
			<xsl:when test="eac-san:cpfDescription/eac-san:identity[entityType[text()='family']]">
				<xsl:element name="foaf:name">
					<xsl:choose>
						<xsl:when test="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel">
							<xsl:value-of select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel/eac-san:nameEntry[@langCode='ita']/eac-san:part[not(@localType)]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntry/eac-san:part[not(@localType)]"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
		<xsl:element name="dcterms:provenance">
			<xsl:attribute name="rdf:resource"><xsl:for-each select="ancestor::node()[name()='record']"><xsl:value-of select="node()[name()='header']//node()[name()='setSpec']/text()"/></xsl:for-each></xsl:attribute>
			<!--NON E' RESOURCE!!!!-->
		</xsl:element>
		<xsl:element name="dcterms:isReferencedBy">
			<xsl:attribute name="rdf:resource"><xsl:value-of select="eac-san:control/eac-san:sources/eac-san:source/@xlink:href"/></xsl:attribute>
		</xsl:element>
		<xsl:if test="eac-san:control">
			<xsl:element name="eac-cpf:control">
				<xsl:attribute name="rdf:resource">control/<xsl:value-of select="eac-san:control/eac-san:otherRecordId"/></xsl:attribute>
			</xsl:element>
		</xsl:if>
		<xsl:if test="eac-san:cpfDescription">
			<xsl:element name="eac-cpf:description">
				<xsl:attribute name="rdf:resource">description/<xsl:value-of select="eac-san:control/eac-san:otherRecordId/text()"/></xsl:attribute>
			</xsl:element>
		</xsl:if>
		<xsl:if test="eac-san:cpfDescription/eac-san:relations">
			<xsl:for-each select="eac-san:cpfDescription/eac-san:relations/eac-san:cpfRelation">
				<xsl:element name="eac-cpf:cpfRelation">
					<xsl:attribute name="rdf:resource">relationCPF/<xsl:value-of select="eac-san:relationEntry"/></xsl:attribute>
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="eac-san:cpfDescription/eac-san:relations/eac-san:resourceRelation[@resourceRelationType='creatorOf']">
				<xsl:element name="eac-cpf:resourceRelation">
					<xsl:attribute name="rdf:resource">relationResource/<xsl:value-of select="eac-san:relationEntry"/></xsl:attribute>
				</xsl:element>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="scrivicontrol">
		<xsl:attribute name="rdf:about">control/<xsl:value-of select="eac-san:control/eac-san:otherRecordId/text()"/></xsl:attribute>
		<xsl:element name="rdfs:label">
			<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#string</xsl:attribute>Area del controllo:	<xsl:choose>
				<xsl:when test="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel">
					<xsl:value-of select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel/eac-san:nameEntry[@langCode='ita']/eac-san:part[not(@localType)]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntry/eac-san:part[not(@localType)]"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:element name="eac-cpf:recordID">
			<xsl:value-of select="eac-san:control/eac-san:otherRecordId"/>
		</xsl:element>
		<xsl:if test="eac-san:control/eac-san:maintenanceStatus">
			<xsl:element name="eac-cpf:maintenanceStatus">
				<xsl:value-of select="eac-san:control/eac-san:maintenanceStatus"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="eac-san:control/eac-san:languageDeclaration">
			<xsl:element name="eac-cpf:languageDeclaration">http://id.loc.gov/vocabulary/iso639-1/it</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="scrividesc">
		<xsl:attribute name="rdf:about">description/<xsl:value-of select="eac-san:control/eac-san:otherRecordId/text()"/></xsl:attribute>
		<xsl:element name="rdfs:label">
			<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#string</xsl:attribute>Area della descrizione: 	<xsl:choose>
				<xsl:when test="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel">
					<xsl:value-of select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel/eac-san:nameEntry[@langCode='ita']/eac-san:part[not(@localType)]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntry/eac-san:part[not(@localType)]"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:choose>
			<xsl:when test="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel">
				<xsl:for-each select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntryParallel">
					<xsl:element name="eac-cpf:nameEntry">
						<xsl:attribute name="rdf:parseType">Resource</xsl:attribute>
						<xsl:if test="../eac-san:entityType/text()='corporateBody'">
							<xsl:element name="foaf:name">
								<xsl:attribute name="xml:lang"><xsl:value-of select="eac-san:nameEntry/@langCode"/></xsl:attribute>
								<xsl:value-of select="eac-san:nameEntry/eac-san:part[not(@localType)]/text()"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="../eac-san:entityType/text()='person'">
							<xsl:element name="foaf:givenName">
								<xsl:attribute name="xml:lang"><xsl:value-of select="eac-san:nameEntry/@langCode"/></xsl:attribute>
								<xsl:value-of select="eac-san:nameEntry/eac-san:part[not(@localType)]/text()"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="eac-san:cpfDescription/eac-san:identity/eac-san:nameEntry">
					<xsl:element name="eac-cpf:nameEntry">
						<xsl:attribute name="rdf:parseType">Resource</xsl:attribute>
						<xsl:element name="authorizedForm">
							<xsl:for-each select="ancestor::node()[name()='record']">
								<xsl:value-of select="node()[name()='header']//node()[name()='setSpec']/text()"/>
							</xsl:for-each>
						</xsl:element>
						<xsl:if test="../eac-san:entityType/text()='corporateBody'">
							<xsl:element name="foaf:name">
								<xsl:value-of select="eac-san:part[not(@localType)]/text()"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="../eac-san:entityType/text()='person'">
							<xsl:element name="foaf:givenName">
								<xsl:value-of select="eac-san:part[not(@localType)]/text()"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="eac-san:cpfDescription/eac-san:description/eac-san:descriptiveEntries/eac-san:descriptiveEntry">
			<xsl:for-each select="eac-san:cpfDescription/eac-san:description/eac-san:descriptiveEntries/eac-san:descriptiveEntry">
				<xsl:element name="eac-cpf:descriptiveNote">
					<xsl:value-of select="eac-san:term"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="eac-san:cpfDescription/eac-san:description/eac-san:existDates/eac-san:dateSet/eac-san:date/text()">
			<xsl:element name="eac-cpf:existDates">
				<xsl:value-of select="eac-san:cpfDescription/eac-san:description/eac-san:existDates/eac-san:dateSet/eac-san:date"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="eac-san:cpfDescription/eac-san:description/eac-san:placeDates/eac-san:placeDate">
			<xsl:for-each select="eac-san:cpfDescription/eac-san:description/eac-san:placeDates/eac-san:placeDate">
				<xsl:variable name="apos">'</xsl:variable>
				<xsl:variable name="spazio" select="' '"/>
				<xsl:variable name="about">
					<xsl:value-of select="translate(translate(translate(eac-san:place,'àèéìòù','aeeiou'),$spazio,'_'),$apos,'_')"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="contains(eac-san:descriptiveNote/text(),'nascita')">
						<xsl:element name="bio:Birth">
							<xsl:attribute name="rdf:parseType">Resource</xsl:attribute>
							<xsl:element name="bio:date">
								<xsl:value-of select="normalize-space(substring-before(../../eac-san:existDates/eac-san:dateSet/eac-san:date,'-'))"/>
							</xsl:element>
							<xsl:element name="eac-cpf:hasPlace">
								<xsl:attribute name="rdf:resource"><xsl:text>luoghiSAN/</xsl:text><xsl:value-of select="$about"/>_<xsl:value-of select="count(ancestor::node())"/>_<xsl:value-of select="count(preceding::node())"/></xsl:attribute>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(eac-san:descriptiveNote/text(),'morte')">
						<xsl:element name="bio:Death">
							<xsl:attribute name="rdf:parseType">Resource</xsl:attribute>
							<xsl:element name="bio:date">
								<xsl:value-of select="normalize-space(substring-after(../../eac-san:existDates/eac-san:dateSet/eac-san:date,'-'))"/>
							</xsl:element>
							<xsl:element name="eac-cpf:hasPlace">
								<xsl:attribute name="rdf:resource"><xsl:text>luoghiSAN/</xsl:text><xsl:value-of select="$about"/>_<xsl:value-of select="count(ancestor::node())"/>_<xsl:value-of select="count(preceding::node())"/></xsl:attribute>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="not(contains(eac-san:descriptiveNote/text(),'morte')) and not(contains(../eac-san:descriptiveNote/text(),'nascita'))">
						<xsl:element name="eac-cpf:hasPlace">
							<xsl:attribute name="rdf:resource"><xsl:text>luoghiSAN/</xsl:text><xsl:value-of select="$about"/>_<xsl:value-of select="count(ancestor::node())"/>_<xsl:value-of select="count(preceding::node())"/></xsl:attribute>
							
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
			<xsl:if test="eac-san:cpfDescription/eac-san:description/eac-san:biogHist">
				<xsl:element name="eac-cpf:biogHist">
					<xsl:value-of select="eac-san:cpfDescription/eac-san:description/eac-san:biogHist"/>
				</xsl:element>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="scrivirel">
		<xsl:for-each select="eac-san:cpfDescription/eac-san:relations/eac-san:cpfRelation">
			<xsl:element name="eac-cpf:relation">
				<xsl:attribute name="rdf:about">relationCPF/<xsl:value-of select="eac-san:relationEntry"/></xsl:attribute>
				<xsl:element name="rdfs:label">
					<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#string</xsl:attribute>
					<xsl:value-of select="@localType"/>
				</xsl:element>
				<xsl:element name="dcterms:relation">
					<xsl:attribute name="rdf:resource">eac-cpf/<xsl:value-of select="eac-san:relationEntry"/></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
		<xsl:for-each select="eac-san:cpfDescription/eac-san:relations/eac-san:resourceRelation">
			<xsl:element name="eac-cpf:relation">
				<xsl:attribute name="rdf:about">relationResource/<xsl:value-of select="eac-san:relationEntry"/></xsl:attribute>
				<xsl:element name="rdfs:label">
					<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#string</xsl:attribute>
					<xsl:value-of select="@resourceRelationType"/>
				</xsl:element>
				<xsl:element name="dcterms:relation">
					<xsl:attribute name="rdf:resource">uod/<xsl:value-of select="eac-san:relationEntry"/></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="scriviPlace">
		<xsl:param name="place"/>
		<xsl:if test="eac-san:cpfDescription/eac-san:description/eac-san:placeDates">
			<xsl:for-each select="eac-san:cpfDescription/eac-san:description/eac-san:placeDates/eac-san:placeDate">
				<xsl:variable name="apos">'</xsl:variable>
				<xsl:variable name="spazio" select="' '"/>
				<xsl:variable name="about">
					<xsl:value-of select="translate(translate(translate(eac-san:place/text(),'àèéìòù','aeeiou'),$spazio,'_'),$apos,'_')"/>
				</xsl:variable>
				<xsl:element name="eac-cpf:place">
					<xsl:attribute name="rdf:about"><xsl:text>luoghiSAN/</xsl:text><xsl:value-of select="$about"/>_<xsl:value-of select="count(ancestor::node())"/>_<xsl:value-of select="count(preceding::node())"/></xsl:attribute>
					<xsl:element name="rdfs:label"><xsl:value-of select="eac-san:place/text()"/></xsl:element>
					<xsl:element name="dc:title"><xsl:value-of select="eac-san:place/text()"/></xsl:element>
					<xsl:element name="eac-cpf:placeRole">
								<xsl:value-of select="eac-san:descriptiveNote/text()"/>
							</xsl:element>
				</xsl:element>
				<xsl:element name="skos:Concept">
					<xsl:attribute name="rdf:about"><xsl:text>luoghiSAN/</xsl:text><xsl:value-of select="$about"/>_<xsl:value-of select="count(ancestor::node())"/>_<xsl:value-of select="count(preceding::node())"/></xsl:attribute>
					<xsl:element name="rdfs:label">
						<xsl:attribute name="xml:lang">it</xsl:attribute>
						<xsl:value-of select="eac-san:place/text()"/>
					</xsl:element>
					<xsl:element name="skos:prefLabel">
						<xsl:attribute name="xml:lang">it</xsl:attribute>
						<xsl:value-of select="eac-san:place/text()"/>
					</xsl:element>
					<xsl:element name="dc:title">
						<xsl:attribute name="xml:lang">it</xsl:attribute>
						<xsl:value-of select="eac-san:place/text()"/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
