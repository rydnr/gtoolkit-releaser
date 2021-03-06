"
I am a release strategy that uses the current checked out branch as the release branch and that applies only to repository releases that have a single project release and no other dependencies.

I am a limited release that only makes a new commit, tags it and pushes to the remote origin. I should only be used for leaf projects that have no dependencies.
The main differences with other strategies are that I use the current branch and I make no changes to any files from the repository.

See ${method:GtRlLeafProjectReleaseStrategy>>#shouldCreateNewRelease}$ for the cases when I generate a new release.
"
Class {
	#name : #GtRlLeafProjectReleaseStrategy,
	#superclass : #GtRlSemanticTagReleaseStrategy,
	#category : #'GToolkit-Releaser'
}

{ #category : #assertions }
GtRlLeafProjectReleaseStrategy >> assertCompatibleWithRepository: aRepository [
	self 
		assert: [ aRepository projects size == 1 ] 
		description: 'This strategy can be used only for repositories with one project'.
	self 
		assert: [ aRepository projects first childProjects isEmpty ] 
		description: 'This strategy can be used only for repositories with one project with no dependencies' 
	
	
]

{ #category : #assertions }
GtRlLeafProjectReleaseStrategy >> assertOnlyAllowedChanges [
	| releaseCommit sourceDiff |
	
	releaseCommit := self releaseBranch commit.
	self assert: releaseCommit ancestors size = 1.
	
	sourceDiff := releaseCommit diffTo: releaseCommit parent.
	self assert: sourceDiff isEmpty.
]

{ #category : #printing }
GtRlLeafProjectReleaseStrategy >> description [
	^ 'LeafRelease'
]

{ #category : #initialization }
GtRlLeafProjectReleaseStrategy >> initializeFor: aRepositoryRelease fromConfiguration: aReleaseConfiguration [
	super initializeFor: aRepositoryRelease fromConfiguration: aReleaseConfiguration.
	self
		releaseBranchName: aRepositoryRelease icebergRepository branchName
]

{ #category : #testing }
GtRlLeafProjectReleaseStrategy >> shouldCreateNewRelease [
	| latestVersionTag |
	
	"1. If a new release if explicitly requested created it."
	self shouldForceNewRelease ifTrue: [ 
		^ true ].
	
	"2. If there is no release tag in the repository a new release is needed."
	self repositoryRelease semanticVersionTags ifEmpty: [
		^ true ].
	
	"3. If the latest release is not the head commit of the release branch generate a new release."
	latestVersionTag := self repositoryRelease latestSemanticVersionTag.
	(latestVersionTag commit = self releaseBranch commit) ifFalse: [
		^ true ].
	
	^ false
]

{ #category : #'actions - building' }
GtRlLeafProjectReleaseStrategy >> updateReleaseActionsUsing: anUpdateWorkflow [
	| commitAction |
	self repositoryRelease resetReleaseActions.
	self repositoryRelease isPassiveRelease ifTrue: [ ^ self ].
	
	commitAction := GtRlCommitAndTagReleaseAction new
		repositoryRelease: self repositoryRelease;
	 	order: anUpdateWorkflow nextActionOrder.
	self repositoryRelease addReleaseAction: commitAction.
	
]
