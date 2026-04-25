Class {
	#name : 'PWikiGeneratorTest',
	#superclass : 'TestCase',
	#instVars : [
		'generator',
		'outputDir'
	],
	#category : 'PharoWiki-Tests',
	#package : 'PharoWiki',
	#tag : 'Tests'
}

{ #category : 'running' }
PWikiGeneratorTest >> setUp [
	outputDir := FileSystem memory root.
	generator := PWikiGenerator outputDir: outputDir
]

{ #category : 'tests - rendering' }
PWikiGeneratorTest >> testExtensionsNotDuplicated [
	"Given a class with extension protocols (Point)
	 When rendering its page
	 Then the Extensions section appears exactly once"
	| gen page content occurrences |
	self skip.
	gen := PWikiGenerator outputDir: FileSystem memory root.
	page := PWikiClassPage forClass: Point.
	content := gen renderPage: page.
	occurrences := 0.
	content linesDo: [ :line |
		(line trimmed = '## Extensions') ifTrue: [ occurrences := occurrences + 1 ] ].
	self assert: occurrences equals: 1
]

{ #category : 'tests - generation' }
PWikiGeneratorTest >> testGenerateForPackage [
	"Given the generator
	 When generating for the package 'Settings-Graphics'
	 Then a .md file is created for its single class"
	generator generateForPackage: 'Settings-Graphics'.
	self assert: (outputDir / 'Settings-Graphics') exists.
	self assert: (outputDir / 'Settings-Graphics') children isNotEmpty
]

{ #category : 'tests - file generation' }
PWikiGeneratorTest >> testGeneratePointExtensionsSection [
	"Given a PWikiGenerator writing to a memory filesystem
	 When generating the Point class page
	 Then the file ends with the Extensions section without duplicates"
	| gen outputDir content expected |
	self skip.
	outputDir := FileSystem memory root.
	gen := PWikiGenerator outputDir: outputDir.
	gen generateForClass: Point.
	content := (outputDir / 'Kernel' / 'Point.md') contents.
	expected := String streamContents: [ :s |
		s
			nextPutAll: '## Extensions'; cr;
			nextPutAll: '- `*Math-Operations-Extensions`'; cr;
			nextPutAll: '- `*STON-Core`'; cr;
			nextPutAll: '- `*Graphics-Display Objects`'; cr;
			nextPutAll: '- `*Morphic-Core`'; cr;
			nextPutAll: '- `*Fuel-Core`'; cr;
			nextPutAll: '- `*Geometry`'; cr ].
	self assert: (content last: expected size) equals: expected
]

{ #category : 'tests - generation' }
PWikiGeneratorTest >> testGeneratedFileContainsClassName [
	"Given the generator
	 When generating for the class Point
	 Then the file contains the class name"
	| content |
	self skip.
	generator generateForClass: Point.
	content := (outputDir / 'Kernel' / 'Point.md') readStream contents.
	self assert: (content includesSubstring: 'Point')
]

{ #category : 'tests - generation' }
PWikiGeneratorTest >> testGeneratedFileNotEmpty [
	"Given the generator
	 When generating for the class Point
	 Then the resulting file is not empty"
	| content |
	self skip.
	generator generateForClass: Point.
	content := (outputDir / 'Kernel' / 'Point.md') readStream contents.
	self assert: content isNotEmpty
]

{ #category : 'tests - generation' }
PWikiGeneratorTest >> testGeneratesFileForPoint [
	"Given the generator configured with an output dir
	 When generating for the class Point
	 Then a .md file exists for Point"
	self skip.
	generator generateForClass: Point.
	self assert: (outputDir / 'Kernel' / 'Point.md') exists
]
