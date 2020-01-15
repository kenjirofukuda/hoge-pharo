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
