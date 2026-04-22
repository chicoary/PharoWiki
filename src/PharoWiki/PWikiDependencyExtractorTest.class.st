Class {
	#name : #PWikiDependencyExtractorTest,
	#superclass : #TestCase,
	#instVars : [
		'extractor'
	],
	#category : #'PharoWiki-Tests'
}

{ #category : #running }
PWikiDependencyExtractorTest >> setUp [
	extractor := PWikiDependencyExtractor new
]

{ #category : #'tests - class deps' }
PWikiDependencyExtractorTest >> testUsersOfPointAreClasses [
	"Given the class Point
	 When asking who uses it
	 Then all results are class names (strings or symbols)"
	| users |
	users := extractor usersOf: Point.
	self assert: (users allSatisfy: [ :n | n isString or: [ n isSymbol ] ])
]

{ #category : #'tests - class deps' }
PWikiDependencyExtractorTest >> testUsersOfPointIncludesNumber [
	"Given the class Point
	 When asking who uses it
	 Then Number is among the users (via #@ which creates a Point)"
	| users |
	users := extractor usersOf: Point.
	self assert: (users includes: #Number)
]

{ #category : #'tests - class deps' }
PWikiDependencyExtractorTest >> testDependenciesOfPointAreClasses [
	"Given the class Point
	 When asking its dependencies
	 Then all results are class names (strings or symbols)"
	| deps |
	deps := extractor dependenciesOf: Point.
	self assert: (deps allSatisfy: [ :n | n isString or: [ n isSymbol ] ])
]

{ #category : #'tests - class deps' }
PWikiDependencyExtractorTest >> testDependenciesOfPointIncludesObject [
	"Given the class Point
	 When asking its dependencies
	 Then Object is among them (via superclass)"
	| deps |
	deps := extractor dependenciesOf: Point.
	self assert: (deps includes: #Object)
]

{ #category : 'tests - implementors' }
PWikiDependencyExtractorTest >> testImplementorsOfIfTrueIncludesBoolean [
	"Given the selector #ifTrue:
	 When asking for implementors
	 Then Boolean is among them"
	| implementors |
	implementors := extractor implementorsOf: #ifTrue:.
	self assert: (implementors anySatisfy: [ :m | m methodClass name = 'Boolean' ])
]

{ #category : 'tests - implementors' }
PWikiDependencyExtractorTest >> testImplementorsOfReturnsCompiledMethods [
	"Given any selector
	 When asking for implementors
	 Then all results are CompiledMethods"
	| implementors |
	implementors := extractor implementorsOf: #printOn:.
	self assert: (implementors allSatisfy: [ :m | m isKindOf: CompiledMethod ])
]
