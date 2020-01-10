Extension { #name : #OSPlatform }

{ #category : #'*Hoge-Extension' }
OSPlatform >> userConfigDirectory [
	^ self subclassResponsibility 
]
