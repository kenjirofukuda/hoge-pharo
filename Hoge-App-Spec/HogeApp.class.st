"
# HogeForm

i am pharo version of  kenjirofukuda/hoge (lazarus) of git.
"
Class {
	#name : #HogeApp,
	#superclass : #ComposableModel,
	#instVars : [
		'graphicView',
		'menuBar',
		'statusBar',
		'menuItemMap',
		'delegate'
	],
	#category : #'Hoge-App-Spec'
}

{ #category : #specs }
HogeApp class >> defaultSpec [
	<spec: #default>
	^ SpecLayout composed
		newColumn: [ :c | 
			c
				add: #menuBar height: self toolbarHeight;
				add: #graphicView;
				add: #statusBar height: HogeAppDelegate statusbarHeight ];
		yourself
]

{ #category : #'menu items' }
HogeApp class >> hogeMenuOn: aBuilder [ 
	<worldMenu>
	(aBuilder item: #Hoge)
		order: 5.0;
		help: 'HogeApp open';
		icon: HogeAppDelegate appIcon;
		action: [self open].
]

{ #category : #example }
HogeApp class >> open [
	<example>
	^ self new 
		windowIcon: HogeAppDelegate appIcon;
		openWithSpec.
]

{ #category : #api }
HogeApp class >> windowIcon [
	^ HogeAppDelegate appIcon 
]

{ #category : #commands }
HogeApp >> cmdToggleShowsAxisline: sender [
	delegate cmdToggleShowsAxisline.
	sender name: delegate nameForToggleShowsAxisline
]

{ #category : #commands }
HogeApp >> cmdToggleShowsExtentBounds: sender [
	delegate cmdToggleShowsExtentBounds.
	sender name: delegate nameForToggleShowsExtentBounds
]

{ #category : #'accessing menu' }
HogeApp >> debugMenu [
	^ MenuModel new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Show configuration folder';
						action: [ delegate cmdShowAppConfigDir ] ].
			group
				addItem: [ :item | 
					item
						name: delegate nameForToggleShowsAxisline;
						autoRefresh: true;
						action: [ self cmdToggleShowsAxisline: item ] ].
			group
				addItem: [ :item | 
					item
						name: delegate nameForToggleShowsExtentBounds;
						autoRefresh: true;
						action: [ self cmdToggleShowsExtentBounds: item ] ].
			group
				addItem: [ :item | 
					item
						name: 'Install sample graphics';
						action: [ delegate cmdInstallSampleGraphics ] ].
			group
				addItem: [ :item | 
					item
						name: 'Browse package';
						action: [ self class package browse ] ].
			group
				addItem: [ :item | 
					item
						name: 'Inspect document';
						action: [ delegate cmdInspectDocument ] ].
			self graphicView morph newCanvasEnabled
				ifTrue: [ 
					group
						addItem: [ :item | 
							item
								name: 'Toggle Canvas';
								action: [ delegate cmdToggleCanvas ] ] ] ]
]

{ #category : #'as yet unclassified' }
HogeApp >> delegate [
	^ delegate
]

{ #category : #accessing }
HogeApp >> document [
	^ delegate document
]

{ #category : #'accessing menu' }
HogeApp >> editMenu [
	^ MenuModel new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					menuItemMap at: #undo put: item.
					item
						name: 'Undo';
						shortcut: $z command;
						action: [ 
							delegate cmdUndo ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #redo put: item.
					item
						name: 'Redo';
						shortcut: $z shift command ;
						action: [ 
							delegate cmdRedo ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #clear put: item.
					item
						name: 'Clear';
						shortcut:Character backspace command;
						action: [ 
							delegate cmdClearGraphics ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #selectAll put: item.
					item
						name: 'Select All';
						shortcut: $a command ;
						action: [ 
							delegate cmdSelectAll ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #deselectAll put: item.
					item
						name: 'Deselect All';
						action: [ 
							delegate cmdDeselectAll ] ].
					 ]
]

{ #category : #'accessing menu' }
HogeApp >> fileMenu [
	^ MenuModel new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					menuItemMap at: #settings put: item.
					item
						name: 'Settings...';
						action: [ 
							delegate cmdOpenSettings ] ] ]
]

{ #category : #accessing }
HogeApp >> graphicView [
	^ graphicView
		ifNil: [ 
			graphicView := (delegate graphicViewMorph) asSpecAdapter
				color: Color white;
				vSpaceFill;
				hSpaceFill ]
]

{ #category : #'events handling' }
HogeApp >> graphicViewResized: anAnnouncement [
	self statusBar setSizeWH: graphicView morph extent.

]

{ #category : #api }
HogeApp >> initialExtent [
	^ delegate initialExtent
]

{ #category : #initialization }
HogeApp >> initializeMenuBar [
	menuItemMap := Dictionary new.
	menuBar := MenuModel new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'File';
						subMenu: self fileMenu ].
			group
				addItem: [ :item | 
					item
						name: 'Edit';
						subMenu: self editMenu ].
			group
				addItem: [ :item | 
					item
						name: 'Tools';
						subMenu: self toolsMenu ].
			group
				addItem: [ :item | 
					item
						name: 'View';
						subMenu: self viewMenu ].
			#HogeRoassal3Spec asClassIfPresent: [ :clazz | 
				group
				addItem: [ :item | 
					clazz new 
						perform: #specUI: with: self;
						perform: #installMenuOn: with: item  ].
				].
			
			group
				addItem: [ :item | 
					item
						name: 'Debug';
						subMenu: self debugMenu ] ].
	menuBar applyTo: self
]

{ #category : #initialization }
HogeApp >> initializePresenter [
	graphicView morph announcer 
		when: #graphicViewResized send: #graphicViewResized: to: self .
	graphicView morph announcer 
		when: MorphOpened do: [ graphicView morph viewport resetPortCenter ].
	self document graphicsProperty 
		whenChangedSend: #clearOffCanvas to: self graphicView morph. 
	self document graphicsProperty 
		whenChangedSend: #changed to: self graphicView morph. 
	self document graphicsProperty 
		whenChangedDo: [ (menuItemMap at: #clear) enabled: self document graphics notEmpty ].
	self whenWindowChanged: [:w | w whenClosedDo: [ UIManager default inform: 'Bye bye!' ]  ]
]

{ #category : #initialization }
HogeApp >> initializeWidgets [
   delegate := HogeAppDelegate new.
	self initializeMenuBar.
	graphicView := self graphicView.
	graphicView morph on: #mouseMove send: #updateMouseStatus: to: self.
	self focusOrder add: graphicView
]

{ #category : #'accessing menu' }
HogeApp >> menuBar [
	^ menuBar
]

{ #category : #accessing }
HogeApp >> statusBar [
	^ statusBar ifNil: [ statusBar := self instantiate:  HgStatusBar ]
]

{ #category : #api }
HogeApp >> title [
	^ delegate title, '(Spec)'
]

{ #category : #'accessing menu' }
HogeApp >> toolsMenu [
	^ MenuModel new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					menuItemMap at: #selectTool put: item.
					item
						name: 'Select';
						action: [ self graphicView morph toolClass: HgSelectTool ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #pointTool put: item.
					item
						name: 'Point';
						action: [ self graphicView morph toolClass: HgPointTool ] ] ]
]

{ #category : #initialization }
HogeApp >> updateMouseStatus: anEvent [
	| hvPoint xyPoint |
	hvPoint := anEvent cursorPoint.
	xyPoint := self graphicView morph viewport transform invertPoint: hvPoint.
	self statusBar setMouseXY: xyPoint.
	self statusBar setMouseHV: hvPoint.

]

{ #category : #'accessing menu' }
HogeApp >> viewMenu [
	^ MenuModel new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Fit';
						action: [ delegate cmdViewFit ] ] ]
]
