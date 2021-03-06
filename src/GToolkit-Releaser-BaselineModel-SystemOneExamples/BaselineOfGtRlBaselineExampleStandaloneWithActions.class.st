Class {
	#name : #BaselineOfGtRlBaselineExampleStandaloneWithActions,
	#superclass : #BaselineOf,
	#category : #'GToolkit-Releaser-BaselineModel-SystemOneExamples'
}

{ #category : #baselines }
BaselineOfGtRlBaselineExampleStandaloneWithActions >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec preLoadDoIt: #'preloadAction:'.
		spec postLoadDoIt: #'postloadAction:'.
	].
]

{ #category : #baselines }
BaselineOfGtRlBaselineExampleStandaloneWithActions >> postloadAction: loader [
]

{ #category : #baselines }
BaselineOfGtRlBaselineExampleStandaloneWithActions >> preloadAction: loader [
]
