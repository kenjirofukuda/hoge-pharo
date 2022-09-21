Class {
	#name : #HgGraphicDocument,
	#superclass : #Object,
	#instVars : [
		'graphics',
		'editingState'
	],
	#category : #'Hoge-App'
}

{ #category : #'redo-undo' }
HgGraphicDocument >> addCreateGraphicUndoRecord: aNewGraphic [
	self editingState
		redoArray:
			{self.
			#redoCreateGraphic:.
			{aNewGraphic}}
		undoArray:{self.
			#undoCreateGraphic:.
			{aNewGraphic}}
]

{ #category : #'redo-undo' }
HgGraphicDocument >> addCreateGraphicsUndoRecord: aNewGraphics [
	self editingState
		redoArray:
			{self.
			#redoCreateGraphics:.
			{aNewGraphics}}
		undoArray:{self.
			#undoCreateGraphics:.
			{aNewGraphics}}
]

{ #category : #'redo-undo' }
HgGraphicDocument >> addDeleteSelectionUndoRecord [
	self editingState
		redoArray:
			{self.
			#redoDeleteSelection:.
			{self selectedGraphics}}
		undoArray:
			{self.
			#undoDeleteSelection:.
			{self selectedGraphics}}
]

{ #category : #adding }
HgGraphicDocument >> addGraphic: aHgGraphic [
	self assert: (aHgGraphic isKindOf: HgGraphic).
	self addGraphics: (Array with: aHgGraphic)
]

{ #category : #adding }
HgGraphicDocument >> addGraphics: aHgGraphicCollection [
	self assert: aHgGraphicCollection isCollection. 
	graphics addAll: aHgGraphicCollection	
]

{ #category : #accessing }
HgGraphicDocument >> appConfigDirectory [
	^ (OSPlatform current userConfigDirectory / 'hoge')
			ensureCreateDirectory;
			yourself
]

{ #category : #accessing }
HgGraphicDocument >> appConfigFile [
	^ self appConfigDirectory  / 'hoge.csv'.
]

{ #category : #accessing }
HgGraphicDocument >> bounds [
	| bounds |
	bounds := GeometryUtils minusBounds.
	graphics do: [ :g | bounds := bounds quickMerge: g bounds ].
	^ bounds
]

{ #category : #actions }
HgGraphicDocument >> createSampleGraphicsXmin: aXmin yMin: aYmin xMax: aXmax yMax: aYmax step: aStep [
	^ Array
		streamContents: [ :arrayStream | 
			100
				timesRepeat: [ | x y |
					x := (aXmin to: aXmax by: aStep) atRandom.
					y := (aYmin to: aYmax by: aStep) atRandom.
					arrayStream
						<<
							(HgPointGraphic new
								origin: x @ y;
								yourself) ] ]
]

{ #category : #accessing }
HgGraphicDocument >> editingState [
	^ editingState ifNil: [editingState := self editingStateClass new]
]

{ #category : #accessing }
HgGraphicDocument >> editingStateClass [
	^ HgEditingState
]

{ #category : #accessing }
HgGraphicDocument >> findGraphicAt: aPoint pixelDistance: aPixel worldScale: aScale [
	^ self graphics
		ifEmpty: [ nil ]
		ifNotEmpty: [ | foundPair |
			foundPair := ((self graphics
				collect: [ :each | Array with: each with: (each distance: aPoint) ])
				sort: [ :a :b | (a at: 2) < (b at: 2) ]) first.
			((foundPair at: 2) <=  (aPixel / aScale asFloat))
				ifTrue: [ foundPair at: 1 ] ifFalse: [ nil ] ].
]

{ #category : #accessing }
HgGraphicDocument >> graphics [
	^ graphics value asArray.
]

{ #category : #accessing }
HgGraphicDocument >> graphicsProperty [
	^ graphics
]

{ #category : #initialization }
HgGraphicDocument >> initialize [
	graphics := OrderedCollection new asValueHolder.
]

{ #category : #actions }
HgGraphicDocument >> installSampleGraphicsBounds: aWorldBounds [
	|  samples |
	samples := self createSampleGraphicsXmin: aWorldBounds origin x yMin: aWorldBounds origin y xMax: aWorldBounds corner x yMax: aWorldBounds corner y step: 1.0 / aWorldBounds width.
	self addCreateGraphicsUndoRecord: samples.
	self addGraphics: samples.
]

{ #category : #actions }
HgGraphicDocument >> installSampleGraphicsXmin: aXmin yMin: aYmin xMax: aXmax yMax: aYmax step: aStep [
	|  samples |
	samples := self createSampleGraphicsXmin: aXmin yMin: aYmin xMax: aXmax yMax: aYmax step: aStep.
	self addCreateGraphicsUndoRecord: samples.
	self addGraphics: samples.
]

{ #category : #initialization }
HgGraphicDocument >> loadGraphics [
	self appConfigFile isFile
		ifFalse: [ 
			^ self inform: 'File not found: ' , String cr , self appConfigFile asString ].
	self appConfigFile
		readStreamDo: [ :fs | 
			| xyDataArray |
			xyDataArray := (NeoCSVReader on: fs)
				addFloatField;
				addFloatField;
				upToEnd.
	self addGraphics: 
			(xyDataArray
				collect: [ :xyData | 
					HgPointGraphic new origin: ((xyData at: 1) @ (xyData at: 2)) ]) ]
]

{ #category : #'redo-undo' }
HgGraphicDocument >> redoCreateGraphic: aHgGraphic [
	self redoCreateGraphics: (Array with: aHgGraphic)
]

{ #category : #'redo-undo' }
HgGraphicDocument >> redoCreateGraphics: aHgGraphicCollection [
	self addGraphics: aHgGraphicCollection
]

{ #category : #'redo-undo' }
HgGraphicDocument >> redoDeleteSelection: aSelectedGraphics [
	self removeGraphics: aSelectedGraphics.
]

{ #category : #actions }
HgGraphicDocument >> removeAllGraphics [
	self graphicsProperty removeAll.
]

{ #category : #actions }
HgGraphicDocument >> removeGraphics: aGraphicCollection [ 
	self graphicsProperty removeAll: aGraphicCollection 
]

{ #category : #actions }
HgGraphicDocument >> selectGraphics: aGraphicCollection [
	self selectGraphics:  aGraphicCollection toSelectedState: true.
]

{ #category : #actions }
HgGraphicDocument >> selectGraphics: aGraphicCollection toSelectedState: aState [
	aGraphicCollection do: [ :each | each selected: aState ]
]

{ #category : #accessing }
HgGraphicDocument >> selectedGraphics [ 
	^ self graphics select: [ :graphic | graphic selected ]
]

{ #category : #'redo-undo' }
HgGraphicDocument >> undoCreateGraphic: aHgGraphic [ 
	self undoCreateGraphics: (Array with: aHgGraphic)
]

{ #category : #'redo-undo' }
HgGraphicDocument >> undoCreateGraphics: aHgGraphicCollection [ 
	self removeGraphics: aHgGraphicCollection
]

{ #category : #'redo-undo' }
HgGraphicDocument >> undoDeleteSelection: aSelectedGraphics [
	self addGraphics: aSelectedGraphics.
	self unselectGraphics: self graphics.
	self selectGraphics: aSelectedGraphics.
]

{ #category : #actions }
HgGraphicDocument >> unselectGraphics: aGraphicCollection [
	self selectGraphics:  aGraphicCollection toSelectedState: false.
]
