Class {
	#name : 'PWikiSelectorPageBase',
	#superclass : 'Object',
	#instVars : [
		'selector',
		'methods'
	],
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'instance creation' }
PWikiSelectorPageBase class >> selector: aSymbol methods: aCollectionOfMethods [
	^ self new initializeWith: aSymbol methods: aCollectionOfMethods
]

{ #category : 'private' }
PWikiSelectorPageBase class >> selectorToFileName: aSelector [
	"Convert a selector to a filesystem-safe name.
	 Replaces Smalltalk special characters with descriptive names.
	 Colons are replaced with underscores."
	| result |
	result := aSelector.
	result := result copyReplaceAll: ':' with: '_'.
	result := result copyReplaceAll: '*' with: '_asterisk_'.
	result := result copyReplaceAll: '+' with: '_plus_'.
	result := result copyReplaceAll: '-' with: '_minus_'.
	result := result copyReplaceAll: '/' with: '_slash_'.
	result := result copyReplaceAll: '\' with: '_backslash_'.
	result := result copyReplaceAll: '@' with: '_at_'.
	result := result copyReplaceAll: '<' with: '_lt_'.
	result := result copyReplaceAll: '>' with: '_gt_'.
	result := result copyReplaceAll: '=' with: '_eq_'.
	result := result copyReplaceAll: '~' with: '_tilde_'.
	result := result copyReplaceAll: ',' with: '_comma_'.
	^ result
]

{ #category : 'initialization' }
PWikiSelectorPageBase >> initializeWith: aSymbol methods: aCollectionOfMethods [
	selector := aSymbol.
	methods := aCollectionOfMethods
		asSortedCollection: [ :a :b | a methodClass name <= b methodClass name ]
]

{ #category : 'accessing' }
PWikiSelectorPageBase >> selector [
	^ selector
]

{ #category : 'accessing' }
PWikiSelectorPageBase >> fileName [
	"Subclasses must override."
	^ self subclassResponsibility
]

{ #category : 'accessing' }
PWikiSelectorPageBase >> title [
	"Subclasses must override."
	^ self subclassResponsibility
]

{ #category : 'rendering' }
PWikiSelectorPageBase >> content [
	"Render the methods list as Markdown.
	 Each item uses linkFor: to generate the appropriate Obsidian link."
	| stream |
	stream := WriteStream on: String new.
	stream nextPutAll: '# ', self title; cr.
	stream cr.
	methods do: [ :method |
		stream nextPutAll: '- ', (self linkFor: method); cr ].
	^ stream contents
]

{ #category : 'rendering' }
PWikiSelectorPageBase >> linkFor: aMethod [
	"Subclasses must override — generate the Obsidian link for one method."
	^ self subclassResponsibility
]
