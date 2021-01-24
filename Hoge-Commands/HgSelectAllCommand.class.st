Class {
	#name : #HgSelectAllCommand,
	#superclass : #HgCommand,
	#category : #'Hoge-Commands'
}

{ #category : #converting }
HgSelectAllCommand >> asSpecCommand [
	^ super asSpecCommand
		shortcutKey: $a control;
		yourself
]

{ #category : #testing }
HgSelectAllCommand >> canBeExecuted [
	^ self document graphics notEmpty
]

{ #category : #executing }
HgSelectAllCommand >> execute [
	self document selectGraphics: self document graphics.
	self appDelegate graphicViewMorph forceRedraw.
	self context updateMenuBar
	
]

{ #category : #initialization }
HgSelectAllCommand >> initialize [
	super initialize.
	self name: 'Select All'.
	self description: 'select all graphics.'
]
