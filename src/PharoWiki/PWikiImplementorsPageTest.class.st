Class {
	#name : 'PWikiImplementorsPageTest',
	#superclass : 'TestCase',
	#instVars : [
		'page'
	],
	#category : 'PharoWiki-Tests',
	#package : 'PharoWiki',
	#tag : 'Tests'
}

{ #category : 'running' }
PWikiImplementorsPageTest >> setUp [
	"Use #ifTrue: as canonical test selector — stable, well-known implementors."
	| implementors |
	implementors := SystemNavigation default allImplementorsOf: #ifTrue:.
	page := PWikiImplementorsPage
		selector: #ifTrue:
		implementors: implementors
]

{ #category : 'tests - accessing' }
PWikiImplementorsPageTest >> testSelector [
	"Given a page for #ifTrue:
	 When asking the selector
	 Then it returns #ifTrue:"
	self assert: page selector equals: #ifTrue:
]

{ #category : 'tests - accessing' }
PWikiImplementorsPageTest >> testFileName [
	"Given a page for #ifTrue:
	 When asking the file name
	 Then colons are replaced with underscores and suffix is implementors"
	self assert: page fileName equals: 'ifTrue_ implementors'
]

{ #category : 'tests - accessing' }
PWikiImplementorsPageTest >> testTitle [
	"Given a page for #ifTrue:
	 When asking the title
	 Then it returns the selector followed by implementors"
	self assert: page title equals: 'ifTrue: implementors'
]

{ #category : 'tests - rendering' }
PWikiImplementorsPageTest >> testContentIncludesHeading [
	"Given a page for #ifTrue:
	 When rendering
	 Then the content starts with the title heading"
	self assert: (page content beginsWith: '# ifTrue: implementors')
]

{ #category : 'tests - rendering' }
PWikiImplementorsPageTest >> testContentIncludesBooleanLink [
	"Given a page for #ifTrue:
	 When rendering
	 Then the content includes a link for Boolean"
	self assert: (page content includesSubstring: '[[Boolean#ifTrue:|Boolean>>ifTrue:]]')
]

{ #category : 'tests - rendering' }
PWikiImplementorsPageTest >> testImplementorsSortedAlphabetically [
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
PWikiImplementorsPageTest >> testFileNameForBinarySelector [
	"Given a page for a binary selector like #*
	 When asking the file name
	 Then special characters are replaced with descriptive names"
	| binaryPage |
	binaryPage := PWikiImplementorsPage
		selector: #*
		implementors: (SystemNavigation default allImplementorsOf: #*).
	self assert: binaryPage fileName equals: '_asterisk_ implementors'
]
