Class {
	#name : #PWikiAnchorGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'generator'
	],
	#category : #'PharoWiki-Tests'
}

{ #category : 'running' }
PWikiAnchorGeneratorTest >> setUp [
	generator := PWikiAnchorGenerator new
]

{ #category : 'tests - generation' }
PWikiAnchorGeneratorTest >> testSimpleSelectorAnchor [
	"Given a simple unary selector #x
	 When generating an anchor
	 Then it returns 'x'"
	self assert: (generator anchorFor: #x) equals: 'x'
]

{ #category : 'tests - generation' }
PWikiAnchorGeneratorTest >> testKeywordSelectorAnchor [
	"Given a keyword selector #setX:setY:
	 When generating an anchor
	 Then colons are replaced with dashes and result is lowercase"
	self assert: (generator anchorFor: #setX:setY:) equals: 'setx-sety-'
]

{ #category : 'tests - generation' }
PWikiAnchorGeneratorTest >> testBinarySelectorAnchor [
	"Given a binary selector #+
	 When generating an anchor
	 Then it returns a safe string representation"
	self assert: (generator anchorFor: #+) isString
]

{ #category : 'tests - resolution' }
PWikiAnchorGeneratorTest >> testResolveAnchorForMethodInSameClass [
	"Given a method in the same class
	 When resolving the anchor link
	 Then it returns just #anchorName"
	| link |
	link := generator
		anchorLinkFor: #x
		inClass: 'Point'
		fromClass: 'Point'.
	self assert: link equals: '#x'
]

{ #category : 'tests - resolution' }
PWikiAnchorGeneratorTest >> testResolveAnchorForMethodInOtherClass [
	"Given a method in a different class
	 When resolving the anchor link
	 Then it returns a relative path with anchor"
	| link |
	link := generator
		anchorLinkFor: #x
		inClass: 'Point'
		fromClass: 'Rectangle'.
	self assert: link equals: 'Point.md#x'
]
