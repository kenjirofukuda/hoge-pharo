Class {
	#name : #HogeRoassal3Spec,
	#superclass : #Object,
	#instVars : [
		'specUI'
	],
	#classVars : [
		'Instance'
	],
	#category : #'Hoge-Roassal3'
}

{ #category : #'as yet unclassified' }
HogeRoassal3Spec class >> instance [
	^ Instance ifNil: [ Instance := self new ].
]

{ #category : #'menu building' }
HogeRoassal3Spec >> adjustViewportToCanvas: aRSCanvas [
	aRSCanvas extent: self viewport extent.
	aRSCanvas camera zoomToFit: aRSCanvas extent rectangle: self viewport worldViewBounds.
]

{ #category : #'menu building' }
HogeRoassal3Spec >> cmdViewGraphics [
	| canvas createBlock wantsCreate window |
	canvas := HgRSCanvas new.
	self adjustViewportToCanvas: canvas.
	wantsCreate := true.
	self viewport announcer
		when: #viewTransformChanged
		do: [ self updateCanvas: canvas ].
	createBlock := [ canvas shapes copy do: #remove.
	self document graphics
		do: [ :m | 
			| e |
			e := RSEllipse new.
			e model: m.
			e withBorder.
			e size: m handleSize.
			e color: Color transparent.
			e position: m origin.
			canvas addShape: e ] ].
	self document graphicsProperty
		whenChangedDo: [ wantsCreate := true.
			self inform: 'Updated Graphics!!!', self identityHash printString].
	canvas newAnimation
		repeat;
		duration: 0.2 seconds;
		onStepDo: [ :t | 
			wantsCreate
				ifTrue: [ createBlock value.
					wantsCreate := false ].
			self updateCanvas: canvas ].
	window := canvas
		openBeforeMorphBlock: [ :morph | 
			morph changeNoLayout.
			morph extent: specUI graphicView extent ].
	window setLabel: specUI title , '(Roassal3), ', window identityHash printString.
	window isResizeable: false.
	window announcer
		when: WindowClosed
		do: [ self inform: 'FIXME: unsubscribe', window identityHash printString ].
	specUI window window announcer
		when: WindowClosed
		do: [ window delete ].
	^ window
]

{ #category : #'menu building' }
HogeRoassal3Spec >> document [
	^ specUI delegate document
]

{ #category : #'menu building' }
HogeRoassal3Spec >> installMenuOn: aMenuItemPresenter [ 
	aMenuItemPresenter
		name: 'Roassal3';
		subMenu: self subMenu.
		
]

{ #category : #'menu building' }
HogeRoassal3Spec >> setCosmetic: aRSShape [
	| scale |
	aRSShape canvas ifNil: [ ^ self ].
	scale := aRSShape canvas camera scale.
	aRSShape size: aRSShape model pointDisplaySize / scale.
	aRSShape border width: 1 / scale
]

{ #category : #accessing }
HogeRoassal3Spec >> specUI: aHogeApp [ 
	specUI := aHogeApp
]

{ #category : #'menu building' }
HogeRoassal3Spec >> subMenu [
	^ MenuModel new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'View Graphics';
						action: [ self cmdViewGraphics ] ].
			#('RSCanvas' 'RSCamera' 'RSAthensMorph')
				do: [ :className | 
					group
						addItem: [ :item | 
							item
								name: 'Browse ' , className;
								action: [ specUI delegate cmdBrowseClass: className asClass ] ]].
					group
						addItem: [ :item | 
							item
								name: 'Browse package';
								action: [ self class package browse ] ] ] 
]

{ #category : #'menu building' }
HogeRoassal3Spec >> updateCanvas: aHgRSCanvas [
self adjustViewportToCanvas: aHgRSCanvas.
	(aHgRSCanvas shapes select: [ :e | e model isKindOf: HgPointGraphic ])
		do: [ :e | 
			self setCosmetic: e.
			 ] .
	aHgRSCanvas signalUpdate
]

{ #category : #'menu building' }
HogeRoassal3Spec >> viewport [ 
	^ specUI graphicView morph viewport.

]
