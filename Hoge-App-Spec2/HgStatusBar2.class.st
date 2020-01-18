Class {
	#name : #HgStatusBar2,
	#superclass : #SpPresenter,
	#instVars : [
		'mouseXY',
		'mouseHV',
		'sizeWH'
	],
	#category : #'Hoge-App-Spec2'
}

{ #category : #specs }
HgStatusBar2 class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add: #mouseXY;
		add: #mouseHV;
		add: #sizeWH;
		yourself
]

{ #category : #example }
HgStatusBar2 class >> example [
	self new openWithSpec
]

{ #category : #initialization }
HgStatusBar2 >> initializeWidgets [
	mouseXY := self newLabel.
	mouseXY label: '[X: , Y: ]'.
	mouseHV := self newLabel.
	mouseHV label: '[H: , V: ]'.
	sizeWH := self newLabel.
	sizeWH label: '[W: , H: ]'
]

{ #category : #accessing }
HgStatusBar2 >> mouseHV [
	^ mouseHV
]

{ #category : #accessing }
HgStatusBar2 >> mouseXY [
	^ mouseXY
]

{ #category : #utility }
HgStatusBar2 >> pointString: aPoint label1: label1 label2: label2 [
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
HgStatusBar2 >> pointString: aPoint label1: label1 label2: label2 decimalPlaces: anInteger [
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
HgStatusBar2 >> setMouseHV: aPoint [
	self mouseHV label: (self pointString: aPoint label1: 'H' label2: 'V')
]

{ #category : #accessing }
HgStatusBar2 >> setMouseXY: aPoint [
	self mouseXY
		label:
			(self
				pointString: aPoint
				label1: 'X'
				label2: 'Y'
				decimalPlaces: 4)
]

{ #category : #accessing }
HgStatusBar2 >> setSizeWH: aPoint [
	self sizeWH label: (self pointString: aPoint label1: 'W' label2: 'H')
]

{ #category : #accessing }
HgStatusBar2 >> sizeWH [
	^ sizeWH
]
