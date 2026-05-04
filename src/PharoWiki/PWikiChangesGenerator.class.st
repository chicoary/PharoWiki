Class {
	#name : 'PWikiChangesGenerator',
	#superclass : 'PWikiGenerator',
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'testing' }
PWikiChangesGenerator >> isProjectPackage: aClass [
	"Return true if aClass belongs to a package declared in the project baseline.
	 Classes in project packages go to wiki/changes/.
	 Classes in other packages go to wiki/libs/ via PWikiLibsGenerator."
	^ self projectPackageNames includes: aClass package name
]

{ #category : 'accessing' }
PWikiChangesGenerator >> projectPackageNames [
	"Package names that make up the project under development.
	 Read from the baseline, which is the source of truth for what is 'my project'.
	 See BaselineOfPharoWiki >> projectPackageNames."
	^ BaselineOfPharoWiki new projectPackageNames
]

{ #category : 'generating - public' }
PWikiChangesGenerator >> classesToGenerate [
	"Classes registered in Epicea as additions that belong to the project.
	 Project packages are declared in BaselineOfPharoWiki >> projectPackageNames.
	 Classes from external libraries are handled by PWikiLibsGenerator."
	^ ((EpMonitor current log entries
		select: [ :e | e content isKindOf: EpClassAddition ])
		collect: [ :e | e content classAdded realClass ])
		select: [ :c | self isProjectPackage: c ]
]
