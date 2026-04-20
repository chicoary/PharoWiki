Class {
	#name : #PWikiAnchorGenerator,
	#superclass : #Object,
	#category : #'PharoWiki-Extractors'
}

{ #category : #generating }
PWikiAnchorGenerator >> anchorFor: aSelector [
	"Generate a Markdown-safe anchor for a selector.
	 Example: #setX:setY: → 'setx-sety-'
	          #x          → 'x'
	          #+          → '+'  (binary selectors returned as-is lowercased)"
	^ aSelector asLowercase copyReplaceAll: ':' with: '-'
]

{ #category : #resolving }
PWikiAnchorGenerator >> anchorLinkFor: aSelector inClass: aClassName fromClass: aFromClassName [
	"Resolve a link to a method anchor.
	 If the method is in the same class, return just #anchor.
	 If in a different class, return ClassName.md#anchor."
	| anchor |
	anchor := self anchorFor: aSelector.
	aClassName = aFromClassName
		ifTrue: [ ^ '#', anchor ]
		ifFalse: [ ^ aClassName, '.md#', anchor ]
]
