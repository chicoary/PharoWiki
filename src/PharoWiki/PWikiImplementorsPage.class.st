Class {
	#name : 'PWikiImplementorsPage',
	#superclass : 'PWikiSelectorPageBase',
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'instance creation' }
PWikiImplementorsPage class >> selector: aSymbol implementors: aCollectionOfMethods [
	^ self selector: aSymbol methods: aCollectionOfMethods
]

{ #category : 'accessing' }
PWikiImplementorsPage >> fileName [
	"Example: #ifTrue: → 'ifTrue_ implementors'"
	^ (self class selectorToFileName: selector), ' implementors'
]

{ #category : 'accessing' }
PWikiImplementorsPage >> title [
	^ selector, ' implementors'
]

{ #category : 'rendering' }
PWikiImplementorsPage >> linkFor: aMethod [
	"[[ClassName#selector|ClassName>>selector]]"
	| className |
	className := aMethod methodClass name.
	^ '[[', className, '#', selector, '|', className, '>>', selector, ']]'
]
