Extension { #name : #HgGraphicViewMorph }

{ #category : #'*Hoge-App-Sparta' }
HgGraphicViewMorph >> drawAxisSpartaCanvasOn: aSpartaCanvas [
	| hvPoint path |
	hvPoint := self viewport xy2hv: 0 @ 0.
	path := aSpartaCanvas path
		moveTo: (hvPoint x @ 0);
		lineTo: (hvPoint x @ self extent y);
		moveTo: (0 @ hvPoint y);
		lineTo: (self extent x @ hvPoint y);
		finish. 
	aSpartaCanvas stroke 
		paint: Color black;
		path: path;
		draw.
]

{ #category : #'*Hoge-App-Sparta' }
HgGraphicViewMorph >> drawExtentBoundsSpartaCanvasOn: aSpartaCanvas [
	| xyBounds hvBounds |
	xyBounds := self document bounds.
	hvBounds := (self viewport xy2hv: xyBounds origin)
		corner: (self viewport xy2hv: xyBounds corner).
	aSpartaCanvas stroke
		paint: self extentBoundsColor;
		path: hvBounds;
		draw
]

{ #category : #'*Hoge-App-Sparta' }
HgGraphicViewMorph >> drawNewCanvasOn: aCanvas [
	| newCanvas |
	newCanvas := self spartaCanvasClass extent: self innerBounds extent.
	self drawSpartaCanvasOn: newCanvas.
	aCanvas drawImage: newCanvas asForm form at: 0 @ 0
]

{ #category : #'*Hoge-App-Sparta' }
HgGraphicViewMorph >> drawSpartaCanvasOn: aSpartaCanvas [
	aSpartaCanvas fill
		path: (0 @ 0 extent: aSpartaCanvas extent);
		paint: Color white;
		draw.
	self showAxisLines
		ifTrue: [ self drawAxisSpartaCanvasOn: aSpartaCanvas ].
	self document
		ifNotNil: [ :doc | 
			doc graphics do: [ :each | each drawSpartaCanvasOn: aSpartaCanvas viewport: self viewport ].
			self showExtentBounds
				ifTrue: [ self drawExtentBoundsSpartaCanvasOn: aSpartaCanvas ] ]
]

{ #category : #'*Hoge-App-Sparta' }
HgGraphicViewMorph >> lookupSpartaCanvasClass [
	| enabled |
	enabled := true.
	[ | t |
	t := MozCanvasFillTests new.
	[ t setUp.
	[ t testFillCanvasWhite ]
		on: Error
		do: [ enabled := false ] ]
		ensure: [ t tearDown.
			t cleanUpInstanceVariables ] ].
	^ enabled
		ifTrue: [ MozCanvas ]
		ifFalse: [ SpartaCairoCanvas ]
]

{ #category : #'*Hoge-App-Sparta' }
HgGraphicViewMorph >> spartaCanvasClass [
	^ spartaCanvasClass ifNil: [ spartaCanvasClass := self lookupSpartaCanvasClass ]
]
