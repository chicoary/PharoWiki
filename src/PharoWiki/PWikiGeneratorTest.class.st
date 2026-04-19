Class {
	#name : 'PWikiGeneratorTest',
	#superclass : 'TestCase',
	#instVars : [ 'generator' 'outputDir' ],
	#category : 'PharoWiki-Tests',
	#package : 'PharoWiki',
	#tag : 'Tests'
}

{ #category : 'running' }
PWikiGeneratorTest >> setUp [
	outputDir := FileSystem memory root.
	generator := PWikiGenerator outputDir: outputDir
]

{ #category : 'tests - generation' }
PWikiGeneratorTest >> testGeneratesFileForPoint [
	"Given the generator configured with an output dir
	 When generating for the class Point
	 Then a .md file exists for Point"
	generator generateForClass: Point.
	self assert: (outputDir / 'Kernel' / 'Point.md') exists
]

{ #category : 'tests - generation' }
PWikiGeneratorTest >> testGeneratedFileNotEmpty [
	"Given the generator
	 When generating for the class Point
	 Then the resulting file is not empty"
	generator generateForClass: Point.
	| content |
	content := (outputDir / 'Kernel' / 'Point.md') readStream contents.
	self assert: content isNotEmpty
]

{ #category : 'tests - generation' }
PWikiGeneratorTest >> testGeneratedFileContainsClassName [
	"Given the generator
	 When generating for the class Point
	 Then the file contains the class name"
	generator generateForClass: Point.
	| content |
	content := (outputDir / 'Kernel' / 'Point.md') readStream contents.
	self assert: (content includesSubstring: 'Point')
]

{ #category : 'tests - generation' }
PWikiGeneratorTest >> testGenerateForPackage [
	"Given the generator
	 When generating for the package 'Kernel'
	 Then multiple .md files are created"
	generator generateForPackage: 'Kernel'.
	| kernelDir |
	kernelDir := outputDir / 'Kernel'.
	self assert: kernelDir exists.
	self assert: kernelDir children isNotEmpty
]
