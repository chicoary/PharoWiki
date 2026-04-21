Class {
	#name : 'PWikiMicrodownConverter',
	#superclass : 'Object',
	#category : 'PharoWiki-Extractors',
	#package : 'PharoWiki',
	#tag : 'Extractors'
}

{ #category : 'converting' }
PWikiMicrodownConverter >> convert: aString [
	"Convert Microdown markup in aString to Markdown/Obsidian format.
	 Handles code blocks and three forms of links:
	   fenced code blocks     → adds smalltalk language tag
	   `#'PackageName'`       → [[PackageName]]
	   `ClassName>>#selector` → [[ClassName#selector]]
	   `ClassName`            → [[ClassName]]
	 Order matters: code blocks first, then package and method links before class links."
	| result |
	result := self convertCodeBlocks: aString.
	result := self convertPackageLinks: result.
	result := self convertMethodLinks: result.
	result := self convertClassLinks: result.
	^ result
]

{ #category : 'private-converting' }
PWikiMicrodownConverter >> convertCodeBlocks: aString [
	"Add smalltalk language tag to fenced code blocks that have none.
	 Processes line by line: opening fence (``` alone) gets the tag;
	 closing fence (``` alone, inside a block) is left unchanged."
	| lines result inBlock |
	lines := aString lines.
	result := WriteStream on: String new.
	inBlock := false.
	lines
		do: [ :line |
			line trimmed = '```'
				ifTrue: [
					inBlock
						ifTrue: [
							result nextPutAll: '```'.
							inBlock := false ]
						ifFalse: [
							result nextPutAll: '```smalltalk'.
							inBlock := true ] ]
				ifFalse: [ result nextPutAll: line ] ]
		separatedBy: [ result cr ].
	^ result contents
]

{ #category : 'private-converting' }
PWikiMicrodownConverter >> convertPackageLinks: aString [
	"Convert `#'PackageName'` → [[PackageName]]"
	| regex |
	regex := '`#''([^'']+)''`' asRegex.
	^ regex
		copy: aString
		translatingMatchesUsing: [ :match |
			| packageName |
			packageName := regex subexpression: 2.
			'[[', packageName, ']]' ]
]

{ #category : 'private-converting' }
PWikiMicrodownConverter >> convertMethodLinks: aString [
	"Convert `ClassName>>#selector` → [[ClassName#selector]]"
	| regex |
	regex := '`([A-Z][A-Za-z0-9_]*)>>#([^`]+)`' asRegex.
	^ regex
		copy: aString
		translatingMatchesUsing: [ :match |
			| className selector |
			className := regex subexpression: 2.
			selector := regex subexpression: 3.
			'[[', className, '#', selector, ']]' ]
]

{ #category : 'private-converting' }
PWikiMicrodownConverter >> convertClassLinks: aString [
	"Convert `ClassName` → [[ClassName]]
	 Only matches backtick-wrapped identifiers starting with uppercase."
	| regex |
	regex := '`([A-Z][A-Za-z0-9_]*)`' asRegex.
	^ regex
		copy: aString
		translatingMatchesUsing: [ :match |
			| className |
			className := regex subexpression: 2.
			'[[', className, ']]' ]
]

{ #category : 'private' }
PWikiMicrodownConverter >> selectorToAnchor: aSelector [
	"Convert a selector to a Markdown-safe anchor.
	 Example: setX:setY: → setx-sety-"
	^ aSelector asLowercase copyReplaceAll: ':' with: '-'
]