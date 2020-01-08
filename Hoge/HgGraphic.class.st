Class {
	#name : #HgGraphic,
	#superclass : #Object,
	#instVars : [
		'selected'
	],
	#category : #Hoge
}

{ #category : #accessing }
HgGraphic >> bounds [
	^ 0 @ 0 corner: 0 @ 0
]

{ #category : #analisys }
HgGraphic >> distance: aPoint [
	^ Float maxExactInteger asPoint
]

{ #category : #drawing }
HgGraphic >> drawOn: aCanvas viewport: aViewport [

]

{ #category : #drawing }
HgGraphic >> drawSpartaCanvasOn: aSpartaCanvas viewport: aViewport [

]

{ #category : #drawing }
HgGraphic >> halfHandleSize [
	^ HogeAppSettings instance handleSize // 2.
]

{ #category : #accessing }
HgGraphic >> initialize [
	super initialize.
	selected := false.
]

{ #category : #drawing }
HgGraphic >> rectangleCenter: aCenterPoint handleHalfSize: aHandleHalfSize [
	| halfHandle |
	halfHandle := aHandleHalfSize asPoint.
	^ Rectangle 
		origin: aCenterPoint - halfHandle  corner: aCenterPoint + halfHandle
]

{ #category : #accessing }
HgGraphic >> selected [
  ^ selected
]

{ #category : #accessing }
HgGraphic >> selected: aBoolean [
	selected := aBoolean
]
