Class {
	#name : #HgPointGraphic,
	#superclass : #HgGraphic,
	#instVars : [
		'origin'
	],
	#category : #'Hoge-App'
}

{ #category : #accessing }
HgPointGraphic >> bounds [
	^ self origin corner: self origin
]

{ #category : #analisys }
HgPointGraphic >> distance: aPoint [
	^ self origin distanceTo: aPoint
]

{ #category : #drawing }
HgPointGraphic >> drawOn: aCanvas viewport: aViewport [
	| hvPoint halfHandle halfPoint |
	hvPoint := aViewport xy2hv: self origin.
	halfHandle := self halfHandleSize asPoint.
	halfPoint := self pointDisplayHalfSize asPoint.
	self selected
		ifTrue: [ aCanvas fillRectangle: (self rectangleCenter: hvPoint handleHalfSize: halfHandle) color: self handleColor ].
	aCanvas frameOval: (hvPoint - halfPoint corner: hvPoint + halfPoint) color: self strokeColor
]

{ #category : #'drawing sparta' }
HgPointGraphic >> drawSpartaCanvasOn: aSpartaCanvas viewport: aViewport [
	"| hvPoint circle |
	hvPoint := aViewport xy2hv: self origin.
	self selected
		ifTrue: [ 
			| halfHandle |
			halfHandle := self halfHandleSize asPoint.
			aSpartaCanvas fill
				paint: self handleColor;
				path: (self rectangleCenter: hvPoint handleHalfSize: halfHandle);
				draw ].
	circle := aSpartaCanvas shape circleAt: hvPoint radius: self pointDisplayHalfSize.
	aSpartaCanvas stroke
		paint: self strokeColor;
		path: circle;
		draw"
]

{ #category : #drawing }
HgPointGraphic >> handleColor [
	^ Color blue
]

{ #category : #initialization }
HgPointGraphic >> initialize [
	super initialize.
	origin := (0 @ 0) asValueHolder
]

{ #category : #accessing }
HgPointGraphic >> origin [
	^ origin value
]

{ #category : #accessing }
HgPointGraphic >> origin: aPoint [
	origin value: aPoint
]

{ #category : #drawing }
HgPointGraphic >> pointDisplayHalfSize [
	^ HogeAppSettings instance pointDisplaySize // 2 
]

{ #category : #printing }
HgPointGraphic >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self origin printOn: aStream.
	aStream nextPut: $).
	
]

{ #category : #drawing }
HgPointGraphic >> strokeColor [
	^ Color black
]
