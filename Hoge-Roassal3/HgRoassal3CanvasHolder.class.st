Class {
	#name : #HgRoassal3CanvasHolder,
	#superclass : #Object,
	#instVars : [
		'canvas',
		'specUI',
		'wantsCreate'
	],
	#category : #'Hoge-Roassal3'
}

{ #category : #private }
HgRoassal3CanvasHolder >> adjustViewport [
	"canvas extent: self viewport extent."
	canvas camera zoomToFit: canvas extent rectangle: self viewport worldViewBounds.
]

{ #category : #private }
HgRoassal3CanvasHolder >> buildShapes [	
	canvas shapes copy do: #remove.
	self document graphics
		do: [ :m | 
			| e |
			e := self createPointShape: m.
			canvas addShape: e ] 
]

{ #category : #accessing }
HgRoassal3CanvasHolder >> canvas [ 
	^ canvas
]

{ #category : #private }
HgRoassal3CanvasHolder >> createPointShape: aHgPointGraphic [
	| e |
	e := RSEllipse new.
	e model: aHgPointGraphic.
	e withBorder.
	e size: aHgPointGraphic handleSize.
	e color: Color transparent.
	e position: aHgPointGraphic origin.
	^ e
]

{ #category : #accessing }
HgRoassal3CanvasHolder >> document [
	^ specUI delegate document
]

{ #category : #private }
HgRoassal3CanvasHolder >> graphicsChanged: aValueChanged [ 
	wantsCreate := true.
]

{ #category : #initialization }
HgRoassal3CanvasHolder >> initialize [
	canvas := HgRSCanvas new.
]

{ #category : #running }
HgRoassal3CanvasHolder >> run [
	| window |
	self adjustViewport.
	wantsCreate := true.
	self viewport announcer
		when: #viewTransformChanged
		do: [ self updateCanvas ].
	self document graphicsProperty whenChangedSend: #graphicsChanged: to: self.
	canvas newAnimation
		repeat;
		duration: 0.2 seconds;
		onStepDo: [ :t | 
			wantsCreate
				ifTrue: [ self buildShapes.
					wantsCreate := false ].
			self updateCanvas ].
	window := canvas
		openBeforeMorphBlock: [ :morph | 
			self setupAthensMorph: morph ].
	window setLabel: specUI title , '(Roassal3), ', window identityHash printString.
	"window isResizeable: false."
	window announcer
		when: WindowClosed
		do: [ self document graphicsProperty announcer unsubscribe: self ].
	specUI window window announcer
		when: WindowClosed
		do: [ window delete ].
	^ window
]

{ #category : #utility }
HgRoassal3CanvasHolder >> setCosmetic: aRSShape [
	| scale |
	aRSShape canvas ifNil: [ ^ self ].
	scale := aRSShape canvas camera scale.
	aRSShape size: aRSShape model pointDisplaySize / scale.
	aRSShape border width: 1 / scale
]

{ #category : #running }
HgRoassal3CanvasHolder >> setupAthensMorph: aRSAthensMorph [
"	canvas when: RSExtentChangedEvent do: [ aRSAthensMorph extent: specUI graphicView extent ].
	aRSAthensMorph changeNoLayout.
	aRSAthensMorph vResizing: #rigid.
	aRSAthensMorph hResizing: #rigid.	
	aRSAthensMorph extent: specUI graphicView extent"
]

{ #category : #accessing }
HgRoassal3CanvasHolder >> specUI: aHogeApp [
	specUI := aHogeApp.
]

{ #category : #private }
HgRoassal3CanvasHolder >> updateCanvas [
	self adjustViewport.
	(canvas shapes select: [ :e | e model isKindOf: HgPointGraphic ])
		do: [ :e | self setCosmetic: e ].
	canvas signalUpdate
]

{ #category : #accessing }
HgRoassal3CanvasHolder >> viewport [ 
	^ specUI graphicView morph viewport.
]
