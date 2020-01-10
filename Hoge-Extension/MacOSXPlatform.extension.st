Extension { #name : #MacOSXPlatform }

{ #category : #'*Hoge-Extension' }
MacOSXPlatform >> shellReveal: aFileReference [
	| url template |
	url := aFileReference asUrl asString.
	template := aFileReference isFile
		ifTrue: [ 'open -R "<1s>"' ]
		ifFalse: [ 'open "<1s>"' ].
	LibC system: (template expandMacrosWith: url)
]
