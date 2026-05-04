Class {
	#name : 'PWikiGeneratorRegistry',
	#superclass : 'Object',
	#instVars : [
		'sourcesGen',
		'changesGen',
		'libsGen'
	],
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'instance creation' }
PWikiGeneratorRegistry class >> sourcesGen: aSourcesGen changesGen: aChangesGen libsGen: aLibsGen [
	^ self new
		initializeSourcesGen: aSourcesGen
		changesGen: aChangesGen
		libsGen: aLibsGen
]

{ #category : 'initialization' }
PWikiGeneratorRegistry >> initializeSourcesGen: aSourcesGen changesGen: aChangesGen libsGen: aLibsGen [
	sourcesGen := aSourcesGen.
	changesGen := aChangesGen.
	libsGen := aLibsGen
]

{ #category : 'accessing' }
PWikiGeneratorRegistry >> generators [
	"All generators managed by this registry.
	 Used to prepare directories and write generation records."
	^ { sourcesGen. changesGen. libsGen }
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
PWikiGeneratorRegistry >> libsGen [
	^ libsGen
]

{ #category : 'accessing' }
PWikiGeneratorRegistry >> generatorFor: aClass [
	"Return the appropriate generator for aClass based on its origin.
	 Classes not in Epicea come from .sources.
	 Classes in Epicea go to changes/ if in project packages, libs/ otherwise."
	(EpMonitor current log entries
		anySatisfy: [ :e |
			(e content isKindOf: EpClassAddition)
			and: [ e content classAdded realClass = aClass ] ])
		ifFalse: [ ^ sourcesGen ].
	^ (changesGen isProjectPackage: aClass)
		ifTrue: [ changesGen ]
		ifFalse: [ libsGen ]
]
