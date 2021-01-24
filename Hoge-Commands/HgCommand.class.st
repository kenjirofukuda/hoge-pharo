Class {
	#name : #HgCommand,
	#superclass : #CmCommand,
	#category : #'Hoge-Commands'
}

{ #category : #accessing }
HgCommand >> appDelegate [
	^ self context delegate
]

{ #category : #accessing }
HgCommand >> document [
	^ self appDelegate document
]
