Class {
	#name : #GtRlLeafProjectReleaseStrategy,
	#superclass : #GtRlSemanticTagReleaseStrategy,
	#category : #'GToolkit-Releaser'
}

{ #category : #actions }
GtRlLeafProjectReleaseStrategy >> commitAndTagRelease [
	| iceRepository |
	iceRepository := self repositoryRelease icebergRepository.
	self 
		assert: [ iceRepository branchName = self referenceBranchName ]
		description: 'The Iceberg repository needs to be on the release branch.'.
	self repositoryRelease commitAndTagRelease
]

{ #category : #printing }
GtRlLeafProjectReleaseStrategy >> description [
	^ 'LeafRelease'
]

{ #category : #accessing }
GtRlLeafProjectReleaseStrategy >> releaseBranchName [
	^ self referenceBranch 
]

{ #category : #accessing }
GtRlLeafProjectReleaseStrategy >> updateFor: anUpdateWorkflow [
	| latestVersionTag |
	
	"1. If a new release if explicitly requested created it."
	self shouldForceNewRelease ifTrue: [ 
		^ self configureNewVersionReleaseUsing: anUpdateWorkflow ].
	
	"2. If there is no release tag in the repository a new release is needed."
	self repositoryRelease semanticVersionTags ifEmpty: [
		^ self configureNewVersionReleaseUsing: anUpdateWorkflow ].
	
	"3. If the latest release is not the head commit of the reference branch generate a new release."
	latestVersionTag := self repositoryRelease latestSemanticVersionTag.
	(latestVersionTag commit = self referenceBranch commit) ifFalse: [
		^ self configureNewVersionReleaseUsing: anUpdateWorkflow ].
	
	"Use the latest releae instead of generating a new one."
	^ self repositoryRelease 
		version: latestVersionTag gtAsSemanticVersionNumber;
		resetReleaseActions
]

{ #category : #'private - actions' }
GtRlLeafProjectReleaseStrategy >> updateReleaseActionsUsing: anUpdateWorkflow [
	| commitAction |
	self repositoryRelease resetReleaseActions.
	
	commitAction := GtRlCommitAndTagReleaseAction new
		repositoryRelease: self repositoryRelease;
	 	order: anUpdateWorkflow nextActionOrder.
	self repositoryRelease addReleaseAction: commitAction
]