Class {
	#name : 'PWikiMicrodownConverterTest',
	#superclass : 'TestCase',
	#instVars : [
		'converter'
	],
	#category : 'PharoWiki-Tests',
	#package : 'PharoWiki',
	#tag : 'Tests'
}

{ #category : 'running' }
PWikiMicrodownConverterTest >> setUp [
	converter := PWikiMicrodownConverter new
]

{ #category : 'tests - class links' }
PWikiMicrodownConverterTest >> testClassLinkConversion [
	"Given a Microdown class reference `Point`
	 When converting to Obsidian wiki link
	 Then it becomes [[Point]]"
	| result |
	result := converter convert: '`Point`'.
	self assert: result equals: '[[Point]]'
]

{ #category : 'tests - class links' }
PWikiMicrodownConverterTest >> testMethodLinkConversion [
	"Given a Microdown method reference `Point>>#x`
	 When converting to Obsidian wiki link
	 Then it becomes [[Point#x]]"
	| result |
	result := converter convert: '`Point>>#x`'.
	self assert: result equals: '[[Point#x]]'
]

{ #category : 'tests - class links' }
PWikiMicrodownConverterTest >> testKeywordMethodLinkConversion [
	"Given a Microdown method reference `Point>>#setX:setY:`
	 When converting to Obsidian wiki link
	 Then it becomes [[Point#setX:setY:]]"
	| result |
	result := converter convert: '`Point>>#setX:setY:`'.
	self assert: result equals: '[[Point#setX:setY:]]'
]

{ #category : 'tests - class links' }
PWikiMicrodownConverterTest >> testPackageLinkConversion [
	"Given a Microdown package reference `#'Kernel'`
	 When converting to Obsidian wiki link
	 Then it becomes [[Kernel]]"
	| result |
	result := converter convert: '`#''Kernel''`'.
	self assert: result equals: '[[Kernel]]'
]

{ #category : 'tests - passthrough' }
PWikiMicrodownConverterTest >> testPlainTextUnchanged [
	"Given plain text with no Microdown links
	 When converting
	 Then it is returned unchanged"
	| text |
	text := 'A simple comment with no links.'.
	self assert: (converter convert: text) equals: text
]

{ #category : 'tests - passthrough' }
PWikiMicrodownConverterTest >> testEmptyStringUnchanged [
	"Given an empty string
	 When converting
	 Then it returns an empty string"
	self assert: (converter convert: '') equals: ''
]

{ #category : 'tests - code blocks' }
PWikiMicrodownConverterTest >> testCodeBlockGetsSmalltalkLanguage [
	"Given a fenced code block without language tag
	 When converting
	 Then opening fence gets smalltalk tag and closing fence is unchanged"
	| input result |
	input := '```', String cr, 'x := 1.', String cr, '```'.
	result := converter convert: input.
	self assert: result equals: ('```smalltalk', String cr, 'x := 1.', String cr, '```')
]