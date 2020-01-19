Class {
	#name : #HogeRoassal3Spec,
	#superclass : #Object,
	#instVars : [
		'specUI'
	],
	#category : #'Hoge-Roassal3'
}

{ #category : #'menu building' }
HogeRoassal3Spec >> adjustViewportToCanvas: aRSCanvas [
	aRSCanvas extent: self viewport extent.
	aRSCanvas camera zoomToFit: aRSCanvas extent rectangle: self viewport worldViewBounds.
]

{ #category : #'menu building' }
HogeRoassal3Spec >> cmdViewGraphics [
	HgRoassal3CanvasHolder new
		specUI: specUI;
		run
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
		do: [ :e | self setCosmetic: e ].
	aHgRSCanvas signalUpdate
]

{ #category : #'menu building' }
HogeRoassal3Spec >> viewport [ 
	^ specUI graphicView morph viewport.

]
