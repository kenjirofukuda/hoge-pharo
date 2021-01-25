Class {
	#name : #HgInspectCommand,
	#superclass : #HgCommand,
	#category : #'Hoge-Commands'
}

{ #category : #executing }
HgInspectCommand >> execute [
	self context inspect
]
