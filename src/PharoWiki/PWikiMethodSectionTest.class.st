Class {
	#name : #PWikiMethodSectionTest,
	#superclass : #TestCase,
	#instVars : [
		'section'
	],
	#category : #'PharoWiki-Tests'
}

{ #category : 'running' }
PWikiMethodSectionTest >> setUp [
	"Point >> #x is our canonical test method:
	 trivial, stable, one self send, one instvar read"
	section := PWikiMethodSection forMethod: (Point >> #x)
]

{ #category : 'tests - basic' }
PWikiMethodSectionTest >> testSelector [
	"Given a section for Point >> #x
	 When asking the selector
	 Then it returns #x"
	self assert: section selector equals: #x
]

{ #category : 'tests - basic' }
PWikiMethodSectionTest >> testProtocol [
	"Given a section for Point >> #x
	 When asking the protocol
	 Then it returns 'accessing'"
	self assert: section protocol equals: 'accessing'
]

{ #category : 'tests - basic' }
PWikiMethodSectionTest >> testSourceCodeNotEmpty [
	"Given a section for Point >> #x
	 When asking the source code
	 Then it is not empty"
	self assert: section sourceCode isNotEmpty
]

{ #category : 'tests - basic' }
PWikiMethodSectionTest >> testIsNotClassSide [
	"Given a section for Point >> #x (instance method)
	 When checking if class side
	 Then it is false"
	self deny: section isClassSide
]

{ #category : 'tests - anchor' }
PWikiMethodSectionTest >> testAnchorNameForSimpleSelector [
	"Given a section for Point >> #x
	 When generating the anchor name
	 Then it returns 'x'"
	self assert: section anchorName equals: 'x'
]

{ #category : 'tests - anchor' }
PWikiMethodSectionTest >> testAnchorNameForKeywordSelector [
	"Given a section for a keyword method like #setX:setY:
	 When generating the anchor name
	 Then colons are replaced with dashes"
	| kw |
	kw := PWikiMethodSection forMethod: (Point >> #setX:setY:).
	self assert: kw anchorName equals: 'setx-sety-'
]

{ #category : 'tests - dependencies' }
PWikiMethodSectionTest >> testSentMessagesNotNil [
	"Given any method section
	 When asking for sent messages
	 Then the result is a collection (possibly empty)"
	self assert: section sentMessages isCollection
]

{ #category : 'tests - dependencies' }
PWikiMethodSectionTest >> testReferencedClassesAreStrings [
	"Given any method section
	 When asking for referenced classes
	 Then all results are strings"
	self assert: (section referencedClasses allSatisfy: [ :n | n isString ])
]
