Class {
	#name : 'PWikiGenerationRecord',
	#superclass : 'Object',
	#instVars : [
		'sourcesFile',
		'sourcesDigest',
		'generatedAt',
		'classCount',
		'durationSeconds',
		'outputDir',
		'classDigests'
	],
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'instance creation' }
PWikiGenerationRecord class >> outputDir: aDirectory classCount: aCount startTime: aDateAndTime [
	^ self new
		initializeOutputDir: aDirectory
		classCount: aCount
		startTime: aDateAndTime
]

{ #category : 'initialization' }
PWikiGenerationRecord >> initializeOutputDir: aDirectory classCount: aCount startTime: aDateAndTime [
	outputDir := aDirectory.
	classCount := aCount.
	generatedAt := aDateAndTime.
	durationSeconds := (DateAndTime now - aDateAndTime) totalSeconds truncated.
	sourcesFile := Smalltalk sourcesFile basename.
	sourcesDigest := self computeDigest.
	classDigests ifNil: [ classDigests := Dictionary new ]
]

{ #category : 'private' }
PWikiGenerationRecord >> computeDigest [
	"Compute SHA256 digest of the .sources file."
	| bytes |
	bytes := Smalltalk sourcesFile binaryReadStream upToEnd.
	^ (SHA256 hashMessage: bytes) hex
]

{ #category : 'writing' }
PWikiGenerationRecord >> writeFiles [
	self writeSton.
	self writeMarkdown
]

{ #category : 'writing' }
PWikiGenerationRecord >> writeSton [
	| file |
	file := outputDir / '_generation.ston'.
	file writeStreamDo: [ :stream |
		stream nextPutAll: (STON toString: self asDictionary) ]
]

{ #category : 'writing' }
PWikiGenerationRecord >> writeMarkdown [
	| file |
	file := outputDir / '_generation.md'.
	file writeStreamDo: [ :stream |
		stream
			nextPutAll: '# PharoWiki Generation Record'; cr;
			nextPutAll: '**Generated at:** ', generatedAt printString; cr;
			nextPutAll: '**Duration:** ', self formattedDuration; cr;
			nextPutAll: '**Classes:** ', classCount printString; cr;
			nextPutAll: '**Sources file:** `', sourcesFile, '`'; cr;
			nextPutAll: '**Sources digest:** `', sourcesDigest, '`'; cr ]
]

{ #category : 'converting' }
PWikiGenerationRecord >> asDictionary [
	^ Dictionary new
		at: #sourcesFile put: sourcesFile;
		at: #sourcesDigest put: sourcesDigest;
		at: #generatedAt put: generatedAt printString;
		at: #classCount put: classCount;
		at: #durationSeconds put: durationSeconds;
		at: #classDigests put: classDigests;
		yourself
]

{ #category : 'instance creation' }
PWikiGenerationRecord class >> loadFrom: aDirectory [
	"Load classDigests from an existing _generation.ston in aDirectory.
	 Returns a new empty Dictionary if the file does not exist or has no classDigests key."
	| stonFile dict |
	stonFile := aDirectory / '_generation.ston'.
	stonFile exists ifFalse: [ ^ Dictionary new ].
	dict := STON fromString: stonFile contents.
	^ dict at: #classDigests ifAbsent: [ Dictionary new ]
]

{ #category : 'digest' }
PWikiGenerationRecord >> computeDigestForClass: aClass [
	"Serialize aClass via TonelWriter and SHA256 the result.
	 Covers methods, comment, variables, and hierarchy."
	| bytes |
	bytes := (TonelWriter sourceCodeOf: aClass) utf8Encoded.
	^ (SHA256 hashMessage: bytes) hex
]

{ #category : 'digest' }
PWikiGenerationRecord >> isClassUpToDate: aClass [
	"Return true if the stored digest matches the current digest of aClass."
	| stored current |
	stored := classDigests at: aClass name ifAbsent: [ ^ false ].
	current := self computeDigestForClass: aClass.
	^ stored = current
]

{ #category : 'digest' }
PWikiGenerationRecord >> recordDigestForClass: aClass [
	"Compute and store the current digest for aClass."
	classDigests at: aClass name put: (self computeDigestForClass: aClass)
]

{ #category : 'accessing' }
PWikiGenerationRecord >> classDigests [
	^ classDigests
]

{ #category : 'accessing' }
PWikiGenerationRecord >> classDigests: aDictionary [
	classDigests := aDictionary
]

{ #category : 'private' }
PWikiGenerationRecord >> formattedDuration [
	| hours minutes seconds |
	hours := durationSeconds // 3600.
	minutes := (durationSeconds \\ 3600) // 60.
	seconds := durationSeconds \\ 60.
	hours > 0 ifTrue: [
		^ hours printString, 'h ', minutes printString, 'm ', seconds printString, 's' ].
	minutes > 0 ifTrue: [
		^ minutes printString, 'm ', seconds printString, 's' ].
	^ seconds printString, 's'
]
