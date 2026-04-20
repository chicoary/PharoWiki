Class {
	#name : #PWikiMethodSection,
	#superclass : #Object,
	#instVars : [
		'method'
	],
	#category : #'PharoWiki-Core'
}

{ #category : #'instance creation' }
PWikiMethodSection class >> forMethod: aCompiledMethod [
	^ self new initializeWith: aCompiledMethod
]

{ #category : #initialization }
PWikiMethodSection >> initializeWith: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #accessing }
PWikiMethodSection >> selector [
	^ method selector
]

{ #category : #accessing }
PWikiMethodSection >> protocol [
	^ method protocol name
]

{ #category : #accessing }
PWikiMethodSection >> sourceCode [
	^ method sourceCode
]

{ #category : #accessing }
PWikiMethodSection >> pragmas [
	^ method pragmas
]

{ #category : #dependencies }
PWikiMethodSection >> selfSends [
	"Messages sent to self — statically resolvable in the hierarchy"
	^ method ast selfMessages
		collect: [ :msg | msg selector ]
]

{ #category : #dependencies }
PWikiMethodSection >> superSends [
	"Messages sent to super"
	^ method ast superMessages
		collect: [ :msg | msg selector ]
]

{ #category : #dependencies }
PWikiMethodSection >> sentMessages [
	"All messages sent in this method body"
	^ method ast sentMessages asArray
]

{ #category : #dependencies }
PWikiMethodSection >> referencedClasses [
	"Global class references found statically in the AST"
	^ method ast allChildren
		select: [ :node | node isVariable and: [ node isGlobalVariable ] ]
		thenCollect: [ :node | node name ]
]

{ #category : #testing }
PWikiMethodSection >> isAbstract [
	^ method pragmas anySatisfy: [ :p | p selector = #abstract ]
]

{ #category : #testing }
PWikiMethodSection >> isPrimitive [
	^ method isPrimitive
]

{ #category : #testing }
PWikiMethodSection >> isClassSide [
	^ method methodClass isMeta
]

{ #category : #accessing }
PWikiMethodSection >> anchorName [
	"Generates a Markdown-safe anchor for this method selector.
	 Example: #setX:setY: → 'setx-sety-'"
	^ self selector asLowercase
		copyReplaceAll: ':'
		with: '-'
]
