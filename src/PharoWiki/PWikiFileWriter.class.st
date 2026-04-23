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
PWikiFileWriter >> writeSelectorPage: aPage [
	"Write a selector page to _implementors/.
	 Skips writing if the file already exists — idempotent and I/O efficient."
	self
		writePage: aPage
		toDirectory: '_implementors'
]

{ #category : 'writing' }
PWikiFileWriter >> writeSenderPage: aPage [
	"Write a sender page to _senders/.
	 Skips writing if the file already exists — idempotent and I/O efficient."
	self
		writePage: aPage
		toDirectory: '_senders'
]

{ #category : 'private' }
PWikiFileWriter >> writePage: aPage toDirectory: aDirName [
	"Write aPage content to aDirName/fileName.md under outputDir.
	 Creates the directory if it does not exist.
	 Skips writing if the file already exists."
	| dir file |
	dir := outputDir / aDirName.
	dir exists ifFalse: [ dir createDirectory ].
	file := dir / (aPage fileName, '.md').
	file exists ifTrue: [ ^ self ].
	file writeStreamDo: [ :stream |
		stream nextPutAll: aPage content ]
]
