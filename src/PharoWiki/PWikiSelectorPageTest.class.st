Class {
	#name : 'PWikiSelectorPageTest',
	#superclass : 'TestCase',
	#instVars : [
		'page'
	],
	#category : 'PharoWiki-Tests',
	#package : 'PharoWiki',
	#tag : 'Tests'
}

{ #category : 'running' }
PWikiSelectorPageTest >> setUp [
	"Use #ifTrue: as canonical test selector — stable, well-known implementors."
	| implementors |
	implementors := SystemNavigation default allImplementorsOf: #ifTrue:.
	page := PWikiSelectorPage
		selector: #ifTrue:
		implementors: implementors
]

{ #category : 'tests - accessing' }
PWikiSelectorPageTest >> testSelector [
	"Given a page for #ifTrue:
	 When asking the selector
	 Then it returns #ifTrue:"
	self assert: page selector equals: #ifTrue:
]

{ #category : 'tests - accessing' }
PWikiSelectorPageTest >> testTitle [
	"Given a page for #ifTrue:
	 When asking the title
	 Then it returns the selector followed by implementors"
	self assert: page title equals: 'ifTrue: implementors'
]

{ #category : 'tests - rendering' }
PWikiSelectorPageTest >> testContentIncludesHeading [
	"Given a page for #ifTrue:
	 When rendering
	 Then the content starts with the title heading"
	self assert: (page content beginsWith: '# ifTrue: implementors')
]

{ #category : 'tests - rendering' }
PWikiSelectorPageTest >> testContentIncludesBooleanLink [
	"Given a page for #ifTrue:
	 When rendering
	 Then the content includes a link for Boolean"
	self assert: (page content includesSubstring: '[[Boolean#ifTrue:|Boolean>>ifTrue:]]')
]

{ #category : 'tests - rendering' }
PWikiSelectorPageTest >> testImplementorsSortedAlphabetically [
	"Given a page for #ifTrue:
	 When rendering
	 Then Boolean appears before True (alphabetical order)"
	| content booleanPos truePos |
	content := page content.
	booleanPos := content indexOfSubCollection: '[[Boolean#ifTrue:'.
	truePos := content indexOfSubCollection: '[[True#ifTrue:'.
	self assert: booleanPos < truePos
]

{ #category : 'tests - accessing' }
PWikiSelectorPageTest >> testFileName [
	"Given a page for #ifTrue:
	 When asking the file name
	 Then colons are replaced with underscores"
	self assert: page fileName equals: 'ifTrue_ implementors'
]

{ #category : 'tests - accessing' }
PWikiSelectorPageTest >> testFileNameForBinarySelector [
	"Given a page for a binary selector like #*
	 When asking the file name
	 Then special characters are replaced with descriptive names"
	| binaryPage |
	binaryPage := PWikiSelectorPage
		selector: #*
		implementors: (SystemNavigation default allImplementorsOf: #*).
	self assert: binaryPage fileName equals: '_asterisk_ implementors'
]