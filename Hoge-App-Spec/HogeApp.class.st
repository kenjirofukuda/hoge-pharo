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
		'menuItemMap'
	],
	#classVars : [
		'AppIcon',
		'PngSaveDirectory'
	],
	#category : #'Hoge-App-Spec'
}

{ #category : #resources }
HogeApp class >> appIcon [
	^ AppIcon ifNil: [ AppIcon := self createAppIconForm  ]
]

{ #category : #private }
HogeApp class >> createAppIconForm [
	"https://freeicons.io/material-icons-device-2/wallpaper-icon-16295#"
 ^ (Form
	extent: (16@16)
	depth: 32
	fromArray: #( 2032016926 4129103133 4280098077 4280098077 4280098077 4280098077 3961330973 337254938 337254938 3961330973 4280098077 4280098077 4280098077 4280098077 4129103133 2015239710 4129103133 4112325917 2703039773 2568756252 2568756252 2568756252 2250054941 67108864 67108864 2250054941 2568756252 2568756252 2568756252 2703039773 4112325917 4129103133 4280098077 2719751196 0 0 0 0 0 0 0 0 0 0 0 0 2719751196 4280098077 4280098077 2568756252 0 0 0 0 0 0 0 0 0 0 0 0 2568756252 4280098077 4280098077 2568756252 0 0 0 0 0 0 0 689905439 3910933532 2870746140 0 0 2568756252 4280098077 4280098077 2568756252 0 0 0 0 0 0 0 1310530845 4280098077 3860667677 0 0 2568756252 4280098077 3961330973 2250054941 0 0 0 0 0 0 0 16777216 1310530845 656022042 0 0 2250054941 3944553757 337254938 67108864 0 0 0 0 0 0 0 0 0 0 0 0 67108864 337254938 337254938 67108864 0 0 0 0 0 0 0 0 0 0 0 0 67108864 337254938 3961330973 2250054941 0 0 0 824123167 3407682845 337254938 0 0 169482778 0 0 0 2250054941 3961330973 4280098077 2568756252 0 0 320543515 3726449949 4280098077 3273465117 87241523 1209801756 4045217053 639310619 0 0 2568756252 4280098077 4280098077 2568756252 0 67108864 3189644830 4280098077 4280098077 4280098077 2669485341 3927776541 4280098077 3424460061 119809060 0 2568756252 4280098077 4280098077 2568756252 0 840900383 3424460061 3424460061 3424460061 3424460061 3424460061 3424460061 3424460061 3424460061 958077723 0 2568756252 4280098077 4280098077 2719751196 0 0 0 0 0 0 0 0 0 0 0 0 2719751196 4280098077 4129103133 4112325917 2703039773 2568756252 2568756252 2568756252 2250054941 67108864 67108864 2250054941 2568756252 2568756252 2568756252 2703039773 4112325917 4112325917 2015239710 4129103133 4280098077 4280098077 4280098077 4280098077 3944553757 337254938 337254938 3944553757 4280098077 4280098077 4280098077 4280098077 4112325917 1998462494)
	offset: (0@0))
]

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

{ #category : #'menu items' }
HogeApp class >> hogeMenuOn: aBuilder [ 
	<worldMenu>
	(aBuilder item: #Hoge)
		order: 5.0;
		help: 'HogeApp open';
		icon: self appIcon;
		action: [self open].
]

{ #category : #example }
HogeApp class >> open [
	<example>
	^ self new 
		windowIcon: self appIcon;
		openWithSpec.
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

{ #category : #api }
HogeApp class >> windowIcon [
	^ self appIcon 
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

{ #category : #commands }
HogeApp >> cmdInspectDocument: sender [
	self document inspect
]

{ #category : #commands }
HogeApp >> cmdInstallSampleGraphics: sender [
	| worldBounds |
	worldBounds := self graphicView morph viewport worldViewBounds.
	self document installSampleGraphicsBounds: worldBounds
]

{ #category : #commands }
HogeApp >> cmdShowAppConfigDir: sender [
	OSPlatform current shellReveal: self document appConfigDirectory
]

{ #category : #commands }
HogeApp >> cmdToggleCanvas: sender [ 
	graphicView morph useNewCanvas: graphicView morph useNewCanvas not
]

{ #category : #commands }
HogeApp >> cmdToggleShowsAxisline: sender [
	self graphicView morph showAxisLines: self graphicView morph showAxisLines not.
	sender name: self nameForToggleShowsAxisline
]

{ #category : #commands }
HogeApp >> cmdToggleShowsExtentBounds: sender [
	self graphicView morph showExtentBounds: self graphicView morph showExtentBounds not.
	sender name: self nameForToggleShowsExtentBounds
]

{ #category : #'accessing menu' }
HogeApp >> debugMenu [
	^ MenuModel new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Show configuration folder';
						action: [ self cmdShowAppConfigDir: item ] ].
			group
				addItem: [ :item | 
					item
						name: self nameForToggleShowsAxisline;
						autoRefresh: true;
						action: [ self cmdToggleShowsAxisline: item ] ].
			group
				addItem: [ :item | 
					item
						name: self nameForToggleShowsExtentBounds;
						autoRefresh: true;
						action: [ self cmdToggleShowsExtentBounds: item ] ].
			group
				addItem: [ :item | 
					item
						name: 'Install sample graphics';
						action: [ self cmdInstallSampleGraphics: item ] ].
			group
				addItem: [ :item | 
					item
						name: 'Inspect document';
						action: [ self cmdInspectDocument: item ] ].
			self graphicView morph newCanvasEnabled
				ifTrue: [ 
					group
						addItem: [ :item | 
							item
								name: 'Toggle Canvas';
								action: [ self cmdToggleCanvas: item ] ] ] ]
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
		whenChangedDo: [ (menuItemMap at: #clear) enabled: self document graphics notEmpty ].
	self whenWindowChanged: [:w | w whenClosedDo: [ UIManager default inform: 'Bye bye!' ]  ]
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

{ #category : #'dynamic caption' }
HogeApp >> nameForToggleShowsAxisline [
	^ '<1s> Axis lines'
		expandMacrosWith:
			(self graphicView morph showAxisLines
				ifTrue: [ 'Hide' ]
				ifFalse: [ 'Show' ])
]

{ #category : #'dynamic caption' }
HogeApp >> nameForToggleShowsExtentBounds [
	^ '<1s> Extent bounds'
		expandMacrosWith:
			(self graphicView morph showExtentBounds
				ifTrue: [ 'Hide' ]
				ifFalse: [ 'Show' ])
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
