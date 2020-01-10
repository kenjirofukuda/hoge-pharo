Extension { #name : #OSPlatform }

{ #category : #'*Hoge-Extension' }
OSPlatform >> openPlatformFolder: aFileReference [
	| targetFolder |
	aFileReference ifNil: [ ^ self ].
	aFileReference exists
		ifFalse: [ ^ self ].
	targetFolder := aFileReference isFile
		ifTrue: [ aFileReference parent ]
		ifFalse: [ aFileReference ].
	self privateOpenPlatformFolder: targetFolder fullName .
]

{ #category : #'*Hoge-Extension' }
OSPlatform >> privateOpenPlatformFolder: folderPathString [
	self subclassResponsibility.

]

{ #category : #'*Hoge-Extension' }
OSPlatform >> shellReveal: aFileReference [
	self subclassResponsibility 
]

{ #category : #'*Hoge-Extension' }
OSPlatform >> userConfigDirectory [
	^ self subclassResponsibility 
]
