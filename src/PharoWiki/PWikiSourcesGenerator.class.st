Class {
	#name : 'PWikiSourcesGenerator',
	#superclass : 'PWikiGenerator',
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'generating - public' }
PWikiSourcesGenerator >> classesToGenerate [
	"Return classes that came with the .sources — not registered in Epicea.
	 These are the classes that were part of the original Pharo image."
	| changesClasses |
	changesClasses := self changesClasses.
	^ Smalltalk allClasses
		reject: [ :c | changesClasses includes: c ]
]

{ #category : 'private' }
PWikiSourcesGenerator >> changesClasses [
	"Return the set of classes registered in Epicea as additions.
	 These are classes that were added after the image was created."
	^ ((EpMonitor current log entries
		select: [ :e | e content isKindOf: EpClassAddition ])
		collect: [ :e | e content classAdded realClass ]) asSet
]
