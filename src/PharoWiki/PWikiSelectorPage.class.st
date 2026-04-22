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
	"Answer the file name for this selector page.
	 Colons are replaced with underscores for filesystem compatibility.
	 Example: #ifTrue: → 'ifTrue_ implementors'"
	^ (selector copyReplaceAll: ':' with: '_'), ' implementors'
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
