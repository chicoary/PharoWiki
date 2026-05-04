Class {
	#name : 'PWikiLibsGeneratorTest',
	#superclass : 'TestCase',
	#category : 'PharoWiki-Tests',
	#package : 'PharoWiki',
	#tag : 'Tests'
}

{ #category : 'tests' }
PWikiLibsGeneratorTest >> testClassesToGenerateExcludesProjectPackages [
	"classesToGenerate must not include classes from project packages."
	| gen projectPackageNames |
	gen := PWikiLibsGenerator outputDir: FileSystem memory root.
	projectPackageNames := gen projectPackageNames.
	gen classesToGenerate do: [ :c |
		self deny: (projectPackageNames includes: c package name) ]
]

{ #category : 'tests' }
PWikiLibsGeneratorTest >> testClassesToGenerateDisjointFromChangesGenerator [
	"libs and changes classesToGenerate must be disjoint."
	| libsGen changesGen libsClasses changesClasses |
	libsGen    := PWikiLibsGenerator    outputDir: FileSystem memory root.
	changesGen := PWikiChangesGenerator outputDir: FileSystem memory root.
	libsClasses    := libsGen classesToGenerate asSet.
	changesClasses := changesGen classesToGenerate asSet.
	self assert: (libsClasses intersection: changesClasses) isEmpty
]

{ #category : 'tests' }
PWikiLibsGeneratorTest >> testClassesToGenerateIsEmptyIfNoLibs [
	"If no external libraries are loaded, classesToGenerate returns empty.
	 Skipped if libs are present in this image."
	| gen |
	gen := PWikiLibsGenerator outputDir: FileSystem memory root.
	gen classesToGenerate ifNotEmpty: [ ^ self skip ].
	self assert: gen classesToGenerate isEmpty
]
