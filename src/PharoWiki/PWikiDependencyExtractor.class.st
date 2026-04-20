Class {
	#name : #PWikiDependencyExtractor,
	#superclass : #Object,
	#category : #'PharoWiki-Extractors'
}

{ #category : #extracting }
PWikiDependencyExtractor >> dependenciesOf: aClass [
	"Answer the names of classes that aClass depends on.
	 Includes superclass, traits, and classes referenced in method ASTs."
	| deps |
	deps := OrderedCollection new.
	aClass superclass ifNotNil: [ :s | deps add: s name ].
	aClass traitComposition traits do: [ :t | deps add: t name ].
	aClass methods do: [ :method |
		method ast allChildren do: [ :node |
			(node isVariable and: [ node isGlobalVariable ]) ifTrue: [
				| name |
				name := node name.
				(Smalltalk globals includesKey: name asSymbol) ifTrue: [
					(Smalltalk globals at: name asSymbol) isClass ifTrue: [
						deps add: name ] ] ] ] ].
	^ deps asArray removeDuplicates
]

{ #category : #extracting }
PWikiDependencyExtractor >> usersOf: aClass [
	"Answer the names of classes that reference aClass in their methods."
	| users className |
	users := OrderedCollection new.
	className := aClass name.
	Smalltalk allClasses do: [ :each |
		(each ~= aClass) ifTrue: [
			each methods do: [ :method |
				method ast allChildren do: [ :node |
					(node isVariable and: [
						node isGlobalVariable and: [
							node name = className ] ]) ifTrue: [
						users add: each name ] ] ] ] ].
	^ users asArray removeDuplicates
]
