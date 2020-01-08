"
A KFViewport is Pluggable coordinate transformer.

Instance Variables
	grid:		<KFViewGrid>
	lastPoint:		<Object>
	model:		<Object>
	pixelBoundsSelector:		<Symbol>
	pixelBoundsTarget:		<Object>
	scale:		<Float>
	viewCenter:		<Point>
	wTrans:		<MatrixTransform2x3>

grid
	- xxxxx

lastPoint
	- xxxxx

model
	- xxxxx

pixelBoundsSelector
	- xxxxx

pixelBoundsTarget
	- xxxxx

scale
	- xxxxx

viewCenter
	- xxxxx

wTrans
	- xxxxx

"
Class {
	#name : #KFViewport,
	#superclass : #Object,
	#instVars : [
		'scale',
		'grid',
		'viewCenter',
		'pixelBoundsSelector',
		'pixelBoundsTarget',
		'model',
		'fittingRatio',
		'portCenter',
		'transformStack',
		'basicTransform',
		'transform',
		'extent',
		'lockUpdate',
		'updateCount',
		'announcer'
	],
	#category : #Hoge
}

{ #category : #'as yet unclassified' }
KFViewport class >> defaultFittingRatio [ 
	^0.98.
]

{ #category : #accessing }
KFViewport >> absoluteScale [
	^ self transform a11 abs
]

{ #category : #accessing }
KFViewport >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #transforms }
KFViewport >> basicTransform [
	^ basicTransform ifNil: [ basicTransform := self lookupBasicTransform ].

]

{ #category : #testing }
KFViewport >> canGridDraw [
	^ self grid displayMultiply ~= 0
		and: [ (self gridScale x * self absoluteScale) asFloat * self grid displayMultiply > 8.0 ]
]

{ #category : #private }
KFViewport >> damageTransform [
	lockUpdate ifTrue: [ updateCount := updateCount + 1. ^  self ].
	basicTransform := nil.
	transform := nil.
	self announcer announce: #viewTransformChanged.
]

{ #category : #defaults }
KFViewport >> defaultFittingRatio [ 
	^ 0.98.
]

{ #category : #accessing }
KFViewport >> extent [
	^ extent
]

{ #category : #drawing }
KFViewport >> extent: aPoint [
	extent := aPoint.
	self damageTransform.

]

{ #category : #accessing }
KFViewport >> fittingRatio [
	^ fittingRatio
]

{ #category : #accessing }
KFViewport >> fittingRatio: aFloat [
	fittingRatio := (aFloat > 1.0 or: [ aFloat < 0.5 ])
		ifTrue: [ self defaultFittingRatio ]
		ifFalse: [ aFloat ]
]

{ #category : #accessing }
KFViewport >> grid [
	grid ifNil: [ grid := KFViewGrid new ].
	^ grid
]

{ #category : #accessing }
KFViewport >> grid: aGrid [
	grid := aGrid.
	self changed
]

{ #category : #accessing }
KFViewport >> gridOffset [
	^ self grid offset
]

{ #category : #accessing }
KFViewport >> gridScale [
	^ self grid scale
]

{ #category : #initialization }
KFViewport >> initialize [
	super initialize.
	fittingRatio := self defaultFittingRatio.
	transformStack := OrderedCollection new.
	lockUpdate := false.
	scale := 1.0 asValueHolder.
	viewCenter := (0 @ 0) asValueHolder.
	portCenter := (0 @ 0) asValueHolder.
	{ portCenter . scale . viewCenter } 
		do: [ :slot | 
			slot whenChangedSend: #damageTransform to: self ].

]

{ #category : #accessing }
KFViewport >> lockUpdateDuring: aBlock [
	updateCount := 0.
	lockUpdate := true.
	aBlock value.
	lockUpdate := false.
	updateCount > 0
		ifTrue: [ self damageTransform ].
	updateCount := 0
]

{ #category : #lookup }
KFViewport >> lookupBasicTransform [
	| m |
	m := MatrixTransform2x3 new.
	m setScale: (1 @ -1).
	m setOffset: (0 @ self pixelBounds extent y).	
	m := m composedWithLocal: (MatrixTransform2x3 withOffset: self portCenter).
	m := m composedWithLocal: (MatrixTransform2x3 withScale: self viewScale asPoint).
	m := m composedWithLocal: (MatrixTransform2x3 withOffset: self viewCenter negated).
	^m	
]

{ #category : #lookup }
KFViewport >> lookupHorizontalGridSteps [
	^self grid 
		lookupGridStepsMin: self worldViewMinX 
		max: self worldViewMaxX 
		gridScale: (self gridScale x * self grid displayMultiply) gridOffset: self gridOffset x
	
]

{ #category : #lookup }
KFViewport >> lookupTransform [
	| newTransform |
	newTransform := MatrixTransform2x3 identity.
	newTransform := newTransform composedWithLocal: self basicTransform.
	transformStack do: [ :tx | newTransform := newTransform composedWithLocal: tx ].
	"self announcer announce: #viewTransformChanged."
	^newTransform
	
]

{ #category : #lookup }
KFViewport >> lookupVerticalGridSteps [
	^self grid 
		lookupGridStepsMin: self worldViewMinY 
		max: self worldViewMaxY 
		gridScale: (self gridScale y * self grid displayMultiply) gridOffset: self gridOffset y

	
	
]

{ #category : #viewing }
KFViewport >> marginBounds: aBaseBounds [
	| growFactor growWidth growHeight|
	growFactor := (self fittingRatio reciprocal) - 1.0.
	growWidth := (aBaseBounds width * growFactor) * 0.5.
	growHeight := (aBaseBounds height * growFactor) * 0.5.
	^aBaseBounds expandBy: (growWidth@growHeight).
	 
]

{ #category : #viewing }
KFViewport >> maxScaleLimit [
	^1000.
]

{ #category : #viewing }
KFViewport >> minScaleLimit [
	^self maxScaleLimit reciprocal asFloat.
]

{ #category : #initialization }
KFViewport >> model: aModel [
	model := aModel.
	
	
]

{ #category : #transforms }
KFViewport >> morphicPointFromGlobal:  aGlobalPoint [
	^aGlobalPoint - self pixelBounds origin.
]

{ #category : #private }
KFViewport >> pixelBounds [
	^pixelBoundsTarget perform: pixelBoundsSelector.
]

{ #category : #initialization }
KFViewport >> pixelBoundsSelector: aSelector [
	pixelBoundsSelector := aSelector.
	
	
]

{ #category : #initialization }
KFViewport >> pixelBoundsTarget: aTarget [
	self assert: [aTarget isNil not].
	pixelBoundsTarget := aTarget.	
	
]

{ #category : #transforms }
KFViewport >> pixelSize: aWorldSize [
	^(self xy2hv: aWorldSize asPoint) dist: (self xy2hv: 0 asPoint)
]

{ #category : #private }
KFViewport >> popTransform [
	| result |
	result := transformStack last. 
	transformStack := transformStack allButLast.
	transform := nil.
	^result.
]

{ #category : #accessing }
KFViewport >> portCenter [
	^ portCenter value.
]

{ #category : #accessing }
KFViewport >> portCenter: aPoint [
	portCenter value: aPoint x @ (self pixelBounds extent y - aPoint y)
]

{ #category : #private }
KFViewport >> pushTransform: aMatrixTransform2x3 [
	self assert: aMatrixTransform2x3 isNil not.
	transformStack add: aMatrixTransform2x3.
	transform := nil.
]

{ #category : #drawing }
KFViewport >> pushTransform: aMatrixTransform2x3 during: aBlock [
	self pushTransform: aMatrixTransform2x3.
	aBlock value.
	self popTransform
]

{ #category : #viewing }
KFViewport >> resetPortCenter [
	self portCenter: self pixelBounds extent / 2.0.
	self viewScale: 1.0.
	self viewCenter: 0 @ 0
]

{ #category : #initialization }
KFViewport >> scaleProperty [
	^ scale
	
]

{ #category : #transforms }
KFViewport >> snapedWorldPoint:  aWorldPoint [
	^(GeometryUtils point: aWorldPoint roundTo: (self gridScale)) + self gridOffset.
]

{ #category : #transforms }
KFViewport >> snapedWorldPointFromGlobal:  aGlobalPoint [
	^self snapedWorldPoint: (self worldPointFromGlobal: aGlobalPoint).
]

{ #category : #transforms }
KFViewport >> transform [
	transform ifNil: [ transform := self lookupTransform  ].
	^ transform
]

{ #category : #accessing }
KFViewport >> updatePortBy: aKFViewport [
	self portCenter: aKFViewport portCenter.
	self viewCenter: aKFViewport viewCenter.
	self viewScale: aKFViewport viewScale
]

{ #category : #accessing }
KFViewport >> viewBounds: aWorldBounds [
	| hRatio vRatio scalingFactor centerPoint |
	scalingFactor := 1.
	hRatio := [ (self pixelBounds width / aWorldBounds width) asFloat ]
		on: Error
		do: [ :ex | ex return: 1 ].
	vRatio := [ (self pixelBounds height / aWorldBounds height) asFloat ]
		on: Error
		do: [ :ex | ex return: 1 ].
	scalingFactor := hRatio min: vRatio.
	centerPoint := (aWorldBounds origin + aWorldBounds corner) / 2.0.
	self
		lockUpdateDuring: [ self portCenter: self pixelBounds extent / 2.0.
			self viewScale: scalingFactor.
			self viewCenter: centerPoint ]
]

{ #category : #accessing }
KFViewport >> viewCenter [
	^ viewCenter value
	
]

{ #category : #accessing }
KFViewport >> viewCenter: aPoint [
	viewCenter value: aPoint

]

{ #category : #viewing }
KFViewport >> viewFit [
	self viewBounds: (self marginBounds: (model dataExtentForFittingView)).
	 
]

{ #category : #viewing }
KFViewport >> viewMove: aFractionPoint [
	self viewMoveFractionX: aFractionPoint x y: aFractionPoint y.

]

{ #category : #viewing }
KFViewport >> viewMoveFractionX: aXfraction y: aYfraction [	
	| xDelta yDelta newCenter |
	xDelta := self worldViewWidth * aXfraction.
	yDelta := self worldViewHeight * aYfraction.	
	newCenter := self viewCenter + (xDelta@yDelta).
	self viewCenter: newCenter.
	
]

{ #category : #accessing }
KFViewport >> viewScale [
	^ scale value.
]

{ #category : #accessing }
KFViewport >> viewScale: aScale [
	aScale < self minScaleLimit
		ifTrue: [ 
			Transcript
				cr;
				show: '*** WARNING *** minimam scale limit.'.
			^ self ].
	aScale > self maxScaleLimit
		ifTrue: [ 
			Transcript
				cr;
				show: '*** WARNING *** maximam scale limit.'.
			^ self ].
	scale value: aScale
]

{ #category : #transforms }
KFViewport >> worldPointFromGlobal:  aGlobalPoint [
	^self transform invertPoint: (self morphicPointFromGlobal: aGlobalPoint).
]

{ #category : #transforms }
KFViewport >> worldPointFromLocal:  aMorphcLocalPoint [
	^self transform invertPoint: aMorphcLocalPoint
]

{ #category : #'world-geometry' }
KFViewport >> worldViewBounds [
	^Rectangle origin: self worldViewOrigin corner: self worldViewCorner.
	
]

{ #category : #'world-geometry' }
KFViewport >> worldViewCorner [
	| globalPoint |
	globalPoint := self pixelBounds right@self pixelBounds top.
	^self worldPointFromGlobal: globalPoint.
	
]

{ #category : #'world-geometry' }
KFViewport >> worldViewHeight [
	^self worldViewMaxY - self worldViewMinY.
	
]

{ #category : #'world-geometry' }
KFViewport >> worldViewMaxX [
	^self worldViewCorner x.
]

{ #category : #'world-geometry' }
KFViewport >> worldViewMaxY [
	^self worldViewCorner y.
]

{ #category : #'world-geometry' }
KFViewport >> worldViewMinX [
	^self worldViewOrigin x.
]

{ #category : #'world-geometry' }
KFViewport >> worldViewMinY [
	^self worldViewOrigin y.
]

{ #category : #'world-geometry' }
KFViewport >> worldViewOrigin [
	| globalPoint |
	globalPoint := self pixelBounds left@self pixelBounds bottom.
	^self worldPointFromGlobal: globalPoint.
	
]

{ #category : #'world-geometry' }
KFViewport >> worldViewWidth [
	^self worldViewMaxX - self worldViewMinX.
	
]

{ #category : #transforms }
KFViewport >> xy2hv: aWorldPoint [
	^self xy2hv: aWorldPoint transform: self transform
]

{ #category : #transforms }
KFViewport >> xy2hv: aWorldPoint transform: aMatrixTransform2x3 [
	| np1 |
	(aWorldPoint isPoint)
		ifFalse: [  ].
	np1 := aMatrixTransform2x3 localPointToGlobal: aWorldPoint.	"np1 := GeometryUtils point: np1 roundTo: 1.0."
	^ GeometryUtils limitedPoint: np1 rounded
]

{ #category : #transforms }
KFViewport >> xy2hvPoints: aPointArray [
	^aPointArray collect: 
		[:each | self xy2hv: each]. 
]

{ #category : #viewing }
KFViewport >> zoom: aNumber [
	self viewScale: self viewScale * aNumber.
	
]
