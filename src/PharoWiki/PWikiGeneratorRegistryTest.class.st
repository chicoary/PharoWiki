Class {
	#name : 'PWikiGeneratorRegistryTest',
	#superclass : 'TestCase',
	#category : 'PharoWiki-Tests',
	#package : 'PharoWiki',
	#tag : 'Tests'
}

{ #category : 'tests' }
PWikiGeneratorRegistryTest >> testGeneratorsReturnsAllGenerators [
	"generators returns both sourcesGen and changesGen."
	| sourcesGen changesGen registry |
	sourcesGen := PWikiSourcesGenerator outputDir: FileSystem memory root.
	changesGen := PWikiChangesGenerator outputDir: FileSystem memory root.
	registry := PWikiGeneratorRegistry sourcesGen: sourcesGen changesGen: changesGen.
	self assert: (registry generators includes: sourcesGen).
	self assert: (registry generators includes: changesGen).
	self assert: registry generators size equals: 2
]

{ #category : 'tests' }
PWikiGeneratorRegistryTest >> testGeneratorForSourcesClass [
	"generatorFor: returns sourcesGen for a class from .sources."
	| sourcesGen changesGen registry |
	sourcesGen := PWikiSourcesGenerator outputDir: FileSystem memory root.
	changesGen := PWikiChangesGenerator outputDir: FileSystem memory root.
	registry := PWikiGeneratorRegistry sourcesGen: sourcesGen changesGen: changesGen.
	"Point is a .sources class — not in Epicea"
	self assert: (registry generatorFor: Point) == sourcesGen
]

{ #category : 'tests' }
PWikiGeneratorRegistryTest >> testGeneratorForChangesClass [
	"generatorFor: returns changesGen for a class from .changes."
	| sourcesGen changesGen registry changesClass |
	sourcesGen := PWikiSourcesGenerator outputDir: FileSystem memory root.
	changesGen := PWikiChangesGenerator outputDir: FileSystem memory root.
	registry := PWikiGeneratorRegistry sourcesGen: sourcesGen changesGen: changesGen.
	"Use the first class from changesGen if any exist"
	changesClass := changesGen classesToGenerate
		ifEmpty: [ ^ self skip ]
		ifNotEmpty: [ :classes | classes first ].
	self assert: (registry generatorFor: changesClass) == changesGen
]

{ #category : 'tests' }
PWikiGeneratorRegistryTest >> testSourcesGenAccessor [
	"sourcesGen accessor returns the sources generator."
	| sourcesGen changesGen registry |
	sourcesGen := PWikiSourcesGenerator outputDir: FileSystem memory root.
	changesGen := PWikiChangesGenerator outputDir: FileSystem memory root.
	registry := PWikiGeneratorRegistry sourcesGen: sourcesGen changesGen: changesGen.
	self assert: registry sourcesGen == sourcesGen
]

{ #category : 'tests' }
PWikiGeneratorRegistryTest >> testChangesGenAccessor [
	"changesGen accessor returns the changes generator."
	| sourcesGen changesGen registry |
	sourcesGen := PWikiSourcesGenerator outputDir: FileSystem memory root.
	changesGen := PWikiChangesGenerator outputDir: FileSystem memory root.
	registry := PWikiGeneratorRegistry sourcesGen: sourcesGen changesGen: changesGen.
	self assert: registry changesGen == changesGen
]
