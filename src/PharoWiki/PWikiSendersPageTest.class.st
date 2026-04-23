Class {
	#name : 'PWikiSendersPageTest',
	#superclass : 'TestCase',
	#instVars : [
		'page'
	],
	#category : 'PharoWiki-Tests',
	#package : 'PharoWiki',
	#tag : 'Tests'
}

{ #category : 'running' }
PWikiSendersPageTest >> setUp [
	"Use #ifTrue: as canonical test selector — stable, well-known senders."
	| senders |
	senders := SystemNavigation default allSendersOf: #ifTrue:.
	page := PWikiSendersPage
		selector: #ifTrue:
		senders: senders
]

{ #category : 'tests - accessing' }
PWikiSendersPageTest >> testSelector [
	"Given a page for #ifTrue:
	 When asking the selector
	 Then it returns #ifTrue:"
	self assert: page selector equals: #ifTrue:
]

{ #category : 'tests - accessing' }
PWikiSendersPageTest >> testFileName [
	"Given a page for #ifTrue:
	 When asking the file name
	 Then colons are replaced with underscores and suffix is senders"
	self assert: page fileName equals: 'ifTrue_ senders'
]

{ #category : 'tests - accessing' }
PWikiSendersPageTest >> testTitle [
	"Given a page for #ifTrue:
	 When asking the title
	 Then it returns the selector followed by senders"
	self assert: page title equals: 'ifTrue: senders'
]

{ #category : 'tests - rendering' }
PWikiSendersPageTest >> testContentIncludesHeading [
	"Given a page for #ifTrue:
	 When rendering
	 Then the content starts with the title heading"
	self assert: (page content beginsWith: '# ifTrue: senders')
]

{ #category : 'tests - rendering' }
PWikiSendersPageTest >> testContentIsNotEmpty [
	"Given a page for #ifTrue:
	 When rendering
	 Then the content includes at least one sender link"
	self assert: (page content includesSubstring: '[[')
]

{ #category : 'tests - rendering' }
PWikiSendersPageTest >> testSendersSortedAlphabetically [
	"Given a page for #ifTrue:
	 When rendering
	 Then the first sender class name sorts before or equal to the last"
	| content linkLines firstClass lastClass |
	content := page content.
	linkLines := content lines select: [ :l | l beginsWith: '- [[' ].
	linkLines size >= 2 ifFalse: [ ^ self ].
	firstClass := (linkLines first copyFrom: 5 to: (linkLines first indexOf: $#) - 1).
	lastClass := (linkLines last copyFrom: 5 to: (linkLines last indexOf: $#) - 1).
	self assert: firstClass <= lastClass
]
