Class {
	#name : #HgRSCamera,
	#superclass : #RSCamera,
	#category : #'Hoge-Roassal3'
}

{ #category : #zoom }
HgRSCamera >> zoomToFit: anExtent rectangle: rect [
	| sc |
	sc := anExtent / (rect extent max: 0.01 @ 0.01).
	sc := sc x min: sc y.
	self 
		translateTo: rect rsCenter;
		scale: sc.
]
