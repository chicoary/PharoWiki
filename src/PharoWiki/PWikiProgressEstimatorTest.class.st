Class {
	#name : 'PWikiProgressEstimatorTest',
	#superclass : 'TestCase',
	#instVars : [ 'estimator' ],
	#category : 'PharoWiki-Tests',
	#package : 'PharoWiki',
	#tag : 'Tests'
}

{ #category : 'running' }
PWikiProgressEstimatorTest >> setUp [
	PWikiProgressEstimator reset.
	"Start 10 seconds in the past — gives us a known elapsed time."
	estimator := PWikiProgressEstimator startAt: DateAndTime now - 10 seconds
]

{ #category : 'tests - formatting' }
PWikiProgressEstimatorTest >> testFormatSecondsOnly [
	"Given 30000ms
	 When formatting
	 Then returns '~30s remaining'"
	self
		assert: (estimator formatMilliseconds: 30000)
		equals: '~30s remaining'
]

{ #category : 'tests - formatting' }
PWikiProgressEstimatorTest >> testFormatMinutesAndSeconds [
	"Given 90000ms (1m 30s)
	 When formatting
	 Then returns '~1m 30s remaining'"
	self
		assert: (estimator formatMilliseconds: 90000)
		equals: '~1m 30s remaining'
]

{ #category : 'tests - formatting' }
PWikiProgressEstimatorTest >> testFormatExactlyOneMinute [
	"Given 60000ms
	 When formatting
	 Then returns '~1m 0s remaining'"
	self
		assert: (estimator formatMilliseconds: 60000)
		equals: '~1m 0s remaining'
]

{ #category : 'tests - remaining' }
PWikiProgressEstimatorTest >> testReturnsEmptyWhenCounterIsZero [
	"Given counter = 0
	 When asking for remaining string
	 Then returns empty string"
	self
		assert: (estimator remainingStringFor: 0 of: 100)
		equals: ''
]

{ #category : 'tests - remaining' }
PWikiProgressEstimatorTest >> testReturnsStringWhenCounterIsPositive [
	"Given 10s elapsed, 10 classes done of 100
	 When asking for remaining string
	 Then returns a non-empty string with ' — '"
	| result |
	result := estimator remainingStringFor: 10 of: 100.
	self assert: (result includesSubstring: ' — ')
]

{ #category : 'tests - remaining' }
PWikiProgressEstimatorTest >> testUpdatesLastRatePerClass [
	"Given a completed estimation
	 When calling remainingStringFor:of:
	 Then LastRatePerClass is no longer nil"
	estimator remainingStringFor: 10 of: 100.
	self assert: PWikiProgressEstimator lastRatePerClass notNil
]

{ #category : 'tests - fallback' }
PWikiProgressEstimatorTest >> testFallbackWhenEstimateExceedsOneDay [
	"Given a known LastRatePerClass of 1000ms/class (set by a prior run)
	 And only 1 class processed in 10s (rate = 10000ms/class, remainder = huge)
	 When the estimate exceeds 24h
	 Then falls back to LastRatePerClass"
	| primedEstimator result |
	"Prime LastRatePerClass with a sane rate: 1000ms/class"
	primedEstimator := PWikiProgressEstimator startAt: DateAndTime now - 1000 seconds.
	primedEstimator remainingStringFor: 1000 of: 2000.
	"Now use a fresh estimator with only 1 class done in 10s — rate = 10000ms/class
	 remaining = 10000 * 99999 >> 24h — should fall back"
	result := estimator remainingStringFor: 1 of: 100000.
	self assert: (result includesSubstring: ' — ')
]
