Class {
	#name : #HgRoassal3CanvasHolderSpec,
	#superclass : #Object,
	#instVars : [
		'canvas',
		'specUI',
		'wantsCreate'
	],
	#category : #'Hoge-Roassal3'
}

{ #category : #private }
HgRoassal3CanvasHolderSpec >> adjustViewport [
	"canvas extent: self viewport extent."
	canvas camera zoomToFit: canvas extent rectangle: self viewport worldViewBounds.
]

{ #category : #private }
HgRoassal3CanvasHolderSpec >> buildShapes [	
	canvas shapes copy do: #remove.
	self document graphics
		do: [ :m | 
			| e |
			e := self createPointShape: m.
			canvas addShape: e ] 
]

{ #category : #accessing }
HgRoassal3CanvasHolderSpec >> canvas [ 
	^ canvas
]

{ #category : #private }
HgRoassal3CanvasHolderSpec >> createPointShape: aHgPointGraphic [
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
HgRoassal3CanvasHolderSpec >> document [
	^ specUI delegate document
]

{ #category : #private }
HgRoassal3CanvasHolderSpec >> graphicsChanged: aValueChanged [ 
	wantsCreate := true.
]

{ #category : #initialization }
HgRoassal3CanvasHolderSpec >> initialize [
	canvas := HgRSCanvas new.
	canvas yFliped: true.
]

{ #category : #accessing }
HgRoassal3CanvasHolderSpec >> masterWindow [ 
	^ specUI window window.
]

{ #category : #running }
HgRoassal3CanvasHolderSpec >> openWindow [
	| window |
	window := canvas
		openBeforeMorphBlock: [ :morph | self setupAthensMorph: morph ].
	window
		setLabel: specUI title , '(Roassal3), ' , window identityHash printString.
	"window isResizeable: false."
	window announcer
		when: WindowClosed
		do: [ self document graphicsProperty announcer unsubscribe: self ].
	self masterWindow announcer
		when: WindowClosed
		do: [ window delete ].
	self masterWindow announcer
		when: WindowResizing
		do: [ :ann | 
			self flag: 'TODO: canvas not strict same. status height, menubar height lessen'.
			window extent: ann newSize ].
	^ window
]

{ #category : #running }
HgRoassal3CanvasHolderSpec >> run [
	self adjustViewport.
	wantsCreate := true.
	self viewport announcer
		when: #viewTransformChanged
		do: [ self updateCanvas ].
	self document graphicsProperty
		whenChangedSend: #graphicsChanged:
		to: self.
	canvas newAnimation
		repeat;
		duration: 0.2 seconds;
		onStepDo: [ :t | 
			wantsCreate
				ifTrue: [ self buildShapes.
					wantsCreate := false ].
			self updateCanvas ].
	^ self openWindow 
]

{ #category : #utility }
HgRoassal3CanvasHolderSpec >> setCosmetic: aRSShape [
	| scale |
	aRSShape canvas ifNil: [ ^ self ].
	scale := aRSShape canvas camera scale.
	aRSShape size: aRSShape model pointDisplaySize / scale.
	aRSShape border width: 1 / scale
]

{ #category : #running }
HgRoassal3CanvasHolderSpec >> setupAthensMorph: aRSAthensMorph [
"	canvas when: RSExtentChangedEvent do: [ aRSAthensMorph extent: specUI graphicView extent ]."
	aRSAthensMorph changeNoLayout.
	"aRSAthensMorph vResizing: #rigid."
	"aRSAthensMorph hResizing: #rigid.	"
	aRSAthensMorph extent: specUI graphicView extent
]

{ #category : #accessing }
HgRoassal3CanvasHolderSpec >> specUI: aHogeApp [
	specUI := aHogeApp.
]

{ #category : #private }
HgRoassal3CanvasHolderSpec >> updateCanvas [
	self adjustViewport.
	(canvas shapes select: [ :e | e model isKindOf: HgPointGraphic ])
		do: [ :e | self setCosmetic: e ].
	canvas signalUpdate
]

{ #category : #accessing }
HgRoassal3CanvasHolderSpec >> viewport [ 
	^ specUI graphicView morph viewport.
]
