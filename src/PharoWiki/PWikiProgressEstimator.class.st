Class {
	#name : 'PWikiProgressEstimator',
	#superclass : 'Object',
	#classVars : [
		'LastRatePerClass',
		'OneDayMs'
	],
	#instVars : [ 'startTime' ],
	#category : 'PharoWiki-Core',
	#package : 'PharoWiki',
	#tag : 'Core'
}

{ #category : 'initialization' }
PWikiProgressEstimator class >> initialize [
	"24 * 60 * 60 * 1000"
	OneDayMs := 86400000
]

{ #category : 'accessing' }
PWikiProgressEstimator class >> lastRatePerClass [
	^ LastRatePerClass
]

{ #category : 'initialization' }
PWikiProgressEstimator class >> reset [
	"For testing — clears LastRatePerClass to avoid interference between tests."
	LastRatePerClass := nil
]

{ #category : 'instance creation' }
PWikiProgressEstimator class >> start [
	^ self new initializeStart
]

{ #category : 'instance creation' }
PWikiProgressEstimator class >> startAt: aDateAndTime [
	"For testing — allows injecting a fixed start time."
	^ self new initializeStartAt: aDateAndTime
]

{ #category : 'initialization' }
PWikiProgressEstimator >> initializeStart [
	startTime := DateAndTime now
]

{ #category : 'initialization' }
PWikiProgressEstimator >> initializeStartAt: aDateAndTime [
	startTime := aDateAndTime
]

{ #category : 'accessing' }
PWikiProgressEstimator >> elapsedMilliseconds [
	^ (DateAndTime now - startTime) totalSeconds * 1000
]

{ #category : 'accessing' }
PWikiProgressEstimator >> remainingStringFor: counter of: total [
	"Return a human-readable estimate of remaining time.
	 Returns empty string if counter is zero (no data yet).
	 If the estimate exceeds 24 hours (likely noise from small counter),
	 falls back to LastRatePerClass from the previous run."
	| elapsed ratePerClass remainingMs |
	counter = 0 ifTrue: [ ^ '' ].
	elapsed := self elapsedMilliseconds.
	ratePerClass := elapsed / counter.
	remainingMs := ratePerClass * (total - counter).
	(remainingMs > OneDayMs and: [ LastRatePerClass notNil ]) ifTrue: [
		ratePerClass := LastRatePerClass.
		remainingMs := ratePerClass * (total - counter) ].
	LastRatePerClass := ratePerClass.
	^ ' — ', (self formatMilliseconds: remainingMs asInteger)
]

{ #category : 'private - formatting' }
PWikiProgressEstimator >> formatMilliseconds: ms [
	"Format milliseconds as:
	 - '~Xs remaining'        when under 1 minute
	 - '~Xm Ys remaining'     when under 1 hour
	 - '~Xh Ym Zs remaining'  when 1 hour or more"
	| totalSeconds hours minutes seconds |
	totalSeconds := ms // 1000.
	hours := totalSeconds // 3600.
	minutes := (totalSeconds \\ 3600) // 60.
	seconds := totalSeconds \\ 60.
	hours > 0 ifTrue: [
		^ '~', hours printString, 'h ', minutes printString, 'm ', seconds printString, 's remaining' ].
	minutes > 0 ifTrue: [
		^ '~', minutes printString, 'm ', seconds printString, 's remaining' ].
	^ '~', seconds printString, 's remaining'
]
