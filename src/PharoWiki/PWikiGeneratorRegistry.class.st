Class {
	#name : 'PWikiGeneratorRegistry',
	#superclass : 'Object',
	#instVars : [
		'sourcesGen',
		'changesGen'
	],
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'instance creation' }
PWikiGeneratorRegistry class >> sourcesGen: aSourcesGen changesGen: aChangesGen [
	^ self new
		initializeSourcesGen: aSourcesGen
		changesGen: aChangesGen
]

{ #category : 'initialization' }
PWikiGeneratorRegistry >> initializeSourcesGen: aSourcesGen changesGen: aChangesGen [
	sourcesGen := aSourcesGen.
	changesGen := aChangesGen
]

{ #category : 'accessing' }
PWikiGeneratorRegistry >> generators [
	"All generators managed by this registry.
	 Used to prepare directories and write generation records."
	^ { sourcesGen. changesGen }
]

{ #category : 'accessing' }
PWikiGeneratorRegistry >> sourcesGen [
	^ sourcesGen
]

{ #category : 'accessing' }
PWikiGeneratorRegistry >> changesGen [
	^ changesGen
]

{ #category : 'accessing' }
PWikiGeneratorRegistry >> generatorFor: aClass [
	"Return the appropriate generator for aClass based on its origin.
	 Classes registered in Epicea were added via .changes; others come from .sources."
	^ (EpMonitor current log entries
		anySatisfy: [ :e |
			(e content isKindOf: EpClassAddition)
			and: [ e content classAdded realClass = aClass ] ])
		ifTrue: [ changesGen ]
		ifFalse: [ sourcesGen ]
]
