Class {
	#name : #GtRlDocumentationExplorer,
	#superclass : #Object,
	#instVars : [
		'tutorialClasses',
		'howToGuideClasses',
		'explanationClasses',
		'exampleClasses'
	],
	#category : #'GToolkit-Releaser-ExamplesExplorer'
}

{ #category : #accessing }
GtRlDocumentationExplorer >> exampleClasses [
	^ exampleClasses ifNil: [ exampleClasses := OrderedCollection new ]
]

{ #category : #accessing }
GtRlDocumentationExplorer >> explanationClasses [
	^ explanationClasses ifNil: [ explanationClasses := OrderedCollection new ]
]

{ #category : #ui }
GtRlDocumentationExplorer >> gtViewExamplesListFor: aView [
	<gtView>
	^ aView list
		title: 'Examples' translated;
		priority: 25;
		items: [ self exampleClasses ]
]

{ #category : #ui }
GtRlDocumentationExplorer >> gtViewExplanationsListFor: aView [
	<gtView>
	^ aView list
		title: 'Explanations' translated;
		priority: 10;
		items: [ self explanationClasses ]
]

{ #category : #ui }
GtRlDocumentationExplorer >> gtViewHowToGuidesListFor: aView [
	<gtView>
	^ aView list
		title: 'How-to Guides' translated;
		priority: 15;
		items: [ self howToGuideClasses ]
]

{ #category : #ui }
GtRlDocumentationExplorer >> gtViewTutorialsListFor: aView [
	<gtView>
	^ aView list
		title: 'Tutorials' translated;
		priority: 20;
		items: [ self tutorialClasses ]
]

{ #category : #accessing }
GtRlDocumentationExplorer >> howToGuideClasses [
	^ howToGuideClasses ifNil: [ howToGuideClasses := OrderedCollection new ]
]

{ #category : #accessing }
GtRlDocumentationExplorer >> tutorialClasses [
	^ tutorialClasses ifNil: [ tutorialClasses := OrderedCollection new ]
]
