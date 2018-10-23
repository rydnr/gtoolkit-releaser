Class {
	#name : #FkRlModelBuilder,
	#superclass : #Object,
	#instVars : [
		'projectsByBaselineClass',
		'projectsChain'
	],
	#category : #'Feenk-Releaser'
}

{ #category : #building }
FkRlModelBuilder >> buildPackageFromMetacelloSpec: aMetacelloPackageSpec [
	^ FkRlPackage new
		name: aMetacelloPackageSpec name;
		dependencies: aMetacelloPackageSpec requires
]

{ #category : #building }
FkRlModelBuilder >> buildProjectFromBaselineClass: aBaselineClass withRepositoryDescription: aRepositoryUrl [
	| newProject mcVersion |
	self assert: [ aBaselineClass project versions size = 1 ].
	
	mcVersion := aBaselineClass project versions first.
	newProject := FkRlProject new
		name: (MetacelloScriptEngine baseNameOf: aBaselineClass name); 
		repositorySpec: (self createRepositoriesSpecFor: aRepositoryUrl);
		baselineVersion: mcVersion;
		baselineClass: aBaselineClass.
	
	self updateDependenciesFor: newProject fromMCVersion: mcVersion.
	self projectsByBaselineClass at: aBaselineClass put: newProject.
	
	^ newProject
]

{ #category : #building }
FkRlModelBuilder >> buildProjectFromMetacelloSpec: aMetacelloProjectSpec [
	| newProject |
	self assert: [ aMetacelloProjectSpec project versions size = 1 ].
	self assert: [ aMetacelloProjectSpec repositorySpecs size = 1 ].
	
	"If the project was already created return the existing project.
	This does not initialize any dependencies as it assumes they are already initialized."
	(self projectsByBaselineClass includesKey: aMetacelloProjectSpec projectClass)
		ifTrue: [ ^ self projectsByBaselineClass at: aMetacelloProjectSpec projectClass ]
	
	"If this is the first time the project is encountered, create it and initalize its dependencies".
	newProject := self instantiateProjectFromMetacelloSpec: aMetacelloProjectSpec.
	self 
		updateDependenciesFor: newProject 
		fromMCVersion: aMetacelloProjectSpec version.
	
	"Only add the project to the "
	self projectsByBaselineClass at: aMetacelloProjectSpec projectClass put: newProject.
	
	^ newProject
]

{ #category : #'private - building' }
FkRlModelBuilder >> createRepositoriesSpecFor: aRepositoryUrl [
	^ MetacelloRepositoriesSpec new
			add: (MetacelloRepositorySpec new 
				description: aRepositoryUrl;
				yourself);
			yourself
]

{ #category : #initialize }
FkRlModelBuilder >> initialize [ 
	super initialize.
	projectsByBaselineClass := IdentityDictionary new.
	projectsChain := OrderedCollection new.
]

{ #category : #'private - building' }
FkRlModelBuilder >> instantiateProjectFromMetacelloSpec: aBaselineProjectSpec [
	^ FkRlProject new 
		name: (MetacelloScriptEngine baseNameOf: aBaselineProjectSpec projectClass name);
		repositorySpec: aBaselineProjectSpec version spec repositories;
		baselineVersion: aBaselineProjectSpec version;
		baselineClass: aBaselineProjectSpec projectClass 
]

{ #category : #accessing }
FkRlModelBuilder >> projectsByBaselineClass [
	^ projectsByBaselineClass
]

{ #category : #dependencies }
FkRlModelBuilder >> updateDependenciesFor: currentProject fromMCVersion: aMetacelloVersion [
	self 
		updateProjectDependenciesFor: currentProject 
		fromMCVersion: aMetacelloVersion.
	self 
		updatePackageDependenciesFor: currentProject
		fromMCVersion: aMetacelloVersion
]

{ #category : #dependencies }
FkRlModelBuilder >> updatePackageDependenciesFor: currentProject fromMCVersion: aMetacelloVersion [
	| newPackages |
	newPackages := aMetacelloVersion packages collect: [ :aMetacelloPackageSpec |
		self buildPackageFromMetacelloSpec: aMetacelloPackageSpec ].
	currentProject addPackages: newPackages
]

{ #category : #dependencies }
FkRlModelBuilder >> updateProjectDependenciesFor: currentProject fromMCVersion: aMetacelloVersion [
	| childProjects |
	childProjects := (aMetacelloVersion projects 
		select: [ :aMetacelloProjectSpec || shouldReject |
			shouldReject := aMetacelloProjectSpec version notNil and: [ 
				aMetacelloProjectSpec version name = 'baseline' ].
			shouldReject ifFalse: [ 
				('Ignoring dependency ', aMetacelloProjectSpec className, ' of ', currentProject name) logCr ].
			shouldReject ])
		collect: [ :aMCProjectSpec | 
			self buildProjectFromMetacelloSpec: aMCProjectSpec ].
	currentProject addChildProjects: childProjects.
]