Class {
	#name : 'PWikiGenerator',
	#superclass : 'Object',
	#instVars : [
		'outputDir',
		'writer',
		'converter',
		'extractor'
	],
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'instance creation' }
PWikiGenerator class >> outputDir: aDirectory [
	^ self new initializeWith: aDirectory
]

{ #category : 'initialization' }
PWikiGenerator >> initializeWith: aDirectory [
	outputDir := aDirectory.
	outputDir exists ifFalse: [ outputDir ensureCreateDirectory ].
	writer := PWikiFileWriter outputDir: aDirectory.
	converter := PWikiMicrodownConverter new.
	extractor := PWikiDependencyExtractor new
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

{ #category : 'generating - private' }
PWikiGenerator >> generateClasses: anArrayOfClasses outerJob: outerJob [
	"Group anArrayOfClasses by package and process each group under a package-level Job."
	| byPackage counter |
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
			pkgJob
				title: 'Package: ', pkgName;
				min: 0;
				max: classes size.
			classes doWithIndex: [ :aClass :i |
				pkgJob currentValue: i.
				[ :classJob |
					classJob
						title: aClass name;
						min: 0;
						max: (aClass protocols size max: 1).
					self generateForClass: aClass classJob: classJob
				] asJob run.
				counter := counter + 1.
				outerJob currentValue: counter ]
		] asJob run ]
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

{ #category : 'generating - private' }
PWikiGenerator >> generateSelectorPageFor: aSelector [
	"Generate the implementors note for aSelector.
	 Skips if the file already exists — handled by PWikiFileWriter."
	| implementors selectorPage |
	implementors := extractor implementorsOf: aSelector.
	selectorPage := PWikiSelectorPage
		selector: aSelector
		implementors: implementors.
	writer writeSelectorPage: selectorPage
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
							fileName := (PWikiSelectorPage selectorToFileName: sel), ' implementors'.
							stream nextPutAll: '[[', fileName, '|', sel, ']]'.
							self generateSelectorPageFor: sel ]
						separatedBy: [ stream nextPutAll: ', ' ].
					stream cr ].
				stream nextPutAll: '```smalltalk'; cr.
				stream nextPutAll: section sourceCode; cr.
				stream nextPutAll: '```'; cr ] ] ].

	aPage extensionProtocolNames ifNotEmpty: [ :extProtos |
		stream cr.
		stream nextPutAll: '## Extensions'; cr.
		extProtos do: [ :protocol |
			stream nextPutAll: '- `', protocol, '`'; cr ] ].

	^ stream contents
]

{ #category : 'generating - private' }
PWikiGenerator >> prepareImplementorsDir [
	"Delete and recreate the _implementors directory.
	 Called before bulk generation to ensure no stale files remain."
	| implementorsDir |
	implementorsDir := outputDir / '_implementors'.
	implementorsDir exists ifTrue: [ implementorsDir deleteAll ].
	implementorsDir createDirectory
]

{ #category : 'generating - public' }
PWikiGenerator >> generateForImage [
	"Generate wiki pages for all classes in the image.
	 Shows three nested progress bars:
	   - outer : overall class count
	   - middle : current package
	   - inner  : protocols within the current class"
	| allClasses |
	self prepareImplementorsDir.
	allClasses := Smalltalk allClasses asArray.
	[ :outerJob |
		outerJob
			title: 'PharoWiki — generating full image';
			min: 0;
			max: allClasses size.
		self
			generateClasses: allClasses
			outerJob: outerJob
	] asJob run
]

{ #category : 'generating - public' }
PWikiGenerator >> generateForPackageNamed: aPackageName [
	"Generate wiki pages for all classes in one package, with job feedback."
	| package classes |
	self prepareImplementorsDir.
	package := PackageOrganizer default
		packageNamed: aPackageName
		ifAbsent: [ ^ self ].
	classes := package classes asArray.
	[ :outerJob |
		outerJob
			title: 'PharoWiki — package ', aPackageName;
			min: 0;
			max: classes size.
		self
			generateClasses: classes
			outerJob: outerJob
	] asJob run
]
