Class {
	#name : #PWikiFileWriter,
	#superclass : #Object,
	#instVars : [
		'outputDir'
	],
	#category : #'PharoWiki-Writers'
}

{ #category : #'instance creation' }
PWikiFileWriter class >> outputDir: aDirectory [
	^ self new initializeWith: aDirectory
]

{ #category : #initialization }
PWikiFileWriter >> initializeWith: aDirectory [
	outputDir := aDirectory
]

{ #category : #writing }
PWikiFileWriter >> writeClass: aClassName package: aPackageName content: aString [
	"Write the markdown content for a class to the appropriate file.
	 Creates the package directory if it does not exist."
	| packageDir file |
	packageDir := outputDir / aPackageName.
	packageDir exists ifFalse: [ packageDir createDirectory ].
	file := packageDir / (aClassName, '.md').
	file writeStreamDo: [ :stream |
		stream nextPutAll: aString ]
]
