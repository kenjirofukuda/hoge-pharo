Extension { #name : #OSPlatform }

{ #category : #'*Hoge-Extension' }
OSPlatform >> shellReveal: aFileReference [
	self subclassResponsibility 
]

{ #category : #'*Hoge-Extension' }
OSPlatform >> userConfigDirectory [
	^ self subclassResponsibility 
]
