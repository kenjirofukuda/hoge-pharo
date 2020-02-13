Class {
	#name : #HgRSAthensMorph,
	#superclass : #RSAthensMorph,
	#category : #'Hoge-Roassal3'
}

{ #category : #drawing }
HgRSAthensMorph >> drawShapes [
	"The drawing has to be done when a change in the shapes occured or when there is an animation."
	
	surface drawDuring: [ :athensCanvas | 
		| camera canvasRect |
		roassalCanvas clearBackground
			ifTrue: [ surface clear ].
		"We display the elements that are subject to the camera"
		camera := roassalCanvas camera.
		athensCanvas pathTransform
			translateBy: (self extent / 2) asFloatPoint;
			scaleBy: ((self flipedScale) * camera scale asFloat);
			translateBy: camera position negated asFloatPoint.
		renderer canvas: athensCanvas.
		canvasRect := Rectangle 
			rsCenter: roassalCanvas camera position
			extent: roassalCanvas extent / camera scale.
		roassalCanvas shapes do: [ :trachelShape | 
			(trachelShape encompassingRectangle intersects: canvasRect)
				ifTrue: [ 
					trachelShape accept: renderer ] ].
		self showRectanglesIfNecessary: roassalCanvas shapes.
		"We display the elements that are _NOT_ subject to the camera"
		athensCanvas pathTransform loadIdentity scaleBy: 1.0001.
		roassalCanvas fixedShapes do: [ :trachelShape | 
			trachelShape accept: renderer ].
		"debug mode to show encompassingRectangles"
		self showRectanglesIfNecessary: roassalCanvas fixedShapes. ]
		

]

{ #category : #accessing }
HgRSAthensMorph >> flipedScale [
	^ self yFliped ifTrue: [ 1.0 @ -1.0 ] ifFalse: [ 1.0 @ 1.0 ]
]

{ #category : #accessing }
HgRSAthensMorph >> yFliped [
	^ self canvas yFliped
]
