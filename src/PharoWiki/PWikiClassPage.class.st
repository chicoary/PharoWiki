Class {
	#name : #PWikiClassPage,
	#superclass : #Object,
	#instVars : [
		'theClass'
	],
	#category : #'PharoWiki-Core'
}

{ #category : 'instance creation' }
PWikiClassPage class >> forClass: aClass [
	^ self new initializeWith: aClass
]

{ #category : 'initialization' }
PWikiClassPage >> initializeWith: aClass [
	theClass := aClass
]

{ #category : 'accessing' }
PWikiClassPage >> className [
	^ theClass name
]

{ #category : 'accessing' }
PWikiClassPage >> superclassName [
	^ theClass superclass
		ifNil: [ '' ]
		ifNotNil: [ :s | s name ]
]

{ #category : 'accessing' }
PWikiClassPage >> packageName [
	^ theClass package name
]

{ #category : 'accessing' }
PWikiClassPage >> comment [
	^ theClass comment ifNil: [ '' ]
]

{ #category : 'accessing' }
PWikiClassPage >> subclassNames [
	^ theClass subclasses collect: [ :c | c name ]
]

{ #category : 'accessing' }
PWikiClassPage >> theClass [
	^ theClass
]

{ #category : 'protocols' }
PWikiClassPage >> protocolNames [
	"Exclude extension protocols (those starting with *)"
	^ (theClass protocols
		reject: [ :p | p name beginsWith: '*' ])
		collect: [ :p | p name ]
]

{ #category : 'protocols' }
PWikiClassPage >> extensionProtocolNames [
	"Protocols defined by other packages extending this class"
	^ (theClass protocols
		select: [ :p | p name beginsWith: '*' ])
		collect: [ :p | p name ]
]

{ #category : 'protocols' }
PWikiClassPage >> methodsInProtocol: aProtocolName [
	^ theClass methodsInProtocol: aProtocolName
]

{ #category : 'accessing' }
PWikiClassPage >> instanceVariableNames [
	^ theClass instVarNames
]

{ #category : 'accessing' }
PWikiClassPage >> classVariableNames [
	^ theClass classVarNames
]

{ #category : 'accessing' }
PWikiClassPage >> traitNames [
	^ (theClass traitComposition traits
		collect: [ :t | t name ])
		asArray
]

{ #category : 'testing' }
PWikiClassPage >> hasComment [
	^ theClass comment isNotNil and: [ theClass comment isNotEmpty ]
]

{ #category : 'testing' }
PWikiClassPage >> hasSubclasses [
	^ theClass subclasses isNotEmpty
]
