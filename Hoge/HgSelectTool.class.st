Class {
	#name : #HgSelectTool,
	#superclass : #KFViewTracking,
	#instVars : [
		'document'
	],
	#category : #Hoge
}

{ #category : #accessing }
HgSelectTool >> document [
	^ document
	
]

{ #category : #accessing }
HgSelectTool >> document: aDocument [
	document := aDocument.
	
]

{ #category : #accessing }
HgSelectTool >> lastWorldPoint [
	^ self viewport worldPointFromGlobal: points last.

]

{ #category : #'event handler' }
HgSelectTool >> noDragAction [
	| xyPoint |
	xyPoint := self lastWorldPoint.
	(self document findGraphicAt: xyPoint pixelDistance: 6 worldScale: self viewport viewScale)
		ifNotNil: [ :graphic | 
			graphic selected: graphic selected not.
			self view
				clearOffCanvas;
				changed	"TODO: fire event" ]
]
