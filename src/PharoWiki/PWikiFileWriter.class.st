Class {
	#name : 'PWikiFileWriter',
	#superclass : 'Object',
	#instVars : [
		'outputDir'
	],
	#category : 'PharoWiki-Writers',
	#package : 'PharoWiki',
	#tag : 'Writers'
}

{ #category : 'instance creation' }
PWikiFileWriter class >> outputDir: aDirectory [
	^ self new initializeWith: aDirectory
]

{ #category : 'initialization' }
PWikiFileWriter >> initializeWith: aDirectory [
	outputDir := aDirectory
]

{ #category : 'writing' }
PWikiFileWriter >> writeClass: aClassName package: aPackageName content: aString [
	"Write the markdown content for a class to the appropriate file.
	 Creates the package directory if it does not exist.
	 Always overwrites any existing file."
	| packageDir file |
	packageDir := outputDir / aPackageName.
	packageDir exists ifFalse: [ packageDir createDirectory ].
	file := packageDir / (aClassName, '.md').
	file ensureDelete.
	file writeStreamDo: [ :stream |
		stream nextPutAll: aString ]
]

{ #category : 'writing' }
PWikiFileWriter >> writeSelectorPage: aSelectorPage [
	"Write the implementors note for a selector to _implementors/.
	 Creates the directory if it does not exist.
	 Skips writing if the file already exists — idempotent and I/O efficient."
	| implementorsDir file |
	implementorsDir := outputDir / '_implementors'.
	implementorsDir exists ifFalse: [ implementorsDir createDirectory ].
	file := implementorsDir / (aSelectorPage fileName, '.md').
	file exists ifTrue: [ ^ self ].
	file writeStreamDo: [ :stream |
		stream nextPutAll: aSelectorPage content ]
]
