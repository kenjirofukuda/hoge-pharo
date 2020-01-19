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
	aRSCanvas camera position: self viewport viewCenter.
	aRSCanvas camera scale: self viewport viewScale.
]

{ #category : #'menu building' }
HogeRoassal3Spec >> cmdViewGraphics [
	| canvas updateBlock |
	self flag: 'TODO: Flip Vertiacal'. 
	canvas := RSCanvas new.
	self adjustViewportToCanvas: canvas.
	updateBlock := [ self adjustViewportToCanvas: canvas.
	(canvas shapes select: [ :e | e isKindOf: RSEllipse ])
		do: [ :e | 
			e size: e model handleSize / canvas camera scale.
			canvas signalUpdate ] ].
	self viewport announcer when: #viewTransformChanged do: updateBlock.
	self document graphics
		do: [ :m | 
			| e |
			e := RSEllipse new.
			e model: m.
			e size: m handleSize.
			e color: Color black.
			e position: m origin.
			canvas addShape: e ].
	canvas newAnimation
		duration: 0.1 seconds;
		onStepDo: [ :t | updateBlock value ].
	^ (canvas
		openBeforeMorphBlock: [ :morph | 
	morph changeNoLayout.
	morph extent: specUI graphicView extent ])
		setLabel: specUI title , '(Roassal3)';
		isResizeable: false;
		yourself
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
HogeRoassal3Spec >> viewport [ 
	^ specUI graphicView morph viewport.

]
