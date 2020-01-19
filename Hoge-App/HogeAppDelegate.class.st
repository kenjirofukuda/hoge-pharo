"
Shared context for Spec and Spec.
"
Class {
	#name : #HogeAppDelegate,
	#superclass : #Object,
	#instVars : [
		'graphicViewMorph',
		'document'
	],
	#classVars : [
		'AppIcon',
		'PngSaveDirectory'
	],
	#category : #'Hoge-App'
}

{ #category : #resources }
HogeAppDelegate class >> appIcon [
	^ AppIcon ifNil: [ AppIcon := self createAppIconForm  ]
]

{ #category : #private }
HogeAppDelegate class >> createAppIconForm [
	"https://freeicons.io/material-icons-device-2/wallpaper-icon-16295#"
 ^ (Form
	extent: (16@16)
	depth: 32
	fromArray: #( 2032016926 4129103133 4280098077 4280098077 4280098077 4280098077 3961330973 337254938 337254938 3961330973 4280098077 4280098077 4280098077 4280098077 4129103133 2015239710 4129103133 4112325917 2703039773 2568756252 2568756252 2568756252 2250054941 67108864 67108864 2250054941 2568756252 2568756252 2568756252 2703039773 4112325917 4129103133 4280098077 2719751196 0 0 0 0 0 0 0 0 0 0 0 0 2719751196 4280098077 4280098077 2568756252 0 0 0 0 0 0 0 0 0 0 0 0 2568756252 4280098077 4280098077 2568756252 0 0 0 0 0 0 0 689905439 3910933532 2870746140 0 0 2568756252 4280098077 4280098077 2568756252 0 0 0 0 0 0 0 1310530845 4280098077 3860667677 0 0 2568756252 4280098077 3961330973 2250054941 0 0 0 0 0 0 0 16777216 1310530845 656022042 0 0 2250054941 3944553757 337254938 67108864 0 0 0 0 0 0 0 0 0 0 0 0 67108864 337254938 337254938 67108864 0 0 0 0 0 0 0 0 0 0 0 0 67108864 337254938 3961330973 2250054941 0 0 0 824123167 3407682845 337254938 0 0 169482778 0 0 0 2250054941 3961330973 4280098077 2568756252 0 0 320543515 3726449949 4280098077 3273465117 87241523 1209801756 4045217053 639310619 0 0 2568756252 4280098077 4280098077 2568756252 0 67108864 3189644830 4280098077 4280098077 4280098077 2669485341 3927776541 4280098077 3424460061 119809060 0 2568756252 4280098077 4280098077 2568756252 0 840900383 3424460061 3424460061 3424460061 3424460061 3424460061 3424460061 3424460061 3424460061 958077723 0 2568756252 4280098077 4280098077 2719751196 0 0 0 0 0 0 0 0 0 0 0 0 2719751196 4280098077 4129103133 4112325917 2703039773 2568756252 2568756252 2568756252 2250054941 67108864 67108864 2250054941 2568756252 2568756252 2568756252 2703039773 4112325917 4112325917 2015239710 4129103133 4280098077 4280098077 4280098077 4280098077 3944553757 337254938 337254938 3944553757 4280098077 4280098077 4280098077 4280098077 4112325917 1998462494)
	offset: (0@0))
]

{ #category : #'menu items' }
HogeAppDelegate class >> savePngMorph: aMorph [
	PNGReadWriter
		putForm: aMorph imageForm
		onFileNamed:
			(HogeAppSettings instance pngSaveDirectory asFileReference / (aMorph asString , '.png'))
				nextVersion
]

{ #category : #specs }
HogeAppDelegate class >> statusbarHeight [

	^ StandardFonts defaultFont height + 2
]

{ #category : #api }
HogeAppDelegate class >> windowIcon [
	^ self appIcon 
]

{ #category : #'menu items' }
HogeAppDelegate class >> windowMenuOn: aBuilder [
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
HogeAppDelegate >> cmdBrowseClass: aClass [
	aClass browse.
]

{ #category : #commands }
HogeAppDelegate >> cmdBrowsePackage [
	self class package browse
]

{ #category : #commands }
HogeAppDelegate >> cmdClearGraphics [
	self document addDeleteSelectionUndoRecord.
	self document removeGraphics: self document selectedGraphics
]

{ #category : #commands }
HogeAppDelegate >> cmdDeselectAll [
	self document unselectGraphics: self document graphics.
	self graphicViewMorph
		clearOffCanvas;
		changed	"TODO: event"
]

{ #category : #commands }
HogeAppDelegate >> cmdInspectDocument [
	self document inspect
]

{ #category : #commands }
HogeAppDelegate >> cmdInstallSampleGraphics [
	| worldBounds |
	worldBounds := self graphicViewMorph viewport worldViewBounds.
	self document installSampleGraphicsBounds: worldBounds
]

{ #category : #commands }
HogeAppDelegate >> cmdOpenSettings [
	SettingBrowser new
		changePackageSet: {self class package};
		open;
		expandAll
]

{ #category : #commands }
HogeAppDelegate >> cmdRedo [
	self editingState redo
]

{ #category : #commands }
HogeAppDelegate >> cmdSelectAll [
	self document selectGraphics: self document graphics.
	self graphicViewMorph
		clearOffCanvas;
		changed	"TODO: fire event"
]

{ #category : #commands }
HogeAppDelegate >> cmdShowAppConfigDir [
	OSPlatform current shellReveal: self document appConfigDirectory
]

{ #category : #commands }
HogeAppDelegate >> cmdToggleCanvas [
	graphicViewMorph useNewCanvas: graphicViewMorph useNewCanvas not
]

{ #category : #commands }
HogeAppDelegate >> cmdToggleShowsAxisline [
	self graphicViewMorph showAxisLines: self graphicViewMorph showAxisLines not.
]

{ #category : #commands }
HogeAppDelegate >> cmdToggleShowsExtentBounds [
	self graphicViewMorph showExtentBounds: self graphicViewMorph showExtentBounds not.
]

{ #category : #commands }
HogeAppDelegate >> cmdUndo [ 
	self editingState undo
]

{ #category : #commands }
HogeAppDelegate >> cmdViewFit [
	self graphicViewMorph fit
]

{ #category : #accessing }
HogeAppDelegate >> document [
	^ document value
]

{ #category : #accessing }
HogeAppDelegate >> document: aHgGraphicDocumenmt [
 	document value: aHgGraphicDocumenmt
]

{ #category : #accessing }
HogeAppDelegate >> editingState [
	^ self document editingState
]

{ #category : #accessing }
HogeAppDelegate >> graphicViewMorph [
	^ graphicViewMorph
		ifNil: [ 
			graphicViewMorph := HgGraphicViewMorph new
				borderWidth: 0;
				yourself ]
]

{ #category : #api }
HogeAppDelegate >> initialExtent [
	^ 800 @ 600
]

{ #category : #initialization }
HogeAppDelegate >> initialize [
   document := nil asValueHolder.
	self document: (HgGraphicDocument new loadGraphics; yourself).
	self graphicViewMorph document: self document.

]

{ #category : #'dynamic caption' }
HogeAppDelegate >> nameForToggleShowsAxisline [
	^ '<1s> Axis lines'
		expandMacrosWith:
			(self graphicViewMorph showAxisLines
				ifTrue: [ 'Hide' ]
				ifFalse: [ 'Show' ])
]

{ #category : #'dynamic caption' }
HogeAppDelegate >> nameForToggleShowsExtentBounds [
	^ '<1s> Extent bounds'
		expandMacrosWith:
			(self graphicViewMorph showExtentBounds
				ifTrue: [ 'Hide' ]
				ifFalse: [ 'Show' ])
]

{ #category : #api }
HogeAppDelegate >> title [
	^ 'Points View'
]
