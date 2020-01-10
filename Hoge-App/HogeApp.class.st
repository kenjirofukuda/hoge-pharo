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
		'document',
		'menuItemMap',
		'editingState'
	],
	#classVars : [
		'PngSaveDirectory'
	],
	#category : #'Hoge-App'
}

{ #category : #specs }
HogeApp class >> defaultSpec [
	<spec: #default>
	^ SpecLayout composed
		newColumn: [ :c | 
			c
				add: #menuBar height: self toolbarHeight;
				add: #graphicView;
				add: #statusBar height: self statusbarHeight ];
		yourself
]

{ #category : #example }
HogeApp class >> example [
	^ self new openWithSpec.
]

{ #category : #'menu items' }
HogeApp class >> hogeMenuOn: aBuilder [ 
	<worldMenu>
	(aBuilder item: #Hoge)
		order: 5.0;
		help: 'HogeApp open';
		action: [self example].
]

{ #category : #'menu items' }
HogeApp class >> savePngMorph: aMorph [
	PNGReadWriter
		putForm: aMorph imageForm
		onFileNamed:
			(HogeAppSettings instance pngSaveDirectory asFileReference / (aMorph asString , '.png'))
				nextVersion
]

{ #category : #settings }
HogeApp class >> settingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #Hoge)
		with: [ 
			(aBuilder setting: #pngSaveDirectory)
				type: #Directory;
				target: HogeAppSettings;
				targetSelector: #instance;
				description: 'The path of a directory where png file';
				label: 'PNG Save directory'.	"TODO: move to KFImaging"
			(aBuilder range: #handleSize)
				target: HogeAppSettings;
				targetSelector: #instance;
				default: 6;
				description: 'Selection marker size';
				label: 'Handle size';
				range: (6 to: 16 by: 2).	"TODO: grouping"
			(aBuilder range: #pointDisplaySize)
				target: HogeAppSettings;
				targetSelector: #instance;
				default: 4;
				description: 'Selection marker size';
				label: 'Point display size';
				range: (4 to: 16 by: 2)	"TODO: grouping" ]
]

{ #category : #specs }
HogeApp class >> statusbarHeight [

	^ StandardFonts defaultFont height + 2
]

{ #category : #'menu items' }
HogeApp class >> windowMenuOn: aBuilder [
	"Window Shot utility"

	<windowMenu>
	(HogeAppSettings instance pngSaveDirectory asString asFileReference isDirectory)
		ifTrue: [ 
			(aBuilder item: #'Save As PNG')
				action: [ self savePngMorph: aBuilder model ];
				iconName: #image;
				order: 300;
				withSeparatorAfter ]
]

{ #category : #'accessing menu' }
HogeApp >> debugMenu [
	^ MenuModel new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Show AppConfigDir';
						action: [ OSPlatform current shellReveal: self document appConfigDirectory ] ].
			group
				addItem: [ :item | 
					item
						name: 'Show Axis line';
						action: [ self graphicView morph showAxisLines: self graphicView morph showAxisLines not ] ].
			group
				addItem: [ :item | 
					item
						name: 'Show Extent bounds';
						action: [ self graphicView morph showExtentBounds: self graphicView morph showExtentBounds not ] ].
			group
				addItem: [ :item | 
					item
						name: 'Install sample graphics';
						action: [ | worldBounds |
							worldBounds := self graphicView morph viewport worldViewBounds.
							self document installSampleGraphicsBounds: worldBounds ] ].
			self graphicView morph newCanvasEnabled
				ifTrue: [ group
						addItem: [ :item | 
							item
								name: 'Toggle Canvas';
								action: [ graphicView morph useNewCanvas: graphicView morph useNewCanvas not ] ] ] ]
]

{ #category : #accessing }
HogeApp >> document [
	^ document value
]

{ #category : #accessing }
HogeApp >> document: aHgGraphicDocumenmt [
 	document value: aHgGraphicDocumenmt
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
							self editingState undo ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #redo put: item.
					item
						name: 'Redo';
						shortcut: $z shift command ;
						action: [ 
							self editingState redo ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #clear put: item.
					item
						name: 'Clear';
						shortcut:Character backspace command;
						action: [ 
							self document addDeleteSelectionUndoRecord.
							self document removeGraphics: self document selectedGraphics ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #selectAll put: item.
					item
						name: 'Select All';
						shortcut: $a command ;
						action: [ 
							self document selectGraphics: self document graphics.
							self graphicView morph clearOffCanvas; changed. "TODO: fire event" ] ].
			group
				addItem: [ :item | 
					menuItemMap at: #deselectAll put: item.
					item
						name: 'Deselect All';
						action: [ 
							self document unselectGraphics: self document graphics.
							self graphicView morph clearOffCanvas; changed. "TODO: event"  ] ].
					 ]
]

{ #category : #accessing }
HogeApp >> editingState [
	^ self document editingState
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
							SettingBrowser new
								changePackageSet: {self class package};
								open;
								expandAll ] ] ]
]

{ #category : #accessing }
HogeApp >> graphicView [
	^ graphicView
		ifNil: [ 
			graphicView := (HgGraphicViewMorph new
				borderWidth: 0;
				yourself) asSpecAdapter
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
	^ 800 @ 600
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
		whenChangedDo: [ (menuItemMap at: #clear) enabled: self document graphics notEmpty ]
]

{ #category : #initialization }
HogeApp >> initializeWidgets [
   document := nil asValueHolder.
	self initializeMenuBar.
	self document: (HgGraphicDocument new loadGraphics; yourself).
	graphicView := self graphicView.
	graphicView morph on: #mouseMove send: #updateMouseStatus: to: self.
	graphicView morph document: self document.
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
	^ 'Points View'
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
						action: [ self graphicView morph fit ] ] ]
]
