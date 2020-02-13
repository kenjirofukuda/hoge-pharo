Class {
	#name : #HgRSCanvas,
	#superclass : #RSCanvas,
	#instVars : [
		'yFliped'
	],
	#category : #'Hoge-Roassal3'
}

{ #category : #initialization }
HgRSCanvas >> cameraClass [
	^ HgRSCamera
]

{ #category : #'morph creation' }
HgRSCanvas >> createMorph [
	"Create a Morph that contains myself."
	morph := HgRSAthensMorph new. 
	morph renderer: RSAthensRenderer new.
	morph canvas: self.
	^ morph
]

{ #category : #initialization }
HgRSCanvas >> initialize [
	super initialize.
	showRectangles := false.
	shapes := RSGroup new.
	fixedShapes := RSGroup new.
	nodes := RSGroup new.
	edges := RSGroup new.
	animations := OrderedCollection new.
	clearBackground := true.
	color := Color white.
	extent := 500@500.
	camera := self cameraClass new
		canvas: self;
		yourself.
	yFliped := false.
]

{ #category : #accessing }
HgRSCanvas >> yFliped [
	^ yFliped
]

{ #category : #accessing }
HgRSCanvas >> yFliped: aBoolean [
	yFliped := aBoolean
]
