Class {
	#name : #GtRlMajorVersionComputation,
	#superclass : #GtRlSymbolicVersionComputation,
	#category : #'GToolkit-Releaser'
}

{ #category : #accessing }
GtRlMajorVersionComputation >> nextSemanticVersionFrom: aSemanticVersion [
	^ GtRlSemanticVersion 
		major: aSemanticVersion major + 1
		minor: aSemanticVersion minor 
		patch: aSemanticVersion patch
]