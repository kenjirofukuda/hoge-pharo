Class {
	#name : #KFViewTracking,
	#superclass : #Object,
	#instVars : [
		'event',
		'currentEvent',
		'points'
	],
	#category : #'Hoge-Generic'
}

{ #category : #accessing }
KFViewTracking >> currentEvent: aMouseMoveEvent [ 
	currentEvent := aMouseMoveEvent.
	points add: currentEvent cursorPoint copy.
	self view fireFirstdrawing .
]

{ #category : #accessing }
KFViewTracking >> currentWorldPoint [
	^ self viewport worldPointFromGlobal: currentEvent cursorPoint. 

]

{ #category : #accessing }
KFViewTracking >> event: aMouseButtonEvent [ 
	event := aMouseButtonEvent.
	points add: event cursorPoint copy.
]

{ #category : #initialization }
KFViewTracking >> initialize [
	points := OrderedCollection new.
]

{ #category : #accessing }
KFViewTracking >> localPixelPoint [
	^ self viewport morphicPointFromGlobal: event cursorPoint
]

{ #category : #private }
KFViewTracking >> noDragAction [
	| menu |
	menu := MenuModel new
		addGroup: [ :group | 
			self setupMenu: group ].
	Cursor normal show.
	menu openWithSpecAt: event cursorPoint
]

{ #category : #accessing }
KFViewTracking >> offset [
	| p1 p2|
	p1 := self viewport worldPointFromGlobal: event cursorPoint. 
	p2 := self viewport worldPointFromGlobal: currentEvent cursorPoint. 
	^ p2 - p1.	
]

{ #category : #accessing }
KFViewTracking >> offsetPixelPoint [
	^ (currentEvent cursorPoint - event cursorPoint)
]

{ #category : #menu }
KFViewTracking >> setupEditorMenu: aMenuGroupModel [
	self structureMorph idNotEmpty
		ifTrue: [ 
			self setupIdSelectionMenu: aMenuGroupModel ].

]

{ #category : #menu }
KFViewTracking >> setupIdSelectionMenu: aMenuGroupModel [
	aMenuGroupModel
		addItem: [ :item | 
			item
				name: 'Fit selection' translated;
				action: [ self structureMorph viewport viewBounds: event handler structure dataExtentForIdElements ] ].
	aMenuGroupModel
		addItem: [ :item | 
			item
				name: 'Clear selection' translated;
				action: [ self structureMorph structure idSelection idClear ] ].
	aMenuGroupModel
		addItem: [ :item | 
			item
				name: 'Explore selection' translated;
				action: [ | elements |
					elements := self structureMorph structure idSelection elements.
					(elements size = 1 ifTrue: [ elements first ] ifFalse: [ elements ])
						explore.
					 ] ].
	aMenuGroupModel addItem: [ :item | item name: '-'].
	aMenuGroupModel
		addItem: [ :item | 
			item
				name: 'Delete' translated;
				action: [ self structureMorph structure idSelection idDelete ] ]
]

{ #category : #menu }
KFViewTracking >> setupMenu: aMenuGroupModel [
	aMenuGroupModel
		addItem: [ :item | 
			item
				name: 'Clear markers';
				action: [ self structureMorph clearMarker] ].
	aMenuGroupModel
		addItem: [ :item | 
			item
				name: 'Fit';
				shortcut: $f command;
				action: [ self viewport viewFit ] ].			
]

{ #category : #accessing }
KFViewTracking >> startWorldPoint [
	^ self viewport worldPointFromGlobal: event cursorPoint. 

]

{ #category : #'event handler' }
KFViewTracking >> trackEnd [
	points size = 1
		ifTrue: [ self noDragAction ]
]

{ #category : #accessing }
KFViewTracking >> view [
	^ event handler
]

{ #category : #'event handler' }
KFViewTracking >> viewMove [
	| p1 p2 lp1 lp2 |
	points size < 2 ifTrue: [ ^ self ].
	lp1 := points at: (points size - 1).
	lp2 := points last.
	p2 := self viewport worldPointFromGlobal: lp2.
	p1 := self viewport worldPointFromGlobal: lp1.
	self viewMoveFrom: p1 to: p2. 
]

{ #category : #private }
KFViewTracking >> viewMoveFrom: aPoint1 to: aPoint2 [
	self viewport viewCenter: (self viewport viewCenter - (aPoint2 - aPoint1)) .

]

{ #category : #private }
KFViewTracking >> viewport [
	^ self view viewport

]
