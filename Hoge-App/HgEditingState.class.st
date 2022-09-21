Class {
	#name : #HgEditingState,
	#superclass : #Object,
	#instVars : [
		'undoManager'
	],
	#category : #'Hoge-App'
}

{ #category : #'undo-redo' }
HgEditingState >> clearUndoManager: aKeyboardEvent [
	self undoManager reset.
	^ true
]

{ #category : #'undo-redo' }
HgEditingState >> redo [
	^ self undoManager redo 
]

{ #category : #'undo-redo' }
HgEditingState >> redoArray: doArray undoArray: undoArray [
	self undoManager isPlugged 
		ifTrue: [self undoManager redoArray: doArray undoArray: undoArray]
]

{ #category : #'undo-redo' }
HgEditingState >> undo [
	^ self undoManager undo 
]

{ #category : #accessing }
HgEditingState >> undoManager [
	^ undoManager ifNil: [ undoManager := HistoryIterator new].
]
