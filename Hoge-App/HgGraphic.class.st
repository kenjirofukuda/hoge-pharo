Class {
	#name : #HgGraphic,
	#superclass : #Object,
	#instVars : [
		'selected'
	],
	#category : #'Hoge-App'
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
HgGraphic >> halfHandleSize [
	^ self handleSize // 2.
]

{ #category : #drawing }
HgGraphic >> handleSize [
	^ HogeAppSettings instance handleSize
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
