Class {
	#name : #PWikiMicrodownConverter,
	#superclass : #Object,
	#category : #'PharoWiki-Extractors'
}

{ #category : 'private' }
PWikiMicrodownConverter >> convertPackageLinks: aString [
	"Convert `#'PackageName'` → [PackageName](../PackageName/index.md)"
	| regex |
	regex := '`#''([^'']+)''`' asRegex.
	^ regex
		copy: aString
		translatingMatchesUsing: [ :match |
			| packageName |
			packageName := regex subexpression: 2.
			'[', packageName, '](../', packageName, '/index.md)' ]
]

{ #category : 'private' }
PWikiMicrodownConverter >> convertMethodLinks: aString [
	"Convert `ClassName>>#selector` → [ClassName>>selector](ClassName.md#anchor)"
	| regex |
	regex := '`([A-Z][A-Za-z0-9_]*)>>#([^`]+)`' asRegex.
	^ regex
		copy: aString
		translatingMatchesUsing: [ :match |
			| className selector anchor |
			className := regex subexpression: 2.
			selector := regex subexpression: 3.
			anchor := self selectorToAnchor: selector.
			'[', className, '>>', selector, '](', className, '.md#', anchor, ')' ]
]

{ #category : 'private' }
PWikiMicrodownConverter >> convertClassLinks: aString [
	"Convert `ClassName` → [ClassName](ClassName.md)
	 Only matches backtick-wrapped identifiers starting with uppercase."
	| regex |
	regex := '`([A-Z][A-Za-z0-9_]*)`' asRegex.
	^ regex
		copy: aString
		translatingMatchesUsing: [ :match |
			| className |
			className := regex subexpression: 2.
			'[', className, '](', className, '.md)' ]
]

{ #category : 'private' }
PWikiMicrodownConverter >> selectorToAnchor: aSelector [
	"Convert a selector to a Markdown-safe anchor.
	 Example: setX:setY: → setx-sety-"
	^ aSelector asLowercase copyReplaceAll: ':' with: '-'
]


{ #category : 'private-converting' }
PWikiMicrodownConverter >> convertCodeBlocks: aString [
	"Add smalltalk language tag to fenced code blocks that have none."
	| regex |
	regex := ('```', String cr) asRegex.
	^ regex
		copy: aString
		translatingMatchesUsing: [ :match | '```smalltalk', String cr ]
]

{ #category : 'converting' }
PWikiMicrodownConverter >> convert: aString [
	"Convert Microdown markup in aString to Markdown.
	 Handles code blocks and three forms of links:
	   fenced code blocks     → adds smalltalk language tag
	   `#'PackageName'`       → [PackageName](../PackageName/index.md)
	   `ClassName>>#selector` → [ClassName>>selector](ClassName.md#anchor)
	   `ClassName`            → [ClassName](ClassName.md)
	 Order matters: code blocks first, then package and method links before class links."
	| result |
	result := self convertCodeBlocks: aString.
	result := self convertPackageLinks: result.
	result := self convertMethodLinks: result.
	result := self convertClassLinks: result.
	^ result
]
