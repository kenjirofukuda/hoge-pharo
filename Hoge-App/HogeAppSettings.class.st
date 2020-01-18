Class {
	#name : #HogeAppSettings,
	#superclass : #Object,
	#instVars : [
		'pngSaveDirectory',
		'handleSize',
		'pointDisplaySize'
	],
	#classVars : [
		'Instance'
	],
	#category : #'Hoge-App'
}

{ #category : #accessing }
HogeAppSettings class >> instance [
	^ Instance := Instance ifNil: [ self new ].
]

{ #category : #settings }
HogeAppSettings class >> settingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #Hoge)
		with: [ 
			(aBuilder setting: #pngSaveDirectory)
				type: #Directory;
				target: self;
				targetSelector: #instance;
				description: 'The path of a directory where png file';
				label: 'PNG Save directory'.	"TODO: move to KFImaging"
			(aBuilder range: #handleSize)
				target: self;
				targetSelector: #instance;
				default: 6;
				description: 'Selection marker size';
				label: 'Handle size';
				range: (6 to: 16 by: 2).	"TODO: grouping"
			(aBuilder range: #pointDisplaySize)
				target: self;
				targetSelector: #instance;
				default: 4;
				description: 'Selection marker size';
				label: 'Point display size';
				range: (4 to: 16 by: 2)	"TODO: grouping" ]
]

{ #category : #accessing }
HogeAppSettings >> handleSize [
	^ handleSize ifNil: [ handleSize := 4 ].
]

{ #category : #accessing }
HogeAppSettings >> handleSize: anInteger [
	handleSize := anInteger
]

{ #category : #accessing }
HogeAppSettings >> pngSaveDirectory [
	^ pngSaveDirectory ifNil: [
		pngSaveDirectory :=  FileSystem workingDirectory fullName].
]

{ #category : #accessing }
HogeAppSettings >> pngSaveDirectory: aFileReference [
	pngSaveDirectory := aFileReference
]

{ #category : #accessing }
HogeAppSettings >> pointDisplaySize [
	^ pointDisplaySize ifNil: [ pointDisplaySize := 4 ].
]

{ #category : #accessing }
HogeAppSettings >> pointDisplaySize: anInteger [
	pointDisplaySize := anInteger
]
