Class {
	#name : 'PWikiGeneratorRegistryTest',
	#superclass : 'TestCase',
	#category : 'PharoWiki-Tests',
	#package : 'PharoWiki',
	#tag : 'Tests'
}

{ #category : 'private' }
PWikiGeneratorRegistryTest >> buildRegistry [
	^ PWikiGeneratorRegistry
		sourcesGen: (PWikiSourcesGenerator outputDir: FileSystem memory root)
		changesGen: (PWikiChangesGenerator outputDir: FileSystem memory root)
		libsGen:    (PWikiLibsGenerator    outputDir: FileSystem memory root)
]

{ #category : 'tests' }
PWikiGeneratorRegistryTest >> testGeneratorsReturnsAllGenerators [
	"generators returns all three generators."
	| registry |
	registry := self buildRegistry.
	self assert: registry generators size equals: 3.
	self assert: (registry generators includes: registry sourcesGen).
	self assert: (registry generators includes: registry changesGen).
	self assert: (registry generators includes: registry libsGen)
]

{ #category : 'tests' }
PWikiGeneratorRegistryTest >> testGeneratorForSourcesClass [
	"generatorFor: returns sourcesGen for a class from .sources."
	| registry |
	registry := self buildRegistry.
	self assert: (registry generatorFor: Point) == registry sourcesGen
]

{ #category : 'tests' }
PWikiGeneratorRegistryTest >> testGeneratorForChangesClass [
	"generatorFor: returns changesGen for a project class from .changes."
	| registry changesClass |
	registry := self buildRegistry.
	changesClass := registry changesGen classesToGenerate
		ifEmpty: [ ^ self skip ]
		ifNotEmpty: [ :classes | classes first ].
	self assert: (registry generatorFor: changesClass) == registry changesGen
]

{ #category : 'tests' }
PWikiGeneratorRegistryTest >> testGeneratorForLibsClass [
	"generatorFor: returns libsGen for a library class from .changes."
	| registry libsClass |
	registry := self buildRegistry.
	libsClass := registry libsGen classesToGenerate
		ifEmpty: [ ^ self skip ]
		ifNotEmpty: [ :classes | classes first ].
	self assert: (registry generatorFor: libsClass) == registry libsGen
]

{ #category : 'tests' }
PWikiGeneratorRegistryTest >> testSourcesGenAccessor [
	| registry |
	registry := self buildRegistry.
	self assert: registry sourcesGen isNotNil
]

{ #category : 'tests' }
PWikiGeneratorRegistryTest >> testChangesGenAccessor [
	| registry |
	registry := self buildRegistry.
	self assert: registry changesGen isNotNil
]

{ #category : 'tests' }
PWikiGeneratorRegistryTest >> testLibsGenAccessor [
	| registry |
	registry := self buildRegistry.
	self assert: registry libsGen isNotNil
]
