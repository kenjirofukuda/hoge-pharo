Class {
	#name : #HogeAppPresenter,
	#superclass : #SpPresenter,
	#instVars : [
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
		"add: #menuBar height: self toolbarHeight;"
		add: #graphicView;
		"add: #statusBar height: HogeAppDelegate statusbarHeight;"
		yourself
]

{ #category : #'menu items' }
HogeAppPresenter class >> hogeMenuOn: aBuilder [
	<worldMenu>
	(aBuilder item: #Hoge)
		order: 5000;
		parent: #Tools;
		help: 'Hoge Application Spec 2.0';
		icon: HogeAppDelegate appIcon;
		action: [ self new openWithSpec ]
]

{ #category : #commands }
HogeAppPresenter >> cmdToggleShowsAxisline: sender [
	delegate cmdToggleShowsAxisline.
	sender name: delegate nameForToggleShowsAxisline
]

{ #category : #commands }
HogeAppPresenter >> cmdToggleShowsExtentBounds: sender [
	delegate cmdToggleShowsExtentBounds.
	sender name: delegate nameForToggleShowsExtentBounds
]

{ #category : #'accessing menu' }
HogeAppPresenter >> debugMenu [
	^ self newMenu
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
			delegate graphicViewMorph newCanvasEnabled
				ifTrue: [ 
					group
						addItem: [ :item | 
							item
								name: 'Toggle Canvas';
								action: [ delegate cmdToggleCanvas ] ] ] ]
]

{ #category : #accessing }
HogeAppPresenter >> delegate [
	^ delegate
]

{ #category : #'accessing menu' }
HogeAppPresenter >> editMenu [
	^ self newMenu
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					menuItemMap at: #undo put: item.
					item
						name: 'Undo';
						shortcut: $z command;
						action: [ delegate cmdUndo ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #redo put: item.
					item
						name: 'Redo';
						shortcut: $z shift command;
						action: [ delegate cmdRedo ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #clear put: item.
					item
						name: 'Clear';
						shortcut: Character backspace command;
						action: [ delegate cmdClearGraphics ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #selectAll put: item.
					item
						name: 'Select All';
						shortcut: $a command;
						action: [ delegate cmdSelectAll ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #deselectAll put: item.
					item
						name: 'Deselect All';
						action: [ delegate cmdDeselectAll ] ] ]
]

{ #category : #'accessing menu' }
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

{ #category : #accessing }
HogeAppPresenter >> graphicView [
	^ graphicView 
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
			#HogeRoassal3Spec2 asClassIfPresent: [ :clazz | 
				group
				addItem: [ :item | 
					clazz new 
						perform: #specUI: with: self;
						perform: #installMenuOn: with: item  ].
				].			group
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
		menu: menuBar;
		statusBar: statusBar; 
		title: delegate title.
]

{ #category : #accessing }
HogeAppPresenter >> statusBar [
	^ statusBar ifNil: [ statusBar := self instantiate:  HgStatusBar2 ]
]

{ #category : #'accessing menu' }
HogeAppPresenter >> toolsMenu [
	^ self newMenu
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					menuItemMap at: #selectTool put: item.
					item
						name: 'Select';
						action: [ delegate graphicViewMorph toolClass: HgSelectTool ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #pointTool put: item.
					item
						name: 'Point';
						action: [ delegate graphicViewMorph toolClass: HgPointTool ] ] ]
]

{ #category : #initialization }
HogeAppPresenter >> updateMouseStatus: anEvent [
	| hvPoint xyPoint |
	hvPoint := anEvent cursorPoint.
	xyPoint := delegate graphicViewMorph viewport transform invertPoint: hvPoint.
	self statusBar setMouseXY: xyPoint.
	self statusBar setMouseHV: hvPoint.
]

{ #category : #'accessing menu' }
HogeAppPresenter >> viewMenu [
	^ self newMenu
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Fit';
						action: [ delegate cmdViewFit ] ] ]
]
