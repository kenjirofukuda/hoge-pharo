Extension { #name : #HgPointGraphic }

{ #category : #'*Hoge-App-Sparta' }
HgPointGraphic >> drawSpartaCanvasOn: aSpartaCanvas viewport: aViewport [
	| hvPoint circle |
	hvPoint := aViewport xy2hv: self origin.
	self selected
		ifTrue: [ | halfHandle |
			halfHandle := self halfHandleSize asPoint.
			aSpartaCanvas fill
				paint: self handleColor;
				path: (self rectangleCenter: hvPoint handleHalfSize: halfHandle);
				draw ].
	circle := aSpartaCanvas shape circleAt: hvPoint radius: self pointDisplayHalfSize.
	aSpartaCanvas stroke
		paint: self strokeColor;
		path: circle;
		drawOptions:
			(aSpartaCanvas drawOptions
				alpha: 1.0;
				antialiasGray;
				"composeColorDodge;"
					yourself);
		draw
]
