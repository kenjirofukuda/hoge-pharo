Class {
	#name : #HgGraphicViewMorph,
	#superclass : #BorderedMorph,
	#instVars : [
		'viewport',
		'document',
		'useNewCanvas',
		'offCanvas',
		'newCanvasEnabled',
		'toolClass',
		'showAxisLines',
		'showExtentBounds'
	],
	#category : #'Hoge-App'
}

{ #category : #drawing }
HgGraphicViewMorph >> clearOffCanvas [
	offCanvas := nil.
]

{ #category : #initialization }
HgGraphicViewMorph >> createViewport [
	| vp |
	vp := KFViewport new.
	vp model: self model.
	vp pixelBoundsSelector: #innerBounds.
	vp pixelBoundsTarget: self.
	vp announcer
		when: #viewTransformChanged
		do: [ 
			self clearOffCanvas.
			self changed ].
	^ vp
]

{ #category : #'event handling' }
HgGraphicViewMorph >> customMouseDown: aMouseButtonEvent [
	| track |
	track := self toolClass new
		event: aMouseButtonEvent copy;
		document: self document;
		yourself.
	self setProperty: #viewTracking toValue: track.
	(self isNavigarionClick: aMouseButtonEvent)
		ifTrue: [ self activeHand showTemporaryCursor: Cursor move hotSpotOffset: 16 @ 16 ]
]

{ #category : #'event handling' }
HgGraphicViewMorph >> customMouseMove: aMouseButtonEvent [
	self trackingObject
		ifNotNil: [ :track | 
			track currentEvent: aMouseButtonEvent copy.
			(self isNavigarionClick: aMouseButtonEvent)
				ifTrue: [ track viewMove ] ]
]

{ #category : #'event handling' }
HgGraphicViewMorph >> customMouseUp: aMouseButtonEvent [
	self trackingObject
		ifNotNil: [ :track | 
			track trackEnd.
			self removeProperty: #viewTracking.
			self activeHand showTemporaryCursor: nil. ]
]

{ #category : #'event handling' }
HgGraphicViewMorph >> customMouseWheel: event [
	| center dir localPoint |
	self viewport ifNil: [ ^ self ].
	localPoint := event cursorPoint - self innerBounds origin.
	center := self viewport worldPointFromLocal: localPoint.
	dir := 1.
	(KFEventSupport isWheelUpEvent: event)
		ifTrue: [ dir := 1.0 ].
	(KFEventSupport isWheelDownEvent: event)
		ifTrue: [ dir := -1.0 ].
	self viewport
		lockUpdateDuring: [ 
			self viewport portCenter: localPoint.
			self viewport viewCenter: center.
			self viewport zoom: 1.0 + (0.125 * dir) ]
]

{ #category : #accessing }
HgGraphicViewMorph >> document [
	^ document value
]

{ #category : #accessing }
HgGraphicViewMorph >> document: aHgGraphicDocumenmt [
 	document value: aHgGraphicDocumenmt.
	
]

{ #category : #drawing }
HgGraphicViewMorph >> drawAxisOn: aCanvas [
	| hvPoint |
	hvPoint := self viewport xy2hv: 0 @ 0.
	aCanvas line: (hvPoint x @ 0) to: (hvPoint x @ self extent y) color: Color black.
	aCanvas line: (0 @ hvPoint y) to: (self extent x @ hvPoint y) color: Color black.	
]

{ #category : #drawing }
HgGraphicViewMorph >> drawClasicCanvasOn: aCanvas [
	self showAxisLines
		ifTrue: [ self drawAxisOn: aCanvas ].
	self document
		ifNotNil: [ :doc | 
			doc graphics do: [ :each | each drawOn: aCanvas viewport: self viewport ].
			self showExtentBounds
				ifTrue: [ self drawExtentBoundsOn: aCanvas ] ]
]

{ #category : #drawing }
HgGraphicViewMorph >> drawExtentBoundsOn: aCanvas [
	| xyBounds hvBounds |
	xyBounds := self document bounds.
	hvBounds := (self viewport xy2hv: xyBounds origin)
		corner: (self viewport xy2hv: xyBounds corner).
	aCanvas frameRectangle: hvBounds color: self extentBoundsColor
]

{ #category : #drawing }
HgGraphicViewMorph >> drawLocalOn: aCanvas [
	offCanvas
		ifNil: [ 
			self useNewCanvas
				ifFalse: [ self drawClasicCanvasOn: self ensureOffCanvas ]
				ifTrue: [ self perform: #drawNewCanvasOn: with: self ensureOffCanvas ] ].
	aCanvas drawImage: self ensureOffCanvas form at: 0 @ 0
]

{ #category : #drawing }
HgGraphicViewMorph >> drawOn: aCanvas [
	super drawOn: aCanvas.
	aCanvas
		translateBy: self topLeft
		clippingTo: self clippingBounds
		during: [ :c | self drawLocalOn: c ]
]

{ #category : #drawing }
HgGraphicViewMorph >> ensureOffCanvas [
	^ offCanvas ifNil: [ 
		offCanvas := FormCanvas extent: self extent.
		offCanvas fillColor: Color white; yourself ]
]

{ #category : #geometry }
HgGraphicViewMorph >> extent: aPoint [
	super extent: aPoint.
	self viewport extent: aPoint.
	self clearOffCanvas.
	self announcer announce: #graphicViewResized
]

{ #category : #accessing }
HgGraphicViewMorph >> extentBoundsColor [
	^ Color veryLightGray
]

{ #category : #actions }
HgGraphicViewMorph >> fireFirstdrawing [
	"nop"
]

{ #category : #actions }
HgGraphicViewMorph >> fit [
	self viewport viewBounds: self document bounds.
]

{ #category : #actions }
HgGraphicViewMorph >> forceRedraw [
	self clearOffCanvas.
	self changed.
]

{ #category : #'events-processing' }
HgGraphicViewMorph >> handlesMouseDown: evt [
	^ true
]

{ #category : #'events-processing' }
HgGraphicViewMorph >> handlesMouseMove: evt [
	^ true
]

{ #category : #'events-processing' }
HgGraphicViewMorph >> handlesMouseUp: evt [
	^ true
]

{ #category : #'events-processing' }
HgGraphicViewMorph >> handlesMouseWheel: evt [
	^ true
]

{ #category : #initialization }
HgGraphicViewMorph >> initialize [
	super initialize.
	showAxisLines := true.
	showExtentBounds := true.
	document := nil asValueHolder.
	useNewCanvas  := self lookupNewCanvasEnabled asValueHolder.
	self on: #mouseDown send: #customMouseDown: to: self. 
	self on: #mouseMove send: #customMouseMove: to: self. 
	self on: #mouseUp send: #customMouseUp: to: self. 
	"can't handled #mouseWheel. direct override #mouseWheel: "
	"self on: #mouseWheel send: #customMouseWheel: to: self." 
	
	useNewCanvas whenChangedDo: [ self clearOffCanvas. self changed ]
	
]

{ #category : #testing }
HgGraphicViewMorph >> isNavigarionClick: aMouseButtonEvent [ 
	^ aMouseButtonEvent yellowButtonPressed 
]

{ #category : #private }
HgGraphicViewMorph >> lookupNewCanvasEnabled [
	^ ([ #MozCanvas asClass ]
		on: Error
		do: [ :ex | ex return: nil ])
		ifNil: [ false ]
		ifNotNil: [ :clazz | 
			([ clazz extent: 5 @ 5 ]
				on: Error "Windows dll moz2d dll not ready."
				do: [ :ex | ex return: nil ]) notNil ]
]

{ #category : #'events-processing' }
HgGraphicViewMorph >> mouseWheel: aMouseEvent [
	self customMouseWheel: aMouseEvent
]

{ #category : #testing }
HgGraphicViewMorph >> newCanvasEnabled [
	^ newCanvasEnabled := newCanvasEnabled ifNil: [ self lookupNewCanvasEnabled  ]
]

{ #category : #testing }
HgGraphicViewMorph >> showAxisLines [
	^ showAxisLines

]

{ #category : #accessing }
HgGraphicViewMorph >> showAxisLines: aBoolean [
	| changed1 |
	changed1 := showAxisLines ~= aBoolean.
	showAxisLines := aBoolean.
	changed1
		ifTrue: [ self forceRedraw ]
]

{ #category : #testing }
HgGraphicViewMorph >> showExtentBounds [
	^ showExtentBounds

]

{ #category : #accessing }
HgGraphicViewMorph >> showExtentBounds: aBoolean [
	| changed1 |
	changed1 := showExtentBounds ~= aBoolean.
	showExtentBounds := aBoolean.
	changed1
		ifTrue: [ self forceRedraw ]
]

{ #category : #accessing }
HgGraphicViewMorph >> toolClass [
	^ toolClass := toolClass ifNil: [ HgSelectTool ]
]

{ #category : #accessing }
HgGraphicViewMorph >> toolClass: aToolClass [
	toolClass := aToolClass
]

{ #category : #'event handling' }
HgGraphicViewMorph >> trackingObject [
	^ (self valueOfProperty: #viewTracking ifAbsent: [])
]

{ #category : #testing }
HgGraphicViewMorph >> useNewCanvas [
	^ useNewCanvas value
]

{ #category : #accessing }
HgGraphicViewMorph >> useNewCanvas: aBoolean [
	useNewCanvas value: aBoolean
]

{ #category : #accessing }
HgGraphicViewMorph >> viewport [
	^ viewport ifNil: [ viewport := self createViewport  ]
]
