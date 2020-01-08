Class {
	#name : #HgPointTool,
	#superclass : #HgSelectTool,
	#category : #Hoge
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
