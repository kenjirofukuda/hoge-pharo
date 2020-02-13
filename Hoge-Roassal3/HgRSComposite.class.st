Class {
	#name : #HgRSComposite,
	#superclass : #RSComposite,
	#category : #'Hoge-Roassal3'
}

{ #category : #printing }
HgRSComposite >> printOn: aStream [
	super printOn: aStream.
	self model
		ifNotNil: [ aStream nextPut: $(.
			aStream print: self model.
			aStream nextPut: $) ]
]
