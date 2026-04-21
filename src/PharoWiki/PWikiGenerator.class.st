Class {
	#name : 'PWikiGenerator',
	#superclass : 'Object',
	#instVars : [
		'outputDir',
		'writer',
		'converter'
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
	converter := PWikiMicrodownConverter new
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

{ #category : 'generating - public' }
PWikiGenerator >> generateForImage [
	"Generate wiki pages for all classes in the image.
	 Shows three nested progress bars:
	   - outer : overall class count
	   - middle : current package
	   - inner  : protocols within the current class"
	| allClasses |
	allClasses := Smalltalk allClasses asArray.
	[ :outerJob |
		outerJob
			title: 'PharoWiki — gerando imagem completa';
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
	package := PackageOrganizer default
		packageNamed: aPackageName
		ifAbsent: [ ^ self ].
	classes := package classes asArray.
	[ :outerJob |
		outerJob
			title: 'PharoWiki — pacote ', aPackageName;
			min: 0;
			max: classes size.
		self
			generateClasses: classes
			outerJob: outerJob
	] asJob run
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
				title: 'Pacote: ', pkgName;
				min: 0;
				max: classes size.
			classes doWithIndex: [ :aClass :i |
				pkgJob currentValue: i.
				[ :classJob |
					classJob
						title: aClass name;
						min: 0;
						max: (aClass protocols size max: 1).
					self generateForClass: aClass classJob: classJob.
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
	stream nextPutAll: '**Pacote:** `', aPage packageName, '`'; cr.
	aPage superclassName ifNotEmpty: [ :s |
		stream nextPutAll: '**Herda de:** [', s, '](../'; cr.
		stream nextPutAll: s, '.md)'; cr ].
	aPage hasSubclasses ifTrue: [
		stream nextPutAll: '**Subclasses:** '.
		stream nextPutAll: (', ' join: (aPage subclassNames collect: [ :n |
			'[', n, '](', n, '.md)' ])).
		stream cr ].
	aPage hasComment ifTrue: [
		stream cr.
		stream nextPutAll: '## Comentário'; cr.
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
					stream nextPutAll: '**Envia:** `'.
					stream nextPutAll: (', ' join: msgs).
					stream nextPutAll: '`'; cr ].
				stream nextPutAll: '```smalltalk'; cr.
				stream nextPutAll: section sourceCode; cr.
				stream nextPutAll: '```'; cr ] ] ].

	aPage extensionProtocolNames ifNotEmpty: [ :extProtos |
		stream cr.
		stream nextPutAll: '## Extensões'; cr.
		extProtos do: [ :protocol |
			stream nextPutAll: '- `', protocol, '`'; cr ] ].

	^ stream contents
]
