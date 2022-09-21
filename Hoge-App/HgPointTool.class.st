Class {
	#name : #HgPointTool,
	#superclass : #HgSelectTool,
	#category : #'Hoge-App'
}

{ #category : #'event handler' }
HgPointTool >> noDragAction [
	| newGraphic |
	newGraphic := HgPointGraphic new
		origin: self lastWorldPoint;
		yourself.
	self document addCreateGraphicUndoRecord: newGraphic.	
	self document addGraphic: newGraphic.
	
]
