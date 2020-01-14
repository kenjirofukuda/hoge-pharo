Class {
	#name : #HgStatusBar,
	#superclass : #ComposableModel,
	#instVars : [
		'mouseXY',
		'mouseHV',
		'sizeWH'
	],
	#category : #'Hoge-App-Spec'
}

{ #category : #specs }
HgStatusBar class >> defaultSpec [
	<spec: #default>
	^ SpecRowLayout composed
		add: #mouseXY;
		add: #mouseHV;
		add: #sizeWH
]

{ #category : #example }
HgStatusBar class >> example [
	self new openWithSpec
]

{ #category : #initialization }
HgStatusBar >> initializeWidgets [
	mouseXY := self newLabel.
	mouseXY label: '[X: , Y: ]'.
	mouseHV := self newLabel.
	mouseHV label: '[H: , V: ]'.
	sizeWH := self newLabel.
	sizeWH label: '[W: , H: ]'
]

{ #category : #accessing }
HgStatusBar >> mouseHV [
	^ mouseHV
]

{ #category : #accessing }
HgStatusBar >> mouseXY [
	^ mouseXY
]

{ #category : #utility }
HgStatusBar >> pointString: aPoint label1: label1 label2: label2 [
	^ String
		streamContents: [ :s | 
			s nextPutAll: label1.
			s nextPutAll: ': '.
			s nextPutAll: (aPoint x asString padLeftTo: 5).
			s nextPutAll: ', '.
			s nextPutAll: label2.
			s nextPutAll: ': '.
			s nextPutAll: (aPoint y asString padLeftTo: 5)]
]

{ #category : #utility }
HgStatusBar >> pointString: aPoint label1: label1 label2: label2 decimalPlaces: anInteger [
	^ String
		streamContents: [ :s | 
			s nextPutAll: label1.
			s nextPutAll: ': '.
			s nextPutAll: (aPoint x printShowingDecimalPlaces: anInteger).
			s nextPutAll: ', '.
			s nextPutAll: label2.
			s nextPutAll: ': '.
			s nextPutAll: (aPoint y printShowingDecimalPlaces: anInteger) ]
]

{ #category : #accessing }
HgStatusBar >> setMouseHV: aPoint [
	self mouseHV label: (self pointString: aPoint label1: 'H' label2: 'V')
]

{ #category : #accessing }
HgStatusBar >> setMouseXY: aPoint [
	self mouseXY
		label:
			(self
				pointString: aPoint
				label1: 'X'
				label2: 'Y'
				decimalPlaces: 4)
]

{ #category : #accessing }
HgStatusBar >> setSizeWH: aPoint [
	self sizeWH label: (self pointString: aPoint label1: 'W' label2: 'H')
]

{ #category : #accessing }
HgStatusBar >> sizeWH [
	^ sizeWH
]
