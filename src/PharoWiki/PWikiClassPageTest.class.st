Class {
	#name : #PWikiClassPageTest,
	#superclass : #TestCase,
	#instVars : [
		'page'
	],
	#category : #'PharoWiki-Tests'
}

{ #category : #running }
PWikiClassPageTest >> setUp [
	"Point is our canonical test class:
	 small, well-known, clear protocols, stable across Pharo versions"
	page := PWikiClassPage forClass: Point
]

{ #category : #'tests - basic' }
PWikiClassPageTest >> testClassName [
	"Given a page for Point
	 When asking for the class name
	 Then it returns 'Point'"
	self assert: page className equals: 'Point'
]

{ #category : #'tests - basic' }
PWikiClassPageTest >> testSuperclassName [
	"Given a page for Point
	 When asking for the superclass name
	 Then it returns 'Object'"
	self assert: page superclassName equals: 'Object'
]

{ #category : #'tests - basic' }
PWikiClassPageTest >> testPackageName [
	"Given a page for Point
	 When asking for the package name
	 Then it returns 'Kernel'"
	self assert: page packageName equals: 'Kernel'
]

{ #category : #'tests - basic' }
PWikiClassPageTest >> testHasComment [
	"Given a page for Point
	 When checking the comment
	 Then it is not empty (Point is well documented)"
	self assert: page hasComment
]

{ #category : #'tests - protocols' }
PWikiClassPageTest >> testHasAccessingProtocol [
	"Given a page for Point
	 When listing protocol names
	 Then 'accessing' is present"
	self assert: (page protocolNames includes: 'accessing')
]

{ #category : #'tests - protocols' }
PWikiClassPageTest >> testHasArithmeticProtocol [
	"Given a page for Point
	 When listing protocol names
	 Then 'arithmetic' is present"
	self assert: (page protocolNames includes: 'arithmetic')
]

{ #category : #'tests - protocols' }
PWikiClassPageTest >> testExtensionProtocolsExcludedFromMain [
	"Given a page for Point
	 When listing protocol names
	 Then no protocol starts with '*' (those are extensions)"
	self deny: (page protocolNames anySatisfy: [ :p | p beginsWith: '*' ])
]

{ #category : #'tests - protocols' }
PWikiClassPageTest >> testAccessingProtocolContainsX [
	"Given a page for Point
	 When listing methods in 'accessing'
	 Then it includes the selector #x"
	| methods |
	methods := page methodsInProtocol: 'accessing'.
	self assert: (methods anySatisfy: [ :m | m selector = #x ])
]

{ #category : #'tests - structure' }
PWikiClassPageTest >> testHasInstanceVariables [
	"Given a page for Point
	 When listing instance variable names
	 Then it includes 'x' and 'y'"
	self assertCollection: page instanceVariableNames
		includesAll: #('x' 'y')
]

{ #category : #'tests - structure' }
PWikiClassPageTest >> testHasSubclasses [
	"Given a page for Collection (which has many subclasses)
	 When checking subclasses
	 Then hasSubclasses is true"
	| collectionPage |
	collectionPage := PWikiClassPage forClass: Collection.
	self assert: collectionPage hasSubclasses
]

{ #category : #'tests - structure' }
PWikiClassPageTest >> testSubclassNamesAreStrings [
	"Given a page for Collection
	 When listing subclass names
	 Then all elements are strings"
	| collectionPage |
	collectionPage := PWikiClassPage forClass: Collection.
	self assert: (collectionPage subclassNames allSatisfy: [ :n | n isString ])
]
