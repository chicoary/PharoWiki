Class {
	#name : 'PWikiDependencyExtractorTest',
	#superclass : 'TestCase',
	#instVars : [ 'extractor' ],
	#category : 'PharoWiki-Tests',
	#package : 'PharoWiki',
	#tag : 'Tests'
}

{ #category : 'running' }
PWikiDependencyExtractorTest >> setUp [
	extractor := PWikiDependencyExtractor new
]

{ #category : 'tests - class deps' }
PWikiDependencyExtractorTest >> testUsersOfPointAreClasses [
	"Given the class Point
	 When asking who uses it
	 Then all results are class names (strings)"
	| users |
	users := extractor usersOf: Point.
	self assert: (users allSatisfy: [ :n | n isString ])
]

{ #category : 'tests - class deps' }
PWikiDependencyExtractorTest >> testUsersOfPointIncludesRectangle [
	"Given the class Point
	 When asking who uses it
	 Then Rectangle is among the users"
	| users |
	users := extractor usersOf: Point.
	self assert: (users includes: 'Rectangle')
]

{ #category : 'tests - class deps' }
PWikiDependencyExtractorTest >> testDependenciesOfPointAreClasses [
	"Given the class Point
	 When asking its dependencies
	 Then all results are class names (strings)"
	| deps |
	deps := extractor dependenciesOf: Point.
	self assert: (deps allSatisfy: [ :n | n isString ])
]

{ #category : 'tests - class deps' }
PWikiDependencyExtractorTest >> testDependenciesOfPointIncludesObject [
	"Given the class Point
	 When asking its dependencies
	 Then Object is among them (via superclass)"
	| deps |
	deps := extractor dependenciesOf: Point.
	self assert: (deps includes: 'Object')
]
