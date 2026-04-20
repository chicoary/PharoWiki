Class {
	#name : #PWikiGenerator,
	#superclass : #Object,
	#instVars : [
		'outputDir',
		'writer',
		'converter'
	],
	#category : #'PharoWiki-Core'
}

{ #category : #'instance creation' }
PWikiGenerator class >> outputDir: aDirectory [
	^ self new initializeWith: aDirectory
]

{ #category : #initialization }
PWikiGenerator >> initializeWith: aDirectory [
	outputDir := aDirectory.
	writer := PWikiFileWriter outputDir: aDirectory.
	converter := PWikiMicrodownConverter new
]

{ #category : #generating }
PWikiGenerator >> generateForClass: aClass [
	"Generate a wiki page for aClass and write it to the output directory."
	| page content |
	page := PWikiClassPage forClass: aClass.
	content := self renderPage: page.
	writer
		writeClass: page className
		package: page packageName
		content: content
]

{ #category : #generating }
PWikiGenerator >> generateForPackage: aPackageName [
	"Generate wiki pages for all classes in the given package."
	| package |
	package := PackageOrganizer default
		packageNamed: aPackageName
		ifAbsent: [ ^ self ].
	package classes do: [ :aClass |
		self generateForClass: aClass ]
]

{ #category : #rendering }
PWikiGenerator >> renderPage: aPage [
	"Render a PWikiClassPage as a Markdown string."
	| stream |
	stream := WriteStream on: String new.
	stream
		nextPutAll: '# ', aPage className; cr.
	stream
		nextPutAll: '**Pacote:** `', aPage packageName, '`'; cr.
	aPage superclassName ifNotEmpty: [ :s |
		stream nextPutAll: '**Herda de:** [', s, '](', s, '.md)'; cr ].
	aPage hasComment ifTrue: [
		stream cr;
		nextPutAll: '## Comentário'; cr;
		nextPutAll: (converter convert: aPage comment); cr ].
	aPage protocolNames do: [ :protocol |
		| methods |
		methods := aPage methodsInProtocol: protocol.
		methods ifNotEmpty: [
			stream cr;
			nextPutAll: '## ', protocol; cr.
			methods do: [ :method |
				| section |
				section := PWikiMethodSection forMethod: method.
				stream
					nextPutAll: '### ', section selector; cr;
					nextPutAll: '```smalltalk'; cr;
					nextPutAll: section sourceCode; cr;
					nextPutAll: '```'; cr ] ] ].
	^ stream contents
]
