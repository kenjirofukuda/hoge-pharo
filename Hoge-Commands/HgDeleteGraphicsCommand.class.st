Class {
	#name : #HgDeleteGraphicsCommand,
	#superclass : #HgCommand,
	#category : #'Hoge-Commands'
}

{ #category : #converting }
HgDeleteGraphicsCommand >> asSpecCommand [
	^ super asSpecCommand
		shortcutKey: Character backspace asKeyCombination;
		yourself
]

{ #category : #testing }
HgDeleteGraphicsCommand >> canBeExecuted [
	^ self document selectedGraphics notEmpty
]

{ #category : #executing }
HgDeleteGraphicsCommand >> execute [
	self document addDeleteSelectionUndoRecord.
	self document removeGraphics: self document selectedGraphics.
	self context updateMenuBar

]

{ #category : #initialization }
HgDeleteGraphicsCommand >> initialize [
	super initialize.
	self name: 'Clear'.
	self description: 'Remove selected graphics.'
]
