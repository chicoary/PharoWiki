Class {
	#name : 'PWikiChangesGenerator',
	#superclass : 'PWikiGenerator',
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'generating - public' }
PWikiChangesGenerator >> classesToGenerate [
	"Return classes registered in Epicea as additions — added via .changes.
	 These are classes that were loaded into the image after it was created."
	^ ((EpMonitor current log entries
		select: [ :e | e content isKindOf: EpClassAddition ])
		collect: [ :e | e content classAdded realClass ]) asArray
]
