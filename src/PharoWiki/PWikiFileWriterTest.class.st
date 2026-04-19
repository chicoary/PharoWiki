Class {
	#name : 'PWikiFileWriterTest',
	#superclass : 'TestCase',
	#instVars : [ 'writer' 'outputDir' ],
	#category : 'PharoWiki-Tests',
	#package : 'PharoWiki',
	#tag : 'Tests'
}

{ #category : 'running' }
PWikiFileWriterTest >> setUp [
	outputDir := FileSystem memory root.
	writer := PWikiFileWriter outputDir: outputDir
]

{ #category : 'tests - writing' }
PWikiFileWriterTest >> testWritesFile [
	"Given a class name and markdown content
	 When writing
	 Then a file exists at the expected path"
	writer writeClass: 'Point' package: 'Kernel' content: '# Point'.
	self assert: (outputDir / 'Kernel' / 'Point.md') exists
]

{ #category : 'tests - writing' }
PWikiFileWriterTest >> testFileContainsContent [
	"Given markdown content
	 When writing
	 Then the file contains exactly that content"
	writer writeClass: 'Point' package: 'Kernel' content: '# Point'.
	| content |
	content := (outputDir / 'Kernel' / 'Point.md') readStream contents.
	self assert: content equals: '# Point'
]

{ #category : 'tests - writing' }
PWikiFileWriterTest >> testCreatesPackageDirectory [
	"Given a class in a package
	 When writing
	 Then the package directory is created automatically"
	writer writeClass: 'Point' package: 'Kernel' content: '# Point'.
	self assert: (outputDir / 'Kernel') exists
]

{ #category : 'tests - writing' }
PWikiFileWriterTest >> testOverwritesExistingFile [
	"Given an existing file
	 When writing again with new content
	 Then the file is updated"
	writer writeClass: 'Point' package: 'Kernel' content: '# Point'.
	writer writeClass: 'Point' package: 'Kernel' content: '# Point updated'.
	| content |
	content := (outputDir / 'Kernel' / 'Point.md') readStream contents.
	self assert: content equals: '# Point updated'
]
