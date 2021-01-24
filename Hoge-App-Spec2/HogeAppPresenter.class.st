Class {
	#name : #HogeAppPresenter,
	#superclass : #SpPresenter,
	#traits : 'SpTContextMenu',
	#classTraits : 'SpTContextMenu classTrait',
	#instVars : [
		'#menuItemMap',
		'#menuBar',
		'#delegate',
		'#graphicView',
		'#statusBar'
	],
	#category : #'Hoge-App-Spec2'
}

{ #category : #commands }
HogeAppPresenter class >> buildCommandsGroupWith: presenter forRoot: rootCommandGroup [
	rootCommandGroup
		register: (self buildMenuBarGroupWith: presenter)
]

{ #category : #commands }
HogeAppPresenter class >> buildMenuBarGroupWith: presenter [
	| menuBar |
	menuBar := (CmCommandGroup named: 'MenuBar') asSpecGroup.
	self menuBarLayout
		keysAndValuesDo: [ :menuName :commands | 
			| menu |
			menu := (CmCommandGroup named: menuName) asSpecGroup.
			commands do: [ :each | menu register: (each forSpec context: presenter)].
			menuBar register: menu ].
	menuBar beDisplayedAsGroup.
	^ menuBar
]

{ #category : #specs }
HogeAppPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		"add: #menuBar height: self toolbarHeight;"
		add: #graphicView;
		"add: #statusBar height: HogeAppDelegate statusbarHeight;"
		yourself
]

{ #category : #commands }
HogeAppPresenter class >> editCommands [
	^ { 
	HgDeleteGraphicsCommand.
	HgSelectAllCommand. 
	HgUnselectAllCommand.
	} 
]

{ #category : #commands }
HogeAppPresenter class >> fileCommands [
	^ { HgOpenSettings }
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
HogeAppPresenter class >> menuBarLayout [
	^ OrderedDictionary
		newFrom: {
			('File' -> self fileCommands).
			('Edit' -> self editCommands).
		}
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

{ #category : #'as yet unclassified' }
HogeAppPresenter >> contextMenuFromCommandsGroup: aValuable [
	self contextMenu: [ aValuable value beRoot asMenuPresenter ]
]

{ #category : #'accessing menu' }
HogeAppPresenter >> debugMenu [

	^ self newMenu addGroup: [ :group | 
		  group addItem: [ :item | 
			  item
				  name: 'Show configuration folder';
				  action: [ delegate cmdShowAppConfigDir ] ].
		  group addItem: [ :item | 
			  item
				  name: delegate nameForToggleShowsAxisline;
				  autoRefresh: true;
				  action: [ self cmdToggleShowsAxisline: item ] ].
		  group addItem: [ :item | 
			  item
				  name: delegate nameForToggleShowsExtentBounds;
				  autoRefresh: true;
				  action: [ self cmdToggleShowsExtentBounds: item ] ].
		  group addItem: [ :item | 
			  item
				  name: 'Install sample graphics';
				  action: [ delegate cmdInstallSampleGraphics ] ].
		  group addItem: [ :item | 
			  item
				  name: 'Browse package';
				  action: [ self class package browse ] ].
		  group addItem: [ :item | 
			  item
				  name: 'Inspect document';
				  action: [ delegate cmdInspectDocument ] ].

		  group addItem: [ :item | 
			  item
				  name: 'Inspect presenter';
				  action: [ self inspect ] ].

		  delegate graphicViewMorph newCanvasEnabled 
				ifTrue: [ 
			  		group addItem: [ :item | 
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
	| modifire |
	modifire := OSPlatform current defaultModifier.
	^ self newMenu
		addItem: [ :item | 
			menuItemMap at: #undo put: item.
			item
				name: 'Undo';
				shortcut: modifire + $z;
				action: [ delegate cmdUndo ] ];
		addItem: [ :item | 
			menuItemMap at: #redo put: item.
			item
				name: 'Redo';
				shortcut: modifire + $z shift;
				action: [ delegate cmdRedo ] ];
		addItem: [ :item | 
			menuItemMap at: #clear put: item.
			item
				name: 'Clear';
				shortcut: modifire + Character backspace;
				action: [ delegate cmdClearGraphics ] ];
		addItem: [ :item | 
			menuItemMap at: #selectAll put: item.
			item
				name: 'Select All';
				shortcut: modifire + $a;
				action: [ delegate cmdSelectAll ] ];
		addItem: [ :item | 
			menuItemMap at: #deselectAll put: item.
			item
				name: 'Deselect All';
				action: [ delegate cmdDeselectAll ] ];
		yourself
]

{ #category : #'accessing menu' }
HogeAppPresenter >> editMenu2 [
	| modifire |
	modifire := OSPlatform current defaultModifier.
	^ self newMenu
		addItem: [ :item | 
			menuItemMap at: #undo put: item.
			item
				name: 'Undo';
				shortcut: modifire + $z;
				action: [ delegate cmdUndo ] ];
		addItem: [ :item | 
			menuItemMap at: #redo put: item.
			item
				name: 'Redo';
				shortcut: modifire + $z shift;
				action: [ delegate cmdRedo ] ];
		addItem: [ :item | 
			menuItemMap at: #clear put: item.
			item
				name: 'Clear';
				shortcut: modifire + Character backspace;
				action: [ delegate cmdClearGraphics ] ];
		addItem: [ :item | 
			menuItemMap at: #selectAll put: item.
			item
				name: 'Select All';
				shortcut: modifire + $a;
				action: [ delegate cmdSelectAll ] ];
		addItem: [ :item | 
			menuItemMap at: #deselectAll put: item.
			item
				name: 'Deselect All';
				action: [ delegate cmdDeselectAll ] ];
		yourself
]

{ #category : #'accessing menu' }
HogeAppPresenter >> fileMenu [

	| modifire |
	modifire := OSPlatform current defaultModifier.
	^ self newMenu addGroup: [ :group | 
		  group addItem: [ :item | 
			  menuItemMap at: #settings put: item.
			  item
				  name: 'Settings...';
				  action: [ delegate cmdOpenSettings ].
			  [ item shortcut: modifire + $, ]
				  on: Error
				  do: [ self inform: 'Why ca''nt use $, short cut on Pharo 9.0 !!!'  ] ] ]
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
HogeAppPresenter >> initialize [
	super initialize.
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
						subMenu: self editMenu2 ].
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
	"self initializeMenuBar."
	menuBar := (self rootCommandsGroup / 'MenuBar' ) asMenuBarPresenter.
	self focusOrder add: graphicView
]

{ #category : #initialization }
HogeAppPresenter >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	self rootCommandsGroup installShortcutsIn: aWindowPresenter.
	aWindowPresenter
		initialExtent: delegate initialExtent;
		menu: self menuBar;
		statusBar: self statusBar; 
		title: delegate title.
]

{ #category : #accessing }
HogeAppPresenter >> menuBar [
	^ menuBar
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
HogeAppPresenter >> updateMenuBar [
	"Pharo 8.0 's SpCommand hasnt updateEnableStatus"
	menuBar := (self rootCommandsGroup / 'MenuBar' ) asMenuBarPresenter.
	self window menu: menuBar.

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
