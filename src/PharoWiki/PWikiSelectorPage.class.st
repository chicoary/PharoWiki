Class {
	#name : 'PWikiSelectorPage',
	#superclass : 'Object',
	#instVars : [
		'selector',
		'implementors'
	],
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'instance creation' }
PWikiSelectorPage class >> selector: aSymbol implementors: aCollectionOfMethods [
	^ self new initializeWith: aSymbol implementors: aCollectionOfMethods
]

{ #category : 'initialization' }
PWikiSelectorPage >> initializeWith: aSymbol implementors: aCollectionOfMethods [
	selector := aSymbol.
	implementors := aCollectionOfMethods
		asSortedCollection: [ :a :b | a methodClass name <= b methodClass name ]
]

{ #category : 'accessing' }
PWikiSelectorPage >> selector [
	^ selector
]

{ #category : 'accessing' }
PWikiSelectorPage >> fileName [
	"Answer the filesystem-safe file name for this selector page.
	 Example: #ifTrue: → 'ifTrue_ implementors'
	 Example: #* → '_asterisk_ implementors'"
	^ (self class selectorToFileName: selector), ' implementors'
]

{ #category : 'accessing' }
PWikiSelectorPage >> title [
	^ selector, ' implementors'
]

{ #category : 'rendering' }
PWikiSelectorPage >> content [
	"Render the implementors list as Markdown."
	| stream |
	stream := WriteStream on: String new.
	stream nextPutAll: '# ', self title; cr.
	stream cr.
	implementors do: [ :method |
		| className anchor link |
		className := method methodClass name.
		anchor := selector.
		link := '[[', className, '#', anchor, '|', className, '>>', selector, ']]'.
		stream nextPutAll: '- ', link; cr ].
	^ stream contents
]

{ #category : 'private' }
PWikiSelectorPage class >> selectorToFileName: aSelector [
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

{ #category : 'accessing' }
PWikiSelectorPage >> fileName [
	"Answer the filesystem-safe file name for this selector page.
	 Example: #ifTrue: → 'ifTrue_ implementors'
	 Example: #* → '_asterisk_ implementors'"
	^ (self class selectorToFileName: selector), ' implementors'
]