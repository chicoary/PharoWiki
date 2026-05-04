Class {
	#name : 'PWikiLibsGenerator',
	#superclass : 'PWikiChangesGenerator',
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'generating - public' }
PWikiLibsGenerator >> classesToGenerate [
	"Classes registered in Epicea as additions that do NOT belong to the project.
	 These are external libraries loaded via .changes — context for the AI, but read-only."
	^ ((EpMonitor current log entries
		select: [ :e | e content isKindOf: EpClassAddition ])
		collect: [ :e | e content classAdded realClass ])
		reject: [ :c | self isProjectPackage: c ]
]
