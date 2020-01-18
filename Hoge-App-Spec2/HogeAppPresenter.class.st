Class {
	#name : #HogeAppPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'graphicsView',
		'menuItemMap',
		'menuBar',
		'delegate',
		'graphicView',
		'statusBar'
	],
	#category : #'Hoge-App-Spec2'
}

{ #category : #specs }
HogeAppPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #menuBar height: self toolbarHeight;
		add: #graphicView;
		add: #statusBar height: HogeAppDelegate statusbarHeight;
		yourself
]

{ #category : #'menu items' }
HogeAppPresenter class >> hogeMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #Hoge2)
		order: 5.0;
		help: 'HogeApp(Spec2) open';
		action: [ self new openWithSpec ]
]

{ #category : #initialization }
HogeAppPresenter >> debugMenu [
	^ self newMenu
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Show configuration folder';
						action: [ delegate cmdShowAppConfigDir ] ] ] 
]

{ #category : #initialization }
HogeAppPresenter >> fileMenu [
	^ self newMenu
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					menuItemMap at: #settings put: item.
					item
						name: 'Settings...';
						action: [ 
							delegate cmdOpenSettings ] ] ]
]

{ #category : #'events handling' }
HogeAppPresenter >> graphicViewResized: anAnnouncement [
	self statusBar setSizeWH: graphicView morph extent.
]

{ #category : #initialization }
HogeAppPresenter >> initializeMenuBar [
	menuItemMap := Dictionary new.
	menuBar := self newMenuBar
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'File';
						subMenu: self fileMenu ].
			group
				addItem: [ :item | 
					item
						name: 'Debug';
						subMenu: self debugMenu ] ].
	menuBar applyTo: self
]

{ #category : #initialization }
HogeAppPresenter >> initializePresenter [
	graphicView morph announcer 
		when: #graphicViewResized send: #graphicViewResized: to: self .
	delegate graphicViewMorph announcer 
		when: MorphOpened do: [ delegate graphicViewMorph viewport resetPortCenter ].
	delegate document graphicsProperty 
		whenChangedSend: #clearOffCanvas to: delegate graphicViewMorph. 
	delegate document graphicsProperty 
		whenChangedSend: #changed to: delegate graphicViewMorph. 
	delegate document graphicsProperty 
		whenChangedDo: [ (menuItemMap at: #clear) enabled: delegate document graphics notEmpty ].
	self whenWindowChanged: [:w | w whenClosedDo: [ UIManager default inform: 'Bye bye!' ]  ]
]

{ #category : #initialization }
HogeAppPresenter >> initializeWidgets [ 
	delegate := HogeAppDelegate new.
	graphicView := self newMorph.
	graphicView morph: delegate graphicViewMorph.
	graphicView morph on: #mouseMove send: #updateMouseStatus: to: self.
	self initializeMenuBar.
	self focusOrder add: graphicView
]

{ #category : #initialization }
HogeAppPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		initialExtent: delegate initialExtent;
		title: delegate title.
]

{ #category : #accessing }
HogeAppPresenter >> statusBar [
	^ statusBar ifNil: [ statusBar := self instantiate:  HgStatusBar2 ]
]

{ #category : #initialization }
HogeAppPresenter >> updateMouseStatus: anEvent [
	| hvPoint xyPoint |
	hvPoint := anEvent cursorPoint.
	xyPoint := delegate graphicViewMorph viewport transform invertPoint: hvPoint.
	self statusBar setMouseXY: xyPoint.
	self statusBar setMouseHV: hvPoint.
]
