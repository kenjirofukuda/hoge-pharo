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
HogeRoassal3Spec >> cmdViewGraphics [
	| canvas |
	canvas := RSCanvas new.
	canvas extent: specUI graphicView extent.
	canvas camera position: specUI graphicView morph viewport viewCenter.
	self document graphics
		do: [ :m | 
			| e |
			e := RSEllipse new.
			e size: 4.
			e color: Color black.
			e position: m origin.
			canvas addShape: e ].
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
		#('RSCanvas' 'RSCamera' 'RSAthensMorph') do: [ :className |
			group
				addItem: [ :item | 
					item
						name: 'Browse ', className;
						action: [ specUI delegate cmdBrowseClass: className asClass ] ] ] 
	]
]
