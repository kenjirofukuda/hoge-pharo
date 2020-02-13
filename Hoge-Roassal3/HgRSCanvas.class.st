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

{ #category : #accessing }
HgRSCanvas >> clipedShapes [
	| canvasRect |
	canvasRect := Rectangle
		rsCenter: self camera position
		extent: self extent / camera scale.
	^ self shapes
		select:
			[ :trachelShape | trachelShape encompassingRectangle intersects: canvasRect ]
]

{ #category : #'morph creation' }
HgRSCanvas >> createMorph [
	"Create a Morph that contains myself."
	morph := HgRSAthensMorph new. 
	morph renderer: HgRSAthensRenderer new.
	morph canvas: self.
	self announcer when: RSScaleChangedEvent do: [ morph removeOffCanvas ].
	self announcer when: RSPositionChangedEvent do: [ morph removeOffCanvas ].	
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
