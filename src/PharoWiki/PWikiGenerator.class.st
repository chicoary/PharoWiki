Class {
	#name : 'PWikiGenerator',
	#superclass : 'Object',
	#instVars : [
		'outputDir',
		'writer',
		'converter',
		'extractor',
		'implementorsCache',
		'sendersCache',
		'generationRecord'
	],
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'instance creation' }
PWikiGenerator class >> outputDir: aDirectory [
	^ self new initializeWith: aDirectory
]

{ #category : 'scripts' }
PWikiGenerator class >> cacheBenchmark [
	<script>
	| sizes selectedPackages string |

	"Tamanhos de cache a comparar"
	sizes := #(50 100 250 500 1000 2000 5000).

	"Selecionar 5 pacotes aleatórios com >= 10 classes"
	selectedPackages := (PackageOrganizer default packages
	    select: [ :pkg | pkg classes size >= 10 ])
	    asSortedCollection: [ :a :b | a name < b name ].
	selectedPackages := selectedPackages asArray shuffled first: 5.

	Transcript
	    show: '=== PharoWiki — Cache Benchmark ==='; cr;
	    show: 'Pacotes: ', (selectedPackages collect: [ :p | p name ]) asString; cr;
	    show: 'Total de classes: ',
	        (selectedPackages inject: 0 into: [ :sum :p | sum + p classes size ]) asString; cr;
	    cr.

	"Cabeçalho da tabela"
	Transcript
	    show: ('MaxWeight' padRightTo: 12);
	    show: ('Hits' padRightTo: 10);
	    show: ('Misses' padRightTo: 10);
	    show: ('HitRatio%' padRightTo: 12);
	    show: ('CacheSize' padRightTo: 12);
	    cr;
	    show: (String new: 56 withAll: $-); cr.

	"Rodar ensaio para cada tamanho"
	[ :outerJob |
	    outerJob title: 'Cache Benchmark'.
	    outerJob min: 0; max: sizes size.

	    sizes doWithIndex: [ :maxWeight :sizeIndex |
	        | cache |
	        outerJob current: sizeIndex.
	        outerJob title: 'Cache Benchmark — MaxWeight: ', maxWeight asString.

	        cache := LRUCache new.
	        cache maximumWeight: maxWeight.

	        [ :innerJob |
	            innerJob title: 'MaxWeight ', maxWeight asString.
	            innerJob min: 0; max: selectedPackages size.

	            selectedPackages doWithIndex: [ :pkg :pkgIndex |
	                innerJob current: pkgIndex.
	                innerJob title: pkg name.

	                pkg classes do: [ :cls |
	                    cls methods do: [ :method |
	                        cache
	                            at: method selector
	                            ifAbsentPut: [
	                                SystemNavigation default allImplementorsOf: method selector ] ] ] ] ]
	        asJob run.

	        string := (cache hitRatio * 100.0) rounded asString, ' %'.

	        Transcript
	            show: (maxWeight asString padRightTo: 12);
	            show: (cache hits asString padRightTo: 10);
	            show: (cache misses asString padRightTo: 10);
	            show: (string padRightTo: 12);
	            show: (cache size asString padRightTo: 12);
	            cr ] ]
	asJob run.

	Transcript show: '=== Fim ==='; cr
]

{ #category : 'scripts' }
PWikiGenerator class >> generateImage [
	<script>
	| gen outputDir |
	outputDir := '/Users/chicoary/Documents/Obsidian Vaults/PharoWiki vault/wiki/' asFileReference.
	gen := PWikiGenerator outputDir: outputDir.
	gen generateForImage.
	Transcript crShow: 'Wiki is ready!'.
	self inform: 'Ok'
]

{ #category : 'scripts' }
PWikiGenerator class >> generatePackagePharoWiki [
	<script>
	| gen outputDir |
	'Começando...' crTrace.
	outputDir := '/Users/chicoary/Documents/Obsidian Vaults/PharoWiki vault/wiki' asFileReference.
	gen := PWikiGenerator outputDir: outputDir.
	gen generateForPackageNamed: 'PharoWiki'.
	'Pronto!' crTrace.
	self inform: 'Ok'
]

{ #category : 'scripts' }
PWikiGenerator class >> generatePoint [
	<script>
	| gen outputDir |
	DebugTracer default clear.
	DebugTracer default traces inspect.
	outputDir := '/Users/chicoary/Documents/Obsidian Vaults/PharoWiki vault/wiki/' asFileReference.
	gen := PWikiGenerator outputDir: outputDir.
	gen generateForClass: Point.
	self inform: 'Ok'
]

{ #category : 'scripts' }
PWikiGenerator class >> reload [
	<script>
	| pharoWikiPath |
	pharoWikiPath := '/Users/chicoary/Documents/Obsidian Vaults/CODE Vault/1 - Projetos/1 - In progress/PharoWiki/Anexos/PharoWiki'.

	Transcript
	    clear;
	    show: '[', DateAndTime now printString, '] Recarregando PharoWiki...'; cr.

	Metacello new
	    baseline: 'PharoWiki';
	    repository: 'tonel://', pharoWikiPath, '/src';
	    load.
	self inform: 'Ok'
]

{ #category : 'scripts' }
PWikiGenerator class >> runAllTests [
	<script>
	| result suite |

	Transcript
	    clear;
	    cr;
	    show: '[', DateAndTime now printString, '] Rodando testes...'; cr.

	suite := TestSuite new.
	suite addTest: PWikiClassPageTest suite.
	suite addTest: PWikiMethodSectionTest suite.
	suite addTest: PWikiMicrodownConverterTest suite.
	suite addTest: PWikiAnchorGeneratorTest suite.
	suite addTest: PWikiDependencyExtractorTest suite.
	suite addTest: PWikiFileWriterTest suite.
	suite addTest: PWikiGeneratorTest suite.
	suite addTest: PWikiImplementorsPageTest suite.
	suite addTest: PWikiSendersPageTest suite.
	suite addTest: PWikiProgressEstimatorTest suite.

	[ :job |
	    job title: 'Rodando testes PharoWiki'; min: 0; max: 1.
	    result := suite run.
	    job currentValue: 1 ] asJob run.

	Transcript
	    show: result passed size printString, ' passaram'; cr;
	    show: result failures size printString, ' falharam'; cr;
	    show: result errors size printString, ' erros'; cr;
	    show: result skipped size printString, ' pulados'; cr.
	self inform: 'Ok'
]

{ #category : 'scripts' }
PWikiGenerator class >> saveClassTonel [
	<script>
	| class className string fileReference |
	class := String.
	className := class name.
	Transcript crShow: 'Exportando a classe: ', className, '...'.
	Transcript crShow: '[', DateAndTime now printString, ']'; cr.
	string := TonelWriter sourceCodeOf: class.
	Transcript crShow: 'Código fonte (truncate):'; cr.
	Transcript crShow: (string truncateTo: 5000); cr.
	fileReference := ('{1}.class.st' format: { className }) asFileReference.
	fileReference writeStreamDo: [ :stream | stream nextPutAll: string ].
	Transcript crShow: 'Exportação concluída!'.
	self inform: 'Ok'
]

{ #category : 'scripts' }
PWikiGenerator class >> sourceCodeOf [
	<script>
	Transcript
	    clear;
	    crShow: (TonelWriter sourceCodeOf: PWikiGenerator)
]

{ #category : 'generating - private' }
PWikiGenerator >> generateClasses: anArrayOfClasses [
	"Group anArrayOfClasses by package and process each group under a package-level Job.
	 Progress % and time remaining appear in the package-level job title."
	| byPackage counter total estimator |
	total := anArrayOfClasses size.
	estimator := PWikiProgressEstimator start.
	byPackage := anArrayOfClasses
		inject: Dictionary new
		into: [ :dict :aClass |
			| pkgName col |
			pkgName := aClass package name.
			col := dict at: pkgName ifAbsent: [ OrderedCollection new ].
			col add: aClass.
			dict at: pkgName put: col.
			dict ].
	counter := 0.
	byPackage keysAndValuesDo: [ :pkgName :classes |
		[ :pkgJob |
			pkgJob title: 'Package: ', pkgName.
			classes doWithIndex: [ :aClass :i |
				pkgJob currentValue: i.
				counter := counter + 1.
				pkgJob title: ('{1} — {2} / {3} ({4}%){5}' format: {
					pkgName.
					counter.
					total.
					counter * 100 // total.
					estimator remainingStringFor: counter of: total }).
				[ :classJob |
					classJob title: aClass name.
					(generationRecord isClassUpToDate: aClass)
						ifTrue: [
							classJob title: '↷ ', aClass name, ' — skipped' ]
						ifFalse: [
							self generateForClass: aClass classJob: classJob.
							generationRecord recordDigestForClass: aClass ]
				] asJob min: 0; max: (aClass protocols size max: 1); run ]
		] asJob min: 0; max: classes size; run ]
]

{ #category : 'generating - public' }
PWikiGenerator >> classesToGenerate [
	"Subclasses must override to return the classes to generate."
	^ self subclassResponsibility
]

{ #category : 'generating - public' }
PWikiGenerator >> generateForClass: aClass [
	"Generate a wiki page for aClass without job feedback."
	| page content |
	page := PWikiClassPage forClass: aClass.
	content := self renderPage: page.
	writer
		writeClass: page className
		package: page packageName
		content: content
]

{ #category : 'generating - private' }
PWikiGenerator >> generateForClass: aClass classJob: classJob [
	"Generate one class page, advancing classJob per protocol rendered."
	| page content |
	page := PWikiClassPage forClass: aClass.
	content := self renderPage: page classJob: classJob.
	writer
		writeClass: page className
		package: page packageName
		content: content
]

{ #category : 'generating - public' }
PWikiGenerator >> generateForImage [
	"Generate wiki pages for the classes returned by classesToGenerate.
	 Shows two nested progress bars:
	   - outer : fixed title anchor
	   - inner  : current class with overall % and time remaining"
	| allClasses startTime record |
	self prepareImplementorsDir.
	self prepareSendersDir.
	allClasses := self classesToGenerate.
	startTime := DateAndTime now.
	[ :outerJob |
		outerJob title: 'PharoWiki — generating full image'.
		self generateClasses: allClasses
	] asJob run.
	record := PWikiGenerationRecord
		outputDir: outputDir
		classCount: allClasses size
		startTime: startTime.
	record classDigests: generationRecord classDigests.
	record writeFiles
]

{ #category : 'generating - public' }
PWikiGenerator >> generateForPackage: aPackageName [
	"Generate wiki pages for all classes in the given package, without job feedback."
	| package |
	package := PackageOrganizer default
		packageNamed: aPackageName
		ifAbsent: [ ^ self ].
	package classes do: [ :aClass |
		self generateForClass: aClass ]
]

{ #category : 'generating - public' }
PWikiGenerator >> generateForPackageNamed: aPackageName [
	"Generate wiki pages for all classes in one package, with job feedback."
	| package classes record startTime |
	self prepareImplementorsDir.
	self prepareSendersDir.
	package := PackageOrganizer default
		packageNamed: aPackageName
		ifAbsent: [ ^ self ].
	classes := package classes asArray.
	startTime := DateAndTime now.
	[ :outerJob |
		outerJob title: 'PharoWiki — package ', aPackageName.
		self generateClasses: classes
	] asJob run.
	record := PWikiGenerationRecord
		outputDir: outputDir
		classCount: classes size
		startTime: startTime.
	record classDigests: generationRecord classDigests.
	record writeFiles
]

{ #category : 'generating - private' }
PWikiGenerator >> generateImplementorsPageFor: aSelector [
	"Generate the implementors note for aSelector.
	 Skips if the file already exists — handled by PWikiFileWriter."
	| implementors page |
	implementors := self implementorsOf: aSelector.
	page := PWikiImplementorsPage
		selector: aSelector
		implementors: implementors.
	writer writeSelectorPage: page
]

{ #category : 'generating - private' }
PWikiGenerator >> generateSendersPageFor: aSelector [
	"Generate the senders note for aSelector.
	 Skips if the file already exists — handled by PWikiFileWriter."
	| senders page |
	senders := self sendersOf: aSelector.
	page := PWikiSendersPage
		selector: aSelector
		senders: senders.
	writer writeSenderPage: page
]

{ #category : 'accessing' }
PWikiGenerator >> implementorsCache [
	^ implementorsCache
]

{ #category : 'accessing' }
PWikiGenerator >> sendersCache [
	^ sendersCache
]

{ #category : 'private' }
PWikiGenerator >> implementorsOf: aSelector [
	"Return the implementors of aSelector, consulting the cache first."
	^ implementorsCache
		at: aSelector
		ifAbsentPut: [ extractor implementorsOf: aSelector ]
]

{ #category : 'private' }
PWikiGenerator >> sendersOf: aSelector [
	"Return the senders of aSelector, consulting the cache first."
	^ sendersCache
		at: aSelector
		ifAbsentPut: [ extractor sendersOf: aSelector ]
]

{ #category : 'initialization' }
PWikiGenerator >> initializeWith: aDirectory [
	outputDir := aDirectory.
	outputDir exists ifFalse: [ outputDir ensureCreateDirectory ].
	writer := PWikiFileWriter outputDir: aDirectory.
	converter := PWikiMicrodownConverter new.
	extractor := PWikiDependencyExtractor new.
	implementorsCache := LRUCache new.
	implementorsCache maximumWeight: 2000.
	sendersCache := LRUCache new.
	sendersCache maximumWeight: 2000.
	generationRecord := PWikiGenerationRecord new.
	generationRecord classDigests: (PWikiGenerationRecord loadFrom: aDirectory)
]

{ #category : 'generating - private' }
PWikiGenerator >> prepareImplementorsDir [
	"Delete and recreate the _implementors directory.
	 Called before bulk generation to ensure no stale files remain."
	| dir |
	dir := outputDir / '_implementors'.
	dir exists ifTrue: [ dir deleteAll ].
	dir createDirectory
]

{ #category : 'generating - private' }
PWikiGenerator >> prepareSendersDir [
	"Delete and recreate the _senders directory.
	 Called before bulk generation to ensure no stale files remain."
	| dir |
	dir := outputDir / '_senders'.
	dir exists ifTrue: [ dir deleteAll ].
	dir createDirectory
]

{ #category : 'rendering' }
PWikiGenerator >> renderPage: aPage [
	"Render a PWikiClassPage as a Markdown string (no job feedback)."
	^ self renderPage: aPage classJob: nil
]

{ #category : 'rendering' }
PWikiGenerator >> renderPage: aPage classJob: classJobOrNil [
	"Render a PWikiClassPage as a Markdown string.
	 If classJobOrNil is not nil, advance it once per protocol rendered."
	| stream protocolIndex |
	stream := WriteStream on: String new.
	protocolIndex := 0.

	stream nextPutAll: '# ', aPage className; cr.
	stream nextPutAll: '**Package:** `', aPage packageName, '`'; cr.
	aPage superclassName ifNotEmpty: [ :s |
		stream nextPutAll: '**Inherits from:** [[', s, ']]'; cr ].
	aPage hasSubclasses ifTrue: [
		stream nextPutAll: '**Subclasses:** '.
		aPage subclassNames
			do: [ :n | stream nextPutAll: '[[', n, ']]' ]
			separatedBy: [ stream nextPutAll: ', ' ].
		stream cr ].
	aPage hasComment ifTrue: [
		stream cr.
		stream nextPutAll: '## Comment'; cr.
		stream nextPutAll: (converter convert: aPage comment); cr ].

	aPage protocolNames do: [ :protocol |
		| methods |
		DebugTracer default add: protocol labeled: #protocol.
		protocolIndex := protocolIndex + 1.
		classJobOrNil ifNotNil: [ classJobOrNil currentValue: protocolIndex ].
		methods := aPage methodsInProtocol: protocol.
		methods ifNotEmpty: [
			stream cr.
			stream nextPutAll: '## ', protocol; cr.
			methods do: [ :method |
				| section |
				section := PWikiMethodSection forMethod: method.
				stream nextPutAll: '### ', section selector; cr.
				section sentMessages ifNotEmpty: [ :msgs |
					stream nextPutAll: '**Sends:** '.
					msgs
						do: [ :sel |
							| fileName |
							fileName := (PWikiSelectorPageBase selectorToFileName: sel), ' implementors'.
							stream nextPutAll: '[[', fileName, '|', sel, ']]'.
							self generateImplementorsPageFor: sel ]
						separatedBy: [ stream nextPutAll: ', ' ].
					stream cr ].
				stream nextPutAll: '[[', (PWikiSelectorPageBase selectorToFileName: section selector), ' senders|Senders]]'; cr.
				self generateSendersPageFor: section selector.
				stream nextPutAll: '```smalltalk'; cr.
				stream nextPutAll: section sourceCode; cr.
				stream nextPutAll: '```'; cr ] ] ].

	aPage classProtocolNames ifNotEmpty: [ :classProtos |
		stream cr.
		stream nextPutAll: '## Class methods'; cr.
		classProtos do: [ :protocol |
			| methods |
			methods := aPage classMethodsInProtocol: protocol.
			methods ifNotEmpty: [
				stream cr.
				stream nextPutAll: '### ', protocol; cr.
				methods do: [ :method |
					| section |
					section := PWikiMethodSection forMethod: method.
					stream nextPutAll: '#### ', section selector; cr.
					section sentMessages ifNotEmpty: [ :msgs |
						stream nextPutAll: '**Sends:** '.
						msgs
							do: [ :sel |
								| fileName |
								fileName := (PWikiSelectorPageBase selectorToFileName: sel), ' implementors'.
								stream nextPutAll: '[[', fileName, '|', sel, ']]'.
								self generateImplementorsPageFor: sel ]
							separatedBy: [ stream nextPutAll: ', ' ].
						stream cr ].
					stream nextPutAll: '[[', (PWikiSelectorPageBase selectorToFileName: section selector), ' senders|Senders]]'; cr.
					self generateSendersPageFor: section selector.
					stream nextPutAll: '```smalltalk'; cr.
					stream nextPutAll: section sourceCode; cr.
					stream nextPutAll: '```'; cr ] ] ].
		aPage classExtensionProtocolNames ifNotEmpty: [ :extProtos |
			stream cr.
			stream nextPutAll: '### Extensions'; cr.
			extProtos do: [ :protocol |
				| methods |
				methods := aPage classMethodsInProtocol: protocol.
				methods ifNotEmpty: [
					stream cr.
					stream nextPutAll: '#### ', protocol; cr.
					methods do: [ :method |
						| section |
						section := PWikiMethodSection forMethod: method.
						stream nextPutAll: '##### ', section selector; cr.
						section sentMessages ifNotEmpty: [ :msgs |
							stream nextPutAll: '**Sends:** '.
							msgs
								do: [ :sel |
									| fileName |
									fileName := (PWikiSelectorPageBase selectorToFileName: sel), ' implementors'.
									stream nextPutAll: '[[', fileName, '|', sel, ']]'.
									self generateImplementorsPageFor: sel ]
								separatedBy: [ stream nextPutAll: ', ' ].
							stream cr ].
						stream nextPutAll: '[[', (PWikiSelectorPageBase selectorToFileName: section selector), ' senders|Senders]]'; cr.
						self generateSendersPageFor: section selector.
						stream nextPutAll: '```smalltalk'; cr.
						stream nextPutAll: section sourceCode; cr.
						stream nextPutAll: '```'; cr ] ] ] ] ].

	aPage extensionProtocolNames ifNotEmpty: [ :extProtos |
		stream cr.
		stream nextPutAll: '## Extensions'; cr.
		extProtos do: [ :protocol |
			| methods |
			methods := aPage methodsInProtocol: protocol.
			methods ifNotEmpty: [
				stream cr.
				stream nextPutAll: '### ', protocol; cr.
				methods do: [ :method |
					| section |
					section := PWikiMethodSection forMethod: method.
					stream nextPutAll: '#### ', section selector; cr.
					section sentMessages ifNotEmpty: [ :msgs |
						stream nextPutAll: '**Sends:** '.
						msgs
							do: [ :sel |
								| fileName |
								fileName := (PWikiSelectorPageBase selectorToFileName: sel), ' implementors'.
								stream nextPutAll: '[[', fileName, '|', sel, ']]'.
								self generateImplementorsPageFor: sel ]
							separatedBy: [ stream nextPutAll: ', ' ].
						stream cr ].
					stream nextPutAll: '[[', (PWikiSelectorPageBase selectorToFileName: section selector), ' senders|Senders]]'; cr.
					self generateSendersPageFor: section selector.
					stream nextPutAll: '```smalltalk'; cr.
					stream nextPutAll: section sourceCode; cr.
					stream nextPutAll: '```'; cr ] ] ] ].

	^ stream contents
]

{ #category : 'scripts' }
PWikiGenerator >> cacheBenchmark [
	<script: 'self cacheBenchmark'>
]

{ #category : 'scripts' }
PWikiGenerator >> generateImage [
	<script: 'self generateImage'>
]

{ #category : 'scripts' }
PWikiGenerator >> generatePackagePharoWiki [
	<script: 'self generatePackagePharoWiki'>
]

{ #category : 'scripts' }
PWikiGenerator >> generatePoint [
	<script: 'self generatePoint'>
]

{ #category : 'scripts' }
PWikiGenerator >> reload [
	<script: 'self reload'>
]

{ #category : 'scripts' }
PWikiGenerator >> runAllTests [
	<script: 'self runAllTests'>
]

{ #category : 'scripts' }
PWikiGenerator >> saveClassTonel [
	<script: 'self saveClassTonel'>
]

{ #category : 'scripts' }
PWikiGenerator >> sourceCodeOf [
	<script: 'self sourceCodeOf'>
]
