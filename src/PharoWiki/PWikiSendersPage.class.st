Class {
	#name : 'PWikiSendersPage',
	#superclass : 'PWikiSelectorPageBase',
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'instance creation' }
PWikiSendersPage class >> selector: aSymbol senders: aCollectionOfMethods [
	^ self selector: aSymbol methods: aCollectionOfMethods
]

{ #category : 'accessing' }
PWikiSendersPage >> fileName [
	"Example: #abs → 'abs senders'"
	^ (self class selectorToFileName: selector), ' senders'
]

{ #category : 'accessing' }
PWikiSendersPage >> title [
	^ selector, ' senders'
]

{ #category : 'rendering' }
PWikiSendersPage >> linkFor: aMethod [
	"[[ClassName#methodSelector|ClassName>>methodSelector]]"
	| className methodSelector |
	className := aMethod methodClass instanceSide name.
	methodSelector := aMethod selector.
	^ '[[', className, '#', methodSelector, '|', className, '>>', methodSelector, ']]'
]
