Class {
	#name : #BaselineOfPharoWiki,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoWiki
}

{ #category : #baselines }
BaselineOfPharoWiki >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			spec
				package: 'PharoWiki'
				with: [ spec requires: #() ].
			spec
				group: 'Core'
				with: #('PharoWiki').
			spec
				group: 'Tests'
				with: #('PharoWiki').
			spec
				group: 'default'
				with: #('Core' 'Tests') ]
]
