Class {
	#name : #GtRlIceMinimalBranch,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'GToolkit-Releaser-BaselineModel-MinimalIceberg'
}

{ #category : #accessing }
GtRlIceMinimalBranch >> name [
	^ name
]

{ #category : #accessing }
GtRlIceMinimalBranch >> name: aString [
	name := aString
]

{ #category : #validating }
GtRlIceMinimalBranch >> validateIsBranch [
	^ true
]
