Class {
	#name : #HgRSAthensMorph,
	#superclass : #RSAthensMorph,
	#instVars : [
		'offCanvas'
	],
	#category : #'Hoge-Roassal3'
}

{ #category : #'session management' }
HgRSAthensMorph >> checkSession [
	"The mechanism of session is useful in case you have a visualization open, save-and-quit the image, and open the image again.
	Naturally, you wish to see the visualization again. The session mechanism makes sure that low-level resources that belongs to Cairo are properly recreated"
	session == Smalltalk session ifTrue: [ ^ self ].
	surface := nil.
	offCanvas := nil.
	self createSurface.
	roassalCanvas shapes do: #sessionChanged.
	roassalCanvas fixedShapes do: #sessionChanged.
]

{ #category : #drawing }
HgRSAthensMorph >> drawOn: aCanvas [
	"Draw the whole visualization"

	isDrawing
		ifTrue: [ ^ self ].
	isDrawing := true.
	[ self checkSession.
	self recreateSurfaceIfNecessary.
	aCanvas fillRectangle: bounds color: roassalCanvas color.
	roassalCanvas playAnimations.
	offCanvas
		ifNil: [ 
			self drawShapes.
			offCanvas := FormCanvas extent: self innerBounds extent depth: 32.
			offCanvas fillRectangle: (0 @ 0 extent: bounds extent)color: roassalCanvas color.
			surface hasBeenFreed
				ifTrue: [ self createSurface ].
			[ offCanvas
				image: surface asForm
				at: 0 @ 0
				sourceRect: (0 @ 0 extent: surface extent)
				rule: 34 ]
				on: Exception
				do: [ :ex |  ] ].
	offCanvas
		ifNotNil: [ aCanvas drawImage: offCanvas form at: self innerBounds origin ] ]
		ensure: [ isDrawing := false ]
]

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
			floatCenter: roassalCanvas camera position
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

{ #category : #removing }
HgRSAthensMorph >> removeOffCanvas [
	offCanvas := nil.
]

{ #category : #signaling }
HgRSAthensMorph >> signalUpdate [
	self removeOffCanvas.
	super signalUpdate
]

{ #category : #accessing }
HgRSAthensMorph >> yFliped [
	^ self canvas yFliped
]
