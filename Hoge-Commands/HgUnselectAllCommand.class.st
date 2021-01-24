Class {
	#name : #HgUnselectAllCommand,
	#superclass : #HgCommand,
	#category : #'Hoge-Commands'
}

{ #category : #converting }
HgUnselectAllCommand >> asSpecCommand [
	^ super asSpecCommand
		shortcutKey: Character escape asKeyCombination;
		yourself
]

{ #category : #testing }
HgUnselectAllCommand >> canBeExecuted [
	^ self document selectedGraphics notEmpty
]

{ #category : #executing }
HgUnselectAllCommand >> execute [
	self document unselectGraphics: self document graphics.
	self appDelegate graphicViewMorph forceRedraw.
	
]

{ #category : #initialization }
HgUnselectAllCommand >> initialize [
	super initialize.
	self name: 'Unselect All'.
	self description: 'unselect all graphics.'
]
