Class {
	#name : #HgRSCanvas,
	#superclass : #RSCanvas,
	#category : #'Hoge-Roassal3'
}

{ #category : #'morph creation' }
HgRSCanvas >> createMorph [
	"Create a Morph that contains myself."
	morph := HgRSAthensMorph new. 
	morph renderer: RSAthensRenderer new.
	morph canvas: self.
	^ morph
]
