Class {
	#name : #HogeAppSettings,
	#superclass : #Object,
	#instVars : [
		'handleSize',
		'pointDisplaySize',
		'backgroundColor',
		'axisColor',
		'extentBoundsColor',
		'pointColor',
		'tempGraphicColor',
		'strokeColor'
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
	(aBuilder group: #Hoge) with: [ 
		(aBuilder range: #handleSize)
			target: self;
			targetSelector: #instance;
			default: 6;
			description: 'Selection marker size';
			label: 'Handle size';
			range: (6 to: 16 by: 2). "TODO: grouping"
		(aBuilder range: #pointDisplaySize)
			target: self;
			targetSelector: #instance;
			default: 4;
			description: 'Selection marker size';
			label: 'Point display size';
			range: (4 to: 16 by: 2). "TODO: grouping"
		self instance customSettingsOn: aBuilder ]
]

{ #category : #accessing }
HogeAppSettings >> axisColor [

	^ axisColor ifNil: [ axisColor := self defaultAxisColor  ]
]

{ #category : #accessing }
HogeAppSettings >> axisColor: anObject [

	axisColor := anObject
]

{ #category : #accessing }
HogeAppSettings >> backgroundColor [

	^ backgroundColor ifNil: [ 
		  backgroundColor := self defaultBackgroundColor ]
]

{ #category : #accessing }
HogeAppSettings >> backgroundColor: anObject [

	backgroundColor := anObject
]

{ #category : #settings }
HogeAppSettings >> customSettingsOn: aBuilder [
	(aBuilder setting: #backgroundColor)
		target: self;
		label: 'Background Color';
		default: self defaultBackgroundColor.
	(aBuilder setting: #axisColor)
		target: self;
		label: 'Axis Color';
		default: self defaultAxisColor.		
]

{ #category : #defaults }
HogeAppSettings >> defaultAxisColor [

	^ Color black
]

{ #category : #defaults }
HogeAppSettings >> defaultBackgroundColor [

	^ Color white
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
HogeAppSettings >> pointDisplaySize [
	^ pointDisplaySize ifNil: [ pointDisplaySize := 4 ].
]

{ #category : #accessing }
HogeAppSettings >> pointDisplaySize: anInteger [
	pointDisplaySize := anInteger
]
